# require 'json'
# require 'time'


#   # Cores ANSI para um layout mais profissional
#   RESET = "\e[0m"
#   BOLD = "\e[1m"
#   BLUE = "\e[34m"
#   GREEN = "\e[32m"
#   YELLOW = "\e[33m"
#   RED = "\e[31m"
#   CYAN = "\e[36m"

#   def limpar_tela
#     system("clear") || system("cls")
#   end

#   def exibir_banner
#     limpar_tela
#     puts BLUE
#     puts "   ██████╗       ██╗        ██████      ██████╗  ".center(80)
#     puts "  ██╔════╝       ██║       ██╔═══██╗   ██╔════╝  ".center(80)
#     puts "  ██║            ██║       ██║   ██║   ██║  ███╗ ".center(80)
#     puts "  ██║      ███   ██║       ██║   ██║   ██║   ██║ ".center(80)
#     puts "  ╚██████╗       ███████╗  ╚██████╔╝   ╚██████╔╝ ".center(80)
#     puts "   ╚═════╝       ╚══════╝   ╚═════╝     ╚═════╝  ".center(80)
#     puts YELLOW + "  Conversor de Logs".center(80) + RESET
#     puts CYAN + "#{Time.now.strftime("Data: %d/%m/%Y  Hora: %H:%M:%S")}".center(80) + RESET
#     puts BLUE + "=" * 80 + RESET
#   end

#   def capturar_log
#     puts "
#   #{YELLOW}📥 Cole ou digite o log abaixo e pressione Ctrl+D para processar como JSON e cURL#{RESET}
#   "
#     puts "=" * 80
    
#     input = STDIN.read.strip
#     return nil if input.empty?
#     input
#   end

#   def processar_json(input)
#     json_match = input.match(/-- PAYLOAD: ({.*?})\s-- TIMEOUT/m)
#     return nil unless json_match
    
#     json_data = json_match[1]
#     begin
#       JSON.parse(json_data)
#     rescue JSON::ParserError
#       nil
#     end
#   end

#   def gerar_curl(json_data)
#     <<~CURL
#       curl --location 'https://api.monezo.com.br/v1/transactions' \\
#       --header 'Authorization: Basic c2tfbmxFTnRPZDdjTE43VkY1VjVsX1hIUlZMYnpJNVkxSVh3WWFSZWNxMmNqSGJUSVBnOng=' \\
#       --header 'Content-Type: application/json' \\
#       --data-raw '#{JSON.pretty_generate(json_data)}'
#     CURL
#   end

#   def salvar_em_arquivo(conteudo, tipo)
#     timestamp = Time.now.strftime("%Y%m%d-%H%M%S")
#     dir_path = "logs"
#     Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
#     file_name = "#{dir_path}/CLOG-#{tipo}-#{timestamp}.txt"
#     File.open(file_name, "w") { |file| file.puts conteudo }
#     puts "\n#{GREEN}💾 Arquivo salvo com sucesso!#{RESET}"
#     puts "📂 #{BOLD}Local do arquivo:#{RESET} #{file_name}"
#   end

#   def menu_principal
#     loop do
#       exibir_banner
#       puts "
#   #{BOLD}📌 Escolha uma opção:#{RESET}
#   "
#       puts "#{CYAN}[1] ✍️ Inserir log para conversão#{RESET}"
#       puts "#{RED}[2] ❌ Sair#{RESET}"
#       print "
#   👉 #{BOLD}Opção: #{RESET}"
#       STDOUT.flush
#       opcao = $stdin.gets.chomp
      
#       case opcao
#       when "1"
#         input = capturar_log
#         if input.nil?
#           puts "#{RED}⚠️ Nenhum log inserido! Retornando ao menu...#{RESET}"
#           next
#         end

#         json_data = processar_json(input)
        
#         if json_data
#           puts "
#   #{GREEN}✅ JSON Processado com Sucesso!#{RESET}"
#           puts JSON.pretty_generate(json_data)
#           salvar_em_arquivo(JSON.pretty_generate(json_data), "JSON")
          
#           curl_output = gerar_curl(json_data)
#           puts "
#   #{GREEN}✅ cURL Gerado com Sucesso!#{RESET}"
#           puts curl_output
#           salvar_em_arquivo(curl_output, "CURL")
#         else
#           puts "#{RED}❌ Erro ao processar JSON!#{RESET}"
#         end
#       when "2"
#         puts "
#   #{RED}👋 Aplicação encerrada pelo usuário.#{RESET}"
#         sleep(1) # Pequena pausa antes de limpar a tela
#         limpar_tela
#         exit
#       else
#         puts "#{RED}🚫 Opção inválida. Tente novamente.#{RESET}"
#       end
      
#       puts "
#   #{GREEN}🎉 Processo finalizado! Pressione Enter para voltar ao menu...#{RESET}"
#       STDIN.gets
#     end
#   end

# menu_principal
