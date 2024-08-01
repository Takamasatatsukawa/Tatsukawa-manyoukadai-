class User < ApplicationRecord
    has_secure_password
    has_many :labels, dependent: :destroy
   
    before_update :ensure_an_admin_remains_on_update
    has_many :tasks, dependent: :destroy

    before_save :downcase_email

    validates :name, presence: { message: '名前を入力してください' }
    validates :email, presence: { message: 'メールアドレスを入力してください' }, uniqueness: { case_sensitive: false, message: 'メールアドレスはすでに使用されています' }
    validates :password, presence: { message: 'パスワードを入力してください' }, length: { minimum: 6, message: 'パスワードは6文字以上で入力してください' }
    #validates :password_confirmation, presence: true, if: -> { new_record? || password.nil? }
    #validate :password_confirmation_matches
    
    validate :ensure_an_admin_remains_on_update, on: :update
    before_destroy :ensure_an_admin_remains_on_destroy
    
    
    private

    def downcase_email
      self.email = email.downcase
    end



  def password_confirmation_matches
    if password != password_confirmation
      errors.add(:password_confirmation, 'パスワード（確認）とパスワードの入力が一致しません')
    end
  end

  def ensure_an_admin_remains_on_destroy
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, '管理者が0人になるため削除できません')
      throw(:abort)
    end
  end

  def ensure_an_admin_remains_on_update
    if User.where(admin: true).count == 1 && self.admin_was && !self.admin
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw(:abort)
    end
  end
end
  