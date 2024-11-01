namespace :zhangjiang do
  namespace :excel do
    desc "import excel data"
    task import: :environment do
      file_path = Rails.root.join('public/uploads/feishu_excel_import/file/1/file_20241030140052.xlsx')
      import_enterprise_field_records(file_path)
      import_talent_field_records(file_path)
      import_round_field_records(file_path)
      import_product_field_records(file_path)
      import_trend_field_records(file_path)
      import_innovation_field_records(file_path)
      import_graph_field_records(file_path)
    end

    def import_enterprise_field_records(file_path)
      xlsx_file = Roo::Excelx.new(file_path)
      xlsx_file.sheet('企业信息').each_with_index do |row, index|
        # p row
        next if index < 1
        begin
          field = EnterpriseFieldRecord.find_or_initialize_by(record_id: row[0])
          body = {"alias":row[4],"name":row[3],"code":row[1],"introduce":row[6],"operationStatus":row[7],"industryTypes":row[9].split_strip,"industryTracks":row[10].split_strip,"isZhangJiang":row[11],"labels":row[13].split_strip,"stockCode":row[12],"listDate":row[14],"listState":row[15],"lastUpdateDate":row[16]}
          field.update(code: row[1], name: row[3], table_id: "tbljWKNhE9sYOp6v", batch: [18], base_fields: body)
          p field.base_fields.to_json
        rescue ActiveRecord::RecordInvalid => exception
          p exception
          p row
        end
      end
    end

    def import_talent_field_records(file_path)
      xlsx_file = Roo::Excelx.new(file_path)
      xlsx_file.sheet('重点企业人才信息').each_with_index do |row, index|
        # p row
        next if index < 1
        begin
          field = TalentFieldRecord.find_or_initialize_by(record_id: row[0])
          body = {"name":row[1],"positions":row[2].split_strip,"educations": row[3].split_strip,"professions":row[4].split_strip,"awards":row[5].split_strip,"achievements":row[6].split_strip,"remark":row[7]}
          field.update(name: row[1], table_id: "tbleTvx12bkJHzWa", base_fields: body, enterprise_record_id: row[8])
          p body
        rescue ActiveRecord::RecordInvalid => exception
          p exception
          p row
        end
      end

    end

    def import_round_field_records(file_path)
      xlsx_file = Roo::Excelx.new(file_path)
      xlsx_file.sheet('重点企业融资信息').each_with_index do |row, index|
        # p row
        next if index < 1
        begin
          field = RoundFieldRecord.find_or_initialize_by(record_id: row[0])
          body = {"name":row[1],"amount":row[2],"institutions": row[3].split_strip,"date": row[4]}
          field.update(name: row[1], table_id: "tbln8iAx3QRZZeUM", base_fields: body, enterprise_record_id: row[5])
          p body
        rescue ActiveRecord::RecordInvalid => exception
          p exception
          p row
        end
      end
    end

    def import_product_field_records(file_path)
      xlsx_file = Roo::Excelx.new(file_path)
      xlsx_file.sheet('重点企业产品信息').each_with_index do |row, index|
        # p row
        next if index < 1
        begin
          field = ProductFieldRecord.find_or_initialize_by(record_id: row[0])
          body = {"name":row[1],"body": row[2]}
          field.update(name: row[1], table_id: "tblzWemRbHEXpIoj", base_fields: body, enterprise_record_id: row[3])
          p body
        rescue ActiveRecord::RecordInvalid => exception
          p exception
          p row
        end
      end
    end

    def import_trend_field_records(file_path)
      xlsx_file = Roo::Excelx.new(file_path)
      xlsx_file.sheet('产业动态').each_with_index do |row, index|
        # p row
        next if index < 1
        begin
          field = TrendFieldRecord.find_or_initialize_by(record_id: row[0])
          body = {"type":row[2],"title": row[1], "body": row[3], "publishDate": row[4], "source": row[5], "url": row[6] }
          field.update(table_id: "tblCr2EF9nF9G2z7", base_fields: body, enterprise_record_id: row[8], batch: row[9])
          p body
        rescue ActiveRecord::RecordInvalid => exception
          p exception
          p row
        end
      end
    end

    def import_innovation_field_records(file_path)
      xlsx_file = Roo::Excelx.new(file_path)
      xlsx_file.sheet('产业创新分析').each_with_index do |row, index|
        # p row
        next if index < 1
        begin
          field = InnovationFieldRecord.find_or_initialize_by(record_id: row[0])
          references = row[7].to_s.split(";;").map {|string| item = string.split("=>"); {title: item[0], url: item[1]}}
          body = {"type":row[2],"title": row[1], "body": row[3], "publishDate": row[5], "source": row[4], "url": row[6], references: references }
          field.update(table_id: "tblQdd1uPMSLrl3C", base_fields: body, batch: row[9])
          p body
        rescue ActiveRecord::RecordInvalid => exception
          p exception
          p row
        end
      end
    end

    def import_graph_field_records(file_path)
      areas = {"张江": 1, "上海": 2, "国内": 3, "国际": 4}
      xlsx_file = Roo::Excelx.new(file_path)
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
          p exception
          p row
        end
      end
    end
  end
end
