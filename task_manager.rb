require 'csv'

module TaskManager
  # 1. Create Task (With 3-Attempt Title Validation)
  def self.create_task(current_user)
    puts "\n--- Create New Task ---"
    title_attempts = 0
    title = ""

    loop do
      if title_attempts >= 3
        puts "!!! Too many failed title attempts. Task cancelled. !!!"
        return
      end

      print "Enter Task Title (Attempt #{title_attempts + 1}/3): "
      title = gets.strip

      # 1. Basic Validations (No Empty, No Start Digit/Special Char)
      if title.empty?
        puts "!!! ERROR: Title cannot be empty !!!"
        title_attempts += 1
        next
      elsif title =~ /\A[\d\W]/
        puts "!!! ERROR: Cannot start with digit or special character !!!"
        title_attempts += 1
        next
      elsif title =~ /\d/
        puts "!!! ERROR: Digits are not allowed in title !!!"
        title_attempts += 1
        next 
      end

      # 2. UNIQUE TITLE CHECK (Check if title already exists in task.csv)
      if File.exist?("task.csv")
        title_exists = File.readlines("task.csv").any? do |line|
          # Pehla column (index 0) title hota hai
          line.split(",")[0].strip.downcase == title.downcase
        end

        if title_exists
          puts "!!! ERROR: Task with title '#{title}' already exists. Please use a unique title !!!"
          title_attempts += 1
          next
        end
      end

      break 
    end

    # Description Input
    desc_attempts = 0
    desc = ""
    loop do
      if desc_attempts >= 3
        puts "!!! Too many failed description attempts. Task cancelled. !!!"
        return
      end

      print "Enter Description (Attempt #{desc_attempts + 1}/3): "
      desc = gets.strip

      if desc.empty?
        puts "!!! ERROR: Description khali nahi ho sakta !!!"
        desc_attempts += 1
      else
        break 
      end
    end

    # Status Validation
    status_attempts = 0
    status = ""
    loop do
      if status_attempts >= 3
        puts "!!! Too many failed status attempts. Task cancelled. !!!"
        return
      end
      print "Enter Status (pending/completed): "
      status = gets.strip.downcase
      break if ["pending", "completed"].include?(status)
      puts "!!! ERROR: Status must be 'pending' or 'completed' only !!!"
      status_attempts += 1
    end
    
     date = Time.now.strftime("%d/%m/%Y")
    # Data Save in CSV
    CSV.open("task.csv", "a+") { |csv| csv << [title, desc, status, current_user, date] }
    puts " Task '#{title}' Created Successfully!"
  end

  # 2. View All Tasks
  def self.view_all_task(my_email)

    found = false

    
    assigned_to_me = []
    if File.exist?("assignments.csv")
      File.readlines("assignments.csv").each do |line|
        title, from, to, date = line.chomp.split(",").map(&:strip)
        assigned_to_me << title if to == my_email
      end
    end

   
    if File.exist?("task.csv")
      File.readlines("task.csv").each do |line|
        title, desc, status, creator, date = line.chomp.split(",").map(&:strip)

        
        is_creator = (creator == my_email)
        is_assignee = assigned_to_me.include?(title)

        if is_creator || is_assignee
          
          puts("#{title} | #{desc} | #{status} | #{date}")
          found = true
        end
      end
    end

    puts "!!! No tasks found for you !!!" unless found
    
  end

  # 3. View Task by Specific User 
  def self.task_by_specific_user
    email = nil
    
    
    3.times do |i|
      print "Enter the email to search tasks (Attempt #{i+1}/3): "
      input = gets.strip.downcase

      
      if input.empty?
        puts "!!! ERROR: Email cannot be empty !!!"
      elsif !input.include?("@") || !input.include?(".")
        puts "!!! ERROR: Invalid email format  !!!"
      else
        email = input
        break
      end

      
      if i == 2
        puts "!!! Too many failed attempts. Returning to menu !!!"
        return
      end
    end

    
    unless File.exist?("task.csv")
      puts "!!! ERROR: task.csv file not found !!!"
      return
    end

   
    
    puts " TASKS CREATED BY: #{email}"
    
    found = false
    File.readlines("task.csv").each do |line|
      
      t, d, s, creator_email, date = line.chomp.split(",").map(&:strip)
      
      if creator_email == email
        printf( t, d, s)
        found = true
      end
    end

    puts "!!! No tasks found for this user !!!" unless found
    
  end

  # 4. Delete Task
  def self.delete_task
    attempts = 0
    loop do
      return puts "!!! Too many attempts !!!" if attempts >= 3
      return puts "!!! File not found !!!" unless File.exist?("task.csv")

      print "Enter Title to Delete (Attempt #{attempts+1}/3): "
      target = gets.strip
      lines = File.readlines("task.csv")
      new_lines = lines.reject { |l| l.split(",")[0].strip == target }

      if lines.length > new_lines.length
        File.write("task.csv", new_lines.join)
        puts "✔ Task Deleted Successfully!"
        break
      else
        puts "!!! Task Not Found !!!"
        attempts += 1
      end
    end
  end

  # 5. Status Update
  def self.status_update
    puts "\n--- Update Task Status ---"
    attempts = 0

    loop do
      if attempts >= 3
        puts "!!! Too many invalid attempts. Returning to Menu. !!!"
        return
      end

      return puts "!!! File not found !!!" unless File.exist?("task.csv")

      print "Enter Title to Update Status (Attempt #{attempts+1}/3): "
      target = gets.strip
      lines = File.readlines("task.csv")
      found = false
      already_completed = false

      updated = lines.map do |line|
        t, d, s, n = line.chomp.split(",").map(&:strip)
        if t == target
          found = true
          
          # 1. Agar task pehle se Completed hai toh error dekar bahar nikal jao
          if s.downcase == "completed"
            already_completed = true
            line
          else
            # 2. Agar task Pending hai, toh status update ka loop chalao
            status_attempts = 0
            new_valid_status = nil
            
            loop do
              if status_attempts >= 3
                puts "!!! Failed to provide 'completed' status in 3 attempts !!!"
                return line # Purana data hi rakhenge
              end

              puts "Current Status: #{s}"
              print "To complete this task, type 'completed' (Attempt #{status_attempts+1}/3): "
              ns = gets.strip.downcase
              
              if ns == "completed"
                new_valid_status = "completed"
                break
              elsif ns == "pending"
                puts "!!! ERROR: Task is already 'pending'. You must change it to 'completed' !!!"
                status_attempts += 1
              else
                puts "!!! ERROR: Invalid status. Only 'completed' is allowed !!!"
                status_attempts += 1
              end
            end
            
            "#{t},#{d},#{new_valid_status},#{n}\n"
          end
        else
          line
        end
      end

      # Final checks after processing lines
      if already_completed
        puts "!!! ERROR: Task '#{target}' is already COMPLETED and cannot be modified !!!"
        break 
      elsif found
        File.write("task.csv", updated.join)
        puts "✔ Success: Status updated to COMPLETED!"
        break
      else
        puts "!!! ERROR: Task with title '#{target}' not found !!!"
        attempts += 1
      end
    end
  end 
  
  # View All Registered users
  def self.view_all_users 
    
    return puts "!!! No tasks found !!!" unless File.exist?("task.csv")
    File.readlines("test.csv").each { |line| puts line }
  end
   
  # Task-Assignment 
  def self.assign_task(my_email)
    
    puts "   ASSIGN YOUR TASK "
    task_title = nil
    attempts = 0
    loop do
      if attempts >= 3
        puts "!!! Too many failed attempts. Task not found or not yours. !!!"
        return
      end

      print "Enter Task Title to Assign (Attempt #{attempts + 1}/3): "
      title_input = gets.strip
      
      
      found_task = false
      
        File.readlines("task.csv").each do |line|
          t_name, d, s, creator = line.chomp.split(",").map(&:strip)
          if t_name == title_input && creator == my_email
            task_title = t_name
            found_task = true
            break
          end
        end
      

      break if found_task
      puts "-> Task Not Found/ You Are Not Owner Of this task!!!!!."
      attempts += 1
    end

    
    receiver_email = nil
    email_attempts = 0
    loop do
      if email_attempts >= 3
        puts "!!! Too many failed attempts. User not found. !!!"
        return
      end

      print "Enter email to assign? (Attempt #{email_attempts + 1}/3): "
      email_input = gets.strip.downcase

      
      user_exists = File.exist?("test.csv") && File.readlines("test.csv").any? do |line|
        u_name, u_email = line.chomp.split(",").map(&:strip)
        u_email == email_input
      end

      if user_exists
        receiver_email = email_input
        break
      else
        puts "-> ERROR: User not Found"
        email_attempts += 1
      end
    end

    t=Time.now.strftime("%d-%m-%Y")
    File.open("assignments.csv", "a") do |f|
      f.puts "#{task_title},#{my_email},#{receiver_email},#{t}"
    end

    puts "\ SUCCESS! Task '#{task_title}' assigned to #{receiver_email}."
  end 

  # Filter  

  def self.filter_all_tasks
    
    choice = ""
    3.times do |i|
      print "\nFilter All Tasks by: (1) Title, (2) Status, (3) Date: "
      choice = gets.strip
      break if ["1", "2", "3"].include?(choice)
      puts "!!! Invalid choice. Enter 1, 2, or 3 (Attempt #{i+1}/3) !!!"
      return if i == 2
    end

    
    search = ""
    3.times do |i|
      print "Enter search keyword: "
      search = gets.strip.downcase
      break unless search.empty?
      puts "!!! Search keyword cannot be empty (Attempt #{i+1}/3) !!!"
      return if i == 2
    end

   
    printf( "TITLE", "DESCRIPTION", "STATUS", "DATE", "CREATED BY")
    

    found = false
    if File.exist?("task.csv")
      File.readlines("task.csv").each do |line|
       
        title, desc, status, creator, date = line.chomp.split(",").map(&:strip)

        
        match = false
        match = true if choice == "1" && title.downcase.include?(search)
        match = true if choice == "2" && status.downcase == search
        match = true if choice == "3" && date == search

        if match
          puts"#{title},#{desc}, #{status}, #{date}, #{creator}"
          found = true
        end
      end
    else
      puts "!!! File 'task.csv' not found !!!"
      return
    end

    puts "!!! No tasks found matching your search !!!" if !found
   
  end
end