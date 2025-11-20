class CreateSequences < ActiveRecord::Migration[8.0]
  def change
    create_table :sequences do |t|
      t.bigint :sequence_numero, null: false, default: 0
    end
  end
end
