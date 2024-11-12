RailsAdmin.config do |config|

  ### Popular gems integration


  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)
  config.authenticate_with do
    warden.authenticate! scope: :admin_user
  end
  config.current_user_method(&:current_admin_user)
  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true
  #
  config.model 'FeishuExcelImport' do
    configure :enterprise_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
    configure :product_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
    configure :graph_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
    configure :innovation_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
    configure :round_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
    configure :talent_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
    configure :trend_status, :enum do
      enum do
        { "待执行": :pending, "导入成功": :success, "导入失败": :failed }
      end
    end
  end

  config.model 'EnterpriseFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'GraphFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'InnovationFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'ProductFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'RoundFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'TalentFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'TrendFieldRecord' do
    configure :base_fields, :serialized
  end
  config.model 'IndustryAnalysisTask' do
    configure :data, :serialized
    configure :api_method, :enum do
      enum do
        { "企业信息": :enterprise_info, "重点企业人才信息": :key_enterprise_talent, "重点企业融资信息": :key_enterprise_financing, "重点企业产品信息": :key_enterprise_product, "产业动态": :trends, "产业创新分析": :innovation ,"产业图谱企业记录": :data_map }
      end
    end

    configure :send_status, :enum do
      enum do
        { "准备中": :pending, "数据完成": :making, "发送中": :sending, "对方已接收": :finished, "发送失败": :failed }
      end
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
