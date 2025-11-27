import UIKit

class ChatInputView: UIView {

    let textField = UITextField()
    let sendButton = UIButton(type: .system)

    var onSend: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = UIColor(hex: "#3D4354")
        layer.cornerRadius = 25
        clipsToBounds = true

        addSubview(textField)
        addSubview(sendButton)

        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        textField.placeholder = "Message"
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Message",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )

        sendButton.setTitle("→", for: .normal)
        sendButton.tintColor = .gray
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func sendTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        onSend?(text)
        textField.text = ""
    }
}
    // chat gpt terefinden verilmis hex rengler. rgb ye sonra kecid edersen
extension UIColor {
    convenience init(hex: String) {
        var hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") { hexFormatted.remove(at: hexFormatted.startIndex) }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let r = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8)/255.0
        let b = CGFloat(rgbValue & 0x0000FF)/255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
