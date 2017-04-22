# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new
user.email = "user@example.com"
user.login_id = "user1"
user.password = "hogehoge"
user.password_confirmation = "hogehoge"
user.save!

site = Site.new
site.site_id = "sushi"
site.site_name = "銀のさら"
site.url = "https://www.ginsara.jp/"
site.save!

account = Account.new
account.user_id = 1
account.site_id = 1
account.mail = "user1@example.com"
account.password = "hogehoge"
account.save!

order_list = OrderList.new
order_list.account_id = 1
order_list.order_token = "hogehoge"
order_list.sort_num = 1
order_list.name = "まぐろづくし"
order_list.save!

order = Order.new
order.order_list_id = 1
order.item_id = 1
order.item_num = 5
order.save!