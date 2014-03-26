class Segment < ActiveRecord::Base
  serialize :conditions
  belongs_to :user
  
  has_many :segmentizations
  has_many :contacts, through: :segmentizations
  has_many :events, through: :segmentizations
  has_many :messageships
  has_many :messages, through: :messageships
  
  after_commit :sidekiq_sync_segmentizations
  
  scope :for_events, -> { where model: "Event" }
  scope :for_contacts, -> { where model: "Contact" }
  
  def sidekiq_sync_segmentizations
    Segmentizer.perform_async id
  end
  
  def sync_segmentizations
    new_segmentizations = []
    not_in = current_resources.pluck(:id)
  
    no_longer = segmentizations.where("segmentizations.#{model.downcase}_id not in (?)", not_in)
    no_longer_count = no_longer.count
    no_longer.destroy_all
  
    current_segmentizations = segmentizations.pluck("#{model.downcase}_id".to_sym)
    current_segmentizations = [0] if current_segmentizations == []

    current_resources.where("#{model.pluralize}.id not in (?)", current_segmentizations).find_each do |resource|
      s = { segment_id: id }
      s["#{model.downcase}_id".to_sym] = resource.id
      new_segmentizations.push s
    end
  
    Segmentization.create new_segmentizations
    self.update_columns segmentizations_count: segmentizations.count
  end
  
  def resources
    @resources ||= user.send(model.downcase.pluralize)
  end
  
  def current_resources(output = nil, start = nil, finish = nil)
    n = 0
    query = ""
  
    conditions.each do |attribute, matcher, search, joiner|
      join = ""
      join = " #{joiner} " if conditions.size != n - 1
    
      if matcher == "exists"
        query += "#{model.downcase.pluralize}.data ? '#{attribute}'#{join}"
      elsif matcher == "does not exist"
        query += "exist(#{model.downcase.pluralize}.data, '#{attribute}') is false#{join}"
      elsif matcher == "!="
        query += "(exist(#{model.downcase.pluralize}.data, '#{attribute}') is false or #{model.downcase.pluralize}.data -> '#{attribute}' #{matcher} '#{search}') #{join}"
      elsif [">", ">=", "<", "<="].include? matcher
        query += "(#{model.downcase.pluralize}.data -> '#{attribute}')::float #{matcher} #{search.to_i}#{join}"
      else
        query += "#{model.downcase.pluralize}.data -> '#{attribute}' #{matcher} '#{search}'#{join}"
      end
    
      n += 1
    end
    
    if start && finish
      if output == "count"
        resources.where(query).where(created_at: start..finish).count
      else
        resources.where(query).where(created_at: start..finish)
      end
    else
      if output == "count"
        resources.where(query).count
      else
        resources.where(query)
      end
    end
  end
end
