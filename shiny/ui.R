library(shiny)
library(shinydashboard)
library(leaflet)
library(plotly)
library(DT)
library(shinyWidgets)

ui <- dashboardPage(
  dashboardHeader(title = "Analyse Vélib Washington"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Vue d'ensemble", tabName = "overview", icon = icon("chart-line")),
      menuItem("Analyse temporelle", tabName = "temporal", icon = icon("clock")),
      menuItem("Stations populaires", tabName = "stations", icon = icon("map-marker-alt")),
      menuItem("Types de vélos", tabName = "bikes", icon = icon("bicycle"))
    )
  ),
  
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .content-wrapper, .right-side {
            background-color: #f4f4f4;
        }
      "))
    ),
    
    tabItems(
      # Onglet 1: Vue d'ensemble
      tabItem(tabName = "overview",
              fluidRow(
                box(width = 12, title = "Contrôles", status = "primary", solidHeader = TRUE,
                    fluidRow(
                      column(4,
                             dateRangeInput("date_range_1", "Période:",
                                            start = "2020-05-01", end = "2024-08-31",
                                            format = "yyyy-mm-dd")
                      ),
                      column(4,
                             selectInput("user_type_1", "Type d'utilisateur:",
                                         choices = c("Tous" = "all", "Membre" = "member", "Occasionnel" = "casual"),
                                         selected = "all")
                      ),
                      column(4,
                             selectInput("bike_type_1", "Type de vélo:",
                                         choices = c("Tous" = "all", "Classique" = "classic_bike", 
                                                     "Électrique" = "electric_bike", "Station" = "docked_bike"),
                                         selected = "all")
                      )
                    )
                )
              ),
              fluidRow(
                box(width = 12, title = "Évolution mensuelle des trajets", status = "info", solidHeader = TRUE,
                    plotlyOutput("overview_plot", height = "500px")
                )
              ),
              fluidRow(
                box(width = 6, title = "Statistiques générales", status = "success", solidHeader = TRUE,
                    verbatimTextOutput("overview_stats")
                )
              )
      ),
      
      # Onglet 2: Analyse temporelle
      tabItem(tabName = "temporal",
              fluidRow(
                box(width = 12, title = "Contrôles temporels", status = "primary", solidHeader = TRUE,
                    fluidRow(
                      column(3,
                             selectInput("user_type_2", "Type d'utilisateur:",
                                         choices = c("Tous" = "all", "Membre" = "member", "Occasionnel" = "casual"))
                      ),
                      column(3,
                             selectInput("period_filter", "Période:",
                                         choices = c("Tous" = "all", "Semaine" = "weekday", "Weekend" = "weekend"))
                      ),
                      column(3,
                             selectInput("month_filter", "Mois:",
                                         choices = c("Tous" = "all", setNames(1:12, month.name)))
                      ),
                      column(3,
                             selectInput("temporal_view", "Vue:",
                                         choices = c("Evolution journalière" = "daily",
                                                     "Profil horaire" = "hourly"))
                      )
                    )
                )
              ),
              fluidRow(
                box(width = 12, title = "Analyse temporelle des trajets", status = "info", solidHeader = TRUE,
                    conditionalPanel(
                      condition = "input.temporal_view == 'daily'",
                      plotlyOutput("daily_pattern", height = "500px")
                    ),
                    conditionalPanel(
                      condition = "input.temporal_view == 'hourly'",
                      plotlyOutput("hourly_pattern", height = "500px")
                    )
                )
              )
      ),
      
      # Onglet 3: Stations
      tabItem(tabName = "stations",
              fluidRow(
                box(width = 12, title = "Contrôles stations", status = "primary", solidHeader = TRUE,
                    fluidRow(
                      column(3,
                             numericInput("top_n", "Top N stations:", value = 10, min = 5, max = 50)
                      ),
                      column(3,
                             selectInput("station_type", "Type:",
                                         choices = c("Départ" = "start", "Arrivée" = "end"))
                      ),
                      column(3,
                             selectInput("user_type_3", "Type d'utilisateur:",
                                         choices = c("Tous" = "all", "Membre" = "member", "Occasionnel" = "casual"))
                      ),
                      column(3,
                             selectInput("station_view", "Vue:",
                                         choices = c("Carte" = "map", "Graphique barres" = "bar"))
                      )
                    )
                )
              ),
              fluidRow(
                conditionalPanel(
                  condition = "input.station_view == 'map'",
                  box(width = 12, title = "Carte des stations les plus utilisées", status = "success", solidHeader = TRUE,
                      leafletOutput("stations_map", height = "600px")
                  )
                ),
                conditionalPanel(
                  condition = "input.station_view == 'bar'",
                  box(width = 12, title = "Top stations", status = "success", solidHeader = TRUE,
                      plotlyOutput("stations_bar", height = "600px")
                  )
                )
              )
      ),
      
      # Onglet 4: Types de vélos
      tabItem(tabName = "bikes",
              fluidRow(
                box(width = 12, title = "Contrôles vélos", status = "primary", solidHeader = TRUE,
                    fluidRow(
                      column(4,
                             dateRangeInput("date_range_4", "Période:",
                                            start = "2020-05-01", end = "2024-08-31")
                      ),
                      column(4,
                             selectInput("user_type_4", "Type d'utilisateur:",
                                         choices = c("Tous" = "all", "Membre" = "member", "Occasionnel" = "casual"))
                      ),
                      column(4,
                             selectInput("bikes_view", "Vue:",
                                         choices = c("Évolution temporelle" = "evolution", 
                                                     "Répartition" = "distribution",
                                                     "Comparaison utilisateurs" = "comparison"))
                      )
                    )
                )
              ),
              fluidRow(
                box(width = 12, title = "Analyse des types de vélos", status = "warning", solidHeader = TRUE,
                    conditionalPanel(
                      condition = "input.bikes_view == 'evolution'",
                      plotlyOutput("bikes_evolution", height = "500px")
                    ),
                    conditionalPanel(
                      condition = "input.bikes_view == 'distribution'",
                      plotlyOutput("bikes_distribution", height = "500px")
                    ),
                    conditionalPanel(
                      condition = "input.bikes_view == 'comparison'",
                      plotlyOutput("bikes_comparison", height = "500px")
                    )
                )
              )
      )
    )
  )
)
