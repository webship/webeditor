Feature: Access control for Web Editor admin pages
  As a site administrator
  I want every Web Editor admin route to be protected
  So that only privileged users can change editor configuration

  Scenario: Anonymous user cannot reach the text formats list
    Given I am an anonymous user
    Then I should be denied access to "/admin/config/content/formats"

  Scenario: Anonymous user cannot reach the Basic HTML format editor
    Given I am an anonymous user
    Then I should be denied access to "/admin/config/content/formats/manage/basic_html"

  Scenario: Anonymous user cannot reach the Full HTML format editor
    Given I am an anonymous user
    Then I should be denied access to "/admin/config/content/formats/manage/full_html"

  Scenario: Anonymous user cannot reach the Linkit profiles list
    Given I am an anonymous user
    Then I should be denied access to "/admin/config/content/linkit"

  Scenario: Anonymous user cannot reach the External Links settings
    Given I am an anonymous user
    Then I should be denied access to "/admin/config/user-interface/extlink"

  Scenario: Authenticated user cannot reach the text formats list
    Given I am a logged in user with the "Authenticated user" user
    Then I should be denied access to "/admin/config/content/formats"
