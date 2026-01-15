class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
    if htmx_request?
      render :new, layout: false
    end
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user

      if htmx_request?
        render partial: "home/index", locals: { authenticated: true }
      else
        redirect_to after_authentication_url
      end
    else
      flash[:alert] = "Try another email address or password."
      if htmx_request?
        render :new, layout: false, status: :unprocessable_entity
      else
        redirect_to new_session_path, alert: "Try another email address or password."
      end
    end
  end

  def destroy
    terminate_session
    flash[:notice] = "You have been logged out."

    if htmx_request?
      render partial: "home/index", locals: { authenticated: false }
    else
      redirect_to new_session_path, status: :see_other
    end
  end
end
