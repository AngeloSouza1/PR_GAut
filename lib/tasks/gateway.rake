require 'io/console'
require 'time'
require 'yaml'
require 'fileutils'
require 'json'



# rake logs:convert

namespace :logs do
  desc "Conversor de Logs"
  task convert: :environment do
    require 'json'
    require 'time'

    # Cores ANSI para um layout mais profissional
    RESET = "\e[0m"
    BOLD = "\e[1m"
    BLUE = "\e[34m"
    GREEN = "\e[32m"
    YELLOW = "\e[33m"
    RED = "\e[31m"
    CYAN = "\e[36m"

    def limpar_tela
      system("clear") || system("cls")
    end

    def exibir_banner
      limpar_tela
      puts BLUE
      puts "   ██████╗       ██╗        ██████      ██████╗  ".center(80)
      puts "  ██╔════╝       ██║       ██╔═══██╗   ██╔════╝  ".center(80)
      puts "  ██║            ██║       ██║   ██║   ██║  ███╗ ".center(80)
      puts "  ██║      ███   ██║       ██║   ██║   ██║   ██║ ".center(80)
      puts "  ╚██████╗       ███████╗  ╚██████╔╝   ╚██████╔╝ ".center(80)
      puts "   ╚═════╝       ╚══════╝   ╚═════╝     ╚═════╝  ".center(80)
      puts YELLOW + "  Conversor de Logs".center(80) + RESET
      puts CYAN + "#{Time.now.strftime("Data: %d/%m/%Y  Hora: %H:%M:%S")}".center(80) + RESET
      puts BLUE + "=" * 80 + RESET
    end

    def capturar_log
      puts "
  #{YELLOW}📥 Cole ou digite o log abaixo e pressione Ctrl+D para processar como JSON e cURL#{RESET}
  "
      puts "=" * 80
      
      input = STDIN.read.strip
      return nil if input.empty?
      input
    end

    def processar_json(input)
      json_match = input.match(/-- PAYLOAD: ({.*?})\s-- TIMEOUT/m)
      return nil unless json_match
      
      json_data = json_match[1]
      begin
        JSON.parse(json_data)
      rescue JSON::ParserError
        nil
      end
    end

    def gerar_curl(json_data)
      <<~CURL
        curl --location 'https://api.monezo.com.br/v1/transactions' \\
        --header 'Authorization: Basic c2tfbmxFTnRPZDdjTE43VkY1VjVsX1hIUlZMYnpJNVkxSVh3WWFSZWNxMmNqSGJUSVBnOng=' \\
        --header 'Content-Type: application/json' \\
        --data-raw '#{JSON.pretty_generate(json_data)}'
      CURL
    end

    def salvar_em_arquivo(conteudo, tipo)
      timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
      dir_path = "logs"
      Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
      file_name = "#{dir_path}/CLOG-#{tipo}-#{timestamp}.txt"
      File.open(file_name, "w") { |file| file.puts conteudo }
      puts "\n#{GREEN}💾 Arquivo salvo com sucesso!#{RESET}"
      puts "📂 #{BOLD}Local do arquivo:#{RESET} #{file_name}"
    end

    def menu_principal
      loop do
        exibir_banner
        puts "
  #{BOLD}📌 Escolha uma opção:#{RESET}
  "
        puts "#{CYAN}[1] ✍️ Inserir log para conversão#{RESET}"
        puts "#{RED}[2] ❌ Sair#{RESET}"
        print "
  👉 #{BOLD}Opção: #{RESET}"
        STDOUT.flush
        opcao = $stdin.gets.chomp
        
        case opcao
        when "1"
          input = capturar_log
          if input.nil?
            puts "#{RED}⚠️ Nenhum log inserido! Retornando ao menu...#{RESET}"
            next
          end

          json_data = processar_json(input)
          
          if json_data
            puts "
  #{GREEN}✅ JSON Processado com Sucesso!#{RESET}"
            puts JSON.pretty_generate(json_data)
            salvar_em_arquivo(JSON.pretty_generate(json_data), "JSON")
            
            curl_output = gerar_curl(json_data)
            puts "
  #{GREEN}✅ cURL Gerado com Sucesso!#{RESET}"
            puts curl_output
            salvar_em_arquivo(curl_output, "CURL")
          else
            puts "#{RED}❌ Erro ao processar JSON!#{RESET}"
          end
        when "2"
          puts "
  #{RED}👋 Aplicação encerrada pelo usuário.#{RESET}"
          sleep(1) # Pequena pausa antes de limpar a tela
          limpar_tela
          exit
        else
          puts "#{RED}🚫 Opção inválida. Tente novamente.#{RESET}"
        end
        
        puts "
  #{GREEN}🎉 Processo finalizado! Pressione Enter para voltar ao menu...#{RESET}"
        STDIN.gets
      end
    end

    menu_principal
  end
end


# rake gateway:create_model


