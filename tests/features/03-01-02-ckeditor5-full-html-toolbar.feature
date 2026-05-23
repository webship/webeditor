Feature: CKEditor 5 toolbar configuration for Full HTML
  As an admin user
  I want the Full HTML toolbar to ship with the rich editorial set
  So that editors get headings, links, media, alignment, tables and source editing

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Full HTML toolbar config exposes the curated buttons
    When I navigate to "/admin/config/content/formats/manage/full_html"
    Then I should see "Toolbar"
     And the active CKEditor 5 toolbar should contain "Bold"
     And the active CKEditor 5 toolbar should contain "Italic"
     And the active CKEditor 5 toolbar should contain "Heading"
     And the active CKEditor 5 toolbar should contain "Link"
     And the active CKEditor 5 toolbar should contain "Image"
     And the active CKEditor 5 toolbar should contain "Drupal media"
     And the active CKEditor 5 toolbar should contain "table"
     And the active CKEditor 5 toolbar should contain "Source"
