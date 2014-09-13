# ui.R
shinyUI(pageWithSidebar(
  headerPanel("Determine Current Value of Your Invesment Made in Two Stocks"),
  sidebarPanel(
      h4("Input any two stocks traded on NYSE or NASDAQ"),
      br(),
      textInput(inputId="stock1", label=h5("Input First Stock Symbol:"), "AAPL"),
      numericInput(inputId="inv1", label=h5("Enter Investment in First Stock ($):"), 1000),
      br(),
      textInput(inputId="stock2", label =h5("Input Second Stock Symbol:"), "MSFT"),
      numericInput(inputId="inv2", label=h5("Enter Investment in Second Stock ($):"), 1000),
      br(),
      dateInput(inputId="invDate", label= h5("Investment Date:"), value="2011-01-01"),

      submitButton('Submit')
    ),
  
mainPanel(
    h4("Current Value of Your Investments:"),
    h4(textOutput("currValue"), style="color:darkblue"),
    br(),
    htmlOutput("view"),
    br(),
    h4("Application Description:"),
    HTML("<ul>
      <li>This shiny application provides current value of your investments made in two stocks at a given date.</li>
      <li>Please select two stocks you are interested in, along with starting investment amounts and investment date. Click on Submit to see the results.</li>
      <li>Current Value does not take 'Dividend Income' or 'Reinvestment' into account and is purely based on 'Capital Appreciation'</li>
      <li>googleVis Package has been used for the charting. Yahoo finance site has been used as the source of all data</li>
      </ul>"
         )
    )
  ))