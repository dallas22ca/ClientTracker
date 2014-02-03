class OverviewController < ApplicationController
  before_action :set_times, only: [:index]
  
  def index
    @events = @user.events.where(created_at: @start..@finish)
    @all_epm = []
    @epm = []
    @all_epm_events = @user.events.where(created_at: @start..@finish).order("date_trunc('minute', events.created_at)").group("date_trunc('minute', events.created_at)").count.map{ |k, v| @all_epm.push [k.to_datetime.to_i * 1000, v] }
    
    minute = @start.to_datetime
    while minute < @finish.to_datetime
      @all_epm.push [minute.to_i * 1000, 0]
      minute += 60.seconds
    end
    
    @all_epm.sort.each_slice(@all_epm.size / 25) do |batch|
      start = batch[0][0]
      @epm.push [start, batch.map{|a, b|b}.reduce(:+).to_f / batch.size]
    end
  end
end
