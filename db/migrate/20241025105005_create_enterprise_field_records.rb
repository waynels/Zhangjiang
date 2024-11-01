class CreateEnterpriseFieldRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :enterprise_field_records, id: :uuid, default: -> { "uuid_generate_v4()" }   do |t|
      t.string :record_id, index: true
      t.string :table_id
      t.string :batch, index: true
      t.string :code, index: true
      t.string :name
      t.jsonb :base_fields
      t.datetime :batch_updated_at
      t.string :acknowledgment

      t.timestamps
    end
  end
end
