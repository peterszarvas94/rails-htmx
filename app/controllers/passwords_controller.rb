class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: "Try again later." }

  def new
    if htmx_request?
      render :new, layout: false
    end
  end

  def create
    if user = User.find_by(email_address: params[:email_address])
      PasswordsMailer.reset(user).deliver_later
    end

    if htmx_request?
      render partial: "shared/flash", locals: { notice: "Password reset instructions sent (if user with that email address exists)." }
    else
      redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
    end
  end

  def edit
    if htmx_request?
      render :edit, layout: false
    end
  end

  def update
    if @user.update(params.permit(:password, :password_confirmation))
      @user.sessions.destroy_all

      if htmx_request?
        render partial: "shared/flash", locals: { notice: "Password has been reset." }
      else
        redirect_to new_session_path, notice: "Password has been reset."
      end
    else
      if htmx_request?
        render partial: "shared/flash", locals: { alert: "Passwords did not match." }
      else
        redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
      end
    end
  end

  private
    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
