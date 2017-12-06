class Api::MicrocontroladorController < ApplicationController

	before_action :authenticate_user!
	before_action do |c|
		authorize_user!([Constants::SUPERVISOR, Constants::SERVICE , Constants::SYSO ])
	end

	def index
		#render json: Api::Microcontrolador.all, status: :ok
	end
end
