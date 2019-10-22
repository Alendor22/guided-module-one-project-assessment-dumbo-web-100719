class CommandLineInterface

  def initialize
    @prompt = TTY::Prompt.new
  end

    # def admin
    #     @prompt.select("Are you a patient or administrator") do |menu|
    #         menu.choice "patient", -> { login}
    #         menu.choice "Administrator",  -> { password }

    #    end
    # end

    # def password 
    #     password = @prompt.ask("Please Enter Password") do |m|
    #         if password == "adeja"
    #             admin_view
    # end

  # This is to add new patient if they do not exist in the db
  def new_patient 
    patient_name =  @prompt.ask("Please Enter Your Name")
    patient_phone = @prompt.ask("Please Enter Your Phone Number")
    patient_email = @prompt.ask("Please Enter Your Email Address")
    @patient = Patient.create(name: patient_name, phone: patient_phone, email: patient_email)
    appointment_system 
  end


  # This is login method is displayed first
  def login
    puts "Welcome to the Lendor Online Patient Portal"
    @prompt.select "Are you a returning patient?" do |menu|
      menu.choice "Yes", -> do
      phone = @prompt.ask("Please Enter Your Phone Number")
      @patient = Patient.find_by(phone: phone)
        
        if @patient.nil?
          puts "Sorry, cannot find a patient with that phone number"
          @prompt.select "What would you like to do?" do |m|
            m.choice "Try Again", -> { login }
            m.choice "Create Account", -> { new_patient }
            m.choice "Exit", -> {  exit_method  }
            end
        end
  end
    menu.choice "No (Create New patient Portal)", -> { new_patient }
    menu.choice "Exit The System", -> { exit_method }
    end
  end

  # This is helper method
  def ask
    @prompt.select "Would you like to schedule appointment now" do |menu|
        menu.choice " Yes", ->  { schedule_appointment }
        menu.choice " No <Go Back>", ->  { appointment_system }
      end
  end

  def doctor_all
    @prompt.select("Select Doctor") do |menu|
      Doctor.all.each do |doctor|
      #binding.pry
      menu.choice "#{doctor.name}", -> { @patient.appointments.last.update(doctor_id: doctor.id) }
      # appointment
      end
    end
  end

  # Since we already know who the patient is we can simply push the appointment to @patient (joiner Instance)
  def schedule_appointment
    @doctors = Doctor.all.map {|doctor| doctor.name}.join(",")
    doctor_choice = @prompt.select("What Doctor would you like to choose?", @doctors.split(","))
    @doctor = Doctor.find_by(name: doctor_choice)
    entered_time = @prompt.ask("Plase Enter Date and Time -> Ex. 12/12/12 AT 12:00 PM ")
    @patient.appointments << Appointment.create(time: entered_time, patients: @patient.name, doctor_id: @doctor.id) 
    sleep(2)
    # @patient.appointments.create(patient_id: patient_id, doctor_id: doctor_id)
         appointment_system
        #doctor_id: Doctor.first.id, 
  end

   # This method is checking the appointments array if the patient has appointments it will display
   # Pluck directly converts a database result into an array, without constructing ActiveRecord objects
   def view_appointment
    if @patient.appointments.length < 1
        puts "You currently have no appointments"
        sleep(2)
    else 
        puts "Here are your appointments:"
        @patient.appointments.pluck(:time).each { |time| puts " - #{time}" } 
        @prompt.select "" do |m| 
            m.choice "<Go Back>", -> { appointment_system }
        end
    end
        appointment_system
  end

# This is a helper method for changing appointments
    def change_appt(appt) 
      time = @prompt.ask("Plase Enter The New Date and Time -> Ex. 12/12/12 AT 12:00 PM")
      appt.update(time: time)
    end

# This method is for rescheduling
    def reschedule_appointment
      if @patient.appointments.length < 1
        puts "You currently have no appointments"
        sleep(2)
      else
      @prompt.select "Which appointment would you like to Reschedule?" do |menu|
        @patient.appointments.each do |appt|
          menu.choice appt.time, -> { change_appt(appt)  }
          end
          menu.choice "<Go Back>", -> {  appointment_system   }  #back 
          end
      end
        @patient.reload
        appointment_system
    end

    # This method is for canceling the appointment using .destory
    def cancel_appointment
      if @patient.appointments.length < 1
        puts "You currently have no appointments"
        sleep(2)
      else
      @prompt.select "Which appointment would you like to cancel?" do |menu|
        @patient.appointments.each do |appt|
        menu.choice appt.time, -> { appt.destroy }  
        end
        menu.choice "<Go Back>", -> {  appointment_system    } #back
      end
    end
      @patient.reload
      appointment_system
    end


    def exit_method
      exit
    end

    def appointment_system
      puts `clear`
      @prompt.select("Please Select Your Option") do |menu|
        menu.choice "Schedule Appointment", -> { ask } 
        menu.choice "View Appointment", -> { view_appointment }
        menu.choice "Reschedule Appointment", -> { reschedule_appointment }
        menu.choice "Cancel Appointment", -> { cancel_appointment }
        menu.choice "Exit", -> { exit_method }
        end
    end

    def admin_view
      Appointment.all.each do |appt|
          puts "Name: #{appt.clients} Time:  #{appt.time}"
        end
    end

end  