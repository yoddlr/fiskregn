@content @delete
Feature: Delete content

  As a signed in user
  I want to be able to delete content
  
  Scenario: delete content
    Given I have signed in with my account
      And I have content
    When I delete the content
    Then the content is deleted
