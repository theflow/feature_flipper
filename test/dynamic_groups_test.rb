require 'test_helper'

class DynamicGroupsTest < Minitest::Test
  def setup
    FeatureFlipper::Config.path_to_file = 'fixtures/features.rb'
    FeatureFlipper::Config.reload_config
    FeatureFlipper.reset_active_feature_groups
  end

  def test_should_show_a_beta_feature_to_the_feature_group
    Rails.stub(:env, 'production') do
      FeatureFlipper.active_feature_groups << :beta_users

      assert show_feature?(:beta_feature_old)
      assert show_feature?(:beta_feature_new)
    end
  end

  def test_should_not_show_a_beta_feature_if_not_in_the_group
    Rails.stub(:env, 'production') do
      FeatureFlipper.active_feature_groups << :different_feature_group

      assert !show_feature?(:beta_feature_old)
      assert !show_feature?(:beta_feature_new)
    end
  end

  def test_should_always_show_a_beta_feature_on_dev
    Rails.stub(:env, 'development') do
      FeatureFlipper.active_feature_groups << nil

      assert show_feature?(:beta_feature_old)
      assert show_feature?(:beta_feature_new)
    end
  end

  def test_can_be_in_two_feature_groups_at_the_same_time
    Rails.stub(:env, 'production') do
      FeatureFlipper.active_feature_groups << :beta_users
      FeatureFlipper.active_feature_groups << :employees

      assert show_feature?(:beta_feature_new)
      assert show_feature?(:employee_feature)
    end
  end
end
