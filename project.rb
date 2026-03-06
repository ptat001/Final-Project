require 'csv' 
require_relative 'registration' 
require_relative 'login'

def main_menu
  loop do
    puts "\n--- Main Menu ---"
    puts "1. Register"
    puts "2. Login"
    puts "3. Exit"
    print "Enter your choice:"
    choice = gets.strip 
    
    case choice
    when "1"
      RegistrationLogic.register_user
    when "2"
      Loginlogic.login_user
    when "3"
      puts "Goodbye!" 
      break 
    else
      puts "Invalid choice. Please select 1, 2, or 3."
    end
  end
end


main_menu