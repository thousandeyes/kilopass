###### If you need a thousand passwords, you shouldn't save a thousand passwords.

```
$ kilopass
Usage: kilopass [-s SALT] [-f SALTFILE] [-n NONCE] [-g GEN] [-h HELP] <user@domain>
Alternatively, create ~/.kilopass/salt with your salt, preferably chmod 600.
```

Note that the salt on the command line may be visible to other users on your system. You can generally disable globally user-accessible /proc, or just use ~/.kilopass/salt to store your salt.

The -f saltfile option can be literal (/home/user/.kilopass/salts/dev), or relative "dev". If relative with no prefixing /, kilopass will search for a salt at $HOME/.kilopass/salts/(yoursalt).

## Overview

kilopass is a specification (and shell utility) for saving passwords off of a single hash. It supports a nonce and multiple generation modes, in case a certain service mandates the password be a different length or have certain patterns. The target (user@domain) is generally arbitrary, but following that syntax should get you through most situations. You may want to save your passwords, or at least your generation methods for a while, before relying completely on kilopass.

You can increment the nonce if your password was compromised at whatever login, just make a note that the nonce is higher for that target. Different nonces should generate completely different results. However, different generation modes should not used for the same salt + nonce + target as compromise of one could easily lead to compromise of the others.

## Requirements

A loosely POSIX-compliant system with a bourne shell (/bin/sh) or equivalent.

Uses these utilities, in addition to other more common Unix utilities (cat, tr, head, etc):

 * xxd
 * base64
 * sha256/sha256sum

## Installation

```
$ make test # Do this before using kilopass at all to make sure it gives correct output on your system.
# make install # Will copy to /usr/local/bin
```

## Generation specification

### Overview

All kilopass generators currently use sha256 on a concatenated string of these parts:
 * Salt (User specified.)
 * ^Nonce^ (User specified, defaults to zero.)
 * Target (User specified, has no default.)

In effect, in shell, this is:
```
$SALT^$NONCE^$TARGET
```

No passwords will end with a newline. The only characters in the password should be a-z, A-Z, 0-9, and possibly "!" depending on the mode. If mode 0, only lowercase hexadecimal.

### Mode 0

This is the ASCII-HEX representation of the sha256sum and nothing more.

### Mode 1

This is the default. The sha256sum has [Base64](http://en.wikipedia.org/wiki/Base64) applied with + and / stripped. The first 18 characters/bytes are kept. Keep in mind that this is not the ASCII-HEX representation, but the literal sha256sum which has base64 applied.

### Mode 2

This is the same as mode 1, but prefixed with a "z" and suffixed with a "!". 20 characters total, but with 2 guessable.

### Mode 3

Same as mode 1, but 10 characters before adding a prefix if "a" (not "z") and a suffix of "!" (just like in mode 2).

### Mode 4

Same as mode 1, but 12 total characters.

## License

This is released under the [Unlicense](http://unlicense.org/), into the public domain.

## Security guarantee

Absolutely none. Read the specification and code for yourself and decide, or have a qualified professional review this and decide if it is acceptable.

## Modifications

Send pull requests via GitHub. After you make changes, run test.sh to verify your changes don't break expected behavior.

## Contact

If you have questions or comments, please send them to  
opensource@thousandeyes.com, or to the following address:

ThousandEyes, Inc.  
301 Howard Street #1700  
San Francisco, CA  94105  
Attn: ThousandEyes Open Source Projects
