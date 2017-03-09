require('sinatra/activerecord')
require('sinatra')
require('sinatra/reloader')
require('./lib/event')
require('./lib/attendee')
require('./lib/categorie')
also_reload('lib/**/*.rb')
require("pg")





get("/") do
  @category = Categorie.all()
  erb(:index)
end


get("/admin") do
  @categories = Categorie.all()
  @events = Event.all()
  erb(:admin)
end

get("/events") do
  @events = Event.all()
  erb(:events)
end

post('/categories')do
  name = params.fetch("categorie_name")
  category = Categorie.new({:categorie_name => name, :id => nil})
  category.save()
  erb(:success)
end

get('/categories/:id')do

  @category = Categorie.find(params.fetch("id").to_i())
  erb(:category)
end

post('/event')do
  event_name = params.fetch("event_name")
  organization = params.fetch("organization")
  time = params.fetch("time")
  location = params.fetch("location")
  fee = params.fetch("fee").to_i()
  categorie_id = params.fetch("categorie_id").to_i()
  @categorie = Categorie.find(categorie_id)
  event = Event.new(:event_name => event_name, :organization => organization, :time => time, :location => location, :fee => fee, :categorie_id =>categorie_id )
  event.save()
  erb(:success)
end

get('/event/:id')do

@event = Event.find(params.fetch("id").to_i())
 erb(:attendee_form)
end

post('/attendees')do
 name = params.fetch("name")
 number = params.fetch("number")
 event_id = params.fetch("event_id").to_i()
 attendee = Attendee.new({:name => name, :number => number, :event_id => event_id, :id => nil})
 attendee.save()
 erb(:success)
end


get('/admin/event_edit/:id')do
@event = Event.find(params.fetch("id").to_i())
 erb(:event_form)
end


 patch("/event/edit/:id") do
   organization = params.fetch("organization")
   event_name = params.fetch("event_name")
   location = params.fetch("location")
   fee = params.fetch("fee").to_i()
   time = params.fetch("time")
   @event = Event.find(params.fetch("id").to_i())
   @event.update({:organization => organization,:event_name => event_name, :location => location, :fee => fee, :time => time})
  #  if @event = Event.update({:organization => organization,:event_name => event_name, :location => location, :fee => fee, :time => time})
  #   erb(:event)
  # else
  #   erb(:index)
  # end
  erb(:success)
end

delete("/event/edit/:id") do
    @event = Event.find(params.fetch("id").to_i())
    @event.delete()
    @categories = Categorie.all()
    @events = Event.all()
    erb(:admin)
  end

  # get("/event/editted/:id")do
  #  @event = Event.find(params.fetch("id").to_i())
  #  erb(:event)
  # end
