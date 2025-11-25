class Comprobante < ApplicationRecord
  before_create :asignar_numero

  def save!
    transaction do
      super()
    end
  end

  private

  def asignar_numero
    self.fecha = Time.zone.now
    self.class.connection.execute("SELECT pg_advisory_xact_lock(1)")
    max = self.class.where(
      tipo_comprobante_pago_id: tipo_comprobante_pago_id,
      tipo_comprobante_id: tipo_comprobante_id
    ).maximum(:num_comp_pago) || 0

    self.num_comp_pago = max + 1
  end
end
