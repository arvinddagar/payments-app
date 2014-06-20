class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  helper_method :symbol_for_currency

  private
  def symbol_for_currency(currency)
    ABCD::CURRENCY_SYMBOLS.fetch(currency, "$")
  end
end
