class Spree::Gateway::Stripe < Gateway
  def provider_class
    ActiveMerchant::Billing::StripeGateway
  end

  def provider
    ActiveMerchant::Billing::Base.gateway_mode = options[:server].to_sym
    @provider ||= provider_class.new(login:ENV['STRIPE_API_SECRET_KEY'])
  end

  def url(path = '')
    url = 'https://dashboard.stripe.com/'
    url << 'test/' if preferred_test_mode
    url << path
  end

  def payment_profiles_supported?
    true
  end

  def purchase(money, creditcard, gateway_options)
    user = gateway_options.delete(:user)

    create_or_update_profile(creditcard, user) if creditcard.number.present?

    gateway_options[:customer] = user.stripe_profile_id

    provider.purchase(money, nil, gateway_options)
  end

  def authorize(money, creditcard, gateway_options)
    raise "The spree-stripe gem does not currently support separate auth and capture. Either update the gem if you need this functionality or set Spree::Config[:auto_capture] to true"
  end

  def capture(authorization, creditcard, gateway_options)
    raise "The spree-stripe gem does not currently support separate auth and capture. Either update the gem if you need this functionality or set Spree::Config[:auto_capture] to true"
  end

  def credit(money, creditcard, response_code, gateway_options)
    provider.credit(money, response_code, {})
  end

  def void(response_code, gateway_options)
    provider.void(response_code, {})
  end

  # This will update a customer if the user already has a Stripe profile ID stored in the DB
  def create_or_update_profile(creditcard, user)
    gateway_options = user.gateway_options
    
    gateway_options[:metadata] ||= {}
    gateway_options[:metadata]['Name on Card'] = creditcard.name
    gateway_options[:billing_address] = { zip: creditcard.zipcode }

    response = provider.store(creditcard, gateway_options)
    if response.success?
      sources = response.params['sources'].try(:[],'data') || []
      creditcard.update_from_gateway_response!(response.params['id'], sources, user)
    else
      creditcard.gateway_error(response)
    end
  end
end