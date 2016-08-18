class InvitationsController < ApplicationController
  before_filter :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    invitation = Invitation.new(invite_params)

    if invitation.save
      AppMailer.send_invitation(invitation).deliver
      flash[:success] = "Send your invitation to #{invitation.recipient_name}"
      redirect_to new_invitation_path
    else
      flash[:error] = "Please check your input."
      render :new
    end
  end

  private

  def invite_params
    params.require(:invitation).permit(:recipient_email, :recipient_name, :message, :inviter_id).merge!(inviter: current_user)
  end
end