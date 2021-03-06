class ChargesController < ApplicationController
  def new
    @amount = (params[:amount].to_i * 100)
    @goal = Goal.find(params[:goal])
  end

  def button
  end

  def create
    @amount = 500

    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
      )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount:   @amount,
      description: "Rails Stripe customer",
      currency: "usd"
      )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
