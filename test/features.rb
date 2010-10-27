FeatureFlipper.features do
  in_state :live do
    feature :live_feature
  end
  
  in_state :disabled do
    feature :disabled_feature
  end
  
  in_state :dev do
    feature :dev_feature, :description => 'dev feature'
  end
  
  in_state :live do
    feature :boolean_feature
    feature :requires_live, :requires => :boolean_feature
    feature :requires_disabled, :requires => :disabled_feature
    feature :requires_many, :requires => [:boolean_feature, :requires_live]
  end
  
  in_state :proc do
    feature :proc_feature
  end
  
  in_state :beta_old do
    feature :beta_feature_old
  end
  
  in_state :beta_new do
    feature :beta_feature_new
  end
  
  in_state :employees do
    feature :employee_feature
  end
end

FeatureFlipper.states do
  state :disabled, false
  state :dev, ['development', 'test'].include?(Rails.env)
  state :beta_old, :beta_users => :dev
  state :beta_new, :required_state => :dev, :feature_group => :beta_users
  state :employees, :required_state => :dev, :feature_group => :employees
  state :live, true
  state :proc, Proc.new { Date.today > Date.today - 84000 }
end
