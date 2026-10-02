# Sharkus Chat Widget for Google Tag Manager

This is the official Google Tag Manager (GTM) Community Template source for
installing the Sharkus AI chat widget.

Documentation: [docs.sharkus.cl/google-tag-manager](https://docs.sharkus.cl/google-tag-manager).

## Installation

1. Open Google Tag Manager.
2. Go to **Templates**.
3. Install or import **Sharkus Chat Widget**.
4. Create a new Sharkus tag.
5. Enter the Widget ID shown in Sharkus for the agent you want to install.
6. Select the **All Pages** trigger.
7. Preview the container and confirm the widget loads once.
8. Publish the container.

The tag accepts one required field: **Widget ID**. It is the public UUID v4
installation identifier (`agent.widget_uuid`), not an API key or the internal
agent database ID.

## Direct installation equivalent

```html
<script
  src="https://widget.sharkus.cl/loader.js"
  data-widget-id="YOUR_WIDGET_ID">
</script>
```

GTM's Sandboxed JavaScript API cannot add `data-*` attributes to an injected
script. The template therefore calls the same canonical loader with its
validated Widget ID in `?widgetId=`. This is a transport detail of the GTM
template; direct installations should use `data-widget-id` as shown above.

## Troubleshooting

- **Missing Widget ID:** enter the public Widget ID from Sharkus, then save the
  tag.
- **Invalid Widget ID:** the value must be a UUID v4, including hyphens.
- **Loader blocked by CSP:** allow the CSP directives below on the host page.
- **Ad or script blocker:** allow `widget.sharkus.cl`, then retry in GTM Preview
  mode.
- **Duplicate widget installation:** remove duplicate direct snippets or GTM
  tags. The loader is idempotent for the same Widget ID, but one installation is
  the intended setup.
- **Tag not firing:** verify the tag has the **All Pages** trigger and inspect
  GTM Preview for its execution result.

## CSP requirements

The host page needs these directives for the complete widget experience:

```text
script-src https://widget.sharkus.cl
frame-src https://widget.sharkus.cl
```

The loader sends best-effort timeout telemetry from the host page. To retain
that signal, also allow:

```text
connect-src https://widget.sharkus.cl
```

The iframe owns its internal requests; this template does not load host-page
fonts, stylesheets, images, or additional scripts.

## Security

The template requests only GTM's `inject_script` permission, narrowed to
`https://widget.sharkus.cl/loader.js?widgetId=*`. It does not access browser
globals, cookies, the data layer, or user data, and it loads no other host.

Widget IDs are public installation identifiers. Authorization, origin
allowlisting, rate limits, tenant scoping, sessions, and private configuration
remain enforced by Sharkus services; the template contains no secrets.

## Gallery source layout

This directory is source material inside the Sharkus monorepo. Before a Gallery
submission, extract its contents to the root of the public repository
`sharkus-google-tag-manager-template`; see [PUBLISHING.md](PUBLISHING.md).
