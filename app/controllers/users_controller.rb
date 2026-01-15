class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
    if htmx_request?
      render :new, layout: false
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome! Your account has been created."
      start_new_session_for(@user)

      if htmx_request?
        render partial: "home/index", locals: { authenticated: true }
      else
        redirect_to root_path, notice: "Welcome! Your account has been created."
      end
    else
      if htmx_request?
        render :new, layout: false, status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
