class Spree::Gateway::Stripe < Gateway
  preference :login, :string
  attr_accessible :preferred_login, :preferred_password, :name, :description, :environment, :display_on, :active

  # Make sure to have Spree::Config[:auto_capture] set to true.

  def provider_class
    ActiveMerchant::Billing::StripeGateway
  end

  def payment_profiles_supported?
    false
  end
end
