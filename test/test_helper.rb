$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'feature_flipper'

require 'minitest/autorun'
require 'date'

module Rails
  def self.env
    'test'
  end
end
