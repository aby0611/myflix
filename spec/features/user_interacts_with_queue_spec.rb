require 'spec_helper'

feature "User interacts with the queue" do
  scenario "user adds and reorder videos in the queue" do
    action = Fabricate(:category)
    bb = Fabricate(:video, title: "Breaking Bad")
    got = Fabricate(:video, title: "Game of Thrones")
    flash = Fabricate(:video, title: "Flash")

    action.videos << bb
    action.videos << got
    action.videos << flash
  
    sign_in

    add_video_to_queue(bb)
    expect_video_to_be_in_queue(bb)

    visit video_path(bb)
    expect_link_not_to_be_seen("+ My Queue")
    
    add_video_to_queue(got)
    add_video_to_queue(flash)

    set_video_position(bb, 3)
    set_video_position(got, 1)
    set_video_position(flash, 2)

    update_queue

    expect_video_position(got, 1)
    expect_video_position(flash, 2)
    expect_video_position(bb, 3)
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def expect_link_not_to_be_seen(text_content)
    page.should_not have_content text_content
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def add_video_to_queue(video)
    visit home_path
    find_and_click_video(video)
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end