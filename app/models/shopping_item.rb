class ShoppingItem < ApplicationRecord
  belongs_to :shopping_list

  validates :name, presence: true
  validates :state, inclusion: { in: %w[active completed deferred] }
  
  before_create :set_position

  after_create_commit :broadcast_create
  after_update_commit :broadcast_update
  after_destroy_commit :broadcast_removal

  def completed?
    state == "completed"
  end

  def deferred?
    state == "deferred"
  end

  def active?
    state == "active"
  end

  private

  def set_position
    self.position ||= (shopping_list.shopping_items.maximum(:position) || 0) + 1
  end

  def broadcast_create
    broadcast_append_to(
      "shopping_list:#{shopping_list_id}",
      target: "shopping_items",
      partial: "shopping_items/item",
      locals: { item: self }
    )
  end

  def broadcast_update
    broadcast_replace_to(
      "shopping_list:#{shopping_list_id}",
      target: dom_id(self),
      partial: "shopping_items/item",
      locals: { item: self }
    )
  end

  def broadcast_removal
    broadcast_remove_to "shopping_list:#{shopping_list_id}", target: dom_id(self)
  end
end
