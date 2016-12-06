class List
  attr_reader(:name, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    returned_lists = DB.exec("SELECT * FROM lists;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      lists.push(List.new({:name => name, :id => id}))
    end
    lists
  end

  def save
    result = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_list)
    name().==(another_list.name()).&(self.id().==(another_list.id()))
  end

  define_method(:tasks) do
   list_tasks = []
   tasks = DB.exec("SELECT * FROM tasks WHERE list_id = #{self.id()};")
   tasks.each() do |task|
     description = task.fetch("description")
     list_id = task.fetch("list_id").to_i()
     list_tasks.push(Task.new({:description => description, :list_id => list_id}))
   end
   list_tasks
 end

 define_singleton_method(:name_by_id) do |check_id|
   lists = DB.exec("SELECT * FROM lists WHERE id = #{check_id};")
   lists.first().fetch('name')
 end

end
