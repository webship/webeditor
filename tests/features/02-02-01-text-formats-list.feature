Feature: Text formats list page
  As an admin user
  I want to verify all expected text formats are listed
  So that authors can pick the right format on every body field

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Admin can open the text formats list
    When I navigate to "/admin/config/content/formats"
    Then I should see "Text formats and editors"
     And I should see "Full HTML"
     And I should see "Basic HTML"
     And I should see "Restricted HTML"
     And I should see "Plain text"
