# Tell the app that we're not running console
$web = true

# Boot the app
require './config/boot.rb'

# Set up middleware stack
app = Rack::Builder.new do

  # Clean up requests
  use UTF8Cleaner::Middleware

  # Load images and fonts
  use Rack::Static,
    :urls => ['/images', '/fonts'],
    :root => App.assets,
    :header_rules => [
      [:all, {'Cache-Control' => 'public, max-age=31536000'}],
      [:fonts, {'Access-Control-Allow-Origin' => '*'}]
    ]

  # Set up caching, only in production and staging
  if %w[production staging].include?(App.env)
    use Rack::Cache,
      :metastore => 'file:./tmp/cache/rack/meta',
      :entitystore => 'file:./tmp/cache/rack/body',
      :verbose => false
  end

  # Enable support for Rest parameters using _method
  use Rack::MethodOverride

  # Set up asset router for js and css
  use Asset::Router

  # Serve static files
  use Susana::Files

  # Set up session cookies
  use Rack::Session::Cookie,
    :path => '/',
    :expire_after => 2592000,
    :secret => '07cd5cbf5cc9aab7c77e92af3e9047ae2e69599610c7db39c074d61f9e82a2c0'

  # Set up flash
  use Rack::Flash, :sweep => true

  # Extract parameters from post body
  use Rack::PostBodyContentTypeParser

  # Add support for JSONP
  use Rack::JSONP

  # Init request store
  use RequestStore::Middleware

  # Run app
  run App.new
end

run app
