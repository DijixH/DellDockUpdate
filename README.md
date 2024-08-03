# Mise à jour des bases Dell

Lancer le raccourcis "MAJ Dell Dock", il exécute en administrateur le script de mise à jour des bases Dell.

## Pour les PC Dell

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

## Pour les autres marques de PC

1. Test de la présence d'une base Dell WD19/WD22 series

Le script lance une vérification de la version des composants de la base connecté via le package d'installation sans lancer d'installation. Si aucune base est connecté le script l'indique et s'arrête. 

2. Mise à jour des bases Dell

Si une base est connecté elle indique le modèle, le service tag et la version présente sur la base. Un test de la présence de la dernière version s'effectue alors, si la version n'est pas la bonne la mise à jour est lancé, sinon le script indique que la base est à jour et s'arrête.

## Logs

Le script log tout son déroulement dans le répertoire "logs".

## Contraintes connues

- Pour les bases Dell WD15 : Le script n'est compatible qu'avec les PC Dell en raison de la nécessité d'un BIOS Dell pour la remonté d'information des équipements connectés au PC ainsi que pour le lancement de l'utilitaire de MAJ des WD15 qui n'est compatible qu'avec les postes Dell.

## Problèmes connues

- Si deux modèles de bases différents (WD15 puis WD19X) sont mis à jour avec le même poste Dell dans un délai inferieur à 2 minutes le script temporisera la maj avec le message "Attente de connexion d'une base..." même si la base est connecté. Il faudra soit attendre et relancer le script, soit attendre 5 minutes que la fonction de temporisation du script relance un check. La cause est que le module DSIA ne met pas à jour instantanéement les informations du poste à l'inverse du Dell Command Monitor. 

# Dell Dock Base Updates

Launch the "Dell Dock Update" shortcut; it runs the Dell base update script with administrator privileges.

## For Dell PCs

1. Dell Command Monitor Installation

The script checks if the utility is present on the computer. If it is, an error is returned; otherwise, a silent installation begins. The utility provides additional classes for information about Dell products, including warranty status and connected peripherals (among other details).

2. Dell DSIA Installation

This step and function are identical to the Dell Command Monitor. It provides hardware information for older Dell devices.

3. Dell Base Updates

After querying the classes related to Dell bases (if possible) to target computers with a Dell base, the script checks if a Dell station is connected. If not, the script waits and rechecks every five minutes. If a base is connected, the script silently updates the base. If the base is disconnected between detection and update launch, the DellWrapper utility can delay the update until the next connection to a Dell base. The script waits for the process to finish before confirming the update. It uninstalls the DellWrapper, which is single-use and cannot be relaunched. Logs are available in the script's location. If the base is up-to-date, the script indicates so.

## For other PC brands

1. Testing for Dell WD19/WD22 Series Base Presence

The script checks the version of components connected to the base using the installation package without launching an installation. If no base is connected, the script indicates this and stops.

2. Dell Base Updates

If a base is connected, it provides the model, service tag, and current version. It then tests for the presence of the latest version. If the version is incorrect, the update is launched; otherwise, the script indicates that the base is up-to-date and stops.

## Logs

The script logs its entire process in the "logs" directory.

## Known Constraints

- For Dell WD15 bases: The script is only compatible with Dell PCs due to the need for a Dell BIOS to retrieve information about connected equipment and to launch the WD15 update utility, which is only compatible with Dell computers.

## Known Issues

- If two different base models (WD15 and WD19X) are updated on the same Dell computer within less than 2 minutes, the script will delay the update with the message "Waiting for base connection..." even if the base is connected. You can either wait and relaunch the script or wait 5 minutes for the script's built-in delay function to recheck. This issue occurs because the DSIA module does not instantly update the computer's information, unlike the Dell Command Monitor.
