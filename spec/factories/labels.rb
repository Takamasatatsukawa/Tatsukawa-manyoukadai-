FactoryBot.define do
  factory :label do
    name { "テストラベル" }
    association :user
  end
end
