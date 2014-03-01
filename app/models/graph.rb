class Graph < ActiveRecord::Base
  belongs_to :user
  
  def numerator(start, finish)
    @numerator ||= (
      segment = user.segments.where(id: data["numerator"]).first
      segment ? segment.current_resources("count", start, finish) : user.events.where(created_at: start..finish).count
    )
  end
  
  def denominator(start, finish)
    @denominator ||= (
      segment = user.segments.where(id: data["denominator"]).first
      segment ? segment.current_resources("count", start, finish) : user.events.where(created_at: start..finish).count
    )
  end
  
  def rate(start, finish)
    '%.1f' % (numerator(start, finish) * 100.00 / denominator(start, finish)).round(1)
  end
end
