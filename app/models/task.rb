class Task < ApplicationRecord 
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { todo: 0, in_progress: 1, done: 2 }
  
  scope :search_by_title, -> (title) { where("title LIKE ?", "%#{title}%") if title.present? }
  scope :search_by_status, -> (status) { where(status: status) if status.present? }
  scope :sorted_by, ->(sort_params) { order(sort_params) if sort_params.present? }
  scope :default_order, -> { order(created_at: :desc) }

  validates :deadline_on, presence: { message: I18n.t('activerecord.errors.models.task.attributes.deadline_on.blank') }
  validates :priority, presence: { message: I18n.t('activerecord.errors.models.task.attributes.priority.blank') }
  validates :status, presence: { message: I18n.t('activerecord.errors.models.task.attributes.status.blank') }
  validates :title, presence: true
  validates :content, presence: true

    def created_at_in_time_zone
        created_at.in_time_zone('Tokyo') # 例として東京タイムゾーンを設定
      end
end