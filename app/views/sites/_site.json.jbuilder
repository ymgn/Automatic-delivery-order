json.extract! site, :id, :site_id, :site_name, :url, :created_at, :updated_at
json.url site_url(site, format: :json)
