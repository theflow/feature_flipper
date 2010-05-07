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
end

FeatureFlipper::Config.states = {
  :dev      => ['development', 'test'].include?(Rails.env),
  :live     => true
}
