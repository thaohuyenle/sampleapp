require_relative "boot"
require "rails/all"
require File.expand_path("../boot", __FILE__)

Bundler.require(*Rails.groups)

module Sampleapp
  class Application < Rails::Application
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
