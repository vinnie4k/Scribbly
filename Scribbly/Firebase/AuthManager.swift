//
//  AuthManager.swift
//  Scribbly
//
//  Created by Vin Bui on 1/10/23.
//

import FirebaseAuth
import Firebase

// MARK: AuthManager
class AuthManager {
    static private let auth = Auth.auth()
    static private var verificationID: String?
    
    /// Get the current user id
    static func currentUserID(completion: @escaping (String?) -> Void) {
        guard let userID = AuthManager.auth.currentUser?.uid else {
            print("Error retrieving current user ID.")
            completion(nil)
            return
        }
        completion(userID)
    }
    
    /// Begin the phone number authentication process
    static func startAuth(number: String, completion: @escaping (Bool) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
            guard let verificationID = verificationID, error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            AuthManager.verificationID = verificationID
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID") // In case user closes out
            completion(true)
        }
    }
    
    /// Verify a code sent to a phone number
    static func verifyCode(code: String, completion: @escaping (Bool) -> Void) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        guard let verificationID = verificationID else {
            completion(false)
            return
        }
        
        let creds = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        AuthManager.auth.signIn(with: creds) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}
