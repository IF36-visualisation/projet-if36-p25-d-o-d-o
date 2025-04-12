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
