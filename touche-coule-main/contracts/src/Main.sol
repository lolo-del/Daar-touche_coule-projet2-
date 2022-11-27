// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import './Ship.sol';
import './MyShip.sol';
import 'hardhat/console.sol';

struct Game {
  uint height;
  uint width;
  //Nombre de tours d'une bataille 
  uint nbTourMax ;
  mapping(uint => mapping(uint => uint)) board;
  mapping(uint => int) xs;
  mapping(uint => int) ys;
}

contract Main {
  Game private game;
  uint private index;
  mapping(address => bool) private used;
  mapping(uint => address) private ships;
  mapping(uint => address) private owners;
  mapping(address => uint) private count;  
  //La liste des navires du jeux
  Ship[] myShips;
  event Size(uint width, uint height);
  event Touched(uint ship, uint x, uint y);
  event Registered(
    uint indexed index,
    address indexed owner,
    uint x,
    uint y
  );
 
  constructor() {
    game.width = 50;
    game.height = 50;
    //Initialiser le nombre de tour Max du jeux
    game.nbTourMax= 3;
    index = 1;
    emit Size(game.width, game.height);
  }

  /**
   * register : Ajout d'un navire au joueur qui déploie le contrat 
   * Paramètre : l'adresse du navire 
   */
  function register(address ship) public{
    require(count[msg.sender] < 2, 'Only two ships');
    require(!used[ship], 'Ship alread on the board');
    require(index <= game.height * game.width, 'Too much ship on board');
    count[msg.sender] += 1;
    ships[index] = ship;
    owners[index] = msg.sender;
    (uint x, uint y) = placeShip(index);
    Ship(ships[index]).update(x, y);
    emit Registered(index, msg.sender, x, y);
    index += 1;
  }

  /**
   * @dev onction registerShip : Création d'un navire et utilise son adresse
   * pour appeler register qui s'occupe de son enregistrement
   */
  function registerShip()public{
    require(count[msg.sender] < 2, 'Only two ships');
    require(index <= game.height * game.width, 'Too much ship on board');
    //Création d'une instance navire 'MyShip'
    Ship newShip = new MyShip(msg.sender);
    myShips.push(newShip);
    register(address(newShip));
  }

  /**
   * @dev : Tire sur l'adversaire et vérifier l'état d grille et les résultats des différentes étapes.
   */
  function turn() public {
    //Annonce la fin de la partie 
    require(game.nbTourMax >0,"Fin de la partie");
    bool[] memory touched = new bool[](index);
    for (uint i = 1; i < index; i++) {
      if (game.xs[i] < 0) continue;
      Ship ship = MyShip(ships[i]);
      (uint x, uint y) = ship.fire(); 
      if (game.board[x][y] > 0) {
        touched[game.board[x][y]] = true;
      }    
    }
    //Décrémenter le nombre de tours après chaque tire de tous les navires de la grille 
    game.nbTourMax--;
    for (uint i = 0; i < index; i++) {
      if (touched[i]) {
        MyShip ship = MyShip(ships[i]);
        //Décrémenter le nombre de navires du joueur toucher par le tire
        if(ship.getX() == uint(game.xs[i]) && ship.getY() == uint(game.ys[i]))
        {
          count[ships[i]]--;
        }
        //Annoncer les joueurs qui ont perdu 
        if(game.nbTourMax == 0 && count[ships[i]] == 0) 
        {
            console.log("le joueur  ",ships[i], " a perdu la partie");
        }
        emit Touched(i, uint(game.xs[i]), uint(game.ys[i]));
        game.xs[i] = -1;
      }
    }
    
    
  }
  /**
   * @dev : fonction placeShip : positionne un navire dans la grille et le relier à un joueur.
   * return : les coordonnées 2D du navire 
   */
  function placeShip(uint idx) internal returns (uint, uint) {
    Ship ship = MyShip(ships[idx]);
    (uint x, uint y) = ship.place(game.width, game.height);
    bool invalid = true;
    while (invalid) {
      if (game.board[x][y] == 0) {
        game.board[x][y] = idx;
        game.xs[idx] = int(x);
        game.ys[idx] = int(y);
        invalid = false;
      } else {
        uint newPlace = (x * game.width) + y + 1;
        x = newPlace % game.width;
        y = newPlace / game.width;
        invalid = false;
      }
    }
    return (x, y);
  }
}
