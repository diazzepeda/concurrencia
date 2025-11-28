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
    service: Selenium::WebDriver::Firefox::Service.new(path: '/opt/homebrew/bin/geckodriver')
    #service: Selenium::WebDriver::Firefox::Service.new(path: '/home/adiaz/.bin/geckodriver')
  )
end

Capybara.register_driver :selenium_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.binary = '/usr/bin/chromium-browser'
  options.add_argument('--window-size=1920,1080')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options:
  )
end
Capybara.default_driver = :selenium_firefox
Capybara.javascript_driver = :selenium_firefox

require 'database_cleaner/active_record'
Before { DatabaseCleaner.strategy = :transaction; DatabaseCleaner.start }
After { DatabaseCleaner.clean }
