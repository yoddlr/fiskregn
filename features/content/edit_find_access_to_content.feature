@content @access @edit
Feature: Set find access rights

  As a User
  I want to be able to control who gets to see my content

  Scenario: Grant find access to specific user on selected content
    Given I have signed in with my_account
      And I have content
    When I grant find access to a user
    Then that user appears in the find access list

  Scenario: Revoke find access to specific user on selected content
    Given I have signed in with my_account
    And I have content
    When I revoke find access to a user
    Then that user does not appear in the find access list

