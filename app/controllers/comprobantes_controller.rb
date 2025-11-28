class ComprobantesController < ApplicationController
  before_action :set_comprobante, only: %i[ show edit update destroy ]

  # GET /comprobantes or /comprobantes.json
  def index
    @comprobantes = Comprobante.all
  end

  # GET /comprobantes/1 or /comprobantes/1.json
  def show
  end

  # GET /comprobantes/new
  def new
    @comprobante = Comprobante.new
  end

  # GET /comprobantes/1/edit
  def edit
  end

  # POST /comprobantes or /comprobantes.json
  def create
    @comprobante = Comprobante.new(comprobante_params)
    @comprobante.asignar_numero
    respond_to do |format|
      if @comprobante.save!
        format.html { redirect_to @comprobante, notice: "Comprobante was successfully created." }
        format.json { render :show, status: :created, location: @comprobante }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comprobante.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comprobantes/1 or /comprobantes/1.json
  def update
    respond_to do |format|
      if @comprobante.update(comprobante_params)
        format.html { redirect_to @comprobante, notice: "Comprobante was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @comprobante }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comprobante.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comprobantes/1 or /comprobantes/1.json
  def destroy
    @comprobante.destroy!

    respond_to do |format|
      format.html { redirect_to comprobantes_path, notice: "Comprobante was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comprobante
      @comprobante = Comprobante.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def comprobante_params
      params.expect(comprobante: [ :fecha, :tipo_comprobante_pago_id, :tipo_comprobante_id, :num_comp_diario, :num_comp_pago, :num_comp_egreso, :num_comp_deposito, :num_comp_depreciacion, :num_comp_diferencial_cambiario ])
    end
end
