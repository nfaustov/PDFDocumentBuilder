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

    private var totalPrice: Double {
        services
            .map { $0.price }
            .reduce(0, +)
    }

    init(patient: Patient, services: [Service]) {
        self.patient = patient
        self.services = services
    }

    func makeFirstPage(_ drawContext: CGContext, pageRect: CGRect, textTop: CGFloat) {
        let font = UIFont.systemFont(ofSize: 9, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        let attributedFirstPagePart = NSAttributedString(string: firstPagePart, attributes: attributes)
        let aboveTablePartRect = CGRect(
            x: 30,
            y: textTop,
            width: pageRect.width - 60,
            height: pageRect.height - 60
        )
        attributedFirstPagePart.draw(in: aboveTablePartRect)
    }

    func makeSecondPage(_ drawContext: CGContext, pageRect: CGRect, textTop: CGFloat) {
        let font = UIFont.systemFont(ofSize: 9, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        let attributedAboveTablePart = NSAttributedString(string: aboveTablePart, attributes: attributes)
        let aboveTablePartSize = attributedAboveTablePart.size()
        let aboveTablePartRect = CGRect(
            x: 30,
            y: textTop,
            width: aboveTablePartSize.width,
            height: aboveTablePartSize.height
        )
        attributedAboveTablePart.draw(in: aboveTablePartRect)

        let tableBottom = drawPriceTable(drawContext, pageRect: pageRect, tableY: aboveTablePartRect.maxY + 10)

        let attributedBelowTablePart = NSAttributedString(string: belowTablePart, attributes: attributes)
        let belowTablePartRect = CGRect(
            x: 30,
            y: tableBottom + 10,
            width: pageRect.width - 60,
            height: pageRect.height - 60
        )
        attributedBelowTablePart.draw(in: belowTablePartRect)
    }

    private func drawPriceTable(_ drawContext: CGContext, pageRect: CGRect, tableY: CGFloat) -> CGFloat {
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

        addServicesList(tableY: tableY, tableWidth: tableWidth, separatorX: separatorX)

        // draw title rectangle
        drawContext.move(to: CGPoint(x: 30, y: tableY + titleHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 30, y: tableY + titleHeight))

        addServicesListTitle(tableY: tableY, tableWidth: tableWidth, separatorX: separatorX)

        // draw total rectangle
        drawContext.move(to: CGPoint(x: 30, y: tableBottom - titleHeight))
        drawContext.addLine(to: CGPoint(x: pageRect.width - 30, y: tableBottom - titleHeight))

        addServicesListTotal(tableBottom: tableBottom, tableWidth: tableWidth, separatorX: separatorX)

        // draw vertical separator
        drawContext.move(to: CGPoint(x: separatorX, y: tableY))
        drawContext.addLine(to: CGPoint(x: separatorX, y: tableBottom))

        drawContext.strokePath()
        drawContext.restoreGState()

        return tableBottom
    }

    private func addServicesList(tableY: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let serviceFont = UIFont.systemFont(ofSize: 9, weight: .light)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let serviceAttributes: [NSAttributedString.Key: Any] = [
            .font: serviceFont,
            .paragraphStyle: paragraphStyle
        ]
        services.enumerated().forEach { index, service in
            let attributedService = NSAttributedString(string: service.title, attributes: serviceAttributes)
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
                attributes: serviceAttributes
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

    private func addServicesListTitle(tableY: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let titleFont = UIFont.systemFont(ofSize: 9, weight: .regular)
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]

        let attributedServiceTitle = NSAttributedString(
            string: "Наименование платной медицинской услуги",
            attributes: titleAttributes
        )
        let serviceTitleSize = attributedServiceTitle.size()
        let serviceTitleRect = CGRect(
            x: (separatorX - 30 - serviceTitleSize.width) / 2,
            y: tableY + (16 - serviceTitleSize.height) / 2,
            width: serviceTitleSize.width,
            height: serviceTitleSize.height
        )
        attributedServiceTitle.draw(in: serviceTitleRect)

        let attributedPriceTitle = NSAttributedString(string: "Цена (руб.)", attributes: titleAttributes)
        let priceTitleSize = attributedPriceTitle.size()
        let priceTitleRect = CGRect(
            x: separatorX + (tableWidth - separatorX + 30 - priceTitleSize.width) / 2,
            y: tableY + (16 - serviceTitleSize.height) / 2,
            width: priceTitleSize.width,
            height: priceTitleSize.height
        )
        attributedPriceTitle.draw(in: priceTitleRect)
    }

    private func addServicesListTotal(tableBottom: CGFloat, tableWidth: CGFloat, separatorX: CGFloat) {
        let totalFont = UIFont.systemFont(ofSize: 9, weight: .bold)
        let totalAttributes: [NSAttributedString.Key: Any] = [.font: totalFont]

        let attributedTotal = NSAttributedString(string: "ИТОГО", attributes: totalAttributes)
        let totalSize = attributedTotal.size()
        let totalRect = CGRect(
            x: 40,
            y: tableBottom - 16 + (16 - totalSize.height) / 2,
            width: totalSize.width,
            height: totalSize.height
        )
        attributedTotal.draw(in: totalRect)

        let attributedTotalPrice = NSAttributedString(
            string: "\(String(format: "%.2f", totalPrice))",
            attributes: totalAttributes
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
}

private extension ContractBody {
    // swiftlint:disable line_length
    var firstPagePart: String {
        """
              ООО «УльтраМед», зарегистрированное инспекцией ФНС России по Советском району г. Липецка за основным государственным регистрационным номером 1104823005319 в Едином государственном реестре юридических лиц, далее именуемый Исполнитель, в лице директора Фаустовой А.Ю., действующего на основании  лицензии № ЛО-48-01-001195 от 12.08.2014 г. на осуществление медицинской деятельности (перечень работ (услуг): 2. При оказании первичной, в том числе доврачебной, врачебной и специализированной, медико-санитарной помощи организуются и выполняются следующие работы (услуги): 1) при оказании первичной доврачебной медико-санитарной помощи в амбулаторных условиях по: вакцинации (проведению профилактических прививок); медицинскому массажу; сестринскому делу; 2) при оказании первичной врачебной медико-санитарной помощи в амбулаторных условиях по: терапии; 4) при оказании специализированной медико-санитарной помощи в амбулаторных условиях по: акушерству и гинекологии (за исключением вспомогательных репродуктивных технологий); гастроэнтерологии; кардиологии; косметологии; неврологии; онкологии; сердечно-сосудистой хирургии; урологии; ультразвуковой диагностике; функциональной диагностике; эндокринологии; 7. При проведении медицинских осмотров, медицинских освидетельствований и медицинских экспертиз организуются и выполняются следующие работы (услуги): 1) при проведении медицинских осмотров по: медицинским осмотрам (предрейсовым, послерейсовым); 3) при проведении медицинских экспертиз по: экспертизе временной нетрудоспособности;), выданной Управлением здравоохранения Липецкой области, расположенного по адресу: г. Липецк, ул. Зегеля, д.6, телефон 23-80-10, и Устава, с одной стороны, \(patient.name) далее именуемый «Пациент», с другой стороны, вместе именуемые Стороны, заключили настоящий Договор о нижеследующем:
        1. ПРЕДМЕТ ДОГОВОРА
        1.1. Настоящий Договор определяет порядок и условия оказания платных медицинских услуг. Пациент поручает, а Исполнитель обязуется оказать Потребителю платную медицинскую услугу.
        1.2. Наименование услуг: \(enumeratedServices()).
        2. ПРАВА И ОБЯЗАННОСТИ СТОРОН
        2.1. Исполнитель обязуется:
        - оказать Пациенту квалифицированную, качественную медицинскупомощь;
        - выдать заключение с указанием результатов проведенных исследований.
        2.2. Исполнитель вправе:
        - отказать в проведении диагностических мероприятий в случаяневыполнения Пациентом требований врача выполняющего исследование.
        - в случавозникновения неотложных состояний самостоятельно определять объем исследованийманипуляций, оперативных вмешательств, необходимых для установления диагноза и оказанимедицинской помощи, в том числе не предусмотренных Договором.
        2.3. Пациент обязуется:
        - предоставить точную и достоверную информацию о состоянии своего здоровья. Информироватврача до оказания медицинской услуги о перенесенных заболеваниях, известных емаллергических реакциях, противопоказаниях;
        - выполнять все медицинские рекомендации врача проводимого исследование;\n- своевременнпроводить необходимые финансовые расчеты с лечебным учреждением.
        2.4. Пациент в праве:
        - получить полную и достоверную информацию о медицинской услуге;
        - ознакомиться с документами подтверждающими специальную правоспособность лечебногучреждения и его специалистов на оказание платной медицинской услуги;
        - отказаться от получения медицинской услуги и получить обратно сумму с возмещениеИсполнителю затрат, связанных с подготовкой оказания услуги.
        3. ОТВЕТСТВЕННОСТИ СТОРОН
        3.1. В случае ненадлежащего оказания медицинской услуги, Пациент вправе потребоватьбезвозмездного устранения недостатков услуги, исполнения услуги другим специалистом илназначить новую дату оказания услуги.
        3.2. Исполнитель освобождается от ответственности за неисполнение или ненадлежащее исполнение своих обязательств по договору, если докажет, что это произошло вследствие непреодолимой силы, нарушения Пациентом своих обязанностей.
        3.3. Пациент обязан полностью возместить медицинскому учреждению понесенные убытки, если оно не смогло оказать услугу или было вынужденно прекратить оказание по вине Пациента.
        4. СТОИМОСТЬ И ПОРЯДОК ОПЛАТЫ
        4.1. Расчеты между сторонами осуществляются предварительно 100% оплатой.
        4.2. Оплата медицинской услуги производится безналичным перечислением на расчетный счет лечебного учреждения или внесения в кассу Исполнителя.
        4.3. При возникновении необходимости выполнения дополнительных услуг, не предусмотренных Договором, они выполняются с согласия Пациента с оплатой по утвержденному Прейскуранту.
        """
    }

    var aboveTablePart: String {
        """
        4.4. Цена медицинской услуги согласно Прейскуранту:
        """
    }
    var belowTablePart: String {
        """
        4.5. Общая стоимость медицинских услуг, предоставляемых Пациенту составляет \(String(format: "%.2f", totalPrice)) рублей (\(totalPriceInWords()))
        5. ПРОЧИЕ УСЛОВИЯ
        5.1. Настоящий Договор вступает в силу с момента его подписания Сторонами и действует до полного и надлежащего исполнения сторонами всех его условий.
        5.2. Условия настоящего Договора могут быть изменены по письменному соглашению Сторон.
        5.3. Споры и разногласия решаются путем переговоров, привлечения независимой экспертизы и в судебном порядке.
        6. АДРЕСА И РЕКВИЗИТЫ СТОРОН
        """
    }

    var conclusion: String {
        ""
    }

    func enumeratedServices() -> String {
        var enumeratedServices = services.map { $0.title }.reduce("") { $0 + ", " + $1 }
        enumeratedServices.removeFirst()

        return enumeratedServices
    }

    func totalPriceInWords() -> String {
        let numberValue = NSNumber(value: totalPrice)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .spellOut
        let string = formatter.string(from: numberValue) ?? "\(totalPrice)"

        return "\(string) рублей 00 копеек"
    }
}
