import Routing
import Vapor
import Foundation

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { req -> Future<View> in
        struct PollsContext: Codable {
            var allPolls: [Poll]
        }

        return Poll.query(on: req).all().flatMap(to: View.self) { polls in
            let context = PollsContext(allPolls: polls)
            return try req.view().render("home", context)
        }
    }

    router.get("poll", UUID.parameter) { req -> Future<View> in
        struct PollContext: Codable {
            var ttl: String
            var option1: String
            var option2: String
            var votes1: Int
            var votes2: Int
        }
        return Poll.find(try req.parameters.next(UUID.self), on: req)
            .flatMap(to: View.self) { poll in

                guard let poll = poll else {
                    throw Abort(.notFound)
                }

                let context = PollContext(ttl: poll.title,
                                          option1: poll.option1,
                                          option2: poll.option2,
                                          votes1: poll.votes1,
                                          votes2: poll.votes2)
                return try req.view().render("poll", context)
        }
    }

    router.group("polls", "api") { api in
        api.post(Poll.self, at: "polls") { req, poll -> Future<Poll> in
            return poll.save(on: req)
        }

        api.put("polls", UUID.parameter, Int.parameter) { req -> Future<Poll> in
            let id = try req.parameters.next(UUID.self)
            let vote = try req.parameters.next(Int.self)

            return Poll.find(id, on: req).flatMap(to: Poll.self) { poll in
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

        api.get("polls") { req -> Future<[Poll]> in
            return Poll.query(on: req).all()
        }

        api.get("poll", UUID.parameter) { req -> Future<Poll> in
            return Poll.find(try req.parameters.next(UUID.self), on: req).unwrap(or: Abort(.notFound))
        }

        api.delete("poll", UUID.parameter) { req -> Future<HTTPStatus> in
            return Poll.find(try req.parameters.next(UUID.self), on: req).unwrap(or: Abort(.notFound)).delete(on: req).transform(to: .noContent)

        }
    }
}
