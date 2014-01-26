class Event < ActiveRecord::Base
  store_accessor :data
  belongs_to :contact
  belongs_to :user
  
  def full_description
    Liquid::Template.parse(description).render(data)
  end
end
