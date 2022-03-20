//
//  Notifications.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 19/3/22.
//

import SwiftUI
import NotificationCenter

final class Notifications {
    func createNotification(id: UUID, date: Date, element: String, type: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let content = UNMutableNotificationContent()
                
                // Tipo 1 = Medicinas; Tipo 2 = Citas Médicas
                if (type == 1) {
                    content.title = self.generarMensajeRecordatoriosMedicinas()
                    
                } else if (type == 2) {
                    content.title = self.generarMensajeRecordatorioCitas()
                }
                
                content.body = element
                
                let calendar = Calendar.current
                var dateComponents = DateComponents()
                dateComponents.day = calendar.component(.day, from: date)
                dateComponents.month = calendar.component(.month, from: date)
                dateComponents.year = calendar.component(.year, from: date)
                dateComponents.hour = calendar.component(.hour, from: date)
                dateComponents.minute = calendar.component(.minute, from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
                
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { error in
                    if error != nil {
                        print("ERROR creating notification \(String(describing: error))")
                    }
                }
            } else if let error = error {
                print("ERROR in notification creation \(error)")
            }
        }
    }
    
    func eliminarNotificacion(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    fileprivate func generarMensajeRecordatoriosMedicinas() -> String {
        let mensajeAleatorio = Int.random(in: 0..<4)
        var mensaje: String = ""
        
        switch mensajeAleatorio {
        case 0:
            mensaje = "Hey, it's your turn to take the medicine"
        case 1:
            mensaje = "I think you have to take your medicine, don't you?"
        case 2:
            mensaje = "It's medicine time!"
        case 3:
            mensaje = "Hey, you have to take your medicine, don't forget"
        default:
            mensaje = "It's your turn to take the medicine"
        }
        
        return mensaje
    }
    
    fileprivate func generarMensajeRecordatorioCitas() -> String {
        let mensajeAleatorio = Int.random(in: 0..<3)
        var mensaje: String = ""
        
        switch mensajeAleatorio {
        case 0:
            mensaje = "Hey, in no time it's your medical appointment"
        case 1:
            mensaje = "You have to go to the doctor soon, right?"
        case 2:
            mensaje = "Don't forget your medical appointment"
        default:
            mensaje = "You have to go to the doctor soon"
        }
        
        return mensaje
    }
}
