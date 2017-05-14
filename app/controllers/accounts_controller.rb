require 'json'

class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # モデルからrequestを参照できるようにする
  before_filter :set_request_filter
  def set_request_filter
    Thread.current[:request] = request
  end

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    # アカウント毎のjsonファイルに保存した商品データから商品情報を表示
    @order_lists = Account.find(params["id"]).order_list
    @site_name = Account.find(params["id"]).site.name

    # 表示する商品リスト
    file_path = "tmp/item_list/account_#{params["id"]}.json"
      if File.exist?(file_path)
        json_file = File.open(file_path).read
        @item_list = JSON.load(json_file)
      else
        @item_list = ""
      end

    # 処理が成功したかのメッセージ
    case session["item_list_result"]
    when 0 then # 成功
      session["item_list_result"] = ""
      flash.now[:notice] = '商品一覧を更新しました。'
    when 1 then # ログイン失敗
      session["item_list_result"] = ""
      flash.now[:error] = 'ログインを失敗しました。'
    end
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def item_list
    session["item_list_result"] = Account.find(params["id"]).item_list
    redirect_to :action => "show"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:user_id, :site_id, :code, :email, :password)
    end
end
