require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:image) }
  end
end
