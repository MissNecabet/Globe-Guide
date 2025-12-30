
import UIKit

class ChatMessageCell: UITableViewCell {

    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()

    private var leading: NSLayoutConstraint!
    private var trailing: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        bubbleView.layer.cornerRadius = 20
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)

        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(dateLabel)

        leading = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25)
        trailing = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            leading,
            trailing,

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),

            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        messageLabel.textColor = .white
        dateLabel.text = DateFormatter.localizedString(from: message.date, dateStyle: .none, timeStyle: .short)
        dateLabel.textColor = .white

        if message.type == .user {
            bubbleView.backgroundColor = UIColor(named:"user")
            leading.isActive = false
            trailing.isActive = true
        } else {
            bubbleView.backgroundColor = UIColor(named:"antiuser")
            trailing.isActive = false
            leading.isActive = true
        }
    }
}
