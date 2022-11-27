// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
import "./Ship.sol";
import 'hardhat/console.sol';

/**
 * @title Contrat qui représente un navire et ses méthodes
 */
contract MyShip is Ship{
    uint actuelPos =0;
    uint nextPos =0;
    uint height =50;
    uint width = 50;
    address gamerAdress;
    uint numShip =0;
   // Coordonnées (x,y) du navire
   uint x = 1;
   uint y = 1;
   uint decalage = 1;
   //La grille du jeu : Je mets la position de mon navire à true , tout ce qui est false est une cible. 
   bool [] grille;
   //Liste des positions des cibles 
   uint[] attackPos;
   

   constructor(address _gamer){
      //L'adresse du Joueur
      gamerAdress = _gamer;
      //Numéro du navire
      numShip = numShip + 1;
      grille = new bool[](width * height);
   }

  function getX()public view returns(uint){
   return x;   
  }
  function getY()public view returns(uint){
   return y;   
  }
  function getNumShip()public view returns(uint){
   return numShip;   
  }
  /**
   * @dev update fonction : change la position de notre navire et calcule les positions des adversaires.
   * Paramètres : les coordonnées de la position actuelle du navire (x,y)
   */
  function update(uint _x, uint _y) public override{
      uint randx =0;
      uint randy =0;
      if((_x * _y * width) < grille.length)
      {
         actuelPos = _x * _y * width;
         grille[actuelPos] = false;
         console.log("Fonction update : mes nouvelles coordonnees (x ,y) " , getX(),getY());
      } 
      //Générer les coordonner à cible de façon aléatoire 
      randx = uint(keccak256(abi.encodePacked(block.timestamp,gamerAdress,(_x+decalage)))) % width;
      randy = uint(keccak256(abi.encodePacked(block.timestamp,gamerAdress,_y))) % height;
      decalage++;
      //La position de la cible 
      nextPos = (randx * randy)  * width;
      console.log("La position de la cible : ",nextPos);
      //Remplir un tableau de position cible qu'on va utiliser plus tard dans la fonction fire()
      while(nextPos > actuelPos && nextPos < width* height)
      {
         attackPos.push(nextPos);
         nextPos +=1;
      }
      if( nextPos  == width* height || actuelPos == width* height)
      {
         actuelPos = x * y * width;
      }
  }
  /**
   * @dev La fonction place : positionne le navire dans la grille de façon aléatoire.
   * Paramètres : la longueur et la largeur de la grille
   * return : les coordonner 2D du navire
   */
  function place(uint _width, uint _height) public override returns (uint, uint){
    if(_width > 2 && _height >2 && decalage < _width ) 
    {
      width = _width;
      height = _height;
      //Générer les coordonnées du navire de facon aléatoire
      x = uint(keccak256(abi.encodePacked(block.timestamp,gamerAdress,decalage))) % width;
      y = uint(keccak256(abi.encodePacked(block.timestamp,gamerAdress,decalage + numShip))) % height;
      //Calculer la position actuelle du navire 
      actuelPos = x * y * width;
      nextPos = actuelPos;
      decalage = decalage +3;
      //Verifier que la position de mon navire rentre dans la grille 
      if(actuelPos < grille.length)
      {
         grille[actuelPos] = true;
      }  
    }
    console.log("Fonction place : mes coordonnees (x ,y) " , getX(),getY());
    return (getX(),getY());     
  }
   /**
   * @dev fonction fire : Attack une des position cible générée précédemment, en espérant que l'une d'elles soit
   * la position de l'adversaire
   * return : les coordonnées 2D de la cible 
   */
   function fire() public override returns (uint, uint){
      uint randx =0;
      uint randy =0;
      nextPos = nextPos +1;
      
      //Eviter de tirer sur soi même 
      if(nextPos == actuelPos && nextPos < width* height)
      {
         nextPos++;
      }
      if(x > 0 && y > 0)
      {
         //Parcourir le tableau des positions cible
         for(uint i=0;i<attackPos.length;i++)
         {
            //Vérifier que la cible est dans la grille 
            if(attackPos[i]!=0 && attackPos[i] < grille.length)
            {
               //Vérifier que la cible n'est pas moi 
               if(grille[attackPos[i]] == false)
                  {
                     if(((attackPos[i]/ width)/y) >0 && ((attackPos[i]/ width)/y) >0)
                     {
                        console.log("la fonction fire : la cible (cibleX,cibleY)" ,(attackPos[i]/ width)/y ,(attackPos[i] / width)/x); 
                        //Retourner les coordonnées 2D de la cible  
                        return ((attackPos[i]/ width)/y,(attackPos[i] / width)/x);
                     }                    
                  }
               break;
            }   
         }
      }
      //Calculer la cible aléatoirement dans le cas où aucune des cibles pré-calculée ne convient
      while(randx == 0 || randy == 0)
      {
         uint i = 1;
         //On utilise le temps, l'adresse du joueur, et une valeur de décalage 
         randx = uint(keccak256(abi.encodePacked(block.timestamp,gamerAdress,i))) % width;
         randy = uint(keccak256(abi.encodePacked(block.timestamp,gamerAdress,i))) % height; 
         i++;
      } 
      //Retourner les coordonnées 2D de la cible
      console.log("la fonction fire : la cible (cibleX,cibleY)" ,randx ,randy);     
      return (randx,randy);
   }
}

