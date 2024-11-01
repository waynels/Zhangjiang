# require 'openssl'
# require 'base64'
# require 'json'
# require 'net/http'
# require 'uri'

# 通用密钥
# KEY = Digest::MD5.hexdigest("bYc*2VgVAvmd)!yX")
class AccessUtilsService
  class << self
    # # 加密函数
    # def encrypt(input)
    #   cipher = OpenSSL::Cipher::AES256.new(:CBC) # 使用AES-256-CBC模式
    #   cipher.encrypt
    #   cipher.key = KEY
    #   # 对于CBC模式，我们需要一个初始化向量（IV）
    #   iv = cipher.random_iv
    #   # 加密数据，注意：这里我们假设input是字符串，并且已经编码为适合加密的二进制形式
    #   # 在实际使用中，您可能需要将字符串编码为UTF-8或其他适当的编码
    #   encrypted = cipher.update(input.encode('UTF-8')) + cipher.final
    #   # 将IV和密文拼接起来（在实际应用中，您应该将IV和密文一起安全地存储和传输）
    #   # 然后将结果编码为Base64字符串
    #   Base64.encode64(iv + encrypted)
    # end

    # # 解密函数
    # def decrypt(input_base64)
    #   decoded = Base64.decode64(input_base64)
    #   iv_size = OpenSSL::Cipher::AES256.new(:CBC).block_size # IV的大小等于块大小
    #   iv = decoded[0, iv_size]
    #   encrypted_data = decoded[iv_size..-1]

    #   cipher = OpenSSL::Cipher::AES256.new(:CBC)
    #   cipher.decrypt
    #   cipher.key = KEY
    #   cipher.iv = iv

    #   # 解密数据
    #   decrypted = cipher.update(encrypted_data) + cipher.final
    #   # 将解密后的二进制数据编码回UTF-8字符串（或您使用的其他编码）
    #   decrypted.encode('UTF-8')
    # end
    #
    def encrypt(input, key)
      cipher = OpenSSL::Cipher.new('AES-128-ECB')
      cipher.encrypt
      cipher.key = key
      encrypted = cipher.update(input) + cipher.final
      p encrypted
      Base64.strict_encode64(encrypted)
    end

    # 解密一个以 Base64 编码的 AES 加密字符串
    def decrypt(input, key)
      decoded = Base64.decode64(input)
      cipher = OpenSSL::Cipher.new('AES-128-ECB')
      cipher.decrypt
      cipher.key = key
      cipher.update(decoded) + cipher.final
    end
  end
end

# # 假设的HTTP请求发送函数
# def send_http_request(url, headers, body)
#   uri = URI(url)
#   http = Net::HTTP.new(uri.host, uri.port)
#   http.use_ssl = uri.scheme == 'https'

#   request = Net::HTTP::Post.new(uri.request_uri, headers)
#   request.body = body

#   response = http.request(request)
#   response.body
# end

# 示例使用
# encrypted_data = AccessUtilsService.encrypt("hello, world!")
# puts "Encrypted: #{encrypted_data}"

# decrypted_data = AccessUtilsService.decrypt(encrypted_data)
# puts "Decrypted: #{decrypted_data}"
