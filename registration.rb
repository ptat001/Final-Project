require 'csv'

module RegistrationLogic
  def self.register_user
    
    def self.exist(em)
      
      a = File.readlines("test.csv") 
      a.any? do |line| 
        e, p = line.chomp.split(",") 
        e == em
      end 
    end

    puts "--- User Registration ---"
    print "Enter email: "
    @email = gets.strip  
    if @email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      if exist(@email) 
        puts "email Already Exist" 
      else 
        print "Enter password: "
        @password = gets.strip   
        if @password.match?(/\A[a-zA-Z0-9@#$%^&*!]+\z/)
          CSV.open("test.csv", "a+") do |csv| 
           csv << [@email, @password] 
         end   
         puts "Registration done please login"
        else 
          puts "Error: Invalid Password Format" 
        end
       #puts "Registration done please login"
     end  
     else 
       puts"Invalid Email Format"
    end
  end
end