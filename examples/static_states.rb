# Setup
#

# just need this to make it works from within the library
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

# fake production Rails environment
module Rails
  def self.env
    'production'
  end
end


# Configuration
#

require 'feature_flipper'

# set the path to your app specific config file
FeatureFlipper::Config.path_to_file = File.expand_path('features.rb', File.dirname(__FILE__))


# Usage
#

puts "=== first example:"

# rating_game is still in development, so shouldn't be shown on production
if show_feature?(:rating_game)
  puts "Rating Game"
else
  puts "old stuff"
end

puts "\n=== second example:"

# city_feed is enabled everywhere
if show_feature?(:city_feed)
  puts "City Feed"
else
  puts "old stuff"
end
