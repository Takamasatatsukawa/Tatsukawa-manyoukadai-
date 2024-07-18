require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '企画書', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.new(title: '企画書', content: '企画書を作成する。', deadline_on: '2022-02-18', priority: 2, status: 'todo')
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    before do
      @first_task = Task.create(title: 'first_task', content: 'content1', deadline_on: '2022-02-18', priority: :medium, status: 'todo')
      @second_task = Task.create(title: 'second_task', content: 'content2', deadline_on: '2022-02-17', priority: :high, status: 'in_progress')
      @third_task = Task.create(title: 'third_task', content: 'content3', deadline_on: '2022-02-16', priority: :low, status: 'done')
    end

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_title('first')).to include(@first_task)
        expect(Task.search_by_title('first')).not_to include(@second_task, @third_task)
        expect(Task.search_by_title('first').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_status('todo')).to include(@first_task)
        expect(Task.search_by_status('todo')).not_to include(@second_task, @third_task)
        expect(Task.search_by_status('todo').count).to eq 1
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_by_title('first').search_by_status('todo')).to include(@first_task)
        expect(Task.search_by_title('first').search_by_status('todo')).not_to include(@second_task, @third_task)
        expect(Task.search_by_title('first').search_by_status('todo').count).to eq 1
      end
    end
  end
end