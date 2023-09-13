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
        
        //вернёт все таблицы на экран
        let tablesQuery = app.tables
        
        //вернёт ячейку по индексу 0
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        sleep(5)
        
        //таблицы на экране
        let tableQuery = app.tables
        
        //ячейкa по индексу 0
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(3)
        
        let cellForLike = tableQuery.children(matching: .cell).element(boundBy: 1)
        
        let buttonLike = cellForLike.buttons["likeButton"]
        buttonLike.tap()
        sleep(2)
        buttonLike.tap()
        sleep(3)
        
        cellForLike.tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let backButton = app.buttons["backButton"]
        backButton.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        sleep(3)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        
        app.buttons["logoutButton"].tap()
        sleep(1)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        
        XCTAssertTrue(app.staticTexts["Войти"].exists)
    }
}

