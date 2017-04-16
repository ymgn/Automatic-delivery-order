class DeliveryController < ApplicationController
  def index
      render :text => "site_code"+params[:site_code]
  end
end