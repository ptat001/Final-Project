require 'csv'

module Loginlogic
  def self.login_user 
    def self.validate(ep, pe) 
      
      a = File.readlines("test.csv") 
      a.any? do |line| 
        n, e, c, p = line.chomp.split(",") 
        e == ep && p == pe
      end 
    end  
    
    def self.create_task   
      
      puts "--- Create New Task ---"
      
      attempts = 0 
      loop do
        if attempts >= 3
          puts "Maximum title attempts reached. Returning to menu..."
          return 
        end
        
        print "Enter Title: " 
        @title = gets.strip   
        
        if task_validate(@title) 
          puts "Error: Title Already Exists"  
          attempts += 1 
        elsif @title =~ /\A[a-zA-Z ]+\z/ && !@title.empty?
          break 
        else 
          puts "Error: Title must contain only alphabets/spaces" 
          attempts += 1
        end
      end 
      
      
      
      attempts = 0
      loop do
        return if attempts >= 3
        print "Enter Description: " 
        @desc = gets.strip 
        if @desc =~ /\A[a-zA-Z ]+\z/ && !@desc.empty?
          break 
        else 
          puts "Error: Description must contain only alphabets (Attempt #{attempts + 1}/3)"
          attempts += 1
        end
      end
      
      
      attempts = 0
      loop do
        return if attempts >= 3
        print "Enter Status (pending/completed): " 
        @status = gets.strip.downcase
        if ["pending", "completed"].include?(@status)
          break 
        else
          puts "Error: Status must be 'pending' or 'completed'!"
          attempts += 1
        end
      end 
      
      @date = Time.now.strftime("%d/%m/%Y")
      @user = @email
      
      CSV.open("task.csv", "a+") do |csv| 
        csv << [@title, @desc, @status, @user, @date] 
      end  
      puts "Task Created Successfully !!!"
      
    end 
    
    def self.view_all_task(e2)
      puts "-----All Tasks-----" 
      File.readlines("task.csv").each do |line|  
        t, d, s, n, d3= line.chomp.split(",") 
        if (n == e2) 
          puts "#{t},#{d},#{s},#{n},#{d3}" 
        end
        
      end  
      
    end
    
    def self.task_by_Specific_user
      puts "Please enter the email" 
      email_1 = gets.chomp 
      if email_1=~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        puts "-----Tasks Created By #{email_1} Are-------" 
        
        File.readlines("task.csv").each do |line|  
          t, d, s, n = line.chomp.split(",") 
          if (n == email_1) 
            puts "Title :#{t},Desc :#{d},Status :#{s}" 
          end 
        end 
      else 
        puts"Invalid Email Formate" 
      end
      puts "No Task Available " 
    end 
    
    def self.delete_task 
      print"Enter the Title of the task to delete: " 
      target_title=gets.chomp 
      l=File.readlines("task.csv") 
      ul=l.reject do |line| 
        t,d,s,n= line.chomp.split(",") 
        t==target_title 
      end 
      if l.length>ul.length 
        File.write("task.csv",ul.join) 
        puts"Deleted Succesfully" 
      else 
        puts("!!! ERROR : Task With Title #{target_title} Not Found !!!") 
      end
    end 
    
    
    def self.update_task_Status  
      title_attempts = 0
      target_title = nil
      
      loop do  
        if title_attempts >= 3
          puts "Maximum title attempts reached. Returning to menu..."
          return 
        end
        puts"Enter the Title of the task you want to update: " 
        target_title = gets.strip  
        if task_validate(target_title) 
          break 
        else
          title_attempts += 1
          puts "!!! ERROR: Task With Title '#{target_title}' Not Found !!! (Attempt #{title_attempts}/3)"
        end
      end 
      return puts "No tasks found." unless File.exist?("task.csv")
      lines = File.readlines("task.csv") 
      
      found = false
      already_completed = false
      
      updated_lines = lines.map do |line| 
        t, d, s, u, dt = line.chomp.split(",").map(&:strip)
        if t == target_title 
          found = true
          
          
          if s.downcase == "completed"
            already_completed = true
            line 
          else
            attempts = 0
            new_status = nil
            loop do
              if attempts >= 3
                puts "Max attempts reached. Task remains 'pending'."
                new_status = s
                break
              end
              
              puts "Current Status: #{s}"
              print "Enter New Status (completed): "
              input = gets.strip.downcase
              
              if input == "completed"
                new_status = "completed"
                break
              else
                puts "Error: You can only update to 'completed'. (Attempt #{attempts + 1}/3)"
                attempts += 1
              end
            end
            "#{t},#{d},#{new_status},#{u},#{dt}\n" 
          end
        else 
          line 
        end 
      end
      
      
      if already_completed
        puts "!!! ERROR: Task '#{target_title}' is already completed and cannot be updated."
      elsif found 
        File.write("task.csv", updated_lines.join) 
        puts "Task Updated Successfully!"
      else 
        puts "!!! ERROR: Task With Title '#{target_title}' Not Found !!!" 
      end  
    end
    
    
    puts "--- User Login ---" 
    
    attempts = 0 
    
    loop do
      
      if attempts >= 3
        puts "Too many failed login attempts. Returning to main menu..."
        break
      end
      
      print "Enter email: "
      @email = gets.strip 
      
      print "Enter password: "
      @password = gets.strip  
      
      if self.validate(@email, @password)   
        
        return task_menue
      else 
        
        attempts += 1
        puts "Invalid Email Or Password!)"
        next 
      end 
    end 
    
    
    
    def self.task_validate(h)
      a = File.readlines("task.csv") 
      a.any? do |line| 
        t1,d1,s1,e,d = line.chomp.split(",") 
        t1 == h 
      end 
      
    end 
    
    
  end 
  
  def self.task_menue 
    loop do
      puts "\n------- Welcome -------" 
      puts "1. Create Task"
      puts "2. View All Task"
      puts "3. View task by specific user"
      puts "4. Delete Task" 
      puts "5. Status Update"  
      puts "6. view all users"  
      puts "7. assign task"
      puts "8. Logout" 
      print "Enter your choice: "
      choice = gets.strip
      case choice
      when "1" then create_task 
      when "2" then view_all_task(@email)
      when "3" then task_by_Specific_user 
      when "4" then delete_task 
      when "5" then update_task_Status 
      when "6" then view_all_users 
      when "7" then assign_task
      when "8"
        puts "Logging out..."
        return
      else
        puts "Invalid choice." 
      end
    end 
    
  end  
  
  def self.view_all_users 
    puts "-----All Users-----" 
    
    a = File.readlines("test.csv") 
    puts a 
  end 
  
  def self.assign_task 
    puts "--- Assign Task to Another User ---"
    
    print "Enter the Title of the task: "
    @target_title = gets.strip
    unless task_validate(@target_title)
      puts "Error: Task with title '#{@target_title}' not found."
      return
    end 
    attempts = 0
    loop do
      return if attempts >= 3
      print "Enter email: "
      @email = gets.strip
      if @email !~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        puts "Invalid Email Format"
        attempts += 1  
        next
      else 
        break 
      end
    end 
    lines = File.readlines("task.csv") 
    found = false
    ul= lines.map do |line| 
      t, d, s, n ,dt= line.chomp.split(",").map(&:strip)
      if t == @target_title 
        found = true
        @new_assignee = @email
        "#{t},#{d},#{s},#{@new_assignee},#{dt}\n" 
      else 
        line
      end 
    end  
    if found 
      File.write("task.csv", ul.join) 
      puts "Task successfully reassigned "
      
    else 
      puts "!!! ERROR: Not Found !!!" 
    end 
  end 
end  