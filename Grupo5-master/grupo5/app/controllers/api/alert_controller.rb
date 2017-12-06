class Api::AlertController < ApplicationController

	before_action :authenticate_user!
	before_action do |c|
		authorize_user!([Constants::SUPERVISOR, Constants::SERVICE , Constants::SYSO ])
	end

  # GET /api/registro_mediciones
  # GET /api/registro_mediciones.json
		def index
    	#render json: Api::Alert.all, status: :ok
  	end

		def alerts_area
			@alerts = Api::Alert.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id))
			gon.alerts_area = Api::RegistroMedicion.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id)).order("created_at DESC").paginate(page: params[:page], per_page: 5)
			gon.alerts_area_temp = Api::RegistroMedicion.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id)).where(:variable_ambiental_id.in => Api::VariableAmbiental.where(tipo: "Temperatura").pluck(:id))
			gon.alerts_area_son = Api::RegistroMedicion.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id)).where(:variable_ambiental_id.in => Api::VariableAmbiental.where(tipo: "Sonido").pluck(:id))
			gon.alerts_area_mono = Api::RegistroMedicion.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id)).where(:variable_ambiental_id.in => Api::VariableAmbiental.where(tipo: "Monoxido").pluck(:id))
			gon.alerts_area_lux = Api::RegistroMedicion.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id)).where(:variable_ambiental_id.in => Api::VariableAmbiental.where(tipo: "Luz").pluck(:id))
		end
end
