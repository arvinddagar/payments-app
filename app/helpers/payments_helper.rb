module PaymentsHelper
  def payment_tier_data(currency)
    as_html_data(
      currency: symbol_for_currency(currency),
      low_min: 1,
      low_price: PricingTier.find_by_min_sessions(1).price_in(currency),
    )
  end

  def stripe_script_attrs(payment)
    cost = number_to_currency(payment.amount_in("USD"), locale: :en)
    description = "You will be charged #{cost}"

     as_html_data(
       key: ENV['STRIPE_PUBLISHABLE_KEY'],
       amount: (payment.amount_in("USD")*100).to_i.to_s,
       name: "Test Payments",
       description: description,
       image: image_path('stripe-checkout-icon.png'),
     ).merge(src: "https://checkout.stripe.com/v2/checkout.js",
             class: "stripe-button")
  end

  def prices_in_other_currencies(payment)
    ABCD::ENABLED_CURRENCIES.map do |currency|
      next if payment.currency == currency
      number_to_currency(payment.amount_in(currency), unit: symbol_for_currency(currency))
    end.compact
  end
end
