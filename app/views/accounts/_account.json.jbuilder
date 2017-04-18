json.extract! account, :id, :user_id, :site_id, :mail, :password_digest, :created_at, :updated_at
json.url account_url(account, format: :json)
