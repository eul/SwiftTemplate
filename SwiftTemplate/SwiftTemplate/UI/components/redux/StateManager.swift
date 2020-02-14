//
//  StateManager.swift
//  SwiftTemplate
//
//  Created by Yevhen Liashenko on 2/14/20.
//  Copyright © 2020 Yevhen Liashenko. All rights reserved.
//

class StateManager<S: ViewState, E>: EventHandler {

    typealias Event = E

    var state      : S
    var reducer    : AnyReducer<S,E>
    var stateViewer: AnyStateViewer<S,E>

    init<SV: StateViewer, R: Reducer>(state: S, reducer: R, stateViewer: SV)
        where SV.State == S, SV.Event == E, R.State == S, R.Event == E {

        self.state       = state
        self.reducer     = AnyReducer.init(reducer)
        self.stateViewer = AnyStateViewer.init(stateViewer)

        self.reducer.newStateHandler = {[weak self] newState in
            
            self?.state = newState
            self?.stateChanged()
        }

        stateViewer.eventHandler = AnyEventHandler.init(self)
//        observeStateChanges{
//
//            stateChanged()
//        }
    }

    func handle<E>(event: E) {
        
        guard let event = event as? Event else {
            return
        }

        let oldState = state

        self.state = reducer.reduce(state: state, event: event)

        if oldState != state {
            stateChanged()
        }
    }

    private func stateChanged() {

        stateViewer.render(state: state)
    }
}

