# frozen_string_literal: true

require "pastel"
require "time"

require_relative "../command"
require_relative "../task"
require_relative "../task_repository"

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
        @task_repository = TaskRepository.new config
      end

      def execute(input: $stdin, output: $stdout)
        task_names = @task_repository.load_tasks
        running_task = @task_repository.load_running_task
        show_running_task(running_task, output)
        selected_task_name = select_task(task_names, input, output)
        new_task = new_task(selected_task_name)
        stop_running_task(running_task, output)
        @task_repository.save_current_task(new_task)
        print_task(new_task, output)
      end

      private

      def show_running_task(running_task, output)
        output.puts "Current Task"
        if running_task
          print_task(running_task, output)
        else
          output.puts add_color("  No Task running!", :red)
          output.puts
        end
      end

      def stop_running_task(running_task, output)
        return unless running_task

        running_task.stop!
        output.puts "Current Tasks stopped!"
        print_task(running_task, output)
      end

      def select_task(tasks, input, output)
        merged_tasks = tasks.flat_map(&:last)
        prompt(input, output).select("Choose a task", filter: true, echo: false) do |menu|
          menu.choice "Enter a task name...", -> { prompt(input, output).ask("Enter a new name:", required: true) }
          merged_tasks.each do |task|
            menu.choice task
          end
        end
      rescue TTY::Reader::InputInterrupt => _e
        output.puts
        begin
          prompt(input, output).ask("Enter a task name: ", required: true)
        rescue TTY::Reader::InputInterrupt => _e
          output.puts
          exit 1
        end
      end

      def new_task(name)
        task = Task.new(name: name)
        task.start!
        task
      end

      def print_task(task, output)
        output.puts
        output.puts "Tracking"
        output.puts "  Task    #{add_color(task.name, :green)}"
        output.puts "  Started #{add_color(task.start, :yellow)}"
        output.puts "  Stopped #{add_color(task.stop, :yellow)}" unless task.stop.nil?
        output.puts
      end
    end
  end
end