namespace :gateway do
  desc "Sistema de Gerenciamento de Gateways"
  task create_model: :environment do
    # Caminho do arquivo de bases
    BASES_FILE = Rails.root.join('config', 'bases.yml')

    # Função para limpar a tela
    def clear_screen
      system('clear') || system('cls')
    end

    # Função para exibir o logotipo
    def display_logo
      puts "\e[34m"
      puts "   ██████╗      ██╗ ███╗   ██╗ ████████╗".center(80)
      puts "  ██╔════╝      ██║ ████╗  ██║ ╚══██╔══╝".center(80)
      puts "  ██║  ███╗     ██║ ██╔██╗ ██║    ██║   ".center(80)
      puts "  ██║   ██║ ███ ██║ ██║╚██╗██║    ██║   ".center(80)
      puts "  ╚██████╔╝     ██║ ██║ ╚████║    ██║   ".center(80)
      puts "   ╚═════╝      ╚═╝ ╚═╝  ╚═══╝    ╚═╝   ".center(80)
      puts "          \e[33mGerador de Integrações (G-INT)\e[0m".center(80)
      puts "\e[36m#{Time.now.strftime("Data: %d/%m/%Y  Hora: %H:%M:%S")}\e[0m".center(80)
      puts "\e[34m" + "=" * 80 + "\e[0m"
    end

    # Função para exibir o menu fixo
    def display_menu
      puts "\e[36mEscolha uma opção do menu:\e[0m".center(80)
      puts "\e[33m[1] Consulta BASE      [2] Criar Gateway      [3] Cadastrar Base      [4] Sair\e[0m".center(80)
      puts "\e[34m" + "=" * 80 + "\e[0m"
    end

    # Função para exibir o cabeçalho fixo (logo + menu)
    def display_header
      clear_screen
      display_logo
      display_menu
    end

    # Função para exibir a área de saída
    def display_content(content)
      puts "\n" + content
      
    end

    # Função para carregar as bases do arquivo
    def load_bases
      return {} unless File.exist?(BASES_FILE)
      YAML.load_file(BASES_FILE) || {}
    end

    # Função para salvar as bases no arquivo
    def save_bases(bases)
      File.open(BASES_FILE, 'w') { |file| file.write(bases.to_yaml) }
    end

    # Função para consultar as bases
    def consulta_base
      bases = load_bases
      display_header
      if bases.empty?
        display_content("\n\e[33m❓ Nenhuma base cadastrada no momento.\e[0m")
      else
        puts "\nBases cadastradas:\n".center(40)
        bases.each do |base, dados|
          puts "\n\e[33m🌐 Base: #{base}\e[0m"
          puts "=============================================================="
          puts "Local: #{dados['local']}"
          puts "Arquivos:"
          dados['arquivos'].each { |arquivo| puts "🔹 #{arquivo}" }
          
        end
      end
      puts "\n\e[34m[💻] Pressione qualquer tecla para voltar ao menu.\e[0m".center(40)

      STDIN.getch
    end

    # Função para cadastrar novas bases
def cadastrar_base
  bases = load_bases
  display_header

  # Solicita o nome da base
  puts "\e[36mDigite o nome da nova base:\e[0m".center(80)
  print " -> "
  base_name = STDIN.gets.chomp.strip

  if base_name.empty?
    display_content("❌ [Erro] O nome da base não pode estar vazio!")
    sleep(1)
    return
  end

  # Verifica se a base já existe
  if bases.key?(base_name)
    display_content("❌ [Erro] A base '#{base_name}' já está cadastrada!")
    sleep(1)
    return
  end

  # Pergunta se o usuário deseja continuar após inserir o nome da base
  puts "\e[36mVocê deseja continuar o cadastro da base '#{base_name}'? (S/n)\e[0m".center(80)
  response = STDIN.getch.downcase
  if response != 's' && response != ''
    display_content("[Cancelado] Cadastro interrompido pelo usuário.")
    sleep(1)
    return
  end

  # Solicita o local onde os arquivos estão armazenados
  puts "\e[36m Digite o local onde os arquivos estão armazenados (ex: 'app/files'):\e[0m".center(80)
  print " -> "
  local = STDIN.gets.chomp.strip

  if local.empty?
    display_content("❌ [Erro] O local dos arquivos não pode estar vazio!")
    sleep(1)
    return
  end

  # Solicita os arquivos relacionados
  arquivos = []
  loop do
    puts "\e[36mDigite o nome de um arquivo (ou pressione Enter para finalizar):\e[0m".center(80)
    print " -> "
    arquivo = STDIN.gets.chomp.strip
    break if arquivo.empty?

    arquivos << arquivo
  end

  if arquivos.empty?
    display_content("❌ [Erro] É necessário adicionar pelo menos um arquivo!")
    sleep(1)
    return
  end

  # Adiciona a base ao hash e salva no arquivo
  bases[base_name] = { 'local' => local, 'arquivos' => arquivos }
  save_bases(bases)

  display_content("🌐 Base '#{base_name}' cadastrada com sucesso!")
  sleep(1)
end


# --------------------------------------INSERÇÃO CODIGO WEBHOOK-----------------------------------------------

