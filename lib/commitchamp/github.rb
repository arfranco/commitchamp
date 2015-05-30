require 'httparty'

module Commitchamp

  ACCESS_TOKEN = ENV['29b922846cb021186457380079925cb696ed5714']

  class Github
    include HTTParty
    base_uri "https://api.github.com"

    def initialize
      @headers = { "Authorization" => "token #{ACCESS_TOKEN}",
                   "User-Agent" => "HTTParty" }
    end

    def get_user(username)
      self.class.get("/users/#{username}", headers: @headers)
    end

    def get_repo(org_name)
      self.class.get("/orgs/#{org_name}/repos", headers: @headers)
    end

    def get_contributions(owner, repo, page=1)
      params = {
        page: page
      }
      options = {
        headers: @headers,
        query: params
      }
      self.class.get("/repos/#{owner}/#{repo}/stats/contributors", options)
    end

  end
end
