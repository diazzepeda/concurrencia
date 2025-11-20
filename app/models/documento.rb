class Documento < ApplicationRecord
  before_create :asignar_numero

  def asignar_numero
    Documento.transaction do
      max_numero = Documento.lock.maximum(:numero) || 0
      self.numero = max_numero + 1
    end
  end
end
