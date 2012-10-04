Feature: Update account information

  As a user
  I want to be able to edit my personal data
  In order to keep my account up to date
  
  Scenario Outline: Edit information
  
    Given I have an account
      And I am logged in
    When I edit my <info>
      And authenticate with my password
    Then my <info> is updated
    
    Examples:
    | info |
    | password |