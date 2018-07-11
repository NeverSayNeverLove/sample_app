class User < ApplicationRecord
  before_save :email_downcase
  
  validate :name, presence: true, length: {maximum: Setting.max.name_len}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validate :email, presence: true, length: {maximum: Setting.max.email_len},
                   format: {with: VALID_EMAIL_REGEX},
                   uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, precence: true, length: {minimum: 6}

  private
  def email_downcase
    email.downcase!
  end
end