# Criação da pasta e do arquivo do gateway no webhook
def create_webhook_controller(gateway_name, selected_base)
  # Caminho para a pasta do webhook
  webhook_base_path = Rails.root.join('app', 'controllers', 'api', 'v1', 'webhook')

  # Nome do gateway em CamelCase e minúsculo
  gateway_camel_case = gateway_name.camelize(:upper)
  gateway_lowercase = gateway_name.downcase

  # Caminho para a pasta do gateway dentro do webhook
  gateway_folder_path = webhook_base_path.join(gateway_lowercase)

  # Cria a pasta do gateway
  FileUtils.mkdir_p(gateway_folder_path)

  # Caminho para o arquivo payments_controller.rb
  payments_controller_path = gateway_folder_path.join('payments_controller.rb')

  # Caminho para o modelo de referência na base
  modelo_webhook_path = Rails.root.join('lib', 'bases', selected_base.downcase, 'modelo_webhook.rb')

  # Verifica se o modelo existe
  if File.exist?(modelo_webhook_path)
    # Lê o conteúdo do modelo
    modelo_webhook_content = File.read(modelo_webhook_path)

    # Substitui 'nomehook' pelo nome do gateway em CamelCase
    # Substitui 'nomegateway' pelo nome do gateway em minúsculo
    updated_webhook_content = modelo_webhook_content
                              .gsub('nomehook', gateway_camel_case)
                              .gsub('nomegateway', gateway_lowercase)

    # Cria o arquivo payments_controller.rb com o conteúdo atualizado
    File.open(payments_controller_path, 'w') do |file|
      file.puts updated_webhook_content
    end

    display_content("✅ [Sucesso]  Pasta e controller para o gateway \e[32m#{gateway_name}\e[0m criados com sucesso em \e[32m#{gateway_folder_path}\e[0m.")
  else
    display_content("❌ [Erro] Modelo 'modelo_webhook.rb' não encontrado na base selecionada: \e[32m#{modelo_webhook_path}\e[0m.")
  end
end


# -------------------------FUNÇÃO PARA CRIAR UM GATEWAY----------------------------------

def create_gateway
   # Captura o tempo de início da execução
   bases = load_bases
  display_header


  # Solicita o nome do gateway ao usuário
  puts "\e[36mDigite o nome do Gateway:\e[0m".center(80)
  puts "\e[33m(Digite o identificador principal do modelo a ser criado.)\e[0m".center(80)
  print " -> "
  gateway_name = STDIN.gets.chomp.strip

 
  if gateway_name.empty?
    display_content("❌ [Erro] O nome do gateway não pode estar vazio!")
    sleep(1)
    return
  end

  # Solicita a Base URL do gateway
  puts "\e[36mDigite a Base URL para o Gateway:\e[0m".center(80)
  puts "\e[33m(Essa URL substituirá 'https://api.gateway' no modelo de migração.)\e[0m".center(80)
  print " -> "
  base_url = STDIN.gets.chomp.strip

  if base_url.empty?
    display_content("[Erro] ❌ A Base URL não pode estar vazia!")
    sleep(1)
    return
  end


  # Solicita o nome do logo
  puts "\e[36mDigite o nome do logo (com extensão, ex: logo.png):\e[0m".center(80)
  puts "\e[33m(Deixe vazio para usar o logo padrão 'gateway_default.png')\e[0m".center(80)
  print " -> "
  logo_name = STDIN.gets.chomp.strip
  logo_name = 'gateway_default.png' if logo_name.empty?

  # Verifica se o logo existe
  logo_path = Rails.root.join('app', 'assets', 'images', 'gateways_images', logo_name).to_s
  unless File.exist?(logo_path)
    puts "\n"
    puts "\e[31m ❌ [Erro] Logo '#{logo_name}' não encontrado no caminho #{logo_path}.\e[0m".center(80)
    puts "\n[INFO] Deseja continuar mesmo assim? (S/n)\e[0m"
    response = STDIN.getch.downcase
    if response != 's' && response != ''
      display_content("[Cancelado] Processo interrompido pelo usuário.")
      sleep(1)
      return
    end
  end

  # Exibe as bases cadastradas para seleção
  if bases.empty?
    display_content("❌ [Erro] Nenhuma base cadastrada. Cadastre uma base primeiro!")
    sleep(2)
    return
  end

  puts "\n\e[36mSelecione a base que será usada como referência:\e[0m".center(80)
  base_names = bases.keys
  base_names.each_with_index do |base, index|
    puts "[#{index + 1}] #{base}"
  end
  print "\n -> "
  selected_index = STDIN.gets.chomp.to_i - 1

  # Valida a seleção da base
  if selected_index < 0 || selected_index >= base_names.size
    display_content("❌ [Erro] Opção inválida! Tente novamente.")
    sleep(2)
    return
  end

  # Define a base selecionada
  selected_base = base_names[selected_index]

  
  #Cria o webhook do controller com o nome do gateway e a base selecionada
  create_webhook_controller(gateway_name, selected_base)


  # Caminhos dos arquivos de referência
  modelo_migrar_path = Rails.root.join('lib', 'bases', selected_base.downcase, 'modelo_migrar.rb')
  modelo_model_path = Rails.root.join('lib', 'bases', selected_base.downcase, 'modelo_model.rb')

  unless File.exist?(modelo_migrar_path) && File.exist?(modelo_model_path)
    display_content("❌ [Erro] Arquivos de referência não encontrados: #{modelo_migrar_path} ou #{modelo_model_path}!")
    sleep(2)
    return
  end

  # Confirmação final
  puts "\n\e[36mResumo das informações:\e[0m"
  puts "\e[33mGateway:\e[0m #{gateway_name}"
  puts "\e[33mBase URL:\e[0m #{base_url}"
  puts "\e[33mLogo:\e[0m #{logo_name}"
  puts "\e[33mBase Selecionada:\e[0m #{selected_base}"
  puts "\n\e[36mConfirmar criação do Gateway? (S/n)\e[0m"
  response = STDIN.getch.downcase
  if response != 's' && response != ''
    display_content("[Cancelado] Processo interrompido pelo usuário.")
    sleep(1)
    return
  end

  # Ajusta o nome do modelo com "Config"
  model_name = "#{gateway_name.split.map(&:capitalize).join}Config"

  # Gera o modelo
  display_content("✅ [INFO] Gerando o modelo '#{model_name}' com base na base '#{selected_base}'...")
  puts "\n"
  system("rails g model #{gateway_name}_config")

  # Localiza a migração
  migration_files = Dir.glob("db/migrate/*_create_#{gateway_name.downcase}_configs.rb")
  if migration_files.empty?
    display_content("❌ [Erro] Arquivo de migração não encontrado!")
    sleep(2)
    return
  end
  migration_file = migration_files.first

  # Atualiza a migração
  modelo_migrar_content = File.read(modelo_migrar_path)
  modelo_migrar_content.gsub!("nomegateway", gateway_name.downcase)
  modelo_migrar_content.gsub!("https://api.monezo.com.br", base_url)

  new_migration_content = <<-RUBY
