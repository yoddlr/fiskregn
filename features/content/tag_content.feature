@content @tag
Feature: Tag content

  As a signed in user
  I want to be able to tag content

  Scenario: Tag existing content
    Given I have an account
      And I have signed in
      And There is content
    When I tag the content
    Then the content has the tag