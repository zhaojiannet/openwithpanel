# Releasing

Pushing a version tag runs the Release workflow in GitHub Actions. It builds OpenWithPanel, packages it as a DMG, and creates a draft release with the DMG and a Homebrew cask file whose version and checksum are already filled in. Review the draft on GitHub, then publish it.

The workflow is defined in `.github/workflows/release.yml` and packages with `scripts/package.sh`, the same script used for local builds.

Whether a release is signed depends on the signing secrets configured in the repository:

- **None configured:** the app is signed ad hoc and isn't notarized by Apple. macOS blocks it the first time a user opens it, and they have to click **Open Anyway** in **System Settings › Privacy & Security**. The DMG includes `First Launch.txt` with those steps, and the draft release notes include them too. The **First launch** section of the README (and its translations) describes this case.
- **All 6 configured:** the app is signed with a Developer ID and notarized, so users can open it directly. Once releases are signed, remove the **First launch** section from the README and every translation.

If only some of the secrets are configured, the workflow stops before building, so a release meant to be signed is never published unsigned.

## Setting up signing and notarization (optional)

1. Join the Apple Developer Program.
2. Create a **Developer ID Application** certificate on the developer website, install it in your keychain, then export it together with its private key as a `.p12` file from Keychain Access, setting a password.
3. In App Store Connect, under **Users and Access › Integrations › App Store Connect API**, create an API key with the **Developer** role. Download the `.p8` file (it can only be downloaded once) and note the key ID and issuer ID.
4. In the GitHub repository, open **Settings › Environments** and create an environment named `release`:
   - under **Deployment branches and tags**, choose **Selected branches and tags** and add only the tag rule `v*`;
   - turn on **Required reviewers** and add yourself, so every release waits for your approval before the secrets are used.
5. Add these 6 secrets under **Environment secrets** of the `release` environment. Don't add them as repository secrets, which other workflows and branches could read.

| Name | Value |
|---|---|
| `DEVELOPER_ID_P12_BASE64` | The `.p12` file in base64: `base64 -i certificate.p12 \| pbcopy` |
| `DEVELOPER_ID_P12_PASSWORD` | The password set when exporting the `.p12` |
| `DEVELOPER_ID` | The certificate name, such as `Developer ID Application: Name (TEAMID)`; find it with `security find-identity -v -p codesigning` |
| `NOTARY_KEY_BASE64` | The `.p8` file in base64: `base64 -i AuthKey_XXXX.p8 \| pbcopy` |
| `NOTARY_KEY_ID` | The API key ID |
| `NOTARY_ISSUER_ID` | The issuer ID |

## Publishing a release

1. Make sure `MARKETING_VERSION` in the Xcode project is the version you're releasing. The workflow fails if it doesn't match the tag.
2. Create and push a tag, for example `git tag v0.1.0 && git push origin v0.1.0`. You can also run the workflow manually from **Actions › Release › Run workflow** and enter the tag name.
3. When the workflow finishes, find the draft on the **Releases** page, check the notes and assets, and click **Publish release**.

## Homebrew

The `openwithpanel.rb` file attached to the draft already has the version and SHA-256 filled in. To let users install with Homebrew, create a separate repository named `zhaojiannet/homebrew-tap` and put the file in its `Casks/` folder. Users can then run:

```sh
brew install --cask zhaojiannet/tap/openwithpanel
```

For each new release, replace the file in the tap repository with the new `openwithpanel.rb`.

Don't publish unnotarized releases through Homebrew. Apps installed with Homebrew are blocked by macOS just the same, and Homebrew no longer offers a way to skip that check, so users would end up with an app that installs but won't open.
