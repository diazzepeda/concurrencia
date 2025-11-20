require 'cucumber/rails'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'webdrivers'

Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = 5

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--window-size=1400,1400')
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless

require 'database_cleaner/active_record'
Before { DatabaseCleaner.strategy = :transaction; DatabaseCleaner.start }
After { DatabaseCleaner.clean }
