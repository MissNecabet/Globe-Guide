import UIKit

enum ChatAction {
    case openMap
}
import UIKit

class ChatViewController: UIViewController {

    private let tableView = UITableView()
    private let inputViewBar = ChatInputView()
    private let viewModel = ChatViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named:"ChatBg")


        setupTableView()
        setupInputView()
        bindViewModel()
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])

        tableView.delegate = self
        tableView.dataSource = self
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

    private func bindViewModel() {
        viewModel.didUpdateMessages = { [weak self] in
            guard let self = self else { return }

            self.tableView.reloadData()

            let lastIndex = IndexPath(
                row: self.viewModel.numberOfMessages() - 1,
                section: 0
            )
            self.tableView.scrollToRow(
                at: lastIndex,
                at: .bottom,
                animated: true
            )
        }
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfMessages()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChatMessageCell",
            for: indexPath
        ) as! ChatMessageCell

        let message = viewModel.message(at: indexPath.row)
        cell.configure(with: message)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let message = viewModel.message(at: indexPath.row)

        if message.action == .openMap {
            openOnMap()
        }
    }

    private func openOnMap() {
        guard let nav = navigationController else { return }

        for vc in nav.viewControllers {
            if vc is MapViewController {
                nav.popToViewController(vc, animated: true)
                return
            }
        }
    }
}
