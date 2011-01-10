module Tolk
  class ApplicationController < ActionController::Base
    helper :all
    protect_from_forgery

    cattr_accessor :authenticator
    before_filter :authenticate

    helper_method :authorized_for_locale?, :authorize_to_create_locale?

    def authenticate
      self.authenticator.bind(self).call if self.authenticator && self.authenticator.respond_to?(:call)
    end

    def ensure_no_primary_locale
      redirect_to tolk_locales_path if @locale.primary? || !authorized_for_locale?
    end

    def authorized_for_locale?(locale = @locale)
      current_translator.locales && (current_translator.locales.include?('all') || current_translator.locales.include?(locale.name.to_s))
    end

    def ensure_authorized_to_create_locale?
      redirect_to tolk_locales_path unless authorize_to_create_locale?
    end

    def authorize_to_create_locale?
      current_translator.locales && current_translator.locales.include?('all')
    end
  end
end
