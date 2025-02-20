# == Schema Information
#
# Table name: charges
#
#  id                :bigint           not null, primary key
#  additional_infos  :jsonb
#  cancel_reason     :string
#  canceled_at       :datetime
#  chargeable_type   :string
#  deleted_at        :datetime
#  error_description :string
#  error_http_code   :integer
#  payment_type      :integer
#  service           :integer
#  slug              :string
#  status            :integer          default("waiting_payment")
#  value             :decimal(19, 2)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  cart_id           :bigint
#  chargeable_id     :bigint
#  gateway_config_id :bigint
#  invoice_id        :bigint
#  order_id          :bigint
#
# Indexes
#
#  index_charges_on_cart_id            (cart_id)
#  index_charges_on_chargeable         (chargeable_type,chargeable_id)
#  index_charges_on_deleted_at         (deleted_at)
#  index_charges_on_gateway_config_id  (gateway_config_id)
#  index_charges_on_invoice_id         (invoice_id)
#  index_charges_on_order_id           (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (cart_id => carts.id)
#  fk_rails_...  (gateway_config_id => gateway_configs.id)
#  fk_rails_...  (invoice_id => invoices.id)
#  fk_rails_...  (order_id => orders.id)
#
class Charge < ApplicationRecord
  ## PARANOIA
  acts_as_paranoid

  ## AUDITED
  audited

  ## CONCERN
  include ExternalReferenceable

  ## ENUMS
  enum status: {
    waiting_payment: 0,
    paid: 1,
    in_process: 2,
    authorized: 3,
    captured: 4,
    canceled: 5,
    refunded: 6,
    declined: 7,
    chargedback: 8,
    in_mediation: 9,
    expired: 10
  }, _default: :waiting_payment, _prefix: :status

  enum service: {
    pag_seguro: 0,
    mercado_pago: 1,
    pagar_me: 2,
    abmex: 3,
    zoop: 4,
    akta: 5,
    horizon: 6,
    orla: 7,
    ultragate: 8,
    zolluspay: 9,
    morganpay: 10,
    arkama: 11,
    dom_pagamento: 12,
    noxpay: 13,
    cashtime: 14,
    beehive: 15,
    zouti: 16,
    morgan: 17,
    black_x_pay: 18,
    neverra: 19,
    brazapay: 20,
    mevpay: 21,
    hypepay: 22,
    abmexpay: 23,
    payd: 24,
    safepay: 25,
    zenith: 26,
    innovepay: 27,
    unicopay: 28,
    maxpay: 29,
    dragon_pay: 30,
    cashfy: 31,
    axionpay: 32,
    black_bull_pay: 33,
    soutpay: 34,
    bestfy: 35,
    centrapay: 36,
    paguemais: 37,
    rawart: 38,
    cashfypaga: 39,
    summitpay: 40,
    wishpag: 41,
    asaas: 42,
    royalfy: 43,
    zyon_pay: 44,
    tryplopay: 45,
    proxypay: 46,
    eskypay: 47,
    dropipay: 48,
    abypay: 49,
    paggopay: 50,
    skalepay: 51,
    quantum: 52,
    dorapag: 53,
    aurapay: 54,
    justpay: 55,
    guardpay: 56,
    syfra: 57,
    elitepay: 58,
    loftpay: 59,
    podpay: 60,
    novak: 61,
    freepay: 62,
    midaspag: 63,
    apexpy: 64,
    lunar_cash: 65,
    titanshub: 66,
    alcateiapay: 67,
    dubaipay: 69,
    astrumpay: 70,
    aureolink: 71,
    pagdrop: 72,
    tropical_pagamentos: 73,
    azcend: 74,
    dorapag_pay: 75,
    cashtime_pay: 76,
    venuzpay: 77,
    dom_pagamentos_v3: 78,
    bynet: 79,
    aionpay: 80,
    horuspay: 81,
    dubpay: 82,
    az_pagamentos: 83,
    pulse_pag: 84,
    armpay: 85,
    aprovepay: 86,
    maxpay_v2: 87,
    almighty_pay: 88,
    paysak: 89,
    kitercash: 90,
    paguex: 91,
    pigpay: 92,
    mp_pagamentos: 93,
    elysiumpay: 125,
     pay2flow: 133,
    motorolapay: 159,
  vegapay: 118,
  teste: 700,
  sfsdfs: 155,
  gafe: 222,
  motorola: 123,
  yopa: 122,
  obito: 122,
  vergonex: 155,
  mojee: 156,
  hydrahub: 698,
  comercialltt: 356,
  moscouv: 555,
  cacapava: 333,
  jacaei: 888,
  bisonpay: 800,
  american: 333,
  flyer: 333,
  supercash: 333,
  sprra: 222,
  dora: 777,
  perplexid: 888,
}, _default: :pag_seguro, _prefix: :service


  enum payment_type: {
    credit_card: 0,
    bank_slip: 1,
    pix: 2
  }, _default: :credit_card, _prefix: :payment_type

  ## ASSOCIATIONS
  belongs_to :gateway_config, optional: true
  belongs_to :order, optional: true
  belongs_to :invoice, optional: true
  belongs_to :cart, optional: true
  belongs_to :chargeable, polymorphic: true, optional: true

  ## CONCERNS
  include FriendlyUuid
end
