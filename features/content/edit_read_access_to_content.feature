@content @access @edit
Feature: Set read access rights

  As a User
  I want to be able to control who gets to see my content

  Scenario: Grant read access to specific user on selected content
    Given I have signed in with my_account
      And I have content
    When I grant read access to a user
   Then that user appears in the read access list

  Scenario: Revoke read access from specific user on selected content
    Given I have signed in with my_account
    And I have content
    When I revoke read access to a user
    Then that user does not appear in the read access list
