"""Adds release signing to android/app/build.gradle. Reads KEYSTORE_FILE, KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD from the environment."""
import re, sys
p = 'android/app/build.gradle'
s = open(p).read()
if 'signingConfigs.release' in s:
    print('Signing already configured'); sys.exit(0)
block = '''    signingConfigs {
        release {
            storeFile file(System.getenv("KEYSTORE_FILE") ?: "release.keystore")
            storePassword System.getenv("KEYSTORE_PASSWORD")
            keyAlias System.getenv("KEY_ALIAS")
            keyPassword System.getenv("KEY_PASSWORD")
        }
    }
'''
s, n1 = re.subn(r'(\n\s*)buildTypes\s*\{', lambda m: '\n' + block + m.group(1).lstrip('\n') + 'buildTypes {', s, count=1)
s, n2 = re.subn(r'(buildTypes\s*\{\s*release\s*\{)', r'\1\n            signingConfig signingConfigs.release', s, count=1)
if not (n1 and n2):
    sys.exit('Could not patch build.gradle (unexpected layout)')
open(p, 'w').write(s); print('Release signing configured')
