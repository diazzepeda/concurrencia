json.extract! comprobante, :id, :tipo_comprobante_pago_id, :tipo_comprobante_id, :num_comp_diario, :num_comp_pago, :num_comp_egreso, :num_comp_deposito, :num_comp_depreciacion, :num_comp_diferencial_cambiario, :created_at, :updated_at
json.url comprobante_url(comprobante, format: :json)
