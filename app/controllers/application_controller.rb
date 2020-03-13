class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from Exception, with: :rescue500
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from ActionController::RoutingError, with: :rescue404

  def rescue404(e=nil)
    render status: 404, json: {status: 404, msg: "404 not found."}
  end
  def rescue500(e=nil)
    render status: 500, json: {status: 500, msg: "Internal Server Error."}
  end
end
