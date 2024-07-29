# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'factory_bot_rails'
# require 'faker'

# 確認のため、既存のタスクをすべて削除
# Task.delete_all

#一般ユーザと管理者ユーザのデータを１件ずつ入れるコードを作成
general_user = User.create!(
  name: 'General User',
  email: 'general_user@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: false
)

admin_user = User.create!(
  name: 'Admin User',
  email: 'admin_user@example.com',
  password: 'adminpassword123',
  password_confirmation: 'adminpassword123',
  admin: true
)

# タスクの作成
50.times do |i|
  Task.create!(
    title: "General Task #{i+1}",
    content: "This is task number #{i+1} for general user.",
    deadline_on: Date.today + (i+1).days,
    priority: Task.priorities.keys.sample,
    status: Task.statuses.keys.sample,
    user: general_user
  )
end

50.times do |i|
  Task.create!(
    title: "Admin Task #{i+1}",
    content: "This is task number #{i+1} for admin user.",
    deadline_on: Date.today + (i+1).days,
    priority: Task.priorities.keys.sample,
    status: Task.statuses.keys.sample,
    user: admin_user
  )
end

puts "50件のタスクデータを投入しました"
# # 50件のタスクデータを生成
# ## admin_user.id general_user.id それぞれをuser_idのカラムに入れたTaskを作成
# 50.times do |i|
#   Task.create(title: "aaa#{i}", content: "bbb#{i}",user_id=ここ！)
# end

# puts "50件のタスクデータを投入しました。"

# Task(id: integer, title: string, content: text, created_at: datetime, updated_at: datetime, deadline_on: date, priority: integer, status: integer, user_id: integer)
# irb(main):004> 