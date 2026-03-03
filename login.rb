require 'csv'

module LoginLogic
  def self.login_user 
    def self.validate(ep, pe) 
      #return false unless File.exist?("test.csv")
      a = File.readlines("test.csv") 
      a.any? do |line| 
        e, p = line.chomp.split(",") 
        e == ep && p == pe
      end 
    end  

    def self.create_task 
      print "Enter Title: " 
      @title = gets.chomp 
      print "Description: " 
      @desc = gets.chomp 
      print "Enter Status pending/complited: " 
      @status = gets.chomp  
      print "Created By: " 
      @user = gets.chomp

      CSV.open("task.csv", "a+") do |csv| 
        csv << [@title, @desc, @status, @user] 
      end  
      puts "Task Created !!! "
    end 

    def self.view_all_task 
      puts "-----All Tasks-----" 
      
        a = File.readlines("task.csv") 
        puts a 
      
    end
    
    def self.task_by_Specific_user
      puts "Enter the name" 
      name = gets.chomp
      puts "-----Tasks Created By #{name} Are-------" 
      
        File.readlines("task.csv").each do |line|  
          t, d, s, n = line.chomp.split(",") 
          if (n == name) 
            puts "Title :#{t},Desc :#{d},Status :#{s}" 
          end 
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
       puts "Enter the Title of the task you want to update:" 
       target_title = gets.chomp.strip 

    
       lines = File.readlines("task.csv") 
       found = false

       updated_lines = lines.map do |line| 
         t, d, s, n = line.chomp.split(",").map(&:strip)

         if t == target_title 
          found = true
          puts "Current Status: #{s}"
          print "Enter New Status (pending/completed): "
          new_status = gets.chomp
          "#{t},#{d},#{new_status},#{n}\n" 

         else 
           line
         end 
       end  
       if found 
         File.write("task.csv", updated_lines.join) 
         puts "Task Updated Successfully!"
        else 
          puts "!!! ERROR: Task With Title '#{target_title}' Not Found !!!" 
        end 
    end 
    
       
    
    puts "--- User Login ---"
    print "Enter email: "
    @email = gets.strip 
    
      print "Enter password: "
      @password = gets.strip  

      if self.validate(@email, @password)   
      
        loop do
          puts "\n------- Welcome -------" 
          puts "1. Create Task"
          puts "2. View All Task"
          puts "3. View task by specific user"
          puts "4. Delete Task" 
          puts "5. Status Update" 
          puts "6. Logout" 
          print "Enter your choice: "
          choice = gets.strip
          case choice
          when "1" then create_task 
          when "2" then view_all_task
          when "3" then task_by_Specific_user 
          when "4" then delete_task 
          when "5" then update_task_Status
          when "6"
           puts "Logging out..."
          break
         else
           puts "Invalid choice." 
         end
       end 
     else 
      puts "Invalid Email Or Password !!!!!"
     end 
    
  end
end