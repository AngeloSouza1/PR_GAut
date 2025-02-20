# ApiRoutes
module ApiRoutes
  def self.extended(router)
    router.instance_exec do
      namespace :api do
        post '/login' => 'sessions#signin'

        get '/auth' => 'users#get_user'
        post '/sign_up' => 'users#create'
        put '/users' => 'users#update_user'
        delete 'users/:id' => 'users#destroy'

        # get '/check_proxy_domain/:token', to: 'domains#check_proxy_domain'
        # patch '/domains/:id/verify', to: 'domains#verify'
        # get '/domains/:id/excluded', to: 'domains#excluded'

        namespace :v1 do
          get '/orders/dashboard' => 'orders#dashboard'
          resources :orders
          resources :stores

          get '/variations/:id' => 'variations#index'
          post '/shopify/cart' => 'shopify/cart#index'

          resources :searches, only: [] do
            collection do
              get :brands
              get :categories
              get :grids
            end
          end

          resource :datalayer, only: [:show]

          namespace :webhook do
            namespace :shopify do
              post 'bulk_operation', to: 'bulk_operations#prosecute'
              post 'customers/create', to: 'customers#create'
              post 'customers/update', to: 'customers#update'
              post 'products/create', to: 'products#create'
              post 'products/update', to: 'products#update'
              post 'products/delete', to: 'products#delete'
              post 'orders/create', to: 'orders#create'
              post 'orders/updated', to: 'orders#updated'
              post 'orders/cancelled', to: 'orders#cancelled'
              post 'order_transactions/create', to: 'order_transactions#create'
            end

            namespace :woocommerce do
              post 'customer/created', to: 'customers#created'
              post 'customer/updated', to: 'customers#updated'
              post 'product/created', to: 'products#created'
              post 'product/updated', to: 'products#updated'
              post 'product/deleted', to: 'products#deleted'
              post 'order/created', to: 'orders#created'
              post 'order/updated', to: 'orders#updated'
              post 'order/deleted', to: 'orders#deleted'
            end

            namespace :asaas do
              post 'payments', to: 'payments#update'
            end

            namespace :mercado_pago do
              post 'payments', to: 'payments#update'
            end

            namespace :pag_seguro do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :pagar_me do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :abmex do
              get 'subscriptions', to: 'subscriptions#update'
              post 'subscriptions', to: 'subscriptions#update'
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :akta do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :horizon do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :orla do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :dom_pagamento do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :zoop do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :ultragate do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :zolluspay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :morganpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :arkama do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :noxpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :cashtime do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :beehive do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :zouti do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :morgan do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :black_x_pay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :neverra do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :mevpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :hypepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :brazapay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :whitemex do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :abmexpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :payd do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :safepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :zenith do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :dragon_pay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :innovepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :unicopay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :maxpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :cashfy do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :axionpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :soutpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :bestfy do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :paguemais do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :rawart do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :cashfypaga do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :black_bull_pay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :centrapay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            namespace :summitpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :wishpag do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :proxypay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :royalfy do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :zyonpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :tryplopay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :eskypay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :dropipay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end
            
            namespace :monezopay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end


            namespace :abypay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :paggopay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :skalepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :quantum do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :dorapag do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :titanshub do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :aurapay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :pagdrop do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :mozenopay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end  

            namespace :justpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :guardpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :elitepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :syfra do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :loftpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :podpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :novak do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :freepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :aureolink do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :midaspag do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :aprovepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :apexpy do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :tropicalpagamentos do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :lunarcash do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :alcateiapay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :dubaipay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :astrumpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :azcend do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :dorapagpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :cashtimepay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :aionpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :dom_pagamentos_v3 do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :venuzpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :dubpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :bynet do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :azpagamentos do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :horuspay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :pulse_pag do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :armpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :almighty_pay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :paysak do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :maxpay_v2 do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :kitercash do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :paguex do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :pay2flow do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :elysiumpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :pigpay do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

            namespace :mppagamentos do
              get 'payments', to: 'payments#update'
              post 'payments', to: 'payments#update'
            end

namespace :vegapay do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :teste do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :sfsdfs do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :gafe do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :motorola do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :yopa do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :obito do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :vergonex do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :conguz do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :mojee do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :hydrahub do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :comercialltt do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :moscouv do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :cacapava do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :jacaei do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :bisonpay do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :american do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :flyer do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :supercash do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :sprra do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :dora do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
namespace :perplexid do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
end
          get 'document/:token/download', to: 'documents#download', as: :document_download
        end

        root to: 'domains#index'
      end
    end
  end
end
