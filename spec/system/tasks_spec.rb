require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  include FactoryBot::Syntax::Methods
 
  let!(:task1) { Task.create(title: 'first_task', content: 'content1', deadline_on: '2022-02-18', priority: :medium, status: 'todo', created_at: 3.days.ago) }
  let!(:task2) { Task.create(title: 'second_task', content: 'content2', deadline_on: '2022-02-17', priority: :high, status: 'in_progress', created_at: 2.days.ago) }
  let!(:task3) { Task.create(title: 'third_task', content: 'content3', deadline_on: '2022-02-16', priority: :low, status: 'done', created_at: 1.day.ago) }
 
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
         fill_in 'task[deadline_on]', with: '2022-12-31'
         select '中', from: 'task[priority]'
         select '未着手', from: 'task[status]'
         click_button I18n.t('views.tasks.new.create task')

         # 新規投稿pageにvisit（遷移）して"こんにちは"という文字列を、fill_in（記入）してボタンをクリックし、expect（確認・期待）する
         expect(page).to have_content 'こんにちは'
         expect(page).to have_content 'こんばんは'
         # expectの結果が「真」であれば成功、「偽」であれば失敗としてテスト結果が出力される
      end
    end
  end
  
  describe '一覧表示機能' do
    before do
      visit tasks_path
    end

  describe '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        tasks = all('tr.task') # 適切なCSSセレクタを指定
        expect(tasks[0]).to have_content('third_task')
        expect(tasks[1]).to have_content('second_task')
        expect(tasks[2]).to have_content('first_task')
      end
    end
  
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
      
        fill_in 'task[title]', with: 'new_task'
        fill_in 'task[content]', with: '新しいタスクの内容'
        fill_in 'task[deadline_on]', with: '2022-12-31'
        select '中', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        click_button I18n.t('views.tasks.new.create task')    
        visit tasks_path
        tasks = page.all('tbody tr')
        expect(tasks[0]).to have_content('new_task')
      end
    end
  end

  describe '詳細表示機能' do
    it '任意のタスク詳細画面に遷移した場合、そのタスクの内容が表示される' do
      task = Task.create!(title: '書類作成３', content: '企画書を作成する。３', deadline_on: '2022-12-31', priority: :medium, status: 'todo')
      visit task_path(task)
      expect(page).to have_content('書類作成３')
      expect(page).to have_content('企画書を作成する。３')
     end
  end 

  describe 'ソート機能' do
    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        visit tasks_path
        click_on '終了期限'
        sleep 1 # タスクが並び替わるのを待つ
        task_titles = all('.task_title').map(&:text)
        expect(task_titles).to eq ['third_task', 'second_task', 'first_task']
      end
    end

    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        visit tasks_path
        click_on '優先度'
        sleep 1 # タスクが並び替わるのを待つ
        task_titles = all('.task_title').map(&:text)
        expect(task_titles).to eq ['second_task', 'first_task', 'third_task']
      end
    end
  end

  describe '検索機能' do
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        visit tasks_path
        fill_in 'search_title', with: 'first'
        click_on '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
        expect(page).not_to have_content 'third_task'
      end
    end

    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        visit tasks_path
        select '未着手', from: 'search_status'
        click_on '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
        expect(page).not_to have_content 'third_task'
      end
    end

    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        visit tasks_path
        fill_in 'search_title', with: 'first'
        select '未着手', from: 'search_status'
        click_on '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
        expect(page).not_to have_content 'third_task'
      end
    end
  end
end