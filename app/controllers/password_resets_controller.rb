class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    #require "pry"; binding.pry
    redirect_to expired_token_path unless user
  end
end