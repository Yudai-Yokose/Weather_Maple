require 'capybara/rspec'

Capybara.register_driver :remote_chrome do |app|
  url = ENV['SELENIUM_DRIVER_URL']
  capabilities = ::Selenium::WebDriver::Chrome::Options.new(
    'goog:chromeOptions' => {
      'args' => ['no-sandbox', 'headless', 'disable-gpu', 'window-size=475,1000', '--force-device-scale-factor=0.5']
    }
  )

  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, capabilities: capabilities)
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:each, type: :system, js: true) do
    if ENV['SELENIUM_DRIVER_URL']
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
      Capybara.server_port = 3001
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
      driven_by :remote_chrome
    else
      driven_by :selenium_chrome_headless
    end
  end
end
