@content @share
Feature: Share content

  As a user
  I want to share content
  So that users can find it on the site
  
  Scenario: Share content to my wall
    Given I have an account
      And I have signed in
    When I share content
    Then it shows up on my wall

  Scenario: Share content to target wall
    Given There is content
      And I have an account
      And I have signed in
    When I publish content to target
    Then it shows up on target wall

  Scenario: Withdraw content from target wall
    Given I have an account
      And I have signed in
      And I publish content to target
     When I withdraw content from target
     Then it does not show up on target wall