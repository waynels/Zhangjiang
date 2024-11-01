class CreateFeishuExcelImports < ActiveRecord::Migration[6.1]
  def change
    create_table :feishu_excel_imports, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :file
      t.integer :enterprise_status, default: 0
      t.integer :talent_status, default: 0
      t.integer :round_status, default: 0
      t.integer :trend_status, default: 0
      t.integer :innovation_status, default: 0
      t.integer :graph_status, default: 0
      t.integer :product_status, default: 0
      t.text :remark
      t.timestamps
    end
  end
end
