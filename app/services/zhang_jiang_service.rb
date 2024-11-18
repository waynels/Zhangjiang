require 'net/http/post/multipart'
require 'rest-client'
require 'json'
class ZhangJiangService
  attr_accessor :appid, :app_secret
  API_BASE = 'https://zjkxc.pudong.gov.cn/zjip-admin'.freeze
  ZHANGJIANG_USER_KEY = ENV['ZHANGJIANG_USER_KEY']
  ZHANGJIANG_COMMOM_KEY = ENV['ZHANGJIANG_COMMOM_KEY']

  def initialize(appid, app_secret)
    @appid = appid
    @app_secret = app_secret
  end

  # 1. 获取用户Token并写入redis
  def get_access_token
    url = API_BASE + "/access/token"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    string = {userId: ENV['ZHANGJIANG_USERID'], secret: ENV['ZHANGJIANG_SECRET'],timestamp: timestamp}.to_json
    data = AccessUtilsService.encrypt(string, ZHANGJIANG_COMMOM_KEY)
    body = {data: data}
    token = from_http_client(url, :post, body)
    redis_key = "/zhangjiang/access_token/#{@appid}"
    $redis.set(redis_key, token)
    $redis.expire redis_key, 29.minutes.to_i
    token
  end

  # 从redis中获取Token
  def access_token
    redis_key = "/zhangjiang/access_token/#{@appid}"
    if $redis.exists(redis_key)
      token = $redis.get(redis_key)
      if token.present?
        token
      else
        get_access_token
      end
    else
      get_access_token
    end
  end

  # 2. 获取票据接口
  def access_ticket
    url = API_BASE + "/access/ticket"
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    string = {token: access_token, timestamp: timestamp}.to_json
    data = AccessUtilsService.encrypt(string, ZHANGJIANG_COMMOM_KEY)
    body = {data: data}
    ticket = from_http_client(url, :post, body)
    ticket
  end

  # 3. 企业基本情况接口
  def enterprise_info(json)
    url = API_BASE + "/api/industryAnalysis/enterpriseInfo"
    data_industry_analysis(url, json)
  end

  # 4. 重点企业人才接口
  def key_enterprise_talent(json)
    url = API_BASE + "/api/industryAnalysis/keyEnterpriseTalent"
    data_industry_analysis(url, json)
  end

  # 5. 重点企业融资接口
  def key_enterprise_financing(json)
    url = API_BASE + "/api/industryAnalysis/keyEnterpriseFinancing"
    data_industry_analysis(url, json)
  end

  # 6. 重点企业产品分析接口
  def key_enterprise_product(json)
    url = API_BASE + "/api/industryAnalysis/keyEnterpriseProduct"
    data_industry_analysis(url, json)
  end

  # 7. 产业动态接口
  def trends(json)
    url = API_BASE + "/api/industryAnalysis/trends"
    data_industry_analysis(url, json)
  end

  # 8. 产业创新分析接口
  def innovation(json)
    url = API_BASE + "/api/industryAnalysis/innovation"
    data_industry_analysis(url, json)
  end

  # 9. 产业图谱接口
  def data_map(json)
    url = API_BASE + "/api/industryAnalysis/map"
    data_industry_analysis(url, json)
  end

  # # 10. 产业宏观分析接口
  # def macro1(record_id)
  #   item = ::MacroFieldRecord.find(record_id)
  #   boundary, body = item.body_parts
  #   url = API_BASE + "/api/industryAnalysis/macro"
  #   uri = URI(url)
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   request = Net::HTTP::Post::Multipart.new(uri.path, item.form_data)
  #   http.use_ssl = true # 因为是https请求，启用SSL
  #   request = Net::HTTP::Post.new(uri.request_uri)
  #   request['access_ticket'] = access_ticket
  #   request["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
  #   request.body = body
  #   response = http.request(request)
  #   return nil unless response.code.to_s == '200'
  #   result = JSON.parse(response.body)
  #   p result
  #   return nil if result['code'] != 0
  #   result
  # end

  # 10. 产业宏观分析接口
  # def macro(record_id)
  #   item = ::MacroFieldRecord.find(record_id)
  #   url = API_BASE + "/api/industryAnalysis/macro"
  #   uri = URI(url)

  #   http = Net::HTTP.start(uri.host, uri.port)
  #   req = Net::HTTP::Post::Multipart.new(uri, item.form_data)
  #   req["access_ticket"] = access_ticket
  #   response = http.request(req)
  #   p response
  #   return nil unless response.code.to_s == '200'
  #   result = JSON.parse(response.body)
  #   p result
  #   return nil if result['code'] != 0
  #   result
  # end
  #
  #

  # 10. 产业宏观分析接口
  def macro(record_id)
    item = ::MacroFieldRecord.find(record_id)
    url = API_BASE + "/api/industryAnalysis/macro"

    connection = Faraday.new(url: url) do |faraday|
      faraday.request :multipart
      faraday.request :url_encoded
      faraday.adapter :net_http
    end

    response = connection.post do |req|
      req.headers['access_ticket'] = access_ticket
      req.body = item.form_data
    end
    return nil unless response.status.to_s == '200'
    result = JSON.parse(response.body)
    return nil if result['code'] != 0
    result
  end

  private

  # 通过 application/json 弄出具
  def server_http_client(url, method, body = {}, ticket = nil)
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
    request['access_ticket'] = ticket if ticket.present?
    request.body = body.to_json if body.present?
    http.request(request)
  end

  # 通过 set form data的方式提交或获取数据
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

  # 提交数据
  def data_industry_analysis(url, json)
    ticket = access_ticket
    data =  AccessUtilsService.encrypt(json, ZHANGJIANG_USER_KEY)
    body = {data: data}
    response = server_http_client(url, :post, body, ticket)
    p response
    return nil unless response.code.to_s == '200'
    result = JSON.parse(response.body)
    p result
    return nil if result['code'] != 0
    result
  end
end
