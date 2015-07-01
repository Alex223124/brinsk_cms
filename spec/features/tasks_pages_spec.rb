require 'spec_helper'

describe 'Tasks' do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:other_contact) { FactoryGirl.build(:contact) }
  let(:contact) { FactoryGirl.build(:contact) }
  let(:task1) { FactoryGirl.build(:task) }
  let(:task2) { FactoryGirl.build(:task) }
  let(:task3) { FactoryGirl.build(:task) }
  before { sign_in user }
  before { create_contact(contact) }

  describe 'index page for tasks' do

    before {
      visit root_path
      click_link "#{contact.full_name}"
      create_task(task1)
      create_task(task2)
      create_task(task3)
      within('nav') do
        click_link 'Tasks'
      end
    }

    it { should have_content('Tasks (3)') }
    it { should have_content(task1.name) }
    it { should have_content(task2.name) }
    it { should have_content(task3.name) }

    scenario 'should search and find the searched for task by name' do
      expect(page).to have_content('Tasks (3)')
      within('.search-field') do
        fill_in 'search', with: "#{task1.name}"
      end
      click_button 'Search'
      expect(page).to have_content('Tasks (1)')
      expect(page).to have_content(task1.name)
      expect(page).to_not have_content(task2.name)
      expect(page).to_not have_content(task3.name)
    end

    scenario 'should search and find the searched for task by description' do
      expect(page).to have_content('Tasks (3)')
      within('.search-field') do
        fill_in 'search', with: "#{task2.description}"
      end
      click_button 'Search'
      expect(page).to have_content('Tasks (1)')
      expect(page).to have_content(task2.name)
      expect(page).to_not have_content(task1.name)
      expect(page).to_not have_content(task3.name)
    end

    scenario 'should search and not find an invalid search parameter' do
      expect(page).to have_content('Tasks (3)')
      within('.search-field') do
        fill_in 'search', with: "#{contact.last_name}"
      end
      click_button 'Search'
      expect(page).to have_content('Tasks (3)')
      expect(page).to have_content(task1.name)
      expect(page).to have_content(task2.name)
      expect(page).to have_content(task3.name)
    end
  end

  describe 'task creation in the contact page' do
    before { visit root_path }

    it { should have_content('Contacts') }
    it { should have_title('Contacts') }

    it 'should have contacts to add tasks to' do
      expect(page).to have_content('1')
      expect(page).to have_content(contact.first_name)
    end

    scenario 'should see a button to add a task' do
      click_link "#{contact.full_name}"
      expect(page).to have_content('Add Task')
    end

    let(:task) { FactoryGirl.build(:task) }

    scenario 'should create a task' do
      click_link "#{contact.full_name}"
      expect(page).to have_content('Add Task')
      create_task(task)
      expect(page).to have_content("Task created!")
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
    end

    scenario 'should not be able to edit a completed task' do
      click_link "#{contact.full_name}"
      expect(page).to have_button('Create Task')
      create_task(task)
      expect(page).to have_content("Task created!")
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
      click_link 'Mark as Complete'
      expect(page).to_not have_link('Edit Task')
    end

    let(:other_task) { FactoryGirl.build(:task) }

    scenario 'should cancel a transaction' do
      click_link "#{contact.full_name}"
      create_task(task)
      expect(page).to have_content("Task created!")
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
      within('div.task_list_wrapper') do
        click_link 'Edit Task'
      end
      expect(page).to have_link('Cancel')
      click_link 'Cancel'
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
      expect(page).to have_content('Add Task')
    end

    scenario 'should edit a task' do
      click_link "#{contact.full_name}"
      create_task(task)
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
      within('div.task_list_wrapper') do
        click_link 'Edit Task'
      end
      edit_task(other_task)
      expect(page).to have_content('Task updated!')
      expect(page).to have_content(other_task.name)
      expect(page).to have_content(other_task.description)
    end

    scenario 'should delete a task' do
      click_link "#{contact.full_name}"
      create_task(task)
      expect(page).to have_content("Task created!")
      expect(page).to have_content(task.name)
      expect(page).to have_content(task.description)
      within('div.task_list_wrapper') do
        click_link 'Delete Task'
      end
      expect(page).to have_content("Task deleted!")
      expect(page).to_not have_content(other_task.name)
      expect(page).to_not have_content(other_task.description)
    end
  end
end
