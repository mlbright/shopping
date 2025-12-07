class ShoppingList < ApplicationRecord
  belongs_to :household
  belongs_to :creator, class_name: "User"
  has_many :shopping_items, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true

  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_removal

  private

  def broadcast_update
    broadcast_replace_to(
      "shopping_list:#{id}",
      target: "shopping_list_#{id}_name",
      partial: "shopping_lists/name",
      locals: { shopping_list: self }
    )
  end

  def broadcast_removal
    broadcast_remove_to "shopping_list:#{id}", target: "shopping_list_#{id}"
  end
end
