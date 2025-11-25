class CreateComprobantes < ActiveRecord::Migration[8.0]
  def change
    create_table :comprobantes do |t|
      t.integer :tipo_comprobante_pago_id
      t.integer :tipo_comprobante_id
      t.integer :num_comp_diario
      t.integer :num_comp_pago
      t.integer :num_comp_egreso
      t.integer :num_comp_deposito
      t.integer :num_comp_depreciacion
      t.integer :num_comp_diferencial_cambiario
      t.datetime :fecha
    end
  end
end
