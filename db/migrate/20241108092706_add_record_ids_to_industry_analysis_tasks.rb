class AddRecordIdsToIndustryAnalysisTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :industry_analysis_tasks, :record_ids, :jsonb
    add_column :industry_analysis_tasks, :table_id, :string
  end
end
