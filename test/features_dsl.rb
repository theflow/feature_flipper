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
end


FeatureFlipper::Config.states = {
  :dev      => ['development', 'test'].include?(Rails.env),
  :live     => true
}
