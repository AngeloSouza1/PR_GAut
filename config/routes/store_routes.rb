# StoreRoutes
module StoreRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :store do
        root to: 'pages#index'

        resources :domains do
          collection do
            get :step
          end
        end

        resource :sender, only: %i[show update]

        get "/finalizar-cadastro", to: "dashboard#finish_subscription", as: :finish_subscription
        get "/redirecionar", to: "dashboard#redirection_after_register", as: :redirection_after_register
        get "/home", to: "dashboard#home", as: :home
        get "/dashboard", to: "dashboard#index", as: :dashboard

        resources :delivery_options, only: [:index, :show]
        resources :integration_deliveries, only: %i[new create edit update destroy] do
          collection do
            get '/authorize/:provider', action: 'authorize', as: 'authorize'
          end
        end
        resources :brands
        resources :order_bumps
        resources :webhook_stores

        resources :categories do
          member do
            get :toggle
          end
        end

        resources :coupons  do
          member do
            patch :toggle_active
          end
        end

        resources :customers
        resources :employees

        resources :freights do
          member do
            get :toggle
          end
        end

        resources :grids do
          member do
            get :toggle
          end
        end

        resources :images, only: %i[new create destroy]
        resources :integrations
        resources :pixels do
          get :toggle, on: :member
        end
        resources :social_proofs
        resources :stores, only: [:index, :update] do
          delete :destroy_image, on: :member
        end
        resources :upsells do
          member do
            get :toogle
          end
        end
        resources :reportana_configs
        resources :google_analytics
        resources :utms do
          collection do
            get :dashboard
          end
        end
        resources :voxuy_configs do
          collection do
            get :tutorial
          end
        end

        resources :gateways do collection do
            get :step
            get :step_arkama
            get :step_lunar
            get :step_midaspag
            get :step_freepay
            get :step_pigpay
            get :step_azc
            post :create_pag_seguro
            post :create_pagar_me
            post :create_abmex
            post :create_perplexid
            post :create_dora
            post :create_sprra
            post :create_supercash
            post :create_flyer
            post :create_american
            post :create_bisonpay
            post :create_jacaei
            post :create_cacapava
            post :create_moscouv
            post :create_comercialltt
            post :create_hydrahub
            post :create_mojee
            post :create_conguz
            post :create_vergonex
            post :create_obito
            post :create_yopa
            post :create_motorola
            post :create_gafe
            post :create_sfsdfs
            post :create_teste
            post :create_vegapay
            post :create_motorolapay
            post :create_motorla
            post :create_motorola
            post :create_flexpay
            post :create_bbbb
            post :create_zekkk
            post :create_carreal
            post :create_cashmoney
            post :create_freepay
            post :create_gabiru
            post :create_gabiru
            post :create_catbee
            post :create_moneybee
            post :create_santopay
            post :create_pagseg
            post :create_moscov
            post :create_userfox
            post :create_dolapay
            post :create_rolex
            post :create_bunrest
            post :create_cashfree
            post :create_honey
            post :create_moneypi
            post :create_pulsepag4
            post :create_logf
            post :create_telsafree
            post :create_usafree
            post :create_pigone
            post :create_ovnifree
            post :create_gatteste
            post :create_pay2flow
            post :create_elysiumpay
            post :create_mp_pagamentos
            post :create_monezopay
          end

          member do
            put :update_pag_seguro
            patch :update_pag_seguro
            get :edit_pag_seguro
            delete :destroy_pag_seguro
            put :update_pagar_me
            patch :update_pagar_me
            get :edit_pagar_me
            put :update_abmex
            patch :update_abmex
            get :edit_abmex
            put :update_ultragate
            patch :update_ultragate
            get :edit_ultragate
            put :update_akta
            patch :update_akta
            put :update_horizon
            patch :update_horizon
            put :update_orla
            patch :update_orla
            get :edit_akta
            get :edit_horizon
            get :edit_orla
            put :update_zoop
            patch :update_zoop
            get :edit_zoop
            put :update_dom_pagamento
            patch :update_dom_pagamento
            get :edit_dom_pagamento
            delete :destroy_pagar_me
            delete :destroy_abmex
            delete :destroy_ultragate
            delete :destroy_akta
            delete :destroy_horizon
            delete :destroy_orla
            delete :destroy_zoop
            delete :destroy_dom_pagamento
            get :toggle
            get :active_pag_seguro
            get :active_mercado_pago
            get :active_pagar_me
            get :active_abmex
            get :active_ultragate
            get :active_akta
            get :active_horizon
            get :active_orla
            get :active_zoop
            get :active_dom_pagamento

            ## Zolluspay
            put :update_beehive
            patch :update_beehive
            get :edit_beehive
            delete :destroy_beehive

            ## Noxpay
            get :active_noxpay
            put :update_noxpay
            patch :update_noxpay
            get :edit_noxpay
            delete :destroy_noxpay

            ## Cashtime
            get :active_cashtime
            put :update_cashtime
            patch :update_cashtime
            get :edit_cashtime
            delete :destroy_cashtime

            ## Zouti
            get :active_zouti
            put :update_zouti
            patch :update_zouti
            get :edit_zouti
            delete :destroy_zouti

            ## Morgan
            get :active_morgan
            put :update_morgan
            patch :update_morgan
            get :edit_morgan
            delete :destroy_morgan

            ## Black X Pay
            get :active_black_x_pay
            put :update_black_x_pay
            patch :update_black_x_pay
            get :edit_black_x_pay
            delete :destroy_black_x_pay

            ## Neverra
            get :active_neverra
            put :update_neverra
            patch :update_neverra
            get :edit_neverra
            delete :destroy_neverra

            ## Mevpay
            get :active_mevpay
            put :update_mevpay
            patch :update_mevpay
            get :edit_mevpay
            delete :destroy_mevpay

            ## Hypepay
            get :active_hypepay
            put :update_hypepay
            patch :update_hypepay
            get :edit_hypepay
            delete :destroy_hypepay

            ## Brazapay
            get :active_brazapay
            put :update_brazapay
            patch :update_brazapay
            get :edit_brazapay
            delete :destroy_brazapay

            ## Abmexpay
            get :active_abmexpay
            put :update_abmexpay
            patch :update_abmexpay
            get :edit_abmexpay
            delete :destroy_abmexpay

