Feature: CKEditor 5 toolbar configuration for Basic HTML
  As an admin user
  I want the Basic HTML toolbar to ship with a sensible default set
  So that authors get bold, italic, underline, lists, alignment and quotes

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Basic HTML toolbar config exposes the curated buttons
    When I navigate to "/admin/config/content/formats/manage/basic_html"
    Then I should see "Toolbar"
     And the active CKEditor 5 toolbar should contain "Bold"
     And the active CKEditor 5 toolbar should contain "Italic"
     And the active CKEditor 5 toolbar should contain "Underline"
     And the active CKEditor 5 toolbar should contain "Bulleted list"
     And the active CKEditor 5 toolbar should contain "Numbered list"
     And the active CKEditor 5 toolbar should contain "Block quote"
