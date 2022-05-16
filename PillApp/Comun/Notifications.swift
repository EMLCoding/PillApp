//
//  Notifications.swift
//  PillApp
//
//  Created by Eduardo Martin Lorenzo on 19/3/22.
//

import SwiftUI
import NotificationCenter

final class Notifications {
    /// Permite crear una notificación que se mostrará en el dispositivo en la fecha indicada
    ///
    ///  - Parameter id: ID del elemento que genera esta notificación (id de un recordatorio de medicina/cita médica). --> (UUID)
    ///  - Parameter date: La fecha en la que se va a mostrar la notificacón, con la hora y minutos incluidos --> (Date)
    ///  - Parameter element: Nombre del elemento que genera esta notificación --> (String)
    ///  - Parameter type: ID del tipo de elemento (1 para recordatorio de medicinas y 2 para recordatorio de citas medicas) --> (Int)
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
    
    /// Permite eliminar una notificación programada
    ///
    ///  - Parameter id: ID de la notificación que se quiere eliminar, que será el ID del elemento que generó la notificación. --> (UUID)
    func eliminarNotificacion(id: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
    }
    
    /// Permite generar mensajes aleatorios para mostrar en las notificaciones de los recordatorios de medicinas
    ///
    ///  - Returns: String
    fileprivate func generarMensajeRecordatoriosMedicinas() -> String {
        let randomMessage = Int.random(in: 0..<4)
        var message: String = ""
        let spanish = NSLocale.preferredLanguages[0] == "es" ? true : false
        
        switch randomMessage {
        case 0:
            message = spanish ? "Oye, es el momento de tomarse la medicina" : "Hey, it's your turn to take the medicine"
        case 1:
            message = spanish ? "Creo que tienes que tomar tu medicina, ¿no?" : "I think you have to take your medicine, don't you?"
        case 2:
            message = spanish ? "¡Es la hora de la medicina!" : "It's medicine time!"
        case 3:
            message = spanish ? "Oye, tienes que tomar tu medicina, no lo olvides" : "Hey, you have to take your medicine, don't forget"
        default:
            message = spanish ? "Es el momento de tomarse la medicina" : "It's your turn to take the medicine"
        }
        
        return message
    }
    
    /// Permite generar mensajes aleatorios para mostrar en las notificaciones de los recordatorios de citas médicas
    ///
    ///  - Returns: String
    fileprivate func generarMensajeRecordatorioCitas() -> String {
        let randomMessage = Int.random(in: 0..<3)
        var message: String = ""
        let spanish = NSLocale.preferredLanguages[0] == "es" ? true : false
        
        switch randomMessage {
        case 0:
            message = spanish ? "Oye, en poco tiempo es tu cita médica" : "Hey, in no time it's your medical appointment"
        case 1:
            message = spanish ? "Tienes que ir al médico pronto, ¿verdad?" : "You have to go to the doctor soon, right?"
        case 2:
            message = spanish ? "No olvides tu cita médica" : "Don't forget your medical appointment"
        default:
            message = spanish ? "En poco tiempo es tu cita médica" : "You have to go to the doctor soon"
        }
        
        return message
    }
}
