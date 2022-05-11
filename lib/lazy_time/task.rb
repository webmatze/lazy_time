# frozen_string_literal: true

module LazyTime
  # This is our task model
  class Task
    attr_reader :name, :start, :stop

    def initialize(name:, start: nil, stop: nil)
      @name = name
      @start = start
      @stop = stop
    end

    class << self
      def from_hash(task_hash)
        start = task_hash["start"].nil? ? nil : Time.parse(task_hash["start"])
        stop = task_hash["stop"].nil? ? nil : Time.parse(task_hash["stop"])
        Task.new name: task_hash["name"], start: start, stop: stop
      end
    end

    def start!
      @start = Time.now
    end

    def stop!
      @stop = Time.now
    end

    def to_h
      {
        "name": name,
        "start": start&.to_s,
        "stop": stop&.to_s
      }
    end
  end
end
