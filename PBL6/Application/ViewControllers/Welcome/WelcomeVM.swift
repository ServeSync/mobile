//
//  WelcomeVM.swift
//  PBL6
//
//  Created by KietKoy on 11/09/2023.
//

import Foundation

class WelcomeVM: BaseVM {
    private let slides: [SlideItem] = [
        SlideItem(img: "img_slide_first", title: "slide_title_1".localized),
        SlideItem(img: "img_slide_second", title: "slide_title_2".localized),
        SlideItem(img: "img_slide_third", title: "slide_title_3".localized),
    ]
    
    func numberOfSlides() -> Int {
        return slides.count
    }
    
    func slide(at index: Int) -> SlideItem {
        return slides[index]
    }
}
