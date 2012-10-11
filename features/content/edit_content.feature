@content
Feature: Edit content

  As a logged in user
  I want to be able to update content
  
  Scenario: Edit existing content
    Given I have an account
      And I have logged in
      And I have content
    When I update the content
    Then the content is updated