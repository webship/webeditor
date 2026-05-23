Feature: Restricted HTML text format
  As an admin user
  I want the Restricted HTML format to keep only safe tags
  So that comment/anonymous content cannot inject markup

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Admin can open the Restricted HTML format settings
    When I navigate to "/admin/config/content/formats/manage/restricted_html"
    Then I should see "Restricted HTML"
     And I should see "Enabled filters"
     And I should see the button "Save configuration"

  Scenario: Restricted HTML keeps the HTML filter on
    When I navigate to "/admin/config/content/formats/manage/restricted_html"
    Then I should see a "Limit allowed HTML tags and correct faulty HTML" checkbox checked
