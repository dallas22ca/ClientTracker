class OverviewController < ApplicationController
  before_action :set_times, only: [:index]
  
  def index
    @events = @user.events.where(created_at: @start..@finish)
    @all_epm = []
    @epm = []
    @all_epm_events = @events.group("date_trunc('minute', events.created_at)").count.map{ |k, v| @all_epm.push [k.to_datetime.to_i * 1000, v] }
    
    minute = @start.to_datetime
    while minute < @finish.to_datetime
      @all_epm.push [minute.to_i * 1000, 0]
      minute += 60.seconds
    end
    
    batch_size = @all_epm.size / 25
    batch_size = 25 if batch_size == 0
    batch_duration = (@finish.to_i - @start.to_i) / 25
    
    @all_epm.sort.each_slice(batch_size) do |batch|
      start = batch[0][0]
      @epm.push [start, batch.map{|a, b|b}.reduce(:+).to_f / batch.size]
    end
    
    @latest_events = []
    @grouped_descriptions = @events.group_by(&:description)
    
    @grouped_descriptions.each do |k, v|
      data = []
      
      time = @start.to_datetime
      while time < @finish.to_datetime
        data.push [time.to_i * 1000, @events.where(description: k, created_at: time..time + (batch_duration - 1).seconds).count]
        time += batch_duration.seconds
      end
      
      d = { 
        name: "#{k} (#{v.count} events)", 
        animation: false, 
        lineWidth: 2, 
        marker: { 
          enabled: false 
        },
        data: data
      }

      @latest_events.push d
    end
  end
end
