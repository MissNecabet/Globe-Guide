
import Foundation

class OpenAIService {
    static let shared = OpenAIService()
    
    func getResponse(for prompt: String, completion: @escaping (String) -> Void) {
     //  muveqqeti demo ai caqirirsi bele olacaq. duzelt bunu sonra!
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion("AI: Response to '\(prompt)'")
        }
    }
}
