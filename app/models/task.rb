class Task < ApplicationRecord

    validates :title, presence: true
    validates :content, presence: true

    def created_at_in_time_zone
        created_at.in_time_zone('Tokyo') # 例として東京タイムゾーンを設定
      end
end