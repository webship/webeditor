@curated-toolbar
Feature: CKEditor 5 toolbar configuration for Basic HTML
  As an admin user
  I want the Basic HTML toolbar to ship with a sensible default set
  So that authors get bold, italic, underline, lists, alignment and quotes

  The module sets this toolbar when it is installed on its own. A site
  template that sets the text formats itself (a Webship site) keeps its own
  Basic HTML toolbar, so a run there leaves the feature out.

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Basic HTML toolbar config exposes the curated buttons
    When I navigate to "/admin/config/content/formats/manage/basic_html"
    Then I should see "Toolbar"
     And the active rich text editor toolbar should contain "Bold"
     And the active rich text editor toolbar should contain "Italic"
     And the active rich text editor toolbar should contain "Underline"
     And the active rich text editor toolbar should contain "Bulleted list"
     And the active rich text editor toolbar should contain "Numbered list"
     And the active rich text editor toolbar should contain "Block quote"
