class WelcomeController < ApplicationController
  def index
    flash[:alert] = "红灯，"
    flash[:notice] = "绿灯，"
    flash[:warning] = "小黄灯……"
  end
end
