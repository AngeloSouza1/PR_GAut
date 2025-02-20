class ObitoConfig < ApplicationRecord
## PARANOIA
 acts_as_paranoid
 belongs_to :client, optional: true
 belongs_to :store, optional: true
 validates :store, uniqueness: true
 validates :secret_key, :public_key, presence: true
 validates :rate, numericality: { in: 0..1 }, if: :has_rate?
 ## CONCERNS
 include FriendlyUuid
 ## CALLBACKS
 after_create :create_gateway_config
 after_destroy :destroy_gateway_config
 before_create :set_active_attribute
 before_validation :strip_whitespaces

 def installments_rate
   has_rate ? installments : 1
 end

#  def name = 'MaxpayV2'

 def data_to_tokenize = public_key

 def client_side_gateway_data
   {
     is_active: active,
     secret_key: secret_key,
     js_sdk_path: 'https://assets.pagseguro.com.br/checkout-sdk-js/rc/dist/browser/pagseguro.min.js'
   }
 end

 def gateway_config
   gateway = Gateway.find_by_name("Obito")
   GatewayConfig.find_by(gateway_id: gateway.id, store_id: store.id) if store.present?
 end

 private

  def strip_whitespaces
   secret_key.squish! unless secret_key.nil?
  end

  def destroy_gateway_config
   gateway = Gateway.find_by_name("Obito")
   GatewayConfig.where(gateway_id: gateway.id, store_id: store.id).destroy_all if store.present?
  end

  def create_gateway_config
    gateway = Gateway.find_by_name("Obito")
    GatewayConfig.kinds.each_key do |kind|
      next unless store.present?
      last_gateway_config = GatewayConfig.where(kind: kind.to_sym, store_id: store.id).order(priority: :asc).last
      index = last_gateway_config ? last_gateway_config.priority : 0
      GatewayConfig.create(
        priority: index + 1,
        status: :active,
        gateway_id: gateway.id,
        gatewable: store.seller,
        kind: kind.to_sym,
        store_id: store.id
      )
    end
  end

  def set_active_attribute
    return if store.nil?
    self.active = true if store.Obito_config.nil?
  end
end
