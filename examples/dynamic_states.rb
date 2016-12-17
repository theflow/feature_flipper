# Setup
#

# just need this to make it works from within the library
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

# stub production Rails environment
module Rails
  def self.env
    'production'
  end
end

# stub current_user method
class User
  def initialize(employee)
    @employee = employee
  end

  def employee?
    @employee == true
  end
end

def current_user
  @current_user
end

# Configuration
#

require 'feature_flipper'

# set the path to your app specific config file
FeatureFlipper::Config.path_to_file = File.expand_path('features.rb', File.dirname(__FILE__))


# Usage
#

puts "=== first example:"

# mock current user to not be a employee
@current_user = User.new(false)

# current user it not an employee and we are on prod, so no new badges
if show_feature?(:badges)
  puts "shiny new badges not live on prod yet"
else
  puts "no new badges"
end

puts "\n=== second example:"

# mock current user to be a employee
@current_user = User.new(true)

if show_feature?(:badges)
  puts "shiny new badges for this employee"
else
  puts "no new badges"
end
