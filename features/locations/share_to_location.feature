@location @content @pending
Feature: Share to location

  As a logged in user
  I want to share content
  To a specific location
  
  Scenario: Share to a users wall
    Given I have signed in with my_account
    And I have content
    When I publish content to target
    Then it shows up on target wall
