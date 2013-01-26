class Movie < ActiveRecord::Base
  def self.ratings
    self.select(:rating).map(&:rating).uniq
  end
end
