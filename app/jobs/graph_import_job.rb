class GraphImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    areas = {"张江": 1, "上海": 2, "国内": 3, "国际": 4}
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('产业图谱企业记录').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = GraphFieldRecord.find_or_initialize_by(record_id: row[0])
        area = areas[row[7]]
        body = {"name":row[1],"level1": row[3], "level2": row[4], "title": row[5], area: area }
        field.update(table_id: "tbltzsmAUdkoSJk7", base_fields: body, enterprise_record_id: row[2])
        p body
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.graph_status = status
    import.save
  end
end
