//
//  ProfileConfiguration.swift
//  ImageFeed
//
//  Created by Григорий Машук on 7.09.23.
//

import Foundation

let ImageAvatar = "Avatar"
let LabelText = "Екатерина Новикова"
let LoginLabelText = "@ekaterina_nov"
let DescriptionLabelText = "Hello, world!"
let ImageLogoutButton = "ipad.and.arrow.forward"
let ImagePlaceholder = "placeholderAvatar"
let AlertTitle = "Пока, пока!"
let AlertMessage = "Уверены что хотите выйти?"
let TitleActionOne = "Да"
let TitleActionTwo = "Нет"
let LabelFont = CGFloat(23)
let LabelLoginFont = CGFloat(13)
let LabelDescriptionFont = CGFloat(13)


public struct ProfileConfiguration {
    let imageAvatar: String
    let labelText: String
    let loginLabelText: String
    let descriptionLabelText: String
    let imageLogoutButton: String
    let imagePlaceholder: String
    let alertTitle: String
    let alertMessage: String
    let titleActionOne: String
    let titleActionTwo:String
    let labelFont: CGFloat
    let labelLoginFont: CGFloat
    let labelDescriptionFont: CGFloat
    
    static let standart: ProfileConfiguration = ProfileConfiguration(imageAvatar: ImageAvatar,
                                                                     labelText: LabelText,
                                                                     loginLabelText: LoginLabelText,
                                                                     descriptionLabelText: DescriptionLabelText,
                                                                     imageLogoutButton: ImageLogoutButton,
                                                                     imagePlaceholder: ImagePlaceholder,
                                                                     alertTitle: AlertTitle,
                                                                     alertMessage: AlertMessage,
                                                                     titleActionOne: TitleActionOne,
                                                                     titleActionTwo: TitleActionTwo,
                                                                     labelFont: LabelFont,
                                                                     labelLoginFont: LabelLoginFont,
                                                                     labelDescriptionFont: LabelDescriptionFont)
    
    init(imageAvatar: String, labelText: String, loginLabelText: String, descriptionLabelText: String, imageLogoutButton: String, imagePlaceholder: String, alertTitle: String, alertMessage: String, titleActionOne: String, titleActionTwo: String, labelFont: CGFloat, labelLoginFont: CGFloat, labelDescriptionFont: CGFloat) {
        self.imageAvatar = imageAvatar
        self.labelText = labelText
        self.loginLabelText = loginLabelText
        self.descriptionLabelText = descriptionLabelText
        self.imageLogoutButton = imageLogoutButton
        self.imagePlaceholder = imagePlaceholder
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.titleActionOne = titleActionOne
        self.titleActionTwo = titleActionTwo
        self.labelFont = labelFont
        self.labelLoginFont = labelLoginFont
        self.labelDescriptionFont = labelDescriptionFont
    }
}
