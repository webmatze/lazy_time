# frozen_string_literal: true

module LazyTime
  # Repository to load and save tasks
  class TaskRepository
    attr_reader :config

    def initialize(config)
      @config = config
    end

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

      Task.from_hash current_task
    end

    def save_current_task(task)
      config.set(:current_task, value: task.to_h)
      config.write(force: true)
    end

    private

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
