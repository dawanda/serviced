class HomeController < ApplicationController
  def index
    if !authenticated? then
      authenticate!
    else
      @user = User.find(session[:user_id])
    end
    @access_token = session[:access_token]
  end

  def logout
    session[:user_id] = nil
    session[:access_token] = nil
    return authenticate!
  end

  def github_callback
    session_code = params[:code]
    client_id = Rails.application.config.github_client_id
    client_secret = Rails.application.config.github_client_secret

    response = JSON.parse(RestClient.post(
        'https://github.com/login/oauth/access_token',
        { :client_id => client_id,
          :client_secret => client_secret,
          :code => session_code },
        :accept => :json))

    session[:access_token] = response['access_token']

    ensure_user!

    redirect_to '/'
  end
end
