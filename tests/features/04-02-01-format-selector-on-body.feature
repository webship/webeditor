Feature: Format selector exposes all installed formats on the Body field
  As an editor
  I want the format selector under the Body field to expose the right formats
  So that I can pick Full HTML, Basic HTML or Restricted HTML per content item

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Body field shows all installed text formats in the format selector
    When I navigate to "/node/add/page"
    Then the page should expose the text format "Full HTML"
     And the page should expose the text format "Basic HTML"
     And the page should expose the text format "Restricted HTML"
