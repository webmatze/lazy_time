# frozen_string_literal: true

require "thor"
require "pastel"

module LazyTime
  class CLI < Thor
    desc "version", "lazy_time version"
    def version
      require_relative "version"
      puts "v#{LazyTime::VERSION}"
    end
    map %w[--version -v] => :version
  end
end
