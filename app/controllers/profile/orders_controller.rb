class Profile::OrdersController < ApplicationController

  def index
    binding.pry
    @profile = Profile.find
  end
end
