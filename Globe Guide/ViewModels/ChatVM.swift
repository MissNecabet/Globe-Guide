import Foundation
@MainActor
class ChatViewModel {
    private let geocodeVM = GoogleGeocodeViewModel()

    private(set) var messages: [ChatMessage] = []
    var didUpdateMessages: (() -> Void)?
    init() {
           sendWelcomeMessages()
       }
    
    private func sendWelcomeMessages() {
        messages.append(ChatMessage(
            text: "Hi my friend,  I’m your travel guider.",
            type: .guider,
            date: Date(),
            action: nil
        ))

        messages.append(ChatMessage(
            text: "pls, ask me anything abou any place you want!?",
            type: .guider,
            date: Date(),
            action: nil
        ))
     }

    @MainActor func sendMessage(_ text: String) {

       
        messages.append(ChatMessage(
            text: text,
            type: .user,
            date: Date(),
            action: nil
        ))

        // * ile başlayan sözü tapir
        let words = text.split(separator: " ")
        let starredWord = words.first { $0.hasPrefix("*") }

        guard let word = starredWord else {
            messages.append(ChatMessage(
                text: "Pls enter your place with the beginning of * (for example: *baku)",
                type: .guider,
                date: Date(),
                action: nil
            ))
            didUpdateMessages?()
            return
        }

        let query = String(word.dropFirst())

       // evvelceden verilecek cavaba esasen yoxlamilir. bele bir olkenin olub olmamasi
        geocodeVM.loadGeocode(for: query) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {

                switch result {
                case .success:
                    self.messages.append(ChatMessage(
                        text: "📍 See on the map",
                        type: .guider,
                        date: Date(),
                        action: .openMap(query: query)
                    ))

                case .failure:
                    self.messages.append(ChatMessage(
                        text: "There is no such region name,try again",
                        type: .guider,
                        date: Date(),
                        action: nil
                    ))
                }

                self.didUpdateMessages?()
            }
        }
    }


    func message(at index: Int) -> ChatMessage {
        messages[index]
    }

    func numberOfMessages() -> Int {
        messages.count
    }
}
