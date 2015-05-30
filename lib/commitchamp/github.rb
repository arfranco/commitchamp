require 'httparty'

module Commitchamp
  class Github
    include HTTParty
    base_uri "https://api.github.com"

    def get_user(user_name)
      self.class.get("/users/#{user_name}")
    end

    def get_repo(repo)
      self.class.get("/users/#{user_name}/followers")
    end


  end
end
