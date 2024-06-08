library(leaflet)
library(htmltools)

# Define the data
cities <- data.frame(
  title = c("Baranov Lab. Schepens Eye Research Institute, Boston", "Dong Feng Chen Lab. Schepens Eye Research Institute, Boston", 
            "Lamba Lab. UCSF, San Francisco", "Goldberg Lab. Stanford, Palo Alto", "Samuels Lab. UAB, Birmingham", 
            "Johnson Lab. Johns Hopkins, Baltimore", "Zack Lab. Johns Hopkins, Baltimore", "Meyer Lab. Indiana University, Indianapolis", 
            "He Lab. Boston Childrens, Boston", "Sun Lab. Boston Childrens, Boston", "McGregor Lab. Flaum Eye Institute, Rochester", 
            "Carrier Lab. Northeastern, Boston", "Monaghan Lab. Northeastern, Boston", "InGel Tx, Cambridge", 
            "Cellino, Cambridge", "Fortune Lab. University of Oregon, Oregon", "Gutmann Lab. Washington University, Saint Louis", 
            "Gilbert Family Foundation, Detroit", "RRESTORE, Baltimore", "Whited Lab. Harvard University, Cambridge", 
            "LHON Collective, San Diego", "Reh Lab. University of Washington, Seattle", "Goldman Lab. University of Michigan, Ann Arbor"),
  latitude = c(42.3601, 42.6, 37.7749, 37.4419, 33.5024, 39.3289, 39.3289, 39.7684, 42.3391, 42.3391, 
               43.1610, 42.3398, 42.3398, 42.3736, 42.3736, 44.0458, 38.6488, 42.3314, 39.2904, 42.3770, 
               32.7157, 47.6062, 42.2808),
  longitude = c(-71.0589, -71.5, -122.4194, -122.1430, -86.8092, -76.6205, -76.6205, -86.1581, -71.1097, -71.1097, 
                -77.6109, -71.0892, -71.0892, -71.1097, -71.1097, -123.0726, -90.3108, -83.0458, -76.6122, -71.1167, 
                -117.1611, -122.3321, -83.7430),
  customText = c("Harvard Medical School", "Harvard Medical School", "UCSF", "Stanford", "UAB", 
                 "Johns Hopkins", "Johns Hopkins", "Indiana University", "Boston Childrens", "Boston Childrens", 
                 "Flaum Eye Institute", "Northeastern", "Northeastern", "InGel Tx", 
                 "Cellino", "University of Oregon", "Washington University", "Gilbert Family Foundation", 
                 "RRESTORE", "Harvard University", "LHON Collective", "University of Washington", "University of Michigan")
)

pins <- data.frame(
  title = c("Jonathan Soucy", "Petr Baranov", "Emil Kriukov", "Volha Malechka", "Nikita Bagaev", 'Aubin Mutschler'),
  latitude = c(44.1004, 56.3039, 59.3508, 52.0976, 51.5336, 48.5734),
  longitude = c(-70.2148, 38.5567, 18.0691, 23.7341, 46.0343, 7.7521),
  value = c(6, 6, 6, 6, 6, 6)
)



install.packages('geojsonio')
library(geojsonio)
url <- "https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json"
countries <- geojsonio::geojson_read(url, what = "sp")

# Define custom CSS for white background
backg <- htmltools::tags$style(".leaflet-container { background: white; }")

# Create the map
m <- leaflet() %>% 
  # Add white background tile
  addTiles(urlTemplate = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wcAAgcBA0cmggAAAABJRU5ErkJggg==") %>%
  # Add country polygons
  addPolygons(data = countries, fillColor = "lightgray", fillOpacity = 1, color = "black", weight = 1) %>% 
  setView(lng = 0, lat = 20, zoom = 2)

# Add markers and polylines as previously defined
m <- m %>% 
  addCircleMarkers(lng = cities$longitude[1], lat = cities$latitude[1], 
                   popup = htmlEscape(cities$title[1]), 
                   radius = 10, color = "#CB4154", # red brick color
                   fillOpacity = 1, label = htmlEscape(cities$customText[1]))

for (i in 2:nrow(cities)) {
  m <- m %>% 
    addCircleMarkers(lng = cities$longitude[i], lat = cities$latitude[i], 
                     popup = htmlEscape(cities$title[i]), 
                     radius = 6, color = "blue", 
                     fillOpacity = 0.7, label = htmlEscape(cities$customText[i]))
}

for (i in 1:nrow(pins)) {
  m <- m %>% 
    addCircleMarkers(lng = pins$longitude[i], lat = pins$latitude[i], 
                     popup = htmlEscape(pins$title[i]), 
                     radius = 10 + pins$value[i], color = "orange", 
                     fillOpacity = 0.7, label = htmlEscape(pins$title[i]))
}

baranov_lab <- cities[1,]
for (i in 2:nrow(cities)) {
  route <- gcIntermediate(c(baranov_lab$longitude, baranov_lab$latitude), 
                          c(cities$longitude[i], cities$latitude[i]), 
                          n = 100, addStartEnd = TRUE, sp = TRUE)
  m <- m %>% 
    addPolylines(data = route, color = "green", weight = 2, opacity = 0.5)
}
m

install.packages('leaflet.extras')
library(leaflet.extras)

m <- m%>%
  setMapWidgetStyle(list(background= "white"))
m
saveWidget(m, "C://Bioinf/lab_map_white_background2.html", selfcontained = TRUE)
