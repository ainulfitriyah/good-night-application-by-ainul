require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  describe '#association' do
    it { should belong_to(:user) }
  end

  describe '#indexes' do
    it { should have_db_index(:user_id) }
    it { should have_db_index(:woke_at) }
  end
end
