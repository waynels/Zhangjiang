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
    ::EnterpriseImportJob.perform_later(id, file_path)
    ::TalentImportJob.perform_later(id, file_path)
    ::RoundImportJob.perform_later(id, file_path)
    ::ProductImportJob.perform_later(id, file_path)
    ::TrendImportJob.perform_later(id, file_path)
    ::InnovationImportJob.perform_later(id, file_path)
    ::GraphImportJob.perform_later(id, file_path)
  end

  # def enterprise_status_cn
  #   hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #   hash[enterprise_status]
  # end
  # def product_status_cn
  #   hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #   hash[product_status]
  # end
  # def graph_status_cn
  #   hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #   hash[graph_status]
  # end
  # def innovation_status_cm
  #   hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #   hash[innovation_status]
  # end
  # def round_status_cn
  #   hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #   hash[round_status]
  # end
  # def talent_status_cn
  #   hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #   hash[talent_status]
  # end
  # def trend_status_cn
  #    hash = {pending: '待执行', success: '导入成功', failed: '导入失败'}
  #    hash[trend_status]
  # end

  def excel_path
    if Rails.env.development?
      file.path
    else
      file.path
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
