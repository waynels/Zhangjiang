class IndustryAnalysisSendJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task_job = IndustryAnalysisTask.find(task_id)
    server = ::ZhangJiangService.new(ENV['ZHANGJIANG_USERID'], ENV['ZHANGJIANG_SECRET'])
    result = server.public_send(task_job.api_method, task_job.data.to_json )
    if result.present?
      task_job.update(send_status: 'finished', acknowledgment: result['data']['acknowledgment'])
    else
      task_job.update(send_status: 'failed')
    end
  end
end
