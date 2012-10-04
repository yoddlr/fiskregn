@session
Feature: Log out

  As a user
  I want to be able to log in to the site
  To interact with the content and users
  
  Scenario: Log out
  
    Given I have an account
      And I have logged in
    When I log out
    Then I am no longer logged in