ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'database_cleaner'

require_relative '../../lib/controllers/main_controller'

# configure rspec to clean the database after each test using database_cleaner
RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.app = MainController

describe 'searching for book', :type => :feature do

  it 'shows a list of search results' do
    visit '/search_for_book'
    fill_in 'Search books', :with => 'the life of pi'
    click_button 'Search'
    page.find('h1').should have_text('Search Results for: the life of pi')
    page.find('p:nth-of-type(2)').should have_text('ISBN:')
    find(:css, 'button:nth-of-type(1)').should have_text('Add to favourites')
    page.should have_xpath('//img')
    click_link 'Next'
    page.find('h1').should have_text('Search Results for: the life of pi')
    page.find('p:nth-of-type(2)').should have_text('ISBN:')
    find(:css, 'button:nth-of-type(1)').should have_text('Add to favourites')
    page.should have_xpath('//img')
  end

end  

describe 'signing up a user', :type => :feature do

  it 'creates a new user when valid details are provided' do
    expect(User.count).to be == 0
    visit '/signup'
    fill_in 'First Name', :with => 'Tom'
    fill_in 'Last Name', :with => 'Atkinson'
    fill_in 'Email', :with => 'tomatkinson@gmail.com'
    fill_in 'Password', :with => 'password'
    fill_in 'Password Confirmation', :with => 'password'
    click_button 'Sign Up'
    expect(User.count).to be == 1
    page.should have_content('Bookster Home Page')
  end



end
# describe 'display_results', :type => :feature do

#   it 'should render a page with any results' do
#     visit "/display_results?search=ruby"
#     page.should have_content("ISBN")
#   end

#   it 'should render a page with a defined number of results' do
#     visit "/display_results?search=ruby&count=7"
#     page.should have_content("ISBN", :count => 7)
#   end

#   it 'should render a page with a defined number of results' do
#     visit "/display_results?search=ruby"
#     page.should have_content("ISBN", :count => 10)
#   end

# end