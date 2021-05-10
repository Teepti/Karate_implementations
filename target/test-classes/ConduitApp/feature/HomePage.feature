
Feature:Test for the Home page

    Background:
       Given url appUrl
    @ignore
    Scenario:Get all the tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains [dragons,butt]
    And match response.tags !contains [test1,test2]
    And match response.tags contains any [dragons,test1, test2]
    And match each response.tags == '#string'



    @ignore
    Scenario: Get first 10 articles
    * def timevalidator = read('classpath:helpers/time-validator.js')
    Given path 'articles'
    Given params { limit:10, offset:0}
    When method Get
    Then status 200
    And match response == {"articles":"#[10]","articlesCount": 500}
    And match each response.articles ==
    """
    {
            "title": "#string",
            "slug": "#string",
            "body": "#string",
            "createdAt": "#? timevalidator(_)",
            "updatedAt": "#? timevalidator(_)",
            "tagList": '#array',
            "description": "#string",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": '#boolean'
            },
            "favorited": '#boolean',
            "favoritesCount": "#number"
        },
    """

@ignore
Scenario:Conditional logic
    Given path 'articles'
    Given params { limit:10, offset:0}
    When method Get
    Then status 200
    * def favourCount = response.articles[0].favoritesCount
    * def articles = response.articles[0]
    #* if (favourCount == 0) karate.call('classpath:helpers/AddLikes.feature',articles)
    * def result = favourCount == 0 ? karate.call('classpath:helpers/AddLikes.feature',articles).likesCount : favourCount

    Given path 'articles'
    Given params { limit:10, offset:0}
    When method Get
    Then status 200
    And match response.articles[0].favoritesCount == result


Scenario:Retry call
  * configure retry = {count:10, interval: 5000}
    Given path 'articles'
    Given params { limit:10, offset:0}
    And retry until response.articles[0].favoritesCount == 2
    When method Get
    Then status 200

@parallel=false
Scenario:Sleep call
  * def sleep = function(pause){ java.lang.Thread.sleep(pause) }
    Given path 'articles'
    Given params { limit:10, offset:0}
    * eval sleep(5000)
    When method Get
    Then status 200



    