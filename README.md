# TOTPSecretGenerator4Pascal
This is a simple generator for TOTP secrets and TOTP-URIs that can be published as QRCodes subsequently.
The URI format follows Googles documentation here: https://github.com/google/google-authenticator/wiki/Key-Uri-Format

For compilation it needs the following additional components:

* The SynCrypto components from mORMot (see https://github.com/synopse/mORMot). These seem to have a cryptographically safe random number generator.
* SZCodeBaseX from either Torry (http://torry.net/authorsmore.php?id=5726) or from my copy on Github (https://github.com/marsupilami79/SZCodeBaseX)

You will need to add the path to these components to the other unit search path in the project settings.
