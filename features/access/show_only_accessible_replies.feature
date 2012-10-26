@access
Feature: Show only accessible replies

  As a user I want to control who get's to see my replies
  
  Scenario: Listing only accessible replies
    Given I am showing content
      And the content has replies I have access to
      And the content has replies I do not have access to
    When the replies are listed
    Then I only see the replies I have access to