class EnterpriseFieldRecord < ApplicationRecord
  has_many :talent_field_records, class_name: "TalentFieldRecord", foreign_key: "enterprise_record_id", primary_key: :record_id
  has_many :round_field_records, class_name: "RoundFieldRecord", foreign_key: "enterprise_record_id", primary_key: :record_id
  has_many :product_field_records, class_name: "ProductFieldRecord", foreign_key: "enterprise_record_id", primary_key: :record_id
  has_many :grahp_field_records, class_name: "GraphFieldRecord", foreign_key: "enterprise_record_id", primary_key: :record_id


  def info
    { code: code, name: name }
  end


  def talents_info
    { code: code, name: name, "talents": talent_field_records.map(&:base_fields) }
  end

  def rounds_info
    { code: code, name: name, "rounds": round_field_records.map(&:base_fields) }
  end

  def products_info
    { code: code, name: name, "rounds": product_field_records.map(&:base_fields) }
  end

end

# == Schema Information
#
# Table name: enterprise_field_records
#
#  id               :uuid             not null, primary key
#  acknowledgment   :string
#  base_fields      :jsonb
#  batch            :string
#  batch_updated_at :datetime
#  code             :string
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  record_id        :string
#  table_id         :string
#
# Indexes
#
#  index_enterprise_field_records_on_batch      (batch)
#  index_enterprise_field_records_on_code       (code)
#  index_enterprise_field_records_on_record_id  (record_id)
#
