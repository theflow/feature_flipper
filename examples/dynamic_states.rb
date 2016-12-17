# Setup
#

# just need this to make it work from within the library
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

# no active feature_group set, so the required_state of badges is looked at
if show_feature?(:badges)
  puts "shiny new badges not live on prod yet"
else
  puts "no new badges"
end

puts "\n=== second example:"

# now we set the active feature_group. Usually depending on the logged in user

FeatureFlipper.reset_active_feature_groups
FeatureFlipper.active_feature_groups << :employees

if show_feature?(:badges)
  puts "shiny new badges for this user"
else
  puts "no new badges"
end
