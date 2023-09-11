//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Григорий Машук on 25.05.23.
//

import XCTest
@testable import ImageFeed

let Login = ""
let Password = ""

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() //переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так
        
        app.launch()  // запускаем приложение перед каждым тестом
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        
        /* У приложения мы получаем список кнопок на экране и получаем нужную кнопку по тексту на ней
        Далее вызываем функцию tap() для нажатия на этот элемент
        */
        app.buttons["Authenticate"].tap()
        
        //вернёт нужный WebView по accessibilityIdentifier
        let webView = app.webViews["UnsplashWebView"]
        
        //подождёт 5 секунд, пока WebView не появится
        XCTAssert(webView.waitForExistence(timeout: 5))
        
        // найдёт поле для ввода пароля
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        //введёт текст в поле ввода
        passwordTextField.typeText(Password)
        // поможет скрыть клавиатуру после ввода текста
        webView.swipeUp()
        
        //найдёт поле для ввода логина
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(Login)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()

        //вернёт таблицы на экран
        let tablesQuery = app.tables
        
        //вернёт ячейку по индексу 0
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}
