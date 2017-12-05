class HomeController < ApplicationController
  def login
  end

  def logout
    reset_session
    redirect_to home_login_url
  end

  def error
  end
end
