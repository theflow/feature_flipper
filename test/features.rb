FeatureFlipper::Config.features = {
  :live_feature     => { :status => :live },
  :disabled_feature => { :status => :disabled },
  :dev_feature      => { :status => :dev, :description => 'dev feature' },
  :boolean_feature  => { :status => true },
  :proc_feature     => { :status => Proc.new { Date.today > Date.today - 84000 } },
  :beta_feature_old => { :status => :beta_old },
  :beta_feature_new => { :status => :beta_new }
}


FeatureFlipper::Config.states = {
  :disabled => false,
  :dev      => ['development', 'test'].include?(Rails.env),
  :beta_old => { :beta_users => :dev },
  :beta_new => { :required_state => :dev, :feature_group => :beta_users },
  :live     => true
}
