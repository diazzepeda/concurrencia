# features/step_definitions/home_steps.rb
Given("I am on the home page") do
  visit new_admin_user_session_path
end

BASE_URL = "http://127.0.0.1:123456"
HOME_AD = "/home/adiaz/workspace/ruby/rubyledger_test2"

def abrir_sesion(session, url, usuario_id)
  session.visit("#{url}/admin_users/sign_in")
  session.fill_in 'admin_user_email', with: "usuario#{usuario_id}@example.com"
  session.fill_in 'admin_user_password', with: "123456"
  session.click_button 'Log in'
end

Given('que ejecuto {int} logins simultáneos') do |numero_de_usuarios|
  #Capybara.send(:session_pool).values.each(&:quit)
  threads = []
  start_time = Time.now
  mutex = Mutex.new
  cv = ConditionVariable.new
  ready_count = 0

  numero_de_usuarios.times do |numero_instancia|
    numero_instancia+= 1

    threads << Thread.new do
      session = Capybara::Session.new(:selenium_firefox)
      begin
      puerto = Capybara.current_session.server.port
      url = BASE_URL.gsub('123456', "3000".to_s)
      abrir_sesion(session, url, numero_instancia) 
      session.visit "#{url}/documentos/new"

      mutex.synchronize do
          ready_count += 1
          if ready_count < numero_de_usuarios
            cv.wait(mutex)
          else
            cv.broadcast
          end
        end

      p "#{Time.zone.now}"
      session.click_button 'Create Documento'

      sleep 5
        # screenshot de resultado
        FileUtils.mkdir_p("#{Rails.root}/features/screenshots/concurrent")
        timestamp = Time.now.strftime('%H%M%S_%L')
        screens = session.save_screenshot("#{Rails.root}/features/screenshots/concurrent/user#{numero_instancia}_#{timestamp}.png")
          puts screens
        Thread.current[:result] = true
      rescue => e
        Thread.current[:result] = false
        session.save_screenshot("#{Rails.root}/features/screenshots/concurrent/error_user#{numero_instancia}.png") rescue nil
        puts "❌ Error en usuario#{numero_instancia}: #{e.message}"
      ensure
        session.quit rescue nil
      end
    end
  end

  threads.each(&:join)
  @results = threads.map { |t| t[:result] }

  @elapsed_time = Time.now - start_time
end
