require 'rails_helper'

RSpec.describe User, type: :model do
  describe '管理者削除の制御' do
    let!(:admin) { FactoryBot.create(:user, :admin) }

    it '管理者が1人しかいない場合、その管理者を削除できない' do
      expect {
        admin.destroy
      }.to_not change { User.count }

      expect(admin.errors[:base]).to include('管理者が0人になるため削除できません')
    end
  end
end
