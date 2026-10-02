___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.

___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Sharkus Chat Widget",
  "description": "Install the Sharkus AI chat widget with a public Widget ID.",
  "categories": [
    "TAG_MANAGEMENT"
  ],
  "containerContexts": [
    "WEB"
  ]
}

___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "widgetId",
    "displayName": "Widget ID",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "help": "Your Sharkus widget identifier. Example: 869eb25e-11b7-4314-8637-85ae05f0235c",
    "valueHint": "869eb25e-11b7-4314-8637-85ae05f0235c",
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Widget ID is required."
      },
      {
        "type": "REGEX",
        "args": [
          "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89aAbB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"
        ],
        "errorMessage": "Widget ID must be a UUID v4."
      }
    ]
  }
]

___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const queryPermission = require('queryPermission');
const loaderUrl = 'https://widget.sharkus.cl/loader.js';
const widgetId = (data.widgetId || '').trim();
const uuidV4 = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

if (!uuidV4.test(widgetId)) {
  data.gtmOnFailure();
  return;
}

const scriptUrl = loaderUrl + '?widgetId=' + widgetId;

if (!queryPermission('inject_script', scriptUrl)) {
  data.gtmOnFailure();
  return;
}

injectScript(scriptUrl, data.gtmOnSuccess, data.gtmOnFailure, scriptUrl);

___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://widget.sharkus.cl/loader.js?widgetId=*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]

___TESTS___

scenarios:
  - name: Loads the canonical Sharkus loader after a valid Widget ID
    code: |-
      runCode({
        widgetId: '869eb25e-11b7-4314-8637-85ae05f0235c'
      });
      assertApi('injectScript').wasCalled();
      assertApi('gtmOnSuccess').wasCalled();
      assertApi('gtmOnFailure').wasNotCalled();
      assertThat(requestedUrl).isEqualTo(
        'https://widget.sharkus.cl/loader.js?widgetId=869eb25e-11b7-4314-8637-85ae05f0235c'
      );
      assertThat(cacheToken).isEqualTo(requestedUrl);

  - name: Rejects a missing Widget ID without injecting a script
    code: |-
      runCode({});
      assertApi('injectScript').wasNotCalled();
      assertApi('gtmOnSuccess').wasNotCalled();
      assertApi('gtmOnFailure').wasCalled();

  - name: Rejects an invalid Widget ID without injecting a script
    code: |-
      runCode({
        widgetId: 'not-a-widget-id'
      });
      assertApi('injectScript').wasNotCalled();
      assertApi('gtmOnSuccess').wasNotCalled();
      assertApi('gtmOnFailure').wasCalled();

  - name: Reports failure when the loader cannot be injected
    code: |-
      mock('injectScript', function(url, onSuccess, onFailure, token) {
        requestedUrl = url;
        cacheToken = token;
        onFailure();
      });
      runCode({
        widgetId: '869eb25e-11b7-4314-8637-85ae05f0235c'
      });
      assertApi('gtmOnSuccess').wasNotCalled();
      assertApi('gtmOnFailure').wasCalled();

  - name: Reports failure when the narrow loader permission is denied
    code: |-
      mock('queryPermission', function(permission, url) {
        requestedPermission = permission;
        requestedUrl = url;
        return false;
      });
      runCode({
        widgetId: '869eb25e-11b7-4314-8637-85ae05f0235c'
      });
      assertApi('injectScript').wasNotCalled();
      assertApi('gtmOnSuccess').wasNotCalled();
      assertApi('gtmOnFailure').wasCalled();
      assertThat(requestedPermission).isEqualTo('inject_script');
      assertThat(requestedUrl).isEqualTo(
        'https://widget.sharkus.cl/loader.js?widgetId=869eb25e-11b7-4314-8637-85ae05f0235c'
      );

setup: |-
  let requestedUrl = '';
  let cacheToken = '';
  let requestedPermission = '';
  mock('queryPermission', function(permission, url) {
    requestedPermission = permission;
    requestedUrl = url;
    return permission === 'inject_script' &&
      url.indexOf('https://widget.sharkus.cl/loader.js?widgetId=') === 0;
  });
  mock('injectScript', function(url, onSuccess, onFailure, token) {
    requestedUrl = url;
    cacheToken = token;
    onSuccess();
  });

___NOTES___

Source artifact maintained in the Sharkus monorepo. Extract this directory before Community Template Gallery submission.
