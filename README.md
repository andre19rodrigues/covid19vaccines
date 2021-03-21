# covid19vaccines
Simple Flutter app to keep track of the COVID-19 vaccination process in Portugal. The app shows the administered vaccines with charts and uses Firebase Cloud Messaging to receive daily notifications with the vaccination updates.


## How to use this code
Download this repository and run the following command in the repository root directory in order to create the necessary content (Android, iOS, etc) for a Flutter project.
```
flutter create .
```
Your app is now ready to be used in both Android and iOS devices.

If you want to use Firebase Cloud Messaging, check the [documentation](https://firebase.flutter.dev/docs/messaging/overview/) and follow the steps to set up your FCM account with your app (no extra coding needed).

This app uses data from https://github.com/dssg-pt/covid19pt-data. This data is later converted into a JSON file that is uploaded to Firebase Realtime Database and accessed through its API.

Splash screen icon by [Mavadee](https://www.flaticon.com/authors/mavadee)

![Alt Text](https://github.com/andre19rodrigues/covid19vaccines/blob/main/demo.gif)
