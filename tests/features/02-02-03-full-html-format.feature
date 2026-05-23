Feature: Full HTML text format with CKEditor 5
  As an admin user
  I want the Full HTML format to be configured with CKEditor 5, Linkit and Media
  So that editors get a full WYSIWYG with images, tables and source editing

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Admin can open the Full HTML format settings
    When I navigate to "/admin/config/content/formats/manage/full_html"
    Then I should see "Full HTML"
     And I should see "Text editor"
     And I should see "CKEditor 5"
     And I should see "Enabled filters"
     And I should see the button "Save configuration"

  Scenario: Full HTML keeps Linkit and Token Filter enabled
    When I navigate to "/admin/config/content/formats/manage/full_html"
    Then I should see a "Linkit URL converter" checkbox checked
     And I should see a "Replaces global and entity tokens with their values" checkbox checked
