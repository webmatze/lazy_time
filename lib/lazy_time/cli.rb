# frozen_string_literal: true

require "thor"
require "pastel"
require "tty-font"

module LazyTime
  class CLI < Thor
    def help(*args)
      font = TTY::Font.new(:standard)
      pastel = Pastel.new(enabled: !options["no-color"])
      puts pastel.yellow(font.write("LazyTime"))
      super
    end

    class_option :"no-color", type: :boolean, default: false,
                              desc: "Disable colorization in output"

    desc "start", "start a new time tracking"
    long_desc <<-DESC
      Start a new time tracking.

      Example:

      > $ lazy_time start
    DESC
    method_option :help, aliases: "-h", type: :boolean,
                         desc: "Display usage information"
    def start(*)
      if options[:help]
        invoke :help, ["start"]
      else
        require_relative "commands/start"
        LazyTime::Commands::Start.new(options).execute
      end
    end

    desc "version", "lazy_time version"
    def version
      require_relative "version"
      puts "v#{LazyTime::VERSION}"
    end
    map %w[--version -v] => :version
  end
end
