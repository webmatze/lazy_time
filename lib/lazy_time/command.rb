# frozen_string_literal: true

module LazyTime
  class Command
    trap("SIGINT") { exit }

    # Main configuration
    # @api public
    def config
      @config ||= begin
        config = TTY::Config.new
        config.filename = "lazy_time"
        config.extname = ".toml"
        config.append_path Dir.pwd
        config.append_path Dir.home
        config
      end
    end

    def add_color(str, color)
      @options["no-color"] || color == :none ? str : @pastel.decorate(str, color)
    end

    # Execute this command
    #
    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # The cursor movement
    #
    # @see http://www.rubydoc.info/gems/tty-cursor
    #
    # @api public
    def cursor
      require "tty-cursor"
      TTY::Cursor
    end

    # Open a file or text in the user's preferred editor
    #
    # @see http://www.rubydoc.info/gems/tty-editor
    #
    # @api public
    def editor
      require "tty-editor"
      TTY::Editor
    end

    # Get terminal screen properties
    #
    # @see http://www.rubydoc.info/gems/tty-screen
    #
    # @api public
    def screen
      require "tty-screen"
      TTY::Screen
    end
  end
end
