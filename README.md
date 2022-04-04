# ShopApp

Download:<br/>
1. Download it via Github and open the ShopApp.xcodeproj file in Xcode.
2. Change the bundle Identifier to the desired name and make sure to the select a developer account.
3. Create a Firebase Project on https://console.firebase.google.com without Analytics.
4. Add the iOS Application to Firebase. Follow the given instructions on Firebase to add it via the Swift Package Manager. You can ignore the step with the Initialization code.
5. Use the packages FirebaseAuth, FirebaseFirestore, FirebaseStorage.
6. Now create a Firestore Database and make sure that you can read and write to it. You can change this in the rules of the Database.
7. Add FirebaseAuth with Email and Password as the sign-in method.
8. Create an Item in Firestore in the collection Items. It should look like this: ![alt text](https://github.com/comhendrik/ShopApp/explanationImage.png) Please upload an product image to Storage and the variable imagePath should contain the matching URL from FirebaseStorage.
9. Now run the app in the simulator.

