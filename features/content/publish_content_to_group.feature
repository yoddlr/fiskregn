@groups @content @publish @pending
Feature: Publish content

  Background:
    Given I have signed in with my_account
    And I am a member of my_group

  Scenario: I can publish content to groups I am member of
    Given I have content
    And I publish my_text_content to my_group
    And I visit the content listing of my_group
    Then I can see my_text_content on the groups content listing

