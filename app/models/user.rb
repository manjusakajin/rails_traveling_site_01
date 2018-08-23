class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
    :rememberable, :recoverable, :lockable, :validatable
  include PgSearch

  before_save :downcase_email

  has_many :chatrooms, through: :messages
  has_many :comments, dependent: :destroy
  has_many :messages
  has_many :participations, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :trips, through: :participations
  has_many :create_trips, class_name: Trip.name, foreign_key: :user_id

  pg_search_scope :search, against: [:name, :email],
    using: {tsearch: {any_word: true}}

  scope :per_page, ->{per Settings.paginate.per}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length:
    {maximum: Settings.user.name.maximum}
  validates :email, presence: true,
    length: {maximum: Settings.user.email.maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.user.password.minimum}, allow_nil: true

  def is_user? user
    self == user
  end

  private
  def downcase_email
    email.downcase!
  end
end
