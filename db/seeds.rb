# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'factory_bot_rails'
require 'faker'

# 確認のため、既存のタスクをすべて削除
Task.delete_all

# 50件のタスクデータを生成
50.times do
  FactoryBot.create(:task)
end

puts "50件のタスクデータを投入しました。"