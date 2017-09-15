module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authorized?, except: [:init, :consume]
  end

  def authorized?
    redirect_to '/saml/init' if session[:userid].nil?
  end
end
