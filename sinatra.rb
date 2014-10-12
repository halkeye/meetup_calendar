require 'bundler/setup'
require 'active_support'
require 'icalendar'
require 'omniauth-meetup'
require 'rmeetup'
require 'securerandom'
require 'sinatra'
require 'sinatra/activerecord'

configure do
  enable :sessions
  set :session_secret, ENV['SESSION_KEY'] || 'ac708f29-1274-4e70-aef7-c7ca812bd05b'
  use OmniAuth::Builder do
    provider :meetup, ENV['MEETUP_OAUTH_KEY'], ENV['MEETUP_OAUTH_SECRET']
  end
  case
    when production?
    when development?
      #require 'sinatra/reloader'
      require 'better_errors'
      use BetterErrors::Middleware
      BetterErrors.application_root = __dir__
  end
end

helpers do
  # define a current_user method, so we can be sure if an user is authenticated
  def current_user
    session[:uid]
  end
  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
end

class User < ActiveRecord::Base
end

before do
  # we do not want to redirect to twitter when the path info starts
  # with /auth/
  pass if request.path_info =~ /^\/auth\//
  pass if request.path_info =~ /^\/calendar\//

  # /auth/meetup is captured by omniauth:
  # when the path info matches /auth/meetup, omniauth will redirect to meetup
  redirect to('/auth/meetup') unless current_user
end

get '/auth/meetup/callback' do
  # probably you will need to create a user in the database too...
  session[:uid] = env['omniauth.auth']['uid']
  @user = User.find_or_initialize_by(uid: env['omniauth.auth']['uid'].to_i)
  @user.guid = SecureRandom.uuid.to_s #unless @user.guid
  [:token, :refresh_token, :expires].each do |field|
    @user.send("#{field.to_s}=", request.env['omniauth.auth']['credentials'][field.to_s]);
  end
  @user.expires_at = Time.at(request.env['omniauth.auth']['credentials']['expires_at']);
  @user.save

  # this is the main endpoint to your application
  redirect to('/')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
end

get '/logout' do
  session[:uid] = nil
  redirect '/auth/meetup'
end

get '/' do
  @user = User.find_by(uid: current_user.to_i)
  return redirect '/auth/meetup' unless @user
  "Your calendar link: <a href=\"/calendar/#{@user.guid}.ics\">#{base_url}/calendar/#{@user.guid}.ics</a>"
end

get '/calendar/:guid.ics' do
  @user = User.find_by(guid: params[:guid])
  cal = Icalendar::Calendar.new
  RMeetup::Client.api_key = ENV['MEETUP_KEY']

  params = {
    text_format: "plain",
    rsvp: "yes,waitlist,maybe",
    member_id: current_user,
    page: 20,
  }
  results = RMeetup::Client.fetch(:events,params)
  results.each do |event|
    cal.event do |e|
      event_end = event.time + (event.duration.to_i/1000).seconds
      e.created     = Icalendar::Values::DateTime.new(event.created)
      e.last_modified     = Icalendar::Values::DateTime.new(event.updated)
      e.dtstart     = Icalendar::Values::DateTime.new(event.time)
      e.dtend       = Icalendar::Values::DateTime.new(event_end)
      e.url         = event.event_url
      e.uid         = event.id
      e.location    = "#{event.venue['name']} (#{event.venue['address_1']})" if event.venue
      e.summary     = "#{event.name} [#{event.group['name']}]"
      e.description = event.description #.gsub(/<\/p>/, "\n").gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, '')
      e.ip_class    = "PRIVATE"
    end
  end

  cal.publish
  content_type 'text/calendar'
  cal.to_ical
end
