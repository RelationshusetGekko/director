SCHEDULE = B56Scheduler::Schedule.new(EventRepository)
B56Scheduler::ConfigLoader.load_schedule(SCHEDULE, 'db/schedule.yaml')
SCHEDULE.add_handler(:send_invite, InvitationSender.new)
