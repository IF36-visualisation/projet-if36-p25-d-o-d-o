# Analyse de l’utilisation des vélos libre-service à Washington

## Introduction

### Données

Nous utilisons 4 jeux de données pour analyser l’utilisation des vélos libre-service à Washington :

**Information sur les locations de vélos** (source :https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408?select=station_list.csv)

- **Nom du dataset :** daily_rent_detail.csv
- **Origine des données** : Ces données proviennent de l’entreprise Capital Bike Share, l’entreprise de location de vélos libre service de Washington.
- **Pourquoi ces données ?** Elles permettent d’observer l’utilisation de ces vélos, en analysant les dates et heures d’utilisation, les lieux d’emprunt et de dépôt notamment.
- **Nombre d’observations** : 16 086 673
- **Nombre de colonnes** : 13 colonnes incluant :
    - Identifiant du trajet (”ride_id”)
    - Type du vélo (”rideable type”) : vélo classique, électrique, autre (cargo)
    - Date et heure de l’emprunt (”started_at”)
    - Date et heure du retour (”ended_at”)
    - Nom de la station de départ (”start_station_name”)
    - Identifiant de la station de départ (”start_station_id)
    - Nom de la station d’arrivée (”end_station_name”)
    - Identifiant de la station d’arrivée (”end_station_id”)
    - Latitude de départ (”start_lat”)
    - Longitude de départ (”start_lng”)
    - Latitude d’arrivée (”end_lat”)
    - Longitude d’arrivée (”end_lng”)
    - Type d’abonnement du client (”member_casual”) : utilisateur en abonnement casual ou membre.
- **Créateur et éditeur** : Entreprise Capital Bike Share
- **Format** : CSV
- **Sous-groupes** :
    - Type de vélo : vélo classique, électrique et cargo
    - Type d’utilisateur : occasionnel et membre
    - Stations : possibilité d’analyser par station d’origine ou de destination
    - Périodes temporelles : heures, jours, saisons, etc…

 
**Liste des stations de Washington** (source :https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408?select=station_list.csv)

- **Nom du dataset :** station_list.csv
- **Origine des données** : Ces données proviennent de l’entreprise Capital Bike Share, l’entreprise de location de vélos libre-service de Washington.
- **Pourquoi ces données ?** Elles permettent d’avoir la liste des stations à Washington
- **Nombre d’observations :** 912 stations différentes
- **Nombre de colonnes :** 2 colonnes incluant **:**
    - Nom de la station
    - Identifiant de la station
- **Format :** CSV
- **Sous-groupes** :
    - Catégorisation géographique (ex: quartiers)


**Emprunts et dépôts des vélos par station** (source :https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408?select=station_list.csv)

- **Nom du dataset :** usage_frequency.csv
- **Origine des données** : Ces données proviennent de l’entreprise Capital Bike Share, l’entreprise de location de vélos libre-service de Washington.
- **Pourquoi ces données ?** Elles permettent d’avoir le nombre d’emprunt et de dépôt pour chaque station à Washington
- **Nombre d’observations :** 873 318
- **Nombre de colonnes :** 4 colonnes incluant **:**
    - Date
    - Nom de la station
    - Nombre d’emprunt sur cette station
    - Nombre de dépôt sur cette station
- **Format :** CSV
- **Sous-groupes** :
    - Date
    - Stations : possibilité d’analyser par stations
    - Activité : Emprunt et dépôt
    - Utilisation : stations très utilisées et peu utilisées

