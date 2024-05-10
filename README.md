# Firebase Authentication Project

A very simple project, to show case the `Firebase` authentication functionality. It has few simple `authentication` functionalities.

1. Login with `Email-and-Password`.
2. Create account with `Email-and-Password`.
3. Securely Store `Email-and-Password` with remember me feature.
4. Login/Register with `Google` account.
5. See few of the account details in `Dashboard/Homepage` screen.
6. And finally `logout` from the app.

## Special features

The project has few extra featured that was focused on.

1. Fully modularized and `clean-architecture` followed.
2. Feature based `directory` structured!
3. Fully `Responsive` UI.
4. Growable theme system.

## Initial Setup

To run the project, you have to have fully functional `Flutter` environment setup. And latest version(`3.19`) of Flutter is preferred.

> If you don't want to go through all this, there's a `.apk` file, inside the `<ProjectDirectory>/release/` folder. You can install it in your `Android` device, and test it from there!

Then create your own `FirebaseProject`. And set up your `Android` app and all the credentials. And don't forget to enable these features -

1. `Firebase-Authentication` -> `Email-Password Authentication`
2. `Firebase-Authentication` -> `Google Authentication`


Finally, just `copy` the `<ProjectDirectory>/env/statics.example.json` to `<ProjectDirectory>/env/statics.json` and you can adjust some minor things on that file. Then just `run` your Flutter app passing that file as an `environment-variable`. 
> Environment Setup for `VSCode` is already present in the project.