# frozen_string_literal: true

require 'rails'
module RspecChunked
  class Railtie < ::Rails::Railtie
    rake_tasks do
      load 'tasks/rspec_chunked_tasks.rake'
    end
  end
end
