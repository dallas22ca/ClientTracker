class Graph < ActiveRecord::Base
  belongs_to :user
  
  def numerator(start, finish)
    @numerator ||= (
      if data["numerator"].to_i == 1
        1
      else
        segment = user.segments.where(id: data["numerator"]).first
        segment ? segment.current_resources("count", start, finish) : user.events.where(created_at: start..finish).count
      end
    )
  end
  
  def denominator(start, finish)
    @denominator ||= (
      if data["denominator"].to_i == 1
        1
      else
        segment = user.segments.where(id: data["denominator"]).first
        segment ? segment.current_resources("count", start, finish) : user.events.where(created_at: start..finish).count
      end
    )
  end
  
  def rate(start, finish)
    @rate ||= (
      r = numerator(start, finish) * 100.00 / denominator(start, finish)
      r.nan? ? "0" : '%.1f' % (r).round(1)
    )
  end
end
