import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const directory = path.dirname(fileURLToPath(import.meta.url));
const template = fs.readFileSync(path.join(directory, 'template.tpl'), 'utf8');

function section(name, next) {
  const start = template.indexOf(`___${name}___`) + name.length + 6;
  const end = next ? template.indexOf(`___${next}___`) : template.length;
  return template.slice(start, end).trim();
}

test('GTM artifact exposes only the required Widget ID field', () => {
  const fields = JSON.parse(section('TEMPLATE_PARAMETERS', 'SANDBOXED_JS_FOR_WEB_TEMPLATE'));
  assert.equal(fields.length, 1);
  assert.equal(fields[0].name, 'widgetId');
  assert.equal(fields[0].displayName, 'Widget ID');
  assert.ok(fields[0].valueValidators.some((validator) => validator.type === 'NON_EMPTY'));
  assert.ok(fields[0].valueValidators.some((validator) => validator.type === 'REGEX'));
});

test('GTM artifact grants only canonical-loader injection permission', () => {
  const permissions = JSON.parse(section('WEB_PERMISSIONS', 'TESTS'));
  assert.equal(permissions.length, 1);
  assert.equal(permissions[0].instance.key.publicId, 'inject_script');
  assert.equal(
    permissions[0].instance.param[0].value.listItem[0].string,
    'https://widget.sharkus.cl/loader.js?widgetId=*',
  );
});

test('GTM artifact has lifecycle and permission-denial Template Editor tests', () => {
  const tests = section('TESTS', 'NOTES');
  for (const expected of [
    'Loads the canonical Sharkus loader after a valid Widget ID',
    'Rejects a missing Widget ID without injecting a script',
    'Rejects an invalid Widget ID without injecting a script',
    'Reports failure when the loader cannot be injected',
    'Reports failure when the narrow loader permission is denied',
  ]) {
    assert.match(tests, new RegExp(expected));
  }
  assert.match(section('SANDBOXED_JS_FOR_WEB_TEMPLATE', 'WEB_PERMISSIONS'), /data\.gtmOnSuccess/);
  assert.match(section('SANDBOXED_JS_FOR_WEB_TEMPLATE', 'WEB_PERMISSIONS'), /data\.gtmOnFailure/);
});

test('GTM sandbox validation does not use unsupported regular-expression literals', () => {
  const code = section('SANDBOXED_JS_FOR_WEB_TEMPLATE', 'WEB_PERMISSIONS');
  assert.match(code, /function isUuidV4\(value\)/);
  assert.doesNotMatch(code, /const uuidV4 = \//);
});

test('GTM sandbox UUID v4 validation accepts valid IDs and rejects invalid IDs', () => {
  const calls = [];
  const dependencies = {
    injectScript: (url) => calls.push(url),
    queryPermission: () => true,
  };
  const execute = (widgetId) => new Function('require', 'data', section(
    'SANDBOXED_JS_FOR_WEB_TEMPLATE',
    'WEB_PERMISSIONS',
  ))(
    (name) => dependencies[name],
    { widgetId, gtmOnSuccess() {}, gtmOnFailure() {} },
  );

  execute('869eb25e-11b7-4314-8637-85ae05f0235c');
  execute('869eb25e-11b7-5314-8637-85ae05f0235c');
  execute('not-a-widget-id');

  assert.deepEqual(calls, [
    'https://widget.sharkus.cl/loader.js?widgetId=869eb25e-11b7-4314-8637-85ae05f0235c',
  ]);
});

test('Gallery submission files contain a release SHA', () => {
  for (const name of ['metadata.yaml', 'LICENSE', 'README.md', 'PUBLISHING.md']) {
    assert.equal(fs.existsSync(path.join(directory, name)), true);
  }
  const metadata = fs.readFileSync(path.join(directory, 'metadata.yaml'), 'utf8');
  assert.match(metadata, /sha: [0-9a-f]{40}/i);
  assert.doesNotMatch(metadata, /REPLACE_WITH_RELEASE_COMMIT_SHA/);
});

test('LICENSE contains the complete Apache 2.0 appendix and Sharkus notice', () => {
  const license = fs.readFileSync(path.join(directory, 'LICENSE'), 'utf8');
  assert.match(license, /APPENDIX: How to apply the Apache License to your work\./);
  assert.match(license, /Copyright 2026 Sharkus/);
  assert.match(license, /Licensed under the Apache License, Version 2\.0/);
});
