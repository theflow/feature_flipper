FeatureFlipper.features do
  in_state :dev do
    feature :dev_feature, :description => 'dev feature'
  end

  in_state :live do
    feature :live_feature
  end

  in_state :beta do
    feature :enabled_beta_feature
    feature :disabled_beta_feature
  end
end

FeatureFlipper.states do
  state :dev, ['development', 'test'].include?(Rails.env)
  state :live, true
  state :beta, Proc.new { |feature| 'enabled_beta_feature' == feature.to_s }
end
