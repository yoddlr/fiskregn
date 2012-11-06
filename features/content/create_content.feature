@content
Feature: Create content

  Background:
    Given I have an account
      And I am signed in
      And I create new content

  # Scenario: Create content
  #   Then I am owner of the content
    
  Scenario: New content has no tags
    When I visit the content page
    Then the content has no tags
  
  Scenario: New content has no access
    When a guest tries to visit the content page
    Then the guest don't see the content
  
  Scenario: New content has no location
    When I visit my location
    Then I don't see the content
    
  Scenario: New content appers in unpublished
    When I visit my unpublished content
    Then I see the content