@access
Feature: Visit unaccessible content via URL

  When someone uses a url to visit content.
  The content makes sure the user has access to the content before rendering the content.
  
  The first step in controlling access to content is to make sure no links are shown to content that is not accessible to specifi user.
  
  Scenario: Visiting a URL with unaccessible content.
  Given content I do not have access to
  When I visit the URL of the content
  Then I am redirected away from the content