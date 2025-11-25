class CrearTrigger < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE OR REPLACE FUNCTION obtener_siguiente_consecutivo(pr_tipo_comprobante_pago_id int)
      RETURNS INT AS $$
      DECLARE
          v_reinicio INT;
          v_max INT;
      BEGIN
          SELECT e.periodo_comp_pago_id
          INTO v_reinicio
          FROM empresas e;

          -- Prevenir colisiones por concurrencia
          PERFORM pg_advisory_xact_lock(pr_tipo_comprobante_pago_id);

          IF v_reinicio = 1 THEN
              SELECT COALESCE(MAX(num_comp_pago), 0)
              INTO v_max
              FROM comprobantes
              WHERE tipo_comprobante_pago_id = pr_tipo_comprobante_pago_id
                AND DATE_TRUNC('month', fecha) = DATE_TRUNC('month', CURRENT_DATE);

          ELSIF v_reinicio = 2 THEN
              SELECT COALESCE(MAX(num_comp_pago), 0)
              INTO v_max
              FROM comprobantes
              WHERE tipo_comprobante_pago_id = pr_tipo_comprobante_pago_id
                AND DATE_TRUNC('year', fecha) = DATE_TRUNC('year', CURRENT_DATE);

          ELSE
              SELECT COALESCE(MAX(num_comp_pago), 0)
              INTO v_max
              FROM comprobantes
              WHERE tipo_comprobante_pago_id = pr_tipo_comprobante_pago_id;
          END IF;

          RETURN v_max + 1;
      END;
      $$ LANGUAGE plpgsql;


      CREATE OR REPLACE FUNCTION trg_asignar_consecutivo()
      RETURNS TRIGGER AS $$
      BEGIN
          IF NEW.num_comp_pago IS NULL OR NEW.num_comp_pago = 0 THEN
              NEW.num_comp_pago := obtener_siguiente_consecutivo(NEW.tipo_comprobante_pago_id);
          END IF;

          RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;


      CREATE TRIGGER asignar_consecutivo_before_insert
      BEFORE INSERT ON comprobantes
      FOR EACH ROW
      EXECUTE FUNCTION trg_asignar_consecutivo();

    SQL
  end

  def down
    execute <<~SQL
      DROP TRIGGER IF EXISTS asignar_consecutivo_before_insert ON comprobantes;
      DROP FUNCTION IF EXISTS trg_asignar_consecutivo();
      DROP FUNCTION IF EXISTS obtener_siguiente_consecutivo(int);
    SQL
  end
end
