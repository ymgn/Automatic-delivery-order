json.extract! order_list, :id, :account_id, :order_token, :sort_num, :created_at, :updated_at
json.url order_list_url(order_list, format: :json)
