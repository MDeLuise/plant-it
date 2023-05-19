Feature: Test the correct interchange of information between the components.

#  Scenario: Create a user, subscribe to a channel, and then retrieve all the video.
#    Given the following users
#      | id | username | password  |
#      | 1  | newUser1 | password1 |
#    And the following channelVideo
#      | channel id               | channel name   | video id | video title | published at | thumbnail link | view |
#      | UCSuHzQ3GrHSzoBbwrIq3LLA | channelNameFoo | 42a24    | title       |              | http://foo.com | 42   |
#    And the authenticated user with username "newUser1" and password "password1"
#    And the subscription to channel with id "UCSuHzQ3GrHSzoBbwrIq3LLA"
#    And wait the scraping
#    Then the count of video is 1
#    And cleanup the environment
#
#  Scenario: Create a two users, subscribe to a channel with one user, login with other user and then retrieve all the video.
#    Given the following users
#      | id | username | password  |
#      | 1  | newUser1 | password1 |
#      | 2  | newUser2 | password2 |
#    And the following channelVideo
#      | channel id               | channel name   | video id | video title | published at | thumbnail link | view |
#      | UCSuHzQ3GrHSzoBbwrIq3LLA | channelNameFoo | 42a24    | title       |              | http://foo.com | 42   |
#    And the authenticated user with username "newUser1" and password "password1"
#    And the subscription to channel with id "UCSuHzQ3GrHSzoBbwrIq3LLA"
#    And wait the scraping
#    And the authenticated user with username "newUser2" and password "password2"
#    Then the count of video is 0
#    And cleanup the environment