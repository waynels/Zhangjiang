class MacroFieldRecord < ApplicationRecord
  mount_uploader :file, PdfUploader
  enum sector: { ai: 1 }

  after_create_commit :send_data_to_zhangjiang

  def send_data_to_zhangjiang
    ::MacroSendJob.perform_later(id)
    # server = ::ZhangJiangService.new(ENV['ZHANGJIANG_USERID'], ENV['ZHANGJIANG_SECRET'])
    # result = server.macro(id)
    # if result.present?
    #   update(acknowledgment: result['data']['acknowledgment'], batch_updated_at: Time.new)
    # end
  end

  after_commit if: :saved_change_to_file? do
    ::MacroSendJob.perform_later(id)
  end

  def body_parts
    boundary = "----WebKitFormBoundary#{SecureRandom.hex(16)}"
    data = []
    # 添加文件部分
    file_path = file.path
    file = File.open(file_path, 'rb')
    data << "--#{boundary}\r\n"
    data << "Content-Disposition: form-data; name=\"file\"; filename=\"#{File.basename(file_path)}\"\r\n"
    data << "Content-Type: application/pdf\r\n\r\n"
    data << file.read.force_encoding('UTF-8')
    data << "\r\n"
    file.close

    # 添加其他表单数据部分
    other_data = [
      { name: "sector", value: "人工智能" },
      { name: "batch", value: batch },
      { name: "title", value: title },
      { name: "source", value: source },
      { name: "author", value: author},
      { name: "publishDate", value: publishDate.strftime("%Y-%m-%d") }
    ]
    other_data.each do |item|
      data << "--#{boundary}\r\n"
      data << "Content-Disposition: form-data; name=\"#{item[:name]}\"\r\n\r\n"
      data << "#{item[:value]}\r\n"
    end
    data << "--#{boundary}--\r\n"
    [boundary, data.join]
  end

  def form_data
    { file: Faraday::UploadIO.new(file.path, 'application/pdf'), sector: "人工智能", batch: batch, title: title, source: source, author: author, publishDate: publishDate.strftime("%Y-%m-%d") }
  end

  def data_form
    { file: File.new(file.path, 'rb'), sector: "人工智能", batch: batch, title: title, source: source, author: author, publishDate: publishDate.strftime("%Y-%m-%d") }
  end
end

# == Schema Information
#
# Table name: macro_field_records
#
#  id               :uuid             not null, primary key
#  acknowledgment   :string
#  author           :string
#  batch            :string
#  batch_updated_at :datetime
#  file             :string
#  publishDate      :datetime
#  sector           :integer          default("ai")
#  source           :string
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  record_id        :string
#  table_id         :string
#
# Indexes
#
#  index_macro_field_records_on_batch      (batch)
#  index_macro_field_records_on_record_id  (record_id)
#
