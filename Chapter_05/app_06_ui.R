## Construct UI

# dashboard header ----

header <- dashboardHeader(
  title = "Accidents"
)

# dashborad sidebar ----

sidebar <- dashboardSidebar(
  ## inject hlper javascript ----
  useShinyjs(),
  introjsUI(),
  use_tippy(),
  ## sidebar menu ----
  sidebarMenu(
    id = "tabs",
    div(
      style = "margin-left: 20px; margin-top: 20px;",
      ### links to the tabs ----
      tagList(
        #### tables/stories link ----
        introBox(
          menuItem(text = "Tables/Stories", tabName = "tables", icon = icon("table")),
          data.step = 8,
          data.intro = glue::glue(
            "The app starts on the tab that shows the tables and the random narrative.
              You can always return to the tables tab by clicking on this menu item.
              \n\nThis is the last item in our tutorial.  Click Done to finish."
          )
        ),
        #### vertical space ----
        div(style = "height: 20px;"),
        #### graph link ----
        introBox(
          menuItem(text = "Graph", tabName = "graph", icon = icon("chart-area")),
          data.step = 7,
          data.intro = glue::glue(
            "Click on this menu itme to be taken to a graph
              of the number of accidents associated with the
              selected product.  Look for tool-tips that will tell you
              more about how to control the graph."
          )
        ) # end introbox
      ) # end taglist
    ), # end enclosing div,
    br(),
    ### producet select widget ----
    introBox(
      selectInput("code", "Product",
                  choices = setNames(products$prod_code, products$title),
                  width = "100%"
      ),
      data.step = 2,
      data.intro = glue::glue(
        "'Product' refers to the type of item that was involved in 
        the person's accident.  Scroll down the list of choices and select
        your favorite one!"
      )
    ),
    ### tutorial action button ----
    introBox(
      actionButton("help", HTML("Press for a tutorial!")),
      data.step = 1,
      data.intro = app_intro,
      data.position = "right"
    )
  )
)

# dashboard body ----

body <- dashboardBody(
  ## CSS for tooltips ----
  tags$style(
    HTML(
      glue::glue("
                    .tippy-tooltip {
                      font-size: 1.5rem !important;
                      padding: 0.3rem 0.6rem;
                      }
                   ", .open = "{{")
    )
  ),
  ## our tabs items ----
  tabItems(
    ### tables tab item ----
    tabItem(
      tabName = "tables",
      fluidRow(
        #### diagnosis table ----
        introBox(
          box(
            width = 4,
            title = "Diagnosis",
            status = "primary",
            solidHeader = TRUE,
            background = table_bg_color,
            tableOutput("diag")
          ),
          data.step = 3,
          data.intro = glue::glue(
            "Here we tally up the accidents by the medical diagnosis given to the
              injury.  The 'n' column is an estimate of how
              many accidents of the selected type result in the given diagnosis,
              each year."
          )
        ),
        #### body part table ----
        introBox(
          box(
            width = 4,
            title = "Body Part",
            status = "primary",
            solidHeader = TRUE,
            background = table_bg_color,
            tableOutput("body_part")
          ),
          data.step = 4,
          data.intro = glue::glue(
            "Here we tally up the accidents by what part of the
              body was injured.  The 'n' column is an estimate of how
              many people in the U.S. sustain this type of injury each year."
          )
        ),
        #### location table ----
        introBox(
          box(
            width = 4,
            title = "Location of Injury",
            status = "primary",
            solidHeader = TRUE,
            background = table_bg_color,
            tableOutput("location")
          ),
          data.step = 5,
          data.intro = glue::glue(
            "Here we tally up the accidents by the sort of place
              where the accident occurred.  The 'n' column is an estimate of how
              many accidents of the selected type occur in the given location
              each year."
          )
        )
      ), # <<row
      br(),
      ### story button ----
      fluidRow(
        column(
          2,
          introBox(
            actionButton("story", "Tell me a story"),
            data.step = 6,
            data.intro = glue::glue(
              "This is the (morbidly) fun part!  Every time you click this button
                     the app will pick a random accident associated with the
                     product you have selected, and will display the narrative
                     of how the accident occurred."
            )
          )
        ),
        column(10, textOutput("narrative"))
      ) # <<row
    ), # <<tabItem,
    ## graph tab ----
    tabItem(
      tabName = "graph",
      ### the graph itself ----
      fluidRow(
        box(
          width = 12,
          title = "Accidents by Age and Gender",
          status = "primary",
          solidHeader = TRUE,
          plotlyOutput("age_sex")
        ),
        br(),
        ### y-axis widget ----
        div(
          style = "margin-left: 20px;",
          tagList(
            selectInput("y",
                        tippy("Choose Y-Axis Units (hover here for info)",
                              tooltip = units_info, width = "100px"
                        ),
                        choices = c("rate", "count")
            ),
            tippy_this("y", "Tooltip", placement = "right")
            
          ) # end taglist
        ) # end div
      ) # <<row
    ) # <<tabItem
  ) # <<tabItems
) # <<body

# assemble ui ----

ui <- dashboardPage(
  skin = dashboard_skin,
  header = header,
  sidebar = sidebar,
  body = body
)
