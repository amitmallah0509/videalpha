# Vide Alpha Project

A vide alpha project created in flutter using MVVM and Provider. it supports both mobile platform Android & iOS, clone the appropriate branches mentioned below:

https://github.com/amitmallah0509/videalpha/tree/master

## Getting Started

The VideAlpha contains the minimal implementation required to create a project. The repository code is preloaded with some basic components like basic app architecture, app theme, constants and required dependencies to create a new project. By using vide alpha code as standard initializer, we can have same patterns in all the projects that will inherit it. This will also help in reducing setup & development time by allowing you to use same code pattern and avoid re-writing from scratch.

## How to Use

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/amitmallah0509/videalpha.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
```

**Step 3:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

**Step 4:**

To Run project on device the following command:

```
flutter run
```

## Vide Alpha Features:

- Splash
- Login
- Profile
- Routing
- Firestore Auth, Database
- Provider (State Management) with MVVM Pattern

### Folder Structure

Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- assets
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- common_view/
|- model/
|- routes/
|- utilities/
|- view/
|- view_model/
|- app.dart
|- main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- common_view - the common widgets for your applications. For example, Button, TextField etc.
2- model - The model represents a single source of truth that carries the real-time fetch data or database-related queries. This layer can contain business logic, code validation, etc. This layer interacts with ViewModel for local data or for real-time. Data are given in response to ViewModel.
3- routes — This file contains all the routes for your application.
4- utilities — Contains the utilities/common functions of your application.
5- view — Contains all the ui of your project, contains sub directory for each screen.
6- view_model — ViewModel is the mediator between View and Model, which accept all the user events and request that to Model for data. Once the Model has data then it returns to ViewModel and then ViewModel notify that data to View.
7- app.dart - This is the root widget of the application.
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```
