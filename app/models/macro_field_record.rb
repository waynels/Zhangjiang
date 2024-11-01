class MacroFieldRecord < ApplicationRecord
  mount_uploader :file, PdfUploader
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
#  sector           :integer          default(1)
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
