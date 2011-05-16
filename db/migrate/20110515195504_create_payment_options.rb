class CreatePaymentOptions < ActiveRecord::Migration
  def self.up
    create_table :payment_options do |t|
      t.string :option

      t.timestamps
    end
    [ "Check", "Credit card", "Purchase order" ].each do |option|
      entry = PaymentOption.new :option => option
      entry.save
    end
  end

  def self.down
    drop_table :payment_options
  end
end
