require 'spec_helper'

feature "User reset password" do
  scenario "user successfully resets the password" do
    steven = Fabricate(:user)
    visit sign_in_path
    click_link "Forgot password?"

    fill_in "Email Address", with: steven.email
    click_button "Send Email"

    open_email(steven.email)
    current_email.click_link "Reset my password"

    fill_in "New Password", with: "new_password"
    click_button "Reset Password"

    fill_in "Email Address", with: steven.email
    fill_in "Password", with: "new_password"
    click_button "Sign in"

    page.should have_content(steven.full_name)
  end
end