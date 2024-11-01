class RoundImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('重点企业融资信息').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = RoundFieldRecord.find_or_initialize_by(record_id: row[0])
        body = {"name":row[1],"amount":row[2],"institutions": row[3].split_strip,"date": row[4]}
        field.update(name: row[1], table_id: "tbln8iAx3QRZZeUM", base_fields: body, enterprise_record_id: row[5])
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.round_status = status
    import.save
  end
end
