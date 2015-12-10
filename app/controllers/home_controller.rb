class HomeController < ApplicationController
  def index
    scope = Rails.application.config.github_scope
    client_id = Rails.application.config.github_client_id

    @auth_url = "https://github.com/login/oauth/authorize" +
                "?scope=#{scope}&client_id=#{client_id}"
  end

  def github_callback
    session_code = params[:code]
    client_id = Rails.application.config.github_client_id
    client_secret = Rails.application.config.github_client_secret

    result = RestClient.post('https://github.com/login/oauth/access_token',
        { :client_id => client_id,
          :client_secret => client_secret,
          :code => session_code },
        :accept => :json)

    puts 'headers'
    puts result.headers['Content-Type']
    puts "result: #{result}"

    access_token = JSON.parse(result)['access_token']
    puts "parsed access_token = #{access_token}"
    session[:access_token] = access_token

    redirect_to '/'
  end
end
