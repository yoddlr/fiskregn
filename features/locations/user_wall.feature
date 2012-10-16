@wall @users @locations
Feature: User wall

  A collection of the users content
  
  Scenario: Show users wall
    Given a user account
    When I visit the user's wall
    Then I see the user's content