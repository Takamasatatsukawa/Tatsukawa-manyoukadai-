# spec/system/user_spec.rb
require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
    let!(:admin) { FactoryBot.create(:user, :admin, name: 'Admin', email: 'admin@example.com') }
    let!(:user) { FactoryBot.create(:user, name: 'User', email: 'user@example.com') }
    let!(:task) { FactoryBot.create(:task, user: admin)}

    before do
        puts "Admin ID: #{admin.id}"
        puts "User ID: #{user.id}"
      end

    def login_as(email, password)
    visit new_session_path
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    click_button 'Log in'
  end

  describe '登録機能' do
    context 'ユーザを登録した場合' do
        before do
            login_as('admin@example.com', 'password')
          end
      it 'タスク一覧画面に遷移する' do
        visit new_admin_user_path
        fill_in '名前', with: 'Test User'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_on '登録する'
        expect(page).to have_content('タスク一覧')
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content('ログインしてください')
        expect(current_path).to eq(new_session_path)
      end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      before do
        login_as('user@example.com', 'password')
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content('ログインしました')
        expect(current_path).to eq(tasks_path)
      end

      it '自分の詳細画面にアクセスできる' do
        visit user_path(user)
        expect(page).to have_content('User')
        expect(current_path).to eq(user_path(user))
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(admin)
        expect(page).to have_content('アクセス権限がありません')
        expect(current_path).to eq(tasks_path)
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content('ログアウトしました')
        expect(current_path).to eq(new_session_path)
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      before do
        login_as('admin@example.com', 'password')
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content('ユーザ一覧')
        expect(current_path).to eq(admin_users_path)
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in '名前', with: 'New Admin'
        fill_in 'メールアドレス', with: 'newadmin@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'
        expect(page).to have_content('ユーザを登録しました')
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user)
        expect(page).to have_content('User')
        expect(current_path).to eq(admin_user_path(user))
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(user)
        fill_in '名前', with: 'Updated User'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '更新する'
        expect(page).to have_content('ユーザを更新しました')
        expect(user.reload.name).to eq('Updated User')
      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        accept_confirm do
        find("a[href='#{admin_user_path(user)}'][data-method='delete']").click
        end
        expect(page).to have_content('ユーザを削除しました')
        expect(User.exists?(user.id)).to be_falsey
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        login_as('user@example.com', 'password')
      end

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content('管理者以外アクセスできません')
        expect(current_path).to eq(tasks_path)
      end
    end
  end
end
