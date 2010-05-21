module FeatureFlipper
  module Config
    @features = {}
    @states   = {}

    def self.path_to_file
      @path_to_file || File.join(Rails.root, 'config', 'features.rb')
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

    def self.active_state?(state)
      active = states[state]
      if active.is_a?(Hash)
        if active.has_key?(:feature_group)
          group, required_state = active[:feature_group], active[:required_state]
        else
          group, required_state = active.to_a.flatten
        end
        (FeatureFlipper.current_feature_groups.include?(group)) || (states[required_state] == true)
      else
        active == true
      end
    end

    def self.is_active?(feature_name)
      ensure_config_is_loaded

      state = get_state(feature_name)
      if state.is_a?(Symbol)
        active_state?(state)
      elsif state.is_a?(Proc)
        state.call == true
      else
        state == true
      end
    end
  end

  class Mapper
    def initialize(state)
      @state = state
    end

    def feature(name, options = {})
      FeatureFlipper::Config.features[name] = options.merge(:state => @state)
    end
  end

  class StateMapper
    def in_state(state, &block)
      Mapper.new(state).instance_eval(&block)
    end
  end

  def self.features(&block)
    StateMapper.new.instance_eval(&block)
  end

  def self.current_feature_groups
    Thread.current[:feature_system_current_feature_groups] ||= []
  end

  def self.reset_current_feature_groups
    current_feature_groups.clear
  end
end
