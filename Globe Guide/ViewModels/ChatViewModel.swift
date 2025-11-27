import Foundation


class ChatViewModel {
    private(set) var messages: [ChatMessage] = []

    var didUpdateMessages: (() -> Void)?

    func sendMessage(_ text: String) {
        let userMessage = ChatMessage(text: text, type: .user, date: Date())
        messages.append(userMessage)

        // AI cavabı simulyasiya
        let aiMessage = ChatMessage(text: "AI response to: \(text)", type: .ai, date: Date())
        messages.append(aiMessage)

        didUpdateMessages?()
    }

    func message(at index: Int) -> ChatMessage {
        return messages[index]
    }

    func numberOfMessages() -> Int {
        return messages.count
    }
}


