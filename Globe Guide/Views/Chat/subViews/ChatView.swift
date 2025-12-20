

import UIKit

class ChatView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let inputViewBar = ChatInputView()
    
    var viewModel: ChatViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        addSubview(tableView)
        addSubview(inputViewBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        inputViewBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputViewBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputViewBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputViewBar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            inputViewBar.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputViewBar.topAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        
        inputViewBar.onSend = { [weak self] text in
            self?.viewModel?.sendMessage(text)
        }
    }
    
    func reloadData() { tableView.reloadData() }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel!.messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        cell.configure(with: message)
        return cell
    }
}
