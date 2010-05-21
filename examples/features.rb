#
# This is an example configuration file. It defines two states and
# two features.
#

FeatureFlipper.features do
  in_status :dev do
    feature :rating_game, :description => 'play a game to get recommendations'
  end

  in_status :live do
    feature :city_feed, :description => 'stream of content for each city'
  end

  in_status :employees do
    feature :badges, :description => 'new badges'
  end
end

FeatureFlipper::Config.states = {
  :dev       => ['development', 'test'].include?(Rails.env),
  :employees => { :required_state => :dev, :feature_group => :employees },
  :live      => true
}
