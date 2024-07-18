# 「FactoryBotを使用します」という記述
FactoryBot.define do
    # 作成するテストデータの名前を「task」とします
    # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
    # factory :task do
    #   title { '書類作成' }
    #   content { '企画書を作成する。' }
    # end
    # # 作成するテストデータの名前を「second_task」とします
    # # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
    # factory :second_task, class: Task do
    #   title { 'メール送信' }
    #   content { '顧客へ営業のメールを送る。' }
    # end
    factory :task do
      # sequence(:title) { |n| "Task #{n}" }
      # sequence(:content) { |n| "Content for task #{n}" }
      # created_at { Faker::Time.backward(days: 30) }  # 過去30日間の日付をランダムに生成
      title { "Default Title" }
      content { "Default Content" }
      deadline_on { "2022-12-31" }
      priority { :medium }
      status { :todo }
      created_at { Time.now }
  
      trait :low_priority do
        priority { :low }
      end
  
      trait :medium_priority do
        priority { :medium }
      end
  
      trait :high_priority do
        priority { :high }
      end
  
      trait :todo_status do
        status { :todo }
      end
  
      trait :in_progress_status do
        status { :in_progress }
      end
  
      trait :done_status do
        status { :done }
      end
    end
  end