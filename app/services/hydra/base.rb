class Hydrahub::Base < ApplicationService
  class Error < StandardError; end

  attr_reader :config, :public_key, :headers

  
  INTEGRATIONS = ['MaxpayV2', 'Mojee', 'Hydrahub', 'Comercialltt', 'Moscouv', 'Cacapava', 'Jacaei', 'Supercash', 'Perplexid'].freeze

  def initialize(config)
    @config = config
    secret_key = config.secret_key
    public_key = config.public_key
    token = Base64.strict_encode64("#{secret_key}:#{public_key}")

    @headers = {
      'Authorization': "Basic #{token}",
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    }
  end

  protected

  def http_request(method: :post, path:, payload: {}, timeout: 60)
    url = "#{config.base_url}#{path}"
    payload = payload.to_json
    logger.info "#{self.class.name} -- MESSAGE: Request -- URL: #{url} -- HEADERS: #{headers.inspect} -- PAYLOAD: #{payload} -- TIMEOUT: #{timeout}"
    response = RestClient::Request.execute(method:, url:, headers:, payload:, timeout: )

    logger.info "#{self.class.name} -- MESSAGE: Response -- CODE: #{response.code} -- BODY: #{response.body}"
    JSON.parse(response.body).merge({
      classepay: {
        http_code: response.code,
      }
    }).with_indifferent_access
  rescue RestClient::MethodNotAllowed => e
    logger.error "#{e}"
  rescue RestClient::ExceptionWithResponse => e
    logger.error "#{self.class.name} -- MESSAGE: Response -- CODE: #{e.http_code} -- BODY: #{e.http_body}"
    raise Error, "Falha ao Realizar Operação"
  rescue => e
    logger.error "#{self.class.name} -- MESSAGE: Response -- ERROR: #{e.full_message}"
    raise Error, "Falha ao Realizar Operação"
  end


  private
    def logger
      @@logger ||= Logger.new("#{Rails.root}/log/hydrahub.log")
    rescue => e
      Rails.logger.error "#{self.class.name} -- MESSAGE: #{e.full_message}"
      @@logger = Rails.logger
    end
end
