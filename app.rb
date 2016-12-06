require('sinatra')
require('sinatra/reloader')
require('./lib/to_do')
also_reload('lib/**/*.rb')
require('pg')

DB = PG.connect({:dbname => 'to_do'})

get('/') do
  @tasks = Task.all()
  erb(:index)
end

post("/tasks") do
  description = params.fetch("description")
  task = Task.new(description)
  task.save()
  erb(:success)
end
