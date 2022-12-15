//
//  LivenessResult.swift
//  PartnerOneSDK
//
//  Created by Aller Allegro on 15/12/22.
//

import Foundation


open class LivenessResult{
    
    public init(faceScan:String="",auditTrailImage:String="",lowQualityAuditTrailImage:String="")
    {
        self.faceScan = faceScan
        self.auditTrailImage=auditTrailImage
        self.lowQualityAuditTrailImage=lowQualityAuditTrailImage
    }
    
    public var faceScan: String = ""
    public var auditTrailImage: String = ""
    public var lowQualityAuditTrailImage: String = ""
    
}
