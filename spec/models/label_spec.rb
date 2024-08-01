require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        label = Label.new(name: '')  # 名前が空のラベルを作成
        expect(label).not_to be_valid  # バリデーションが失敗することを期待
        expect(label.errors[:name]).to include("名前を入力してください")  # エラーメッセージを確認
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        user = User.create(name: 'テストユーザー', email: 'test@example.com', password: 'password')  # ユーザーを作成
        label = Label.new(name: 'ラベル名', user: user)  # 有効な名前とユーザーを持つラベルを作成
        expect(label).to be_valid  # バリデーションが成功することを期待
      end
    end
  end
end