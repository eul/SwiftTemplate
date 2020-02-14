//
//  ViewState.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import UIKit

public protocol ViewState: Equatable {}

public extension Equatable where Self: ViewState {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return false
    }
}

public enum RenderPolicy {
    case possible
    case notPossible(RenderError)

    public enum RenderError {
        case viewNotReady
        case viewDeallocated
    }

    var canBeRendered: Bool {
        switch self {
        case .possible:
            return true
        case .notPossible:
            return false
        }
    }
}

public protocol StateViewer: class, CustomLogDescriptionConvertible {

    associatedtype State: ViewState
    associatedtype Event

    func render(state: State)
    var renderPolicy: RenderPolicy { get }
    var eventHandler: AnyEventHandler<Event>? { get set }
}

public extension StateViewer where Self: UIViewController {
    var renderPolicy: RenderPolicy {
        return isViewLoaded ? .possible : .notPossible(.viewNotReady)
    }

    var logDescription: String {
        return title ?? String(describing: type(of: self))
    }
}

public extension StateViewer where Self: UIView {
    var renderPolicy: RenderPolicy {
        return superview != nil ? .possible : .notPossible(.viewNotReady)
    }

    var logDescription: String {
        return String(describing: type(of: self))
    }
}

public class AnyStateViewer<T: ViewState, E>: StateViewer {

    public var eventHandler: AnyEventHandler<E>?
    
    public typealias State = T
    public typealias Event = E
    
    private let _render        : (T) -> Void
    private let _logDescription: () -> String
    private let _renderPolicy  : () -> RenderPolicy
    private let _eventHandler  : () -> AnyEventHandler<E>?

    let identifier: String
    
    public init<U: StateViewer>(_ stateViewer: U) where U.State == T, U.Event == E {
        _render = { [weak stateViewer] state in
            stateViewer?.render(state: state)
        }

        _logDescription = { [weak stateViewer] in
            stateViewer?.logDescription ?? "Deallocated view"
        }

        _renderPolicy = { [weak stateViewer] in
            stateViewer?.renderPolicy ?? .notPossible(.viewDeallocated)
        }

        _eventHandler = { [weak stateViewer] in
            stateViewer?.eventHandler
        }

      //  self.eventHandler = stateViewer.eventHandler

        identifier = String(describing: stateViewer)
    }
    
    public func render(state: T) {
        guard renderPolicy.canBeRendered else {
            fatalError("""
            View is not ready to be rendered.
            This usually happens when trying to render a view controller that is not ready yet (viewDidLoad
            hasn't been called yet and outlets are not ready) or a view that is not on the screen yet. To avoid
            this problem, try using `viewModel.subscribe(from: self)` from the view layer when the view or
            view controller are ready to be rendered.
            """)
        }
        _render(state)
    }

    public var renderPolicy: RenderPolicy {
        return _renderPolicy()
    }

    public var logDescription: String {
        return _logDescription()
    }
}
