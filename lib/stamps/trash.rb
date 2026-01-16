require 'hashie/trash'

module Hashie
  class Trash

    class << self
      attr_reader :properties

      # Override property to track declaration order
      alias_method :original_property, :property

      def property(property_name, options = {})
        @properties ||= []
        @properties << property_name unless @properties.include?(property_name)
        original_property(property_name, options)
      end
    end

    # Initialize properties array for each class
    @properties = []

    # Sort the hash by the order in which the properties are declared
    def to_hash
      sorted_keys = self.class.properties.map{|prop| prop.to_s} & self.keys

      # Use active_support for ordering hashes for Ruby < 1.9
      out = RUBY_VERSION >= '1.9' ? {} : ActiveSupport::OrderedHash.new
      sorted_keys.each do |k|
        next if self[k].nil?
        out[k] = Hashie::Hash === self[k] ? self[k].to_hash : self[k]
      end
      out
    end

  end
end
