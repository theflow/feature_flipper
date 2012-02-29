require 'test_helper'

class DslFeaturesTest < Minitest::Test
  def setup
    FeatureFlipper::Config.path_to_file = 'fixtures/features_dsl.rb'
    FeatureFlipper::Config.reload_config
  end

  def test_should_show_enabled_features
    assert show_feature?(:live_feature)
  end

  def test_should_not_show_a_feature_when_on_a_higher_environment
    Rails.stub(:env, 'production') do
      assert !show_feature?(:dev_feature)
    end
  end

  def test_show_feature_should_work_with_booleans
    assert show_feature?(:boolean_feature)
  end

  def test_show_feature_should_work_with_feature_procs
    assert show_feature?(:proc_feature)
  end

  def test_should_be_able_to_get_features
    FeatureFlipper::Config.ensure_config_is_loaded
    all_features = FeatureFlipper::Config.features

    refute_nil all_features
    assert all_features.is_a?(Hash)
    assert_equal :dev, all_features[:dev_feature][:state]
    assert_equal 'dev feature', all_features[:dev_feature][:description]
  end

  def test_should_be_able_to_get_active_features
    Rails.stub(:env, 'production') do
      FeatureFlipper::Config.ensure_config_is_loaded
      active_features = FeatureFlipper::Config.active_features

      assert_equal 3, active_features.size
      assert active_features.include?(:live_feature)
      assert active_features.include?(:boolean_feature)
      assert active_features.include?(:proc_feature)
    end
  end

  def test_show_feature_should_work_with_state_procs
    Rails.stub(:env, 'production') do
      assert show_feature?(:enabled_beta_feature)
      assert !show_feature?(:disabled_beta_feature)
    end
  end

  def test_show_feature_should_with_state_procs_should_still_respect_environment
    assert show_feature?(:disabled_beta_feature)
  end
end
