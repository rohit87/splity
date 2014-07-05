window.fbAsyncInit = ->
  Appacitive.Facebook.initialize {
    appId: '696266227100703', # Facebook App ID
    status: false,
    cookie: true,
    xfbml: true,
    version: 'v2.0'
  }
  # login_or_signup_via_facebook()

includeFacebook = (d, s, id) ->
  fjs = d.getElementsByTagName(s)[0]
  return if d.getElementById(id)
  js = d.createElement(s)
  js.id = id
  js.src = "//connect.facebook.net/en_US/sdk.js"
  fjs.parentNode.insertBefore(js, fjs);
includeFacebook document, 'script', 'facebook-jssdk'

login_or_signup_via_facebook = ->
  Appacitive.Facebook.requestLogin().then (fbResponse) ->
    log "Facebook login successfull with access token: #{Appacitive.Facebook.accessToken()}"
    Appacitive.User.loginWithFacebook Appacitive.Facebook.accessToken(), { create: true }

  .then (authResult) ->
      log 'successfully logged in'
    , (err) ->
      if (Appacitive.Facebook.accessToken())
        log 'error during facebook login'
      else
        log ' error signing up the user'