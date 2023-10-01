# Photato
## Photographer's most needed app

![photato intro](https://github.com/stralexs/photato/assets/123239625/716feb19-82e4-48e5-b017-40c9f67e80ea)

One of the toughest tasks of any photographer is to look for inspiration and continue to surprise subscribers and clients with cool pictures. And sometimes problems with organizing  photoshoot start with the very beginning: when searching for a new location. Photato app is designed to solve this problem, because every photographer and just a casual person looking for inspiring places now has an interactive map on their phone with the best locations for photoshoots.

<p align="center">
Scenes hierarchy
</p>
![ViewController Hirarhchy](https://github.com/stralexs/photato/assets/123239625/13f6bc53-41af-4ca4-b605-07454334e770)

## Opening scene
Opening scene using property isUserLoggedIn stored in UserDefaults determines whether user is logged in and, if true, shows Loading scene or UserValidation scene if false.

## Loading scene and UserValidation scene
in Loading scene, first of all, user is authorized in Firebase using a password stored in Keychain. If user data matches, download of information about locations and their title images begins from Firebase database and Firebase storage (FirebaseManager is responsible for all operations related to Firebase). Upon completion of the download, the transition to Tab Bar Controller takes place. If authorization is not successful or user has not yet registered, UserValidation scene opens with an animated gradient in the background, where user can either log in or create a new account.
![UserValidationAndLoadingScene](https://github.com/stralexs/photato/assets/123239625/9119f12c-53e2-4a46-84ac-cdb81cc06e87)

## SignUp scene
SignUp scene is quite ordinary: user can select a profile picture from his gallery, choose a name, specify an email and password. Text fields have some restrictions, for example, the password must contain at least 6 characters. In addition, in accordance with Human Interface Guidelines, there is a button with pop-up information why user should create an account. If the email is already taken or some other error occurs, it will be displayed on the presentation layer through a notification.
![SignUpScene](https://github.com/stralexs/photato/assets/123239625/991d1a8c-a285-49b3-8849-8bf0e034b768)

## SignIn scene
SignIn scene is similar to SignUp scene: there are fields for entering a password and email, again there are restrictions of Text fields. If user's credentials don’t match those stored in Firebase, an error will appear; if signing in is successful, locations will begin loading.
![SignInScene](https://github.com/stralexs/photato/assets/123239625/c53a0090-39a0-4871-a946-2ab28884c353)

## Map scene
Map scene is a visual representation of locations. When used on an iPhone, the user's location is shown. When user clicks on the map pin, a view opens, in which by clicking on “i” icon user can go to a detailed description of the location.
![MapScene](https://github.com/stralexs/photato/assets/123239625/d76f4a6a-0ffc-4671-81c1-e60289f4cf62)

## LocationsList scene
LocationsList scene is a tabular display of the locations list. If user wants to find a specific location, a search is implemented, where it occurs not only by matching the initial letters, but also in the middle of the location name.
![LocationsListScene](https://github.com/stralexs/photato/assets/123239625/4ce77971-8f9f-46ee-ba3e-41651d8e153a)

## Profile scene
Profile scene displays user's favorite locations (that are stored in Firebase). Additionally, there is a gear icon in the top right corner that leads to Settings scene.
![ProfileScene](https://github.com/stralexs/photato/assets/123239625/dbb873eb-2618-4c5c-aa37-d6487d220e19)

## LocationDescription scene
LocationDescription scene contains detailed information about the location: coordinates, address, information. When transition occurs, FirebaseManager begins loading additional location images, which are then available at the top of the screen using ScrollView. These images are then stored in the LocationManager singleton, so that if user navigates to the location again during session, the images will not be reloaded. To the right of the coordinates there is a button for copying coordinates: user can paste them into his favorite geolocation application, as well as press a button that takes user to the standard Maps application, where the location will immediately be opened. On the bottom left is a button with a sun icon that leads to WeatherForecast scene, on the right is a button to add location to favorites, which are then available in Profile scene.
![LocationDescriptionScene](https://github.com/stralexs/photato/assets/123239625/2f9eeaf7-796f-49cb-ad60-a542bafd04f3)

## WeatherForecast scene
Weather scene uses open weather API of the openweathermap website, and with the help of WeatherManager and Alamofire json with weather data is loaded. UI is identical to the interface of the standard Weather application.
![WeatherForecastScene](https://github.com/stralexs/photato/assets/123239625/18de7bb3-6e2e-427d-8f4f-df23c074df71)

## Settings scene
Settings scene allows user to make some changes to his account. Also in the upper right corner there is a button to sign out of account, which leads to UserValidation scene.

## Architecture
Since the project involves further development, when creating architecture, the choice fell on Clean Swift, since this architecture makes it easy to add new modules that expand functionality, and is also easy to test and maximally complies with SOLID principles. Also, many Interactors and Workers, through their dependence on protocols, have access to managers (for example, FirebaseManager) that perform certain functions. Two of them - LocationsManager and UserManager - are singletons. Yes, perhaps singletons are not the best option in terms of clean architecture and testability, but when the entire application should have only one instance of an array with locations information and only one user, this is the best choice. Additionally, the application was monitored for memory leaks and retain cycles.
<img width="1440" alt="Screenshot 2023-09-30 at 12 52 42" src="https://github.com/stralexs/photato/assets/123239625/6cbc7986-d664-45fc-b929-e623d64cc4fa">
<p align="center">
App has no memory leaks in Leaks intrument
</p>

## Stack
- Clean Swift
- UIKit
- Code layout, SnapKit
- MapKit, CoreLocation
- Firebase, UserDefaults
- Unit tests
- REST API, Alamofire
- SOLID principles
- GCD
- SPM














