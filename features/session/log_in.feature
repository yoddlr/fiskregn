@session
Feature: Log in

  As a user
  I want to be able to log in to the site
  To interact with the content and users
  
  Scenario: Log in
  
    Given I have an account
    When I log in
    Then I am logged in