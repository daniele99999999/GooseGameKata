# GooseGameKata

## Description
GooseGameKata is a proposed solution about this [Kata](https://github.com/xpeppers/goose-game-kata). For all general information about the game, you can read the [readme](https://github.com/xpeppers/goose-game-kata/blob/master/README.md).
In this implementation there are some enhancements, mostly on CLI command you can provide.

## Usage
These are the list of commands available through CLI:
 - **help**: shows a list of all commands available
```swift
help
******************************************************************
*                         The Goose Game .                       *
* help              - This Menu                                  *
* add player "name" - add a new player to the game               *
* move "name"       - system throws the dice and move the marker *
* move "name" 1, 2  - player throws the dice and move the marker *
* status            - show current standings                     *
* exit              - terminate game                             *
***************++*************************************************
```
 - **add**: add a new player to the game
```swift
add player pippo
players: pippo
```
- **move**: move the selected player. This command come in two flavors: you can provide dices value, or you can let the program provide them for you
```swift
move pippo 3, 5
pippo rolls 3, 5. pippo moves from 0 to 8.
```
- **status**: show the current standings of players, and the next one who have to move
```swift
status
status: pippo is in position 8, pluto is in position 7, pippo is next one to move
```
- **exit**: ends the game, and tell you bye bye!
```swift
exit
game terminated, goodbye!
```


The full set of rules has been implemented. The most significant ones are the following:
- **bridge**: if a player go on a space called *the bridge*, located at 6, he jump directly to position 12. For make a general rule about that, the underlying implementation consists by doubling current position: so 6 become 12, 10 become 20, and so on
```swift
move pippo 2, 4
pippo rolls 2, 4. pippo moves from 0 to The Bridge. pippo jump to 12.
```
- **goose**: if a player go on a space called * the goose*, he moves again by the same amount of positions, so practically does again previous move. It's possible also to do multiple jumps between multiple goose cells
```swift
move pippo
pippo rolls 2, 3. pippo moves from 0 to 5, The Goose. pippo moves again and goes to 10.
```
```swift
move pippo
pippo rolls 4, 5. pippo moves from 0 to 9, The Goose. pippo moves again and goes to 18, The Goose. pippo moves again and goes to 27, The Goose. pippo moves again and goes to 36.
```
- **prank**: if a player go on a space where there is already another player inside, they switch places. The only exception is of course the initial position (0)
```swift
move pippo 1, 4
pippo rolls 1, 4. pippo moves from 7 to 12. On 12 there is pluto, who returns to 7.
```
- **final place**: fo win, a player have to go exactly on the finish place: if he move forward, will fallback for the same amount of positions 
```swift
pippo rolls 6, 6. pippo moves from 53 to 63. pippo bounces! pippo returns to 61. 
```
These behaviors are configurable, by a configuration file. Its a JSON with this structure:
```swift
{
"GooseCells" : [5,9,14,18,23,27],
"BridgeCells" : [6],
"MultiplePlayerCells" : [0],
"GoalCell" : 63,
"MinNumberOfPlayers" : 2,
"Prank" : true
}
```

## Requirements
minimum osx version is 10.10, Cocoapods 1.5.2

## Installation
To run the project, clone the repo, and run `pod install` from the main directory.

## Author

Daniele99999999

## License

GooseGameKata is available under the MIT license. See the LICENSE file for more info.