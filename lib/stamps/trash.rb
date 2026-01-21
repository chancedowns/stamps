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
      out = {}

      self.class.properties.each do |prop|
        next unless key?(prop) || key?(prop.to_s)
        v = self[prop] || self[prop.to_s]
        next if v.nil?

        out[prop] = Hash === v ? v.to_hash : (v.respond_to?(:to_hash) ? v.to_hash : v)
      end

      out
    end


  end
end
