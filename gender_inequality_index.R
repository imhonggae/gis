# Read in global gender inequality data
gender_data <- read.csv("E:/GIS/wk4/gender_inequality_data.csv")

# Read in spatial data of the world
world_spatial_data <- sf::st_read("E:/GIS/wk4/World_Countries_Generalized/World_Countries_Generalized.shp")

# Calculate the difference in inequality
diff_data <- gender_data %>%
  mutate(inequality_difference = gii_2019 - gii_2010) %>%
  dplyr::select(country,
                inequality_difference)

# Join the data
merged_data <- dplyr::left_join(world_spatial_data, diff_data, by = c("COUNTRY" = "country"))

#test git pull

# Read Shapefile
global_index <- st_read(here::here( "World_Countries_Generalized.shp"))
global_index_edit <- global_index %>%
  dplyr::select(COUNTRY,
                ISO,
                SHAPE_Leng,
                SHAPE_Area,
                geometry)
qtm(global_index_edit)

# Plot up the map
global_index_plot <- global_index_edit %>%
  left_join(.,
            gii_diff_compare,
            by = c("COUNTRY" = "country"))

tmap_mode("plot")
qtm(global_index_plot,
    fill = "Index_Diff201019")

map <- tm_shape(global_index) +
  tm_borders(lwd = 0.3) +
  tm_fill("gii_dff", midpoint=0, palette=brewer.pal(6, "RdBu"),
          title = paste("Change in Gender Inequality Index (2019-2010)"),
          textNA = "Unknown", style="jenks") +
  tm_layout(legend.width =0.3,
            legend.position = c("left","bottom"))
tmap_save(map, "map.png")
