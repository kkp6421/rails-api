class SessionsController < ApplicationController
  include JsonWebToken
  def create
    @current_user = User.find_by(name: params["name"])
    if @current_user&.authenticate(params["password"])
      jwt_token = encode(@current_user.id)
      render status: 200, json: {
          status: 200,
          AccessToken: jwt_token,
          current_user: @current_user
      }
    else
      render status: 401, json: {status: 401, msg: "Invalid email or password."}
    end
  end
end
