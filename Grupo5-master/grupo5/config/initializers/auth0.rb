Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    Rails.application.secrets.auth0_client_id,
    Rails.application.secrets.auth0_client_secret,
    Rails.application.secrets.auth0_domain,
    callback_path: "/auth/oauth2/callback",
    authorize_params: {
      scope: 'openid profile user_metadata app_metadata',
      audience: 'https://arquisoft201720-wrravelo.auth0.com/userinfo'
    }
  )
end
