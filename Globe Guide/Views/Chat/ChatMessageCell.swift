
import UIKit
import UIKit

class ChatMessageCell: UITableViewCell {

    private let messageLabel = UILabel()
    private let bubbleView = UIView()
    private let dateLabel = UILabel()
    
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(dateLabel)
        
        bubbleView.layer.cornerRadius = 20
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = .white
        dateLabel.textAlignment = .right
        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            leadingConstraint,
            trailingConstraint,
            
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
        
        // Mesajın tarixini göstərir, ama nese sehflik var designda!!!!!!!
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: message.date)
        
        // Mesajın rəngi və hizalanması
        if message.type == .user {
            // Mənim mesajım
            bubbleView.backgroundColor = UIColor(red: 0.48, green: 0.51, blue: 0.58, alpha: 1.0)
            messageLabel.textColor = .white
            dateLabel.textColor = .white
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            // Qarşı tərəf mesajı
            bubbleView.backgroundColor = UIColor(red: 0.22, green: 0.24, blue: 0.30, alpha: 1.0)
            messageLabel.textColor = .white
            dateLabel.textColor = .white
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        }

    }
}

