@parallel=false
@ignore
Feature: Test articles page

Background: Generate a token
    Given url appUrl
    * def articleRequestBody = read('classpath:ConduitApp/Json/newArticleRequest.json')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article = dataGenerator.getRandomArticleValues()
    # * set articleRequestBody.article.title = dataGenerator.title
    # * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    # * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

Scenario:Create an article
Given path 'articles'
And request articleRequestBody
When method post
Then status 200    

Scenario: Create and delete an article
Given path 'articles'
And request articleRequestBody
When method post
Then status 200
* def slug = response.article.slug

Given path 'articles'
Given params { limit:10, offset:0}
When method Get
Then status 200
And match response.articles[0].title contains articleRequestBody.article.title

Given path 'articles/',slug
When method delete
Then status 200

Given path 'articles'
Given params { limit:10, offset:0}
When method Get
Then status 200
And match response.articles[0].title !contains articleRequestBody.article.title




