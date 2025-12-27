

import Foundation

enum MessageType {
    case user
    case guider
}

struct ChatMessage {
    let text: String
    let type: MessageType
    let date: Date
    let action: ChatAction?
}
