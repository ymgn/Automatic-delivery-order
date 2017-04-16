require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

class DeliveryController < ApplicationController
  # DSLのスコープを分ける
  include Capybara::DSL

  def index

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 10 })
    end

    page = Capybara::Session.new(:poltergeist)

    page.driver.headers = {
        'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
    }

    url = "https://www.ginsara.jp/"

    case params[:site_code]
      when "sushi" then
        page.visit url
        page.save_screenshot('screenshot1.png', :full => true)

        # ----ログイン処理-----
        p "================ログイン処理に入りました。==============="
        page.find(".header_nav-login").click

        mail_input = page.find("#mail")
        mail_input.native.send_key("")
        mail_input = page.find("#password")
        mail_input.native.send_key("")
        submit = page.find('#postLogin')
        submit.click
        # ------ログイン後--------
        # ここにログインできたか判定いれる
        page.save_screenshot('screenshot2.png', :full => true)

      end
    render :text => "E N D"
  end
end