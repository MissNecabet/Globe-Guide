

import Foundation

enum MessageType {
    case user
    case ai
}

struct ChatMessage {
    let text: String
    let type: MessageType
    let date: Date
}
