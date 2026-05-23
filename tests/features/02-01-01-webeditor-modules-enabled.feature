Feature: Web Editor bundled modules are enabled
  As an admin user
  I want to verify that the Web Editor recipe enables every editor module
  So that I know the recipe ran cleanly during install

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Modules report status page lists Web Editor as enabled
    When I navigate to "/admin/modules"
    Then I should see "Web Editor"
     And I should see "CKEditor 5"
     And I should see "Text Editor"
     And I should see "Filter"
     And I should see "Media"
     And I should see "Linkit"
     And I should see "External Links"
     And I should see "Editor Advanced link"
     And I should see "Token Filter"
