class User < ApplicationRecord
    has_secure_password
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :admin, inclusion: { in: [true, false] }
  end
  