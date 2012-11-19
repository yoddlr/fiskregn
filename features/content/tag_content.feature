@content @tag
Feature: Tag content

  As a signed in user
  I want to be able to tag content

  Scenario: Tag existing content
    Given I have signed in with my_account
      And There is content
    When I tag my_text_content
    Then my_text_content has the tag
