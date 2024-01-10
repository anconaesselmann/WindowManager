//  Created by Axel Ancona Esselmann on 12/16/23.
//

import SwiftUI
import ToolbarManager
import Combine

@MainActor
public protocol ToolbarControlledWindowViewModel: AnyObject, ObservableObject {

    associatedtype Element
        where Element: ToolbarElement

    associatedtype Windows
        where
            Windows: WindowType,
            Windows: Hashable

    var toolbarElement: Element { get }
    var window: Windows { get }

    var toolbarManager: ToolbarManager { get }
    var windowManager: WindowManager<Windows> { get }

    var bag: Set<AnyCancellable> { get set }

    var onClose: (() -> Void)? { get set }

    func subscribeToToolbar()
    func _onDisappear()
    func onDisappear()
    func register()

    func didClose()
}

public extension ToolbarControlledWindowViewModel {
    func onDisappear() {

    }

    func subscribeToToolbar() {
        toolbarManager
            .events(
                [.release],
                for: toolbarElement
            ).sink { [weak self] event in
                self?.onClose?()
                self?.didClose()
            }.store(in: &bag)
    }

    func _onDisappear() {
        toolbarManager.unset(toolbarElement)
        onDisappear()
    }

    func register() {
        if !toolbarManager.isPressed(toolbarElement) {
            toolbarManager.set(toolbarElement)
        }
    }

    func didClose() {
        windowManager.didClose(window)
    }
}

public struct WindowModifier<VM>: ViewModifier
    where VM: ToolbarControlledWindowViewModel
{
    @Environment(\.dismiss)
    var dismiss: DismissAction

    var vm: VM

    public func body(content: Content) -> some View {
        content
            .task {
                vm.register()
                vm.onClose = {
                    dismiss()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { newValue in
                guard let rawValue = (newValue.object as? NSWindow)?.identifier?.rawValue else {
                    return
                }
                if rawValue == vm.window.rawValue {
                    vm._onDisappear()
                    vm.didClose()
                }
            }
    }
}

public extension View {
    func window<VM: ToolbarControlledWindowViewModel>(_ vm: VM) -> some View {
        self.modifier(WindowModifier(vm: vm))
    }
}
