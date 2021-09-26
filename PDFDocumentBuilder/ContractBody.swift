//
//  ContractBody.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.07.2021.
//

import PDFKit

final class ContractBody {
    private let patient: Patient
    private let services: [Service]

    private var controller: ContractBodyController {
        .init(patient: patient, services: services)
    }

    private let regularFontAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 9, weight: .regular)
    ]
    private let lightFontAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 9, weight: .light)
    ]
    private let boldFontAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 9, weight: .bold)
    ]

    init(patient: Patient, services: [Service]) {
        self.patient = patient
        self.services = services
    }

    func makeFirstPage(_ drawContext: CGContext, pageRect: CGRect, textTop: CGFloat) {
        let attributedFirstPagePart = NSAttributedString(
            string: controller.firstPagePart,
            attributes: regularFontAttributes
        )
        let aboveTablePartRect = CGRect(
            x: 30,
            y: textTop,
            width: pageRect.width - 60,
            height: pageRect.height - 60
        )
        attributedFirstPagePart.draw(in: aboveTablePartRect)
    }

    func makeSecondPage(_ drawContext: CGContext, pageRect: CGRect, textTop: CGFloat) {
        let aboveTableTextBottom = addAboveTableText(textTop: textTop)
        let tableBottom = drawPriceTable(drawContext, pageRect: pageRect, tableY: aboveTableTextBottom + 10)
        let belowTableTextBottom = addBelowTableText(pageRect: pageRect, textTop: tableBottom + 10)
        let companyDetailsBottom = addParticipantDetails(
            title: "Исполнитель",
            details: controller.companyDetails,
            pageRect: pageRect,
            titleTop: belowTableTextBottom,
            leading: 30
        )
        let patientDetailsBottom = addParticipantDetails(
            title: "Пациент",
            details: controller.patientDetails,
            pageRect: pageRect,
            titleTop: belowTableTextBottom,
            leading: pageRect.width / 2
        )
        addSignatureField(
            "Директор _______________________ / Фаустов Н.И.",
            signatureTop: max(companyDetailsBottom, patientDetailsBottom) + 15,
            leading: 30,
            width: (pageRect.width - 60) / 2
        )
        addSignatureField(
            "_______________________ / _______________________",
            signatureTop: max(companyDetailsBottom, patientDetailsBottom) + 15,
            leading: pageRect.width / 2,
            width: (pageRect.width - 60) / 2
        )
        addInforming(pageRect: pageRect)
    }
}

private extension ContractBody {
    func addAboveTableText(textTop: CGFloat) -> CGFloat {
        let attributedAboveTablePart = NSAttributedString(
            string: controller.aboveTablePart,
            attributes: regularFontAttributes
        )
        let aboveTablePartSize = attributedAboveTablePart.size()
        let aboveTablePartRect = CGRect(
            x: 30,
            y: textTop,
            width: aboveTablePartSize.width,
            height: aboveTablePartSize.height
        )
        attributedAboveTablePart.draw(in: aboveTablePartRect)

        return aboveTablePartRect.maxY
    }

    func addBelowTableText(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        let attributedBelowTablePart = NSAttributedString(
            string: controller.belowTablePart,
            attributes: regularFontAttributes
        )
        let belowTablePartRect = CGRect(
            x: 30,
            y: textTop,
            width: pageRect.width - 60,
            height: pageRect.height - textTop - 610
        )
        attributedBelowTablePart.draw(in: belowTablePartRect)

        return belowTablePartRect.maxY
    }

