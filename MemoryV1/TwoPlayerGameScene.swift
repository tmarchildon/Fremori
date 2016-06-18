//
//  TwoPlayerGameScene.swift
//  MemoryV1
//
//  Created by Teddy Marchildon on 6/16/16.
//  Copyright © 2016 Teddy Marchildon. All rights reserved.
//

import SpriteKit

class TwoPlayerGameScene: SKScene {
    
    var game = Game()
    var cards: [SKSpriteNode] = []
    var playerOneLabel: SKLabelNode!
    var playerTwoLabel: SKLabelNode!
    var playerOneScoreLabel: SKLabelNode!
    var playerTwoScoreLabel: SKLabelNode!
    var mainMenuLabel: SKLabelNode!
    var winnerLabel: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        game.playerOneTurn = true
        game.playerTwoTurn = false
        game.playerOneScore = 0
        game.playerTwoScore = 0
        if let playerOneScoreLabel = self.childNodeWithName("playerOneScoreLabel") as? SKLabelNode, let playerTwoScoreLabel = self.childNodeWithName("playerTwoScoreLabel") as? SKLabelNode, let playerOneLabel = self.childNodeWithName("playerOneScore") as? SKLabelNode, let playerTwoLabel = self.childNodeWithName("playerTwoScore") as? SKLabelNode, let winnerLabel = self.childNodeWithName("winnerLabel") as? SKLabelNode, let mainMenuLabel = self.childNodeWithName("backToMainLabel") as? SKLabelNode {
            self.playerOneScoreLabel = playerOneScoreLabel
            self.playerTwoScoreLabel = playerTwoScoreLabel
            self.playerOneLabel = playerOneLabel
            self.playerOneLabel.fontColor = UIColor.blueColor()
            self.playerTwoLabel = playerTwoLabel
            self.winnerLabel = winnerLabel
            self.winnerLabel.hidden = true
            self.mainMenuLabel = mainMenuLabel
        }
        for card in cards {
            self.addChild(card)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let node = nodeAtPoint(location)
            if let card = node as? Card {
                if game.firstChoice == nil {
                    card.selected = true
                    card.flip()
                    card.faceUp = true
                    game.firstChoice = card
                }
                else if game.secondChoice == nil && !card.selected {
                    card.flip()
                    card.faceUp = true
                    game.secondChoice = card
                }
                if game.secondChoice != nil && game.firstChoice != nil {
                    let delay = 1.5 * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        self.game.twoPlayerTestMatch()
                        self.updateScoreLabels()
                        self.testEndGame()
                    })
//                    NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(testMatch), userInfo: nil, repeats: false)
                }
            } else if node == mainMenuLabel {
                if let scene = MainMenu(fileNamed: "MainMenu") {
                    scene.scaleMode = .AspectFit
                    self.view?.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(1.5))
                }
            }
        }
    }
    
    func updateScoreLabels() {
        if game.playerOneTurn! {
            game.playerOneTurn = false
            game.playerTwoTurn = true
            playerOneScoreLabel.text = "\(game.playerOneScore!)"
            playerTwoLabel.fontColor = .blueColor()
            playerOneLabel.fontColor = .whiteColor()
        } else {
            game.playerTwoTurn = false
            game.playerOneTurn = true
            playerTwoScoreLabel.text = "\(game.playerTwoScore!)"
            playerOneLabel.fontColor = .blueColor()
            playerTwoLabel.fontColor = .whiteColor()
        }
    }
    
    func testEndGame() {
        if self.children.count < 7 {
            game.finished = true
            if game.playerOneScore > game.playerTwoScore {
                winnerLabel.text = "Player 1 won!"
                playerOneLabel.fontColor = .redColor()
                playerTwoLabel.fontColor = .whiteColor()
            } else if game.playerTwoScore > game.playerOneScore {
                winnerLabel.text = "Player 2 won!"
                playerOneLabel.fontColor = .whiteColor()
                playerTwoLabel.fontColor = .redColor()
            } else {
                winnerLabel.text = "Tie!"
                playerOneLabel.color = .whiteColor()
                playerTwoLabel.color = .whiteColor()
            }
            winnerLabel.hidden = false
        }
    }
    
    func flipBoth(card1: Card, card2: Card) {
        card1.flip()
        card2.flip()
    }
}

