require "./lib/api_parse"

class EventsController < ApplicationController

  before_action :get_event, only: [:show]
  def index
    @events = Event.all
  end

  def search
    empty_search
  end

  def info
    # byebug
    @event = @@search_results[params[:id].to_i]
  end

  def results

    @user = current_user
    y = address_to_geo(params[:search])
    data = nyartbeat_parse(y, 0)
    @events_from_search = data["Events"]["Event"]
    @events_from_search.each{|e| new_event(e)} if @@search_results.empty?
    @events = @@search_results
    redirect_to display_path
  end

  def display
    @user = current_user
    @events = @@search_results
  end

  private

  def new_event(event)
    hash = {}
    # byebug

    hash["title"]=event["Name"]
    hash["venue"]=event["Venue"]["Name"]
    hash["address"]=event["Venue"]["Address"]
    hash["description"]=event["Description"]
    hash["price"]=event["Venue"]["Price"]
    hash["date"]=Date.strptime(event["DateStart"]).strftime('%a, %B %d, %Y') + " to " +  Date.strptime(event["DateEnd"]).strftime('%a, %B %d, %Y')
    hash["hours"]=event["Venue"]["OpeningHour"]+" - "+event["Venue"]["ClosingHour"]
    geo = address_to_geo(hash['address'])
    hash["location"] = Location.find_or_create_by(latitude:geo['lat'],longitude:geo['lng'],neighborhood:geo_to_neighborhood(geo))
    hash["category"] = Category.find_by(name:"Art")
    # byebug
    new_event= Event.new(hash)
    @@search_results << new_event
  end

  def get_event
    @event = Event.find(params[:id])
  end
end
