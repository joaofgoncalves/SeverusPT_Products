
## ----------------------------------------------------------------------------------- ##
## Ancillary R functions ----
## ----------------------------------------------------------------------------------- ##


spt_periods_to_today <- function(date, ndays) {
  today <- Sys.Date()
  d <- as.Date(date)
  timeDiff <- as.numeric(difftime(today, d, units = "days"))
  daysDiff <- ceiling(timeDiff)
  return(floor(daysDiff / ndays))
}


spt_pad_number <- function(x, width = 3){
  stringr::str_pad(x, width = width, side = "left", pad = 0)
} 


spt_ymd_date <- function() {
  date <- Sys.Date()
  year <- format(date, "%Y")
  month <- format(date, "%m")
  day <- format(date, "%d")
  if (nchar(month) == 1) {
    month <- paste0("0", month)
  }
  if (nchar(day) == 1) {
    day <- paste0("0", day)
  }
  return(paste0(year, month, day))
}


spt_current_date_time <- function() {
  current_time <- Sys.time()
  datetime_str <- format(current_time, "%Y-%m-%d %H:%M:%S")
  return(datetime_str)
}

spt_current_year <- function() {
  return(format(Sys.time(), "%Y"))
}

spt_product_name <- function(ProjectAccronym, 
                           SeverityIndicator, 
                           BaseIndex, 
                           SatCode, 
                           BurntAreaDataset, 
                           ReferenceYear, 
                           RefPeriods, 
                           addCalcDate = FALSE, 
                           VersionNumber) {
  if (addCalcDate) {
    CalculationDate <- spt_ymd_date()

    productName <- paste(
      ProjectAccronym, "_", 
      SeverityIndicator, "_", 
      BaseIndex, "_",  
      SatCode, "_",
      spt_ba_dataset_code(BurntAreaDataset), 
      ReferenceYear, "_",
      RefPeriods, "_", 
      CalculationDate, "_",
      VersionNumber,
      sep = "")
    
  } else {
    
    productName <- paste(
      ProjectAccronym, "_", 
      SeverityIndicator, "_", 
      BaseIndex, "_",  
      SatCode, "_",
      spt_ba_dataset_code(BurntAreaDataset), 
      ReferenceYear, "_",
      RefPeriods, "_", 
      VersionNumber,
      sep = "")
  }

  return(productName)
}


spt_backup_file <- function(targetFile) {
  # Get the file name and extension
  file_ext <- tools::file_ext(targetFile)
  file_name <- tools::file_path_sans_ext(targetFile)

  # Create the backup file name with the suffix _bkp
  bkp_file_name <- paste0(file_name, "_bkp.", file_ext)

  # Copy the file to the backup file name
  file.copy(targetFile, bkp_file_name)
}


spt_df_to_md <- function(df) {
  knitr::kable(df,
    format = "markdown",
    col.names = colnames(df), align = "l"
  )
}


spt_export_to_md <- function(df, filename) {
  # Create a pretty table
  ktable <- spt_df_to_md(df)
  kableExtra::save_kable(ktable, file = filename)
}


spt_file_dates <- function(filename, tdelta = 60) {
  if(!file.exists(filename)) {
    return(FALSE)
    #stop(paste0("File ", filename, " does not exist."))
  }
  else {
    ctime <- file.info(filename)$ctime # file creation time
    mtime <- file.info(filename)$mtime # file modification time
    now <- Sys.time()
    if(difftime(now,ctime,units = "mins") < tdelta || 
       difftime(now,mtime,units="mins") < tdelta) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}

spt_create_file <- function(filename) {
  if(file.exists(filename)){
    file.remove(filename)
  }
  fileConn <- file(filename, open = "w")
  writeLines(as.character(paste0(Sys.time(),"\n")), fileConn)
  close(fileConn)
}



spt_download_unzip <- function(url, dest_file, extdir) {
  
  download.file(url, dest_file, mode = "wb")
  
  if (tools::file_ext(dest_file) == "zip") {
    unzip(dest_file, exdir = extdir, overwrite = TRUE)
  }
}


