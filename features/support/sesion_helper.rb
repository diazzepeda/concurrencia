module SesionHelper
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

  def seleccionar_select2(sesion, selector_contenedor, texto_opcion)
    sesion.find(selector_contenedor).click
    xpath_opcion_select2 = "//body//li[@class='select2-results__option'][text()='#{texto_opcion}']"
    sesion.find(:xpath, xpath_opcion_select2).click
  end

  def seleccionar_select2_con_busqueda(sesion, selector_contenedor_select, texto_opcion, texto_busqueda = texto_opcion)
    sesion.within(:xpath, selector_contenedor_select) do
      sesion.find(:xpath, ".//span[@class='select2-selection__rendered']", match: :first).click
    end
    sesion.find(:xpath, '//body').find('input.select2-search__field', match: :first).set(texto_busqueda)
    sesion.find(:xpath, '//body').find('.select2-results__option', text: texto_opcion, match: :first).click
  end

  def establecer_valor_campo_detalles(sesion, indice_fila, clase_campo, valor)
    sesion.within(:xpath, ".//div[contains(@id, 'comprobante_detalles_items')]") do
      sesion.within(:xpath, ".//div[contains(@class, 'has_many has_many-item')][#{indice_fila}]") do
        sesion.assert_selector(".#{clase_campo}")
        elemento = sesion.find(".#{clase_campo}")
        sesion.execute_script("$('.#{clase_campo}').focus()")
        sesion.execute_script("arguments[0].value = '#{valor}';", elemento)
        sesion.execute_script("$('.#{clase_campo}').click()")
        sesion.execute_script('$(".datepicker.datepicker-dropdown.dropdown-menu.datepicker-bottom").hide();')
      end
    end
  end

  def iniciar_sesion(sesion, url, id_usuario)
    email_usuario = "usuario#{id_usuario}@agssa.net"
    clave_usuario = "usuario#{id_usuario}@agssa.net123456"
    sesion.visit("#{url}/admin_users/sign_in")
    sesion.fill_in 'Email', with: email_usuario
    sesion.fill_in 'Password', with: clave_usuario
    sesion.click_button 'Iniciar sesión'
  end

  def construir_comprobante(sesion)
    seleccionar_select2(sesion, '#select2-comprobante_tipo_comprobante_id-container', 'Comprobante de pago')
    seleccionar_select2(sesion, '#select2-comprobante_tipo_comprobante_pago_id-container', 'Efectivo')
    seleccionar_select2(sesion, '#select2-comprobante_proveedor_id-container', ENV_PROD[:proveedor])
    sesion.find('#select2-comprobante_tipo_moneda_id-container', wait: 0).click
    sesion.find(:xpath, "//body", wait: 0).find("li.select2-results__option", text: "C$", match: :first, visible: :all, wait: 0).click
    sesion.fill_in 'comprobante_tasa_cambio', with: '36.00'

    2.times do |i|
      sesion.find('#add_comprobante_detalles').click

      selector_contenedor_select = ".//div[contains(@id, 'comprobante_detalles_items')]//div[contains(@class, 'has_many has_many-item')][#{i + 1}]//select[contains(@id, 'cuenta_contable_id')]/.."
      seleccionar_select2_con_busqueda(
        sesion,
        selector_contenedor_select,
        ENV_PROD[:cuenta_contable_nombre]
      )
    end

    establecer_valor_campo_detalles(sesion, 1, 'debe', '1')
    establecer_valor_campo_detalles(sesion, 2, 'haber', '1')

    sesion.fill_in 'comprobante_tasa_cambio', with: '36.00'
  end

  def condiciones_por_escenario(sesion, numero_instancia, nombre_escenario)
    case nombre_escenario
    when 'cambia_el_numero_en_la_sesion_5'
      if numero_instancia == 5
        p "En usuario #{numero_instancia} cambio el numero a 2."
        sesion.fill_in 'comprobante_num_comp_pago', with: '2'
      end
    when 'errores_en_5_sesiones'
      case numero_instancia
      when 2
        establecer_valor_campo_detalles(sesion, 2, 'haber', '0')
      when 4
        sesion.fill_in 'comprobante_tasa_cambio', with: '0.00'
      when 6
        seleccionar_select2(sesion, '#select2-comprobante_tipo_comprobante_pago_id-container', 'Transferencia')
      when 8
        sesion.fill_in 'comprobante_fecha', with: ''
      when 10
        sesion.fill_in 'comprobante_num_comp_pago', with: '1'
      end
    end
  end
end

World(SesionHelper)
