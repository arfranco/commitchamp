module Commitchamp
  class Contributions < ActiveRecord::Base 
    belongs_to :repos
    belongs_to :users
  end 
end