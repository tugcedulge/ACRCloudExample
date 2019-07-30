//
//  ViewController.swift
//  ACRCloudExample
//
//  Created by Tugce on 7/27/19.
//  Copyright © 2019 tugce. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var _start = false
    var _client: ACRCloudRecognition?
    var musicInformation: SongsData?
    var musicList = [Music]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initView()
        setConfig()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {
        
        self.startButton.layer.masksToBounds = true
        self.startButton.layer.cornerRadius = startButton.frame.width/2
        let playButton = UIImage(named: "play-button")
        let playImage = playButton?.withRenderingMode(.alwaysTemplate)
        self.startButton.setImage(playImage, for: .normal)
        self.startButton.tintColor = .white
        
        volumeLabel.isHidden = true
        stateLabel.isHidden = true
        
        self.volumeLabel.textColor = UIColor.lightGray
        self.volumeLabel.font = UIFont (name: "Helvetica Bold Neue", size: 17)
        self.volumeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.stateLabel.textColor = UIColor.lightGray
        self.stateLabel.font = UIFont (name: "Helvetica Bold Neue", size: 17)
        self.stateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.stateLabel.textColor = UIColor.lightGray
        self.stateLabel.font = UIFont (name: "Helvetica Bold Neue", size: 17)
        self.stateLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.artistLabel.textColor = UIColor.lightGray
        self.artistLabel.font = UIFont (name: "Helvetica Bold Neue", size: 17)
        self.artistLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.albumLabel.textColor = UIColor.lightGray
        self.albumLabel.font = UIFont (name: "Helvetica Bold Neue", size: 17)
        self.albumLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.songLabel.textColor = UIColor.lightGray
        self.songLabel.font = UIFont (name: "Helvetica Bold Neue", size: 17)
        self.songLabel.font = UIFont.boldSystemFont(ofSize: 17)
        
    }
    
    func setConfig() {
        
        _start = false;
        
        let config = ACRCloudConfig()
        
        config.accessKey = "ac4a33a2c61babbdfeef8c2181f6a476";
        config.accessSecret = "lPEV3mtHAb3eQdx3UsYzQKMdXkcfoAe3EtxzgNiO";
        config.host = "identify-eu-west-1.acrcloud.com";
        //if you want to identify your offline db, set the recMode to "rec_mode_local"
        config.recMode = rec_mode_remote
        config.requestTimeout = 10
        config.protocol = "https"
        
        /* used for local model */
        if (config.recMode == rec_mode_local || config.recMode == rec_mode_both) {
            config.homedir = Bundle.main.resourcePath!.appending("/acrcloud_local_db")
        }
        
        config.stateBlock = {[weak self] state in
            self?.handleState(state!)
        }
        config.volumeBlock = {[weak self] volume in
            //do some animations with volume
            self?.handleVolume(volume)
        };
        config.resultBlock = {[weak self] result, resType in
            self?.handleResult(result!, resType:resType)
        }
        self._client = ACRCloudRecognition(config: config)
        
    }
    
    @objc func startRecognition(_ sender:AnyObject) {
        
        if (_start) {
            return;
        }
        
        volumeLabel.isHidden = false
        stateLabel.isHidden = false
        
        self._client?.startRecordRec()
        self._start = true
        
        let pauseImage = UIImage(named: "pause-button")
        self.startButton.setImage(pauseImage, for: .normal)
    }
    
    @IBAction func stopRecognition(_ sender:AnyObject) {
        self._client?.stopRecordRec()
        self._start = false
        
        let playImage = UIImage(named: "play-button")
        self.startButton.setImage(playImage, for: .normal)
    }
    
    func handleResult(_ result: String, resType: ACRCloudResultType) -> Void
    {
        print(result);
        
        if let jsonData = result.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let songsData = try decoder.decode(SongsData.self, from: jsonData)
                
                DispatchQueue.main.async {
                    
                    if (songsData.metadata?.music?[0].artists?[0].name) != nil {
                        
                        let playImage = UIImage(named: "play-button")
                        self.startButton.setImage(playImage, for: .normal)
                        
                        self.artistLabel.text = String(format: "Şarkıcı Adı: %@", songsData.metadata?.music?[0].artists?[0].name ?? "")
                        self.albumLabel.text = String(format: "Albüm Adı: %@", songsData.metadata?.music?[0].album?.name ?? "")
                        self.songLabel.text = String(format: "Şarkı Adı: %@", songsData.metadata?.music?[0].title ?? "")
                    }
                    print(result);
                    self._client?.stopRecordRec();
                    self._start = false;
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleVolume(_ volume: Float) -> Void {
        DispatchQueue.main.async {
            self.volumeLabel.text = String(format: "Ses Düzeyi: %f", volume)
        }
    }
    
    func handleState(_ state: String) -> Void
    {
        DispatchQueue.main.async {
            self.stateLabel.text = state == "stopped" ? String(format:"Durum: Durduruldu") : "Durum: "
        }
    }
}

