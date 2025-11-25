require "test_helper"

class ComprobantesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comprobante = comprobantes(:one)
  end

  test "should get index" do
    get comprobantes_url
    assert_response :success
  end

  test "should get new" do
    get new_comprobante_url
    assert_response :success
  end

  test "should create comprobante" do
    assert_difference("Comprobante.count") do
      post comprobantes_url, params: { comprobante: { num_comp_deposito: @comprobante.num_comp_deposito, num_comp_depreciacion: @comprobante.num_comp_depreciacion, num_comp_diario: @comprobante.num_comp_diario, num_comp_diferencial_cambiario: @comprobante.num_comp_diferencial_cambiario, num_comp_egreso: @comprobante.num_comp_egreso, num_comp_pago: @comprobante.num_comp_pago, tipo_comprobante_id: @comprobante.tipo_comprobante_id, tipo_comprobante_pago_id: @comprobante.tipo_comprobante_pago_id } }
    end

    assert_redirected_to comprobante_url(Comprobante.last)
  end

  test "should show comprobante" do
    get comprobante_url(@comprobante)
    assert_response :success
  end

  test "should get edit" do
    get edit_comprobante_url(@comprobante)
    assert_response :success
  end

  test "should update comprobante" do
    patch comprobante_url(@comprobante), params: { comprobante: { num_comp_deposito: @comprobante.num_comp_deposito, num_comp_depreciacion: @comprobante.num_comp_depreciacion, num_comp_diario: @comprobante.num_comp_diario, num_comp_diferencial_cambiario: @comprobante.num_comp_diferencial_cambiario, num_comp_egreso: @comprobante.num_comp_egreso, num_comp_pago: @comprobante.num_comp_pago, tipo_comprobante_id: @comprobante.tipo_comprobante_id, tipo_comprobante_pago_id: @comprobante.tipo_comprobante_pago_id } }
    assert_redirected_to comprobante_url(@comprobante)
  end

  test "should destroy comprobante" do
    assert_difference("Comprobante.count", -1) do
      delete comprobante_url(@comprobante)
    end

    assert_redirected_to comprobantes_url
  end
end
