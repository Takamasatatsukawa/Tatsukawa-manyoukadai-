# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require 'factory_bot_rails'
# require 'faker'

#確認のため、既存のタスクをすべて削除
# Task.delete_all

#一般ユーザと管理者ユーザのデータを１件ずつ入れるコードを作成
# db/seeds.rb

begin
  general_user = User.create!(
    name: 'General User',
    email: 'general_user@example.com',
    password: 'password123',
    password_confirmation: 'password123',
    admin: false
  )
  puts "General User created: #{general_user.inspect}"
rescue => e
  puts "Failed to create General User: #{e.message}"
end

begin
  admin_user = User.create!(
    name: 'Admin User',
    email: 'admin_user@example.com',
    password: 'adminpassword123',
    password_confirmation: 'adminpassword123',
    admin: true
  )
  puts "Admin User created: #{admin_user.inspect}"
rescue => e
  puts "Failed to create Admin User: #{e.message}"
end

if general_user && admin_user
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

  puts "Users and tasks have been seeded."
else
  puts "Failed to seed users or tasks."
end


puts "50件のタスクデータを投入しました"