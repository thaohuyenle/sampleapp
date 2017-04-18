ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

class ActiveSupport::TestCase
  fixtures :all
end

class ActionDispatch::IntegrationTest
  def log_in_as(user, password: "password", remember_me: "1")
    post login_path, params: { session: { email: user.email,
     password: password, remember_me: remember_me } }
  end
end
