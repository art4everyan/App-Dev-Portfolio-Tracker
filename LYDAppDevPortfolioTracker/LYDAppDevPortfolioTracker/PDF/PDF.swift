//
//  PDF.swift
//  LYDAppDevPortfolioTracker
//
//  Created by Lydia Zhang on 9/23/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import PDFKit

class PDF {
    let name: String
    let github: String
    let intro: String
    
    init(name: String, intro: String, github: String) {
        self.name = name
        self.github = github
        self.intro = intro
    }
    
    func createPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "App Dev Portfolio Tracker",
            kCGPDFContextAuthor: "Lydia",
            kCGPDFContextTitle: name
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        let pageHeight = 8.5 * 2.0
        let pageWidth = 11.0 * 2.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            addImage(image: UIImage(named: "56")!,
            width: CGFloat(pageWidth), height: CGFloat(pageHeight))
            let titleSize = addTitle(pageRect: pageRect)
            addBodyText(pageRect: pageRect, textTop: titleSize + 2.0)
            
        }
        
        return data
    }
    
    func addTitle(pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 2.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont]

        let attributedTitle = NSAttributedString(
            string: name,
            attributes: titleAttributes
        )

        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 0,
            width: titleStringSize.width,
            height: titleStringSize.height
        )

        attributedTitle.draw(in: titleStringRect)

        return titleStringRect.origin.y + titleStringRect.size.height
    }
    
    func addBodyText(pageRect: CGRect, textTop: CGFloat) {
        let textFont = UIFont.systemFont(ofSize: 1.0, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]

        let attributedText = NSAttributedString(
            string: "Github Handle:  \(github) \nIntroduction:   \(intro)",
            attributes: textAttributes
        )

        let textRect = CGRect(
            x: 1,
            y: textTop,
            width: pageRect.width - 1,
            height: pageRect.height - textTop - 5
        )
        
        attributedText.draw(in: textRect)
    }
    
    func addImage(image: UIImage, width: CGFloat, height: CGFloat) {
        
        let imageRect = CGRect(x: 0, y: 0,
                               width: width, height: height)
        
        image.draw(in: imageRect)
    }
}
