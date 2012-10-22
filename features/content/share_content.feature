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
    When I post content to target
    Then it shows up on target wall