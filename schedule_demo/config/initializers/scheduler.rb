SCHEDULE = Director::Schedule.new(EventRepository)
Director::ConfigLoader.load_schedule(SCHEDULE, 'db/schedule.yaml')
SCHEDULE.add_handler(:send_invite, InvitationSender.new)
