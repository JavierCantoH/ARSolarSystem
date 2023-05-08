//
//  RegisterRouterProtocol.swift
//  ARSolarSystem
//
//  Created by Luis Javier Canto Hurtado on 05/05/23.
//

import Foundation
import UIKit

protocol RegisterRouterProtocol: AnyObject {
    static func launch(onRegisterSuccess: @escaping(UserResult) -> Void) -> UIViewController
}
