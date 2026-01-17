module Stamps
  class Client
    module Address

      # Authorizes the User and returns authenticator token
      #
      def clean_address(params = {})
        # Add authenticator FIRST so it appears in the correct position
        params = { authenticator: authenticator_token }.merge(params)
        response = request('CleanseAddress', Stamps::Mapping::CleanseAddress.new(params))
        response[:errors].empty? ? response[:cleanse_address_response] : response
      end

    end
  end
end
