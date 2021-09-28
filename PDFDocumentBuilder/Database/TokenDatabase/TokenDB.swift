//
//  TokenDB.swift
//  PDFDocumentBuilder
//
//  Created by Nikolai Faustov on 28.09.2021.
//

protocol TokenDB {
    func saveToken(token: Token)
    func getToken() -> TokenEntity?
}