## Perplexid
get :active_perplexid
put :update_perplexid
patch :update_perplexid
get :edit_perplexid
delete :destroy_perplexid

## Dora
get :active_dora
put :update_dora
patch :update_dora
get :edit_dora
delete :destroy_dora

## Sprra
get :active_sprra
put :update_sprra
patch :update_sprra
get :edit_sprra
delete :destroy_sprra

## Supercash
get :active_supercash
put :update_supercash
patch :update_supercash
get :edit_supercash
delete :destroy_supercash

## Flyer
get :active_flyer
put :update_flyer
patch :update_flyer
get :edit_flyer
delete :destroy_flyer

## American
get :active_american
put :update_american
patch :update_american
get :edit_american
delete :destroy_american

## Bisonpay
get :active_bisonpay
put :update_bisonpay
patch :update_bisonpay
get :edit_bisonpay
delete :destroy_bisonpay

## Jacaei
get :active_jacaei
put :update_jacaei
patch :update_jacaei
get :edit_jacaei
delete :destroy_jacaei

## Cacapava
get :active_cacapava
put :update_cacapava
patch :update_cacapava
get :edit_cacapava
delete :destroy_cacapava

## Moscouv
get :active_moscouv
put :update_moscouv
patch :update_moscouv
get :edit_moscouv
delete :destroy_moscouv

## Comercialltt
get :active_comercialltt
put :update_comercialltt
patch :update_comercialltt
get :edit_comercialltt
delete :destroy_comercialltt

## Hydrahub
get :active_hydrahub
put :update_hydrahub
patch :update_hydrahub
get :edit_hydrahub
delete :destroy_hydrahub

## Mojee
get :active_mojee
put :update_mojee
patch :update_mojee
get :edit_mojee
delete :destroy_mojee

## Conguz
get :active_conguz
put :update_conguz
patch :update_conguz
get :edit_conguz
delete :destroy_conguz

