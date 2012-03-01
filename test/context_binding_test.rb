require 'test_helper'

class ContextBindingTest < Minitest::Test
  def setup
    FeatureFlipper::Config.path_to_file = 'fixtures/features_context.rb'
    FeatureFlipper::Config.reload_config

    @context = Context.new(:feature1, :feature3)
  end

  def test_should_have_feature_1
    assert @context.show_feature?(:feature1)
  end

  def test_should_not_have_feature_2
    assert !@context.show_feature?(:feature2)
  end

  def test_should_return_active_features_with_context
    FeatureFlipper::Config.ensure_config_is_loaded
    active_features = FeatureFlipper::Config.active_features(@context)

    assert_includes active_features, :feature1
    assert_includes active_features, :feature3

    refute_includes active_features, :feature2
  end
end