class Create#{model_name.pluralize} < ActiveRecord::Migration[7.0]
  def change
#{modelo_migrar_content.strip}
  end
end
  RUBY

  File.open(migration_file, 'w') do |file|
    file.puts new_migration_content.strip
  end

  # Atualiza o modelo
  modelo_model_content = File.read(modelo_model_path)
  modelo_model_content.gsub!("nomegateway", gateway_name.downcase)
  modelo_model_content.gsub!("nomeconfig", gateway_name.split.map(&:capitalize).join)

  model_file_path = Rails.root.join("app", "models", "#{gateway_name.downcase}_config.rb")
  File.open(model_file_path, 'w') do |file|
    file.puts <<-RUBY
class #{model_name} < ApplicationRecord
#{modelo_model_content.strip}
end
    RUBY
  end

  # Atualiza o HTML com o novo gateway
  update_html_with_gateway(gateway_name)

  # Mensagem de sucesso
  display_content("✅ Modelo '#{model_name}' criado com sucesso, baseado na base '#{selected_base}'!")
  display_content("✅ Arquivo de migração, modelo e HTML atualizados com sucesso!")

  # Pergunta se o usuário quer executar o `rails db:migrate`
  puts "\n\e[36mDeseja aplicar a migração? (S/n)\e[0m".center(80)
  migrate_response = STDIN.getch.downcase
  if migrate_response == 's'
    display_content("✅ Executando 'rails db:migrate'...")
    puts "\n"
    system("rails db:migrate")
    display_content("✅ Migração aplicada com sucesso!")
  else
    display_content("🛑 [Ação Pendente] Você escolheu não rodar 'rails db:migrate'.")
  end


# Atualiza o arquivo base com o nome do gateway
base_service_path = Rails.root.join("app", "services", selected_base.downcase, "base.rb")
if File.exist?(base_service_path)
  base_content = File.read(base_service_path)

  # Encontra a linha com o array INTEGRATIONS
  integrations_match = base_content.match(/INTEGRATIONS\s*=\s*\[(.*?)\].freeze/m)
  if integrations_match
    current_integrations = integrations_match[1]

    # Adiciona o nome do gateway ao final do array
    new_integrations = "#{current_integrations}, '#{gateway_name.split.map(&:capitalize).join}'"
    updated_base_content = base_content.sub(current_integrations, new_integrations.strip)

    # Salva as alterações no arquivo base.rb
    File.open(base_service_path, 'w') { |file| file.puts updated_base_content }

    display_content("✅ Gateway '#{gateway_name}' adicionado ao arquivo base com sucesso!")
  else
    display_content("❌ [Erro] Não foi possível localizar o array INTEGRATIONS no arquivo base!")
  end
else
  display_content("❌ [Erro] Arquivo base.rb não encontrado em: #{base_service_path}!")
end

