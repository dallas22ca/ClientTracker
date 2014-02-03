class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: Proc.new { request.format == :json }
  before_filter :authenticate_user_from_api_key!, if: Proc.new { params[:api_key] && request.format == :json }
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_time_cookies, if: Proc.new { request.format == :js }
  
  private
  
  def set_time_cookies
    cookies[:now] = { value: params[:now].to_i == 1 ? 1 : 0, expires: 1.day.from_now }
    cookies[:now_offset] = { value: params[:now_offset] || 0, expires: 1.day.from_now }
    cookies[:start] = { value: !params[:start].blank? ? Time.parse(params[:start]) : 1.days.ago, expires: 1.day.from_now }
    cookies[:finish] = { value: !params[:finish].blank? ? Time.parse(params[:finish]) : Time.zone.now, expires: 1.day.from_now }
  end
  
  def set_times
    if cookies[:now].to_i == 1
      @finish = Time.zone.now
      @start = @finish - cookies[:now_offset].to_i
    else
      @finish = cookies[:finish]
      @start = cookies[:start]
    end
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
