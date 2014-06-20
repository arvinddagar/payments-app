class PricingTier < ActiveRecord::Base
  validates :default_sessions,
    :min_sessions,
    :max_sessions,
    :usd_price,
    presence: true, numericality: { greater_than: 0 }

  def self.load_defaults
    defaults = [
      OpenStruct.new(
        sessions_range: 1..29,
        sessions_count: 1,
        price_per_session: BigDecimal.new('1')
      ),
    ]

    defaults.each do |tier|
      find_or_create_by!(
        default_sessions: tier.sessions_count,
        min_sessions: tier.sessions_range.first,
        max_sessions: tier.sessions_range.last,
        usd_price: tier.price_per_session
      )
    end
  end

  def range
    (min_sessions..max_sessions)
  end

  def package_cost(currency='USD')
    default_sessions * price_in(currency)
  end

  def price_per_hour(currency='USD')
    price_in(currency) * TutoringSession::SESSIONS_IN_AN_HOUR
  end

  def price_per_session(currency='USD')
    price_in(currency)
  end

  def name
    case default_sessions
    when 4
      'dabble'
    when 32
      'flex'
    when 200
      'immerse'
    end
  end

  def type
    case default_sessions
    when 4
      'low'
    when 32
      'medium'
    when 200
      'high'
    end
  end

  def featured?
    name == 'flex'
  end

  def most_popular?
    name == 'flex'
  end

  def priced_in?(currency)
    price_for(currency).present?
  end

  def price_in(currency)
    if priced_in?(currency)
      price_for(currency)
    else
      usd_price
    end
  end

  private
  def price_for(currency)
    method_name = :"#{currency.to_s.downcase}_price"
    self.respond_to?(method_name) && send(method_name)
  end
end
