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
        // background color normal UIColor ilə
        backgroundColor = UIColor(red: 61/255, green: 67/255, blue: 84/255, alpha: 1) // #3D4354
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
