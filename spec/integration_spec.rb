
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('adding a new list', {:type => :feature}) do
  it('allows a user to click a list to see the tasks and details for it') do
    visit('/')
    fill_in('new_list', :with => 'epicodus work')
    click_button('Add list')
    expect(page).to have_content('epicodus work')
  end
end

describe('adding tasks to a list', {:type => :feature}) do
  it('allows a user to add a task to a list') do
    test_list = List.new({:name => 'School stuff', :id => nil})
    test_list.save()
    visit("/list/#{test_list.id()}")
    fill_in("add_task", {:with => "Learn SQL"})
    click_button("Add task")
    expect(page).to have_content("Learn SQL")
  end
end
