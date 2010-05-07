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

    def self.get_status(feature_name)
      feature = features[feature_name]
      feature ? feature[:status] : nil
    end

    def self.active_status?(status)
      active = states[status]
      if active.is_a?(Hash)
        group, group_status = active.to_a.flatten
        FeatureFlipper.current_feature_group == group || states[group_status] == true
      else
        active == true
      end
    end

    def self.is_active?(feature_name)
      ensure_config_is_loaded

      status = get_status(feature_name)
      if status.is_a?(Symbol)
        active_status?(status)
      elsif status.is_a?(Proc)
        status.call == true
      else
        status == true
      end
    end
  end

  class Mapper
    def initialize(status)
      @status = status
    end

    def feature(name, options = {})
      FeatureFlipper::Config.features[name] = options.merge(:status => @status)
    end
  end

  class StatusMapper
    def in_status(status, &block)
      Mapper.new(status).instance_eval(&block)
    end
  end

  def self.features(&block)
    StatusMapper.new.instance_eval(&block)
  end

  def self.current_feature_group
    Thread.current[:feature_system_current_feature_group]
  end

  def self.current_feature_group=(feature_group)
    Thread.current[:feature_system_current_feature_group] = feature_group
  end
end
