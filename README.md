# 1T-projet-final

# Présentation de l'équipe
**Lucas Silva** **Quentin Servais** **Mathieu Walravens** **Cyril GrandJean**

### Description du projet
  - BESOIN DU CLIENT

Le site simple task offre la possibilité aux utilisateurs de déposer des annonces et/ou d'en trouver et de se mettre en contact sans intermédiaires avec la personne désiré.



  - FONCTIONNALITÉS PRINCIPALES

    - Une page regroupant l'ensemble des tâches déjà proposées sur le site ainsi que d'une zone pour ajouter ses propres propositions de tâches. La recherche peut être affiné selon une catégorie de tâche, un lieu géographique ou le profil de la personne    
    - Un système de connexion/ inscription qui vise à protéger ainsi qu'à limité l'accès aux informations personnelles introduite dans le site.


  - FONCTIONNALITÉS SECONDAIRES

    - Une page d'accueil permettant de s'inscrire ou de se connecter sur le site.
    - Un profil public (accessible par tous) reprennant les données personnelles de chaque utilisateur. La personne visitant le profil peut laisser un commentaire ainsi qu'une note sur la prestation de la personne.
    - Un profil privé accessible uniquement au "propriétaire" du compte, lui permettant de voir et de modifier ses informations personnelles.
    - Une page listant tous les profils inscrits sur le site, et permettant d'accéder directement à leur profil public via un boutton.


# Aspects implémentés
La liste des aspects techniques qu'il faut implémenter pour mettre en place le projet, en séparant les aspects backend (base de données, procédures SQL, webservices, serveur de fichiers) et les aspects frontend (html, css, js, page web et fonctionnalités à proposer aux utilisateurs). ???

  - Base de données : Tables reprenant les informations sur les personnes, les tâches que certaines personnes proposent, et les avis laissés par d'autres personnes aux utilisateurs ;
  - Procédures SQL : Liste d'instructions appellées via un web service dans un JS afin d'ammener des informations dans la page ou de modifier la table.
  - Webservices : La plupart des webservices en JSON afin de modifier/ajouter/chercher des données ;
  - Serveur de fichiers :
  <!-- serveur central au sein d’un réseau d’ordinateurs qui met des systèmes de fichiers ou, tout du moins, des parties d’un système de fichiers à disposition des clients associés. Les serveurs de fichiers offrent ainsi aux utilisateurs un lieu de stockage centralisé pour les fichiers présents sur leurs propres supports de données, ce lieu étant accessible à tous les clients autorisés-->

  - HTML : page comprenant toutes les pages, affichant la page demandée et cachant le reste des pages en attendant ;
  - CSS : site le plus esthétique possible, et le plus ergonomique ;
  - JS : fonctions appelées lors de l'affichage d'une page ou lors d'un appel de bouton ;
  - Page web :
  - Fonctionnalités : permet s'inscrire/de se connecter. Egalement de déposer/chercher des tâches, affiner sa recherche de tâche selon differents critères; de mettre des avis/note aux différentes personnes de la communauté, actualiser ses informations;

# Détail api rest
endpoint = ce que fait ta procédure, son but, que fait-elle
format = ce qu'elle renvoie en quel format etc /!\ faire du français pas juste mettre les noms des colonnes
param = mm chose, que prend la procédure

- Aurélien Brille :
    - receiveData : appelle la procédure "inscription"
      - Paramètres : ce service prend 9 paramètres en compte lors de l'inscription via le syte HTML. Le nom, prénom, nom d'utilisateur, mail, téléphone, ville, naissance, mot de passe, mot de passe de confirmation et couleur de l'avatar.
      - Format de réponse : Ne renvoi rien.
      - Endpoint  : ajoute dans la table dba.communaute, un nouvelle ligne contenant toutes les informations de la nouvelle personne inscrite sur base des données fournies.

    - serv_connexions : appelle la procédure "proc_connexion"
      - Paramètres : les deux paramètre de ce service sont reçu lors de la connexion, le service reçoit le nom d'utilisateur et le mot de passe de l'utilisateur.
      - Format de réponse : renvoi en JSON un tableau contenant (ou non) le nom d'utilisateur et le mot de passe entré par la personne qui correspond (ou non) à  "idCom VARCHAR(16) NOT NULL" et "mdp VARCHAR(20) NOT NULL" d'une même ligne dans la table dba.communaute.
      - Endpoint  : permet une vérification du nom d'utilisateur et du mot de passe entré, en cas d'erreur, renvoi un tableau vide (tableau.length = 0 = false) en cas de concordance, renvoi un tableau de longueur 1 (tableau.length = 1 = true) et l'utilisateur est connecté.

