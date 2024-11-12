//
//  ContentView.swift
//  PDF Generator
//
//  Created by Randy McKown on 11/12/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    var body: some View {
        VStack {
            Button("Generate PDF") {
                generatePDF()
            }
            .padding()
        }
    }
    
    func generateText() -> String {
        let insertData = "Inserted Text"
        let defaultData = """
            This is line one.
                             
            This is a really long paragraph that needs to use word wrap in order to display correctly. This is a really long paragraph that needs to use word wrap in order to display correctly.This is a really long paragraph that needs to use word wrap in order to display correctly.This is a really long paragraph that needs to use word wrap in order to display correctly.This is a really long paragraph that needs to use word wrap in order to display correctly.This is a really long paragraph that needs to use word wrap in order to display correctly.
            """
        return "\(insertData)\n\n\(defaultData)"
    }
    
    func generatePDF() {
        // Define the size of the PDF (you can adjust the size as needed)
        let pdfPageSize = CGSize(width: 600, height: 800)
        
        // Create a PDF context
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pdfPageSize))
        
        // Generate the PDF data
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            
            // Set up the text rendering
            let font = UIFont.systemFont(ofSize: 10) // Set font and size
            let textRect = CGRect(x: 20, y: 100, width: pdfPageSize.width - 40, height: pdfPageSize.height - 200)
            
            // Create the attributes for the text (font, color, etc.)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            // Draw the text in the PDF context
            let pdfText = generateText()
            pdfText.draw(in: textRect, withAttributes: attributes)
        }
        
        // Save the PDF to the file system
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("generated.pdf")
        
        do {
            try pdfData.write(to: fileURL)
            print("PDF generated at: \(fileURL)")
        } catch {
            print("Failed to save PDF: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
