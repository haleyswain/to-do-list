require('sinatra')
require('sinatra/reloader')
require('./lib/to_do')
also_reload('lib/**/*.rb')


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
