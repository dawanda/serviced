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
    session.delete(:access_token)
    session.delete(:user_id)
  end

  def github_org_missing
    @github_org = Rails.application.config.github_org
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

    github_org_found = false
    github_org = Rails.application.config.github_org
    github_orgs = github_orgs!(response['access_token'])
    github_orgs.each do |org|
      if org['login'] == github_org
        github_org_found = true
      end
    end

    if not github_org_found
      @github_org = github_org
      redirect_to('/github_org_missing')
    else
      session[:access_token] = response['access_token']
      ensure_user!
      redirect_to '/'
    end
  end
end
