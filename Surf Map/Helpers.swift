import Foundation
import UIKit

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage {
        //  Created by samwize on 6/1/16.
        //  http://samwize.com/2016/06/01/resize-uiimage-in-swift/
        //  Copyright © 2016 samwize. All rights reserved.
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}

extension String {
    func image() -> UIImage {
        //  Created by appzYourLife on 8/6/16.
        //  http://stackoverflow.com/questions/38809425/convert-apple-emoji-string-to-uiimage
        //  Copyright © 2016 appzYourLife. All rights reserved.
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIRectFill(CGRect(origin: CGPoint.zero, size: size))
        (self as NSString).draw(in: rect, withAttributes:
            [NSFontAttributeName: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
