require_relative 'registration'
require_relative 'login'

def main_menu
  loop do
    puts "\n" + "="*30
    puts "   TASK MANAGEMENT SYSTEM"
    puts "="*30
    puts "1. Register"
    puts "2. Login"
    puts "3. Exit"
    print "Select Option: "
    
    case gets.strip
    when "1" then RegistrationLogic.register_user
    when "2" then LoginLogic.login_user
    when "3" then (puts "Goodbye!"; exit)
    else puts "!!! Invalid Choice. Try again !!!"
    end
  end
end

main_menu