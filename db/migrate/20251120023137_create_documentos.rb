class CreateDocumentos < ActiveRecord::Migration[8.0]
  def change
    create_table :documentos do |t|
      t.integer :numero

      t.timestamps
    end
  end
end
