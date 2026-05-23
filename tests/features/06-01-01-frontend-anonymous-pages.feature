Feature: Editor module does not break front-end anonymous pages
  As an anonymous visitor
  I want the standard public pages to keep responding 200
  So that enabling Web Editor never regresses the front-end

  Scenario: Front page is reachable
    Given I am an anonymous user
    Then the response status of "/" should be 200

  Scenario: User login page is reachable
    Given I am an anonymous user
    Then the response status of "/user/login" should be 200
