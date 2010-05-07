FeatureFlipper::Config.features = {
  :live_feature     => { :status => :live },
  :disabled_feature => { :status => :disabled },
  :dev_feature      => { :status => :dev, :description => 'dev feature' },
  :boolean_feature  => { :status => true },
  :proc_feature     => { :status => Proc.new { Date.today > Date.today - 84000 } },
  :beta_feature     => { :status => :beta }
}


FeatureFlipper::Config.states = {
  :disabled => false,
  :dev      => ['development', 'test'].include?(Rails.env),
  :beta     => { :beta_users => :dev },
  :live     => true
}
