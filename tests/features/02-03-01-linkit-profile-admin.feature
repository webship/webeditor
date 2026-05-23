Feature: Linkit profile admin pages
  As an admin user
  I want the Default Linkit profile to be available
  So that the in-editor link autocomplete suggests internal entities

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Admin can open the Linkit profiles list
    When I navigate to "/admin/config/content/linkit"
    Then I should see "Linkit profiles"
     And I should see "Default"

  Scenario: Admin can open the Default Linkit profile edit page
    When I navigate to "/admin/config/content/linkit/manage/default"
    Then I should see "Default"
     And I should see the button "Update profile"

  Scenario: Admin can open the Default Linkit profile matchers tab
    When I navigate to "/admin/config/content/linkit/manage/default/matchers"
    Then I should see "Matchers"
     And I should see "User"
     And I should see "File"
     And I should see "Media"
     And I should see "Email"
     And I should see "External"
     And I should see "Front page"
