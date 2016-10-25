class User < ApplicationRecord
  before_save do
    email.downcase! if email
    username.downcase! if username
  end

  validates :username, presence: true,
                       uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :bucketlists
end