    func drawPriceTable(_ drawContext: CGContext, pageRect: CGRect, tableY: CGFloat) -> CGFloat {
        let titleHeight: CGFloat = 16
        let tableBottom: CGFloat = tableY + titleHeight + CGFloat(20 * services.count) + titleHeight
        let tableWidth: CGFloat = pageRect.width - 60
        let separatorX: CGFloat = 30 + pageRect.width / 1.5

        drawContext.saveGState()
        drawContext.setLineWidth(0.5)
        // draw main rectangle
        drawContext.move(to: CGPoint(x: 30, y: tableY))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 30, y: tableY))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 30, y: tableBottom))
        drawContext.addLine(to: CGPoint(x: 30, y: tableBottom))
        drawContext.addLine(to: CGPoint(x: 30, y: tableY))
        // draw title rectangle
        drawContext.move(to: CGPoint(x: 30, y: tableY + titleHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 30, y: tableY + titleHeight))
        // draw total rectangle
        drawContext.move(to: CGPoint(x: 30, y: tableBottom - titleHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 30, y: tableBottom - titleHeight))
        // draw vertical separator
        drawContext.move(to: CGPoint(x: separatorX, y: tableY))
        drawContext.addLine(to: CGPoint(x: separatorX, y: tableBottom))
        drawContext.strokePath()
        drawContext.restoreGState()

        addServicesListTitle(tableY: tableY, tableWidth: tableWidth, separatorX: separatorX)
        addServicesList(tableY: tableY, tableWidth: tableWidth, separatorX: separatorX)
        addServicesListTotal(tableBottom: tableBottom, tableWidth: tableWidth, separatorX: separatorX)

        return tableBottom
    }

    func addServicesList(tableY: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        services.enumerated().forEach { index, service in
            let attributedService = NSAttributedString(string: service.title, attributes: lightFontAttributes)
            let serviceSize = attributedService.size()
            let serviceRect = CGRect(
                x: 40,
                y: tableY + 16 + (20 * CGFloat(1 + index) - serviceSize.height) / 2,
                width: tableWidth / 1.5 - 20,
                height: serviceSize.height
            )
            attributedService.draw(in: serviceRect)

            let attributedPrice = NSAttributedString(
                string: "\(String(format: "%.2f", service.price))",
                attributes: lightFontAttributes
            )
            let priceSize = attributedPrice.size()
            let priceRect = CGRect(
                x: separatorX + (tableWidth - separatorX + 30 - priceSize.width) / 2,
                y: tableY + 16 + (20 * CGFloat(1 + index) - serviceSize.height) / 2,
                width: tableWidth - tableWidth / 1.5 - 20,
                height: serviceSize.height
            )
            attributedPrice.draw(in: priceRect)
        }
    }

    func addServicesListTitle(tableY: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let attributedServiceTitle = NSAttributedString(
            string: "Наименование платной медицинской услуги",
            attributes: regularFontAttributes
        )
        let serviceTitleSize = attributedServiceTitle.size()
        let serviceTitleRect = CGRect(
            x: (separatorX - 30 - serviceTitleSize.width) / 2,
            y: tableY + (16 - serviceTitleSize.height) / 2,
            width: serviceTitleSize.width,
            height: serviceTitleSize.height
        )
        attributedServiceTitle.draw(in: serviceTitleRect)

        let attributedPriceTitle = NSAttributedString(string: "Цена (руб.)", attributes: regularFontAttributes)
        let priceTitleSize = attributedPriceTitle.size()
        let priceTitleRect = CGRect(
            x: separatorX + (tableWidth - separatorX + 30 - priceTitleSize.width) / 2,
            y: tableY + (16 - serviceTitleSize.height) / 2,
            width: priceTitleSize.width,
            height: priceTitleSize.height
        )
        attributedPriceTitle.draw(in: priceTitleRect)
    }

    func addServicesListTotal(tableBottom: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let attributedTotal = NSAttributedString(string: "ИТОГО", attributes: boldFontAttributes)
        let totalSize = attributedTotal.size()
        let totalRect = CGRect(
            x: 40,
            y: tableBottom - 16 + (16 - totalSize.height) / 2,
            width: totalSize.width,
            height: totalSize.height
        )
        attributedTotal.draw(in: totalRect)

        let attributedTotalPrice = NSAttributedString(
            string: "\(String(format: "%.2f", controller.totalPrice))",
            attributes: boldFontAttributes
        )
        let totalPriceSize = attributedTotalPrice.size()
        let totalPriceRect = CGRect(
            x: separatorX + (tableWidth - separatorX + 30 - totalPriceSize.width) / 2,
            y: tableBottom - 16 + (16 - totalPriceSize.height) / 2,
            width: totalPriceSize.width,
            height: totalPriceSize.height
        )
        attributedTotalPrice.draw(in: totalPriceRect)
    }

    func addParticipantDetails(
        title: String,
        details: String,
        pageRect: CGRect,
        titleTop: CGFloat,
        leading: CGFloat
    ) -> CGFloat {
        let attributedTitle = NSAttributedString(string: title, attributes: boldFontAttributes)
        let titleSize = attributedTitle.size()
        let titleRect = CGRect(
            x: leading,
            y: titleTop,
            width: (pageRect.width - 60) / 2,
            height: titleSize.height
        )
        attributedTitle.draw(in: titleRect)

        let attributedDetails = NSAttributedString(string: details, attributes: lightFontAttributes)
        let detailsRect = CGRect(
            x: leading,
            y: titleRect.maxY,
            width: (pageRect.width - 60) / 2,
            height: pageRect.height - titleTop - 520
        )
        attributedDetails.draw(in: detailsRect)

        return detailsRect.maxY
    }

    func addSignatureField(
        _ signature: String,
        signatureTop: CGFloat,
        leading: CGFloat,
        width: CGFloat
    ) {
        let attributedSignatureField = NSAttributedString(string: signature, attributes: regularFontAttributes)
        let signatureRect = CGRect(
            x: leading,
            y: signatureTop,
            width: width,
            height: attributedSignatureField.size().height
        )
        attributedSignatureField.draw(in: signatureRect)
    }

    func addInforming(pageRect: CGRect) {
        let attributedFreeMedicineInforming = NSAttributedString(
            string: controller.freeMedicineInforming,
            attributes: regularFontAttributes
        )
        let freeMedicineInformingRect = CGRect(
            x: 30,
            y: pageRect.height - 300,
            width: pageRect.width - 60,
            height: pageRect.height
        )
        attributedFreeMedicineInforming.draw(in: freeMedicineInformingRect)

        addSignatureField(
            "_______________________ / _______________________     Дата: __________________",
            signatureTop: pageRect.height - 210,
            leading: 180,
            width: pageRect.width - 60
        )
        addSignatureField(
            "Лечащий врач (специалист) _______________________ / _______________________",
            signatureTop: pageRect.height - 180,
            leading: 180,
            width: pageRect.width - 60
        )

        let attributedRecommendationsInforming = NSAttributedString(
            string: controller.followingRecommendationsInforming,
            attributes: regularFontAttributes
        )
        let recommendationsInformingRect = CGRect(
            x: 30,
            y: pageRect.height - 150,
            width: pageRect.width - 60,
            height: pageRect.height
        )
        attributedRecommendationsInforming.draw(in: recommendationsInformingRect)

        addSignatureField(
            "_______________________ / _______________________     Дата: __________________",
            signatureTop: pageRect.height - 80,
            leading: 180,
            width: pageRect.width - 60
        )
        addSignatureField(
            "Лечащий врач (специалист) _______________________ / _______________________",
            signatureTop: pageRect.height - 50,
            leading: 180,
            width: pageRect.width - 60
        )
    }
}
