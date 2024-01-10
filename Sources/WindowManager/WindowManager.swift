//  Created by Axel Ancona Esselmann on 12/9/23.
//

import SwiftUI

public class WindowManager<Windows> 
    where 
        Windows: WindowType,
        Windows: Hashable
{

    private var openWindow: ((Windows) -> Void)?

    private var openWindows = Set<Windows>()

    public init() {}

    public func set(_ callback: @escaping (Windows) -> Void) {
        openWindow = callback
    }

    public func open(_ window: Windows) {
        guard !openWindows.contains(window) else {
            return
        }
        openWindows.insert(window)
        Task { @MainActor in
            if window == .settings {
#if os(macOS)
                NSApp.openSettings()
#else
                ()
#endif
            } else {
                openWindow?(window)
            }
        }
    }

    public func didClose(_ window: Windows) {
        openWindows.remove(window)
    }
}
