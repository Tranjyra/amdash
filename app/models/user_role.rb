class UserRole < ApplicationRecord
  enum user_role: {Admin: 1, User: 2}
end
