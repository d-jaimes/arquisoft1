module Auth0Helper
  module Constants
    SYSO = 'SYSO'
    SUPERVISOR = 'Supervisor'
    SERVICE = 'Service'
  end

  private
  # Is the user signed in?
  # @return [Boolean]
  def user_signed_in?
    session[:userinfo].present?
  end

  # Set the @current_user or redirect to public page
  def authenticate_user!

    # Redirect to page that has the login here
    if user_signed_in?
      @current_user = session[:userinfo]

      namespace = 'https://arquisoft201720-wrravelo:auth0:com/app_metadata'
      @current_user[:roles] = session[:userinfo][:extra][:raw_info][namespace][:roles]
    elsif request.headers['HTTP_AUTHORIZATION']
      complete_token = request.headers['HTTP_AUTHORIZATION']
      jwt_token = complete_token.split('Bearer')[1].strip
      decoded_token = JWT.decode jwt_token, nil, false
      type = decoded_token[0]["gty"]

      if type == 'client-credentials'
        @current_user = { roles: ['Service'] }
      else
        render :json => { :mssg => 'No tiene privilegios para ver la información' }, status: :unauthorized
      end
    else
      render :json => { :mssg => 'No tiene privilegios para ver la información' }, status: :unauthorized
    end
  end

  def authorize_user!(roles)
    if !@current_user || (@current_user[:roles] & roles).empty?
      render :json => { :mssg => 'No tiene privilegios para ver la información' }, status: :unauthorized
    end
  end

  # What's the current_user?
  # @return [Hash]
  def current_user
    @current_user
  end

  # @return the path to the login page
  def login_path
    redirect_to '/'
  end
end
