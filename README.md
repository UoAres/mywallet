# Abstract

My assignment is a blockchain-based wallet app called My Wallet, which currently implements Bitcoin account balance and account transaction history, as well as Bitcoin block lookup and automatic infinite page loading. It runs on Mac OS, Apple phones, Android phones, and the web.

# Differences

My Wallet is based on Flutter, an open-source, cross-platform application development toolkit from Google. Its programming language is Dart, almost identical to TypeScript in syntax. Still, it is more streamlined than TypeScript, with stricter syntax and type checking, so there are virtually no syntax or null type errors. In addition, it has more streamlined dependency management, no need to use npm to install many dependencies, no huge Node_modules directory will be generated, and the program structure is more refreshing.

In front-end development using Flutter, compared with React, it has carried out more thorough structuring of the page view than React, basically reaching complete hosting of page rendering; you don't even need to write any HTML and CSS code, you only need to use JSON format to define your views to complete the development of a page.

# How it works

Then the overall execution logic of the APP will be described. The entry file of the APP is the main.dart file, in which we define a MaterialApp assembly and then further define the route controller for the community and the default route path in the Routes.dart file, we configure our routes and the specific route processing logic. Here we define the FrameMenu page that opens when the way "/" is entered, and we define the specifics of that page in FrameMenu.dart. In it, we define that this view has only one bottom navigation bar, further define the content in the navigation bar, which is composed of two menus, and further define the view to be opened corresponding to each menu, which includes the asset balance view Asset.dart that we introduced above.

Finally, I'll go over how to configure the Flutter development environment and how to get the app up and running in IOS and MAC.

# How to run the app

## Download the Flutter installer that matches your operating system: 
```sh
https://docs.flutter.dev/get-started/install
```

## Download the project code:
```
git clone https://github.com/UoAres/mywallet
```

## Initialize it:
```sh
flutter pub get //Get the dependencies
flutter create . //create the runtime environment
```

## Run it:
```sh
flutter run //start the project and select the platform you want to run on
```

If you find that you can't access the network (or have no data) after starting, you need to configure network access.

Add the following to the file "macos/Runner/DebugProfile.entitlements":
```sh
<key>com.apple.security.network.client</key>
<true/>
```

Save and re-run the:
```sh
flutter run
```