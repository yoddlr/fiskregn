@global
Feature: Global wall

  As a guest
  I want a list of users and content
  In order to browse the site
  
  Scenario: List all users
    Given there are user accounts
    When I visit the global wall
    Then I get a list of all users
