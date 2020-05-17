# 1TM1-projetData-MyAnimList 2019-2020
## Présentation de l'équipe
 - **Lucas Silva** 
 - **Cyril Grandjean**
 - **Quentin Servais** 
 - **Mathieu Walravens**
## Description du projet
###### BESOIN DU CLIENT
  
Notre site MyAnimeList permet à un utilisateur de tenir à jour sa liste personnelle des différents animés qu'ils regardent pour lui donner une note.




###### FONCTIONNALITÉS PRINCIPALES
  - Une page pour ajouter un animé dans sa liste et lui donner une note. L'anime garde la dernière note .
  - Une page pour ajouter un animé dans la base de donnée au cas où il n'y serait pas déjà.
  
    

###### FONCTIONNALITÉS SECONDAIRES
    
  - Une page d'accueil permettant de s'inscrire ou de se connecter sur le site. On y voit tous les animés avec la moyenne des notes de chacun des utilisateurs. Triée par note de la plus haute à la plus basse.
  - Un profil privé accessible uniquement au "propriétaire" du compte, lui permettant de voir et de modifier son AnimeList.
  - Une page listant tous les profils inscrits sur le site, et permettant d'accéder directement à leur profil public via un boutton.
    

## Aspects implémentés
La liste des aspects techniques qu'il faut implémenter pour mettre en place le projet, en séparant les aspects backend (base de données, procédures SQL, webservices, serveur de fichiers) et les aspects frontend (html, css, js, page web et fonctionnalités à proposer aux utilisateurs);
  - Base de données : Table de données pour enregistrer les différents genres et les animés présent sur le site, y stocker les données utilisateurs (pseudo,mdp,...) et garder les liens entre chaque utilisateur et un animé à travers d'une note;
  - Procédures SQL : Liste d'instructions appellées via un web service dans un JS afin d'ammener des informations dans la page ou de modifier la table;
  - Webservices : La plupart des webservices en JSON afin de modifier/ajouter/chercher des données ;
  
  
  - HTML : page comprenant toutes les pages, affichant la page demandée et cachant le reste des pages en attendant 
  - CSS : site le plus esthétique possible, et le plus ergonomique 
  - JS : fonctions appelées lors de l'affichage d'une page ou lors d'un appel de bouton 
  - Fonctionnalités : permet s'inscrire/de se connecter. Egalement de déposer/chercher des tâches, affiner sa recherche de tâche selon differents critères; de mettre des avis/note aux différentes personnes de la communauté, actualiser ses informations; 

## Détail api rest

- **Lucas Silva** :
    - Nom_du_Service : 
      - Paramètres :
      - Format de réponse :
      - Endpoint :
 
- **Cyril Grandjean** :
    
- **Mathieu Walravens** :
 
- **Quentin Servais** :
  
# Détail DB
![](utile/images/diagramme_LI.jpg)


