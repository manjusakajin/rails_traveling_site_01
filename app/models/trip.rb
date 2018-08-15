class Trip < ApplicationRecord
  include PgSearch

  belongs_to :place, foreign_key: "destination_id"
  belongs_to :owner, class_name: User.name, foreign_key: :user_id

  has_one :chatroom, dependent: :destroy

  has_many :participations, dependent: :destroy
  has_many :members, through: :participations,
    class_name: User.name, source: :user

  scope :per_page, ->{per Settings.paginate.per}

  pg_search_scope :search_trip, against: [:name],
    using: {tsearch: {any_word: true}}

  accepts_nested_attributes_for :place, reject_if: :all_blank

  validates :name, presence: true, length:
    {maximum: Settings.trip.name.maximum}
end
