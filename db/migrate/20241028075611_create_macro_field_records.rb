class CreateMacroFieldRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :macro_field_records, id: :uuid, default: -> { "uuid_generate_v4()" }   do |t|
      t.string :record_id, index: true
      t.string :table_id
      t.string :batch, index: true
      t.string :file
      t.integer :sector, default: 1
      t.string :title
      t.string :source
      t.string :author
      t.datetime :publishDate
      t.datetime :batch_updated_at
      t.string :acknowledgment
      t.timestamps
    end
  end
end
