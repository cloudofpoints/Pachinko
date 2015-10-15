![Pachinko : A Swift Feature Toggle Framework](assets/images/pachinko_banner.png)


## Pachinko

[![Twitter: @KauseFx](https://img.shields.io/badge/contact-@cloudofpoints-blue.svg?style=flat)](https://twitter.com/cloudofpoints)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`Pachinko` is a feature toggle library for iOS & OSX that aims to keep the technical debt associated with feature switching to a minimum whilst leaving you plenty of flexibility. 

`Pachinko` is still very much an experiment and a work in progress. Please feel free to contribute and help make it better.

## Features

- Add feature toggles to your app using the provided `BaseFeature` class or extend and define your own
- Create toggles with binary on/off switching or add bespoke conditional logic with one or more  `FeaturePredicate` closures
- Encapsulate your feature predicates and group them in a `ToggleCondition<T>`
- Optionally group feature toggles into a `FeatureContext` you define that is meaningful to your app to make them easier to manage
- Implement your own `FeatureSource` to provide `FeatureToggle` status.
- You can use a PLIST, a remote API call to your app's server backend, CoreData, Realm or all of the above. 
- `FeatureSource` is source-agnostic and defers to you on how best to implement toggle status information.

## Requirements

`Pachinko` is provided as a Swift 2.0 dynamic framework which you embed in your app project. Embedded frameworks are supported only from iOS8 onwards.

- iOS 8.0+ | Mac OSX 10.9+
- Xcode 7.0+

## Installation

### Carthage

To integrate `Pachinko` into your Xcode project using Carthage, add the following to your local `Cartfile`:

```ogdl
github "cloudofpoints/pachinko" ~> 1.0.0
```

### CocoaPods

Stay tuned - CocoaPods support to follow soon :flushed:

## Usage

- Optionally define a `FeatureContext` to group your feature toggles together for easier lifecycle management and general admin :

```swift
let myLoginContext = FeatureContext(name: "UserLogin", 
									synopsis: "Features related to user login")
```
- Instantiate a unique `FeatureSignature` for each `Feature`. This signature will act as the link between the `Feature` and the matching `FeatureToggle`. `FeatureSignature` conforms to the Swift `Hashable` protocol

```swift
let myNewUserLoginSignature = FeatureSignature(id: "FA8F9F0A-5BDA-4105-A177-E7992A22D643", 
										name: "NewUserLoginFeature", 
										synopsis: "A/B testing for new user greeting")
```

- Implement a `FeatureSource` that will return a `ConditionalFeature` for a specified `FeatureContext` and `FeatureSignature`. 

- Instantiate a `FeatureToggle` corresponding to each `Feature` you wish to execute conditionally. Compose each `FeatureToggle` with your `FeatureSource` implementation.

```swift
let myNewUserLoginToggle = FeatureToggle(context: myLoginContext, 
										signature: myNewUserLoginSignature, 
										featureSource: myStubFeatureSource)

```
- Optionally bind one or more `ToggleCondition<T>` instances to your `FeatureToggle` to inject the evaluation of an added layer of conditional logic over and above determining whether or not the `FeatureStatus` of your toggle is `Active`.

- The array of `FeaturePredicate` closures for any individual `ToggleCondition<T>` instance are reduced to a single `Boolean` output by applying a logical `AND` operation across the entire array.

- If you choose not to bind any `ToggleCondition<T>` instances, your `FeatureToggle` becomes a simple on/off switch driven by the `FeatureStatus` value.

```swift
myNewUserLoginToggle.bindFeaturePredicates([ToggleCondition<UserProfile>(sampleUserProfile)
            {userProfile in userProfile.isNewUser() && userProfile.location == UserLocation.EU}
])
```

- Apply your `FeatureToggle` instance to wrap the relevant feature in your app.

- Combine `FeatureToggle` instances to support A/B feature logic

```swift
if myNewUserLoginToggle.shouldExecuteFeature() {
    
    print("Executing new user login feature  --> A Feature")
    // Your A/B testing 'A' feature code 
    
} else if myOtherNewUserLoginToggle.shouldExecuteFeature() {

    print("Executing new user login feature  --> B Feature")
    // Your A/B testing 'B' feature code     

} else {

    print("Neither the A or the B test feature were executed")
    
}
```

## License
This project is licensed under the terms of the BSD-3 license. See the LICENSE file.