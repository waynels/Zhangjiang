class ZhangJiangService
  attr_accessor :appid, :app_secret
  API_BASE = 'https://zjkxc.pudong.gov.cn/zjip-admin'.freeze
  ZHANGJIANG_USER_KEY = ENV['ZHANGJIANG_USER_KEY']
  ZHANGJIANG_COMMOM_KEY = ENV['ZHANGJIANG_COMMOM_KEY']

  def initialize(appid, app_secret)
    @appid = appid
    @app_secret = app_secret
  end

  # 1 获取用户Token
  def get_access_token
    url = API_BASE + "/access/token"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    string = {userId: ENV['ZHANGJIANG_USERID'], secret: ENV['ZHANGJIANG_SECRET'],timestamp: timestamp}.to_json
    data = AccessUtilsService.encrypt(string, ZHANGJIANG_COMMOM_KEY)
    body = {data: data}
    token = from_http_client(url, :post, body)
    redis_key = "/zhangjiang/access_token/#{@appid}"
    $redis.set(redis_key, token)
    $redis.expire redis_key, 29.minutes.after.to_i
    token
  end

  def access_token
    redis_key = "/zhangjiang/access_token/#{@appid}"
    if $redis.exists(redis_key)
      $redis.get(redis_key)
    else
      get_access_token
      # tenant_access_token
    end
  end

  # 2 获取票据接口
  def access_ticket
    url = API_BASE + "/access/ticket"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    string = {token: access_token, timestamp: timestamp}.to_json
    data = AccessUtilsService.encrypt(string, ZHANGJIANG_COMMOM_KEY)
    body = {data: data}
    ticket = from_http_client(url, :post, body)
    ticket
  end

  # 3 企业基本情况接口
  def enterprise_info(json)
    url = API_BASE + "/api/industryAnalysis/enterpriseInfo"
    data_industry_analysis(url)
  end

  # 4 重点企业人才接口
  def key_enterprise_talent(json)
    url = API_BASE + "/api/industryAnalysis/keyEnterpriseProduct"
    data_industry_analysis(url)
  end

  # 5 重点企业融资接口
  def key_enterprise_financing(json)
    url = API_BASE + "/api/industryAnalysis/keyEnterpriseFinancing"
    data_industry_analysis(url)
  end

  # 6 重点企业产品分析接口
  def key_enterprise_financing(json)
    url = API_BASE + "/api/industryAnalysis/keyEnterpriseFinancing"
    data_industry_analysis(url)
  end

  private

  def server_http_client(url, method, body = {}, trick = nil)
    uri = URI(url)
    request = case method
              when :get
                Net::HTTP::Get.new(uri)
              when :post
                Net::HTTP::Post.new(uri)
              end
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request.content_type = 'application/json'
    request['access_ticket'] = trick if trick.present?
    request.body = body.to_json if body.present?
    http.request(request)
  end


  def from_http_client(url, method, body = {}, authorization = nil)
    uri = URI(url)
    request = case method
              when :get
                Net::HTTP::Get.new(uri)
              when :post
                Net::HTTP::Post.new(uri)
              end
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    # request['Content-Type'] = 'application/json'
    request["Authorization"] = authorization if authorization.present?
    request.set_form_data(body) if body.present?
    response = http.request(request)
    return nil unless response.code.to_s == '200'
    result = JSON.parse(response.body)
    return nil if result['code'] != 0

    result = AccessUtilsService.decrypt(result['data'], ZHANGJIANG_COMMOM_KEY)
    result
  end

  def data_industry_analysis(url, json)
    trick = access_ticket
    data =  AccessUtilsService.encrypt(json, ZHANGJIANG_USER_KEY)
    body = {data: data}
    response = server_http_client(url, :post, body, trick)
    return nil unless response.code.to_s == '200'
    result = JSON.parse(response.body)
    return nil if result['code'] != 0
    result
  end
end
