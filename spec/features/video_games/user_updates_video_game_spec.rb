require 'rails_helper'

feature 'user updates an existing video game', %q(
  As an authenticated user
  I want to be able to update a video game
  I created when information may change
) do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:platform) { FactoryGirl.create(:platform) }
  let!(:platform2) { FactoryGirl.create(:platform) }
  let!(:genre) { FactoryGirl.create(:genre) }
  let!(:video_game) { FactoryGirl.create(:video_game, user_id: user.id) }

  scenario 'sucessfully' do

    sign_in(user)
    visit video_game_path(video_game)

    expect(page).to have_button('Edit')

    click_button 'Edit'

    expect(page).to have_content("Edit - #{video_game.title}")

    fill_in 'Title', with: 'Overwatch'
    fill_in 'Developer', with: 'Blizzard Entertainment'
    fill_in 'Description', with: video_game.description
    check platform2.name
    find(:xpath, "//input[@id='video_game_rating']").set 4
    fill_in 'Release Date', with: '06/10/2015'

    click_button 'Update Video game'

    expect(page).to have_content('Successfully updated Overwatch')
  end

  scenario 'fails with bad data' do

    sign_in(user)
    visit edit_video_game_path(video_game)

    fill_in 'Title', with: ''
    fill_in 'Developer', with: ''
    fill_in 'Description', with: ''
    fill_in 'Date', with: ''

    click_button 'Update Video game'

    expect(page).to have_content("6 errors in video game form.")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Title is too short (minimum is 5 characters)")
    expect(page).to have_content("Developer can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Description is too short (minimum is 15 characters)")
    expect(page).to have_content("Release date can't be blank")
  end

  scenario 'fails by no user logged in' do

    visit video_game_path(video_game.id)

    expect(page).not_to have_button('Edit')

    visit edit_video_game_path(video_game.id)

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
