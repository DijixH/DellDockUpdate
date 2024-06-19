# Mise à jour des bases Dell

Lancer le raccourcis "MAJ Dell Dock", il exécute en administrateur le script de mise à jour des bases Dell.

1. Installation de Dell Command Monitor 

Le script vérifie si l'utilitaire est présent sur le poste, si oui une erreur est retourné sinon une installation silencieuse démarre.
L'utilitaire apporte la consultation de classes supplémentaire relative aux information sur les produits Dell dont l'état de la garantie du poste ou encore des périphériques connectés (entre autres).


2. Installation de Dell DSIA

Etape et fonction identique avec le Dell Command Monitor, apporte une lecture du matériel plus ancien de Dell.

3. Mise à jour des bases Dell

Après requêtage des classes relatives aux bases Dell (si possible), pour ciblage des postes avec une base Dell
Le script vérifie si une station Dell est connecté, si ce n'est pas le cas le script temporise et relance une vérification toutes les cinq minutes. Si une base est connecté le script lance la mise à jour silencieuse de la base. Si entre le moment de la détection et du lancement de la maj, la base est déconnecté, l'utilitaire DellWrapper est capable de temporiser la maj jusqu'au prochain branchement à une base Dell. 
Le script attend la fin du process pour confirmer la maj. 
Il désinstalle le DellWrapper qui est à usage unique et ne peut être relancé une fois installé.
Des logs sont disponible à l'emplacement du script.
Si la base est à jour le script retourne qu'elle l'est.

## Contraintes connues

- Le script n'est compatible qu'avec les PC Dell en raison de la nécessité d'un BIOS Dell pour la remonté d'information des équipements connectés au PC

## Problèmes connues

- Si deux modèles de bases différents (WD15 puis WD19X) sont mis à jour avec le même poste dans un délai inferieur à 2 minutes le script temporisera la maj avec le message "Attente de connexion d'une base..." même si la base est connecté. Il faudra soit attendre et relancer le script, soit attendre 5 minutes que la fonction de temporisation du script relance un check. La cause est que le module DSIA ne met pas à jour instantanéement les informations du poste à l'inverse du Dell Command Monitor.  