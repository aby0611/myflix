require 'spec_helper'

feature "User invites friend" do
  scenario "User successfully invites friends and invitation is accepted", { js: true, vcr: true } do
    alice = Fabricate(:user)
    sign_in(alice)
    sleep 1 # For login time is too slow
    
    invite_a_friend
    friend_accept_invitation
    friend_sign_in

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_emails
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email Address", with: "john@example.com"
    fill_in "Message", with: "Join Myflix!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accept_invitation
    open_email("john@example.com")
    current_email.click_link "Accept the invitation"

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "John Doe"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"
    sleep 3 # Wait stripe server reply
  end

  def friend_sign_in
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content "John Doe"
  end
end