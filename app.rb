require('sinatra')
require('sinatra/reloader')
require('./lib/to_do')
require('./lib/list')
also_reload('lib/**/*.rb')
require('pg')

DB = PG.connect({:dbname => 'to_do'})

get('/') do
  @lists = List.all()
  erb(:index)
end

post('/') do
  new_list = params.fetch('new_list')
  @new_list = List.new({:name => new_list, :id => nil})
  @new_list.save()
  @lists = List.all()
  erb(:index)
end

get('/list/:id') do
  @current_list_id = params.fetch("id").to_i()
  @name = List.name_by_id(@current_list_id)
  @tasks = DB.exec("SELECT * FROM tasks WHERE list_id = #{@current_list_id};")
  erb(:list)
end

post('/list/:id') do
  @current_list_id = params.fetch("id").to_i()
  @name = List.name_by_id(@current_list_id)
  task = params.fetch('add_task')
  new_task = Task.new({:description => task, :list_id => @current_list_id})
  new_task.save()
  @tasks = DB.exec("SELECT * FROM tasks WHERE list_id = #{@current_list_id};")
  erb(:list)
end
