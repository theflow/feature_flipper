FeatureFlipper::Config.features = {
  :live_feature     => { :state => :live },
  :disabled_feature => { :state => :disabled },
  :dev_feature      => { :state => :dev, :description => 'dev feature' },
}


FeatureFlipper::Config.states = {
  :disabled    => false,
  :dev         => ['development', 'test'].include?(Rails.env),
  :live        => true,
}
