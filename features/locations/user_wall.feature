@wall @users @locations
Feature: User wall

  A collection of the users content
  
  Scenario: Show users wall
    Given other user's account
      And the other user have text content
    When I visit the other user's wall
    Then I see the other user's content
