class Photo < ApplicationRecord

  scope :filter_zone_id, ->(zone_id) {where(zone_id: zone_id)}
  scope :orderzoneeq, -> {order('zone_id asc','eq_id asc')}
  scope :ordercomment, -> {order('comment asc')}

  belongs_to :job
  has_one :zone, class_name: "Staff", foreign_key: :id, primary_key: :zone_id
  has_one :eq, class_name: "Staff", foreign_key: :id, primary_key: :eq_id
  has_one_attached :image
  validate :precense_image
  def precense_image
    if self.image.attached?
    else
      self.errors.add(:image, "Изображение должно быть добавлено")
    end
  end
end
