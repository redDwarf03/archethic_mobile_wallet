[![Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev) [![CodeFactor](https://www.codefactor.io/repository/github/archethic-foundation/archethic-wallet/badge)](https://www.codefactor.io/repository/github/archethic-foundation/archethic-wallet)
[![Github All Releases](https://img.shields.io/github/downloads/archethic-foundation/archethic-wallet/total.svg)](https://github.com/archethic-foundation/archethic-wallet/releases)
[![Github Downloads (monthly)](https://img.shields.io/github/downloads/archethic-foundation/archethic-wallet/latest/total.svg)](https://github.com/archethic-foundation/archethic-wallet/releases)

# Archethic Wallet

The app is mainly a FULLY decentralized and cryptocurrency non-custodial hot wallet that enables you to safely manage assets on Layer 1 Archethic blockchain.</br>
This wallet includes the features of send and receive coins instantly to and from anyone.</br>
No signup or KYC needed, you just control your service access keychain, protected by different security ways like PIN Code, Password, Yubikey devices and Biometrics</br>
NB: Yubikey is a device that makes 2-factor authentication as simple as possible (see [yubico.com](https://www.yubico.com))</br>

Archethic Wallet has implemented the following features:

### Main features
- Decentralized keychain management
- Multiple accounts' management
- Support for transactions (Sending and Receiving UCO or Fungibles Tokens, NFTs)
- DeFi features: swap, liquidity management, farming with lock
- List of recent transactions

### Security
- Security access with Password, PIN, Yubicloud OTP, Face ID, Touch ID
- Use of 24 Words Mnemonics

### Customization
- Support for English and French Language

### Other features
- Access to CEX and DEX to buy UCO
- Share address with QR Code or mobile share feature
- UCO and certified tokens Price chart

## Application Initial Screen
<img src="README_wallet.png?v=20241009" width="300"/>

## How to install Archethic Wallet

Available on Chrome, Android, Windows, MacOS, iOS and Linux
[https://www.archethic.net/wallet/](https://www.archethic.net/wallet/)

## How to test the Archethic Wallet

To test Archethic Wallet with Faucet:

- Copy your address from the wallet and paste on the [Archethic Testnet Faucet](https://testnet.archethic.net/faucet) 
- Click on 'Transfer 100 UCO'
- Refresh your dashboard</br>
Now, you can send some UCO and see your transactions

### Patrol installation and configuration

Patrol is a flutter package, you can install it using a simple `flutter pub get`

Full patrol using on this project can be found [here](integration_test/README.md)


## Integrating Deeplinks

### Overview

**aeWallet** supports opening DApps directly in an in-app webview using **deeplinks**. This feature enables seamless interaction between DApps and the wallet on mobile devices.

To use this functionality, the URL parameters must be **encoded in base64Url** before being included in the deeplink.

### URL Schema

The deeplink follows this schema:

`aewallet://dapps_webview?[base64Url_encoded_parameters]`


#### Supported Parameters

- **url**: The URL of the DApp to be loaded in the webview. (mandatory)
- **name**: The name of the DApp. (mandatory)
- **code**: A unique identifier for the DApp. (mandatory)
- **iconUrl**: The URL of the DApp's icon.
- **description**: A short description of the DApp.
- **category**: The category of the DApp (e.g., info, finance, gaming, etc.).

### Usage Example

#### Step 1: Construct the URL with the Required Parameters

Here’s an example of a URL before encoding:

`aewallet://dapps_webview?code=aeWebsite&url=https://archethic.net&category=info&description=Archethic Official Website&name=Archethic Website&iconUrl=https://archethic.net/favicon.ico`


#### Step 2: Encode the URL in base64Url

All the parameters must be encoded in base64Url to ensure compatibility. After encoding, the URL looks like this:

`aewallet://dapps_webview?ZGFwcFVybD1odHRwczovL2FyY2hldGhpYy5uZXQmZGFwcE5hbWU9QXJjaGV0aGljJTIwV2Vic2l0ZSZkYXBwQ29kZT1hZVdlYnNpdGUmY2F0ZWdvcnk9aW5mbyZkZXNjcmlwdGlvbj1BcmNoZXRoaWMlMjBPZmZpY2lhbCUyMFdlYnNpdGUm...`


#### Step 3: Test the Deeplink

Use the encoded URL in your application or mobile browser to verify that it correctly opens the DApp in the **aeWallet** webview.


## Setup this Application for developers

### Pre-requisites

- Flutter 3.24+
- Dart 3.5+

### Instructions

- Download the repo into a folder
- Goto the folder and from terminal run `flutter pub get` to get the packages
- Once packages are installed :
    - You can build and run the program for emulator from VSCode Flutter SDK Tools.
    - You can build for android emulator if already installed.
- Once the packages and installed and application is built
- Run the program with `flutter run`

By default, the endpoint is https://testnet.archethic.net but you can change it in 'Networks' menu.

### Note

*** This Application is currently in active development so it might fail to build. Please refer to issues or create new issues if you find any. Contributions are welcomed.
