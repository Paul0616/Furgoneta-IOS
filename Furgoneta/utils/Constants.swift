//
//  Constants.swift
//  Furgoneta
//
//  Created by Paul Oprea on 08/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

struct Constants {
    static let BASE_URL_STRING: String = "http://www.duoline.ro/furgoneta"
    static let FILE_GET_LOGIN: String = "getlogin.php"
    static let FILE_GET_USER_STATUS: String = "getUserStatus.php"
    static let FILE_GET_LOCATIONS_NUM = "getCountLocationAndProduct.php"
    static let FILE_GET_ALL_PRODUCTS = "getAllProducts.php"
    static let FILE_GET_ALL_LOCATIONS = "getAllLocations.php"
    static let FILE_CHECK_PRODUCT = "setDocCheckProduct.php"
    static let FILE_SET_PRODUCT = "setProduct.php"
    static let FILE_SET_LOCATION = "setLocation.php"
    static let FILE_DELETE_PRODUCT = "setDelProduct.php"
    static let FILE_DELETE_LOCATION = "setDelLocation.php"
    static let FILE_GET_ALL_USERS = "getAllUsers.php"
    static let FILE_SET_USER_STATUS = "setUserStatus.php"
    static let FILE_SET_USER_LOCATIONS = "setUserLocations.php"
    static let FILE_GET_USER_LOCATIONS = "getUserLocations.php"
    static let FILE_SET_USER = "setUser.php"
    static let FILE_DELETE_USER = "setDelUser.php"
    static let FILE_GET_ROLES = "getRoles.php"
    static let FILE_GET_ADMIN_VIEW_DOCS = "getAllDocuments.php"
    static let FILE_GET_DOCUMENT_PRODUCTS = "getDocumentProducts.php"
    
    static let RESULT_KEY: String = "result"
    static let STATUS_KEY: String = "status"
    static let EMAIL_KEY: String = "email"
    static let USER_ID_KEY: String = "userId"
    static let FIRST_NAME_KEY: String = "nume"
    static let LAST_NAME_KEY: String = "prenume"
    static let ROLE_KEY: String = "rol"
    static let USER_NAME_KEY: String = "username"
    static let USER_PASSWORD_KEY: String = "parola"
    static let SUPPLY_KEY: String = "aprovizionare"
    static let EXPEDITURE_KEY: String = "consum"
    static let FIXTURE_KEY: String = "inventar"
    static let PRODUCT_NAME_KEY: String = "produs"
    static let LOCATION_NAME_KEY: String = "locatie"
    static let PRODUCT_UNITS_KEY: String = "um"
    static let ID_KEY: String = "id"
    static let PHONE_KEY: String = "telefon"
    static let HEADER_KEY: String = "header"
    static let DAY_KEY: String = "day"
    static let HOUR_KEY: String = "hour"
    static let TYPE_KEY: String = "tip"
    static let TYPE_DOC_ID_KEY = "tipDocId"
    static let QUANTITY_KEY = "cantitatea"
    static let MOTIVATION_KEY = "motiv"
}