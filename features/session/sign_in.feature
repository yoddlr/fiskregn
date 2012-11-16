@session @user
Feature: Sign in

  As a user
  I want to be able to sign in to the site
  To interact with the content and users
  
  Scenario: Sign in
  
    Given I have an account 
    When I sign in with my_account
    Then I am signed in with my_account
