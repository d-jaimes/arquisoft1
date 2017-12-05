class Api::VariableAmbientalController < ApplicationController

	before_action :authenticate_user!
	before_action do |c|
		authorize_user!([Constants::SUPERVISOR, Constants::SERVICE , Constants::SYSO ])
	end

	def index
		render json: Api::VariableAmbiental.all, status: :ok
	end

	def create
		@variable_ambiental = Api::VariableAmbiental.new(variable_ambiental_params)

		if @variable_ambiental.save
			render json: @variable_ambiental.to_json, status: :ok
		else
			render :json => { :mssg => 'Hubo un error creando el registro medicion.' }, status: :unprocessable_entity
		end
	end

	private
		def variable_ambiental_params
			params.require(:variable_ambiental).permit(:tipo, :valorMaximo, :valorMinimo, :unidad, :variacionDiaria, :precision)
		end
end
