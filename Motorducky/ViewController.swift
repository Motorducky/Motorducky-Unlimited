import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let motorDuckyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let locationManager = CLLocationManager()
    let centerLocation = CLLocation(latitude: 36.003404, longitude: -81.567177)
    let allowedDistanceFeet: Double = 1500

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupGeolocationServices()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(motorDuckyButton)
        
        NSLayoutConstraint.activate([
            motorDuckyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            motorDuckyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            motorDuckyButton.widthAnchor.constraint(equalToConstant: 200),
            motorDuckyButton.heightAnchor.constraint(equalToConstant: 200)
        ])

        if let image = UIImage(named: "Motorducky_Logo_light") {
            motorDuckyButton.setImage(image, for: .normal)
            motorDuckyButton.imageView?.contentMode = .scaleAspectFit
        }

        motorDuckyButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupGeolocationServices() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    @objc private func buttonTapped() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            showAlert("Quack!", "Enable location services to proceed.")
        }
    }

    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        let distanceInFeet = userLocation.distance(from: centerLocation) * 3.28084
        if distanceInFeet <= allowedDistanceFeet {
            // Fire webhook or execute action
            showAlert("Success!", "You have quacked the duck.")
        } else {
            showAlert("Cannot Quack", "Get closer to quack the duck!")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showAlert("Error", "Failed to get location.")
    }
}
