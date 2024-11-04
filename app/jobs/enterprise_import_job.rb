class EnterpriseImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('企业信息').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = EnterpriseFieldRecord.find_or_initialize_by(record_id: row[0])
        body = {"alias":row[4],"name":row[3],"code":row[1],"introduce":row[6],"operationStatus":row[7],"industryTypes":row[9].split_strip,"industryTracks":row[10].split_strip,"isZhangJiang":row[11],"labels":row[13].split_strip,"stockCode":row[12],"listDate":row[14],"listState":row[15],"lastUpdateDate":row[16]}
        field.update(code: row[1], name: row[3], table_id: "tbljWKNhE9sYOp6v", batch: row[17], base_fields: body)
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.enterprise_status = status
    import.save
  end
end
