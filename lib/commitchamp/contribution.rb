module Commitchamp
  class Contribution < ActiveRecord::Base 
    belongs_to :repos
    belongs_to :users
  end 
end