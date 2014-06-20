Paypal.sandbox = !Rails.env.production?
Paypal::Express::Config = OpenStruct.new(
  username: ENV['PAYPAL_USERNAME'],
  password: ENV['PAYPAL_PASSWORD'],
  signature: ENV['PAYPAL_SIGNATURE']
)
