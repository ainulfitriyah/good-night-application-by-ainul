require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#association' do
    it { should have_many(:sleep_records).dependent(:destroy) }
  end

  describe '#indexes' do
    it { should have_db_index(:name) }
  end
end
