//
//  TokenDB.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 22.01.2022.
//

protocol TokenDB {
    func saveToken(token: Token)
    func getToken() -> TokenEntity?
}
