import UIKit

class TextViewController: UIViewController {

    let textView = UITextView()
    let titleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Ensure the view's background is white
        setupTitleLabel()
        setupTextView()
        fetchText()
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Build Log"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18) // Bold title
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white // Ensure the label's background is white
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    private func setupTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = .white // Ensure text view background is white
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16) // Adjust insets for margin
        textView.font = UIFont.systemFont(ofSize: 15) // Set to 15 points
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    private func fetchText() {
        guard let url = URL(string: "https://motorducky.com/talkingduck_buildlog.txt") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            if let text = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.displayTextWithBoldDates(text: text)
                }
            }
        }
        task.resume()
    }

    private func displayTextWithBoldDates(text: String) {
        let attributedText = NSMutableAttributedString(string: text)
        let pattern = "\\d{4}-\\d{2}-\\d{2}"

        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))

            for match in matches {
                attributedText.addAttributes([.font: UIFont.boldSystemFont(ofSize: 15)], range: match.range)
            }
        }

        textView.attributedText = attributedText
    }
}
