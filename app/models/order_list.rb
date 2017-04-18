class OrderList < ApplicationRecord
  has_many :order
  belong_to :account
end
