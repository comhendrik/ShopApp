# ShopApp
Description:<br/>
E-commerce application for the iOS platform, developed in SwiftUI. You can create an account, add items to your favourites and buy them on account. The database is managed by Firebase.<br/>

Why I have built this project:<br/>
I created this project to learn more about Firebase and how to deal with deeper collection structures in Firestore. I was interested in the field of e-commerce and how such an application is built. It is clear to me that the security of this project cannot match the security of big companies that make money every day with e-commerce, but I learned a lot, e.g. user interface, MVVM (this is a point I can definitely put more work into) and I created two animations when you click on the buttons "Add to cart" and "Add to favourites".<br/>

Download:<br/>
1. Download it via Github and open the ShopApp.xcodeproj file in Xcode.
2. Change the bundle Identifier to the desired name and make sure to the select a developer account.
3. Create a Firebase Project on https://console.firebase.google.com without Analytics.
4. Add the iOS Application to Firebase. Follow the given instructions on Firebase to add it via the Swift Package Manager (More Information: https://firebase.google.com/docs/ios/installation-methods). You can ignore the step with the Initialization code.
5. Use the packages FirebaseAuth, FirebaseFirestore, FirebaseStorage.
6. Now create a Firestore Database and make sure that you can read and write to it. You can change this in the rules of the Database.
7. Create an Item in Firestore in the collection Items. It should look like this: ![](/explanationImage.png) Please upload an product image to Storage and the variable imagePath should contain the matching URL from FirebaseStorage.
8. Add FirebaseAuth with Email and Password as the sign-in method.
9. Now run the app in the simulator.

Usecases:<br/>
Create own items in the Firebase Database and get an idea of e-commerce.<br/>

Credits:<br/>
To create a star view, I used this code: https://swiftuirecipes.com/blog/star-rating-view-in-swiftui<br/>
These YouTube videos helped me understand Firebase: https://youtube.com/playlist?list=PLimqJDzPI-H-6rBS1I3VciIsAWG9RZa8o<br/>
Things to improve: <br/>
1.Rating system. To this day it is not possible to rate a product.
