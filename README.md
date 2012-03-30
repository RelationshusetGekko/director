# B56Scheduler

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'b56_scheduler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install b56_scheduler

## Usage

The first thing we need to do to start using the scheduler is to get our hands
on a schedule object:

    schedule = B56Scheduler::Schedule.new(event_repository)

Notice that you need to pass an `event_repository` object to the Schedule. See
the section on Event Repository for details.

Then we need to add a trigger to the schedule:

    schedule.add_trigger(:invitation,
                         :event => :participant_join,
                         :action => :send_invite)

Then we need to tell the schedule which handlers are to be used for handling
which actions. Say we have an InviteSender module like this:

    module InviteSender
      extend self
      def call(participant_id)
        # Do something
      end
    end

Now let's tell the scheduler to use the InviteSender to handle send\_invite
actions:

    schedule.add_handler(:send_invite, InviteSender)

And finally we'll notify the scheduler that a participant is to join the
schedule:

    participant_id = 42
    schedule.notify(participant_id, :participant_join)

Now we're ready to execute the schedule:

    schedule.execute

Which in turn will call:

    InviteSender.call(42)

## Delayed triggers

Sometimes you want to schedule a trigger sometime after an event. This can be
done with:

    schedule.add_trigger(:reminder,
                         :event => 'participant_join'
                         :offset => 3600,
                         :action => :send_reminder)

Where the offset is some number of seconds that must pass after the event
before the trigger is run.

## Event Repository

To use the scheduler you need to provide an event repository object. This
object needs to respond to `notify(participant_id, event_name)` and
`search(criteria)`.

`participant_id` will most likely be an integer and `event_name` must be a
string.

For the search the criteria is an array of hashes that look like:

    { :name => 'event_name', :includes => true }

This means that the event `event_name` must have happened to the participant.
The inverse is also possible:

    { :name => 'event_name', :excludes => true }

Meaning that the event `event_name` must not have happened to the participant.
The search method must return an array of participant ids that match the
criteria.

Optionally the hash might include a `before` key if the event must have
happened before a given time.

    { :name => 'event_name', :includes => true, :before => [time object] }

## Config files

The schedule can be instantiated from a YAML file. The most simple
example is a schedule that basically does nothing but run an action when it's
told to:

    triggers:
      invitation:
        event: participant_join
        action: send_invite

This schedule can be loaded with:

    schedule = B56Scheduler::Config.load_schedule(YAML::load_file('path/to/file'))

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
