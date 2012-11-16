@location @content @pending
Feature: Share to location

  As a logged in user
  I want to share content
  To a specific location
  
  Scenario: Share to a users wall
    Given I have signed in with my_account
    When I share content to a user's wall
    Then the content shows up on the user's wall
