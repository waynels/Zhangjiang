class TrendFieldRecord < ApplicationRecord

  def article
    base_fields.merge(enterprises: enterprises)
  end

  def enterprises
    return [] if enterprise_record_id.present?
    ::EnterpriseFieldRecord.where(record_id: enterprise_record_id.split(',')).map(&:info)
  end
end

# == Schema Information
#
# Table name: trend_field_records
#
#  id                   :uuid             not null, primary key
#  acknowledgment       :string
#  base_fields          :jsonb
#  batch                :string
#  batch_updated_at     :datetime
#  name                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  enterprise_record_id :string
#  record_id            :string
#  table_id             :string
#
# Indexes
#
#  index_trend_field_records_on_batch                 (batch)
#  index_trend_field_records_on_enterprise_record_id  (enterprise_record_id)
#  index_trend_field_records_on_record_id             (record_id)
#
