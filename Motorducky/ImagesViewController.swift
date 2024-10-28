import UIKit

class ImageViewController: UIViewController {
    
    var imageUrl: URL? // This will hold the URL of the image to display
    
    @IBOutlet weak var imageView: UIImageView! // This should be connected in the storyboard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the image once the view has loaded
        if let imageUrl = imageUrl {
            loadImage(from: imageUrl)
        }
    }
    
    // Function to load the image from the provided URL
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image data")
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
