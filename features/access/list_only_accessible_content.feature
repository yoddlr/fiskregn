@access
Feature: Only accessible content appears in lists

  As a user.
  I only get to list content that I have access to
  
  Scenario: list only accessible content
    Given a collection of content
      And the collection contains items I can access
      And the collection contains items I can't access
    When I list the contents of the collection
    Then only the items I can access is shown