$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pry'

require 'commitchamp/version'
require 'commitchamp/init_db'
require 'commitchamp/github'
require 'commitchamp/repo'
require 'commitchamp/contribution'
require 'commitchamp/user'

module Commitchamp
  class App
    def initialize
      if ENV['OAUTH_TOKEN']
        token = ENV['OAUTH_TOKEN']
      else
        token = get_auth_token
      end
      @github = Github.new
    end

    def get_auth_token
      prompt("Please enter your personal access token for Github: ", /^[0-9a-f]{40}$/)
    end

    def get_org
      input = prompt("Welcome! Would you like to choose an existing repo ('e') or fetch a new one('f')?\n\n", /^[ef]$/)
      if input == "f"
        organization = prompt("Great! Which organization would you like to fetch from?\n\n", /^\w+$/)
        org = @github.get_org(organization)
        org.each do |repo|
          final_result = {
            owner: repo['owner']['login'],
            full_name: repo['full_name'],
            name: repo['name'] 
          }
        self.create_repo(final_result)
        end
        self.display_org_repos(organization)
      else
        existing_org = Repos.all
        self.display_org_repos(existing_org)
      end
    end

    def display_org_repos(org_name)
      repos = Repo.where(owner: org_name)
      puts "Here are the repos for the organization you input:\n\n"
      repos.each do |repo|
        puts "#{repo.full_name}\n"
      end    
    end

    def create_repo(org_hash)
      if Repo.exists?(full_name: org_hash[:full_name]) == false 
        Repo.create(org_hash)
      end
    end

    def get_contributions_stats
      input = prompt("Please type in the owner (first part before the backslash) followed by a space and then a coma then repo you'd like to retrieve stats for: \n\n", /^.+[,].+$/)
      input_array = input.downcase.split(", ")
      contributions = @github.get_contributions(input_array[0], input_array[1])
        contributions.each do |contributer|
          user = User.first_or_create(login: contributer['author']['login'])
          additions = contributer['weeks'].map{ |x| x['a'] }.sum
          deletions = contributer['weeks'].map{ |x| x['d'] }.sum
          commit_count = contributer['total']
        user.contributions.create(additions: additions,
                                  deletions: deletions,
                                  commit_count: commit_count)
        end
        repo_full_name = input_array.join("/")
        self.display_contributions_stats(repo_full_name)
    end  

    def display_contributions_stats(repo_full_name)
      repo = Commitchamp::Repo.find_by(full_name: repo_full_name)
      contributers = repo.contributions.order('additions + deletions + commits DESC').limit(20)
      puts "Contributions for '#{repo.full_name}'"
      puts "Username | Additions | Deletions | Commits"
      contributers.each do |x|
        puts "#{x.user.login} | #{x.additions} | #{x.deletions} | #{x.commits}"
      end
      puts
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

    def run
      self.get_org
      analyze = prompt("Would you like to view the stats for a repo ('v') or exit the application? ('e)", /^[ve]$/)
      if analyze == "v"
        self.get_contributions_stats
      else
        exit
      end
    end

  end
end

app = Commitchamp::App.new
app.run
# binding.pry
