SpreeStripe
===========

spree_stripe add stripe payment method to spree commerce. It is designed to be used on our ecommerce http://www.adiastyle.com . For more detail about stripe payment gateway, go to http://www.stripe.com.

If you are using an old version of Active Merchant, you made need it to use the system CA Cert file instead of the file that comes bundled w/ the gem.  You can place the following code in an initializer to acheive this:

````rb
module ActiveMerchant
  Connection.class_eval do
    private
    def configure_ssl(http)
      return unless endpoint.scheme == "https"

      http.use_ssl = true
      
      if verify_peer
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        # Use system defult Root CA file
        # http.ca_file     = File.dirname(__FILE__) + '/../../certs/cacert.pem'
      else               
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end
    
  end
end
````


Install
=======

Install spree_stripe by adding the following to your existing spree site's Gemfile:

	gem 'spree_stripe', :git=>"git://github.com/rietta/spree-stripe.git"

Then run:

	bundle install

And reboot your server:

	rails s

Go to admin interface

Go to Payment Methods

Select "New Payment Method"

Put Stripe Test Secret key in Login for testing, put Live Secret key in Login for production

Demo Site
=========

http://www.adiastyle.com

Copyright (c) 2011 Adiastyle.com, released under the New BSD License
