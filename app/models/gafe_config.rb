class GafeConfig < ApplicationRecord
## PARANOIA
  acts_as_paranoid

  belongs_to :client, optional: true
  belongs_to :store, optional: true

  validates :store, uniqueness: true
  validates :secret_key, presence: true
  # validates :rate, numericality: { less_than_or_equal_to: 1.0 }
  validate :validate_rate

  ## CONCERNS
  include FriendlyUuid

  ## CALLBACKS
  after_create :create_gateway_config
  after_destroy :destroy_gateway_config
  before_create :set_active_attribute

  def installments_rate
    has_rate ? installments : 1
  end

  def client_side_gateway_data
    {
      is_active: active,
      secret_key: secret_key,
      js_sdk_path: 'https://assets.pagseguro.com.br/checkout-sdk-js/rc/dist/browser/pagseguro.min.js'
    }
  end

  def gateway_config
    gateway = Gateway.find_by_name("Gafe")
    GatewayConfig.find_by(gateway_id: gateway.id, store_id: store.id) if store.present?
  end<div id="form_pagdrop">
  <div class="pagdrop">
    <%= render_image_gateway 'gateway_images/gateway_pagdrop.png', 'p-1'%>
  </div>
  <%= bootstrap_form_for @pagdrop_config, url: @pagdrop_config.persisted? ? update_pagdrop_store_gateway_path(@pagdrop_config) : create_pagdrop_store_gateways_path do |f| %>
    <%#= show_errors_for(f.object) %>
    <div class="block block-rounded block-themed shadow-sm">
      <div class="block-header bg-white border-bottom">7
        <h3 class="block-title font-weight-bold text-dark">
          Dados Pagdrop
        </h3>
      </div>
      <div class="block-content">
        <% if f.object.errors[:base].present? %>
          <div class="row">
            <div class="col-12">
              <p><%= f.object.errors[:base] %></p>
            </div>
          </div>
        <% end %>
        <div class="row">
          <div class="col-12">
            <%= f.text_field :public_key, placeholder: "pk_" %>
          </div>
        </div>
        <div class="row">
          <div class="col-12">
            <%= f.text_field :secret_key, placeholder: "sk_" %>
          </div>
        </div>
        <div class="row">
          <div class="col-6">
            <%= f.text_field :formatted_rate, class: 'inputmask', required: true, value: number_with_precision(f.object.rate, precision: 2), append: '%' %>
          </div>
        </div>
      </div>
    </div>
    <div class="text-end">
      <%= f.submit "Salvar configuração", class: 'btn btn-primary', data: {disable_with: 'Salvando...'} %>
      <%= link_to t('.cancel', default: t("helpers.links.cancel")), session[:redirection_after_register].present? ? store_redirection_after_register_path : store_gateways_path, class: 'btn btn-outline-primary' %>
    </div>
  <% end %>
</div>


  private

  def destroy_gateway_config
    gateway = Gateway.find_by_name("Gafe")
    GatewayConfig.where(gateway_id: gateway.id, store_id: store.id).destroy_all if store.present?
  end

  def create_gateway_config
    gateway = Gateway.find_by_name("Gafe")
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

  def validate_rate
    return unless has_rate && rate.present? && (rate <= 0 || rate > 1)

    errors.add(:rate, 'Deve ser maior que 0,00% e menor ou igual a 1.00%')
  end

  def set_active_attribute
    return if store.nil?

    self.active = true if store.gafe_config.nil?
  end
end
