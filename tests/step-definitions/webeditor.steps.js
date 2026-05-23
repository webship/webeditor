'use strict';

const { Given, Then, When } = require('@cucumber/cucumber');
const { friendly } = require('webship-js/tests/step-definitions/webship');

/**
 * Run a step body and rethrow any failure as a tester-friendly error.
 */
async function attempt(body, message) {
  try {
    await body();
  } catch (err) {
    throw friendly(message, err);
  }
}

/**
 * Log in as a named test user defined in cucumber.js worldParameters.users.
 *
 * The Webmaster row is the site-install super-admin. Every other row is
 * provisioned by `Given I add testing users` (see below).
 *
 * Example #1: Given I am a logged in user with the "Webmaster" user
 * Example #2: Given I am a logged in user with the "Content editor" user
 * Example #3: Given I am a logged in user with the "Authenticated user" user
 */
Given(/^I am a logged in user with( the)*( username)* "([^"]*)?"( user)?$/, async function (theCase, usernameCase, key, userCase) {
  const users = this.parameters.users || {};
  if (!(key in users)) {
    throw new Error(`No user named "${key}" in cucumber.js worldParameters.users`);
  }
  const { username, password } = users[key];
  if (!username || !password) {
    throw new Error(`User "${key}" is missing username or password in worldParameters.users`);
  }
  await this.page.goto(`${this.parameters.launchUrl}/user/login`);
  await this.page.getByLabel('Username').fill(username);
  await this.page.getByLabel('Password').fill(password);
  await this.page.locator('input[value="Log in"]').click();
  await this.page.waitForLoadState('networkidle');
});

/**
 * Provision every non-admin user from cucumber.js worldParameters.users.
 *
 * Example #1: Given I add testing users
 * Example #2: And I add the testing users
 */
Given(/^(?:I |we )?add( the)? testing users$/, async function (theCase) {
  const users = this.parameters.users || {};
  for (const [key, info] of Object.entries(users)) {
    if (info.isAdmin) continue;
    await this.page.goto(`${this.parameters.launchUrl}/admin/people/create`);
    await this.page.locator('#edit-name').fill(info.username);
    await this.page.locator('#edit-mail').fill(info.email || `${info.username}@example.test`);
    await this.page.locator('#edit-pass-pass1').fill(info.password);
    await this.page.locator('#edit-pass-pass2').fill(info.password);
    for (const role of info.roles || []) {
      const cb = this.page.locator(`input[name="roles[${role}]"]`);
      if (await cb.count() > 0) await cb.check();
    }
    await this.page.locator('#edit-submit').click();
    await this.page.waitForLoadState('networkidle');
  }
});

/**
 * Resolve a form field locator by label.
 */
function fieldLocator(page, label) {
  return page
    .locator('label.form-item__label, label.form-required, label')
    .filter({ hasText: new RegExp(`^\\s*${label.replace(/[.*+?^${}()|[\\]\\\\]/g, '\\$&')}(\\s|$)`, 'i') })
    .first();
}

/**
 * Assert that a form field with the given label is visible on the page.
 *
 * Example #1: Then I should see a "Title" field
 * Example #2: Then I should see a "Description" field
 */
Then(/^(?:I |we )?should see a "([^"]*)" field$/, async function (label) {
  await attempt(async () => {
    const locator = fieldLocator(this.page, label);
    await locator.waitFor({ state: 'visible', timeout: 30000 });
  }, `Expected to find a field labeled "${label}"`);
});

/**
 * Assert that a form field with the given label (with article "an") is visible.
 *
 * Example #1: Then I should see an "Image" field
 */
Then(/^(?:I |we )?should see an "([^"]*)" field$/, async function (label) {
  await attempt(async () => {
    const locator = fieldLocator(this.page, label);
    await locator.waitFor({ state: 'visible', timeout: 30000 });
  }, `Expected to find a field labeled "${label}"`);
});

/**
 * Assert that a button with the given text is visible on the page.
 *
 * Example #1: Then I should see the button "Save"
 */
Then(/^(?:I |we )?should see the button "([^"]*)"$/, async function (text) {
  await attempt(async () => {
    const locator = this.page.getByRole('button', { name: text, exact: false }).first();
    await locator.waitFor({ state: 'visible', timeout: 30000 });
  }, `Expected to find a button with text "${text}"`);
});

/**
 * Assert the response of a path is the given HTTP status code.
 *
 * Example: Then the response status of "/" should be 200
 */
Then(/^the response status of "([^"]+)" should be (\d+)$/, async function (path, status) {
  await attempt(async () => {
    const url = `${this.parameters.launchUrl}${path}`;
    const response = await this.page.request.get(url, { failOnStatusCode: false });
    const actual = response.status();
    if (String(actual) !== String(status)) {
      throw new Error(`GET ${path} returned ${actual}, expected ${status}`);
    }
  }, `Unexpected HTTP status for "${path}"`);
});

/**
 * Assert a checkbox with the given label is currently checked.
 *
 * Example: Then I should see a "Linkit URL converter" checkbox checked
 */
Then(/^(?:I |we )?should see a "([^"]*)" checkbox checked$/, async function (label) {
  await attempt(async () => {
    const cb = this.page.getByLabel(label, { exact: false }).first();
    await cb.waitFor({ state: 'attached', timeout: 30000 });
    const checked = await cb.isChecked();
    if (!checked) {
      throw new Error(`Checkbox "${label}" exists but is not checked`);
    }
  }, `Expected checkbox "${label}" to be checked`);
});

