//
//  Storyboarded.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

protocol Storyboarded { }

extension Storyboarded where Self: UIViewController {

    static func instantiateFrom(storyboard: UIStoryboard) -> Self {

        let storyboardIdentifier = String(describing: self)

        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
