# frozen_string_literal: true

require "pastel"
require "time"

require_relative "../command"

module LazyTime
  module Commands
    # Starts a new timer for a given task
    # If no task is provided a default timer is started.
    # If a timer is already running, it is stopped first.
    class Start < LazyTime::Command
      def initialize(options)
        super
        @options = options
        @pastel = Pastel.new
        config.set("settings", "color", value: !@options["no-color"])
      end

      def execute(input: $stdin, output: $stdout)
        tasks = load_tasks
        running_task = load_running_task
        show_running_task(running_task, output)
        selected_task = select_task(tasks, input, output)
        task = new_task(selected_task)
        stop_running_task(running_task, output)
        save_current_task(task)
        print_task(task, output)
      end

      private

      def load_tasks
        config_saved = config.exist?
        config.read if config_saved
        tasks = config.fetch("tasks")
        if tasks.nil? || tasks.empty?
          task_init = setup_tasks
          config.set(:tasks, value: task_init)
          config.write(create: !config_saved)
        end
        tasks
      end

      def load_running_task
        current_task = config.fetch("current_task")
        return if current_task.nil?

        current_task
      end

      def show_running_task(running_task, output)
        output.puts "Current Task"
        print_task(running_task, output)
      end

      def stop_running_task(running_task, output)
        running_task["stop"] = Time.now.to_s
        output.puts "Current Tasks stopped!"
        print_task(running_task, output)
      end

      def select_task(tasks, input, output)
        merged_tasks = tasks.flat_map(&:last)
        select_task_prompt = prompt(input, output)
        select_task_prompt.select("Choose a task", merged_tasks, filter: true, echo: false)
      end

      def new_task(name)
        {
          "name" => name,
          "start" => Time.now.to_s,
          "stop" => nil
        }
      end

      def save_current_task(task)
        config.set(:current_task, value: task)
        config.write(force: true)
      end

      def print_task(task, output)
        output.puts
        output.puts "Tracking"
        output.puts "  Task    #{add_color(task["name"], :green)}"
        output.puts "  Started #{add_color(task["start"], :yellow)}"
        output.puts "  Stopped #{add_color(task["stop"], :yellow)}" unless task["stop"].nil?
        output.puts
      end

      def setup_tasks
        {
          default: %w[
            coding
            documentation
            meeting
            daily
            retro
          ],
          added: nil,
          external: nil
        }
      end
    end
  end
end
