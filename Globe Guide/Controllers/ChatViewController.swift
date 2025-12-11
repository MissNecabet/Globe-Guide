import UIKit

class ChatViewController: UIViewController {

    private let tableView = UITableView()
    private let inputViewBar = ChatInputView()
    private let viewModel = ChatViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(
            red: 27/255,
            green: 32/255,
            blue: 45/255,  
            alpha: 1
        )

        setupProfileHeader()
        setupTableView()
        setupInputView()
        bindViewModel()
    }
// chatMessageCell de yazilan mesajin uzunluquna esasen design tenzimlenmelidir. 
    private func setupProfileHeader() {
        let profileView = UIView()
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)

        let imageView = UILabel()
        imageView.text = "YG"
        imageView.textAlignment = .center
        imageView.backgroundColor = UIColor.gray
        imageView.textColor = .white
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(imageView)

        let nameLabel = UILabel()
        nameLabel.text = "Your Guider"
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileView.heightAnchor.constraint(equalToConstant: 60),

            imageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: profileView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: profileView.centerYAnchor)
        ])
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }

    private func setupInputView() {
        inputViewBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(inputViewBar)

        NSLayoutConstraint.activate([
            inputViewBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37),
            inputViewBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            inputViewBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            inputViewBar.heightAnchor.constraint(equalToConstant: 50)
        ])

        inputViewBar.onSend = { [weak self] text in
            self?.viewModel.sendMessage(text)
        }
    }
// her yeni mesaj elave edildikde caqiirlir
    private func bindViewModel() {
        tableView.delegate = self
        tableView.dataSource = self

        viewModel.didUpdateMessages = { [weak self] in
            self?.tableView.reloadData()
            guard let self = self else { return }
            let lastIndex = IndexPath(row: self.viewModel.numberOfMessages() - 1, section: 0)
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        }
    }
}
// table vieewdan istifade
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMessages()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }

        let message = viewModel.message(at: indexPath.row)
        cell.configure(with: message)
        return cell
    }
}
