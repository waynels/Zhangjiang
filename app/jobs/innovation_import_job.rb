class InnovationImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('产业创新分析').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = InnovationFieldRecord.find_or_initialize_by(record_id: row[0])
        references = row[7].to_s.split(";;").map {|string| item = string.split("=>"); {title: item[0], url: item[1]}}
        body = {"type":row[2],"title": row[1], "body": row[3], "publishDate": row[5], "source": row[4], "url": row[6], references: references }
        field.update(table_id: "tblQdd1uPMSLrl3C", base_fields: body, batch: row[8])
        p body
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.innovation_status = status
    import.save
  end
end
