@content @share
Feature: Publish content

  As a user
  I want to publish content
  So that users can find it on a specific location
  
  Background:
    Given I have an account
      And I have signed in
  
  Scenarios: Share content to location
    When I share content to <location>
    Then it shows up on <location>
    
    Examples:
    | location  | path              |
    | home      | home_path         |
    | global    | global_wall_path  |
