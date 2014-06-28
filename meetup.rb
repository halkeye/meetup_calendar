require 'rubygems';
require 'rmeetup';

RMeetup::Client.api_key = ENV['MEETUP_KEY']

params = {
  rsvp: "yes,waitlist,maybe",
  member_id: 3947,
  page: 20,
}
results = RMeetup::Client.fetch(:events,params)
results.each do |event|
  puts event.inspect
end
