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
    private let discount: Double

    private var controller: ContractBodyController {
        .init(patient: patient, services: services, discount: discount)
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

    init(patient: Patient, services: [Service], discount: Double) {
        self.patient = patient
        self.services = services
        self.discount = discount
    }

    func makeFirstPage(_ drawContext: CGContext, pageRect: CGRect, textTop: CGFloat) {
        let attributedFirstPagePart = NSAttributedString(
            string: controller.firstPagePart,
            attributes: regularFontAttributes
        )
        let aboveTablePartRect = CGRect(
            x: Size.textEdgeInset,
            y: textTop,
            width: pageRect.width - Size.textEdgeInset * 2,
            height: pageRect.height - Size.textEdgeInset * 2
        )
        attributedFirstPagePart.draw(in: aboveTablePartRect)
    }

    func makeSecondPage(_ drawContext: CGContext, pageRect: CGRect, textTop: CGFloat) {
        let aboveTableTextBottom = addAboveTableText(textTop: textTop)
        let tableBottom = drawPriceTable(
            drawContext,
            pageRect: pageRect,
            tableY: aboveTableTextBottom + Size.tabletextEdgeInset
        )
        let belowTableTextBottom = addBelowTableText(pageRect: pageRect, textTop: tableBottom + Size.tabletextEdgeInset)
        let companyDetailsBottom = addParticipantDetails(
            title: "Исполнитель",
            details: controller.companyDetails,
            pageRect: pageRect,
            titleTop: belowTableTextBottom,
            leading: Size.textEdgeInset
        )
        let patientDetailsBottom = addParticipantDetails(
            title: "Пациент",
            details: controller.patientDetails,
            pageRect: pageRect,
            titleTop: belowTableTextBottom,
            leading: (pageRect.width + Size.textEdgeInset) / 2
        )
        addSignatureField(
            "Директор _______________________ / Фаустов Н.И.",
            signatureTop: max(companyDetailsBottom, patientDetailsBottom) + 15,
            leading: Size.textEdgeInset,
            width: (pageRect.width - Size.textEdgeInset * 2) / 2
        )
        addSignatureField(
            "_______________________ / _______________________",
            signatureTop: max(companyDetailsBottom, patientDetailsBottom) + 15,
            leading: (pageRect.width + Size.textEdgeInset) / 2,
            width: (pageRect.width - Size.textEdgeInset * 2) / 2
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
            x: Size.textEdgeInset,
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
            x: Size.textEdgeInset,
            y: textTop,
            width: pageRect.width - Size.textEdgeInset * 2,
            height: pageRect.height - textTop - 610
        )
        attributedBelowTablePart.draw(in: belowTablePartRect)

        return belowTablePartRect.maxY
    }

    func drawPriceTable(_ drawContext: CGContext, pageRect: CGRect, tableY: CGFloat) -> CGFloat {
        let tableWidth: CGFloat = pageRect.width - Size.textEdgeInset * 2
        let separatorX: CGFloat = Size.textEdgeInset + pageRect.width / 1.5

        addServicesListTitle(tableY: tableY, tableWidth: tableWidth, separatorX: separatorX)
        let servicesListHeight = addServicesList(tableY: tableY, tableWidth: tableWidth, separatorX: separatorX)
        let tableBottom: CGFloat = tableY + Size.tableTitleRectHeight * 2 + servicesListHeight
        addServicesListTotal(tableBottom: tableBottom, tableWidth: tableWidth, separatorX: separatorX)

        drawContext.saveGState()
        drawContext.setLineWidth(0.5)
        // draw main rectangle
        drawContext.move(to: CGPoint(x: Size.textEdgeInset, y: tableY))
        drawContext.addLine(to: CGPoint(x: pageRect.width - Size.textEdgeInset, y: tableY))
        drawContext.addLine(to: CGPoint(x: pageRect.width - Size.textEdgeInset, y: tableBottom))
        drawContext.addLine(to: CGPoint(x: Size.textEdgeInset, y: tableBottom))
        drawContext.addLine(to: CGPoint(x: Size.textEdgeInset, y: tableY))
        // draw title rectangle
        drawContext.move(to: CGPoint(x: Size.textEdgeInset, y: tableY + Size.tableTitleRectHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - Size.textEdgeInset, y: tableY + Size.tableTitleRectHeight))
        // draw total rectangle
        drawContext.move(to: CGPoint(x: Size.textEdgeInset, y: tableBottom - Size.tableTitleRectHeight))
        drawContext.addLine(to: CGPoint(
            x: pageRect.width - Size.textEdgeInset,
            y: tableBottom - Size.tableTitleRectHeight
        ))
        // draw vertical separator
        drawContext.move(to: CGPoint(x: separatorX, y: tableY))
        drawContext.addLine(to: CGPoint(x: separatorX, y: tableBottom))

        drawContext.strokePath()
        drawContext.restoreGState()

        return tableBottom
    }

    func addServicesList(tableY: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) -> CGFloat {
        var listHeight: CGFloat = 0

        services.forEach { service in
            let attributedService = NSAttributedString(
                string: service.title,
                attributes: lightFontAttributes
            )
            let serviceWidth = separatorX - Size.textEdgeInset - Size.tabletextEdgeInset * 2
            let numberOfLines = ceil(attributedService.size().width / serviceWidth)
            let serviceHeight = attributedService.size().height * numberOfLines
            let serviceRect = CGRect(
                x: Size.textEdgeInset + Size.tabletextEdgeInset,
                y: tableY + Size.tableTitleRectHeight + listHeight + Size.servicesSpacing,
                width: serviceWidth,
                height: serviceHeight + Size.servicesSpacing
            )
            attributedService.draw(in: serviceRect)

            let attributedPrice = NSAttributedString(
                string: "\(String(format: "%.2f", service.price))",
                attributes: lightFontAttributes
            )
            let priceSize = attributedPrice.size()
            let priceRect = CGRect(
                x: separatorX + (tableWidth - separatorX + Size.textEdgeInset - priceSize.width) / 2,
                y: serviceRect.origin.y + ((serviceHeight - priceSize.height) / 2),
                width: priceSize.width,
                height: priceSize.height
            )
            attributedPrice.draw(in: priceRect)

            listHeight += serviceRect.height
        }

        return listHeight + Size.servicesSpacing
    }

    func addServicesListTitle(tableY: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let attributedServiceTitle = NSAttributedString(
            string: "Наименование платной медицинской услуги",
            attributes: regularFontAttributes
        )
        let serviceTitleSize = attributedServiceTitle.size()
        let serviceTitleRect = CGRect(
            x: (separatorX - Size.textEdgeInset - serviceTitleSize.width) / 2,
            y: tableY + (Size.tableTitleRectHeight - serviceTitleSize.height) / 2,
            width: serviceTitleSize.width,
            height: serviceTitleSize.height
        )
        attributedServiceTitle.draw(in: serviceTitleRect)

        let attributedPriceTitle = NSAttributedString(string: "Цена (руб.)", attributes: regularFontAttributes)
        let priceTitleSize = attributedPriceTitle.size()
        let priceTitleRect = CGRect(
            x: separatorX + (tableWidth - separatorX + Size.textEdgeInset - priceTitleSize.width) / 2,
            y: tableY + (Size.tableTitleRectHeight - serviceTitleSize.height) / 2,
            width: priceTitleSize.width,
            height: priceTitleSize.height
        )
        attributedPriceTitle.draw(in: priceTitleRect)
    }

    func addServicesListTotal(tableBottom: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let attributedTotal = NSAttributedString(string: "ИТОГО", attributes: boldFontAttributes)
        let totalSize = attributedTotal.size()
        let totalRect = CGRect(
            x: Size.textEdgeInset + Size.tabletextEdgeInset,
            y: tableBottom - Size.tableTitleRectHeight + (Size.tableTitleRectHeight - totalSize.height) / 2,
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
            x: separatorX + (tableWidth - separatorX + Size.textEdgeInset - totalPriceSize.width) / 2,
            y: tableBottom - Size.tableTitleRectHeight + (Size.tableTitleRectHeight - totalPriceSize.height) / 2,
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
            width: (pageRect.width - Size.textEdgeInset * 2) / 2,
            height: titleSize.height
        )
        attributedTitle.draw(in: titleRect)

        let attributedDetails = NSAttributedString(string: details, attributes: lightFontAttributes)
        let detailsRect = CGRect(
            x: leading,
            y: titleRect.maxY,
            width: (pageRect.width - Size.textEdgeInset * 2) / 2,
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
            x: Size.textEdgeInset,
            y: pageRect.height - Size.informingHeight * 2,
            width: pageRect.width - Size.textEdgeInset * 2,
            height: Size.informingHeight
        )
        attributedFreeMedicineInforming.draw(in: freeMedicineInformingRect)

        addSignatureField(
            "_______________________ / _______________________     Дата: __________________",
            signatureTop: pageRect.height - 210,
            leading: Size.signatureLeading,
            width: pageRect.width - Size.textEdgeInset * 2
        )
        addSignatureField(
            "Лечащий врач (специалист) _______________________ / _______________________",
            signatureTop: pageRect.height - 180,
            leading: Size.signatureLeading,
            width: pageRect.width - Size.textEdgeInset * 2
        )

        let attributedRecommendationsInforming = NSAttributedString(
            string: controller.followingRecommendationsInforming,
            attributes: regularFontAttributes
        )
        let recommendationsInformingRect = CGRect(
            x: Size.textEdgeInset,
            y: pageRect.height - Size.informingHeight,
            width: pageRect.width - Size.textEdgeInset * 2,
            height: Size.informingHeight
        )
        attributedRecommendationsInforming.draw(in: recommendationsInformingRect)

        addSignatureField(
            "_______________________ / _______________________     Дата: __________________",
            signatureTop: pageRect.height - 80,
            leading: Size.signatureLeading,
            width: pageRect.width - Size.textEdgeInset * 2
        )
        addSignatureField(
            "Лечащий врач (специалист) _______________________ / _______________________",
            signatureTop: pageRect.height - 50,
            leading: Size.signatureLeading,
            width: pageRect.width - Size.textEdgeInset * 2
        )
    }
}

extension ContractBody {
    enum Size {
        static let textEdgeInset: CGFloat = 30
        static let tabletextEdgeInset: CGFloat = 10
        static let tableTitleRectHeight: CGFloat = 16
        static let servicesSpacing: CGFloat = 5
        static let signatureLeading: CGFloat = 180
        static let informingHeight: CGFloat = 150
    }
}
