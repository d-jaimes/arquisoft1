class Api::UsuarioController < ApplicationController

	before_action :authenticate_user!
	before_action do |c|
		authorize_user!([Constants::SUPERVISOR, Constants::SERVICE , Constants::SYSO ])
	end

  # GET /api/usuario
  # GET /api/usuario.json
	def index
		render json: Api::Usuario.all, status: :ok
	end

end
