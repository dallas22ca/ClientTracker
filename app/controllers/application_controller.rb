class ApplicationController < ActionController::Base
  before_filter :cors_headers
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: Proc.new { request.format == :json }
  before_filter :authenticate_user_from_api_key!, if: Proc.new { params[:api_key] && request.format == :json }
  before_filter :authenticate_user!
  before_filter :set_user
  
  private
  
  def cors_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
  
  def set_user
    @user = current_user
  end
  
  def authenticate_user_from_api_key!
    if /(contacts\#(save|overwrite)|events\#create)/ =~ "#{controller_name}##{action_name}"
      user = User.where(api_key: params[:api_key]).first
      sign_in user, store: false if user
    else
      false
    end
  end
end
