import Foundation

class ChatViewModel {

    private(set) var messages: [ChatMessage] = []
    var didUpdateMessages: (() -> Void)?

    init() {
        sendWelcomeMessages()
    }

    private func sendWelcomeMessages() {
        messages.append(ChatMessage(
            text: "Hi 👋 I’m your travel guider.",
            type: .guider,
            date: Date(),
            action: nil
        ))

        messages.append(ChatMessage(
            text: "You can explore places directly on the map.",
            type: .guider,
            date: Date(),
            action: nil
        ))

        messages.append(ChatMessage(
            text: "📍 See on the map",
            type: .guider,
            date: Date(),
            action: .openMap
        ))
    }

    func sendMessage(_ text: String) {

        messages.append(ChatMessage(
            text: text,
            type: .user,
            date: Date(),
            action: nil
        ))

        // hər mesajdan sonra map təklifi
        messages.append(ChatMessage(
            text: "📍 See on the map",
            type: .guider,
            date: Date(),
            action: .openMap
        ))

        didUpdateMessages?()
    }

    func message(at index: Int) -> ChatMessage {
        messages[index]
    }

    func numberOfMessages() -> Int {
        messages.count
    }
}
