class Task
  attr_reader(:description, :list_id)

  def ==(another_task)
    self.description().==(another_task.description()).&(self.list_id.==(another_task.list_id()))
  end

  define_method(:initialize) do |attributes|
    @description = attributes.fetch(:description)
    @list_id = attributes.fetch(:list_id)
  end

  define_singleton_method(:all) do
    returned_tasks = DB.exec('SELECT * FROM tasks;')
    tasks = []
    returned_tasks.each() do |task|
      description = task.fetch('description')
      list_id = task.fetch('list_id').to_i()
      tasks.push(Task.new({:description => description, :list_id => list_id}))
    end
    tasks
  end

  define_method(:save) do
      DB.exec("INSERT INTO tasks (description, list_id) VALUES ('#{@description}', #{@list_id});")
  end

  define_singleton_method(:clear) do
    @@all_tasks = []
  end

  define_singleton_method(:delete_last) do
    @@all_tasks.delete_at(-1)
  end
end
