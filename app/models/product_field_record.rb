class ProductFieldRecord < ApplicationRecord
  belongs_to :enterprise_field_record, foreign_key: :enterprise_record_id, primary_key: :record_id

end

# == Schema Information
#
# Table name: product_field_records
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
#  index_product_field_records_on_batch                 (batch)
#  index_product_field_records_on_enterprise_record_id  (enterprise_record_id)
#  index_product_field_records_on_record_id             (record_id)
#
