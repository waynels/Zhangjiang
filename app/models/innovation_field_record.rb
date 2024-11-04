class InnovationFieldRecord < ApplicationRecord
  def article
    base_fields
  end
end

# == Schema Information
#
# Table name: innovation_field_records
#
#  id               :uuid             not null, primary key
#  acknowledgment   :string
#  base_fields      :jsonb
#  batch            :string
#  batch_updated_at :datetime
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  record_id        :string
#  table_id         :string
#
# Indexes
#
#  index_innovation_field_records_on_batch      (batch)
#  index_innovation_field_records_on_record_id  (record_id)
#
