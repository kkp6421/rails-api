class StaticPagesController < ApplicationController
  def index
    render status: 200, json: {status: 200, msg: "This is Sample Rails API"}
  end
end