# Adiciona funcionalidade para criar o arquivo _form_nomegateway.html.erb
modelo_form_path = Rails.root.join('lib', 'bases', selected_base.downcase, 'modelo_form_store.erb')
new_html_path = Rails.root.join("app", "views", "store", "gateways", "_form_#{gateway_name.downcase}.html.erb")

if File.exist?(modelo_form_path)
  begin
    modelo_form_content = File.read(modelo_form_path)

    # Substitui o placeholder 'nomegateway' pelo nome do gateway
    modelo_form_content.gsub!("nomegateway", gateway_name.downcase)

    # Ajusta o nome da imagem corretamente
    if logo_name == 'gateway_default.png'
      modelo_form_content.gsub!("'gateway_images/'", "'gateways_images/gateway_default.png'")
    else
      modelo_form_content.gsub!("'gateway_images/'", "'gateways_images/#{logo_name}'")
    end

    # Garante que a pasta exista antes de criar o arquivo
    FileUtils.mkdir_p(File.dirname(new_html_path))

    File.open(new_html_path, 'w') do |file|
      file.puts modelo_form_content.strip
    end

    display_content("✅ Arquivo '_form_#{gateway_name.downcase}.html.erb' criado com sucesso em 'app/views/store/gateways'!")
  rescue StandardError => e
    display_content("❌ [Erro] Falha ao criar o arquivo HTML: #{e.message}")
  end
else
  display_content("❌ [Erro] Arquivo modelo_form_store.erb não encontrado para a base '#{selected_base}'!")
end

# Atualiza o arquivo de rotas store_routes.rb com as rotas do novo gateway
store_routes_path = Rails.root.join('config', 'routes', 'store_routes.rb')

