Splity::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.to_prepare do
    javascripts_provided = {}
    javascript_base_path = Rails.root.join('app', 'assets', 'javascripts')
    puts 'Loading javascripts from filesystem'
    Dir.foreach(javascript_base_path) do |file|
        next if file == '.' or file == '..'
        current_file = File.join(javascript_base_path, file)
        if File.directory?(current_file)
            Dir.chdir(current_file) do |directory|
                Dir.foreach(directory) do |inner_file|
                  next if inner_file == '.' or inner_file == '..' or inner_file.starts_with? '.'
                  javascripts_provided["#{file}"] = [] if javascripts_provided["#{file}"].nil?
                  javascripts_provided["#{file}"] << "#{inner_file.gsub('.js', '').gsub('.erb', '').gsub('.coffee', '').gsub('.litcoffee','')}"
                end
            end
        end
    end
    GlobalConstants::JavascriptsProvided = javascripts_provided
    puts GlobalConstants::JavascriptsProvided.to_yaml
  end
end
