## ui.R

dashboardPage(
     dashboardHeader(disable=TRUE),
    # title="GIS Data for the Gulf of Mexico Fisheries"),
          dashboardSidebar(
               sidebarMenu(id = "tab",
            
                    menuItem(" ", tabName = "map",selected=TRUE),
                    tags$head(includeCSS("Style.css")),
                    tags$style(type="text/css",
                               ".shiny-output-error { visibility: hidden; }",
                               ".shiny-output-error:before { visibility: hidden; }"
                    ),
                    
                    div(img(src="logo.png"), style="text-align: center;"),
                    div(
                         selectInput("selectFMP", multiple=TRUE,
                                     h3("Select Fishery Management Plan:"),
                                     c("Coastal Migratory Pelagic" = "CMP", ##removed for now
                                        "Coral and Coral Reefs" = "CORAL",
                                        "Spiny Lobster" = "LOBSTER",
                                        #"Red Drum" = "REDDRUM",
                                        "Reef Fish" = "REEF",
                                        "Shrimp" = "SHRIMP"
                                       ),
                                     selected = c("CORAL"))#
                        ),

                    br(),
                    br(),
                    br(),
                    br(),
                    br(),
                    br(),
                    br(),
                    br(),

                    div(tags$a(href="mailto: portal@gulfcouncil.org", h4("portal@gulfcouncil.org")), align="center"),
                    div(br()),
HTML("<h5 id='title' style='text-align:center;' >Gulf of Mexico <br> Fishery Management Council <br> 2203 North Lois Avenue, Suite 1100 <br>
     Tampa, Florida 33607 USA <br> P: 813-348-1630")
                    
                    )),
     dashboardBody(
          tabItems(
               tabItem(tabName='map',
                       includeScript('modalJS.js'),
                       # tabItem(tabName='map',includeHTML('modalHTML4.html'),
                       #         includeScript('modalJS.js'),
                       #tags$img(src="HAPCViewerBanner.png",  width="100%"),
                     HTML("<h3 id='title' style='color: white;' >Essential Fish Habitat Mapping Application for the Gulf of Mexico Fisheries</h3>"),
                  leafletOutput('map',height=600),
                  tableOutput("test"),
                  #textOutput("test2"),
                  #tableOutput("out4"),
                  #uiOutput("ui")
                  box(tableOutput("out3"), width=6)
  
                  #box(htmlTableWidgetOutput("EFHtable"), width=6)#,

                  )#,

          )
          
          )
)

