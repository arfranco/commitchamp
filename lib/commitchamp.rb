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

    def fetch 
    end

    def get_org
      input = prompt("Welcome! Would you like to choose an existing repo ('e') or fetch a new one('f')?", /^[ef]$/)
      if input == "f"
        organization = prompt("Great! Which organization would you like to fetch from?", /^\w+$/)
        org = @github.get_org(organization)
        org.each do |repo|
          final_result = {
            owner: repo['owner']['login'],
            full_name: repo['full_name'],
            name: repo['name'] 
          }
        self.create_repo(final_result)
        end
      else
        existing_org = prompt("Great! Here are the existing organizations. Please choose an organization:", /^\w+$/)
        Repo.all
      end
    end

    def create_repo(org_hash)
      Repo.create(org_hash)
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
binding.pry
