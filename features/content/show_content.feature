@content @show @pending
Feature: Show content

  As a user or visitor
  I want to see content
  And if the content has related content,
  I want to see the related content
  
  Scenario: Show content
    Given there is content
    When I visit the contents page
    Then I see the content
  
  Scenario: Show link to parent
    Given there is content
      And the content has a reply
    When I visit the page of the reply
    Then I see a link to the parent content
  
  Scenario: Show replies
    Given there is content
      And the content has a reply
    When I visit the contents page
    Then I also see the reply