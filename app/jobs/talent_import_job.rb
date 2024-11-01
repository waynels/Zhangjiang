class TalentImportJob < ApplicationJob
  queue_as :default

  def perform(import_id, excel_path)
    import = FeishuExcelImport.find(import_id)
    # Perform Job
    status = 0
    xlsx_file = Roo::Excelx.new(excel_path)
    xlsx_file.sheet('重点企业人才信息').each_with_index do |row, index|
      # p row
      next if index < 1
      begin
        field = TalentFieldRecord.find_or_initialize_by(record_id: row[0])
        body = {"name":row[1],"positions":row[2].split_strip,"educations": row[3].split_strip,"professions":row[4].split_strip,"awards":row[5].split_strip,"achievements":row[6].split_strip,"remark":row[7]}
        field.update(name: row[1], table_id: "tbleTvx12bkJHzWa", base_fields: body, enterprise_record_id: row[8])
      rescue ActiveRecord::RecordInvalid => exception
        status = 99
        import.remark = import.remark + "#{row}#{exception.message}"
        import.save
        next
      end
    end
    status = 1
    import.talent_status = status
    import.save
  end
end
