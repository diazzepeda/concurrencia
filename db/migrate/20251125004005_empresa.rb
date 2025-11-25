class Empresa < ActiveRecord::Migration[8.0]
  def change
    create_table :empresas do |t|
      t.integer :periodo_comp_pago_id
      t.integer :num_periodo_inicio_pago
    end
  end
end
