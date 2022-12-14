
import SwiftUI
import Firebase


class AuthLog: ObservableObject {
    
    @Published var userLogged: FirebaseAuth.User?
    
    init() {
        
        self.userLogged = Auth.auth().currentUser // store user curerently logged in, into the variable "userinfo"
        print ("current user is \(String(describing: self.userLogged))")
    }
    
    func logOut() {
        
        self.userLogged = nil
        
        let auth = Auth.auth()
        try? auth.signOut() // logout user from backend which in this case is firebase (Optional)
        
        
        
    }
    
    
    func login(withEmail email: String, password: String) { //parameters required for this function to be used
        
        
        Auth.auth().signIn(withEmail: email, password: password) { Result, error in // sign in will either produce a result or an error and perform right activity depending on what occurs
            if error != nil { // checks to see if there is an error - if so, print this statement below
                print("Could not login, \(error!.localizedDescription)")
                return
            }
            guard let user = Result?.user else {return} // fast exist, if result is succesful then return user
            
            self.userLogged = user
        }

    }
    
    func signup(withEmail email: String, firstname: String, lastname: String, username: String, password: String)
    { // as shown above these are the parameters that will be accpeted by the user when the function is executed
        Auth.auth().createUser(withEmail: email, password: password) { Result, error in // firebase code to authenticate user for sign up. will produce either a successful result or error with the sign up
            if error != nil {
                print(error!.localizedDescription)
                return // to ensure the function doesnt carry on if an error occurs during sign up
            }
            guard let user = Result?.user else {return}
            
            self.userLogged = user
            
            
            
            // assigns constant " data" to the following info so then the data can get retrieved
            let data = ["uid": user.uid, "username": username.lowercased(), "email": email, "firstname":firstname, "lastname": lastname]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData (data) { _ in
                    print("Uploaded users data...")
                }
        }
        
    }
    
    func resetPassword(withEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email ) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            else {
                print ("Check your inbox to reset password")
            }
        }
    }
       
    }
    

