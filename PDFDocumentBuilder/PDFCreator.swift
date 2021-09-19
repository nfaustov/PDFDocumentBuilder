//
//  PDFCreator.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import PDFKit

final class PDFCreator: NSObject {
    let title: String
    let body: ContractBody
    let date: Date

    init(
        title: String = "ДОГОВОР ОБ ОКАЗАНИИ ПЛАТНЫХ МЕДИЦИНСКИХ УСЛУГ",
        date: Date = Date(),
        body: ContractBody
    ) {
        self.title = title
        self.date = date
        self.body = body
    }

    func createContract() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Document Builder",
            kCGPDFContextAuthor: "ООО УльтраМед",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.3 * 72.0
        let pageHeight = 11.7 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        let data = renderer.pdfData { context in
            context.beginPage()
            let titleBottom = addTitle(pageRect: pageRect)
            let dateBottom = addDate(pageRect: pageRect, dateTop: titleBottom + 10)
        }

        return data
    }

    private func addTitle(pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )
        let titleStringSize = attributedTitle.size()
        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 36,
            width: titleStringSize.width,
            height: titleStringSize.height
        )

        attributedTitle.draw(in: titleStringRect)

        return titleStringRect.origin.y + titleStringRect.size.height
    }

    private func addDate(pageRect: CGRect, dateTop: CGFloat) -> CGFloat {
        let dateFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        let dateAttributes: [NSAttributedString.Key: Any] = [.font: dateFont]
        let formatter = DateFormatter.shared
        let dateString = formatter.string(from: date)
        let attributedDate = NSAttributedString(string: dateString, attributes: dateAttributes)
        let dateStringSize = attributedDate.size()
        let dateStringRect = CGRect(
            x: pageRect.width - dateStringSize.width - 60,
            y: dateTop,
            width: dateStringSize.width,
            height: dateStringSize.height
        )

        attributedDate.draw(in: dateStringRect)

        return dateStringRect.maxY
    }
}
