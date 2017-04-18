class Account < ApplicationRecord
  has_many :order_list
  belong_to :user
  belong_to :site
end
