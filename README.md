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
   -  Identifiant du compteur.
   -  Nom du compteur (souvent associé à un lieu précis).
   - Identifiant du site de comptage
   - Nom du site de comptage (souvent associé à un lieu précis).
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
 - **Créateur et éditeur** : Direction de la Voirie et des Déplacements - Ville de Paris.
 - **Format** : CSV.
 - **Sous-groupes** :
   - Localisation des compteurs (ex : quais, axes principaux, quartiers résidentiels).
   - Différenciation des flux (ex : pistes cyclables dédiées vs voies partagées).
   - Évolution temporelle (ex : analyse par heure, jour, mois, année).
