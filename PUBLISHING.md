# Publishing to the Google Tag Manager Community Template Gallery

This artifact is prepared for a future public repository named
`sharkus-google-tag-manager-template`. It has not been submitted to or approved
by Google.

1. In Google Tag Manager Template Editor, import `template.tpl`, run every test
   in the **Tests** tab, and manually verify the Widget ID field validation.
2. Create the public repository with GitHub Issues enabled. Copy this directory's
   `template.tpl`, `metadata.yaml`, `LICENSE`, and `README.md` to that
   repository's root. Keep this `PUBLISHING.md` as maintenance documentation.
3. Confirm `metadata.yaml` still contains the literal
   `REPLACE_WITH_RELEASE_COMMIT_SHA`; do not invent a SHA.
4. Commit the release payload (including the exact `template.tpl` to publish)
   and push it. Record the full SHA of this **payload commit** as `RELEASE_SHA`.
5. In a follow-up commit, replace the placeholder in `metadata.yaml` with
   `RELEASE_SHA` and push. This order is essential: the SHA listed in metadata
   must point to a commit that already contains the matching `template.tpl`.
6. Confirm the default branch contains the metadata follow-up commit and that
   the listed `RELEASE_SHA` resolves to the release payload commit.
7. Sign in to the Google account that can access the public GitHub repository,
   open the [Community Template Gallery](https://tagmanager.google.com/gallery),
   choose **Submit Template**, and provide the repository URL.
8. Wait for Google's review; do not claim approval before it is received.
9. For each later release, commit and push the changed template first, add a new
   topmost `versions` item with that payload commit's full SHA and change notes
   in a follow-up metadata commit, then push. Keep entries newest-first.

Before submission, publish a real public GTM documentation page and add its URL
as `documentation` in `metadata.yaml`. The intended Sharkus URL is
`https://sharkus.cl/docs/google-tag-manager`; it is not asserted to be live by
this source artifact.

References: Google's [Gallery submission guide](https://developers.google.com/tag-platform/tag-manager/templates/gallery), [permissions guide](https://developers.google.com/tag-platform/tag-manager/templates/permissions), and [Template Editor tests guide](https://developers.google.com/tag-platform/tag-manager/templates/tests).
