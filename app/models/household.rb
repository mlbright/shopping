class Household < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :household_memberships, dependent: :destroy
  has_many :users, through: :household_memberships
  has_many :shopping_lists, dependent: :destroy

  validates :name, presence: true
  
  after_create :add_creator_as_owner

  private

  def add_creator_as_owner
    household_memberships.find_or_create_by(user: creator) do |membership|
      membership.role = "owner"
    end
  end
end
