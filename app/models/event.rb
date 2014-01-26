class Event < ActiveRecord::Base
  store_accessor :data
  belongs_to :contact
  belongs_to :user
end
