library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)
library(lubridate)
library(DT)
library(scales)
library(viridis)
library(tidyverse)
server <- function(input, output, session) {
  
  df <- reactive({
    read_csv("../../data/daily_rent_detail.csv", show_col_types = FALSE) %>%
      mutate(
        # Si les dates sont déjà au bon format, conversion directe
        started_at = as_datetime(started_at),
        ended_at = as_datetime(ended_at),
        duration_minutes = as.numeric(difftime(ended_at, started_at, units = "mins")),
        date = as.Date(started_at),
        hour = hour(started_at),
        wday = wday(started_at, label = TRUE),
        month = month(started_at),
        is_weekend = wday %in% c("Sat", "Sun")
      ) %>%
      filter(
        duration_minutes > 0,
        duration_minutes < 1440
      )
  })
  
  
  weather <- reactive({
    # Version simple - créer des données météo basées sur les dates de vos vraies données
    dates_velo <- seq(as.Date("2020-05-01"), as.Date("2024-08-31"), by = "day")
    
    data.frame(
      date = dates_velo,
      temp = rnorm(length(dates_velo), 15, 10),
      precip = rpois(length(dates_velo), 2),
      windspeed = rnorm(length(dates_velo), 10, 5),
      cloudcover = runif(length(dates_velo), 0, 100)
    )
  })
  
  
  
  # Données filtrées réactives
  filtered_data <- reactive({
    data <- df()
    
    # Filtres communs
    if(!is.null(input$date_range_1)) {
      data <- data %>% filter(date >= input$date_range_1[1] & date <= input$date_range_1[2])
    }
    
    data
  })
  
  # ===== ONGLET 1: VUE D'ENSEMBLE =====
  
  output$overview_plot <- renderPlotly({
    data <- filtered_data()
    
    # Filtres spécifiques
    if(input$user_type_1 != "all") {
      data <- data %>% filter(member_casual == input$user_type_1)
    }
    if(input$bike_type_1 != "all") {
      data <- data %>% filter(rideable_type == input$bike_type_1)
    }
    
    # Évolution mensuelle
    df_evolution <- data %>%
      mutate(month = floor_date(date, "month")) %>%
      group_by(month, member_casual) %>%
      summarise(nb_trajets = n(), .groups = "drop")
    
    p <- ggplot(df_evolution, aes(x = month, y = nb_trajets, color = member_casual)) +
      geom_line(size = 1.2) +
      geom_point() +
      labs(
        title = "Évolution mensuelle du nombre de trajets par type d'utilisateur",
        x = "Date",
        y = "Nombre de trajets",
        color = "Type d'utilisateur"
      ) +
      theme_minimal() +
      scale_color_manual(values = c("member" = "#2E86AB", "casual" = "#A23B72"))
    
    ggplotly(p)
  })
  
  output$overview_stats <- renderText({
    data <- filtered_data()
    
    total_trips <- nrow(data)
    avg_duration <- round(mean(data$duration_minutes, na.rm = TRUE), 1)
    member_pct <- round(sum(data$member_casual == "member") / total_trips * 100, 1)
    
    paste0(
      "Statistiques générales:\n",
      "• Total trajets: ", format(total_trips, big.mark = " "), "\n",
      "• Durée moyenne: ", avg_duration, " minutes\n",
      "• % Membres: ", member_pct, "%\n",
      "• % Occasionnels: ", 100 - member_pct, "%"
    )
  })
  
  output$user_distribution <- renderPlotly({
    data <- filtered_data()
    
    user_counts <- data %>%
      count(member_casual) %>%
      mutate(percentage = n / sum(n) * 100)
    
    p <- ggplot(user_counts, aes(x = "", y = percentage, fill = member_casual)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y", start = 0) +
      theme_void() +
      labs(fill = "Type d'utilisateur") +
      scale_fill_manual(values = c("member" = "#2E86AB", "casual" = "#A23B72"))
    
    ggplotly(p)
  })
  
  # ===== ONGLET 2: ANALYSE TEMPORELLE =====
  
  output$heatmap_plot <- renderPlotly({
    data <- df()
    
    # Filtres
    if(input$user_type_2 != "all") {
      data <- data %>% filter(member_casual == input$user_type_2)
    }
    if(input$period_filter == "weekday") {
      data <- data %>% filter(!is_weekend)
    } else if(input$period_filter == "weekend") {
      data <- data %>% filter(is_weekend)
    }
    if(input$month_filter != "all") {
      data <- data %>% filter(month == as.numeric(input$month_filter))
    }
    
    # Heatmap heure/jour
    heatmap_data <- data %>%
      count(wday, hour) %>%
      complete(wday, hour, fill = list(n = 0))
    
    p <- ggplot(heatmap_data, aes(x = hour, y = wday, fill = n)) +
      geom_tile() +
      scale_fill_viridis_c(name = "Trajets") +
      labs(
        title = "Nombre de trajets par heure et jour de la semaine",
        x = "Heure",
        y = "Jour de la semaine"
      ) +
      theme_minimal()
    
    ggplotly(p)
  })
  
  output$daily_pattern <- renderPlotly({
    data <- df()
    
    daily_data <- data %>%
      group_by(wday, member_casual) %>%
      summarise(nb_trajets = n(), .groups = "drop")
    
    p <- ggplot(daily_data, aes(x = wday, y = nb_trajets, fill = member_casual)) +
      geom_col(position = "dodge") +
      labs(
        title = "Répartition des trajets par jour de la semaine",
        x = "Jour",
        y = "Nombre de trajets",
        fill = "Type d'utilisateur"
      ) +
      theme_minimal() +
      scale_fill_manual(values = c("member" = "#2E86AB", "casual" = "#A23B72"))
    
    ggplotly(p)
  })
  
  output$hourly_pattern <- renderPlotly({
    data <- df()
    
    hourly_data <- data %>%
      group_by(hour, member_casual) %>%
      summarise(nb_trajets = n(), .groups = "drop")
    
    p <- ggplot(hourly_data, aes(x = hour, y = nb_trajets, color = member_casual)) +
      geom_line(size = 1.2) +
      geom_point() +
      labs(
        title = "Profil horaire d'utilisation",
        x = "Heure",
        y = "Nombre de trajets",
        color = "Type d'utilisateur"
      ) +
      theme_minimal() +
      scale_color_manual(values = c("member" = "#2E86AB", "casual" = "#A23B72"))
    
    ggplotly(p)
  })
  
  # ===== ONGLET 3: STATIONS =====
  
  output$stations_map <- renderLeaflet({
    data <- df()
    
    if(input$user_type_3 != "all") {
      data <- data %>% filter(member_casual == input$user_type_3)
    }
    
    if(input$station_type == "start") {
      station_data <- data %>%
        group_by(start_station_name, start_lat, start_lng) %>%
        summarise(nb_trajets = n(), .groups = "drop") %>%
        arrange(desc(nb_trajets)) %>%
        slice_head(n = input$top_n)
      
      leaflet(station_data) %>%
        addTiles() %>%
        addCircleMarkers(
          lng = ~start_lng,
          lat = ~start_lat,
          label = ~paste0(start_station_name, ": ", nb_trajets, " trajets"),
          radius = ~sqrt(nb_trajets) / 10,
          fillColor = "blue",
          color = "darkblue",
          fillOpacity = 0.7,
          stroke = TRUE
        ) %>%
        addLegend("bottomright", colors = "blue", labels = "Stations de départ", title = "Légende")
    } else {
      station_data <- data %>%
        group_by(end_station_name, end_lat, end_lng) %>%
        summarise(nb_trajets = n(), .groups = "drop") %>%
        arrange(desc(nb_trajets)) %>%
        slice_head(n = input$top_n)
      
      leaflet(station_data) %>%
        addTiles() %>%
        addCircleMarkers(
          lng = ~end_lng,
          lat = ~end_lat,
          label = ~paste0(end_station_name, ": ", nb_trajets, " trajets"),
          radius = ~sqrt(nb_trajets) / 10,
          fillColor = "red",
          color = "darkred",
          fillOpacity = 0.7,
          stroke = TRUE
        ) %>%
        addLegend("bottomright", colors = "red", labels = "Stations d'arrivée", title = "Légende")
    }
  })
  
  output$stations_bar <- renderPlotly({
    data <- df()
    
    if(input$user_type_3 != "all") {
      data <- data %>% filter(member_casual == input$user_type_3)
    }
    
    if(input$station_type == "start") {
      station_data <- data %>%
        count(start_station_name, sort = TRUE) %>%
        slice_head(n = input$top_n)
      
      p <- ggplot(station_data, aes(x = reorder(start_station_name, n), y = n)) +
        geom_col(fill = "steelblue") +
        coord_flip() +
        labs(
          title = paste("Top", input$top_n, "stations de départ"),
          x = "Station",
          y = "Nombre de trajets"
        ) +
        theme_minimal()
    } else {
      station_data <- data %>%
        count(end_station_name, sort = TRUE) %>%
        slice_head(n = input$top_n)
      
      p <- ggplot(station_data, aes(x = reorder(end_station_name, n), y = n)) +
        geom_col(fill = "darkgreen") +
        coord_flip() +
        labs(
          title = paste("Top", input$top_n, "stations d'arrivée"),
          x = "Station",
          y = "Nombre de trajets"
        ) +
        theme_minimal()
    }
    
    ggplotly(p)
  })
  
  # ===== ONGLET 4: TYPES DE VÉLOS =====
  
  output$bikes_evolution <- renderPlotly({
    data <- df()
    
    if(input$user_type_4 != "all") {
      data <- data %>% filter(member_casual == input$user_type_4)
    }
    
    bike_evolution <- data %>%
      mutate(month = floor_date(date, "month")) %>%
      group_by(month, rideable_type) %>%
      summarise(nb_trajets = n(), .groups = "drop")
    
    p <- ggplot(bike_evolution, aes(x = month, y = nb_trajets, color = rideable_type)) +
      geom_line(size = 1.2) +
      geom_point() +
      labs(
        title = "Évolution de l'utilisation par type de vélo",
        x = "Date",
        y = "Nombre de trajets",
        color = "Type de vélo"
      ) +
      theme_minimal() +
      scale_color_manual(values = c("classic_bike" = "#1f77b4", "electric_bike" = "#ff7f0e", "docked_bike" = "#2ca02c"))
    
    ggplotly(p)
  })
  
  output$bikes_distribution <- renderPlotly({
    data <- df()
    
    bike_counts <- data %>%
      count(rideable_type) %>%
      mutate(percentage = n / sum(n) * 100)
    
    p <- ggplot(bike_counts, aes(x = rideable_type, y = percentage, fill = rideable_type)) +
      geom_col() +
      labs(
        title = "Répartition des types de vélos",
        x = "Type de vélo",
        y = "Pourcentage (%)",
        fill = "Type de vélo"
      ) +
      theme_minimal() +
      scale_fill_manual(values = c("classic_bike" = "#1f77b4", "electric_bike" = "#ff7f0e", "docked_bike" = "#2ca02c"))
    
    ggplotly(p)
  })
  
  output$bikes_comparison <- renderPlotly({
    data <- df()
    
    comparison_data <- data %>%
      count(member_casual, rideable_type) %>%
      group_by(member_casual) %>%
      mutate(percentage = n / sum(n) * 100)
    
    p <- ggplot(comparison_data, aes(x = member_casual, y = percentage, fill = rideable_type)) +
      geom_col(position = "dodge") +
      labs(
        title = "Préférences de vélos par type d'utilisateur",
        x = "Type d'utilisateur",
        y = "Pourcentage (%)",
        fill = "Type de vélo"
      ) +
      theme_minimal() +
      scale_fill_manual(values = c("classic_bike" = "#1f77b4", "electric_bike" = "#ff7f0e", "docked_bike" = "#2ca02c"))
    
    ggplotly(p)
  })
  
}


