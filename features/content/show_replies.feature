@content @show-replies @pending
Feature: Show replies

  As a user or visitor
  I want to see content
  And if the content has related content,
  I want to see the related content
  
  Background:
    Given there is content
    And the content has reply <reply> with access <access>
    
    | reply     | access  |
    | groda     | read    |
    | troll     | nil     |
    | bengt     | nil     |
    
  
  Scenario: Show accessible replies
    Given I have access to the replies
    When I visit the contents page
    Then I also see the reply
    
  Scenario: Hide unaccessible replies
    Given I dont have access to the replies
    When I visit the contents page
    Then I dont see the reply
    
  Scenario: Replies with mixed accessibility
    When I visit the contents page
    Then I only see the replies I have access to
