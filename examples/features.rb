#
# This is an example configuration file. It defines two states and
# two features.
#

FeatureFlipper.features do
  in_state :development do
    feature :rating_game, :description => 'play a game to get recommendations'
  end

  in_state :live do
    feature :city_feed, :description => 'stream of content for each city'
  end

  in_state :employees do
    feature :badges, :description => 'new badges'
  end
end

FeatureFlipper::Config.states = {
  :development => ['development', 'test'].include?(Rails.env),
  :employees   => { :required_state => :development, :feature_group => :employees },
  :live        => true
}
