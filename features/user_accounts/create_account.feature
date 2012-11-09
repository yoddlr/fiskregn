@user
Feature: Create user account

  As a user
  I want to create a user account
  In order to have personalized settings, feeds and shares.
  
  Scenario: A new user account
    Given I have no account
    When I sign up
    Then a new personal account is created
