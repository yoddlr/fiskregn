@content
Feature: Delete content

  As a signed in user
  I want to be able to delete content
  
  Scenario: delete content
    Given I have an account
      And I have signed in
      And I have content
    When I delete the content
    Then the content is deleted
