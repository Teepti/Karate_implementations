Feature:Add likes

Background:
   Given url appUrl

Scenario:Add likes
Given path 'articles',slug,'favorite'
And request {}
When method post
Then status 200
* def likesCount = response.article.favoritesCount
Then print likesCount   