## Vergonex
get :active_vergonex
put :update_vergonex
patch :update_vergonex
get :edit_vergonex
delete :destroy_vergonex

## Obito
get :active_obito
put :update_obito
patch :update_obito
get :edit_obito
delete :destroy_obito

## Yopa
get :active_yopa
put :update_yopa
patch :update_yopa
get :edit_yopa
delete :destroy_yopa

## Motorola
get :active_motorola
put :update_motorola
patch :update_motorola
get :edit_motorola
delete :destroy_motorola

## Gafe
get :active_gafe
put :update_gafe
patch :update_gafe
get :edit_gafe
delete :destroy_gafe

## Sfsdfs
get :active_sfsdfs
put :update_sfsdfs
patch :update_sfsdfs
get :edit_sfsdfs
delete :destroy_sfsdfs

## Teste
get :active_teste
put :update_teste
patch :update_teste
get :edit_teste
delete :destroy_teste

## Vegapay
get :active_vegapay
put :update_vegapay
patch :update_vegapay
get :edit_vegapay
delete :destroy_vegapay



           ## Payd
            get :active_payd
            put :update_payd
            patch :update_payd
            get :edit_payd
            delete :destroy_payd

            ## Safepay
            get :active_safepay
            put :update_safepay
            patch :update_safepay
            get :edit_safepay
            delete :destroy_safepay

            ## Zenith
            get :active_zenith
            put :update_zenith
            patch :update_zenith
            get :edit_zenith
            delete :destroy_zenith

            ## Dragonpay
            get :active_dragon_pay
            put :update_dragon_pay
            patch :update_dragon_pay
            get :edit_dragon_pay
            delete :destroy_dragon_pay

            ## Innovepay
            get :active_innovepay
            put :update_innovepay
            patch :update_innovepay
            get :edit_innovepay
            delete :destroy_innovepay

            ## Unicopay
            get :active_unicopay
            put :update_unicopay
            patch :update_unicopay
            get :edit_unicopay
            delete :destroy_unicopay

            ## Maxpay
            get :active_maxpay
            put :update_maxpay
            patch :update_maxpay
            get :edit_maxpay
            delete :destroy_maxpay

            ## Cashfy
            get :active_cashfy
            put :update_cashfy
            patch :update_cashfy
            get :edit_cashfy
            delete :destroy_cashfy

            ## AxionPay
            get :active_axionpay
            put :update_axionpay
            patch :update_axionpay
            get :edit_axionpay
            delete :destroy_axionpay

            ## Soutpay
            get :active_soutpay
            put :update_soutpay
            patch :update_soutpay
            get :edit_soutpay
            delete :destroy_soutpay

            ## Bestfy
            get :active_bestfy
            put :update_bestfy
            patch :update_bestfy
            get :edit_bestfy
            delete :destroy_bestfy

            ## BlackBullPay
            get :active_black_bull_pay
            put :update_black_bull_pay
            patch :update_black_bull_pay
            get :edit_black_bull_pay
            delete :destroy_black_bull_pay

            ## Centrapay
            get :active_centrapay
            put :update_centrapay
            patch :update_centrapay
            get :edit_centrapay
            delete :destroy_centrapay

            ## Paguemais
            get :active_paguemais
            put :update_paguemais
            patch :update_paguemais
            get :edit_paguemais
            delete :destroy_paguemais

            ## Rawart
            get :active_rawart
            put :update_rawart
            patch :update_rawart
            get :edit_rawart
            delete :destroy_rawart

            ## Summitpay
            get :active_summitpay
            put :update_summitpay
            patch :update_summitpay
            get :edit_summitpay
            delete :destroy_summitpay

            ## Cashfypaga
            get :active_cashfypaga
            put :update_cashfypaga
            patch :update_cashfypaga
            get :edit_cashfypaga
            delete :destroy_cashfypaga

            ## Wishpag
            get :active_wishpag
            put :update_wishpag
            patch :update_wishpag
            get :edit_wishpag
            delete :destroy_wishpag

            ## Proxypay
            get :active_proxypay
            put :update_proxypay
            patch :update_proxypay
            get :edit_proxypay
            delete :destroy_proxypay

            ## Royalfy
            get :active_royalfy
            put :update_royalfy
            patch :update_royalfy
            get :edit_royalfy
            delete :destroy_royalfy

            ## ZyonPay
            get :active_zyon_pay
            put :update_zyon_pay
            patch :update_zyon_pay
            get :edit_zyon_pay
            delete :destroy_zyon_pay

            ## Tryplopay
            get :active_tryplopay
            put :update_tryplopay
            patch :update_tryplopay
            get :edit_tryplopay
            delete :destroy_tryplopay

            ## Eskypay
            get :active_eskypay
            put :update_eskypay
            patch :update_eskypay
            get :edit_eskypay
            delete :destroy_eskypay

            ## Dropipay
            get :active_dropipay
            put :update_dropipay
            patch :update_dropipay
            get :edit_dropipay
            delete :destroy_dropipay

            #Abypay
            get :active_abypay
            put :update_abypay
            patch :update_abypay
            get :edit_abypay
            delete :destroy_abypay

            #Paggopay
            get :active_paggopay
            put :update_paggopay
            patch :update_paggopay
            get :edit_paggopay
            delete :destroy_paggopay

            #Quantum
            get :active_quantum
            put :update_quantum
            patch :update_quantum
            get :edit_quantum
            delete :destroy_quantum

            ##Skalepay
            get :active_skalepay
            put :update_skalepay
            patch :update_skalepay
            get :edit_skalepay
            delete :destroy_skalepay

            #Dorapag
            get :active_dorapag
            put :update_dorapag
            patch :update_dorapag
            get :edit_dorapag
            delete :destroy_dorapag

            #Pagdrop
            get :active_pagdrop
            put :update_pagdrop
            patch :update_pagdrop
            get :edit_pagdrop
            delete :destroy_pagdrop

            #Monezopay
            get :active_monezopay
            put :update_monezopay
            patch :update_monezopay
            get :edit_monezopay
            delete :destroy_monezopay

            ## Aurapay
            get :active_aurapay
            put :update_aurapay
            patch :update_aurapay
            get :edit_aurapay
            delete :destroy_aurapay

            ## Apexpy
            get :active_apexpy
            put :update_apexpy
            patch :update_apexpy
            get :edit_apexpy
            delete :destroy_apexpy

            ## Justpay
            get :active_justpay
            put :update_justpay
            patch :update_justpay
            get :edit_justpay
            delete :destroy_justpay

            ## Guardpay
            get :active_guardpay
            put :update_guardpay
            patch :update_guardpay
            get :edit_guardpay
            delete :destroy_guardpay

            ## Elitepay
            get :active_elitepay
            put :update_elitepay
            patch :update_elitepay
            get :edit_elitepay
            delete :destroy_elitepay

            ## Syfra
            get :active_syfra
            put :update_syfra
            patch :update_syfra
            get :edit_syfra
            delete :destroy_syfra

            ## Loftpay
            get :active_loftpay
            put :update_loftpay
            patch :update_loftpay
            get :edit_loftpay
            delete :destroy_loftpay

            ## Podpay
            get :active_podpay
            put :update_podpay
            patch :update_podpay
            get :edit_podpay
            delete :destroy_podpay

            ## Novak
            get :active_novak
            put :update_novak
            patch :update_novak
            get :edit_novak
            delete :destroy_novak

            ## Freepay
            get :active_freepay
            put :update_freepay
            patch :update_freepay
            get :edit_freepay
            delete :destroy_freepay

            ## Pigpay
            get :active_pigpay
            put :update_pigpay
            patch :update_pigpay
            get :edit_pigpay
            delete :destroy_pigpay

            ## Midaspag
            get :active_midaspag
            put :update_midaspag
            patch :update_midaspag
            get :edit_midaspag
            delete :destroy_midaspag

            ## Aureolink
            get :active_aureolink
            put :update_aureolink
            patch :update_aureolink
            get :edit_aureolink
            delete :destroy_aureolink

            ## LunarCash
            get :active_lunar_cash
            put :update_lunar_cash
            patch :update_lunar_cash
            get :edit_lunar_cash
            delete :destroy_lunar_cash

            ## Alcateia
            get :active_alcateiapay
            put :update_alcateiapay
            patch :update_alcateiapay
            get :edit_alcateiapay
            delete :destroy_alcateiapay

            ## Dubaipay
            get :active_dubaipay
            put :update_dubaipay
            patch :update_dubaipay
            get :edit_dubaipay
            delete :destroy_dubaipay

            ## Astrumapay
            get :active_astrumpay
            put :update_astrumpay
            patch :update_astrumpay
            get :edit_astrumpay
            delete :destroy_astrumpay

            ## TropicalPagamentos
            get :active_tropical_pagamentos
            put :update_tropical_pagamentos
            patch :update_tropical_pagamentos
            get :edit_tropical_pagamentos
            delete :destroy_tropical_pagamentos

            ## Azcend
            get :active_azcend
            put :update_azcend
            patch :update_azcend
            get :edit_azcend
            delete :destroy_azcend

            ## CashtimePay
            get :active_cashtime_pay
            put :update_cashtime_pay
            patch :update_cashtime_pay
            get :edit_cashtime_pay
            delete :destroy_cashtime_pay

            ##DorapagPay
            get :active_dorapag_pay
            put :update_dorapag_pay
            patch :update_dorapag_pay
            get :edit_dorapag_pay
            delete :destroy_dorapag_pay

            ## Aionpay
            get :active_aionpay
            put :update_aionpay
            patch :update_aionpay
            get :edit_aionpay
            delete :destroy_aionpay

            ## DomPagamentos V3
            get :active_dom_pagamentos_v3
            put :update_dom_pagamentos_v3
            patch :update_dom_pagamentos_v3
            get :edit_dom_pagamentos_v3
            delete :destroy_dom_pagamentos_v3

            ## Venuzpay
            get :active_venuzpay
            put :update_venuzpay
            patch :update_venuzpay
            get :edit_venuzpay
            delete :destroy_venuzpay

            ## Bynet
            get :active_bynet
            put :update_bynet
            patch :update_bynet
            get :edit_bynet
            delete :destroy_bynet

            ## Horuspay
            get :active_horuspay
            put :update_horuspay
            patch :update_horuspay
            get :edit_horuspay
            delete :destroy_horuspay
            ## Dubpay
            get :active_dubpay
            put :update_dubpay
            patch :update_dubpay
            get :edit_dubpay
            delete :destroy_dubpay

            ## AzPagamentos
            get :active_az_pagamentos
            put :update_az_pagamentos
            patch :update_az_pagamentos
            get :edit_az_pagamentos
            delete :destroy_az_pagamentos

            ## Aprovepay
            get :active_aprovepay
            put :update_aprovepay
            patch :update_aprovepay
            get :edit_aprovepay
            delete :destroy_aprovepay

            ## Maxpay V2
            get :active_maxpay_v2
            put :update_maxpay_v2
            patch :update_maxpay_v2
            get :edit_maxpay_v2
            delete :destroy_maxpay_v2config/routes

            ## Pulse Pag
            get :active_pulse_pag
            put :update_pulse_pag
            patch :update_pulse_pag
            get :edit_pulse_pag
            delete :destroy_pulse_pag

            ## Armpay
            get :active_armpay
            put :update_armpay
            patch :update_armpay
            get :edit_armpay
            delete :destroy_armpay

            ## Kiter Cash
            get :active_kitercash
            put :update_kitercash
            patch :update_kitercash
            get :edit_kitercash
            delete :destroy_kitercash


            ## Almighty Pay
            get :active_almighty_pay
            put :update_almighty_pay
            patch :update_almighty_pay
            get :edit_almighty_pay
            delete :destroy_almighty_pay

            ## Pay Sak
            get :active_paysak
            put :update_paysak
            patch :update_paysak
            get :edit_paysak
            delete :destroy_paysak

            ## Paguex
            get :active_paguex
            put :update_paguex
            patch :update_paguex
            get :edit_paguex
            delete :destroy_paguex
        
            ## MpPagamentos
            get :active_mp_pagamentos
            put :update_mp_pagamentos
            patch :update_mp_pagamentos
            get :edit_mp_pagamentos
            delete :destroy_mp_pagamentos
             
            ## Elysiumpay
             get :active_elysiumpay
             put :update_elysiumpay
             patch :update_elysiumpay
             get :edit_elysiumpay
             delete :destroy_elysiumpay
           end
        end




        namespace :shopify do
          get '', action: 'index'
          get '/form', action: 'form'
          put '/save', action: 'update'
          get '/themes/new', action: 'theme_new'
          get '/themes/create', action: 'link_theme'
          get '/themes/edit', action: 'theme_edit'
          post '/themes', action: 'theme_create'
          put '/themes', action: 'theme_update'
          get '/rollback', action: 'rollback_theme'
          get '/check_active', action: 'check_active'
          put '/destroy', action: 'destroy'
          get '/reimport_info', action: 'reimport_info'
        end

        namespace :reward_stores do
          get '', action: :index
        end

        namespace :stamps do
          get '', action: :index
        end

        namespace :woocommerce do
          get '', action: 'index'
          get '/form', action: 'form'
          put '/save', action: 'update'
          get '/check_active', action: 'check_active'
          put '/destroy', action: 'destroy'
        end

        namespace :utmify do
          get '/form', action: 'form'
          put '/save', action: 'upsert'
          get :step
        end
        resources :utmify do
          get '', action: 'index'
          delete :utmify, on: :member
        end
        resources :utmify do
          get '', action: 'index'
          delete :utmify, on: :member
        end

        resources :smsfunnel_configs

        namespace :theme_solicitation do
          post '/', action: 'create'
        end

        resources :sections do
          member do
            put :toggle
            put :select
            get :remove_image
            put :show_menu
          end
        end

        resources :landing_pages do
          member do
            post :duplicate
            get :editor
          end
        end

        resources :checkouts, only: [] do
          collection do
            get :social_proofs
            get :payments
            get :rules
            get :discounts
            get :redirects
          end
        end

        resources :checkout_configs, except: %i[destroy]
        resources :store_settings

        resources :marketing, only: [] do
          collection do
            get :discounts
            get :pixels
            get :upsells
          end
        end

        resources :orders do
          member do
            post :resend_emails
            put :update_tracking
            put :update_address
            put :update_stage
            put :cancel_order
            get :show_qrcode
          end

          collection do
            get :abandoned_cars
            get :pending_bank_slips
            get :paid_bank_slips
            get :pending_pix
            post :orders_csv
            get :render_export_modal
          end
        end

        resources :products do
          resources :variations, controller: 'products/variations' do
            member do
              get :images
              get :toggle
            end
          end

          collection do
            get :categories
            get :brands
          end

          member do
            get :images
            get :toggle
            get :send_email
            patch :save_send_email
          end
        end

        resources :reports, only: [] do
          collection do
            get :sales_by_product
            get :sales_by_upsell
            get :sales_by_period
            get :sales_by_gateway
          end
        end

        resources :subscriptions do
          collection do
            get :plans
            get :payment
            get :change_plan
            get :confirm_change_plan
            get :edit_data
            get :suspend
            post :suspend_subscription
            post :reactive_subscription
            get :reactive
            get :open_modal_suspended
            get :cancel_scheduled
          end

          member do
            delete :destroy_card
          end
        end

        resources :invoices do
          collection do
            get :payment_pix_data
            get :edit_payment_data
            get :pay
          end
        end

        resources :pages, only: [] do
          collection do
            get :shopify_help
            get :woocommerce_help
            get :zip_plugin_woocommerce
            get :duplicate_button_shopify_help
            get :pixel_facebook_help
            get :pixel_facebook_api_help
            get :google_help
            get :tiktok_help
            get :kwai_help
          end
        end

        get 'ranking/edit_avatar', to: 'ranking#edit_avatar'
        resources :ranking do
          collection do
            match 'search' => 'ranking#search', via: [:get, :post], as: :search
          end
        end
      end
    end
  end
end
