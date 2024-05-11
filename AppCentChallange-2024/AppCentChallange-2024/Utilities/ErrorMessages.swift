//
//  ErrorMessages.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import Foundation

enum ACError: String, Error {
    case invalidQuery = "This word created an invalid request. Please try again."
    case unableToComplete = "Unable to complete request please check your internet connection."
    case invalidResponse = "Invalid response from the server , please try again."
    case invalidData = "The data received from the server was invalid. Please try again"
    case unableToSave = "There was an error. Please try again."
    case alreadyInSaved = "You've already saved this article."
}
