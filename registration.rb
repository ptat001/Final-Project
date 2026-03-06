require 'csv' 
require_relative 'login'
module RegistrationLogic 
  
  def self.register_user
    puts "--- User Registration ---"

    
    attempts = 0
    loop do
      return if attempts >= 3 
      print "Enter name: "
      @username = gets.strip 
      if !exist(@username,@email,@contact)
       if @username.match?(/\A[a-zA-Z]+\z/)
        break
       else
        puts "Invalid Username. (Attempts: "
        attempts += 1
       end 
     else 
       puts"User name alredy exist" 
     end
    end

    
    attempts = 0
    loop do
      return if attempts >= 3
      print "Enter email: "
      @email = gets.strip
      if @email !~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        puts "Invalid Email Format"
        attempts += 1
      elsif exist(@username,@email,@contact,)
        puts "Email Already Exist"
        attempts += 1
      else
        break
      end
    end

    
    attempts = 0
    loop do
      return if attempts >= 3
      print "Enter contact no (10 digits): "
      @contact = gets.strip 
      if !exist(@username,@email,@contact)
       if @contact.match?(/\A\d{10}\z/)
        break
       else
        puts "Invalid Contact. Must be 10 digits, no spaces/special chars."
        attempts += 1
       end 
      else 
        puts"Contact no. alredy exist" 
      end
    end

    
    attempts = 0
    loop do
      if attempts >= 3
        puts "Too many password attempts. Restarting registration..."
        return register_user 
      end
      print "Enter 4-digit password: "
      @password = gets.strip
      if @password.match?(/\A[0-9]+\z/)
       
        CSV.open("test.csv", "a+") do |csv|
          csv << [@username, @email, @contact, @password]
        end
        puts "Registration done."
        Loginlogic.task_menue
        return
      else
        puts "Error: Invalid Password Use only 4-digit"
        attempts += 1
      end
    end

  end


  def self.exist(u,em,con)
     a = File.readlines("test.csv") 
     a.any? do |line| 
        n, e, c, p = line.chomp.split(",") 
        e == em || c == con || n==u
     end
   end     

   

end
 



 
