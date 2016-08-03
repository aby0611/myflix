class CategoryController < ApplicationController
  def index
  end

  def show
  	@category = Category.find(params[:id])
  end
end