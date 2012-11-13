@content @access @edit
Feature: Set find access rights

  As a User
  I want to be able to controll who get's to see my content

  Scenario: Give find access to specific user on selected content
    Given I have signed in with my_account
      And I have content
    When I grant find access to a user
    Then that user appears in the find access list
