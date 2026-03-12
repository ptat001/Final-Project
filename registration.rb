require 'csv'

module RegistrationLogic
  def self.register_user
    puts "\n--- User Registration ---"
    
    # 1. NAME 
    name = get_simple_input("Name", /\A[a-zA-Z\s]+\z/, "Only alphabets allowed")
    return if name.nil?

    # 2. EMAIL 
    email = get_unique_input("Email", /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, "Invalid Email Format", 1)
    return if email.nil?

    # 3. CONTACT 
    contact = get_unique_input("Contact No", /\A\d{10}\z/, "Must be exactly 10 digits", 2)
    return if contact.nil?

    # 4. PASSWORD 
    password = get_simple_input("4-Digit Password", /\A\d{4}\z/, "Must be exactly 4 digits")
    return if password.nil?

    
    CSV.open("test.csv", "a+") do |csv|
      csv << [name, email.downcase, contact, password]
    end
    
    puts "\n Registration Successful for #{name}!"
    LoginLogic.task_menu(email) 
  end

  
  def self.get_unique_input(f_name, regex, error, index)
    attempts = 0
    loop do
      if attempts >= 3
        puts "!!! Too many attempts Registration Cancelled. !!!"
        return nil
      end

      print "Enter #{f_name}: "
      val = gets.strip
      
      if !(val =~ regex)
        puts "!!! ERROR: #{error} !!!"
        attempts += 1
        next
      end

      
      if File.exist?("test.csv")
        exists = File.readlines("test.csv").any? do |line|
          data = line.chomp.split(",").map(&:strip)
          data[index].to_s == val
        end

        if exists
          puts "!!! ERROR: This #{f_name} is already registered. Try another. !!!"
          attempts += 1
          next
        end
      end
      return val
    end
  end

 
  def self.get_simple_input(f_name, regex, error)
    attempts = 0
    loop do
      if attempts >= 3
        puts "!!! Too many attempts Registration Cancelled. !!!"
        return nil
      end

      print "Enter #{f_name}: "
      val = gets.strip
      
      if val =~ regex
        return val
      else
        puts "!!! ERROR: #{error} !!!"
        attempts += 1
      end
    end
  end
end