- Cécile Bonnet :
    - serv_Desc : appelle la procédure proc_Desc
      - Paramètres : Prend en paramètre, la nouvelle description introduite dans la page HTML privé & l'id de la personne connecté
      - Format de réponse : Pas de réponse -> Modifie la table
      - Endpoint  : Va modifier la description de la personne connecté, dans la table communauté.

    - serv_Mail : appelle la procédure proc_Mail
      - Paramètres : Prend en paramètre la nourvelle adresse mail introduite dans la page HTML privé & l'id de la personne connecté
      - Format de réponse : Pas de réponse -> Modifie la table
      - Endpoint  : Va modifier l'adresse mail de la personne connecté, dans la table communauté.

    - serv_Notes :
      - Paramètres : Prend en paramètre, la nouvelle note introduite dans la page HTML publique & l'id de la personne connecté
      - Format de réponse : Pas de réponse -> Modifie la table
      - Endpoint  : Va modifier la note de la personne connecté, dans la table communauté.

    - serv_Telephone : appelle la procédure proc_Telephone
      - Paramètres : Prend en paramètre, la nouvelle description introduite dans la page HTML privé & l'id de la personne connecté
      - Format de réponse : Pas de réponse -> Modifie la table
      - Endpoint  : Va modifier le telephone de la personne connecté, dans la table communauté.

    - serv_Ville : appelle la procédure proc_ville
      - Paramètres : Prend en paramètre, la nouvelle description introduite dans la page HTML & l'id de la personne connecté
      - Format de réponse : Pas de réponse -> Modifie la table
      - Endpoint  : Va modifier la ville de la personne connecté, dans la table communaué

    - serv_com : appelle la procédure proc_com
      - Paramètres : Prend en paramètre, le nouveau commentaire , l'id de la personne chez qui est écrit le commentaire & l'id de la personne connecté
      - Format de réponse : Pas de réponse -> Modifie la table
      - Endpoint  : Va ajouter le commentaire introduit dans la page HTML publique dans la table commentaire avec l'id de l'auteur du commentaire ainsi que l'id du destinataire de ce commentaire.

    - serv_valeurs : appelle la procédure proc_valeurs
      - Paramètres : prend en paramètre l'identifiant (idCom) de la personne sur laquelle on a cliqué dans la page Communauté
      - Format de réponse :Cette procédure renvoie en JSON uniquement (sur base de l'id de  la personne)  les informations nécéssaires dans la page publique pour faire un portrait visible par les autres utilisateurs. Pour cela nous avons besoin du nom [VARCHAR(30)], du prénom [VARCHAR(30)], du sex [CHAR(1)], du numéro de télephone [VARCHAR(15)], le mail [VARCHAR(40)], la date de naissance [DATE], la photo [VARCHAR(50)], le portrait [VARCHAR(120)], la ville via un join sur postal dans la table villes [INTEGER], la cote [INTEGER], les commentaires via un join sur idCom dans la table commentaires [ VARCHAR(120)] et pour finir les taches qu'il propose via un join sur idCom dans la table taches [ VARCHAR(100)]
      - Endpoint  : Lorsque la personne connecté click sur un des profils de la page communauté, les procédures renvoie les infos dans la page profil publique afin de se faire une idée sur la personne ainsi que de la contacter.

    - serv_valeursBis : appelle la procédure proc_valeursBis
      - Paramètres : prend en paramètre l'identifiant de la personne connecté
      - Format de réponse : renvoie en JSON les uniquement les informations nécéssaires (sur base de l'id de la personne connecté) dans la page privé pour en faire un portrait personnel et modifiable . Pour cela nous avons besoin du nom [VARCHAR(30)], du prénom [VARCHAR(30)], du sex [CHAR(1)], du numéro de télephone [VARCHAR(15)], le mail [VARCHAR(40)], la date de naissance [DATE], la photo [VARCHAR(50)], le portrait [VARCHAR(120)], la ville via un join sur postal dans la table villes [INTEGER],  et pour finir les taches qu'il propose via un join sur idCom dans la table taches [ VARCHAR(100)]
      - Endpoint  : Cette procédure envoie dans la page du profil privé de la personne connecté les informations générales qu'il peut en partie modifier comme sa ville son mail, son portrait ext..

- Clémentine Sacré :
    - serv_donnees (appelle procédure "donnee"):
      - Paramètres : /
      - Format de réponse : renvoie en JSON le nom (varchar de 30) de toutes les personnes, ainsi que leur prénom (varchar de 30), leur photo (varchar de 50), leur portrait (varchar de 120) et leur cote (entier entre 0 et 10) afin de pouvoir afficher un pré-profil de chaque personne inscrite. Leur id (varchar de 16) est également renvoyé afin de pouvoir accéder à une autre page plus développée sur chacun d'eux ;
      - Endpoint  : Retrouve les données utiles pour la page communauté et les renvoie ;

 - Noelle Khazoum :
    - serv_aff :(appelle la procédure "proc_aff")
      - Paramètres : /
      - Format de réponse : 1) dans la page TACHE; envoie en JSON la tache (LONG VARCHAR), sa description, details (long varchar) et les informations de la personne concernée (nom (varchar(50), prenom (varchar(50), mail (varchar (60), telephone (vARCHAR (15)), ville (vARCHAR(50)).
      2) dans la page Affiner; envoie en JSON les iformations triés par categorie (varchar (30)) avec la tache (long varchar), par nom (varchar (50)) et par ville (varchar (50)).
      - Endpoint  : Affiche dans les pages Tache et Affiner les taches et les informations liées.

    - serv_ajouterTask : (appelle la procédure "proc_ajouterTask)
      - Paramètres : prend en paramètres la nouvelle tache ajoutée, sa catégorie, sa description et l'id de la personne qui a ajouté cette tâche.
      - Format de réponse : pas de reponse.
      - Endpoint  : Crée une nouvelle ligne dans la base de donnée.


# Détail DB
![](photo/image.png)
- Table des villes (contient 6 villes et leur code postal attitré) :
    - postal représente la PK de la table, qui représente le code postal d'une ville, en chiffre ;
    - ville représente le nom de la ville ;

- Table de la communauté (toutes les informations sur les personnes inscrites) :
    - idCom qui représente la PK de la table, l'identifiant de l'utilisateur, c'est le nom qu'il utilise pour se connecter ;
    - mdp représente le mot de passe que l'utilisateur utilise pour pouvoir se connecter au site ;
    - nom représente le nom de l'utilisateur ;
    - prenom représente le prénom de l'utilisateur ;
    - sexe représente le sexe de l'utilisateur ;
    - telephone représente le n° de téléphone de l'utilisateur, c'est par là que la communauté communique pour engager le travailleur pour la durée d'une tâche ;
    - mail représente le mail de l'utilisateur, autre moyen utilisé par la communauté pour communiquer entre elle ;
    - anniversaire représente l'anniversaire de la personne, ce qui permet de connaitre son âge ;
    - photo représente une photo de la personne. Il y a également des photos par défaut si la personne n'en a pas d'elle ;
    - portrait représente une courte description de l'utilisateur afin que la communauté en sache un peu plus sur lui ;
    - postal représente une FK dans la table et renvoie donc le code postal de la ville dans laquelle l'utilisateur habite vit ;
    - cote représente une note donnée par le reste de la communauté à l'utilisateur selon la qualité de ce qu'il fait (travail ou engage), ce qui permet d'avoir un premier appriori quant à la manière de faire de l'utilisateur  ;

- Table des tâches (toutes les tâches disponibles sur le site) :
    - idCom représente une FK dans la table, c'est l'identifiant de l'utilisateur qui propose la tâche ;
    - tache représente le nom de la tâche proposée par l'utilisateur ;
    - details représente une description brève de la tâche proposée par l'utilisateur ;
    - idCar représente une FK dans la table, c'est l'identifiant de la catégorie de tâche que l'utilisateur a proposé ;

- Table des commentaires (avis que certaines personnes laissent à d'autres personnes) :
    - idCom représente une FK dans la table, c'est l'identifiant de la personne chez qui on laisse le commentaire ;
    - commentaire représente un avis laissé repar un autre utilisateur, ce qui permet à la communauté d'avoir un avis sur l'utilisateur, positif ou négatif ;
    - auteur représente l'identifiant de la personne qui écrit le commentaire ;

- Table des catégories (les différentes catégories de tâches existantes) :
  - idCar représente l'identifiant d'une catégorie de tâche ;
  - categorie représente le nom de la catégorie ;
