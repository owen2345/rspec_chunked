# frozen_string_literal: true

require 'rspec_chunked'
require 'rails'

module RspecChunked
  class Railtie < Rails::Railtie
    railtie_name :my_gem

    rake_tasks do
      load 'tasks/rspec_chunked_tasks.rake'
    end
  end
end
