require_relative 'task_manager'

module LoginLogic
  def self.login_user
    puts "\n--- User Login ---"
    attempts = 0
    
    loop do
      if attempts >= 3
        puts "!!! Login Locked. Back to Main Menu. !!!"
        return
      end

      print "Email: "
      email = gets.strip.downcase
      print "Password: "
      password = gets.strip

      if validate(email, password)
        puts " Login Successful!"
        task_menu(email)
        break
      else
        attempts += 1
        puts "!!! Invalid Credentials (Attempt #{attempts}/3) !!!"
      end
    end
  end

  def self.validate(e_in, p_in)
    
    File.readlines("test.csv").any? do |line|
      n, e, c, p = line.chomp.split(",")
      e == e_in && p == p_in
    end
  end

  def self.task_menu(user)
    loop do
      puts "\n--- Task Dashboard [#{user}] ---"
      puts "1. Create Task"
      puts "2. View All Tasks"
      puts "3. Update Status" 
      puts "4. Task by specific user" 
      puts "5. Delete Task"
      puts "6. View All Users"  
      puts "7. assign_task"
      puts "8. Filter Task" 
      puts "9. logout"
      print "Selection: "
      
      case gets.strip
      when "1" then TaskManager.create_task(user)
      when "2" then TaskManager.view_all_task(user)
      when "3" then TaskManager.status_update 
      when "4" then TaskManager.task_by_specific_user 
      when "5" then TaskManager.delete_task  
      when "6" then TaskManager.view_all_users 
      when "7" then TaskManager.assign_task(user) 
      when "8" then TaskManager.filter_all_tasks
      when "9" then break
      else puts "Invalid choice."
      end
    end
  end
end