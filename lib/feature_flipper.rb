require 'feature_flipper/show'
require 'feature_flipper/config'

# we need the show_feature? method everywhere
Object.send(:include, FeatureFlipper::Show)
