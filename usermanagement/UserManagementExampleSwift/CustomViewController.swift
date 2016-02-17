//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

//
// For more information on setting up and running this sample code, see
// https://developers.google.com/firebase/docs/auth/ios/user-auth
//

import UIKit

// [START usermanagement_view_import]
import FirebaseAuth
import Firebase.Core
import FirebaseFacebookAuthProvider
import FirebaseGoogleAuthProvider
// [END usermanagement_view_import]

@objc(CustomViewController)
class CustomViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {

  /*! @var kSignedInAlertTitle
  @brief The text of the "Sign In Succeeded" alert.
  */
  let kSignedInAlertTitle = "Signed In"

  /*! @var kSignInErrorAlertTitle
  @brief The text of the "Sign In Encountered an Error" alert.
  */
  let kSignInErrorAlertTitle = "Sign-In Error"

  /*! @var kOKButtonText
  @brief The text of the "OK" button for the Sign In result dialogs.
  */
  let kOKButtonText = "OK"

  @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
  @IBOutlet weak var signInButton: GIDSignInButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    GIDSignIn.sharedInstance().clientID = FIRContext.sharedInstance().serviceInfo.clientID
    GIDSignIn.sharedInstance().uiDelegate = self

    // TODO(developer): Configure the sign-in button look/feel
    GIDSignIn.sharedInstance().delegate = self

    let loginButton = FBSDKLoginButton()
    loginButton.delegate = self
  }

  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }

    // [START headless_facebook_auth]
    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)

    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
      if let error = error {
        self.showMessagePrompt(error.localizedDescription)
        return
      }

      self.showMessagePrompt(user!.displayName ?? "Display name is not set for user")
      // [START_EXCLUDE]
      self.performSegueWithIdentifier("CustomSignIn", sender: nil)
      // [END_EXCLUDE]
    }
    // [END headless_facebook_auth]
  }

  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    self.showMessagePrompt("User logged out!")
  }

  // [START headless_google_auth]
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }

    let authentication = user.authentication
    let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)

    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
      // [END headless_google_auth]
      if let error = error {
        print(error.localizedDescription)
        return
      }

      self.showMessagePrompt(user!.displayName ?? "Display name is not set for user")
      self.performSegueWithIdentifier("CustomSignIn", sender: nil)
    }
  }

  @IBAction func didTapEmailLogin(sender: AnyObject) {
    // [START headless_email_auth]
    FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
      // [END headless_email_auth]
      if let error = error {
        self.showMessagePrompt(error.localizedDescription)
        return
      }

      self.showMessagePrompt(user!.displayName ?? "Display name is not set for user")
      self.performSegueWithIdentifier("CustomSignIn", sender: nil)
    }
  }

  /** @fn requestPasswordReset
  @brief Requests a "password reset" email be sent.
  */
  @IBAction func didRequestPasswordReset(sender: AnyObject) {
    showTextInputPromptWithMessage("Email:") { (userPressedOK, userInput) in
      if (userPressedOK != true) || userInput!.isEmpty {
        return
      }

      self.showSpinner({
        // [START password_reset]
        FIRAuth.auth()!.sendPasswordResetWithEmail(userInput!) { (error) in
          // [END password_reset]
          self.hideSpinner({
            if let error = error {
              self.showMessagePrompt(error.localizedDescription)
              return
            }

            self.showMessagePrompt("Sent")
          })
        }
      })
    }
  }

  /** @fn getProvidersForEmail
  @brief Prompts the user for an email address, calls @c FIRAuth.getProvidersForEmail:callback:
  and displays the result.
  */
  @IBAction func didGetProvidersForEmail(sender: AnyObject) {
    showTextInputPromptWithMessage("Email:") { (userPressedOK, userInput) in
      if (userPressedOK != true) || userInput!.isEmpty {
        return
      }

      self.showSpinner({
        // [START get_providers]
        FIRAuth.auth()!.getProvidersForEmail(userInput!) { (providers, error) in
          // [END get_providers]
          self.hideSpinner({
            if let error = error {
              self.showMessagePrompt(error.localizedDescription)
              return
            }

            self.showMessagePrompt(providers!.joinWithSeparator(", "))
          })
        }
      })
    }
  }

  @IBAction func didCreateAccount(sender: AnyObject) {
    showTextInputPromptWithMessage("Email:") { (userPressedOK, email) in
      if (userPressedOK != true) || email!.isEmpty {
        return
      }

      self.showTextInputPromptWithMessage("Password:") { (userPressedOK, password) in
        if (userPressedOK != true) || password!.isEmpty {
          return
        }

        self.showSpinner({
          // [START create_user]
          FIRAuth.auth()!.createUserWithEmail(email!, password: password!) { (user, error) in
            // [END create_user]
            self.hideSpinner({
              if let error = error {
                self.showMessagePrompt(error.localizedDescription)
                return
              }

              self.showMessagePrompt(user!.email!)
            })
          }
        })
      }
    }
  }
}