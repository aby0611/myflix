require 'spec_helper'

feature "User following" do
  scenario "user follow and unfollow someone" do
    alice = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video)
    video.categories << category
    Fabricate(:review, user: alice, video: video)

    sign_in
    find_and_click_video(video)

    click_link alice.full_name
    click_link "Follow"
    expect(page).to have_content(alice.full_name)
 
    unfollow(alice)
    expect(page).not_to have_content(alice.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end