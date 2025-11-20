class CrearSecuenciaDocumento < ActiveRecord::Migration[8.0]
def up
    execute <<-SQL
      CREATE SEQUENCE documento_num_seq START 1;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE IF EXISTS documento_num_seq;
    SQL
  end
end
