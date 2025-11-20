class Documento < ApplicationRecord
  before_create :asignar_numero

  def asignar_numero
    if true
      puts "Usando método con_lock!"
      self.numero ||= Documento.con_lock!
    elsif false
      puts "Usando método con_tabla_de_secuencias!"
      self.numero ||= Documento.con_tabla_de_secuencias!
    elsif false
      puts "Usando método con_contadores_atomicos!"
      self.numero ||= Documento.con_contadores_atomicos!
    else
      puts "Usando número por defecto: 1"
      self.numero ||= Documento.maximum(:numero).to_i + 1
    end
  end

  def self.con_lock!
    Documento.transaction do
      ultimo_documento = Documento.lock("FOR UPDATE").order(numero: :desc).first
      nuevo_numero = ultimo_documento ? ultimo_documento.numero + 1 : 1

      nuevo_numero
    end
  end

  def self.con_tabla_de_secuencias!
    connection.transaction do
      seq = connection.select_one("SELECT sequence_numero FROM sequences FOR UPDATE")
      last = seq["sequence_numero"].to_i
      max_db = Documento.maximum(:numero) || 0
      next_num = [ last, max_db ].max + 1
      connection.update("UPDATE sequences SET sequence_numero = #{next_num}")

      next_num
    end
  end

  def self.con_contadores_atomicos!
    ApplicationRecord.connection.execute("SELECT nextval('documento_num_seq')").first['nextval']
  end
end
