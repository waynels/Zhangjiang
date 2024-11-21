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
    edit do
      field :file
    end
  %w[enterprise graph innovation product round talent trend].each do |item|
      configure :"#{item}_status", :enum do
        pretty_value do
          bindings[:view].t("#{item}_status.#{bindings[:object].try("#{item}_status").to_s}")
        end
      end
    end
    list do
      sort_by :created_at
      sort_reverse true
    end
  end

  config.model 'MacroFieldRecord' do
    edit do
      field :batch
      field :title
      field :file
      field :source
      field :author
      field :publishDate
    end
    list do
      field :id
      field :batch
      field :title
      field :file
      field :source
      field :author
      field :publishDate
      field :acknowledgment
      field :batch_updated_at
      field :created_at
      field :updated_at
      sort_by :created_at
      sort_reverse true
    end
  end

  config.model 'EnterpriseFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'GraphFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'InnovationFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'ProductFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'RoundFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'TalentFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'TrendFieldRecord' do
    configure :base_fields, :serialized
    list do
      sort_by :created_at
      sort_reverse true
    end
  end
  config.model 'IndustryAnalysisTask' do

    configure :data, :serialized
    configure :api_method, :enum do
      enum do
        { "企业信息": :enterprise_info, "重点企业人才信息": :key_enterprise_talent, "重点企业融资信息": :key_enterprise_financing, "重点企业产品信息": :key_enterprise_product, "产业动态": :trends, "产业创新分析": :innovation ,"产业图谱企业记录": :data_map }
      end
      pretty_value do
        bindings[:view].t("api_method.#{bindings[:object].api_method.to_s}")
      end
    end
    configure :send_status, :enum do
      pretty_value do
        bindings[:view].t("send_status.#{bindings[:object].send_status.to_s}")
      end
    end
    edit do
      field :batch
      field :api_method
    end
    list do
      sort_by :created_at
      sort_reverse true
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
    # delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
