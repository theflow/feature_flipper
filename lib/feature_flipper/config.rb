module FeatureFlipper
  module Config
    @features = {}
    @states   = {}

    def self.path_to_file
      @path_to_file
    end

    def self.path_to_file=(path_to_file)
      @path_to_file = path_to_file
    end

    def self.ensure_config_is_loaded
      return if @config_loaded

      load path_to_file
      @config_loaded = true
    end

    def self.reload_config
      @features = {}
      @states   = {}

      @config_loaded = false
    end

    def self.features
      @features
    end

    def self.features=(features)
      @features = features
    end

    def self.states
      @states
    end

    def self.states=(states)
      @states = states
    end

    def self.get_state(feature_name)
      feature = features[feature_name]
      feature ? feature[:state] : nil
    end

    def self.active_state?(state, feature_name, context = nil)
      condition = states[state]
      if condition.is_a?(Proc)
        if context
          context.instance_exec(feature_name, &condition)
        else
          condition.call(feature_name) == true
        end
      else
        condition == true
      end
    end

    def self.is_active?(feature_name, context = nil)
      ensure_config_is_loaded

      state = get_state(feature_name)
      active_state?(state, feature_name, context)
    end

    def self.active_features(context = nil)
      self.features.collect { |key, value| self.is_active?(key, context) ? key : nil }.compact
    end
  end

  class FeatureMapper
    def initialize(state)
      @state = state
    end

    def feature(name, options = {})
      FeatureFlipper::Config.features[name] = options.merge(:state => @state)
    end
  end

  class FeaturesMapper
    def in_state(state, &block)
      FeatureMapper.new(state).instance_eval(&block)
    end
  end

  class StatesMapper
    def state(name, condition = false)
      FeatureFlipper::Config.states[name] = condition
    end
  end

  def self.features(&block)
    FeaturesMapper.new.instance_eval(&block)
  end

  def self.states(&block)
    StatesMapper.new.instance_eval(&block)
  end
end
