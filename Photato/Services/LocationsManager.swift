//
//  LocationsManager.swift
//  Photato
//
//  Created by Alexander Sivko on 6.08.23.
//

import Foundation

protocol LocationsManagerLogic {
    var defaultLocations: [Location] { get }
}

class LocationsManager: LocationsManagerLogic {
    var imageManager: ImageManagerLogic?
    
    var defaultLocations: [Location] = []
    
    func createDefaultLocations() -> [Location] {
        imageManager = ImageManager()
        guard let imageManager = imageManager else { return [] }
        
        let botanicalGarden: Location = Location(
            name: "Ботанический сад",
            description: "Тихий ботанический сад: оранжереи, тропинки, множество видов деревьев, цветов и других растений. В глубине парка есть озеро с лебедями.",
            address: "Минск, ул. Сурганова, 2в",
            coordinates: Location.Coordinates(longitude: 53.9158906271127,
                                              latitude: 27.616241235227033),
            imagesData: [imageManager.getImageData(for: "BotanicalGarden1")]
        )
        
        let oktyabrskayaStreet: Location = Location(
            name: "Октябрьская улица",
            description: "Одно из самых популярных мест в городе. Здесь вы может и не сделаете неповтормые фотографии, однако наверняка найдёте очень много мест для красивых снимков. В вашем распоряжении: граффити и муралы, трибуна, уютный дворик и разнообразные заведения.",
            address: "Минск, ул. Октябрьская",
            coordinates: Location.Coordinates(longitude: 53.891684280291116,
                                              latitude: 27.570821040936153),
            imagesData: [imageManager.getImageData(for: "OktyabrskayaStreet1")]
        )
        
        
        let academyOfScience: Location = Location(
            name: "Академия наук",
            description: "Колонны сформируют красивую геометрию на снимке. Ходили слухи, что там запрещено фотографировать. Перед съёмкой лучше подойти к охране и пообщаться",
            address: "Минск, пр. Независимости, 66",
            coordinates: Location.Coordinates(longitude: 53.92061648902405,
                                              latitude: 27.59813254057363),
            imagesData: [imageManager.getImageData(for: "AcademyOfScience1")]
        )
        
        let minskBruklin: Location = Location(
            name: "Минский Бруклин",
            description: "Здания общежиий, фасады которых очень напоминают архитектуру Нью-Йорка. Если вы хотите нестандартные фото, то Вам сюда",
            address: "Минск, ул. Авангардная, 61/1",
            coordinates: Location.Coordinates(longitude: 53.91266098135321,
                                              latitude: 27.630829334417196),
            imagesData: [imageManager.getImageData(for: "Avangardnaya611.1")]
        )
        
        let slalomChannel: Location = Location(
            name: "Слаломный канал",
            description: "Построенный в 1981 году слаломный канал для подготовки сборной СССР по гребному слалому. В настоящее время практически заброшен и не используется по назначению. Добираться лучше на машине",
            address: "Агрогородок Ждановичи",
            coordinates: Location.Coordinates(longitude: 53.975282400623755,
                                              latitude: 27.449428364571908),
            imagesData: [imageManager.getImageData(for: "SlalomChannel1")]
        )
        
        var defaultLocations: [Location] = []
        defaultLocations.append(botanicalGarden)
        defaultLocations.append(oktyabrskayaStreet)
        defaultLocations.append(academyOfScience)
        defaultLocations.append(minskBruklin)
        defaultLocations.append(slalomChannel)
        
        return defaultLocations
    }
    
    init() {
        defaultLocations = createDefaultLocations()
    }
}
