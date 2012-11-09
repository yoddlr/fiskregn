@content @create
Feature: Create content

  Background:
    Given I have signed in with my account
      And I create content
    
  Scenario: New content has no tags
    When I visit the content page
    Then the content has no tags
  
  Scenario: New content has no read access
    When I visit the content page
    Then the content has no read accessors
    
  Scenario: New content has no find access
    When I visit the content page
    Then the content has no find accessors
  
  Scenario: New content 
    When I visit my location
    Then I don't see my new content
    
  @unpublished
  Scenario: New content appers in unpublished
    When I visit my unpublished content
    Then I see my new content
