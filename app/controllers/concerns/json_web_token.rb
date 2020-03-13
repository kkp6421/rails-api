module JsonWebToken
  require 'jwt'

  SECRET_KEY = Rails.application.secrets.secret_key_base

  def jwt_authenticate
    if request.headers['Authorization'].blank?
      render status: 400, json: {status: 400, msg: "Missing Authorization parameter"}
    else
      encoded_token = request.headers['Authorization'].split('Bearer ').last
      begin
        payload = decode(encoded_token)
        @current_user = User.find_by(id: payload["user_id"])
        if @current_user.blank?
          render status: 401, json: {status: 401, msg: "Invalid Access Token."}
        else
          @current_user
        end
      rescue => ex
        render status: 401, json: {status: 401, msg: "Invalid Access Token."}
      end
    end
  end

  def encode(user_id, exp=1.day.from_now.to_i)
    payload = {user_id: user_id, exp: exp}
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def decode(token)
      decode_jwt = JWT.decode(token, SECRET_KEY, true, {algorithm: 'HS256'})
      decode_jwt.first
  end
end
