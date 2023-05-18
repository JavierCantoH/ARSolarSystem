//
//  LoginRouterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 18/05/23.
//

import Foundation
import UIKit

protocol LoginRouterProtocol: AnyObject {
    static func launch(onLoginSuccess: @escaping(UserResult) -> Void) -> UIViewController
}
