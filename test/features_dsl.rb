FeatureFlipper.features do
  in_state :dev do
    feature :dev_feature, :description => 'dev feature'
  end

  in_state :live do
    feature :live_feature
  end

  in_state true do
    feature :boolean_feature
  end

  in_state Proc.new { Date.today > Date.today - 84000 } do
    feature :proc_feature
  end

  in_state :beta do
    feature :enabled_beta_feature
    feature :disabled_beta_feature
  end

  in_state :context do
    feature :feature1
    feature :feature2
    feature :feature3
  end
end


FeatureFlipper::Config.states = {
  :dev      => ['development', 'test'].include?(Rails.env),
  :live     => true,
  :beta     => { :required_state => :dev, :when => Proc.new { |feature| %{ enabled_beta_feature }.include?(feature.to_s) } },
  :context  => { :when => Proc.new { |feature| current_user_betas.include?(feature) } }
}
