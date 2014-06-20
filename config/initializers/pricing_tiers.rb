connection = ActiveRecord::Base.connection

if connection.present? && connection.table_exists?(PricingTier.table_name)
  PricingTier.load_defaults
end
