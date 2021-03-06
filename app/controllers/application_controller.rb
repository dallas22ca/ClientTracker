class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: :api_hit?
  before_filter :authenticate_user_from_api_key!, if: :api_hit?
  before_filter :authenticate_user!, unless: :img_hit?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_user
  before_filter :set_time_zone
  before_filter :set_time_cookies
  
  private
  
  def api_hit?
    (params[:remetric_api_key] || params[:api_key]) && request.format == :json
  end
  
  def img_hit?
    action_name == "img"
  end
  
  def set_time_zone
    Time.zone = @user.time_zone if @user
  end
  
  def set_time_cookies
    cookies[:now_offset] = { value: params[:now_offset] || 0, expires: 1.day.from_now } if @user && params[:now_offset]
  end
  
  def set_times
    @finish = Time.zone.now
    @start = @finish - cookies[:now_offset].to_i
  end
  
  def set_user
    @user = current_user
  end
  
  def authenticate_user_from_api_key!
    if /(contacts\#(save|overwrite)|events\#(create|img))/ =~ "#{controller_name}##{action_name}"
      api_key = params[:api_key]
      api_key ||= params[:remetric_api_key]
      user = User.where(api_key: api_key).first
      sign_in user, store: false if user
    else
      false
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:remember_me, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:remember_me, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :time_zone, :email, :password, :password_confirmation, :current_password) }
  end
end
