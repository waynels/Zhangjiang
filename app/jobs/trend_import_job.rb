class TrendImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('产业动态').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = TrendFieldRecord.find_or_initialize_by(record_id: row[0])
        body = {"type":row[2],"title": row[1], "body": row[3], "publishDate": row[4], "source": row[5], "url": row[6] }
        field.update(table_id: "tblCr2EF9nF9G2z7", base_fields: body, enterprise_record_id: row[8], batch: row[9])
        p body
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.trend_status = status
    import.save
  end
end
