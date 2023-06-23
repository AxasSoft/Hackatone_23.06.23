//
//  InitialModel.swift
//  hackathon
//
//  Created by Денис Чупров on 23.06.2023.
//

import Foundation
import PromiseKit

final class InitialModel {

    func auth(login: String, password: String) -> Promise<RudAPI<SignUp>> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
       
        let param: [String: Encodable] = [
            "login": login,
            "password": password
        ]
        
        let wrappedDict = param.mapValues(NetCoreStruct.EncodableWrapper.init(wrapped:))
        let data: Data? = try? encoder.encode(wrappedDict)
        let urlString = NetworkManager.baseURLString.appending("/api/v1/sign-in/")
        let url = URL(string: urlString)
        return CoreNetwork.request(method: .POST(url: url!, body: data!))
    }
}


// MARK: SIGN UP RESPONSE
struct RudAPI <T: Codable>: Codable {
    let message: String?
    let description: String?
    let data: T?
}

struct SignUp: Codable {
    let accessToken: String?
    //let user: Profile?
}

//struct Profile: Codable {
//    let id: Int?
//    let login, firstName, patronymic, lastName: String?
//    let avatar: String?
//    let position: Position?
//    let userType: Int?
//    let company: Company?
//    let group: Group?
//}

 
