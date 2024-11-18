class ProductImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('重点企业产品信息').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = ProductFieldRecord.find_or_initialize_by(record_id: row[0])
        body = {"name":row[1],"body": row[2]}
        field.update(name: row[1], table_id: "tblzWemRbHEXpIoj", base_fields: body, batch: row[3], enterprise_record_id: row[4])
        p body
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.product_status = status
    import.save
  end
end
