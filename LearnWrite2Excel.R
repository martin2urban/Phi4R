install.packages("openxlsx") 
library(openxlsx)
## Create a new workbook 
wb <- createWorkbook("Martine") 
## Add a worksheets 
addWorksheet(wb, "phiFromR", gridLines = TRUE) 
##write data to worksheet 1 
writeData(wb, sheet = 1, phi, rowNames = FALSE) 
## set column width for row names column saveWorkbook(wb, "addStyleExample.xlsx", overwrite = TRUE)  
saveWorkbook(wb, file = "phiFromR.xlsx", overwrite = TRUE) 
