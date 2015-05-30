module Commitchamp
  class Repos < ActiveRecord::Base 
    has_many :users, through: :contributions
    has_many :contributions
  end 
end