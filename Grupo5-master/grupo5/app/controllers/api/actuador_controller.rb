class Api::ActuadorController < ApplicationController

  before_action :authenticate_user!
  before_action do |c|
    authorize_user!([Constants::SUPERVISOR, Constants::SERVICE , Constants::SYSO ])
  end

  def index
    render json: Api::Actuador.all, status: :ok
  end

  def actuadores_area
    @actuadores = Api::Actuador.where(:microcontrolador_id.in => Api::Microcontrolador.where(area: params[:area]).pluck(:id)).order("created_at DESC").paginate(page: params[:page], per_page: 10)
  end
end
