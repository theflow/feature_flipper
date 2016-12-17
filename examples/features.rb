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

FeatureFlipper.states do
  state :development, ['development', 'test'].include?(Rails.env)
  state :employees, Proc.new { |feature_name| respond_to?(:current_user, true) && current_user.employee? }
  state :live, true
end
