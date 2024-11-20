class MacroSendJob < ApplicationJob
  queue_as :default

  def perform(record_id)
    record = ::MacroFieldRecord.find(record_id)
    server = ::ZhangJiangService.new(ENV['ZHANGJIANG_USERID'], ENV['ZHANGJIANG_SECRET'])
    result = server.macro(record.id)
    if result.present?
      record.update(acknowledgment: result['data']['acknowledgment'], batch_updated_at: Time.new)
    end
  end
end
