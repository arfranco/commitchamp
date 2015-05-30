$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pry'

require 'commitchamp/version'
require 'commitchamp/init_db'
require 'commitchamp/github'

module Commitchamp
  class App
    def initialize
      @github = Github.new
    end

    def prompt(question, validator)
      puts question
      input = gets.chomp
      until input =~ validator
        puts "Sorry, wrong answer."
        puts question
        input = gets.chomp
      end
      input
    end
    
  end
end

# app = Commitchamp::App.new
# binding.pry
