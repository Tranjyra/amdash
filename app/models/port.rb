class Port < ApplicationRecord
  before_save :if_used_not_empty
  belongs_to :patch_panel
  has_one :zone, class_name: "Staff", foreign_key: :id, primary_key: :zone_id
  has_one :eq, class_name: "Staff", foreign_key: :id, primary_key: :eq_id

  private
  def if_used_not_empty
    if self.used
      self.empty = true
    end
  end
end
