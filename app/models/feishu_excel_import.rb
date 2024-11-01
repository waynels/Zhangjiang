class FeishuExcelImport < ApplicationRecord
  enum enterprise_status: { pending: 0, success: 1, failed: 99 }, _prefix: :enterprise
  enum graph_status: { pending: 0, success: 1, failed: 99 }, _prefix: :graph
  enum innovation_status: { pending: 0, success: 1, failed: 99 }, _prefix: :innovation
  enum product_status: { pending: 0, success: 1, failed: 99 }, _prefix: :product
  enum round_status: { pending: 0, success: 1, failed: 99 }, _prefix: :round
  enum talent_status: { pending: 0, success: 1, failed: 99 }, _prefix: :talent
  enum trend_status: { pending: 0, success: 1, failed: 99 }, _prefix: :trend

  mount_uploader :file, ExcelUploader
  after_create_commit :begin_import_job


  def begin_import_job
    file_path = excel_path
    EnterpriseImportJob.perform_later(id, file_path)
    TalentImportJob.perform_later(id, file_path)
    RoundImportJob.perform_later(id, file_path)
    ProductImportJob.perform_later(id, file_path)
    TrendImportJob.perform_later(id, file_path)
    InnovationImportJob.perform_later(id, file_path)
    GraphImportJob.perform_later(id, file_path)
  end

  def excel_path
    if Rails.env.development?
      file.path
    else
      Rails.root.join("public/#{file.path}")
    end
  end
end

# == Schema Information
#
# Table name: feishu_excel_imports
#
#  id                :uuid             not null, primary key
#  enterprise_status :integer          default("pending")
#  file              :string
#  graph_status      :integer          default("pending")
#  innovation_status :integer          default("pending")
#  product_status    :integer          default("pending")
#  remark            :text
#  round_status      :integer          default("pending")
#  talent_status     :integer          default("pending")
#  trend_status      :integer          default("pending")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
