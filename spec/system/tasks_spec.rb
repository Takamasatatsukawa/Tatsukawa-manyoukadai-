require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  include FactoryBot::Syntax::Methods
 
  let!(:task1) {create(:task, title: 'first_task', created_at: '2022-02-18')}
  let!(:task2) {create(:task, title: 'second_task', created_at: '2022-02-17')}
  let!(:task3) {create(:task, title: 'third_task', created_at: '2022-02-16')}

  before do
    driven_by(:rack_test)
  end

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
         click_button I18n.t('views.tasks.new.create task')

         # 新規投稿pageにvisit（遷移）して"こんにちは"という文字列を、fill_in（記入）してボタンをクリックし、expect（確認・期待）する
         expect(page).to have_content 'こんにちは'
         expect(page).to have_content 'こんばんは'
         # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end
  
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      #it '登録済みのタスク一覧が表示される' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do  
        visit tasks_path
       
         expect(page).to have_content('first_task')
         expect(page).to have_content('second_task')
         expect(page).to have_content('third_task')

        tasks = page.all('tbody tr')
         expect(tasks[0]).to have_content('first_task')
         expect(tasks[1]).to have_content('second_task')
         expect(tasks[2]).to have_content('third_task')
      end
    end
  

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
      
        fill_in 'task[title]', with: 'new_task'
        fill_in 'task[content]', with: '新しいタスクの内容'
        click_button I18n.t('views.tasks.new.create task')
    
        visit tasks_path

        tasks = page.all('tbody tr')
        expect(tasks[0]).to have_content('new_task')
        expect(tasks[1]).to have_content('first_task')
        expect(tasks[2]).to have_content('second_task')
        expect(tasks[3]).to have_content('third_task')
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