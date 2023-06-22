class Registrator < ApplicationRecord
  belongs_to :job
  has_one :model, class_name: 'Staff', foreign_key: :id, primary_key: :model_id
end
