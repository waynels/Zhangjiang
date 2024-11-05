class IndustryAnalysisTask < ApplicationRecord
  enum api_method: { enterprise_info: 'enterprise_info', key_enterprise_talent: 'key_enterprise_talent',key_enterprise_financing: 'key_enterprise_financing', key_enterprise_product: 'key_enterprise_product', trends: 'trends', innovation: 'innovation', data_map: 'data_map' }
  enum send_status: { pending: 'pending', making: 'making', sending: 'sending', finished: 'finished', failed: "failed"}
  after_create_commit :rebuild_json_data


  after_commit if: :saved_change_to_send_status? do
    if send_status == 'making'
      IndustryAnalysisSendJob.perform_later(id)
    end
  end

  def rebuild_json_data
    body = public_send("#{api_method}_json_data")
    update(data: body, send_status: 'making')
  end

  def enterprise_info_json_data
    fields = ::EnterpriseFieldRecord.where(batch: batch)
    { "sector": "人工智能", "batch": batch, "enterprises": fields.map(&:base_fields) }
  end

  def key_enterprise_talent_json_data
    fields = ::EnterpriseFieldRecord.where(batch: batch)
    { "sector": "人工智能", "batch": batch, "strategy": 2, "enterprises": fields.map(&:talents_info) }
  end

  def key_enterprise_financing_json_data
    fields = ::EnterpriseFieldRecord.where(batch: batch)
    { "sector": "人工智能", "batch": batch, "strategy": 2, "enterprises": fields.map(&:rounds_info) }
  end

  def key_enterprise_product_json_data
    fields = ::EnterpriseFieldRecord.where(batch: batch)
    { "sector": "人工智能", "batch": batch, "strategy": 2, "enterprises": fields.map(&:products_info) }
  end

  def trends_json_data
    fields = ::TrendFieldRecord.where(batch: batch)
    { "sector": "人工智能", "batch": batch, articles: fields.map(&:article) }
  end

  def innovation_json_data
    fields = ::InnovationFieldRecord.where(batch: batch)
    { "sector": "人工智能", "batch": batch, articles: fields.map(&:article) }
  end

  def data_map_json_data
    enterprise_ids = EnterpriseFieldRecord.where(batch: batch).pluck(:record_id)
    fields = ::GraphFieldRecord.where(enterprise_record_id: enterprise_ids)
    types = fields.group_by(&:level1).map do |level, items|
      {"label": level, "children": items.group_by(&:level2).map {|level2, enterprises| { "label": level2, "enterprises": enterprises.map(&:base_fields) }}}
    end
    { "sector": "人工智能", "batch": batch, types: types }
  end
end

# == Schema Information
#
# Table name: industry_analysis_tasks
#
#  id             :uuid             not null, primary key
#  acknowledgment :string
#  api_method     :string           default("enterprise_info")
#  batch          :string
#  data           :jsonb
#  send_status    :string           default("pending")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
