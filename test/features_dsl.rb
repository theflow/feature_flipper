FeatureFlipper.features do
  in_status :dev do
    feature :dev_feature, :description => 'dev feature'
  end

  in_status :live do
    feature :live_feature
  end

  in_status true do
    feature :boolean_feature
  end

  in_status Proc.new { Date.today > Date.today - 84000 } do
    feature :proc_feature
  end
end


FeatureFlipper::Config.states = {
  :dev      => ['development', 'test'].include?(Rails.env),
  :live     => true
}
