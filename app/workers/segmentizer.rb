class Segmentizer
  include Sidekiq::Worker
  sidekiq_options queue: "Segmentizer"

  def perform(id)
    segment = Segment.find(id)
    segment.sync_segmentizations
  end
end