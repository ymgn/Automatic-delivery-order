class Account < ApplicationRecord
  has_many :order_list
  belongs_to :user
  belongs_to :site
  has_secure_password
end
