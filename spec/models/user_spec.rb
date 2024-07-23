require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: '', email: 'test@nelf.com', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('名前を入力してください')
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'テスト', email: '', password: 'password', password_confirmation: 'password') 
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスを入力してください')
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'テスト', email: 'test@nelf.com', password: '', password_confirmation: '') 
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('パスワードを入力してください')
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      before do
            User.create(name: 'テスト１', email: 'test@nelf.com', password: 'password', password_confirmation: 'password')
      end

      it 'バリデーションに失敗する' do
        user = User.new(name: 'テスト', email: 'test@nelf.com', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスはすでに使われています')
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'テスト', email: 'test@nelf.com', password: 'short', password_confirmation: 'short')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('パスワードは6文字以上で入力してください')
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.new(name: 'テスト', email: 'unique@nelf.com', password: 'password', password_confirmation: 'password')
        expect(user).to be_valid
      end
    end
  end
end