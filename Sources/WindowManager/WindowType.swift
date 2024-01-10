//  Created by Axel Ancona Esselmann on 1/10/24.
//

import Foundation

public protocol WindowType: RawRepresentable {
    var rawValue: String { get }
    static var settings: Self { get }
}
