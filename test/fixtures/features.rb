FeatureFlipper::Config.features = {
  :live_feature     => { :state => :live },
  :disabled_feature => { :state => :disabled },
  :dev_feature      => { :state => :dev, :description => 'dev feature' },
  :boolean_feature  => { :state => true },
  :proc_feature     => { :state => Proc.new { Date.today > Date.today - 84000 } },
  :beta_feature_old => { :state => :beta_old },
  :beta_feature_new => { :state => :beta_new },
  :employee_feature => { :state => :employees }
}


FeatureFlipper::Config.states = {
  :disabled    => false,
  :dev         => ['development', 'test'].include?(Rails.env),
  :beta_old    => { :beta_users => :dev },
  :beta_new    => { :required_state => :dev, :feature_group => :beta_users },
  :employees   => { :required_state => :dev, :feature_group => :employees },
  :live        => true
}
