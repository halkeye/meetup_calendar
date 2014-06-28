require 'active_support'
require 'icalendar'
# https://github.com/fun-ruby/ruby-meetup2
# https://github.com/tapster/omniauth-meetup
require 'rmeetup';

## 
# /calendar/guid => code below
# / Login with meetup button
# Table:
#   guid
#   request.env['omniauth.auth']['uid']
#   request.env['omniauth.auth']['credentials']
#     token
#     refresh_token
#     expires_at
#     expires
#
# Create a calendar with an event (standard method)
cal = Icalendar::Calendar.new
RMeetup::Client.api_key = ENV['MEETUP_KEY']

params = {
  rsvp: "yes,waitlist,maybe",
  member_id: 3947,
  page: 20,
}
results = RMeetup::Client.fetch(:events,params)
results.each do |event|
  # "venue"=>{"id"=>18259662, "lon"=>-123.109161, "repinned"=>false, "name"=>"Mozilla YVR Offices", "state"=>"BC", "address_1"=>"163 West Hastings Street, Vancouver, BC, Canada", "lat"=>49.282612, "city"=>"Vancouver", "country"=>"ca"},
  # "id"=>"qlqkthyskbsb",
  # "utc_offset"=>-25200000, 
  # "duration"=>10800000,
  # "time"=>1405386000000, 
  # "updated"=>1392409598000, 
  # "created"=>1391545761000,
  # "event_url"=>"http://www.meetup.com/PolyglotVancouver/events/182368212/",
  # "description"=>"html",
  # "name"=>"Hack/Study/Mentor Night", 
  # "headcount"=>0, 
  # "group"=>{"id"=>3946322, "group_lat"=>49.2599983215332, "name"=>"PolyglotVancouver", "group_lon"=>-123.12000274658203, "join_mode"=>"open", "urlname"=>"PolyglotVancouver", "who"=>"Polyglots"}}
  #
  cal.event do |e|
    event_end = event.time + (event.duration.to_i/1000).seconds
    e.dtstart     = Icalendar::Values::DateTime.new(event.time)
    e.dtend       = Icalendar::Values::DateTime.new(event_end)
    e.summary     = event.name
    e.description = event.description
    e.ip_class    = "PRIVATE"
  end
end

cal.publish
puts cal.to_ical
