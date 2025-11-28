# features/step_definitions/home_steps.rb
Given("I am on the home page") do
  visit new_admin_user_session_path
end

ENV_PROD = {
  proveedor: 'ACEROS MULTIPLES DE NICARAGUA',
  cuenta_contable_nombre: '1110-0001-0001 / Caja General',
  host: 'http://s0.agssa.net:14096/ambiente3'
}

ENV_TEST = {
  proveedor: 'AG SOFTWARE S.A',
  cuenta_contable_nombre: '5301110 / INSS PATRONAL',
  host: 'http://127.0.0.1:123456'
}

Given('I execute {int} saves at the same to time to comprobantes {string}') do |numero_de_usuarios, escenario|
  Capybara.send(:session_pool).values.each(&:quit)
  hilos = []
  mutex_sincronizacion = Mutex.new
  condicion_sincronizacion = ConditionVariable.new
  sesiones_listas = 0

  url_base = ENV_PROD[:host]

  numero_de_usuarios.times do |indice_instancia|
    numero_instancia = indice_instancia + 1
    hilos << Thread.new do
      sesion = Capybara::Session.new(:selenium_firefox)
      begin
        p "Iniciando sesión número #{numero_instancia}..."
        sleep 10
        iniciar_sesion(sesion, url_base, numero_instancia)
        sleep 10
        sesion.visit "#{url_base}/comprobantes/new"
        sleep 10
        construir_comprobante(sesion)
        sleep 10
        condiciones_por_escenario(sesion, numero_instancia, escenario)

        mutex_sincronizacion.synchronize do
          sesiones_listas += 1
          p "Sesión #{numero_instancia} lista. Total listas: #{sesiones_listas}/#{numero_de_usuarios}"

          if sesiones_listas < numero_de_usuarios
            condicion_sincronizacion.wait(mutex_sincronizacion)
          else
            condicion_sincronizacion.broadcast
            p 'Todas las sesiones listas. Iniciando Guardar concurrente.'
          end
        end

        sesion.click_button 'Guardar'

        Thread.current[:resultado] = true

      rescue StandardError => e
        p "Error en sesión #{numero_instancia}: #{e.message}"
        Thread.current[:resultado] = false
      ensure
        p "Cerrando driver de sesión #{numero_instancia}..."
        sesion.driver.quit
      end
    end
  end
  hilos.each(&:join)
end
