Feature: Integration tests regards botanical info managements

  Scenario: Add a new species.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    When user adds new botanical info
      | synonyms          | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym1,synonym2 | family | genus | species | USER    |            |          |           |               |
    Then response is ok
    * cleanup the database


  Scenario: Add a new species and then another one with the same name, both with creator USER.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms          | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym1,synonym2 | family | genus | species | USER    |            |          |           |               |
    * response is ok
    When user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      |          |        |       | species | USER    |            |          |           |               |
    Then response is not ok
    * cleanup the database


  Scenario: Add a new species and a plant linked to it, then retrieve the species count.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      |          |        |       | foo     | USER    |            |          |           |               |
    * response is ok
    * using this plant info
      | startDate | personalName | endDate | state     | note | purchasedPrice | currencySymbol | seller | location |
      |           | plant1       |         | PURCHASED |      |                |                |        |          |
    When user adds new plant
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            |             | foo            |
    Then response is ok
    When user requests count of all botanical info
    Then response is "1"
    * cleanup the database


  Scenario: Create a new image and a new species, then link them.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms                | family | genus | species | creator | externalId | image_id | image_url | image_content                                                                                | image_content_type |
      | synonym,Synonym,synonym |        |       | foo     | TREFLE  |            |          |           | iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkAAIAAAoAAv/lxKUAAAAASUVORK5CYII= | image/jpg          |
    * response is ok
    * using this plant info
      | startDate | personalName | endDate | state     | note | purchasedPrice | currencySymbol | seller | location |
      |           | plant1       |         | PURCHASED |      |                |                |        |          |
    When user adds new plant
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            |             | foo            |
    Then response is ok
    When user requests count of all botanical info
    Then response is "1"
    When user requests count of all plants
    Then response is "1"
    * cleanup the database


  Scenario: Create a new image and a new species, then link them.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms                | family | genus | species | creator | externalId | image_id | image_url | image_content                                                                                | image_content_type |
      | synonym,Synonym,synonym |        |       | foo     | TREFLE  |            |          |           | iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkAAIAAAoAAv/lxKUAAAAASUVORK5CYII= | image/png          |
    * response is ok
    * there is 1 image in upload folder
    * using this plant info
      | startDate | personalName | endDate | state     | note | purchasedPrice | currencySymbol | seller | location |
      |           | plant1       |         | PURCHASED |      |                |                |        |          |
    When user adds new plant
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            |             | foo            |
    Then response is ok
    When user requests count of all botanical info
    Then response is "1"
    When user requests count of all plants
    Then response is "1"
    * cleanup the database


  Scenario: Create a new image and a new species, then link them, then remove the species.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms                | family | genus | species | creator | externalId | image_id | image_url | image_content                                                                                | image_content_type |
      | synonym,Synonym,synonym |        |       | foo     | TREFLE  |            |          |           | iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkAAIAAAoAAv/lxKUAAAAASUVORK5CYII= | image/jpeg         |
    * response is ok
    * using this plant info
      | startDate | personalName | endDate | state     | note | purchasedPrice | currencySymbol | seller | location |
      |           | plant1       |         | PURCHASED |      |                |                |        |          |
    * user adds new plant
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            |             | foo            |
    * response is ok
    * user requests count of all botanical info
    * response is "1"
    When user requests count of all plants
    Then response is "1"
    When user delete species "foo"
    Then response is ok
    * user requests count of all botanical info
    * response is "0"
    When user requests count of all plants
    Then response is "0"
    * there is 0 image in upload folder
    * cleanup the database

  Scenario: Add two species and a plant, then update the plant.
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms                | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym,Synonym,synonym |        |       | foo     | USER    |            |          |           |               |
    * response is ok
    * user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym  |        |       | bar     | USER    |            |          |           |               |
    * response is ok
    * using this plant info
      | startDate | personalName | endDate | state     | note | purchasedPrice | currencySymbol | seller | location |
      |           | plant1       |         | PURCHASED |      |                |                |        |          |
    * user adds new plant
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            |             | foo            |
    * response is ok
    * using this plant info
      | startDate  | personalName | endDate    | state | note        | purchasedPrice | currencySymbol | seller       | location |
      | 2000-01-01 | plant2       | 2001-01-01 | ALIVE | Lorem Ipsum | 42             | $              | Green Market | Garden   |
    When user updates plant "plant1"
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            | RANDOM      | bar            |
    Then response is ok
    * plant "plant2" has this info
      | startDate  | personalName | endDate    | state | note        | purchasedPrice | currencySymbol | seller       | location |
      | 2000-01-01 | plant2       | 2001-01-01 | ALIVE | Lorem Ipsum | 42             | $              | Green Market | Garden   |
    * plant "plant2" is
      | avatar_id | avatar_url | avatar_mode | botanical_info |
      |           |            | RANDOM      | bar            |
    When user requests count of all plants
    Then response is "1"
    When user requests count of all botanical info
    Then response is "1"
    * cleanup the database


  Scenario: Add same species
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym  |        |       | foo     | TREFLE  |            |          |           |               |
    * response is ok
    When user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      |          |        |       | foo     | TREFLE  |            |          |           |               |
    Then response is not ok
    When user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym  |        |       | foo     | USER    |            |          |           |               |
    Then response is ok
    When user adds new botanical info
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | synonym  |        |       | foo     | USER    |            |          |           |               |
    Then response is not ok
    * cleanup the database


  Scenario: Create a new custom species, then edit it
    Given a user signup with username "user", password "user000", email "foo@bar.com"
    * a user login with username "user" and password "user000"
    * using this species care
      | light | humidity | minTemp | maxTemp | phMax | phMin |
      | 1     | 2        | 3       | 4       | 5     | 6     |
    * user adds new botanical info
      | synonyms | family | genus | species | imageId | creator | externalId | image_id | image_url | image_content |
      | synonym  |        |       | foo     |         | USER    |            |          |           |               |
    * response is ok
    * species "foo" is
      | scientific_name | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content |
      | foo             | synonym  |        |       | foo     | USER    |            |          |           |               |
    * species "foo" has no image
    * species "foo" has this care
      | light | humidity | minTemp | maxTemp | phMax | phMin |
      | 1     | 2        | 3       | 4       | 5     | 6     |
    * using this species care
      | light | humidity | minTemp | maxTemp | phMax | phMin |
      | 6     | 5        |         |         | 2     | 1     |
    When user updates botanical info "foo"
      | synonyms | family | genus | species | creator | externalId | image_id | image_url      | image_content |
      | synonym1 | fam    | gen   | foo     | USER    |            |          | http://foo.com |               |
    Then response is ok
    * species "foo" is
      | scientific_name | synonyms | family | genus | species | creator | externalId |
      | foo             | synonym1 | fam    | gen   | foo     | USER    |            |
    * species "foo" has this image
      | image_id | image_url      | image_content |
      |          | http://foo.com |               |
    * species "foo" has this care
      | light | humidity | minTemp | maxTemp | phMax | phMin |
      | 6     | 5        |         |         | 2     | 1     |
    When user updates botanical info "foo"
      | synonyms | family | genus | species | creator | externalId | image_id | image_url | image_content_type | image_content                                                                                |
      |          |        |       | bar     | USER    |            |          |           | image/jpeg         | iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkAAIAAAoAAv/lxKUAAAAASUVORK5CYII= |
    Then response is ok
    * species "bar" is
      | scientific_name | synonyms | family | genus | species | creator | externalId |
      | bar             |          |        |       | bar     | USER    |            |
    * species "bar" has this image
      | image_id | image_url | image_content                                                                                |
      |          |           | iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkAAIAAAoAAv/lxKUAAAAASUVORK5CYII= |
    * species "bar" has this care
      | light | humidity | minTemp | maxTemp | phMax | phMin |
      | 6     | 5        |         |         | 2     | 1     |
    * cleanup the database
