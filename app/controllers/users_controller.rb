class UsersController < ApplicationController
  include JsonWebToken
  before_action :jwt_authenticate, except: :create

  def create
    user = User.new(user_params)
    if user.save
      render status: 200, json: {status: 200, saved_user: user}
    else
      render status: 400,  json: {status: 400, msg: user.errors}
    end
  end

  def show
    render status: 200, json: {status: 200, current_user: @current_user}
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
