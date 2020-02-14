//
//  EventHandler.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

import Foundation

public protocol EventHandler: class {

    associatedtype Event

    func handle(event: Event)
}

public class AnyEventHandler<E>: EventHandler {

    private let _handle: (E) -> Void

    public init<U: EventHandler>(_ eventHandler: U) where U.Event == E {

        _handle = { event in

            eventHandler.handle(event: event)
        }
    }

    public func handle(event: E) {
        _handle(event)
    }
}

