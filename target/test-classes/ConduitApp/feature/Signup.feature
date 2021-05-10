@ignore
Feature: Testing the functionality of signup users

Background:
* url appUrl
* def dataGenerator = Java.type('helpers.DataGenerator')
* def timevalidator = read('classpath:helpers/time-validator.js')


Scenario:SignUp User
* def randomEmail = dataGenerator.getRandomEmail()
* def randomUserName = dataGenerator.getRandomUserName()

Given path 'users'
And request 
"""
   {
        "user":{
            "email":#(randomEmail),
            "password":"karate123456789",
            "username":#(randomUserName)
        }
}
""" 
When method post
Then status 200
And match response ==
"""
    {
    "user": {
        "id": "#number",
        "email": #(randomEmail),
        "createdAt": "#? timevalidator(_)",
        "updatedAt": "#? timevalidator(_)",
        "username": #(randomUserName),
        "bio": null,
        "image": null,
        "token": "#string"
       }
}
""" 


Scenario Outline:Validate error messages using signup

* def randomEmail = dataGenerator.getRandomEmail()
* def randomUserName = dataGenerator.getRandomUserName()
Given path 'users'
And request
"""
   {
        "user":{
            "email": <email>,
            "password": <password>,
            "username": <username>,
        }
   }
""" 
When method post
Then status 422
And match response == <ErrorMessage>

Examples:
    | email                | password        | username               | ErrorMessage                                                                                                                       |
    | karate456@abc.com    | karate123456789 | karate456              | {"errors": {"email": ["has already been taken"],"username": ["has already been taken"]}}                                         |
    | #(randomEmail)       | karate123456    | karate3                | {"errors": {"username": ["has already been taken"]}}                                                                               | 
    | karate456@abc.com    | karate123456    | #(randomUserName)      | {"errors": {"email": ["has already been taken"]}}                                                                                  |
    | karate456            | karate123456    | #(randomUserName)      | {"errors": {"email": ["is invalid"]}}                                                                                        |
    |                      | karate123456    | #(randomUserName)      | {"errors": {"email": ["can't be blank"]}}                                                                                          |
    | #(randomEmail)       |                 | #(randomUserName)      | {"errors": {"password": ["can't be blank"]}}                                                                                       |
    | #(randomEmail)       | karate123456    |                        | {"errors": {"username": ["can't be blank","is too short (minimum is 1 character)"]}}      |
    | #(randomEmail)       | karate123456    | karate7892383288282758 | {"errors": {"username": ["is too long (maximum is 20 characters)"]}}                                                               |
    | #(randomEmail)       | kara            | #(randomUserName)      | {"errors": {"password": ["is too short (minimum is 8 characters)"]}}                                                              |
    