require 'cucumber/rails'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'webdrivers'

Capybara.register_driver :selenium_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument("--ignore-certificate-errors")

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options,
    service: Selenium::WebDriver::Firefox::Service.new(path: '/home/adiaz/.bin/geckodriver')
  )
end
Capybara.default_driver = :selenium_firefox
Capybara.javascript_driver = :selenium_firefox

require 'database_cleaner/active_record'
Before { DatabaseCleaner.strategy = :transaction; DatabaseCleaner.start }
After { DatabaseCleaner.clean }