if File.exist?(store_routes_path)
  begin
    store_routes_content = File.read(store_routes_path)

    # Adiciona o post :create_nomegateway após a referência 'post :create_abmex'
    abmex_post_match = store_routes_content.match(/post :create_abmex(.*)/)
    if abmex_post_match
      updated_store_routes_content = store_routes_content.sub(
        abmex_post_match[0],
        "#{abmex_post_match[0]}\n            post :create_#{gateway_name.downcase}"
      )
    else
      display_content("❌ [Erro] Não foi possível localizar a referência 'post :create_abmex' no arquivo de rotas.")
      return
    end

        # Adiciona o bloco específico do gateway após a referência '## Abmexpay'
    abmexpay_block_match = updated_store_routes_content.match(/## Abmexpay\n(.*?)\n\n/m)
    if abmexpay_block_match
      current_abmexpay_block = abmexpay_block_match[1]
      
      # Define o novo bloco do gateway com deslocamento de 8 espaços
      new_gateway_block = <<-ROUTES.strip_heredoc
            ## #{gateway_name.camelize}
            get :active_#{gateway_name.downcase}
            put :update_#{gateway_name.downcase}
            patch :update_#{gateway_name.downcase}
            get :edit_#{gateway_name.downcase}
            delete :destroy_#{gateway_name.downcase}
      ROUTES

      # Substitui e adiciona o bloco ajustado
      final_store_routes_content = updated_store_routes_content.sub(
        current_abmexpay_block,
        "#{current_abmexpay_block}\n\n#{new_gateway_block.strip}"
      )
    else
      display_content("❌ [Erro] Não foi possível localizar a referência '## Abmexpay' no arquivo de rotas.")
      return
    end


    # Salva o conteúdo atualizado no arquivo de rotas
    File.open(store_routes_path, 'w') { |file| file.puts final_store_routes_content.strip }

    display_content("✅ Rotas para o gateway '#{gateway_name}' adicionadas com sucesso ao arquivo store_routes.rb!")
  rescue StandardError => e
    display_content("❌ [Erro] Falha ao atualizar o arquivo de rotas: #{e.message}")
  end
else
  display_content("❌ [Erro] Arquivo store_routes.rb não encontrado em: #{store_routes_path}!")
end

# Atualiza o controller do gateway
controller_path = Rails.root.join('app', 'controllers', 'store', 'gateways_controller.rb')

if File.exist?(controller_path)
  controller_content = File.read(controller_path)

  # Define a referência do método create_abmexpay
  reference_code = <<-RUBY
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
  RUBY

  # Bloco do novo método para o gateway
  new_gateway_method = <<-RUBY
  def create_#{gateway_name.downcase}
    @#{gateway_name.downcase}_config = #{gateway_name.camelize}Config.new(#{gateway_name.downcase}_config_params)
    @#{gateway_name.downcase}_config.store_id = @store.id

    if @#{gateway_name.downcase}_config.valid?
      @store.deactivate_all_integrations!
      @#{gateway_name.downcase}_config.save
      update_gateway_configs_status(@#{gateway_name.downcase}_config)
      redirect_to store_gateways_url, notice: "Salvo com sucesso."
    else
      flash.now[:error] = "Chave inválida"
      render :new, status: :unprocessable_entity
    end
  end
  RUBY

  # Verifica se o método já existe
  if controller_content.include?(new_gateway_method.strip)
    display_content("Método 'create_#{gateway_name.downcase}' já existe no controller.")
  else
    # Insere o novo método logo após o método create_abmexpay
    updated_controller_content = controller_content.sub(
      reference_code.strip,
      "#{reference_code.strip}\n\n#{new_gateway_method.strip}"
    )

    # Salva as alterações no arquivo do controller
    File.open(controller_path, 'w') { |file| file.puts updated_controller_content }
    display_content("✅ Método 'create_#{gateway_name.downcase}' adicionado ao controller com sucesso!")
  end
else
  display_content("❌ [Erro] Arquivo gateways_controller.rb não encontrado em: #{controller_path}")
end

# Atualiza o arquivo activerecord.pt-BR.yml com base no modelo da base
activerecord_path = Rails.root.join('config', 'locales', 'pt-BR', 'activerecord.pt-BR.yml')
modelo_ptbr_path = Rails.root.join('lib', 'bases', selected_base.downcase, 'modelo_ptbr.rb')

if File.exist?(activerecord_path) && File.exist?(modelo_ptbr_path)
  # Lê os conteúdos dos arquivos
  activerecord_content = File.read(activerecord_path)
  modelo_ptbr_content = File.read(modelo_ptbr_path)

  # Localiza o bloco de referência no arquivo activerecord
  referencia_match = activerecord_content.match(/abmexpay_config:\n\s+api_key: .*/)

  if referencia_match
    # Gera o novo bloco com base no modelo
    novo_bloco = <<-YAML.strip_heredoc
      #{gateway_name.downcase}_config:
        api_key: Chave da API
    YAML

    # Insere o novo bloco logo abaixo do bloco de referência
    updated_activerecord_content = activerecord_content.sub(
      referencia_match[0],
      "#{referencia_match[0]}\n#{novo_bloco.strip}"
    )

    # Salva as alterações no arquivo activerecord.pt-BR.yml
    File.open(activerecord_path, 'w') { |file| file.puts updated_activerecord_content }

    display_content("✅ Bloco do gateway '#{gateway_name}' adicionado ao activerecord.pt-BR.yml com sucesso!")
  else
    display_content("❌ [Erro] Não foi possível localizar 'abmexpay_config' no arquivo activerecord.pt-BR.yml.")
  end
else
  display_content(" ❌ [Erro] Arquivo activerecord.pt-BR.yml ou modelo_ptbr.rb não encontrado.")
end



# --------------------------------------HTML GATEWAYC CONFIG------------------------------------------------

# Caminho do arquivo de referência na base
modelo_form_client_path = Rails.root.join('lib', 'bases', selected_base.downcase, 'modelo_form_client.erb')

# Caminho do diretório onde o novo arquivo será salvo
novo_arquivo_diretorio = Rails.root.join('app', 'views', 'store', 'gateways')

# Nome do novo arquivo com base no gateway
novo_arquivo_nome = "_#{gateway_name.downcase}_config.html.erb"
novo_arquivo_caminho = File.join(novo_arquivo_diretorio, novo_arquivo_nome)

# Nome do logo selecionado ou o padrão
logo_path = logo_name.empty? ? 'gateway_images/gateway_default.png' : "gateway_images/#{logo_name}"

if File.exist?(modelo_form_client_path)
  # Lê o conteúdo do arquivo de referência
  modelo_form_client_content = File.read(modelo_form_client_path)

  # Substitui todas as ocorrências de "nomegateway" pelo nome do gateway
  novo_arquivo_conteudo = modelo_form_client_content.gsub("nomegateway", gateway_name.downcase)

  # Atualiza o trecho do logo no HTML gerado
  novo_arquivo_conteudo.gsub!(
    /<%= image_tag 'gateway_images\/.*?', alt: '.*?', height: height_image, width: width_image , class: '.*?' %>/,
    "<%= image_tag '#{logo_path}', alt: '#{gateway_name.downcase}', height: height_image, width: width_image , class: 'object-fit-contain p-1 rounded bg-white' %>"
  )

  # Cria o diretório caso ele não exista
  FileUtils.mkdir_p(novo_arquivo_diretorio)

  # Grava o conteúdo no novo arquivo
  File.open(novo_arquivo_caminho, 'w') do |file|
    file.puts novo_arquivo_conteudo
  end

  display_content("✅ Arquivo '#{novo_arquivo_nome}' criado com sucesso na pasta 'app/views/store/gateways' com o logo '#{logo_path}'!")
else
  display_content("❌ [Erro] Arquivo de referência 'modelo_form_client.erb' não encontrado na base selecionada.")
end


# --------------------------------------INSERÇÃO CODIGO GATEWAY NOS ARQUIVOS :CHARGE, INSTALMENT E EXTERNAL-----------------------------------------------
  
# Solicita o código do gateway ao usuário
  puts "\n"
  puts "\e[36mDigite o código do Gateway:\e[0m"
  puts "\e[33m(Esse código será inserido nos arquivos charge.rb, external_reference.rb e installment.rb.)\e[0m".center(80)
  print " -> "
  gateway_code = STDIN.gets.chomp.strip
  
  if gateway_code.empty?
    display_content("[Erro] O código do gateway não pode estar vazio!")
    sleep(1)
    return
  end
  
  # Caminho do arquivo charge.rb
  charge_file_path = Rails.root.join('app', 'models', 'charge.rb')
  
  if File.exist?(charge_file_path)
    # Lê o conteúdo do arquivo charge.rb
    charge_content = File.read(charge_file_path)
  
    # Localiza o trecho de referência
    referencia_charge = charge_content.match(/}, _default: :pag_seguro, _prefix: :service/)
  
    if referencia_charge
      # Gera o novo bloco para o código do gateway
      novo_trecho_charge = "  #{gateway_name.downcase}: #{gateway_code},"
  
      # Insere o novo bloco acima da referência
      updated_charge_content = charge_content.sub(
        referencia_charge[0],
        "#{novo_trecho_charge}\n#{referencia_charge[0]}"
      )
  
      # Salva as alterações no arquivo charge.rb
      File.open(charge_file_path, 'w') do |file|
        file.puts updated_charge_content
      end
  
      display_content("✅ Código do gateway '#{gateway_name}' adicionado ao arquivo charge.rb com sucesso!")
    else
      display_content("❌ [Erro] Não foi possível localizar o trecho de referência no arquivo charge.rb.")
    end
  else
    display_content("❌ [Erro] Arquivo charge.rb não encontrado em: #{charge_file_path}.")
  end
  
  # Caminho do arquivo installment.rb
  installment_file_path = Rails.root.join('app', 'models', 'installment.rb')
  
  if File.exist?(installment_file_path)
    # Lê o conteúdo do arquivo installment.rb
    installment_content = File.read(installment_file_path)
  
    # Localiza o trecho de referência
    referencia_installment = installment_content.match(/}, _default: :mercado_pago, _prefix: :gateway/)
  
    if referencia_installment
      # Gera o novo bloco para o código do gateway
      novo_trecho_installment = "  #{gateway_name.downcase}: #{gateway_code},"
  
      # Insere o novo bloco acima da referência
      updated_installment_content = installment_content.sub(
        referencia_installment[0],
        "#{novo_trecho_installment}\n#{referencia_installment[0]}"
      )
  
      # Salva as alterações no arquivo installment.rb
      File.open(installment_file_path, 'w') do |file|
        file.puts updated_installment_content
      end
  
      display_content("✅ Código do gateway '#{gateway_name}' adicionado ao arquivo installment.rb com sucesso!")
    else
      display_content("❌ [Erro] Não foi possível localizar o trecho de referência no arquivo installment.rb.")
    end
  else
    display_content("❌ [Erro] Arquivo installment.rb não encontrado em: #{installment_file_path}.")
  end
  
  # Caminho do arquivo external_reference.rb
