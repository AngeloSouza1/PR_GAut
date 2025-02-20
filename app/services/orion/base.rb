module Orion
  class Error < RuntimeError; end

  class Base < ApplicationService

    INTEGRATIONS = ['Dubaipay', 'Pagdrop', 'Monezopay', 'Motorola', 'Teste', 'Sfsdfs', 'Gafe'].freeze

    private attr_reader :token, :config

    def initialize(config, url_path, additional_headers = {})
      @config = config
      @url = "#{config.base_url}#{url_path}"
      @secret_key = @config&.secret_key
      @headers = {
        'Authorization': "Basic #{Base64.strict_encode64("#{@secret_key}:x")}",
        'accept' => 'application/json',
        'content-type': 'application/json'
      }.merge(additional_headers)
      @timeout = 60
    end

    protected

    attr_reader :config, :url, :headers, :timeout

    def http_request(payload = nil, method = :post)
      logger.info "#{self.class.name} -- MESSAGE: Request -- METHOD: #{method} URL: #{url} -- HEADERS: #{headers} -- PAYLOAD: #{payload} -- TIMEOUT: #{timeout}"
      response = RestClient::Request.execute(
        method: method,
        url: url,
        headers: headers,
        payload: payload,
        timeout: timeout
      )

      logger.info "#{self.class.name} -- MESSAGE: Response -- CODE: #{response.code} -- BODY: #{response.body}"
      JSON.parse(response.body).merge({
                                        classepay: {
                                          http_code: response.code
                                        }
                                      }).with_indifferent_access
    rescue RestClient::ExceptionWithResponse => e
      logger.error "#{self.class.name} -- MESSAGE: Response -- CODE: #{e.http_code} -- BODY: #{e.http_body}"
      raise Error, cause: e
    rescue StandardError => e
      logger.error "#{self.class.name} -- MESSAGE: Response -- ERROR: #{e.full_message}"
      raise e
    end

    def logger
      @@logger ||= Logger.new(Rails.root.join('log/orion.log').to_s)
    rescue StandardError => e
      Rails.logger.error "#{self.class.name} -- MESSAGE: #{e.full_message} -- LOG: ERROR"
      @@logger = Rails.logger
    end

    # def gateway_kind_name
    #   config.name.downcase
    # end
  end
end
