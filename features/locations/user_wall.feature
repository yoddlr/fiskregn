@wall @users @locations
Feature: User wall

  A collection of the user's content
  
  Scenario: Show user's wall
    Given other user's account
      And the other user has text content
    When I visit the other user's wall
    Then I see the other user's content
