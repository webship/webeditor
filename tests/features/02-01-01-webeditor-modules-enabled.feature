Feature: Web Editor bundled modules are enabled
  As an admin user
  I want to verify that the Web Editor recipe enables every editor module
  So that I know the recipe ran cleanly during install

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Modules report status page lists Web Editor as enabled
    Then the "webeditor" module should be installed
     And the "ckeditor5" module should be installed
     And the "editor" module should be installed
     And the "filter" module should be installed
     And the "media" module should be installed
     And the "linkit" module should be installed
     And the "extlink" module should be installed
     And the "editor_advanced_link" module should be installed
     And the "token_filter" module should be installed
