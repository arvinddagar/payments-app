class PaymentsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  include PaymentsHelper

  def index
    @payments = current_user.payments.charged
  end

  def new
    @payment = Payment.new_default(currency: 'USD')
  end

  def create
    @payment          = Payment.new(new_payment_params)
    @payment.currency = 'USD'
    @payment.user     = current_user
    @payment.save!
    redirect_to @payment
  end

  def show
    @payment = current_user.payments.find(params[:id])

    redirect_to new_payment_url if @payment.charged?
  end

  def update
    @payment = current_user.payments.find(params[:id])

    payment_method = params[:payment] && params[:payment][:payment_method]

    if !@payment.charged? && payment_method.present?
      @payment.update_attribute(:payment_method, payment_method)
    end

    if not @payment.charged?
      if @payment.paypal?
        process_paypal_payment
      elsif @payment.stripe?
        process_stripe_payment
      end
    else
      redirect_to new_payment_url
    end
  end

  def paypal_success
    @payment                 = current_user.payments.find(params[:id])
    @payment.paypal_token    = params[:token]
    @payment.paypal_payer_id = params[:PayerID]
    @payment.save!

    redirect_to @payment
  end

  def paypal_cancel
    redirect_to new_payment_url, alert: I18n.t('payments.paypal.payment-cancel')
  end


  private
  def new_payment_params
    params.require(:payment).permit(:sessions_count)
  end

  def successful_payment_flash
    {
      notice: I18n.t("payments.#{@payment.payment_method}.payment-succeeded.title"),
      flash: {
        body: I18n.t("payments.#{@payment.payment_method}.payment-succeeded.body",
                     amount: number_to_currency(@payment.amount, unit: symbol_for_currency(@payment.currency)),
                     sessions_count: current_user.reload.sessions_count)
      }
    }
  end

  def process_paypal_payment
    if !@payment.charged? && @payment.paypal_payer_id.blank?
      @payment.request_paypal_url(
        paypal_success_payment_url(@payment),
        paypal_cancel_payment_url(@payment)
      )

      redirect_to @payment.paypal_url
    elsif @payment.valid_paypal_payment?
      @payment.charge
      redirect_to new_payment_url, successful_payment_flash
    else
      redirect_to @payment
    end
  end

  def process_stripe_payment
    @payment.update_column(:stripe_token, params[:stripeToken])

    if !@payment.charged? && @payment.stripe_token.present? && @payment.charge
      redirect_to new_payment_url, successful_payment_flash
    else
      redirect_to @payment, alert: I18n.t('payments.stripe.payment-error')
    end
  end

end
