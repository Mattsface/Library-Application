require 'rails_helper'

describe 'User Administration Features:' do

  before(:all) do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe 'Index' do
    before(:each) do
      @user  = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:admin)
    end

    describe 'as a user' do
      before(:each) do
        visit new_user_session_path
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        click_button 'Sign in'
      end
      it 'is not visible' do
        visit useradmin_index_path
        expect(page).to have_text('Naughty!')
      end
    end
      
    describe 'as an admin' do
      before(:each) do
        visit new_user_session_path
        fill_in 'Email', with: @admin.email
        fill_in 'Password', with: @admin.password
        click_button 'Sign in'
      end
      it 'lists the users' do
        visit useradmin_index_path
        [@user, @admin].each do |u|
          expect(page).to have_text(u.email)
        end
      end
      it 'lets me block a user' do
        visit useradmin_index_path
        first(:link, "Block").click
        expect(page).to have_link("Unblock", count: 1)
      end
      it 'lets me unblock a user' do
        visit useradmin_index_path
        first(:link, "Block").click
        first(:link, "Unblock").click
        expect(page).to have_link("Block", count: 2)
      end
    end
      
  end

  describe 'Show' do
    before(:each) do
      @user  = FactoryGirl.create(:user)
      @admin = FactoryGirl.create(:admin)
      visit new_user_session_path
      fill_in 'Email', with: @admin.email
      fill_in 'Password', with: @admin.password
      click_button 'Sign in'
    end

    it 'lets the admin sign in as another user' do
      visit useradmin_path @user
      expect(page).to have_link("Impersonate Me!", count: 1)
      click_link 'Impersonate Me!'
      expect(page).to have_text("You are actually #{@admin.email}")
    end

    it 'and we can sign back out' do
      visit useradmin_path @user
      click_link 'Impersonate Me!'
      expect(page).to have_link("Stop impersonating", count: 1)
      click_link "Stop impersonating"
      expect(page).to have_text("User Administration Page")
    end

  end

end
