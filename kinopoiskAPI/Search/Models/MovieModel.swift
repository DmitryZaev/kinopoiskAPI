//
//  MovieModel.swift
//  kinopoiskAPI
//
//  Created by Dmitry Victorovich on 23.06.2022.
//

import Foundation

struct SiteAnswer: Codable {
    let docs: [MovieModel]
}

struct MovieModel: Codable {
    let poster: PosterModel?
    let name: String?
    let year: Int?
    let rating: Rating
    let description: String?
    let id: Int?
}

struct PosterModel: Codable {
    let url: String
}

struct Rating: Codable {
    let kp: Double?
    let imdb: Double?
}
