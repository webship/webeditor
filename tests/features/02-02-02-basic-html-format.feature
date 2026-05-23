Feature: Basic HTML text format with CKEditor 5
  As an admin user
  I want the Basic HTML format to be configured with CKEditor 5 and Linkit
  So that authors get a safe, simple WYSIWYG out of the box

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Admin can open the Basic HTML format settings
    When I navigate to "/admin/config/content/formats/manage/basic_html"
    Then I should see "Basic HTML"
     And I should see "Text editor"
     And I should see "CKEditor 5"
     And I should see "Enabled filters"
     And I should see the button "Save configuration"

  Scenario: Basic HTML format keeps CKEditor 5 and the Linkit filter on
    When I navigate to "/admin/config/content/formats/manage/basic_html"
    Then I should see a "Linkit URL converter" checkbox checked
     And I should see a "Limit allowed HTML tags and correct faulty HTML" checkbox checked
