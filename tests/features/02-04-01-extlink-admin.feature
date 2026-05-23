Feature: External Links (extlink) admin pages
  As an admin user
  I want to configure External Links behavior
  So that external anchors get the right icon and target attributes

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: Admin can open the External Links settings page
    When I navigate to "/admin/config/user-interface/extlink"
    Then I should see "External links"
     And I should see the button "Save configuration"
