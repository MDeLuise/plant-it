Feature: Authentication related integration tests

  Scenario: User signup correctly
    When a user signup with username "user", password "user000", email "foo@bar.com"
    Then response is ok


  Scenario: User signup with invalid password
    When a user signup with username "user", password "1234", email "foo@bar.com"
    Then response is not ok


  Scenario: User signup with invalid email
    When a user signup with username "user", password "user000", email "foo"
    Then response is not ok


  Scenario: User signup with invalid username
    When a user signup with username "u", password "user000", email "foo@bar.com"
    Then response is not ok


  Scenario: User signup with an already taken username
    When a user signup with username "user", password "user000", email "foo@bar.com"
    Then response is not ok
    And response message contains "Error: Username is already taken!"


  Scenario: User signup with an already taken email
    When a user signup with username "user1", password "user000", email "foo@bar.com"
    Then response is not ok
    And response message contains "Error: Email is already used!"
