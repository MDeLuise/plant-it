Feature: Test the correct functionality of the authentication.

#  Scenario: call GET /subscription without authentication. Request should be denied.
#    When call GET "/subscription"
#    Then receive status code of 403
#
#  Scenario: call GET /subscription/0 without authentication. Request should be denied.
#    When call GET "/subscription/0"
#    Then receive status code of 403
#
#  Scenario: call POST /subscription without authentication. Request should be denied.
#    When call POST "/subscription" with body "{}"
#    Then receive status code of 403
#
#  Scenario: call PUT /subscription/0 without authentication. Request should be denied.
#    When call PUT "/subscription/0" with body "{}"
#    Then receive status code of 403
#
#  Scenario: call DELETE /subscription/0 without authentication. Request should be denied.
#    When call DELETE "/subscription/0" with body "{}"
#    Then receive status code of 403
#
#
#  Scenario: Login correctly.
#    Given the following users
#      | id | username | password |
#      | 1  | user1    | user1111 |
#    And login with username "user1" and password "user1111"
#    Then receive status code of 200
#
#  Scenario: Login denied with username correct and wrong password.
#    Given the following users
#      | id | username | password |
#      | 2  | user2    | user2222 |
#    And login with username "user2" and password "wrongPassword"
#    Then receive status code of 500
#
#  Scenario: Login denied with username and password wrong.
#    Given login with username "userDoesNotExist" and password "user"
#    Then receive status code of 500