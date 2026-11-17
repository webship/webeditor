Feature: Create a Basic page using the Full HTML editor
  As an authenticated editor user
  I want CKEditor 5 to load on the Body field of a new page
  So that I can author rich content end-to-end with the bundled editor

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: CKEditor 5 renders on the Basic page Body field
    When I navigate to "/node/add/page"
    Then I should see a "Title" field
     And I should see "Body"
     And the rich text editor should be visible
     And the rich text editor toolbar should be visible

  Scenario: Author can save a Basic page using the Full HTML format
    When I navigate to "/node/add/page"
     And I fill in "Title" with "Web Editor smoke test"
     And I type "Hello from Web Editor." into the active rich text editor
     And I save the content
    Then I should see "Basic page Web Editor smoke test has been created."
     And I should see "Hello from"
     And I should see "Web Editor"
    When I delete the content item I created
    Then I should see "has been deleted"
