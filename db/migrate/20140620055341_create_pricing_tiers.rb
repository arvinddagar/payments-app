class CreatePricingTiers < ActiveRecord::Migration
  def change
    create_table :pricing_tiers do |t|
      t.integer  "min_sessions",                              null: false
      t.integer  "max_sessions",                              null: false
      t.integer  "default_sessions",                          null: false
      t.decimal  "usd_price",        precision: 19, scale: 2, null: false
      t.timestamps
    end
  end
end
