class CreateTableSheets < ActiveRecord::Migration[6.1]
  def change
    create_table :table_sheets, id: :uuid, default: -> { "uuid_generate_v4()" }  do |t|
      t.string :name
      t.string :table_id
      t.string :format_fields, array: true, default: []

      t.timestamps
    end
  end
end
