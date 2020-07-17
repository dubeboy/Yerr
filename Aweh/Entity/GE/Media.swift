//
// Media.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public struct Media: Codable {

    /** unique identifier of the */
    public var uuid: String
    /** type of file (jpg, mp4) */
    public var type: String
    /** data related to the file */
    public var metadata: String?

    public init(uuid: String, type: String, metadata: String?) {
        self.uuid = uuid
        self.type = type
        self.metadata = metadata
    }


}

