# == Schema Information
#
# Table name: external_references
#
#  id              :bigint           not null, primary key
#  active          :boolean          default(TRUE)
#  additional_info :jsonb
#  deleted_at      :datetime
#  kind            :integer          default("import")
#  owner_type      :string
#  service         :integer          default("shopify")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  external_id     :string
#  owner_id        :bigint
#
# Indexes
#
#  index_external_references_on_owner  (owner_type,owner_id)
#
class ExternalReference < ApplicationRecord
  ## PARANOIA
  acts_as_paranoid

  ## AUDITED
  # audited

  ## ENUMS
  enum kind: {
    import: 0,
    export: 1
  }, _default: :import, _prefix: :kind
  enum service: {
    shopify: 0,
    pag_seguro: 1,
    mercado_pago: 2,
    ciclopay: 3,
    pagar_me: 4,
    abmex: 5,
    zoop: 6,
    akta: 7,
    horizon: 8,
    orla: 9,
    ultragate: 10,
    zolluspay: 11,
    morganpay: 12,
    arkama: 13,
    dom_pagamento: 14,
    noxpay: 15,
    cashtime: 16,
    beehive: 17,
    zouti: 18,
    morgan: 19,
    black_x_pay: 20,
    neverra: 21,
    brazapay: 22,
    mevpay: 23,
    hypepay: 24,
    abmexpay: 25,
    payd: 26,
    safepay: 27,
    zenith: 28,
    innovepay: 29,
    unicopay: 30,
    maxpay: 31,
    dragon_pay: 32,
    cashfy: 33,
    axionpay: 34,
    black_bull_pay: 35,
    soutpay: 36,
    bestfy: 37,
    centrapay: 38,
    paguemais: 39,
    rawart: 40,
    cashfypaga: 41,
    summitpay: 42,
    wishpag: 43,
    asaas: 44,
    royalfy: 45,
    zyon_pay: 46,
    tryplopay: 47,
    proxypay: 48,
    eskypay: 49,
    dropipay: 50,
    abypay: 51,
    paggopay: 52,
    skalepay: 53,
    quantum: 54,
    dorapag: 55,
    aurapay: 56,
    justpay: 57,
    guardpay: 58,
    woocommerce: 59,
    syfra: 60,
    elitepay: 61,
    loftpay: 62,
    podpay: 63,
    novak: 64,
    freepay: 65,
    midaspag: 66,
    apexpy: 67,
    lunar_cash: 68,
    titanshub: 69,
    alcateiapay: 70,
    dubaipay: 72,
    astrumpay: 73,
    aureolink: 74,
    pagdrop: 75,
    tropical_pagamentos: 76,
    azcend: 77,
    dorapag_pay: 78,
    cashtime_pay: 79,
    venuzpay: 80,
    dom_pagamentos_v3: 81,
    bynet: 82,
    aionpay: 83,
    dubpay: 84,
    horuspay: 85,
    az_pagamentos: 86,
    pulse_pag: 87,
    armpay: 88,
    aprovepay: 89,
    maxpay_v2: 90,
    almighty_pay: 91,
    paysak: 92,
    kitercash: 93,
    paguex: 94,
    pigpay: 95,
    mp_pagamentos: 96,
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
}, _default: :shopify, _prefix: :service

  ## ASSOCIATIONS
  belongs_to :owner, polymorphic: true

  ## VALIDATIONS
  validates :external_id, presence: true
  validates :owner_id, uniqueness: { scope: %i[owner_type kind], conditions: -> { where(kind: :import) } }
  validates :service, uniqueness: { scope: %i[owner_type kind external_id] }

  ## SCOPES
  scope :from_the_service, ->(service_name) { where(service: service_name) }
  scope :from_the_service_with_external_id, ->(service_name, external_id) { where(service: service_name.to_sym, external_id: external_id) }
end
