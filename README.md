# Analyse de la Pratique du Cyclisme à Paris

## Introduction

### Données

Nous utilisons deux jeux de données pour analyser la pratique du cyclisme à Paris :

1. **Comptage Vélo - Données Compteurs** ([source](https://www.data.gouv.fr/fr/datasets/comptage-velo-donnees-compteurs/))
 - **Origine des données** :
     Ces données proviennent des compteurs automatiques de vélos installés à Paris. Elles sont collectées par la Ville de Paris afin de suivre l'évolution du trafic cycliste et d’orienter les politiques publiques en matière de mobilité durable.
 - **Pourquoi ces données ?**
     Elles permettent d’observer les tendances de la pratique du vélo, d’identifier les zones à forte affluence et d’évaluer l’impact des infrastructures cyclables.
 - **Nombre d’observations** : 962 340 observations sur 13 mois glissants entre février 2024 et mars 2025
 - **Nombre de variables** : 16 variables incluant :
   -  Identifiant du compteur
   -  Nom du compteur (souvent associé à un lieu précis)
   - Identifiant du site de comptage
   - Nom du site de comptage (souvent associé à un lieu précis)
   - Comptage horaire
   - Date et heure de comptage
   - Date d’installation du site de comptage
   - Lien vers la photo du site de comptage
   - Coordonnées géographiques
   - Identifiant technique du compteur
   - ID Photos
   - test_lien_vers_photos_du_site_de_comptage
   - id_photo_1
   - url_sites
   - type_dimage
   - mois_annee_comptage
 - **Créateur et éditeur** : Direction de la Voirie et des Déplacements - Ville de Paris
 - **Format** : CSV
 - **Sous-groupes** :
   - Localisation des compteurs (ex : quais, axes principaux, quartiers résidentiels)
   - Différenciation des flux (ex : pistes cyclables dédiées vs voies partagées)
   - Évolution temporelle (ex : analyse par heure, jour, mois, année)
  
2. **Disponibilité en temps réel des Vélib’** ([source](https://opendata.paris.fr/explore/dataset/velib-disponibilite-en-temps-reel))
  - **Origine des données** :
    Ces données sont fournies par le service Vélib’ Métropole et sont mises à jour en temps réel pour refléter la disponibilité des vélos dans les stations de la capitale et de sa périphérie.
  - **Pourquoi ces données ?**
    Elles permettent d’analyser l’usage des vélos en libre-service, d’identifier les déséquilibres entre les stations et de comprendre les comportements des usagers.
  - **Nombre d’observations** : 1472 observations
  - **Nombre de variables** :
    - Identifiant station
    - Nom station
    - Station en fonctionnement
    - Capacité de la station
    - Nombre bornettes libres
    - Nombre total vélos disponibles
    - Vélos mécaniques disponibles
    - Vélos électriques disponibles
    - Borne de paiement disponible
    - Retour vélib possible
    - Actualisation de la donnée
    - Coordonnées géographiques
    - Nom communes équipées
    - Code INSEE communes équipées
    - station_opening_hours
 - **Créateur et éditeur** : Autolib Velib Métropole
 - **Formats** : CSV
 - **Sous-groupes** :
    - Différenciation entre vélos mécaniques et électriques
    - Quartiers et zones d’activité (ex : zones résidentielles vs zones touristiques)
    - Stations à forte ou faible demande (ex : gares, bureaux, quartiers résidentiels)
  
### Plan d’Analyse

Avant de commencer l'analyse, nous nous posons plusieurs questions :

1. **Évolution de la fréquentation cycliste**
 - Comment évolue le nombre de passages vélo en fonction des jours de la semaine et des heures de la journée ?
 - Y a-t-il une saisonnalité dans l’usage du vélo à Paris ?
 - Quels facteurs influencent l’utilisation des Vélib’ (crit’air, grèves, forte pollution, beau temps, bouchons, métro bloqué, JO) ?
 - Où serait-il intéressant de rajouter des pistes cyclables ?
2. **Impact des conditions externes**
 - Quel est l’impact de la météo sur la fréquentation des cyclistes ?
 - Y a-t-il une corrélation entre la pollution et l’usage du vélo ?
3. **Analyse des stations Vélib’**
 - Quels sont les quartiers où la demande de vélos en libre-service est la plus forte ?
 - Existe-t-il des déséquilibres entre les stations en termes de disponibilité des vélos ?
4. **Comparaisons et corrélations**
 - Peut-on observer une relation entre l’utilisation des Vélib’ et les données des compteurs fixes ?
 - Quels facteurs influencent la répartition et la disponibilité des vélos en libre-service ?
 - Peut-on observer une relation entre l’utilisation de vélos électriques et la météo.

### Contraintes et Limites

- **Données manquantes ou incomplètes** : Certains compteurs peuvent ne pas fonctionner à certains moments.
- **Données en temps réel** : La variabilité de la disponibilité des Vélib’ peut compliquer l’analyse rétrospective.
- **Facteurs externes non pris en compte** : Les grèves, événements exceptionnels ou changements d’infrastructure peuvent impacter les données. De plus les vélos n’ont pas d’identifiants uniques, ce qui nous empêche de déterminer des informations de type distance parcourue ou itinéraire choisi

L’objectif est d’aboutir à une compréhension approfondie de la pratique du cyclisme à Paris à partir de ces jeux de données, tout en identifiant les tendances et les facteurs influençant l’usage du vélo.
