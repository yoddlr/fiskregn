@user @show
Feature: Show user account

  As a visitor
  I want to see a users profile
  In order to learn more about the user
  
  Scenario: Visit user profile
    Given other user's account
    When I visit the other user's profile page
    Then I see the other user's public information