external_reference_file_path = Rails.root.join('app', 'models', 'external_reference.rb')

if File.exist?(external_reference_file_path)
  # Lê o conteúdo do arquivo external_reference.rb
  external_reference_content = File.read(external_reference_file_path)

  # Localiza o trecho de referência
  referencia_external_reference = external_reference_content.match(/}, _default: :shopify, _prefix: :service/)

  if referencia_external_reference
    # Gera o novo bloco para o código do gateway
    novo_trecho_external_reference = "  #{gateway_name.downcase}: #{gateway_code},"

    # Insere o novo bloco acima da referência
    updated_external_reference_content = external_reference_content.sub(
      referencia_external_reference[0],
      "#{novo_trecho_external_reference}\n#{referencia_external_reference[0]}"
    )

    # Salva as alterações no arquivo external_reference.rb
    File.open(external_reference_file_path, 'w') do |file|
      file.puts updated_external_reference_content
    end

    display_content("✅ Código do gateway '#{gateway_name}' adicionado ao arquivo external_reference.rb com sucesso!")
  else
    display_content("❌ [Erro] Não foi possível localizar o trecho de referência no arquivo external_reference.rb.")
  end
else
  display_content("❌ [Erro] Arquivo external_reference.rb não encontrado em: #{external_reference_file_path}.")
end

  puts "\n✅ [Sucesso] Código do gateway '#{gateway_name}' inserido no arquivo HTML com sucesso!" 
  
  puts "\n\e[33mOBS: Importante! No ambiente admin, habilitar o gateway e no do usuário, inserir as credenciais!\e[0m"


  puts "\n\e[34mPressione qualquer tecla para voltar ao menu.\e[0m".center(80)
  STDIN.getch
end



