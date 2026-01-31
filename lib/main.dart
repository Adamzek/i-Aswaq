import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const IAswaqApp());
}

class IAswaqApp extends StatelessWidget {
  const IAswaqApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'i-aswaq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

// Here are detailed study notes in Markdown format based on the provided handouts. They include concepts, explanations, and code examples.

// ---

// # Flutter Development Study Notes

// ## 1. Types of Mobile Applications

// There are three main categories of mobile applications, plus Flutter's unique approach.

// ### **Mobile Web**

// * 
// **Characteristics:** Uses responsive design to adapt to the device's screen size.


// * 
// **Requirements:** Requires an internet connection to connect to a web server.


// * **Limitations:**
// * Cannot be uploaded to app stores because it functions like a normal website without installation.


// * Does not have the same physical format as a native application.





// ### **Hybrid Applications**

// * 
// **Technology:** Uses unified programming languages (e.g., React Native, Flutter) to write one code base for all platforms (iOS, Android, Windows, etc.).


// * 
// **Process:** The unified code is converted automatically into the mobile platform's native code, allowing upload to app stores.


// * 
// **Benefit:** Reduces development time compared to native development.


// * 
// **Architecture:** Typically uses "Reactive Views" or "WebViews" to render content.



// ### **Native Applications**

// * 
// **Technology:** Requires mastering specific languages for each platform (e.g., Java for Android, Swift/Objective-C for iOS).


// * 
// **Pros:** Generally performs better than mobile web and hybrid applications.


// * 
// **Cons:** Requires separate coding and different skill sets for each platform.



// ### **Flutter Approach**

// * 
// **Architecture:** Flutter is neither strictly native nor hybrid; it uses its own architecture.


// * 
// **Performance:** It uses its own rendering engine (Skia), which performs faster than standard hybrid applications and rivals native performance.



// ---

// ## 2. Introduction to Flutter

// ### **How it Works**

// * 
// **Definition:** Flutter is a reactive, declarative, and composable view-layer library.


// * **Widget Concept:** "Everything is a widget." A widget is a Dart class that represents a view (layout, structure, style, animation).


// * **Composition:** Flutter favors composition over inheritance. Complex objects are built by combining simpler widgets.



// ### **Project Structure**

// When a Flutter project is created, it generates a specific directory structure:

// * 
// `android/`: Contains converted Kotlin native source code for Android.


// * 
// `ios/`: Contains converted Swift native source code for iOS.


// * 
// `lib/`: Contains the Dart source code for your application.


// * 
// `pubspec.yaml`: Configuration file for dependencies and assets.


// * 
// `main.dart`: The entry point of the application.



// ### **Basic Application Code**

// The entry point is `main()`, which calls `runApp()` to launch the root widget.

// ```dart
// import 'package:flutter/material.dart'; [cite_start]// Import UI library [cite: 214]

// void main() {
//   [cite_start]runApp( // Top level widget method [cite: 218]
//     [cite_start]Center( // Alignment widget [cite: 220]
//       child: Text(
//         'Hello, world!',
//         [cite_start]textDirection: TextDirection.ltr, // Text property [cite: 226]
//       ),
//     ),
//   );
// }

// ```

// ---

// ## 3. Widgets and State Management

// ### **Stateless Widgets**

// * 
// **Definition:** These widgets do *not* contain internal state (data) that changes during their lifetime.


// * 
// **Usage:** Used for static UI or layouts where data is passed in and doesn't change.


// * **Example:**
// ```dart
// class SubmitButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton( // Previously RaisedButton
//       child: Text('Submit'),
//       onPressed: () {},
//     );
//   }
// }

// ```






// ### **Stateful Widgets**

// * 
// **Definition:** These widgets contain internal data that can be updated.


// * 
// **Structure:** Must define a `createState` method to create an associated State object.


// * **`setState`:** A method used to trigger a rebuild. It tells Flutter that the internal state has changed and the UI needs to be repainted.



// ### **Stateful Widget Lifecycle**

// The lifecycle describes how a widget is built and updated:

// 1. 
// **`createState()`**: Creates the state object.


// 2. 
// **`initState()`**: Called immediately after the widget is mounted.


// 3. 
// **`build()`**: Builds the widget.


// 4. 
// **`setState()`**: Triggers a rebuild when data changes.


// 5. 
// **`dispose()`**: Called when the widget is removed from the tree.



// ### **Example: Counter with `setState**`

// ```dart
// void _incrementCounter() {
//   [cite_start]setState(() { // Updates the state object [cite: 350]
//     _counter++; [cite_start]// Internal private variable [cite: 351]
//   });
// }

// ```

// ---

// ## 4. UI Layout and Design

// ### **Structural Widgets**

// * 
// **`MaterialApp`**: A top-level widget that provides Material Design styling and navigation structure.


// * 
// **`Scaffold`**: Provides the basic visual layout structure, including `AppBar`, `body`, and `floatingActionButton`.



// ### **Layout Widgets**

// * **`Row`**: Aligns children horizontally. Flexible layout similar to FlexBox.


// * 
// **`Column`**: Aligns children vertically.


// * 
// *Note:* Placing a Column inside another unconstrained Column can cause an "infinite size error".




// * **`Stack`**: Layers widgets on top of each other. Uses `Positioned` widgets to place children relative to the stack's edges.


// * 
// **`Table`**: A strict layout where cells in columns/rows share widths/heights.



// ### **Example: Row Layout**

// ```dart
// Row(
//   [cite_start]mainAxisAlignment: MainAxisAlignment.spaceAround, // Spacing strategy [cite: 940]
//   children: <Widget>[
//     RaisedButton(
//       child: Text("Decrement"),
//       onPressed: _decrementCounter,
//     ),
//     RaisedButton(
//       child: Text("Increment"),
//       onPressed: _incrementCounter,
//     ),
//   ],
// )

// ```



// ### **Styling & Images**

// * 
// **`ThemeData`**: Controls global styles like colors and fonts.


// * 
// **`MediaQuery`**: Used to size widgets relative to the screen size (e.g., 80% of screen width).


// * **Images**:
// * 
// **Network**: `Image.network("url")`.


// * **Asset**: `Image.asset("path")`. Requires adding the file path to the `assets` section in `pubspec.yaml`.





// ---

// ## 5. Forms and Gestures

// ### **Gestures**

// * 
// **`GestureDetector`**: Wraps any widget to listen for interactions like `onTap`, `onDoubleTap`, `onLongPress`, etc..


// * 
// **`Dismissible`**: Implements "swipe to remove" functionality (requires a key).



// ### **Example: Tap Detection**

// ```dart
// GestureDetector(
//   [cite_start]onTap: () => print("tapped!"), // Interaction event [cite: 60]
//   child: Text("Tap Me"),
// );

// ```



// ### **Forms**

// * 
// **`Form`**: Manages the state of multiple form fields using a `GlobalKey<FormState>`.


// * 
// **`TextFormField`**: A specialized widget that wraps a text input field.


// * 
// **Validation**: The `validator` property checks input and returns an error string if invalid, or null if valid.


// * 
// **Focus**: `AutoFocus` allows changing focus when events trigger.



// ---

// ## 6. Routing (Navigation)

// ### **Basic Navigation**

// Flutter uses a `Navigator` widget to manage a stack of routes (screens).

// * 
// **`push()`**: Adds a new route to the top of the stack (navigates to it).


// * 
// **`pop()`**: Removes the current route from the stack (goes back).



// ### **Example: Push Navigation**

// ```dart
// onPressed: () {
//   Navigator.push(
//     context,
//     [cite_start]MaterialPageRoute(builder: (context) => SecondRoute()), // Destination [cite: 421]
//   );
// }

// ```



// ### **Named Routes**

// * 
// **Setup**: Define routes in the `MaterialApp` widget using a map of route names to widget builders.


// * 
// **Usage**: Use `Navigator.pushNamed()` to navigate using the string identifier.


// * 
// **Passing Arguments**: Use `onGenerateRoute` to extract arguments (`settings.arguments`) and pass them to the target widget.



// ---

// ## 7. Packages & Plugins

// ### **Definitions**

// * 
// **Packages**: Libraries created purely in Dart (similar to Java Packages).


// * 
// **Plugins**: Interfaces that interact with native platform code (Kotlin/Swift) via a bridge.



// ### **Installation**

// 1. Find a package on [pub.dev](https://pub.dev).


// 2. Add the dependency to `pubspec.yaml` under `dependencies`:
// ```yaml
// dependencies:
//   url_launcher: ^5.4.0

// ```





// 3. Run `flutter pub get` in the terminal to download it.



// ### **Firebase (FlutterFire)**

// * 
// **`firebase_core`**: Required to connect to Firebase.


// * 
// **`firebase_auth`**: Handles authentication (Google, Facebook, Email).


// * 
// **`cloud_firestore`**: NoSQL database with live synchronization.


// * 
// **Configuration**: Requires downloading `google-services.json`, placing it in `android/app`, and updating `build.gradle` files.



// ---

// ## 8. Rendering and Architecture

// ### **Render Objects**

// * 
// **Role**: `RenderObject` is responsible for the actual painting and layout on the screen.


// * **Constraints**: Parents pass constraints (min/max width/height) to children. Children choose their size within those constraints.


// * **Relationship**: Widgets are high-level abstractions; `RenderObject` performs the heavy lifting of calculating pixels.



// ### **Keys**

// Keys are used to preserve state when widgets move around the element tree.

// * 
// **`GlobalKey`**: Maintains state across the entire app.


// * 
// **`ValueKey`**: Differentiates widgets based on a simple value (e.g., items in a list).


// * 
// **`UniqueKey`**: Used when children are dynamic and don't have inherent values.