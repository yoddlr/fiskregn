@content @reply
Feature: Reply to content

  As a signed in user
  I want to be able to reply to content

  Scenario: Reply to existing content
    Given I have signed in with my_account
      And There is content
    When I reply to content
    Then reply has parent content
