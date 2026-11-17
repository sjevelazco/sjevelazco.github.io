# -----------------------------------------------------------------------------
# Manage the website from R / RStudio
#
#   source("R/manage_site.R")
#   preview_site()        # live preview in your browser while you edit
#   build_site()          # render the full site into docs/
#   add_publication(...)  # append a new paper to data/publications.csv
#   add_mentee(...)       # append a new student to data/mentees.csv
#   add_course(...)       # append a new course/workshop to data/courses.csv
#
# Requirements: Quarto (https://quarto.org/docs/get-started/) and the R packages
# rmarkdown + knitr. The 'quarto' R package is optional (used if installed).
# -----------------------------------------------------------------------------

preview_site <- function() {
  if (requireNamespace("quarto", quietly = TRUE)) {
    quarto::quarto_preview()
  } else {
    system("quarto preview")
  }
}

build_site <- function() {
  if (requireNamespace("quarto", quietly = TRUE)) {
    quarto::quarto_render()
  } else {
    system("quarto render")
  }
  message("Site rendered into docs/. Commit and push docs/ to update the website.")
}

.append_row <- function(file, row) {
  path <- file.path("data", file)
  x <- utils::read.csv(path, stringsAsFactors = FALSE, encoding = "UTF-8",
                       colClasses = "character")
  row <- as.data.frame(lapply(row, as.character), stringsAsFactors = FALSE)
  row <- row[, names(x)]
  x <- rbind(row, x) # newest first
  utils::write.csv(x, path, row.names = FALSE, fileEncoding = "UTF-8", na = "")
  message("Added to ", path, " (", nrow(x), " rows).")
  invisible(x)
}

#' @param citation Full reference text, e.g. "Velazco, S.J.E., ... (2027). Title. Journal 1, 1-10."
#' @param year Publication year (leave NA for manuscripts under review)
#' @param doi DOI without the https://doi.org/ prefix
#' @param status "published" or "under_review"
#' @param featured TRUE to show it under "Selected publications" on the homepage
add_publication <- function(citation, year = NA, doi = "", url = "",
                            status = "published", featured = FALSE) {
  .append_row("publications.csv", list(
    year = ifelse(is.na(year), "", year), status = status, citation = citation,
    doi = doi, url = url, featured = toupper(as.character(featured))
  ))
}

add_mentee <- function(name, level = c("PhD", "MSc", "Undergraduate"),
                       role = "Advisor", program, start, end = "present") {
  level <- match.arg(level)
  .append_row("mentees.csv", list(level = level, name = name, role = role,
                                  program = program, start = start, end = end))
}

add_course <- function(title, year, hours, institution, place,
                       type = c("graduate", "workshop")) {
  type <- match.arg(type)
  .append_row("courses.csv", list(type = type, year = year, title = title,
                                  hours = hours, institution = institution,
                                  place = place))
}