def update_html_with_gateway(gateway_name)
  # Caminho do arquivo HTML
  html_file_path = Rails.root.join('app', 'admin', 'clients', '_form.html.erb')

  unless File.exist?(html_file_path)
    puts "[Erro] Arquivo HTML '_form.html.erb' não encontrado no caminho: #{html_file_path}"
    return
  end

  # Lê o conteúdo do arquivo HTML
  html_content = File.read(html_file_path)

  # Identifica o bloco de referência
  reference_block = %(
<div class="block block-rounded block-themed shadow-sm">
    <div class="block-header bg-white border-bottom">
      <h3 class="block-title font-weight-bold text-dark">
        Tipos de Cadastro de Loja
      </h3>
    </div>
  )

  unless html_content.include?(reference_block.strip)
    puts "[Erro] Bloco de referência não encontrado no arquivo HTML."
    return
  end

  # Converte o nome do gateway para Camel Case
  gateway_camel_case = gateway_name.camelize

# Código do gateway a ser inserido
gateway_block = <<-HTML
      <div class="row">
        <div class="col-6">
          <%= f.label :has_#{gateway_name.downcase}, 'Gateway #{gateway_camel_case}', class: 'fw-bold mb-2' %>
          <%= f.check_box :has_#{gateway_name.downcase}, label: 'Sim', switch: true, help: 'text' %>
        </div>
      </div>
  </div>
</div>
HTML

  # Divide o conteúdo antes e depois do bloco de referência
  html_parts = html_content.split(reference_block.strip)

  if html_parts.size < 2
    puts "❌ [Erro] Falha ao processar o arquivo HTML. Estrutura inesperada."
    return
  end
  
 # Remove as últimas 2 tags `</div>` antes do bloco de referência
 2.times do
  last_div_index = html_parts[0].rindex("</div>")
  if last_div_index
    html_parts[0] = html_parts[0][0...last_div_index]
  else
    puts "❌ [Erro] Não foram encontradas 3 tags </div> imediatamente antes do bloco de referência."
    return
  end
end

  # Reconstrói o HTML inserindo o novo bloco e adiciona o `</div>` no final do bloco do gateway
  updated_html_content = <<-HTML
#{html_parts[0].strip}

#{gateway_block.strip}

#{reference_block.strip}
#{html_parts[1].strip}
  HTML

  # Sobrescreve o arquivo HTML com o conteúdo atualizado
  File.open(html_file_path, 'w') do |file|
    file.puts updated_html_content
  end
  
# --------------------------------------INSERÇÃO CODIGO API ROUTE-----------------------------------------------

# Localiza o arquivo de rotas API
api_routes_path = Rails.root.join('config', 'routes', 'api_routes.rb')

if File.exist?(api_routes_path)
  # Lê o conteúdo do arquivo
  api_routes_content = File.read(api_routes_path)

  # Localiza o trecho de referência
  referencia_match = api_routes_content.match(/end\n\s+get 'document\/:token\/download', to: 'documents#download', as: :document_download/)

  if referencia_match
    # Estrutura do novo gateway
    novo_gateway_namespace = <<-RUBY

    namespace :#{gateway_name.downcase} do
      get 'payments', to: 'payments#update'
      post 'payments', to: 'payments#update'
    end
    RUBY

    # Insere o namespace do gateway acima do trecho de referência
    updated_api_routes_content = api_routes_content.sub(
      referencia_match[0],
      "#{novo_gateway_namespace.strip}\n#{referencia_match[0]}"
    )

    # Salva as alterações no arquivo api_routes.rb
    File.open(api_routes_path, 'w') { |file| file.puts updated_api_routes_content }

    display_content("✅ Namespace do gateway '#{gateway_name}' adicionado ao arquivo api_routes.rb com sucesso!")
  else
    display_content("❌ [Erro] Não foi possível localizar o trecho de referência no arquivo api_routes.rb.")
  end
else
  display_content("❌ [Erro] Arquivo api_routes.rb não encontrado.")
end
end


# Captura o tempo inicial antes de entrar no menu principal
start_time = Time.now


# Captura o tempo inicial antes de entrar no menu principal
start_time = Time.now

# Menu principal com captura de tempo total
def main_menu(start_time)
  loop do
    display_header # Exibe o cabeçalho com logo e menu
    
    print "\e[32m -> Escolha uma opção: \e[0m"
    choice = STDIN.gets.chomp.strip

    case choice
    when '1'
      consulta_base
    when '2'
      # Captura o tempo final
      create_gateway
      end_time = Time.now
      elapsed_time = end_time - start_time
      
      # Converte o tempo para minutos e segundos
      minutes = (elapsed_time / 60).to_i
      seconds = (elapsed_time % 60).to_i

      # Exibe o tempo formatado corretamente
      formatted_time = if minutes > 0
                         "#{minutes} min #{seconds} seg"
                       else
                         "#{seconds} seg"
                       end
      puts"\n"
      puts "\n\e[33mTempo total de execução: #{formatted_time}\e[0m"
      STDIN.gets
    when '3'
      cadastrar_base
    when '4'
       puts "\n\e[31mSaindo do sistema... Até logo!\e[0m".center(80)
      sleep(1)
      clear_screen
      break
    else
      puts "\n\e[31m[Erro] Opção inválida! Tente novamente.\e[0m".center(80)
      sleep(1)
    end
  end
end

# Inicia o menu principal com o tempo inicial
main_menu(start_time)
end
end
