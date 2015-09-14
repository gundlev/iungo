//
//  MyTableView.swift
//  iungo
//
//  Created by Niklas Gundlev on 07/08/15.
//  Copyright © 2015 Niklas Gundlev. All rights reserved.
//

import UIKit

class MyTableView: UITableView {

    func classNameAsString(obj: AnyObject) -> String {
        return _stdlib_getDemangledTypeName(obj).componentsSeparatedByString(".").last!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for view in self.subviews {
            if (classNameAsString(view) == "UITableViewWrapperView") {
                if view.isKindOfClass(UIScrollView) {
                    let scroll = (view as! UIScrollView)
                    scroll.delaysContentTouches = false
                }
                break
            }
        }
    }
}
