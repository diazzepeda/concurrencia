require "application_system_test_case"

class ComprobantesTest < ApplicationSystemTestCase
  setup do
    @comprobante = comprobantes(:one)
  end

  test "visiting the index" do
    visit comprobantes_url
    assert_selector "h1", text: "Comprobantes"
  end

  test "should create comprobante" do
    visit comprobantes_url
    click_on "New comprobante"

    fill_in "Num comp deposito", with: @comprobante.num_comp_deposito
    fill_in "Num comp depreciacion", with: @comprobante.num_comp_depreciacion
    fill_in "Num comp diario", with: @comprobante.num_comp_diario
    fill_in "Num comp diferencial cambiario", with: @comprobante.num_comp_diferencial_cambiario
    fill_in "Num comp egreso", with: @comprobante.num_comp_egreso
    fill_in "Num comp pago", with: @comprobante.num_comp_pago
    fill_in "Tipo comprobante", with: @comprobante.tipo_comprobante_id
    fill_in "Tipo comprobante pago", with: @comprobante.tipo_comprobante_pago_id
    click_on "Create Comprobante"

    assert_text "Comprobante was successfully created"
    click_on "Back"
  end

  test "should update Comprobante" do
    visit comprobante_url(@comprobante)
    click_on "Edit this comprobante", match: :first

    fill_in "Num comp deposito", with: @comprobante.num_comp_deposito
    fill_in "Num comp depreciacion", with: @comprobante.num_comp_depreciacion
    fill_in "Num comp diario", with: @comprobante.num_comp_diario
    fill_in "Num comp diferencial cambiario", with: @comprobante.num_comp_diferencial_cambiario
    fill_in "Num comp egreso", with: @comprobante.num_comp_egreso
    fill_in "Num comp pago", with: @comprobante.num_comp_pago
    fill_in "Tipo comprobante", with: @comprobante.tipo_comprobante_id
    fill_in "Tipo comprobante pago", with: @comprobante.tipo_comprobante_pago_id
    click_on "Update Comprobante"

    assert_text "Comprobante was successfully updated"
    click_on "Back"
  end

  test "should destroy Comprobante" do
    visit comprobante_url(@comprobante)
    click_on "Destroy this comprobante", match: :first

    assert_text "Comprobante was successfully destroyed"
  end
end
