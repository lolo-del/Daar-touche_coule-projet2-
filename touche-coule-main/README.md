# Projet :  
Touché Coulé : l'idée du jeu est de combattre en chacun pour soi (tous les joueurs joueront en même temps) avec des vaisseaux. Chaque joueur dispose de deux navires, de taille 1. Au début de la partie, placez les navires sur une grille (50x50). À chaque tour, les vaisseaux pourront tirer une fois. Le but est de détruire tous les navires adverses.

# Implémentation :
- `Ship.sol` : Regroupe les méthodes communes entre les différents navires.
- `Main.sol` : Gère la mise en place des navires sur la grille et l'évolution des différentes parties du jeu, l'état des flottes des joueurs, et définit le nombre de parties du jeu.
-  `Les fonctionnalités` :
-  `registerShip` : Création d'un navire puis utilise son adresse pour appeler la fonction register qui s'occupe de son enregistrement.
-  `register(address ship)` : relier l'instance du navire pris en paramètre à un joueur, positionne le navire dans la grille.
-  `turn` : Tirer sur l'adversaire et vérifier l'état de la  grille, les résultats des différentes étapes et designer les joueurs perdants. 
- `MyShip.sol`: Représente le navire, ses coordonnées et fonctionnalités.
- `Les fonctionnalités` :
- `update` : 
    Change la position de notre navire et calcule les positions des adversaires, il prend comme paramètre les coordonnées de la position actuelle du navire (x,y).
- `place` : 
    Positionne le navire dans la grille de façon aléatoire, il prend en paramètre la longueur et la largeur de la grille et retourne les coordonnées 2D du navire.
- `fire` : 
    Attaque une des position cible générer précédemment dans update, en espérant que l'une d'elles soit la position de l'adversaire et retourne les coordonnées 2D de la cible.

# Auteurs :
MEHIDI Lisa ;
ELABBASSI Nisrine ;
NAVARRO Erwan
