class CreateIndustryAnalysisTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :industry_analysis_tasks, id: :uuid, default: -> { "uuid_generate_v4()" } do |t|
      t.string :batch
      t.string :api_method, default: 'enterprise_info'
      t.jsonb :data
      t.string :send_status, default: 'pending'
      t.string :acknowledgment

      t.timestamps
    end
  end
end
