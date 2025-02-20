# == Schema Information
#
# Table name: installments
#
#  id                      :bigint           not null, primary key
#  amount                  :decimal(19, 2)   default(0.0)
#  calculated_total_amount :decimal(19, 2)
#  default                 :boolean          default(FALSE)
#  deleted_at              :datetime
#  gateway                 :integer          default("mercado_pago")
#  min_rate_installment    :integer          default(1)
#  number                  :integer
#  option_text             :string
#  original_amount         :decimal(19, 2)   default(0.0)
#  original_option_text    :string
#  original_tax            :decimal(19, 2)
#  original_total_amount   :decimal(19, 2)   default(0.0)
#  selected                :boolean          default(FALSE)
#  tax                     :decimal(19, 2)   default(0.0)
#  total_amount            :decimal(19, 2)   default(0.0)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cart_id                 :bigint
#
# Indexes
#
#  index_installments_on_cart_id     (cart_id)
#  index_installments_on_deleted_at  (deleted_at)
#
class Installment < ApplicationRecord
  ## PARANOIA
  acts_as_paranoid

  ## AUDITED
  # audited

  ## ASSOCIATIONS
  belongs_to :cart

  ## ENUMS
  enum gateway: {
    mercado_pago: 0,
    pag_seguro: 1,
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
    dubaipay: 68,
    astrumpay: 69,
    aureolink: 70,
    pagdrop: 71,
    tropical_pagamentos: 72,
    azcend: 73,
    dorapag_pay: 74,
    cashtime_pay: 75,
    venuzpay: 76,
    dom_pagamentos_v3: 77,
    dubpay: 78,
    bynet: 79,
    aionpay: 80,
    horuspay: 81,
    az_pagamentos: 82,
    pulse_pag: 83,
    armpay: 84,
    aprovepay: 85,
    maxpay_v2: 86,
    almighty_pay: 87,
    paysak: 88,
    kitercash: 89,
    paguex: 90,
    pigpay: 91,
    mp_pagamentos: 92,
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
}, _default: :mercado_pago, _prefix: :gateway

  ## SCOPES
  scope :selecteds, -> { where(selected: true) }
end
