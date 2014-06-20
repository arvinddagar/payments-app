class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.decimal  'amount',           precision: 19, scale: 2,                 null: false
      t.boolean  'charged',                                   default: false, null: false
      t.integer  'sessions_count',                            default: 1,     null: false
      t.integer  'user_id',                                   default: 0,     null: false
      t.string   'paypal_payer_id'
      t.string   'paypal_token'
      t.string   'payment_method'
      t.string   'stripe_token'
      t.string   'stripe_charge_id'
      t.string   'currency',                                  default: 'USD', null: false
      t.timestamps
    end
  end
end