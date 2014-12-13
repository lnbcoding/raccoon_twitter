class Tweet < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :user
  validates :user, uniqueness: true
end
