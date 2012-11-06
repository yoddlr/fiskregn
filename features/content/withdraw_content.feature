  Scenario: Withdraw content from target wall
    Given I have an account
      And I have signed in
      And I publish content to target
     When I withdraw content from target
     Then it does not show up on target wall