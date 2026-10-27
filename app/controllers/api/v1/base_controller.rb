
module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate_api_token!, if: :authentication_required?

      rescue_from ActiveRecord::RecordNotFound,
                  with: :record_not_found

      rescue_from ActionController::ParameterMissing,
                  with: :bad_request

      private

      def authentication_required?
        controller_name == "repairs" ||
          (controller_name == "services" && action_name == "create")
      end

      def authenticate_api_token!
        authenticated = authenticate_with_http_token do |token, _options|
          expected_token = Rails.application.credentials.dig(:api, :token)

          expected_token.present? &&
            ActiveSupport::SecurityUtils.secure_compare(token, expected_token)
        end

        return if authenticated

        response.set_header(
          "WWW-Authenticate",
          'Bearer realm="Wheelhouse API"'
        )

        render json: {
          errors: ["Invalid or missing authentication token"]
        }, status: :unauthorized
      end

      def record_not_found(exception)
        render json: {
          errors: [exception.message]
        }, status: :not_found
      end

      def bad_request(exception)
        render json: {
          errors: [exception.message]
        }, status: :bad_request
      end
    end
  end
end
