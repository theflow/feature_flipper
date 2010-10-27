require 'test_helper'

context 'hash based FeatureFlipper' do
  setup do
    FeatureFlipper::Config.path_to_file = 'features.rb'
    FeatureFlipper::Config.reload_config
  end

  test 'should show enabled features' do
    assert show_feature?(:live_feature)
  end

  test 'should not show disabled features' do
    assert !show_feature?(:disabled_feature)
  end

  test 'should not show a feature when on a higher environment' do
    Rails.stubs(:env).returns('production')
    assert !show_feature?(:dev_feature)
  end

  test 'show feature should work with booleans' do
    assert show_feature?(:boolean_feature)
  end

  test 'show feature should work with procs' do
    assert show_feature?(:proc_feature)
  end

  test 'should be able to get features' do
    FeatureFlipper::Config.ensure_config_is_loaded
    all_features = FeatureFlipper::Config.features

    assert_not_nil all_features
    assert all_features.is_a?(Hash)
    assert_equal :dev, all_features[:dev_feature][:state]
    assert_equal 'dev feature', all_features[:dev_feature][:description]
  end
end

context 'DSL based FeatureFlipper' do
  setup do
    FeatureFlipper::Config.path_to_file = 'features_dsl.rb'
    FeatureFlipper::Config.reload_config
  end

  test 'should show enabled features' do
    assert show_feature?(:live_feature)
  end

  test 'should not show a feature when on a higher environment' do
    Rails.stubs(:env).returns('production')
    assert !show_feature?(:dev_feature)
  end

  test 'show feature should work with booleans' do
    assert show_feature?(:boolean_feature)
  end

  test 'show feature should work with procs' do
    assert show_feature?(:proc_feature)
  end

  test 'should be able to get features' do
    FeatureFlipper::Config.ensure_config_is_loaded
    all_features = FeatureFlipper::Config.features

    assert_not_nil all_features
    assert all_features.is_a?(Hash)
    assert_equal :dev, all_features[:dev_feature][:state]
    assert_equal 'dev feature', all_features[:dev_feature][:description]
  end
end

context 'dynamic feature groups' do
  setup do
    FeatureFlipper::Config.path_to_file = 'features.rb'
    FeatureFlipper::Config.reload_config
    FeatureFlipper.reset_active_feature_groups
  end

  test 'should show a beta feature to the feature group' do
    Rails.stubs(:env).returns('production')
    FeatureFlipper.active_feature_groups << :beta_users

    assert show_feature?(:beta_feature_old)
    assert show_feature?(:beta_feature_new)
  end

  test 'should not show a beta feature if not in the group' do
    Rails.stubs(:env).returns('production')
    FeatureFlipper.active_feature_groups << :different_feature_group

    assert !show_feature?(:beta_feature_old)
    assert !show_feature?(:beta_feature_new)
  end

  test 'should always show a beta feature on dev' do
    Rails.stubs(:env).returns('development')
    FeatureFlipper.active_feature_groups << nil

    assert show_feature?(:beta_feature_old)
    assert show_feature?(:beta_feature_new)
  end

  test 'can be in two feature groups at the same time' do
    Rails.stubs(:env).returns('production')
    FeatureFlipper.active_feature_groups << :beta_users
    FeatureFlipper.active_feature_groups << :employees

    assert show_feature?(:beta_feature_new)
    assert show_feature?(:employee_feature)
  end
end

context 'feature dependencies' do
  setup do
    FeatureFlipper::Config.path_to_file = 'features.rb'
    FeatureFlipper::Config.reload_config
    FeatureFlipper.reset_active_feature_groups
  end
  
  test 'should correctly check feature dependencies' do
    assert show_feature?(:requires_live)
    assert show_feature?(:requires_many)
    
    assert !show_feature?(:requires_disabled)
  end
end