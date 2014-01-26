class Messageship < ActiveRecord::Base
  belongs_to :message
  belongs_to :segment
end
