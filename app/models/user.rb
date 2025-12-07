class User < ApplicationRecord
  has_secure_password

  has_many :household_memberships, dependent: :destroy
  has_many :households, through: :household_memberships
  has_many :created_households, class_name: "Household", foreign_key: :creator_id, dependent: :destroy
  has_many :created_lists, class_name: "ShoppingList", foreign_key: :creator_id, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :create_personal_household

  private

  def create_personal_household
    created_households.create!(name: "Personal")
  end
end
