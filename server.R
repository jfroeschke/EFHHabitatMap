## server.R
server <- function(input, output) { 
     
     
     superSelector <- reactive({
               df <- subset(df, df$FMP %in% input$selectFMP)


               #df <- arrange(df, desc(ORDER))
               tmp <- df$URL
               tmp
                              })
 #     
 #     # legendSelector <- reactive({
 #     #      df2 <- subset(df, df$FMP %in% input$selectFMP)
 #     #      df2 <- arrange(df2, order)
 #     #      #df2 <- select(df2, Color, Name)
 #     #      tmp <- df2
 #     #      tmp
 #     # })
 #     # 
 #     # 
 #     # imageSelector <- reactive({
 #     #      df2 <- subset(df, df$FMP %in% input$selectFMP)
 #     #      df2 <- arrange(df2, order)
 #     #      #df2 <- select(df2, Color, Name)
 #     #      tmp <- df2$image[1]
 #     #      tmp
 #     # })
 #     # 
 #     #output$side <- renderImage({df$image[1]})
 #     
 #     ## Will use later
 #     # checkboxSelector <- reactive({
 #     #      df2 <- subset(df, df$FMP %in% input$selectFMP)
 #     #      #df2 <- subset(df2, df$Sector %in% input$selectSector)
 #     #      #df2 <- subset(df2, Start < input$daterange1[1])
 #     #      #df2 <- subset(df2, End > input$daterange1[2])
 #     #      df2 <- arrange(df2, desc(order))
 #     #      df2 <- select(df2, Color, Name)
 #     #      tmp <- df2
 #     #      tmp
 #     # })
 # # ###highly experimental    
 #    inBounds <- reactive({
 #          if (is.null(input$map_bounds)){
 # 
 #          bounds <- input$map_bounds
 # 
 #         boundsOut <- data.frame(N=bounds$north,
 #                                S=bounds$south,
 #                                E=bounds$east,
 #                                W=bounds$west)
 # 
 #         boundsLL <- data.frame(EW=((bounds$east + bounds$west)/2),
 #                                 NS=((bounds$north + bounds$south)/2)
 #                                )
 #         boundsLL
 # 
 #         }
 # 
 # 
 #     })
 #     
 #    #test <- reactive({data.frame(input$map_bounds)})
 # 
 #      
 #      output$tblx <- renderTable({input$map_bounds})
 #      #output$tbl2 <- renderTable({input$map_bounds})
 #      # output$tbl3 <- renderText({input$map_zoom})
 #      #output$tbl4 <- renderPrint({input$lat})
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
              rectangleOptions = FALSE,
              editOptions = editToolbarOptions(selectedPathOptions = selectedPathOptions()))
            
            
 #          
 #            #addHomeButton(ext=EXTENT, HTML("<i>Home</>"))
 #            if(input$selectFMP == "LOBSTER"){
 #             map <- map %>%  setView(-82, 25, zoom=9) 
            # }
 #        
 #          # map <- map %>%  addLegend(colors=c(legendSelector()$Color),
 #          #                labels=c(legendSelector()$Name),
 #          #                opacity=1, position="bottomleft")
 # 
      })
 #     
 #     
 # #      
      observe({
        map  <- leafletProxy('map')
        map <- map  %>% leaflet::clearGroup(group="A") #%>%
          # isolate({map <- map  %>%
          # setView(inBounds()$EW, inBounds()$NS, zoom = input$map_zoom)
          # })
        for(i in 1:length(superSelector())){
          map <- map  %>%
            #addEsriDynamicMapLayer(superSelector()[i], group="A")
          addTiles(superSelector()[i], group="A")
        }

        map
      })
 # #     
 #      observeEvent(input$map_zoom,{
 #       leafletProxy("map") %>%
 #          setView(lat  = (input$map_bounds$north + input$map_bounds$south) / 2,
 #                  lng  = (input$map_bounds$east + input$map_bounds$west) / 2,
 #                  zoom = input$map_zoom)
 #      })
 # 
 # #     
 # #     output$tbl = DT::renderDataTable(
 # #          species, options = list(lengthChange = FALSE))
 # #     ##################################################
 # #     summarySelector <- reactive({
 # #       df <- subset(df, df$FMP %in% input$selectFMP)
 # #       df <- arrange(df, desc(order))
 # #       tmp <- df$RMD
 # #       tmp
 # #     })
 # #     
 # #     ################################################
 # #     
 # #     ##################################################
 # #     downloadSelector <- reactive({
 # #       df <- subset(df, df$FMP %in% input$selectFMP)
 # #       df <- arrange(df, desc(order))
 # #       tmp <- df$Download
 # #       tmp
 # #     })
 # #     
 # #     ################################################
 # #     
 # #     
 # #     output$tbl2 <- renderTable({summarySelector()})
 # #     
 # #     output$Description <- renderUI({
 # #       #for(i in 1:length(summarySelector() ))  {
 # #       tags$iframe(src = summarySelector()[1], seamless=NA, width="100%", style="height: calc(100vh - 80px)",frameborder=0, scrolling="yes")
 # #     })
 # #     
 # #     # output$Download <- renderUI({
 # #     #   #for(i in 1:length(summarySelector() ))  {
 # #     #   tags$iframe(src = downloadSelector()[1], seamless=NA,width="100%", style="height: calc(100vh - 80px)",frameborder=0)
 # #     # })
 # #     
 # #     ## Download a map
 # #     output$dl <- downloadHandler(
 # #          filename = "map.png",
 # #          
 # #          content = function(file) {
 # #               appshot(app="https://gulfcouncilportal.shinyapps.io/regulationsMap/", file = file)
 # #          }
 # #     )
 # #     
 # #     
 # #     
 # #     ## End : Download a map
 # #     ################################################################################
 # #     observeEvent(input$home,{
 # #          map  <- leafletProxy("map") %>%
 # #               setView(-85, 27, zoom=6)
 # #          map
 # #     })
 # #     ################################################################################ 
 # #     
 # #     
      ############### Get location for point in polygon
      output$out2 <- renderText({
        validate(need(input$map_click, FALSE)) #prevents error on load
        x <- data.frame(input$map_click[1:2])
        rownames(x) <- NULL
        colnames(x) <- c("Latitude","Longitude")
        x$Latitude <- round(x$Latitude,2)
        x$Longitude <- round(x$Longitude,2)
        #paste("Latitude: ", input$map_click[1:1])
        paste("Latitude: ",  x$Latitude,
              "Longitude: ", x$Longitude)
      })
      
      ####################reactive for point in polygon
          PIP <- reactive({
            validate(need(input$map_click, FALSE)) #prevents error on load
            point <- as.numeric(as.character(input$map_click[2:1]))
            #point <- data.frame(c(-85, 29))
            x <- st_point(point)
            CoralPIP <- st_intersects(x, Coral, sparse=FALSE)
            CMPPIP <- st_intersects(x, CMP, sparse=FALSE)
            CoralPIP <- st_intersects(x, Coral, sparse=FALSE)
            RedDrumPIP <- st_intersects(x, RedDrum, sparse=FALSE)
            ReefFishPIP <- st_intersects(x, ReefFish, sparse=FALSE)
            ShrimpPIP <- st_intersects(x, Shrimp, sparse=FALSE)
            EFHout$EFH <- c(CoralPIP, CMPPIP, CoralPIP,
                            RedDrumPIP, ReefFishPIP,ShrimpPIP)
            #EFHout$shapefile <- HTML('<a target="_blank" href="http://sero.nmfs.noaa.gov/maps_gis_data/fisheries/gom/documents/spanish_mackerelzones.txt">Section 622.369—Migratory groups of Spanish mackerel</a>. <br> Maps: <br> GIS Data: <a href="http://portal.gulfcouncil.org/Regulations/spanish_mackerel_po.zip">Shapefile</a>')
            EFHout$Lat <- point[2]
            EFHout$Long <- point[1]
            EFHout$Long <- point[1]
            EFHout
          })
      
          output$out3 <- renderTable({PIP()})

          ## Add marker on Click #######
          observeEvent(input$map_click,{
            click <- input$map_click
            clat <- click$lat
            clon <- click$lng
            leafletProxy("map") %>% 
              clearMarkers() %>% 
              addMarkers(clon, clat)    
          })
          
          output$test <- renderPrint({
            #observeEvent(input$map_draw_new_feature, {
            print(unlist(input$map_draw_new_feature[3]))
            #print(boxCoords())
            
          })
          
          boxCoords <- reactive({
            tmp <- data.frame(unlist(input$map_draw_new_feature[3]))
            df <- data.frame(x=tmp[c(2,4, 6,8, 10),1], y=tmp[c(3,5,7,9,11),1])
            df$x <- as.numeric(as.character(df$x))
            df$y <- as.numeric(as.character(df$y))
            df$id <- 1:nrow(df)
            # out <- data.frame(minX= min(df$x), maxX=max(df$x),
            #                   minY=min(df$y), maxY=max(df$y))
           df
          })
          
          output$out4 <- renderTable({boxCoords()})
          
      
}


