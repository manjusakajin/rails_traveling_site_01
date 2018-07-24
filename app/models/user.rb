class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :trips, through: :participations

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: {maximum: 50}
  validates :email, presence: true,
    length: {maximum: 160}, format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: 6}, allow_nil: true

  has_secure_password
end
