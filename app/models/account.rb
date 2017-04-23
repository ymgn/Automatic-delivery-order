require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

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
    email = self.email
    password = self.decrypt_password
    
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 20 })
    end

    page = Capybara::Session.new(:poltergeist)

    page.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
    }

    url = "https://www.ginsara.jp/"

    case self.site.code
      when "sushi" then
        page.visit url
        page.save_screenshot('screenshot1.png', :full => true)

        # ----ログイン処理-----
        p "================ログイン処理に入りました。==============="
        page.find(".header_nav-login").click

        mail_input = page.find("#mail")
        mail_input.native.send_key(email)
        mail_input = page.find("#password")
        mail_input.native.send_key(password)
        submit = page.find('#postLogin')
        submit.click
        # ------ログイン後--------
        # ここにログインできたか判定いれる
        if !page.has_css?("h4.h4-shop")
          p "======================ログイン失敗============================="
          return ""
        end
        # if page.has_css?("p.error")
        #   p "======================営業時間外============================="
        #   return "時間外"
        # end
        p "======================ログイン成功============================="
        page.save_screenshot('screenshot2.png', :full => true)
        page.find('.top-service-menu').click

      end
  end
end