**Météo (source :** https://www.kaggle.com/datasets/taweilo/capital-bikeshare-dataset-202005202408?select=weather.csv)

- **Nom du dataset :** weather.csv
- **Origine des données** : Ces données proviennent de l’entreprise Visual Crossing qui est un service de météo de Virginia aux Etats Unis.
- **Pourquoi ces données ?** Elles permettent d’obtenir la météo de chaque jour afin de pouvoir croiser ces données avec l’utilisation des vélos à Washington
- **Nombre d’observations :** 1584, une pour chaque jour entre mai 2020 et août 2024
- **Nombre de colonnes :** 32 colonnes dont 7 que nous allons utiliser **:**
    - Date (”*datetime”*)
    - Moyenne de température sur la journée (”*temp*”)
    - Moyenne de température ressentie sur la journée (”*feelslike*”)
    - Précipitations (”*precip*”) : quantité de liquide tombé / prévu dans la période
    - Epaisseur de neige au sol (”*snowdepth*”)
    - Couverture nuageuse (”*cloudcover*”) : entre 0 et 100%
    - Vitesse du vent (”*windspeed*”) : vitesse moyenne du vent soutenu, mesurée comme la vitesse moyenne du vent survenant au cours de la à deux minutes précédentes
- **Créateur et éditeur** : Visual Crossing (fournisseur de données météorologiques)
- **Format :** CSV
- **Sous-groupes** :
    - Conditions météorologiques : pluie, neige, vent, etc…
    - Températures : froid, tempéré, chaud
    - Saisons : printemps, été, automne, hiver
    - Jours : semaine ou week-end


### Plan d’analyse

Avant de commencer l'analyse, nous nous posons plusieurs questions que l’on peut catégoriser :

1. Questions exploratoires
    1. Utilisation générale
        - Quelle est la tendance générale de l’utilisation des vélos au cours de l’année ? Y a-t-il des pics saisonniers ?\
        **Graphique :** Lineplot du nombre de trajet en fonction du temps\
        **Variables :** Nombre de trajets, date
        - Combien de trajets sont effectués en moyenne par jour/mois ?\
        **Graphique :** barplot du nombre de trajets par jour de la semaine, par mois de l’année\
        **Variables :** Nombre de trajets, date d’emprunt
        - Quelles stations sont les plus utilisées pour les départs/arrivées ?\
        **Graphique :** Carte avec points de taille différentes pour le nombre de départs/arrivées\
        **Variables :** Nom des stations, Nombre de départs/arrivées, Coordonnées des stations
        - Quel type de vélo (électrique, classique ou cargo) est le plus utilisé ?\
        **Graphique :** Barchart avec pourcentage/nombre de vélos par catégorie\
        **Variables :** Type de vélo, Nombre de trajets par type de vélos
        - Quel est le comportement moyen selon le type d’utilisateur (occasionnel ou membre) ?\
        **Graphique :** Radar chart (potentiellement plusieurs)\
        **Variables :** moyenne de durée de trajet, distance, heure d’emprunt et de dépôt, date (jour de la semaine), type d’abonnement, type de vélo
        - Quelles sont les durées moyenne des trajets ? Varient-elles selon le jour de la semaine ou la météo ?\
        **Graphique :** Boxplot ou violin plot\
        **Variables :** Durée du trajet, type d’utilisateur, date, condition météo
        - Les vélos électriques sont-ils plus prisés pendant les heures de pointe ?\
        **Graphique :** Bar plot des différents types de vélo\
        **Variables :**  Type du vélo, Date
    2. Spatio-temporel
        - Quelles stations sont les plus actives à différentes périodes de la journée (matin ou soir) ?\
        **Graphique :** Heatmap avec X= heure, Y = station et couleur = nombre de trajets\
        **Variables :** Heure, Nom de la station, Nombre de trajets
        - Quelles sont les stations les plus utilisées le week-end, en semaine ?\
        **Graphique :** Stacked barplot\
        **Variables :** Jour de la semaine, nom station, nombre de trajets
        - Existe-t-il des stations avec un fort déséquilibre entre départs et arrivées ?\
        **Graphique :** Barplot (différence départ, arrivée)\
        **Variables :** Nom de la station, Nombre de départs/arrivées
        - Quels sont les trajets les plus fréquents (station de départ vers station d’arrivée) ?\
        **Graphique :** Barplot (top 10 des paires de stations les plus fréquentées)\
        **Variables :** Nom de la station de départ, Nom de la station d’arrivée, Nombre de trajets

2. Questions explicatives
    1. Lien entre météo et usage
        - Comment la météo influence-t-elle l’usage des vélos ? (pluie, température, vent, etc…)\
        **Graphique :** Lineplot ou scatterplot par variable météorologique\
        **Variables :** Conditions météo, Nombre de trajet par jour
        - En cas de météo extrême (fortes pluies ou froid extrême), est-ce que le volume de trajets diminue fortement ?\
        **Graphique :** Boxplot (jours normaux vs météo extrême)\
        **Variables :** Conditions météo, nombre de trajets
        - Quel est l’impact de la neige ou du vent ou de la couverture nuageuse sur la durée moyenne des trajets ?\
        **Graphique :** Lineplot ou scatterplot par variable météorologique\
        **Variables :** Conditions météo, Durée moyenne des trajets
    2. Différences selon les utilisateurs
        - Les membres abonnés utilisent-ils plus les vélos que les usagers occasionnels quand il fait mauvais ?\
        **Graphique :** Lineplot avec comparaison entre les types d’utilisateur\
        **Variables :** météo, nombre de trajet, type d’utilisateur
        - Selon les saisons, la fréquence de cyclistes occasionnels change-t-elle comparé aux membres ?\
        **Graphique :** Lineplot par type d’utilisateur\
        **Variables :** nombre de trajets, type d’utilisateurs, mois
    3. Temporalité
        - En se focalisant sur les utilisateurs, y a-t-il des effets “heures de pointe” dans la journée ?\
        **Graphique :** Lineplot (heure en abscisse et nombre de trajets en ordonnée)\
        **Variables :** nombre de trajets, heure
    4. Évènements
        - Est ce qu’il est possible de voir une différence d’utilisation des vélos lors de la prise du Capitol le 6 janvier 2021?\
        **Graphique :** Lineplot (date en abscisse, nombre de trajets en ordonnée, avec mise en évidence du 6 janvier 2021)\
        **Variables :** Date de début du trajet, Nombre de trajets par jour

### Contraintes et limites :
- **Données agrégées** : L'absence d’identifiant unique pour chaque vélo limite les possibilités de reconstitution précise des itinéraires ou des distances parcourues.
- **Données contextuelles limitées** : Les événements exceptionnels (grèves, manifestations, travaux, etc.) ou les changements d’infrastructure (nouvelles pistes cyclables, réaménagements urbains) ne sont pas pris en compte dans les données disponibles.
- **Intention de l’usager** : bien qu’il soit riche en information, les jeux de données ne reflète pas nécessairement les raisons des choix des usagers (par ex: s’il n’y a plus de vélos électriques disponibles, l’usager va être contraint de prendre un vélo classique contre son gré)

L’objectif est d’aboutir à une compréhension approfondie de la pratique du cyclisme à Washington à partir de ces jeux de données, en identifiant les tendances d’usage, les comportements des usagers, et les facteurs (comme la météo ou la localisation des stations) influençant l’utilisation du service. Cette analyse vise à fournir des insights pertinents pour les décideurs publics, les urbanistes, les acteurs de la mobilité durable, ainsi que pour les citoyens investis dans l’amélioration des mobilités douces.

## Rapport

En premier lieu, une observation intéressante à faire est d’observer la tendance générale de l’utilisation des vélos partagés au cours des années 2020 - 2025.  Nous pouvons imaginer une corrélation avec la température pour représenter les saisons, et l’utilisation des vélos. 

![Graphe montrant le nombre de trajets par jour et la température](/data/grapheNombreTrajetsParJour+Température.png "Nombre de trajets par jour et température")

On constate une augmentation au fil des années de l’utilisation des vélos et surtout une cyclicité. On observe une corrélation très forte entre la température et l’utilisation des vélos : Les utilisateurs privilégient l’utilisation des vélos lors de températures chaudes et les utilisent moins lors de température plus froides.. Ainsi, on peut voir que les utilisations majoritaires se font pendant le printemps, l’été et l’automne. 

Ceci nous amène à nous demander si la météo a elle aussi un impact sur l’utilisation des vélos.
