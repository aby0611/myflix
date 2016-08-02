class RelationshipsController < ApplicationController
  before_filter do
    redirect_to :root if Rails.env.production?
  end
  before_filter :require_user

  layout "application"

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    Relationship.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    redirect_to people_path
  end
end
