import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.post("polls", "create") { req -> Future<Poll> in
        let poll = Poll(id: nil, title: "Title", option1: "Option 1", option2: "Option 2", votes1: 0, votes2: 0)
        return Future.map(on: req) { return poll }
    }

    router.get("polls", "list") { req -> Future<[Poll]> in
        let poll = Poll(id: nil, title: "Title", option1: "Option 1", option2: "Option 2", votes1: 0, votes2: 0)
        return Future.map(on: req) { return [poll] }
    }
}
