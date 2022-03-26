//
//  ErrorHandler.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/24.
//

import Foundation
import Alamofire
import CFNetwork

private let kUnexpectedMessage = "Unexpected HTTP Status Code:"
private let kFailure = "failure"
private let kCode = "code"
private let kTitle = "header"
private let kMessage = "message"
private let kDebugMessage = "name"

// iOS Default Errors
private let kCFURLErrorCannotConnectToHost = -1004
private let kCFURLErrorSecureConnectionFailed = -1200
private let kCFURLErrorNotConnectedToInternet = -1009
private let kCFURLErrorTimedOut = -1001

// PSDK Errors
private let kPSDKBarcodeRequestCanceled = -999
private let kPSDKSystemError = 2000
private let kPSDKUserNotLogin = 2001

class ErrorHandler {
    
    var statusCode: Int?
    var parsableErrorCode: String?
    var title: String = "Error"
    var message: String?
    var debugMessage: String?
    
    init(response: DataResponse<Data, AFError>) {
        
        statusCode = response.response?.statusCode
        if statusCode != nil {
            if (statusCode! / 100 == 2) {
                parsableErrorCode = "C0001";
                message = "No content."
                debugMessage = "2xx Response Parse Error";
            } else if (statusCode! / 100 == 4) {
                self.parsableErrorCode = "C0003"
                self.message = "Not found."
                self.debugMessage = "4xx Response Parse Error"
            } else if (statusCode! / 100 == 5) {
                switch statusCode! {
                case 500:
                    self.parsableErrorCode = "S0500"
                    self.message = "Internal Server Error."
                    self.debugMessage = "Internal Server Error"
                case 501:
                    self.parsableErrorCode = "S0501"
                    self.message = "Not Implemented."
                    self.debugMessage = "Not Implemented"
                case 502:
                    self.parsableErrorCode = "S0502"
                    self.message = "Bad Gateway."
                    self.debugMessage = "Bad Gateway"
                case 503:
                    self.parsableErrorCode = "S0503"
                    self.message = "Service Unavailable."
                    self.debugMessage = "Service Unavailable"
                default:
                    self.message = "Something went wrong!! Please try again later."
                    self.debugMessage = kUnexpectedMessage + " :\(String(describing: response.error?.responseCode))"
                }
            }
        } else {
            if let error: NSError = response.error?.underlyingError as NSError? {
                if (error.code == kCFURLErrorCannotConnectToHost || error.code == kCFURLErrorSecureConnectionFailed) {
                    // If you are connected to a WiFi hotspot and cannot connect to the internet
                    self.statusCode = 0
                    self.parsableErrorCode = "S0000"
                    self.message = "No internet connection."
                    self.debugMessage = "Not connected to host."
                } else if (error.code == kCFURLErrorNotConnectedToInternet) {
                    // If you are connected to a WiFi hotspot and cannot connect to the internet
                    self.statusCode = 0
                    self.parsableErrorCode = "S0000"
                    self.message = "No internet connection."
                    self.debugMessage = "Not connected to internet."
                } else if (error.code == kCFURLErrorTimedOut) {
                    self.statusCode = 0;
                    self.parsableErrorCode = "C0000"
                    self.message = "Timeout."
                    self.debugMessage = "Timeout."
                } else {
                    self.statusCode = error.code
                    self.parsableErrorCode = "\(error.code)"
                    self.message = "Something went wrong!! Please try again later."
                    self.debugMessage = kUnexpectedMessage + "\(error.code)"
                }
            } else {
                // Server + Unknown = SU
                self.statusCode = 0
                self.parsableErrorCode = "SU0000"
                self.message = "Something went wrong!! Please try again later."
                self.debugMessage = kUnexpectedMessage
            }
        }
    }
    
    init(message: String?) {
        if let message = message {
            self.statusCode = 0
            self.parsableErrorCode = "M0000"
            self.message = message
            self.debugMessage = message
        } else {
            self.statusCode = 0
            self.parsableErrorCode = "M0000"
            self.message = message
            self.debugMessage = message
        }
    }
}
