@session
Feature: Sign out

  As a user
  I want to be able to sign in to the site
  To interact with the content and users
  
  Scenario: Sign out
  
    Given I have an account
      And I have signed in
    When I sign out
    Then I am not signed in