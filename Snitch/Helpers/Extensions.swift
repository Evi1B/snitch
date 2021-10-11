//
//  Extensions.swift
//  test
//
//  Created by evilb on 02.10.2021.
//

import Foundation
import UIKit

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UInt32.max))
  }
  static func random(min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min < max)
    return CGFloat.random() * (max - min) + min
  }
}
