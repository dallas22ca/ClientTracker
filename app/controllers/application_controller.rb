class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: Proc.new { request.format == :json }
  before_filter :authenticate_user_from_api_key!, if: Proc.new { (params[:api_key] || params[:remetric_api_key]) && request.format == :json }
  before_filter :authenticate_user!
  before_filter :set_user
  around_filter :set_time_zone, if: :current_user
  before_filter :set_time_cookies
  
  private
  
  def set_time_zone(&block)
    Time.use_zone(@user.time_zone, &block)
  end
  
  def set_time_cookies
    cookies[:now_offset] = { value: params[:now_offset] || 0, expires: 1.day.from_now } if params[:now_offset]
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
      api_key = params[:api_key] || params[:remetric_api_key]
      user = User.where(api_key: api_key).first
      sign_in user, store: false if user
    else
      false
    end
  end
end
