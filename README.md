# Mite

Notes app that turns notes into designed articles, with Bible Studies, Return Visits and an Hours Report.
The whole app is one file: `www/index.html`. Everything is saved on the phone.

## Edit and preview
Open `www/index.html` in a browser, or run `npm run serve`.

## Build a test APK (easiest)
1. Push this folder to a GitHub repo (branch `main`).
2. Open the **Actions** tab → **Build APK (test version)** → **Run workflow**.
3. When it finishes, download `mite-apk` from the run page, unzip it, and send `app-debug.apk` to the phone.
The build automatically: downloads the fonts into the app (so it works offline), adds camera/mic/notification permissions, makes the pixel-cat icon and splash screen, and installs the native add-ons (reminders, voice typing, backup sharing, JW Library links).

Same thing by hand in a Codespace (the first time, run `npm run codespace:setup` once, then reopen the terminal):

    npm install
    npm run android:add
    npm run android:sync
    npm run android:apk

## Publish on Google Play
1. **Check the app id and name** in `capacitor.config.json` (`com.emman.mite` / `Mite`). The id can never change after publishing, so change it now if you want a different one.
2. **Make a signing key once** (keep the file and passwords safe, you need them for every update):

       keytool -genkey -v -keystore release.keystore -alias notes -keyalg RSA -keysize 2048 -validity 10000

3. In the GitHub repo go to Settings → Secrets → Actions and add: `KEYSTORE_BASE64` (output of `base64 -w0 release.keystore`), `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`.
4. Run **Build signed release (Google Play)**. Upload the `app-release.aab` it produces in the Play Console.
5. Play will also ask for a privacy policy link, screenshots and a content rating.

## What works natively in the APK
- **Reminders** ring even when the app is closed (Android Local Notifications). On first use the app asks for notification permission and for "Alarms & reminders" so they ring on time.
- **Voice typing** uses Android's speech recognizer (English or Filipino, set in Profile).
- **Backup** opens the Android share sheet so the file can be saved to Drive, WhatsApp, etc. Restore can pick that file.
- **Bible texts** (John 3:16, Juan 3:16, Awit 23:1-4 …) open straight in JW Library from the Article view.

## Known limits
- Backup does not include photos and clips (text, tasks, Bible studies, return visits and hours are included).
- Bible texts become links in Article view; in the editor they stay plain text so you can edit them.

## Look and feel
- App icon: `assets/source/mite-icon.png` (the build makes all Android icon sizes from `assets/icon-*.png`).
- Opening animation: `assets/source/mite-intro.gif`, built into `www/index.html`. It plays for 3 seconds when the app opens, and a tap skips it. The phone's native splash screen shows its first frame while the app loads.
