require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
         # テストで使用するためのタスクを登録
         #Task new.(title: '書類作成', content: '企画書を作成する。')
         #FactoryBot.create(:task)
         # タスク一覧画面に遷移
         visit new_task_path
         fill_in 'task[title]', with: "こんにちは"
         fill_in 'task[content]', with:"こんばんは" 
         click_button "Create Task"

         # 新規投稿pageにvisit（遷移）して"こんにちは"という文字列を、fill_in（記入）してボタンをクリックし、expect（確認・期待）する
         expect(page).to have_content 'こんにちは'
         expect(page).to have_content 'こんばんは'
         # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        # テストで使用するためのタスクを複数登録
        Task.create!(title: '書類作成１', content: '企画書を作成する。１')
        Task.create!(title: '書類作成２', content: '企画書を作成する。２')
        FactoryBot.create(:task)
        # タスク一覧画面に遷移
        visit tasks_path
        # visit（遷移）したpage（この場合、タスク一覧画面）に"書類作成"という文字列が、have_content（含まれていること）をexpect（確認・期待）する
        expect(page).to have_content '書類作成１'
        expect(page).to have_content '企画書を作成する。１'
        expect(page).to have_content '書類作成２'
        expect(page).to have_content '企画書を作成する。２'
        # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        # テストで使用するためのタスクを登録
        @task3 = Task.create!(title: '書類作成３', content: '企画書を作成する。３')
        @task4 = Task.create!(title: '書類作成４', content: '企画書を作成する。４')
        FactoryBot.create(:task)
        # タスク詳細画面に遷移（特定）
        visit task_path(@task3)        # 登録ずみのタスクの詳細があるか確認
        expect(page).to have_content '書類作成３'
        expect(page).to have_content '企画書を作成する。３'
        #他のタスク詳細画面に遷移
        visit task_path(@task4)

        expect(page).to have_content '書類作成４'
        expect(page).to have_content '企画書を作成する。４'

       end
     end
  end
end