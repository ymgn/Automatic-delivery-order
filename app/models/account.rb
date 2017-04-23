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
end
