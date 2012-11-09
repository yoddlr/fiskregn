@content @edit
Feature: Edit content

  As a signed in user
  I want to be able to update content
  
  Scenario: Edit existing content
    Given I have signed in with my account
      And I create content
    When I update the content
    Then the content is updated
