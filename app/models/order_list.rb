class OrderList < ApplicationRecord
  has_many :order
  belongs_to :account
end
