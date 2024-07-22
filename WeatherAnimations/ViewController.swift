//
//  ViewController.swift
//  WeatherAnimations
//
//  Created by Uliana Lukash on 21.07.2024.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    // MARK: Private Properties
    
    private var lightningTimer: Timer?
    
    private let rainNode = SKEmitterNode(fileNamed: "RainParticle.sks")!
    private let fogNode = SKEmitterNode(fileNamed: "FogParticle.sks")!
    private let snowNode = SKEmitterNode(fileNamed: "SnowParticle.sks")!
    
    lazy private var fogSkView = SKView()
    lazy private var rainSkView = SKView()
    lazy private var snowSkView = SKView()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .lightGray
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
         return collectionView
     }()

    lazy private var sun: UIImageView = {
        let image = UIImage(systemName: "sun.max.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .yellow
        return imageView
    }()
    
    // MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        if let inst = WEATHER_INSTS.randomElement() {
            showView(title: inst.title)
        }
    }
    
    // MARK: Private Methods
        // --- config methods ---
    private func setUp() {
        fogSkView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        rainSkView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        snowSkView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
        // --- weather animation methods ---
    
    private func addSun() {
        view.backgroundColor = .systemBlue
        view.addSubview(sun)
        sun.frame = CGRect(x: view.bounds.width / 2 - 50, y: view.bounds.height / 2 - 50, width: 100, height: 100)
        animateSun()
    }
    
    private func animateSun() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.sun.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
    }
    
    private func addRain() {
        
        view.backgroundColor = .darkGray
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        rainSkView.backgroundColor = .clear
        rainSkView.presentScene(scene)
        rainSkView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(rainNode)
        rainNode.position.y = scene.frame.maxY
        rainNode.particlePositionRange.dx = scene.frame.width
        view.insertSubview(rainSkView, belowSubview: collectionView)
    }
    
    private func addSnow() {
        
        view.backgroundColor = .black
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        snowSkView.presentScene(scene)
        snowSkView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(snowNode)
        snowNode.position.y = scene.frame.maxY
        snowNode.particlePositionRange.dx = scene.frame.width
        view.insertSubview(snowSkView, belowSubview: collectionView)
    }
    
    private func addThunder() {
        startLightningTimer()
        view.backgroundColor = .black
        let scene = SKScene(size: view.frame.size)
        rainSkView.backgroundColor = .clear
        scene.backgroundColor = .clear
        rainSkView.presentScene(scene)
        rainSkView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(rainNode)
        rainNode.position.y = scene.frame.maxY
        rainNode.particlePositionRange.dx = scene.frame.width
        view.insertSubview(rainSkView, belowSubview: collectionView)
        triggerLightning()
    }
    
    private func addFog() {
        
        view.backgroundColor = .darkGray
        let scene = SKScene(size: view.frame.size)
        scene.backgroundColor = .clear
        fogSkView.backgroundColor = .clear
        fogSkView.presentScene(scene)
        fogSkView.isUserInteractionEnabled = false
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(fogNode)
        fogNode.position.y = scene.frame.minY
        fogNode.particlePositionRange.dx = scene.frame.width
        view.insertSubview(fogSkView, belowSubview: collectionView)
    }
    
    private func flashBackgroundColor() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut, .autoreverse], animations: {
            self.view.backgroundColor = .white
        }, completion: { _ in
            self.view.backgroundColor = .black
        })
    }
    
    private func triggerLightning() {
        for delay in stride(from: 0.0, through: 1.0, by: 0.3) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.flashBackgroundColor()
            }
        }
    }
    
    private func startLightningTimer() {
        lightningTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.triggerLightning()
        }
    }
    
    private func clearView() {
        sun.removeFromSuperview()
        rainSkView.removeFromSuperview()
        fogSkView.removeFromSuperview()
        snowSkView.removeFromSuperview()
        lightningTimer?.invalidate()
    }
    
    private func showView(title: String) {
        switch title {
        case "Ясно":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 2.0, animations: {
                    self.clearView()
                    self.addSun()
                })
            }
        case "Дождь":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.clearView()
                    self.addRain()
                })
            }
            
        case "Гроза":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.clearView()
                    self.addThunder()
                })
            }
            
        case "Туман":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.clearView()
                    self.addFog()
                })
            }
            
        case "Снег":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.clearView()
                    self.addSnow()
                })
            }
        default:
            break
        }
    }
}

// MARK: UICollectionViewDataSource


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        WEATHER_INSTS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CollectionCell
        let inst = WEATHER_INSTS[indexPath.row]
        cell.configure(inst)
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = WEATHER_INSTS[indexPath.row]
        showView(title: item.title)
    }
}
