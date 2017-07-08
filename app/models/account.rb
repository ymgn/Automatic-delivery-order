require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'json'

class Account < ApplicationRecord
  has_many :order_list
  belongs_to :user
  belongs_to :site

  before_save :encrypt_password

  # いずれ適切な位置に移動させる
  SECURE = '6ZEMlruVq1u20bBab6LkFznJfTNgTIqOWUo7lv6zs2uavtKX1u'
  CIPHER = 'aes-256-cbc'

  def encrypt_password
    self.password = encrypt(self.password)
  end

  def decrypt_password
    password = decrypt(self.password)
  end

  # 暗号化
  def encrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.encrypt_and_sign(password)
  end

  # 復号化
  def decrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.decrypt_and_verify(password)
  end

  # 商品リストを取得する
  def item_list
    print "============商品リスト取得開始========="
    # ログイン用のデータ取得
    email = self.email
    password = self.decrypt_password

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 150 })
    end

    page = Capybara::Session.new(:poltergeist)

    page.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
    }

    url = self.site.url

    case self.site.code
      when "sushi" then
        page.visit url
        page.save_screenshot('screenshot1.png', :full => true)

        # ----ログイン処理-----
        p "================ログイン処理に入りました。==============="
        login_button = page.find(".header_nav-login")
        login_button.click
        mail_input = page.find("#mail")
        mail_input.native.send_key(email)
        mail_input = page.find("#password")
        mail_input.native.send_key(password)
        submit = page.find('#postLogin')
        submit.click
        # ログインができたかどうか判定
        if !page.has_css?("h4.h4-shop")
          p "======================ログイン失敗============================="
          page.save_screenshot('screenshot2.png', :full => true)
          page.driver.quit
          return 1
        end
        # ------ログイン後--------
        # if page.has_css?("p.error")
        #   p "======================営業時間外============================="
        #   return "時間外"
        # end
        p "======================ログイン成功============================="
        page.find('.top-service-menu').click
        page.find(:xpath, "//div[@class='menu_nav-btn']/a[@href='/menu/category_CO000/']").click
        page.save_screenshot('screenshot3.png', :full => true)
        p "======================桶一覧に移動============================="
        item_list = {}
        # Nokogiriでhtmlを解析してObjectに
        doc = Nokogiri::HTML.parse(page.html)
        menulist = doc.xpath('//ul[@class="menulist cols-1of2"]')
        menulist.css("li").each do |menu|
          item = {}
          li_name = menu.xpath('p[@class="menulist_pdct"]').text
          item["name"]        = /\W/.match(li_name).post_match
          item["img"]         = menu.xpath('div/div/a/img')[0][:src]
          item["info"]        = menu.xpath('div/div/div/p[@class="menuinfo_price-text"]').text
          item["price"]       = menu.xpath('div/div/div/p[@class="menuinfo_price-price"]').text
          item["description"] = menu.xpath('div/p').text
          item_list[li_name[/\w+/]] = item
        end
        File.open("tmp/item_list/account_#{self.id}.json","w") do |file|
          JSON.dump(item_list,file)
        end
      end
      page.driver.quit
      return 0
  end
end
