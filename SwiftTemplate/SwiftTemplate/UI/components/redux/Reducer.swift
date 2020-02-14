//
//  Reducer.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

public protocol Reducer: class {

    associatedtype State: ViewState
    associatedtype Event
    
    func reduce(state: State, event: Event) -> State
    
    var newStateHandler: ((State)->Void)? { get set }
}

public class AnyReducer<T: ViewState, E>: Reducer {

    public var newStateHandler: ((T) -> Void)? {
        didSet {
            self._didSetStateHandler(newStateHandler)
        }
    }

    private let _reduce: (T, E) -> T
    private let _didSetStateHandler: ((((T) -> Void)?)->Void)
    
    public init<U: Reducer>(_ reducer: U) where U.State == T, U.Event == E {

        _reduce = { state, event in
            
            reducer.reduce(state: state, event: event)
        }

        _didSetStateHandler = { handler in
            
            reducer.newStateHandler = handler
        }
    }

    public func reduce(state: T, event: E) -> T {

        return _reduce(state, event)
    }
}

