class SamlController < ApplicationController
  include Secured

  skip_before_action :verify_authenticity_token

  def init
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)

    # We validate the SAML Response and check if the user already exists in the system
    if response.is_valid?(true)
      # authorize_success, log the user
      session[:userid] = response.nameid
      session[:attributes] = response.attributes

      redirect_to root_path
    else
      # authorize_error
      render status: 403
    end
  end

  private

  def saml_settings
    idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    settings = idp_metadata_parser.parse_remote(idp_metadata)

    settings.assertion_consumer_service_url = "http://localhost:3000/saml/consume"
    settings.issuer                         = "http://localhost:3000"
    settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    settings.authn_context                  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

    settings
  end

  def idp_metadata
    'https://dev-359799.oktapreview.com/app/exkc0mvib8kNafaDJ0h7/sso/saml/metadata'
  end
end
