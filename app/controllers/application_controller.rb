
class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization

  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_pundit_usage, if: :verify_pundit_usage?

  private

  def pundit_user
    Current.user
  end

  def user_not_authorized
    render "errors/forbidden", status: :forbidden
  end

  def verify_pundit_usage?
    Rails.env.development? && !public_pundit_action?
  end

  def verify_pundit_usage
    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end

  def public_pundit_action?
    public_actions = {
      "pages" => %w[home visit about],
      "sessions" => %w[new create destroy],
      "registrations" => %w[new create],
      "passwords" => %w[new create edit update]
    }

    public_actions.fetch(controller_path, []).include?(action_name)
  end
end
