function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    appUrl: 'https://conduit.productionready.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'karate123@abc.com'
    config.userPassword = 'karate123456789'
  } 
  if (env == 'qa') {
    config.userEmail = 'karate456@abc.com'
    config.userPassword = 'karate1234567'
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature',config).authToken;
  karate.configure('headers', {Authorization: 'Token '+ accessToken})
  
  return config;
}