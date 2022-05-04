# frozen_string_literal: true

require 'pastel'

require_relative "../command"

module LazyTime
  module Commands
    class Start < LazyTime::Command
      def initialize(options)
        @options = options
        @pastel = Pastel.new
      end

      def execute(output: $stdout)
        output.print add_color("TODO: Implement Start Command...", :green)
        output.puts
      end
    end
  end
end
