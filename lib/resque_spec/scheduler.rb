require 'resque_spec'

module ResqueSpec
  def schedule_for(klass)
    name = "#{queue_name(klass)}_scheduled"
    queues[name]
  end

  module SchedulerExt
    def enqueue_at(time, klass, *args)
      if ResqueSpec.inline
        klass.send(:perform, *args)
      else
        ResqueSpec.schedule_for(klass) << {:klass => klass.to_s, :time  => time, :args => args}
      end
    end
  end
end

Resque.extend(ResqueSpec::SchedulerExt)
