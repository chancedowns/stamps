require 'hashie/trash'

module Hashie
  class Trash
    class << self
      # Override property to track order in an array
      def property(property_name, options = {})
        super
        (@property_order ||= []) << property_name
      end

      # Return properties in declaration order
      def property_order
        @property_order || []
      end
    end

    # Build hash in property declaration order, skipping nil values
    # Output uses property names (FirstName), not :from names (first_name)
    def to_hash
      self.class.property_order.each_with_object({}) do |prop_name, result|
        # Hashie::Trash stores values using the property name as the key
        # So self[:FirstName] returns the value, not self[:first_name]
        value = self[prop_name]
        next if value.nil?

        # Serialize nested objects recursively
        result[prop_name] = case value
                            when Hash
                              # For nested hashes, recursively convert any Trash objects
                              value.transform_values { |v| v.respond_to?(:to_hash) ? v.to_hash : v }
                            when Array
                              # For arrays, convert any Trash objects to hashes
                              value.map { |v| v.respond_to?(:to_hash) ? v.to_hash : v }
                            else
                              # For single objects, convert to hash if possible
                              value.respond_to?(:to_hash) ? value.to_hash : value
                            end
      end
    end
  end
end
