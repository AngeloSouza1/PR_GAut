class Store::GatewaysController < StoreController
  include VerifyRegisterCompleted
  include InputHelper
  rescue_from Timeout::Error, with: :handle_timeout
  # rescue_from StandardError, with: :handle_standard_error

  #
  # Extract me to a plugin please :)
  #
  class << self
    def has_integrations(arr = [])
      arr.each do |integration|
        xpto = integration.underscore

        #
        # def set_store_<integration>_gateway
        #   @<integration>_config = <integration>Config.where(store_id: @store.id).friendly.find(params[:id])
        # end
        #
        # private :set_store_<integration>_gateway
        #
        set_store_xpto_gateway = :"set_store_#{xpto}_gateway"
        define_method "set_store_#{xpto}_gateway" do
          var = "@#{xpto}_config"
          config_class = "#{integration}Config".constantize
          instance_variable_set var, config_class.where(store_id: @store.id).friendly.find(params[:id])
        end
        instance_eval { private set_store_xpto_gateway }

        #
        # def <integration>_config_params
        #   params.require(:arkama_config).permit!
        # end
        #
        # private :<integration>_config_params
        #
        xpto_config_params = :"#{xpto}_config_params"
        define_method xpto_config_params do
          @gateway = xpto
          params.require("#{xpto}_config".to_sym).permit!
        end
        instance_eval { private xpto_config_params }

        #
        # def edit_<integration>
        #   render :edit
        # end
        #
        define_method :"edit_#{xpto}" do
          @gateway = xpto
          render :edit
        end

        #
        # def update_<integration>
        #  respond_to do |format|
        #    if @<integration>_config.update(<integration>_config_params)
        #      update_gateway_configs_status(@<integration>_config)
        #      format.html { redirect_to store_gateways_url, notice: "Salvo com sucesso." }
        #      format.json { render :show, status: :ok, location: @<integration>_config }
        #    else
        #      format.html { render :edit, status: :unprocessable_entity }
        #      format.json { render json: @<integration>_config.errors, status: :unprocessable_entity }
        #    end
        #  end
        # end
        #
        define_method :"update_#{xpto}" do
          config_instance = instance_variable_get "@#{xpto}_config"
          @gateway = xpto

          respond_to do |format|
            convert_rate_param_value(:"#{xpto}_config")

            if config_instance.update(send(:"#{xpto}_config_params"))
              update_gateway_configs_status(config_instance)
              format.html { redirect_to store_gateways_url, notice: "Salvo com sucesso." }
              format.json { render :show, status: :ok, location: config_instance }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: config_instance.errors, status: :unprocessable_entity }
            end
          end
        end

        #
        # def destroy_<integration>
        #   @<integration>_config.destroy
        #
        #   respond_to do |format|
        #     format.html { redirect_to store_gateways_url, notice: "Deletado com sucesso." }
        #     format.json { head :no_content }
        #   end
        # end
        #
        define_method "destroy_#{xpto}".to_sym do
          if (instance_variable_get "@#{xpto}_config").destroy
            respond_to do |format|
              format.html { redirect_to store_gateways_url, notice: "Deletado com sucesso." }
              format.json { head :no_content }
            end
          else
            respond_to do |format|
              format.html { redirect_to store_gateways_url, error: "Não foi possível excluir este gateway." }
              format.json { head :no_content }
            end
          end
        end

        #
        # def active_<integration>
        #   respond_to do |format|
        #     if @<integration>_config.update(active: true)
        #       Store::INTEGRATIONS.each do |integration|
        #         name = integration.underscore
        #         next if name == "<integration>"
        #         config_instance = @store.send(:"#{integration.underscore}_config")
        #         if config_instance.present?
        #           config_instance.update(active: false)
        #           update_gateway_configs_status(config_instance)
        #         end
        #       end
        #       update_gateway_configs_status(@<integration>_config)
        #       format.html { redirect_to store_gateways_url, notice: "Ativo com sucesso." }
        #       format.json { render :show, status: :ok, location: @<integration>_config }
        #     else
        #       format.html { redirect_to store_gateways_url, error: @<integration>_config.errors.full_messages.join('; ') }
        #       format.json { render json: @<integration>_config.errors, status: :unprocessable_entity }
        #     end
        #   end
        # end
        #
        define_method :"active_#{xpto}" do
          xpto_config = instance_variable_get("@#{xpto}_config")
          respond_to do |format|
            if xpto_config.update(active: true)
              Store::INTEGRATIONS.each do |integration|
                name = integration.underscore
                next if name == xpto
                config_instance = @store.send(:"#{name}_config")
                if config_instance.present?
                  config_instance.update(active: false)
                  update_gateway_configs_status(config_instance)
                end
              end
              update_gateway_configs_status(xpto_config)
              format.html { redirect_to store_gateways_url, notice: "Ativo com sucesso." }
              format.json { render :show, status: :ok, location: xpto_config }
            else
              format.html { redirect_to store_gateways_url, error: xpto_config.errors.full_messages.join('; ') }
              format.json { render json: xpto_config.errors, status: :unprocessable_entity }
            end
          end
        end

        send :before_action, set_store_xpto_gateway,
          only: ["show", "edit_#{xpto}", "update_#{xpto}", "destroy_#{xpto}", "active_#{xpto}"].collect(&:to_sym)
      end
    end
  end

  has_integrations Store::INTEGRATIONS

  before_action :set_store_gateway, only: %i[show edit update destroy active_mercado_pago]
  before_action :verify_redirection_after_register, only: %i[new]
  before_action :redirect_if_not_subscriptions

  # GET /store/gateways or /store/gateways.json
  def index
    #
    # @<integration>_configs = <integration>Config.where(store_id: @store.id)
    #
    @integrations = []
    Store::INTEGRATIONS.each do |integration|
      var = "@#{integration.underscore}_configs"
      config_class = "#{integration}Config".constantize
      instance_variable_set var, config_class.where(store_id: @store.id)
      @integrations << var
    end
  end

  # GET /store/gateways/1 or /store/gateways/1.json
  def show; end

  # GET /store/gateways/new
  def new
    #
    # @<integration>_config = <integration>Config.new if <integration>Config.where(store_id: @store.id).empty?
    #
    gateways = Gateway.all
    @gateways_client = []
    gateways.each do |gateway|
      if @store.client.send(:"has_#{gateway.name.underscore&.to_sym.to_s}?")
        @gateways_client << gateway unless @store.gateway_integrations.include?(gateway.name)
      end
    end

    Store::INTEGRATIONS.each do |integration|
      var = "@#{integration.underscore}_config"
      config_class = "#{integration}Config".constantize
      instance_variable_set var, config_class.new if config_class.where(store_id: @store.id).empty?
    end

    if @black_bull_pay_config.present?
      11.times {|i| @black_bull_pay_config.taxes.build(number: i+1) }
    end
  end

  # GET /store/gateways/1/edit
  def edit
    @gateway = 'mercado_pago'
  end

  # POST /store/gateways or /store/gateways.json
  def create
    @mercado_pago_config = MercadoPagoConfig.new(mercado_pago_config_params)
    @mercado_pago_config.store_id = @store.id

    if @mercado_pago_config.valid?
      @store.deactivate_all_integrations!
      @mercado_pago_config.save
      update_gateway_configs_status(@mercado_pago_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_pag_seguro
    @pag_seguro_config = PagSeguroConfig.new(pag_seguro_config_params)
    @pag_seguro_config.store_id = @store.id

    if @pag_seguro_config.valid?
      @store.deactivate_all_integrations!
      @pag_seguro_config.save
      update_gateway_configs_status(@pag_seguro_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_pagar_me
    convert_rate_param_value(:pagar_me_config)

    @pagar_me_config = PagarMeConfig.new(pagar_me_config_params)
    @pagar_me_config.store_id = @store.id

    if @pagar_me_config.valid?
      @store.deactivate_all_integrations!
      @pagar_me_config.save
      update_gateway_configs_status(@pagar_me_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_abmex
    convert_rate_param_value(:abmex_config)

    @abmex_config = AbmexConfig.new(abmex_config_params)
    @abmex_config.store_id = @store.id

    if @abmex_config.valid? && Abmex::Customer::List.call(@abmex_config).success?
      @store.deactivate_all_integrations!
      @abmex_config.save
      update_gateway_configs_status(@abmex_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_akta
    convert_rate_param_value(:akta_config)

    @akta_config = AktaConfig.new(akta_config_params)
    @akta_config.store_id = @store.id

    akta_rates = Akta::Installment::GetByApi.call(@akta_config)

    if @akta_config.valid? && akta_rates.present?
      @store.deactivate_all_integrations!
      @akta_config.save
      update_gateway_configs_status(@akta_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_horizon
    convert_rate_param_value(:horizon_config)

    @horizon_config = HorizonConfig.new(horizon_config_params)
    @horizon_config.store_id = @store.id

    akta_rates = Akta::Installment::GetByApi.call(@horizon_config)

    if @horizon_config.valid? && akta_rates.present?
      @store.deactivate_all_integrations!
      @horizon_config.save
      update_gateway_configs_status(@horizon_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_orla
    convert_rate_param_value(:orla_config)

    @orla_config = OrlaConfig.new(orla_config_params)
    @orla_config.store_id = @store.id

    akta_rates = Akta::Installment::GetByApi.call(@orla_config)

    if @orla_config.valid? && akta_rates.present?
      @store.deactivate_all_integrations!
      @orla_config.save
      update_gateway_configs_status(@orla_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_dom_pagamento
    convert_rate_param_value(:dom_pagamento_config)

    @dom_pagamento_config = DomPagamentoConfig.new(dom_pagamento_config_params)
    @dom_pagamento_config.store_id = @store.id

    akta_rates = Akta::Installment::GetByApi.call(@dom_pagamento_config)

    if @dom_pagamento_config.valid? && akta_rates.present?
      @store.deactivate_all_integrations!
      @dom_pagamento_config.save
      update_gateway_configs_status(@dom_pagamento_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_noxpay
    @noxpay_config = NoxpayConfig.new(noxpay_config_params)
    @noxpay_config.store_id = @store.id
    begin
      akta_rates = Akta::Installment::GetByApi.call(@noxpay_config)

      if @noxpay_config.valid? && akta_rates.present?
        @store.deactivate_all_integrations!
        @noxpay_config.save
        update_gateway_configs_status(@noxpay_config)
        redirect_to store_gateways_url, notice: "Salvo com sucesso."
      else
        flash[:error] = "Chave Inválida"
        render :new, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "FAILED TO CREATE NOXPAY -- MESSAGE: #{e.message} -- CAUSE: #{e.cause}"
      flash[:error] = "Não foi possível estabelecer uma conexão com o gateway"
      render :new, status: :unprocessable_entity
    end
  end

  def create_beehive
    convert_rate_param_value(:beehive_config)

    @beehive_config = BeehiveConfig.new(beehive_config_params)
    @beehive_config.store_id = @store.id
    begin
      akta_rates = Akta::Installment::GetByApi.call(@beehive_config)

      if @beehive_config.valid? && akta_rates.present?
        @store.deactivate_all_integrations!
        @beehive_config.save
        update_gateway_configs_status(@beehive_config)
        redirect_to store_gateways_url, notice: "Salvo com sucesso."
      else
        flash[:error] = "Chave Inválida"
        render :new, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "FAILED TO CREATE BEEHIVE -- MESSAGE: #{e.message} -- CAUSE: #{e.cause}"
      flash[:error] = "Não foi possível estabelecer uma conexão com o gateway"
      render :new, status: :unprocessable_entity
    end
  end

  def create_cashtime
    convert_rate_param_value(:cashtime_config)
    @cashtime_config = CashtimeConfig.new(cashtime_config_params)
    @cashtime_config.store_id = @store.id
    begin
      akta_rates = Akta::Installment::GetByApi.call(@cashtime_config)

      if @cashtime_config.valid? && akta_rates.present?
        @store.deactivate_all_integrations!
        Rails.logger.info "SAVE"
        @cashtime_config.save
        update_gateway_configs_status(@cashtime_config)
        redirect_to store_gateways_url, notice: "Salvo com sucesso."
      else
        flash[:error] = "Chave Inválida"
        render :new, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "FAILED TO CREATE CASHTIME -- MESSAGE: #{e.message} -- CAUSE: #{e.cause}"
      flash[:error] = "Não foi possível estabelecer uma conexão com o gateway"
      render :new, status: :unprocessable_entity
    end
  end

  def create_zouti
    @zouti_config = ZoutiConfig.new(zouti_config_params)
    @zouti_config.store_id = @store.id
    begin
      akta_rates = Akta::Installment::GetByApi.call(@zouti_config)

      if @zouti_config.valid? && akta_rates.present?
        @store.deactivate_all_integrations!
        @zouti_config.save
        update_gateway_configs_status(@zouti_config)
        redirect_to store_gateways_url, notice: "Salvo com sucesso."
      else
        flash[:error] = "Chave Inválida"
        render :new, status: :unprocessable_entity
      end
    rescue => e
      Rails.logger.error "FAILED TO CREATE ZOUTI -- MESSAGE: #{e.message} -- CAUSE: #{e.cause}"
      flash[:error] = "Não foi possível estabelecer uma conexão com o gateway"
      render :new, status: :unprocessable_entity
    end
  end

  def create_zoop
    convert_rate_param_value(:zoop_config)

    @zoop_config = ZoopConfig.new(zoop_config_params)
    @zoop_config.store_id = @store.id

    if @zoop_config.valid?
      @store.deactivate_all_integrations!
      @zoop_config.save
      update_gateway_configs_status(@zoop_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_ultragate
    convert_rate_param_value(:ultragate_config)

    @ultragate_config = UltragateConfig.new(ultragate_config_params)
    @ultragate_config.store_id = @store.id

    if @ultragate_config.valid?
      @store.deactivate_all_integrations!
      @ultragate_config.save
      update_gateway_configs_status(@ultragate_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_neverra
    convert_rate_param_value(:neverra_config)

    @neverra_config = NeverraConfig.new(neverra_config_params)
    @neverra_config.store_id = @store.id

    if @neverra_config.valid?
      @store.deactivate_all_integrations!
      @neverra_config.save
      update_gateway_configs_status(@neverra_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  rescue => e
    flash.now[:error] = "Não foi possível estabelecer uma conexão com o gateway. (#{e.message})"
    render :new, status: :service_unavailable
  end

  def create_zolluspay
    convert_rate_param_value(:zolluspay_config)

    @zolluspay_config = ZolluspayConfig.new(zolluspay_config_params)
    @zolluspay_config.store_id = @store.id

    if @zolluspay_config.valid? && Zolluspay::Ping.call(@zolluspay_config)
      @store.deactivate_all_integrations!
      @zolluspay_config.save
      update_gateway_configs_status(@zolluspay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_morgan
    convert_rate_param_value(:morgan_config)

    @morgan_config = MorganConfig.new(morgan_config_params)
    @morgan_config.store_id = @store.id

    result = Morgan::Ping.call(@morgan_config)

    unless result.success?
      flash.now[:error] = t(result.message_key)
      render :new and return
    end

    begin
      if @morgan_config.valid?
        @store.deactivate_all_integrations!
        @morgan_config.save

        #Criando produtos da loja na morgan pay, obs: alterar para perform_later
        Morgan::Product::CreateJob.perform_now(@morgan_config, @store)

        update_gateway_configs_status(@morgan_config)
        redirect_to store_gateways_url, notice: "Salvo com sucesso."
      else
        render :new, status: :unprocessable_entity
      end
    rescue => e
      flash.now[:error] = "Não foi possível estabelecer uma conexão com o gateway"
      render :new, status: :service_unavailable
    end
  end

  def create_morganpay
    @morganpay_config = MorganpayConfig.new(morganpay_config_params)
    @morganpay_config.store_id = @store.id

    if @morganpay_config.valid?
      @store.deactivate_all_integrations!
      @morganpay_config.save
      update_gateway_configs_status(@morganpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_black_x_pay
    @black_x_pay_config = BlackXPayConfig.new(black_x_pay_config_params)
    @black_x_pay_config.store_id = @store.id
    @black_x_pay_config.installments = 1

    if @black_x_pay_config.valid?
      @store.deactivate_all_integrations!
      @black_x_pay_config.save
      update_gateway_configs_status(@black_x_pay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_arkama
    @arkama_config = ArkamaConfig.new(arkama_config_params)
    @arkama_config.store_id = @store.id

    if @arkama_config.valid?
      @store.deactivate_all_integrations!
      @arkama_config.save
      update_gateway_configs_status(@arkama_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash[:error] = "Chave Inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_abmexpay
    @abmexpay_config = AbmexpayConfig.new(abmexpay_config_params)
    @abmexpay_config.store_id = @store.id

    if @abmexpay_config.valid?
      @store.deactivate_all_integrations!
      @abmexpay_config.save
      update_gateway_configs_status(@abmexpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_perplexid
    @perplexid_config = PerplexidConfig.new(perplexid_config_params)
    @perplexid_config.store_id = @store.id

    if @perplexid_config.valid?
      @store.deactivate_all_integrations!
      @perplexid_config.save
      update_gateway_configs_status(@perplexid_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_dora
    @dora_config = DoraConfig.new(dora_config_params)
    @dora_config.store_id = @store.id

    if @dora_config.valid?
      @store.deactivate_all_integrations!
      @dora_config.save
      update_gateway_configs_status(@dora_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_sprra
    @sprra_config = SprraConfig.new(sprra_config_params)
    @sprra_config.store_id = @store.id

    if @sprra_config.valid?
      @store.deactivate_all_integrations!
      @sprra_config.save
      update_gateway_configs_status(@sprra_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_supercash
    @supercash_config = SupercashConfig.new(supercash_config_params)
    @supercash_config.store_id = @store.id

    if @supercash_config.valid?
      @store.deactivate_all_integrations!
      @supercash_config.save
      update_gateway_configs_status(@supercash_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_flyer
    @flyer_config = FlyerConfig.new(flyer_config_params)
    @flyer_config.store_id = @store.id

    if @flyer_config.valid?
      @store.deactivate_all_integrations!
      @flyer_config.save
      update_gateway_configs_status(@flyer_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_american
    @american_config = AmericanConfig.new(american_config_params)
    @american_config.store_id = @store.id

    if @american_config.valid?
      @store.deactivate_all_integrations!
      @american_config.save
      update_gateway_configs_status(@american_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_bisonpay
    @bisonpay_config = BisonpayConfig.new(bisonpay_config_params)
    @bisonpay_config.store_id = @store.id

    if @bisonpay_config.valid?
      @store.deactivate_all_integrations!
      @bisonpay_config.save
      update_gateway_configs_status(@bisonpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_jacaei
    @jacaei_config = JacaeiConfig.new(jacaei_config_params)
    @jacaei_config.store_id = @store.id

    if @jacaei_config.valid?
      @store.deactivate_all_integrations!
      @jacaei_config.save
      update_gateway_configs_status(@jacaei_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_cacapava
    @cacapava_config = CacapavaConfig.new(cacapava_config_params)
    @cacapava_config.store_id = @store.id

    if @cacapava_config.valid?
      @store.deactivate_all_integrations!
      @cacapava_config.save
      update_gateway_configs_status(@cacapava_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_moscouv
    @moscouv_config = MoscouvConfig.new(moscouv_config_params)
    @moscouv_config.store_id = @store.id

    if @moscouv_config.valid?
      @store.deactivate_all_integrations!
      @moscouv_config.save
      update_gateway_configs_status(@moscouv_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_comercialltt
    @comercialltt_config = ComerciallttConfig.new(comercialltt_config_params)
    @comercialltt_config.store_id = @store.id

    if @comercialltt_config.valid?
      @store.deactivate_all_integrations!
      @comercialltt_config.save
      update_gateway_configs_status(@comercialltt_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_hydrahub
    @hydrahub_config = HydrahubConfig.new(hydrahub_config_params)
    @hydrahub_config.store_id = @store.id

    if @hydrahub_config.valid?
      @store.deactivate_all_integrations!
      @hydrahub_config.save
      update_gateway_configs_status(@hydrahub_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_mojee
    @mojee_config = MojeeConfig.new(mojee_config_params)
    @mojee_config.store_id = @store.id

    if @mojee_config.valid?
      @store.deactivate_all_integrations!
      @mojee_config.save
      update_gateway_configs_status(@mojee_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_conguz
    @conguz_config = ConguzConfig.new(conguz_config_params)
    @conguz_config.store_id = @store.id

    if @conguz_config.valid?
      @store.deactivate_all_integrations!
      @conguz_config.save
      update_gateway_configs_status(@conguz_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_vergonex
    @vergonex_config = VergonexConfig.new(vergonex_config_params)
    @vergonex_config.store_id = @store.id

    if @vergonex_config.valid?
      @store.deactivate_all_integrations!
      @vergonex_config.save
      update_gateway_configs_status(@vergonex_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_obito
    @obito_config = ObitoConfig.new(obito_config_params)
    @obito_config.store_id = @store.id

    if @obito_config.valid?
      @store.deactivate_all_integrations!
      @obito_config.save
      update_gateway_configs_status(@obito_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_yopa
    @yopa_config = YopaConfig.new(yopa_config_params)
    @yopa_config.store_id = @store.id

    if @yopa_config.valid?
      @store.deactivate_all_integrations!
      @yopa_config.save
      update_gateway_configs_status(@yopa_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_gafe
    @gafe_config = GafeConfig.new(gafe_config_params)
    @gafe_config.store_id = @store.id

    if @gafe_config.valid?
      @store.deactivate_all_integrations!
      @gafe_config.save
      update_gateway_configs_status(@gafe_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_sfsdfs
    @sfsdfs_config = SfsdfsConfig.new(sfsdfs_config_params)
    @sfsdfs_config.store_id = @store.id

    if @sfsdfs_config.valid?
      @store.deactivate_all_integrations!
      @sfsdfs_config.save
      update_gateway_configs_status(@sfsdfs_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_teste
    @teste_config = TesteConfig.new(teste_config_params)
    @teste_config.store_id = @store.id

    if @teste_config.valid?
      @store.deactivate_all_integrations!
      @teste_config.save
      update_gateway_configs_status(@teste_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_vegapay
    @vegapay_config = VegapayConfig.new(vegapay_config_params)
    @vegapay_config.store_id = @store.id

    if @vegapay_config.valid?
      @store.deactivate_all_integrations!
      @vegapay_config.save
      update_gateway_configs_status(@vegapay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_motorolapay
    @motorolapay_config = MotorolapayConfig.new(motorolapay_config_params)
    @motorolapay_config.store_id = @store.id

    if @motorolapay_config.valid?
      @store.deactivate_all_integrations!
      @motorolapay_config.save
      update_gateway_configs_status(@motorolapay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_motorla
    @motorla_config = MotorlaConfig.new(motorla_config_params)
    @motorla_config.store_id = @store.id

    if @motorla_config.valid?
      @store.deactivate_all_integrations!
      @motorla_config.save
      update_gateway_configs_status(@motorla_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_motorola
    @motorola_config = MotorolaConfig.new(motorola_config_params)
    @motorola_config.store_id = @store.id

    if @motorola_config.valid?
      @store.deactivate_all_integrations!
      @motorola_config.save
      update_gateway_configs_status(@motorola_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_flexpay
    @flexpay_config = FlexpayConfig.new(flexpay_config_params)
    @flexpay_config.store_id = @store.id

    if @flexpay_config.valid?
      @store.deactivate_all_integrations!
      @flexpay_config.save
      update_gateway_configs_status(@flexpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

def create_bbbb
    @bbbb_config = BbbbConfig.new(bbbb_config_params)
    @bbbb_config.store_id = @store.id

    if @bbbb_config.valid?
      @store.deactivate_all_integrations!
      @bbbb_config.save
      update_gateway_configs_status(@bbbb_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end


def create_pagseg
    @pagseg_config = PagsegConfig.new(pagseg_config_params)
    @pagseg_config.store_id = @store.id

    if @pagseg_config.valid?
      @store.deactivate_all_integrations!
      @pagseg_config.save
      update_gateway_configs_status(@pagseg_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end




  def create_payd
    @payd_config = PaydConfig.new(payd_config_params)
    @payd_config.store_id = @store.id

    if @payd_config.valid?
      @store.deactivate_all_integrations!
      @payd_config.save
      update_gateway_configs_status(@payd_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_almighty_pay
    @almighty_pay_config = AlmightyPayConfig.new(almighty_pay_config_params)
    @almighty_pay_config.store_id = @store.id

    if @almighty_pay_config.valid?
      @store.deactivate_all_integrations!
      @almighty_pay_config.save
      update_gateway_configs_status(@almighty_pay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_paysak
    @paysak_config = PaysakConfig.new(paysak_config_params)
    @paysak_config.store_id = @store.id

    if @paysak_config.valid?
      @store.deactivate_all_integrations!
      @paysak_config.save
      update_gateway_configs_status(@paysak_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end



  def create_monezopay
    @monezopay_config = MonezopayConfig.new(monezopay_config_params)
    @monezopay_config.store_id = @store.id

    if @monezopay_config.valid?
      @store.deactivate_all_integrations!
      @monezopay_config.save
      update_gateway_configs_status(@monezopay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end


  def create_azcend
    @azcend_config = AzcendConfig.new(azcend_config_params)
    @azcend_config.store_id = @store.id

    if @azcend_config.valid?
      @store.deactivate_all_integrations!
      @azcend_config.save
      update_gateway_configs_status(@azcend_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_cashtime_pay
    @cashtime_pay_config = CashtimePayConfig.new(cashtime_pay_config_params)
    @cashtime_pay_config.store_id = @store.id

    if @cashtime_pay_config.valid?
      @store.deactivate_all_integrations!
      @cashtime_pay_config.save
      update_gateway_configs_status(@cashtime_pay_config)
       redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_dorapag_pay
    @dorapag_pay_config = DorapagPayConfig.new(dorapag_pay_config_params)
    @dorapag_pay_config.store_id = @store.id

    if @dorapag_pay_config.valid?
      @store.deactivate_all_integrations!
      @dorapag_pay_config.save
      update_gateway_configs_status(@dorapag_pay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_venuzpay
    @venuzpay_config = VenuzpayConfig.new(venuzpay_config_params)
    @venuzpay_config.store_id = @store.id

    if @venuzpay_config.valid?
      @store.deactivate_all_integrations!
      @venuzpay_config.save
      update_gateway_configs_status(@venuzpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_mp_pagamentos
    @mp_pagamentos_config = MpPagamentosConfig.new(mp_pagamentos_config_params)
    @mp_pagamentos_config.store_id = @store.id

    if @mp_pagamentos_config.valid?
      @store.deactivate_all_integrations!
      @mp_pagamentos_config.save
      update_gateway_configs_status(@mp_pagamentos_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_bynet
    @bynet_config = BynetConfig.new(bynet_config_params)
    @bynet_config.store_id = @store.id
    if @bynet_config.valid?
      @store.deactivate_all_integrations!
      @bynet_config.save
      update_gateway_configs_status(@bynet_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_horuspay
    @horuspay_config = HoruspayConfig.new(horuspay_config_params)
    @horuspay_config.store_id = @store.id

    if @horuspay_config.valid?
      @store.deactivate_all_integrations!
      @horuspay_config.save
      update_gateway_configs_status(@horuspay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_dubpay
    @dubpay_config = DubpayConfig.new(dubpay_config_params)
    @dubpay_config.store_id = @store.id

    if @dubpay_config.valid?
      @store.deactivate_all_integrations!
      @dubpay_config.save
      update_gateway_configs_status(@dubpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_aionpay
    @aionpay_config = AionpayConfig.new(aionpay_config_params)
    @aionpay_config.store_id = @store.id

    if @aionpay_config.valid?
      @store.deactivate_all_integrations!
      @aionpay_config.save
      update_gateway_configs_status(@aionpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_az_pagamentos
    @az_pagamentos_config = AzPagamentosConfig.new(az_pagamentos_config_params)
    @az_pagamentos_config.store_id = @store.id
    if @az_pagamentos_config.valid?
      @store.deactivate_all_integrations!
      @az_pagamentos_config.save
      update_gateway_configs_status(@az_pagamentos_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end


  def create_maxpay_v2
    @maxpay_v2_config = MaxpayV2Config.new(maxpay_v2_config_params)
    @maxpay_v2_config.store_id = @store.id
    if @maxpay_v2_config.valid?
      @store.deactivate_all_integrations!
      @maxpay_v2_config.save
      update_gateway_configs_status(@maxpay_v2_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Dados inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def create_elysiumpay
    @elysiumpay_config = ElysiumpayConfig.new(elysiumpay_config_params)
    @elysiumpay_config.store_id = @store.id
    if @elysiumpay_config.valid?
      @store.deactivate_all_integrations!
      @elysiumpay_config.save
      update_gateway_configs_status(@elysiumpay_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Dados inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def create_armpay
    @armpay_config = ArmpayConfig.new(armpay_config_params)
    @armpay_config.store_id = @store.id
    if @armpay_config.valid?
      @store.deactivate_all_integrations!
      @armpay_config.save
      update_gateway_configs_status(@armpay_config)

      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_pulse_pag
    @pulse_pag_config = PulsePagConfig.new(pulse_pag_config_params)
    @pulse_pag_config.store_id = @store.id

    if @pulse_pag_config.valid?
      @store.deactivate_all_integrations!
      @pulse_pag_config.save
      update_gateway_configs_status(@pulse_pag_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Erro ao salvar! Verifique as informações inseridas e tente novamente!"
      render :new, status: :unprocessable_entity
    end
  end

  def create_kitercash
    @kitercash_config = KitercashConfig.new(kitercash_config_params)
    @kitercash_config.store_id = @store.id

    if @kitercash_config.valid?
      @store.deactivate_all_integrations!
      @kitercash_config.save
      update_gateway_configs_status(@kitercash_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end

  def create_pay2flow
    @pay2flow_config = Pay2flowConfig.new(pay2flow_config_params)
    @pay2flow_config.store_id = @store.id

    if @pay2flow_config.valid?
      @store.deactivate_all_integrations!
      @pay2flow_config.save
      update_gateway_configs_status(@pay2flow_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Erro ao salvar! Verifique as credenciais e tente novamente!"
      render :new, status: :unprocessable_entity
    end
  end

  def step_arkama; end

  # PATCH/PUT /store/gateways/1 or /store/gateways/1.json
  def update
    respond_to do |format|
      if @mercado_pago_config.update(mercado_pago_config_params)
        update_gateway_configs_status(@mercado_pago_config)
        format.html { redirect_to store_gateways_url, notice: "Salvo com sucesso." }
        format.json { render :show, status: :ok, location: @mercado_pago_config }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mercado_pago_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store/gateways/1 or /store/gateways/1.json
  def destroy
    @mercado_pago_config.destroy

    respond_to do |format|
      format.html { redirect_to store_gateways_url, notice: "Deletado com sucesso." }
      format.json { head :no_content }
    end
  end

  def toggle
    Store::INTEGRATIONS.each do |integration|
      name = integration.underscore
      config_class = "#{integration}Config".constantize

      if params[:kind] == name
        instance_variable_set "@#{name}_config", config_class.where(store_id: @store.id).friendly.find(params[:id])
        config_instance = instance_variable_get("@#{name}_config")
        config_instance.update_column(:active, !config_instance.active?)
        update_gateway_configs_status(config_instance)
      end
    end
    redirect_to store_gateways_url, notice: "Atualizado com sucesso."
  end

  private

  def update_gateway_configs_status(entity_config)
    entity_name = entity_config.class.name&.remove('Config')
    p "TESTEEEEE"
    p @store.gateway_configs.joins(:gateway).where(gateways: { name: entity_name })
    @store.gateway_configs.joins(:gateway).where(gateways: { name: entity_name }).update_all(status: entity_config.active? ? :active : :inactive)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_store_gateway
    @mercado_pago_config = MercadoPagoConfig.where(store_id: @store.id).friendly.find(params[:id])
  end

  ## Intercept and overwrite param rate attribute before save
  def convert_rate_param_value(require_name)
    return unless params[require_name][:rate].present?

    params[require_name][:rate] = convert_number_for_save(params[require_name][:rate])
  end

  def handle_timeout(e)
    logger.error "#{self.class.name} -- MESSAGE: TIMEOUT: #{e.message}"
    redirect_to action: :index
  end

  def handle_standard_error(e)
    logger.error "#{self.class.name} -- MESSAGE: ERROR: #{e.full_message}"
    redirect_to action: :index
  end

  def logger
    @@logger ||= Logger.new("#{Rails.root}/log/store_gateways_controller.log")
  rescue => e
    Rails.logger.error "#{self.class.name} -- MESSAGE: #{e.full_message} -- LOG: ERROR"
    @@logger = Rails.logger
  end
end
