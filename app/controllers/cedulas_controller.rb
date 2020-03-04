class CedulasController < ApplicationController
  before_action :set_cedula, only: [:show, :edit, :update, :destroy]

  # GET /cedulas
  # GET /cedulas.json
  def index
    @cedulas = Cedula.paginate(page: params[:page], per_page: 20).order("id ASC")
    #@cedulas = Cedula.all
  end

  # GET /cedulas/1
  # GET /cedulas/1.json
  def show
  end

  # GET /cedulas/new
  def new
    @cedula = Cedula.new
  end

  # GET /cedulas/1/edit
  def edit
  end

  # POST /cedulas
  # POST /cedulas.json
  def create
    @cedula = Cedula.new(cedula_params)

    respond_to do |format|
      if @cedula.save
        format.html { redirect_to @cedula, notice: 'Cedula was successfully created.' }
        format.json { render :show, status: :created, location: @cedula }
      else
        format.html { render :new }
        format.json { render json: @cedula.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cedulas/1
  # PATCH/PUT /cedulas/1.json
  def update
    respond_to do |format|
      if @cedula.update(cedula_params)
        format.html { redirect_to @cedula, notice: 'Cedula was successfully updated.' }
        format.json { render :show, status: :ok, location: @cedula }
      else
        format.html { render :edit }
        format.json { render json: @cedula.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cedulas/1
  # DELETE /cedulas/1.json
  def destroy
    @cedula.destroy
    respond_to do |format|
      format.html { redirect_to cedulas_url, notice: 'Cedula was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cedula
      @cedula = Cedula.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cedula_params
      params.require(:cedula).permit(:cedula_number, :cedula_type, :name, :last_name_1, :last_name_2, :gender, :title, :institution, :year)
    end
end
