//
//  InterestsViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Foundation


struct InterestViewModel: Hashable {
    var interestName: InterestsContainerConfiguration
}

extension InterestViewModel {
    static func transform(from interests: [Interest]) -> [InterestViewModel] {
       var interestNames = [InterestViewModel]()
        var advanceBy = 0
        while(advanceBy < interests.count) {
            // TODO: not sure if we should generate this random number here
            // TODO: random Elements should also be driven by the server!!! so that they all render the same everytime
            let randomAmountOfElements = Int.random(in: 1...3) // TODO do not ranomise do it for each row use % 
            switch randomAmountOfElements {
                case 1:
                    let interest = interests[advanceBy]
                    advanceBy += 1
                    let viewModel = InterestViewModel(interestName: InterestsContainerConfiguration.transform(from: [interest], randomNumber: randomAmountOfElements))
                    interestNames.append(viewModel)
                case 2:
                    
                    let interests1 =  interests[advanceBy]
                    advanceBy += 1
                    guard let interests2 =  interests.get(advanceBy) else {
                        interestNames.append(InterestViewModel(interestName:
                                                                InterestsContainerConfiguration.transform(from: [interests1],
                                                                                                            randomNumber: 1)))
                        break
                    }
                    interestNames.append(InterestViewModel(interestName:
                                                            InterestsContainerConfiguration.transform(from: [interests1, interests2],
                                                                                   randomNumber: randomAmountOfElements)))
                    advanceBy += 1
                case 3:
                    let interests1 =  interests[advanceBy]
                    advanceBy += 1
                    guard let interests2 = interests.get(advanceBy) else { interestNames.append(InterestViewModel(interestName: InterestsContainerConfiguration.transform(from: [interests1], randomNumber: 1)))
                        break
                    }
                    
                    advanceBy += 1
                    
                    guard let interests3 = interests.get(advanceBy) else { interestNames.append(InterestViewModel(interestName: InterestsContainerConfiguration.transform(from: [interests1, interests2], randomNumber: 2)))
                        break
                    }
                    
                    interestNames.append(InterestViewModel(interestName: InterestsContainerConfiguration.transform(from: [interests1, interests2, interests3],
                                                                                   randomNumber: randomAmountOfElements)))
                    advanceBy += 1
                default:
                    let errorMsg = AppStrings.Error.clampedValueNotInRage(value: randomAmountOfElements, range: 1...3)
                    Logger.log(errorMsg)
                    preconditionFailure(errorMsg)
            }
        }
        return interestNames
    }
    
    // create a static function here that returns [[String]] so that when we impl infinate scroll!!
}

extension InterestsContainerConfiguration {
    static func transform(from insterest: [Interest], randomNumber: Int) -> InterestsContainerConfiguration {
        switch randomNumber {
            case 1:
                return .one(insterest[0].name)
            case 2:
                return .two(insterest[0].name, insterest[1].name)
            case 3:
                return .three(insterest[0].name, insterest[1].name, insterest[2].name)
            default:
                let errorMsg = AppStrings.Error.clampedValueNotInRage(value: randomNumber, range: 1...3)
                Logger.log(errorMsg)
                preconditionFailure(errorMsg)
        }
    }
}
