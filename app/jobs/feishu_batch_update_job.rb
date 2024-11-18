class FeishuBatchUpdateJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = ::IndustryAnalysisTask.find(task_id)

    server = ::FeishuExcelService.new(ENV['FEISHU_TENANT_APPID'], ENV['FEISHU_TENANT_SECRET_KEY'])
    record_ids = task.record_ids
    records = { records: record_ids.map {|record_id| {"record_id": record_id, "fields":{ "acknowledgment": task.acknowledgment, "清湛更新返回时间": task.updated_at}}}}
    response = server.batch_update('M4k6bcg6JaRMX4sjPQ5cij9EnQc', task.table_id, records.to_json)
    if response.code.to_i == 200
      Sidekiq.logger.info "FeishuBatchUpdateJob: success"
    else
      Sidekiq.logger.info "FeishuBatchUpdateJob: error #{JSON.parse(response.body)}"
    end
  end
end
