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
    
    def self.active_dependencies?(feature_name)
      feature = features[feature_name]
      [*(feature[:requires] || [])].all? do |required_feature| 
        FeatureFlipper::Config.is_active?(required_feature)
      end
    end

    def self.active_state?(state)
      active = state.is_a?(Symbol) ? states[state] : state
      if active.is_a?(Hash)
        if active.has_key?(:feature_group)
          group, required_state = active[:feature_group], active[:required_state]
        else
          group, required_state = active.to_a.flatten
        end
        (FeatureFlipper.active_feature_groups.include?(group)) || (states[required_state] == true)
      elsif active.is_a?(Proc)
        active.call == true
      else
        active == true
      end
    end

    def self.is_active?(feature_name)
      ensure_config_is_loaded

      state = get_state(feature_name)
      active_dependencies?(feature_name) && active_state?(state)
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
    def in_state(state, condition = nil, &block)
      state(state, condition) unless condition.nil?
      Mapper.new(state).instance_eval(&block)
    end
    
    def state(name, condition = false)
      FeatureFlipper::Config.states[name] = condition
    end
  end

  def self.features(&block)
    StateMapper.new.instance_eval(&block)
  end
  
  def self.states(&block)
    StateMapper.new.instance_eval(&block)
  end

  def self.active_feature_groups
    Thread.current[:feature_system_active_feature_groups] ||= []
  end

  def self.reset_active_feature_groups
    active_feature_groups.clear
  end
end
