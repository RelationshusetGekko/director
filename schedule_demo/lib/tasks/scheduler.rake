namespace :scheduler do
  desc 'Run scheduler'
  task :run => :environment do
    SCHEDULE.execute
  end
end
