//
//  ViewController.swift
//  RWVideo
//
//  Created by radityakurnianto on 02/04/2019.
//  Copyright (c) 2019 radityakurnianto. All rights reserved.
//

import UIKit
import RWVideo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        guard let url = URL(string: "http://cdnapi.kaltura.com/p/243342/sp/24334200/playManifest/entryId/0_uka1msg4/flavorIds/1_vqhfu6uy,1_80sohj7p,1_ry9w1l0b/format/applehttp/protocol/http/a.m3u8") else { return }
        let video = RWVideo(videoUrl: url)
        
        self.present(video, animated: true) {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
