Feature: Show user account

  As a visitor
  I want to see a users profile
  In order to learn more about the user
  
  Scenario: Visit user profile
    Given a user account
    When I visit the users profile page
    Then I see the users public information