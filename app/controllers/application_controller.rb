class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def index
    @roads = Road.first(30)    
    @roads[0] = Road.find(3586)
  end
end
