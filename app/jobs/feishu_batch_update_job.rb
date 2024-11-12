class FeishuBatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = ::IndustryAnalysisTask.find(task_id)

    server = ::FeishuExcelService.new(ENV['FEISHU_TENANT_APPID'], ENV['FEISHU_TENANT_SECRET_KEY'])
    record_ids = task.record_ids
    records = { records: record_ids.map {|record_id| {"record_id": record_id, "fields":{ "acknowledgment": task.acknowledgment}}}}
    server.batch_update('M4k6bcg6JaRMX4sjPQ5cij9EnQc', task.table_id, records.to_json)
  end
end
