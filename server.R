## server.R
server <- function(input, output) { 
     
### Display layer base on menu: can select multiple layers
     superSelector <- reactive({
               df <- subset(df, df$FMP %in% input$selectFMP)
               tmp <- df$URL
               tmp
                              })

##### Display basemap

     output$map <- renderLeaflet({
          map <- leaflet() %>%
            #addTiles() %>% 
               addTiles('http://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                        options = providerTileOptions(noWrap = TRUE)) %>%
               addTiles('http://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/Mapserver/tile/{z}/{y}/{x}',
                        options = providerTileOptions(noWrap = TRUE)) %>%
               addScaleBar(position="bottomright") %>%
              setView(-85, 27, zoom=7) %>%
               addMiniMap() %>%
               addFullscreenControl() %>%
            addMouseCoordinates2(style=("basic")) %>%
            ##experimental draw tool
            addDrawToolbar(
              targetGroup='draw',
              circleOptions = FALSE,
              markerOptions = TRUE,
              polylineOptions =  FALSE,
              polygonOptions =  FALSE, 
              rectangleOptions = TRUE,
              editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))

      })
  
#### observer to update map based on user input via menu:
       
      observe({
        map  <- leafletProxy('map')
        map <- map  %>% leaflet::clearGroup(group="A") #%>%
        for(i in 1:length(superSelector())){
          map <- map  %>%
            #addEsriDynamicMapLayer(superSelector()[i], group="A")
          addTiles(superSelector()[i], group="A")
        }

        map
      })

##################### This works with draw toolbar##########    
  ### get coordinates from draw tool    
      boxCoords <- reactive({
        tmp <- data.frame(unlist(input$map_draw_new_feature[3]))
        df <- data.frame(tmp)
        #df <- data.frame(x=df[2,1], y=df[3,1])
          df <- data.frame(x=tmp[c(2,4, 6,8, 10),1], y=tmp[c(3,5,7,9,11),1])
         df <- na.omit(df)
          #str(df)
         df$x <- as.numeric(as.character(df$x))
          df$y <- as.numeric(as.character(df$y))
        # #  df$id <- 1:nrow(df)
        # df <- df[1,]
        # # # out <- data.frame(minX= min(df$x), maxX=max(df$x),
        # # #                   minY=min(df$y), maxY=max(df$y))
         df
      })
      
      
      output$test <- renderTable({boxCoords()})
      output$NROW <- renderTable({nrow(boxCoords())})
      

      ### uses output from box coords reactive as input
          PIP <- reactive({
####################Start point in polygon##############            
            if(nrow(boxCoords())==1){
            #df <- data.frame(x=-9999)
              ## put in some logic for nrow, if equal 1 do this, else rectangle
              point <- as.numeric(as.character(boxCoords()))
              x <- st_point(point)
              CoralPIP <- st_intersects(x, Coral, sparse=FALSE)
              CMPPIP <- st_intersects(x, CMP, sparse=FALSE)
              RedDrumPIP <- st_intersects(x, RedDrum, sparse=FALSE)
              ReefFishPIP <- st_intersects(x, ReefFish, sparse=FALSE)
              ShrimpPIP <- st_intersects(x, Shrimp, sparse=FALSE)
              SpinyLobsterPIP <- st_intersects(x, SpinyLobster, sparse=FALSE)
              EFHout$EFH <- c( CMPPIP, CoralPIP,
                               RedDrumPIP, ReefFishPIP,ShrimpPIP,SpinyLobsterPIP)
              #EFHout$shapefile <- HTML('<a target="_blank" href="http://sero.nmfs.noaa.gov/maps_gis_data/fisheries/gom/documents/spanish_mackerelzones.txt">Section 622.369—Migratory groups of Spanish mackerel</a>. <br> Maps: <br> GIS Data: <a href="http://portal.gulfcouncil.org/Regulations/spanish_mackerel_po.zip">Shapefile</a>')
              EFHout$Lat <- point[2]
              EFHout$Long <- point[1]
              EFHout
              
              } else
####################End point in polygon##############               
    
####################Start polygon in polygon##############                
            if(nrow(boxCoords())==5){
            coords <- as.matrix(boxCoords())
            P1 <- Polygon(coords)
            Ps1 <- SpatialPolygons(list(Polygons(list(P1), ID = "a")),
                                   proj4string=CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
            Ps2SF <- st_as_sfc(Ps1)
            #### CMP
            IntersectionOut <-  st_intersection(Ps2SF, CMP)
            df <- as.data.frame(IntersectionOut)
            dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
            EFHout$EFH[1] <- ifelse(dfNROW >0, 'yes', 'no')
            #### End CMP
            
            ####Coral
            IntersectionOut <-  st_intersection(Ps2SF, Coral)
            df <- as.data.frame(IntersectionOut)
            dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
            EFHout$EFH[2] <- ifelse(dfNROW >0, 'yes', 'no')
            #### End Coral
            ####RedDrum
            IntersectionOut <-  st_intersection(Ps2SF, RedDrum)
            df <- as.data.frame(IntersectionOut)
            dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
            EFHout$EFH[3] <- ifelse(dfNROW >0, 'yes', 'no')
            #### End RedDrum
            ####ReefFish
            IntersectionOut <-  st_intersection(Ps2SF, ReefFish)
            df <- as.data.frame(IntersectionOut)
            dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
            EFHout$EFH[4] <- ifelse(dfNROW >0, 'yes', 'no')
            #### End ReefFish
            ####Shrimp
            IntersectionOut <-  st_intersection(Ps2SF, Shrimp)
            df <- as.data.frame(IntersectionOut)
            dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
            EFHout$EFH[5] <- ifelse(dfNROW >0, 'yes', 'no')
            #### End Shrimp
            ####SpinyLobster
            IntersectionOut <-  st_intersection(Ps2SF, SpinyLobster)
            df <- as.data.frame(IntersectionOut)
            dfNROW <- nrow(df) ##if nrow > 0 then positive intersection
            EFHout$EFH[6] <- ifelse(dfNROW >0, 'yes', 'no')
            #### End SpinyLobster
            EFHout
            }
            EFHout
          })
          
          output$out3 <- renderTable({
            PIP()
              })
          
          output$out4 <- renderText({boxCoords()})
         

      
}


