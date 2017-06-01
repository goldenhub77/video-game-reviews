require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.create' do
    it 'succeeds' do
      user = User.create(
        first_name: 'John',
        last_name: 'Smith',
        email: 'test123@abc.com',
        password: 'Pa$$word',
        password_confirmation: 'Pa$$word'
      )

      expect(user.valid?).to be_truthy
      expect(user.errors).to be_empty
    end
    it 'fails' do
      user = User.create(
        first_name: '',
        last_name: '',
        email: 'bademail',
        password: 'Pa$$word',
        password_confirmation: 'unmatched'
      )

      expect(user.valid?).to be_falsey
      expect(user.errors.messages).to eq({
        :email=>["is invalid"],
        :password_confirmation=>["doesn't match Password"],
        :first_name=>["can't be blank"],
        :last_name=>["can't be blank"]}
        )
    end
  end

  describe '.is_admin?' do
    it 'equals false' do
      user = User.create(
        first_name: 'John',
        last_name: 'Smith',
        email: 'test123@abc.com',
        password: 'Pa$$word',
        password_confirmation: 'Pa$$word'
      )
      expect(user.is_admin?).to be_falsey
    end
    it 'equals true' do
      user = User.create(
        first_name: 'John',
        last_name: 'Smith',
        email: 'test123@abc.com',
        role: 'admin',
        password: 'Pa$$word',
        password_confirmation: 'Pa$$word'
      )
      expect(user.is_admin?).to be_truthy
    end
  end
end