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
                generatePDF(hasLogo: true)
            }
            .padding()
        }
    }
    
    func generateText() -> String {
        let insertData = "Inserted Text"
        let defaultData = """
            This is line one.
                             
            This is a really long paragraph that needs to use word wrap in order to display correctly. This is a really long paragraph that needs to use word wrap in order to display correctly. This is a really long paragraph that needs to use word wrap in order to display correctly.
            """
        return "\(insertData)\n\n\(defaultData)"
    }
    
    func generatePDF(hasLogo: Bool) {
        // Set page size to standard letter size (8.5 x 11 inches)
        let pdfPageSize = CGSize(width: 612, height: 792)
        
        // Create a PDF context
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pdfPageSize))
        
        // Generate the PDF data
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            
            // Conditionally draw the logo at the top left
            if hasLogo, let logoImage = UIImage(named: "myLogo") {
                let logoRect = CGRect(x: 20, y: 20, width: 100, height: 50) // Adjust size as needed
                logoImage.draw(in: logoRect)
            }
            
            // Set up the text rendering
            let font = UIFont.systemFont(ofSize: 10)
            let textStartY: CGFloat = hasLogo ? 80 : 20  // Adjust text position if logo is present
            let textRect = CGRect(x: 20, y: textStartY, width: pdfPageSize.width - 40, height: pdfPageSize.height - textStartY - 200)
            
            // Text attributes
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            // Generate text and calculate its height
            let pdfText = generateText()
            let attributedText = NSAttributedString(string: pdfText, attributes: attributes)
            
            // Calculate the bounding box of the text
            let textBoundingRect = attributedText.boundingRect(
                with: CGSize(width: textRect.width, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            )
            
            // Draw the text in the PDF context
            attributedText.draw(in: CGRect(x: textRect.origin.x, y: textRect.origin.y, width: textBoundingRect.width, height: textBoundingRect.height))
            
            // Calculate the position for the additional image (myImage.png), 20 points below the end of the text
            let imageYPosition = textRect.origin.y + textBoundingRect.height + 20
            if let image = UIImage(named: "myImage") {
                let imageRect = CGRect(x: 20, y: imageYPosition, width: 200, height: 200) // Adjust width and height as needed
                image.draw(in: imageRect)
            } else {
                print("Image not found.")
            }
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
