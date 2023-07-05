# Security and Cryptography
## Entropy
1. Suppose a password is chosen as a concatenation of four lower-case dictionary words, where each word is selected uniformly at random from a dictionary of size 100,000. An example of such a password is correcthorsebatterystaple. How many bits of entropy does this have?

`log2(pow(100000, 4)) = 66.44`

2. Consider an alternative scheme where a password is chosen as a sequence of 8 random alphanumeric characters (including both lower-case and upper-case letters). An example is rg8Ql34g. How many bits of entropy does this have?

`log2(pow(52, 8)) =  45.6`

3. Which is the strongest password?

The first one.

4. Suppose and an attacker can try guessing 10,000 passwords per second. On average, how long will it take to break each of the passwords?

The first one takes `pow(100000, 4)/10000 = 1e+16` seconds, around 115740740740 days. The second one takes `pow(52, 8)/10000 = 534972853` seconds, around 61874 days.

## Cryptographic hash function
 Download a Debian image from a mirror (e.g. from this Argentinean mirror). Cross-check the hash (e.g. using the sha256sum command) with the hash retrieved from the official Debian site (e.g. this file hosted at debian.org, if you’ve downloaded the linked file from the Argentinean mirror).

## Symmetric cryptography
Encrypt a file with AES encryption, using OpenSSL: openssl aes-256-cbc -salt -in {input filename} -out {output filename}. Look at the contents using cat or hexdump. Decrypt it with openssl aes-256-cbc -d -in {input filename} -out {output filename} and confirm that the contents match the original using cmp.

Create file `hello.txt`, append a line `hello` to the file. encrypt the file with `openssl aes-256-cbc -salt -in hello.txt -out hello.txt.enc` 

```
> hexdump hello.txt.enc
0000000 6153 746c 6465 5f5f 2049 3ff0 286b 0b01
0000010 49f6 914c df3e 78ce 552b 85a1 9c97 3081
0000020
> hexdump hello.txt
0000000 6568 6c6c 0a6f                         
0000006
```
After decrption, confirmed that the contents match the original using cmp.

```
> openssl aes-256-cbc -d -in hello.txt.enc -out hello.txt.dec
enter aes-256-cbc decryption password:
*** WARNING : deprecated key derivation used.
> cmp hello.txt.dec hello.txt
> # status code 0, two files identical
```

## Asymmetric cryptography
1. Set up SSH keys on a computer you have access to (not Athena, because Kerberos interacts weirdly with SSH keys). Make sure your private key is encrypted with a passphrase, so it is protected at rest.
2. Set up GPG
3. Send Anish an encrypted email (public key).
4. Sign a Git commit with git commit -S or create a signed Git tag with git tag -s. Verify the signature on the commit with git show --show-signature or on the tag with git tag -v.
