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
