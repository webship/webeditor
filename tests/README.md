# Web Editor tests

The behaviour tests of Web Editor: Gherkin features run by
[webship-js](https://www.npmjs.com/package/webship-js) (Playwright and Cucumber)
with the Drupal steps of
[@webship-js/drupal-core-steps](https://www.npmjs.com/package/@webship-js/drupal-core-steps)
(the login by account handle, access checks, content). `cucumber.js` in the
project root holds the configuration.

| Folder | What it holds |
| --- | --- |
| `features/` | the features (14 files, 28 scenarios) |
| `step-definitions/` | this project's own steps |
| `selectors/` | named selectors for the administration themes |
| `reports/`, `screenshots/`, `videos/` | what a run writes (not committed) |

## From nothing to a green run

### 1. A Webship site in DDEV

Web Editor comes with the Webship distribution. Build a site from the
[Webship project template](https://www.drupal.org/project/webship_project):

```bash
mkdir webship-site && cd webship-site
ddev config --project-type=drupal --docroot=web --database=mysql:8.0
ddev start
ddev composer create-project drupal/webship_project:12.0.x-dev
ddev restart
```

### 2. The site, with the test accounts

The suite logs in as the accounts that `cucumber.js` lists in
`worldParameters.users`, and never creates or deletes an account: the site
build does. Choose three passwords, keep them in your environment, install
the site with the Webmaster account and add the other two:

```bash
export DRUPAL_ADMIN_PASS='…' DRUPAL_EDITOR_PASS='…' DRUPAL_AUTHENTICATED_PASS='…'
ddev drush site:install webship --account-name=webmaster --account-mail=webmaster@example.test --account-pass="$DRUPAL_ADMIN_PASS" -y
ddev drush user:create content_editor_user --mail=content_editor_user@example.test --password="$DRUPAL_EDITOR_PASS"
ddev drush user:role:add content_editor content_editor_user
ddev drush user:create authenticated_user --mail=authenticated_user@example.test --password="$DRUPAL_AUTHENTICATED_PASS"
```

The editor scenarios use the Basic page content type, which the Webship
Starter site template does not have. Add it with the core recipe:

```bash
ddev drush recipe core/recipes/page_content_type -y
```

CI builds a smaller site the same way (the Standard profile and this module, the same accounts with
passwords made for the job): see the `webship-js-test` job in `.gitlab-ci.yml`.

### 3. Run the suite

From this project's folder, with Node.js 24 and Yarn 4 (through Corepack):

```bash
corepack enable
yarn install
npx playwright install chromium
export LAUNCH_URL=https://webship-site.ddev.site
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
export DRUPAL_LOGIN_WAIT=3000
yarn test --tags "not @wip and not @curated-toolbar"
```

`DRUPAL_LOGIN_WAIT` is for the login form of the Webship site, which Honeypot
protects with a time limit; a site without it needs none.
`NODE_EXTRA_CA_CERTS` lets Node.js trust DDEV's HTTPS certificate for the
steps that send a request outside the browser.
`@curated-toolbar` marks the Basic HTML toolbar the module sets when it is
installed on its own (CI). A site template that sets the text formats itself
keeps its own toolbar, as a Webship site does, so a run there leaves it out.
`yarn test:dry` checks that every step resolves to one definition, without
a browser.

### 4. What green looks like

```
27 scenarios (27 passed)
121 steps (121 passed)
```

The HTML report is written to `tests/reports/cucumber_report.html`. A failed
step leaves a screenshot in `tests/screenshots/` and a video in
`tests/videos/`. The suite removes the content it creates, so a second run
starts from the same site and is green too.

## Test users

The accounts as `cucumber.js` lists them in `worldParameters.users`. Each
value comes from the environment variable named below; `CHANGE_ME` stands for
the password you chose in step 2.

```json
{
  "Webmaster": { "username": "webmaster", "password": "CHANGE_ME", "email": "webmaster@example.test", "isAdmin": true },
  "Content editor": { "username": "content_editor_user", "password": "CHANGE_ME", "email": "content_editor_user@example.test", "roles": ["content_editor"] },
  "Authenticated user": { "username": "authenticated_user", "password": "CHANGE_ME", "email": "authenticated_user@example.test", "roles": [] }
}
```

| Handle | Variables | The account |
| --- | --- | --- |
| Webmaster | `DRUPAL_ADMIN_USER`, `DRUPAL_ADMIN_PASS`, `DRUPAL_ADMIN_MAIL` | the account the installer created |
| Content editor | `DRUPAL_EDITOR_USER`, `DRUPAL_EDITOR_PASS`, `DRUPAL_EDITOR_MAIL` | a user with the Content editor role |
| Authenticated user | `DRUPAL_AUTHENTICATED_USER`, `DRUPAL_AUTHENTICATED_PASS`, `DRUPAL_AUTHENTICATED_MAIL` | a user with no role |
