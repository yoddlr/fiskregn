@content @location
Feature: Withdraw content from location


  Scenario: Withdraw content from target wall
    Given I have signed in with my_account
      And I publish content to target
     When I withdraw content from target
     Then it does not show up on target wall
