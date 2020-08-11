class User < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  validates :address, :presence => true,
    :length => { :minimum => 5 }

  validates :phone_number, format: { with: /(6|8|9)\d{7}/, message: "should be valid" }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: [:user, :recycler, :admin] # collector = user
  after_initialize :set_default_role, :if => :new_record?

  has_many :lists
  has_one_attached :user_image
  has_many :messages
  has_and_belongs_to_many :conversations,
    association_foreign_key: "conversation_id",
    foreign_key: "user_id"
  def set_default_role
    self.role ||= :user
  end
end
