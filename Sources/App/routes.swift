import Routing
import Vapor
import Foundation

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.post(Poll.self, at: "polls") { req, poll -> Future<Poll> in
        return poll.save(on: req)
    }

    router.put("polls", UUID.parameter, Int.parameter) { req -> Future<Poll> in
        let id = try req.parameters.next(UUID.self)
        let vote = try req.parameters.next(Int.self)

        return try Poll.find(id, on: req).flatMap(to: Poll.self) { poll in
            guard var poll = poll else {
                throw Abort(.notFound)
            }

            if vote == 1 {
                poll.votes1 += 1
            } else {
                poll.votes2 += 1
            }

            return poll.save(on: req)
        }
    }

    router.get("polls") { req -> Future<[Poll]> in
        return Poll.query(on: req).all()
    }

    router.get("poll", UUID.parameter) { req -> Future<Poll> in
        return Poll.find(try req.parameters.next(UUID.self), on: req).unwrap(or: Abort(.notFound))
    }
}
