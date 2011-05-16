class PaymentOption < ActiveRecord::Base
  belongs_to :orders
  
  def to_s
    option
  end
end
