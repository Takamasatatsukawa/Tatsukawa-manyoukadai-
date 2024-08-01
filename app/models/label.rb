class Label < ApplicationRecord
    belongs_to :user
    has_many :task_labels, dependent: :destroy
    has_many :tasks, through: :task_labels

    validates :name, presence: { message: '名前を入力してください' }
end
