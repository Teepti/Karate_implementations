Feature:Create a Token

Scenario:Generate a Token
Given url 'https://conduit.productionready.io/api/users/login'
And request {"user": {"email": "#(userEmail)","password": "#(userPassword)" }}
When method post
Then status 200
* def authToken = response.user.token