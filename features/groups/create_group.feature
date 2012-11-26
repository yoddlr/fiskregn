@groups @create @pending
Feature: Create group

  Background:
    Given I have signed in with my_account
    And I create the group my_admin_group

  Scenario: I am administrator of the group I created
    Given I visit the administrator page for my_admin_group
    Then I can edit the group settings

  Scenario: New group is shown in my list of groups
    When I visit my group listing
    Then I see the group my_admin_group

  Scenario: Group member listing lists members
    When I visit my_admin_group member listing
    Then I see all the members of my_admin_group

