//
//  EventPublisher.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//
// https://www.swiftbysundell.com/articles/building-custom-combine-publishers-in-swift/#building-a-publisher-from-the-ground-up
// https://www.avanderlee.com/swift/custom-combine-publisher/

import UIKit
import Combine

extension UIControl {
    
    // MARK: - EventPublisher
    
    struct EventPublisher: Publisher {
     
        // Declaring that our publisher doesn't emit any values,
        // and that it can never fail:
        typealias Output = Void
        typealias Failure = Never

        fileprivate let control: UIControl
        fileprivate let event: Event
        
        // MARK: - Initializer
        
        init(control: UIControl, event: Event) {
            self.control = control
            self.event = event
        }

        // Combine will call this method on our publisher whenever
        // a new object started observing it. Within this method,
        // we'll need to create a subscription instance and
        // attach it to the new subscriber:
        func receive<S: Subscriber>(
            subscriber: S
        ) where S.Input == Output, S.Failure == Failure {
            // Creating our custom subscription instance:
            let subscription = EventSubscription(target: subscriber)
            
            // Attaching our subscription to the subscriber:
            subscriber.receive(subscription: subscription)

            // Connecting our subscription to the control that's
            // being observed:
            control.addTarget(subscription,
                action: #selector(subscription.eventHandler),
                for: event
            )
        }
        
    }
    
    // MARK: - create EventPublisher
    
    func publisher(for event: Event) -> EventPublisher {
        EventPublisher(control: self, event: event)
    }
}

// MARK: - EventSubscription

private extension UIControl {
    
    /// A custom subscription to capture UIControl target events.
    final class EventSubscription<Target: Subscriber>: Subscription
    where Target.Input == Void {
        
        private var target: Target?
        
        // MARK: - initialiser

        init(target: Target) {
            self.target = target
        }
        
        // This subscription doesn't respond to demand, since it'll
        // simply emit events according to its underlying UIControl
        // instance, but we still have to implement this method
        // in order to conform to the Subscription protocol:
        func request(_ demand: Subscribers.Demand) {
            // We do nothing here as we only want to send events when they occur.
            // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
        }

        func cancel() {
            // When our subscription was cancelled, we'll release
            // the reference to our target to prevent any
            // additional events from being sent to it:
            target = nil
        }

        @objc func eventHandler() {
            // Whenever an event was triggered by the underlying
            // UIControl instance, we'll simply pass Void to our
            // target to emit that event:
            _ = target?.receive(())
        }
    }
}
