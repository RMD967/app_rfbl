class UserDashboard < ApplicationRecord
  belongs_to :user
  belongs_to :dashboard
end
