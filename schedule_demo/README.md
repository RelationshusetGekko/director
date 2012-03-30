Scheduler Demo App
==================

The schedule itself is setup in db/schedule.yaml.
The b56\_scheduler is configured in config/initializers/scheduler.rb.

To see it in action run:

    rails runner "SCHEDULE.notify(1, 'participant_join')"
    rake schedule:run