/**
 * Map a human CKEditor 5 button label to its machine ID.
 *
 * Drupal's CKEditor 5 admin form ships the active toolbar as a JSON list of
 * machine names inside the hidden textarea
 * `#ckeditor5-toolbar-buttons-selected`. Tests are written against the human
 * labels users actually see in the UI; this lookup converts them.
 */
const CKEDITOR5_BUTTON_LABEL_TO_ID = {
  'Bold': 'bold',
  'Italic': 'italic',
  'Underline': 'underline',
  'Strikethrough': 'strikethrough',
  'Superscript': 'superscript',
  'Subscript': 'subscript',
  'Code': 'code',
  'Block quote': 'blockQuote',
  'Heading': 'heading',
  'Link': 'link',
  'Bulleted list': 'bulletedList',
  'Numbered list': 'numberedList',
  'Image': 'drupalInsertImage',
  'Drupal media': 'drupalMedia',
  'Insert image': 'drupalInsertImage',
  'Insert media': 'drupalMedia',
  'Insert table': 'insertTable',
  'table': 'insertTable',
  'Source': 'sourceEditing',
  'Source editing': 'sourceEditing',
  'Text alignment': 'alignment',
  'Outdent': 'outdent',
  'Indent': 'indent',
  'Remove format': 'removeFormat',
  'Horizontal line': 'horizontalLine',
  'Special characters': 'specialCharacters',
  'Text part language': 'textPartLanguage',
  'Code block': 'codeBlock',
  'Undo': 'undo',
  'Redo': 'redo',
};

/**
 * Assert the active CKEditor 5 toolbar contains a button with the given title.
 *
 * The Drupal CKEditor 5 admin form stores the active toolbar as a JSON list
 * inside the hidden textarea `#ckeditor5-toolbar-buttons-selected`. Reading
 * that textarea avoids the slow draggable UI that does not always render in
 * headless mode.
 *
 * Example: Then the active CKEditor 5 toolbar should contain "Bold"
 */
Then(/^the active CKEditor 5 toolbar should contain "([^"]+)"$/, async function (label) {
  await attempt(async () => {
    const textarea = this.page.locator('#ckeditor5-toolbar-buttons-selected');
    await textarea.waitFor({ state: 'attached', timeout: 30000 });
    const raw = await textarea.inputValue();
    let items;
    try {
      items = JSON.parse(raw);
    }
    catch (e) {
      throw new Error(`Could not parse the CKEditor 5 active toolbar JSON: ${raw}`);
    }
    const wanted = CKEDITOR5_BUTTON_LABEL_TO_ID[label] || label;
    if (!items.includes(wanted)) {
      throw new Error(`Active CKEditor 5 toolbar [${items.join(', ')}] does not contain "${label}" (id "${wanted}")`);
    }
  }, `Expected active CKEditor 5 toolbar to contain "${label}"`);
});

/**
 * Assert that CKEditor 5 has rendered on the current page.
 *
 * Example: Then the CKEditor 5 editor should be visible
 */
Then(/^the CKEditor 5 editor should be visible$/, async function () {
  await attempt(async () => {
    const editor = this.page.locator('.ck.ck-editor').first();
    await editor.waitFor({ state: 'visible', timeout: 30000 });
  }, 'Expected to find a rendered CKEditor 5 editor on the page');
});

/**
 * Assert that the CKEditor 5 toolbar has rendered on the current page.
 *
 * Example: And the CKEditor 5 toolbar should be visible
 */
Then(/^the CKEditor 5 toolbar should be visible$/, async function () {
  await attempt(async () => {
    const toolbar = this.page.locator('.ck.ck-toolbar').first();
    await toolbar.waitFor({ state: 'visible', timeout: 30000 });
  }, 'Expected to find a rendered CKEditor 5 toolbar on the page');
});

/**
 * Type some text into the active CKEditor 5 editing area.
 *
 * Example: When I type "Hello world" into the active CKEditor 5
 */
When(/^I type "([^"]*)" into the active CKEditor 5$/, async function (text) {
  await attempt(async () => {
    const area = this.page.locator('.ck.ck-editor__editable').first();
    await area.waitFor({ state: 'visible', timeout: 30000 });
    await area.click();
    await area.fill('');
    await area.type(text);
  }, `Failed to type "${text}" into the active CKEditor 5`);
});

/**
 * Assert the page exposes the named text format in the format selector.
 *
 * The selector is the `<select>` rendered by filter_format_access_filtered_html_format
 * under each formatted text field (`select.filter-list` is the canonical class).
 *
 * Example: Then the page should expose the text format "Full HTML"
 */
Then(/^the page should expose the text format "([^"]+)"$/, async function (name) {
  await attempt(async () => {
    const sel = this.page.locator('select.filter-list, select[name$="[format]"]').first();
    await sel.waitFor({ state: 'attached', timeout: 30000 });
    const options = await sel.locator('option').allTextContents();
    if (!options.some((o) => o.trim() === name)) {
      throw new Error(`Format selector has options [${options.map((o) => o.trim()).join(', ')}], but "${name}" was not present`);
    }
  }, `Expected the page text-format selector to expose "${name}"`);
});
