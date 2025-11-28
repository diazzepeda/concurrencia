class Comprobante < ApplicationRecord
  before_create :asignar_fecha

  def save!
    transaction do
      super()
    end
  end

def asignar_numero
  return if num_comp_pago.present?

  attempts = 0
  loop do
    attempts += 1
    locked = self.class.connection.select_value(
      "SELECT pg_try_advisory_xact_lock(#{1})"
    )

    if locked
      max = self.class.maximum(:num_comp_pago) || 0
      raise if max == 3
      self.num_comp_pago = max + 1
      break
    else
      raise "No se pudo obtener lock después de 5 intentos" if attempts >= 5
      sleep(0.05)
    end
  end
end

  private

  def asignar_fecha
    self.fecha = Time.zone.now
  end

end
