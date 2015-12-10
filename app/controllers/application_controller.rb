class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def github_userinfo!
    info = JSON.parse(RestClient.get(
        'https://api.github.com/user',
        {:params => {:access_token => session[:access_token]}}))

    logger.debug "github_userinfo: #{info}"

    info
  end

  def authenticated?
    client_id = Rails.application.config.github_client_id
    client_secret = Rails.application.config.github_client_secret
    scopes = []

    begin
      auth_result = JSON.parse(RestClient.get(
          'https://api.github.com/user',
          {:params => {:access_token => session[:access_token]}}))
      logger.debug "authenticated? got auth_result: #{auth_result}"
    rescue
      session.delete(:access_token)
      session.delete(:user_id)
      return false
    end

    if !session[:user_id] then
      user = ensure_user!
      session[:user_id] = user.id
    else
      user = User.find_by_id(session[:user_id])
      if !user then
        session.delete(:access_token)
        session.delete(:user_id)
        ensure_user!
      end
    end
    return true
  end

  def authenticate!
    scope = Rails.application.config.github_scope
    client_id = Rails.application.config.github_client_id

    github_auth_url = "https://github.com/login/oauth/authorize" +
                       "?scope=#{scope}&client_id=#{client_id}"

    logger.debug "Authenticating with Github: #{github_auth_url}"
    redirect_to github_auth_url
  end

  def ensure_user!
    userinfo = github_userinfo!

    logger.debug "ensure_user! got userinfo: #{userinfo}"

    # create user if user didn't exist yet
    user = User.find_by_username(userinfo['login'])
    if not user then
      user_emails = JSON.parse(RestClient.get(
          'https://api.github.com/user/emails',
          {:params => {:access_token => session[:access_token]}}))

      useremail = user_emails[0]['email']
      user_emails.each do |email_entry|
        if email_entry['primary'] then
          useremail = email_entry['email']
        end
      end

      user = User.create(:username => userinfo['login'],
                         :avatar_url => userinfo['avatar_url'],
                         :is_admin => User.count == 0,
                         :email => useremail)

      session[:user_id] = user.id
    end
    return user
  end
end
