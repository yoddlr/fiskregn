@content @show @pending
Feature: Show content

  As a user or visitor
  I want to see content
  And if the content has related content,
  I want to see the related content
  
  Background:
    Given there is content
  
  Scenario: Show content
    When I visit the contents page
    Then I see the content
    
  Scenario: Show content as reply
    Given the content is a reply
    When I visit the contents page
    Then I see a link to parent content