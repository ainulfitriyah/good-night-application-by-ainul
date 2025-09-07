require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe '#association' do
    it { should belong_to(:follower) }
    it { should belong_to(:followee) }
  end

  describe '#indexes' do
    it { should have_db_index(:follower_id) }
    it { should have_db_index(:followee_id) }
  end
end
