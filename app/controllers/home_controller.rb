class HomeController < ApplicationController
  def index
    if user_signed_in?
      @account_data = {}
      current_user.account.each do |a|
        @account_data[a.site.name] = []  
      end
      current_user.account.each do |a|
        @account_data[a.site.name].append(a)  
      end
    end
  end
end
