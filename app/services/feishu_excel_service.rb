class FeishuExcelService
  attr_accessor :appid, :app_secret
  API_BASE = 'https://open.feishu.cn/open-apis'.freeze
  WXA_BASE = 'https://api.weixin.qq.com/wxa/'.freeze

  def initialize(appid, app_secret)
    @appid = appid
    @app_secret = app_secret
  end

  def get_table_records(app_token, table_id, view_id=nil)
    url = API_BASE + "/bitable/v1/apps/#{app_token}/tables/#{table_id}/records"
    body = { }
    authorization = "Bearer #{feishu_tenant_access_token}"
    p authorization
    server_http_client(url, :get, body, authorization)
  end

  def batch_update(app_token, table_id, records)
    url = API_BASE + "/bitable/v1/apps/#{app_token}/tables/#{table_id}/records/batch_update"

    body = JSON.parse(records)
    authorization = "Bearer #{feishu_tenant_access_token}"
    response = server_http_client(url, :post, body, authorization)
    if response.code == '200'
      body = JSON.parse(response.body)
      body["data"]
    else
      p 'get table error'
    end
  end

  def tenant_access_token
    url = API_BASE + "/auth/v3/tenant_access_token/internal"

    body = { app_id: @appid, app_secret: @app_secret }

    response = server_http_client(url, :post, body)
    return nil unless response.code.to_s == '200'
    result = JSON.parse(response.body)
    redis_key = "/feishu/tenant_access_token/#{@appid}"
    $redis.set(redis_key, result['tenant_access_token'])
    $redis.expire redis_key, result['expire'].to_i - 10
    result['tenant_access_token']
  end

  def feishu_tenant_access_token
    redis_key = "/feishu/tenant_access_token/#{@appid}"
    if $redis.exists(redis_key)
      $redis.get(redis_key)
    else
      tenant_access_token
    end
  end

  def server_http_client(url, method, body = {}, authorization = nil)
    uri = URI(url)
    request = case method
              when :get
                Net::HTTP::Get.new(uri)
              when :post
                Net::HTTP::Post.new(uri)
              end
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request['Content-Type'] = 'application/json'
    request["Authorization"] = authorization if authorization.present?
    request.body = body.to_json if body.present?
    http.request(request)
  end


  private


  def get_client(url)
    HTTP.get(url)
  end

  def post_client(url, body = {})
    HTTP.post(url, body: body)
  end

end
