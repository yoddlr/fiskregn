@global @wall @locations
Feature: Global wall

  As a guest
  I want a list of locations
  In order to browse the site
  
  Scenario: List all locations
    Given there are user accounts
    When I visit the global wall
    Then I get a list of all locations
