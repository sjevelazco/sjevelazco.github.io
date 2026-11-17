# -----------------------------------------------------------------------------
# Helper functions used by the .qmd pages to turn the CSV files in data/
# into Markdown. They only use base R, so the site renders without extra
# packages (Quarto + knitr + rmarkdown are the only requirements).
#
# Edit the CSV files in data/ to update the website; you rarely need to
# touch this file.
# -----------------------------------------------------------------------------

# Path helper that works no matter which page is being rendered
site_path <- function(...) {
  root <- Sys.getenv("QUARTO_PROJECT_DIR", unset = ".")
  file.path(root, ...)
}

read_data <- function(file) {
  utils::read.csv(site_path("data", file), stringsAsFactors = FALSE,
                  encoding = "UTF-8", na.strings = c("", "NA"))
}

# Bold my name in author lists (handles "Velazco, S.J.E.", "Velazco S. J. E.", ...)
highlight_me <- function(x) {
  gsub("(Velazco,? ?S\\. ?J\\. ?E\\.)", "**\\1**", x, perl = TRUE)
}

# One publication -> one Markdown list item
format_pub <- function(citation, doi = NA, url = NA) {
  txt <- gsub("([*_])", "\\\\\\1", citation)  # escape Markdown characters
  txt <- highlight_me(txt)
  if (!is.na(doi) && nzchar(doi)) {
    txt <- paste0(txt, " [doi:", doi, "](https://doi.org/", doi, "){target=\"_blank\"}")
  } else if (!is.na(url) && nzchar(url)) {
    txt <- paste0(txt, " [[link]](", url, "){target=\"_blank\"}")
  }
  txt
}

# Full publication list, grouped by year (newest first)
print_publications <- function(file = "publications.csv") {
  pubs <- read_data(file)
  pubs <- pubs[pubs$status == "published", ]
  pubs <- pubs[order(-pubs$year), ]
  n <- nrow(pubs)
  for (yr in unique(pubs$year)) {
    cat("\n\n## ", yr, "\n\n", sep = "")
    p <- pubs[pubs$year == yr, ]
    for (i in seq_len(nrow(p))) {
      # (paragraphs instead of an ordered list, so numbers count down correctly)
      cat("::: {.pub}\n[", n, ".]{.pub-num} ",
          format_pub(p$citation[i], p$doi[i], p$url[i]), "\n:::\n\n", sep = "")
      n <- n - 1
    }
  }
}

# Manuscripts under review
print_under_review <- function(file = "publications.csv") {
  pubs <- read_data(file)
  pubs <- pubs[pubs$status == "under_review", ]
  for (i in seq_len(nrow(pubs))) {
    cat("- ", format_pub(pubs$citation[i], pubs$doi[i], pubs$url[i]), "\n", sep = "")
  }
}

# Featured papers (featured = TRUE in the CSV)
print_featured <- function(file = "publications.csv", n = 6) {
  pubs <- read_data(file)
  pubs <- pubs[pubs$status == "published" & pubs$featured %in% c(TRUE, "TRUE"), ]
  pubs <- utils::head(pubs[order(-pubs$year), ], n)
  for (i in seq_len(nrow(pubs))) {
    cat("- ", format_pub(pubs$citation[i], pubs$doi[i], pubs$url[i]), "\n", sep = "")
  }
}

n_publications <- function(file = "publications.csv") {
  pubs <- read_data(file)
  sum(pubs$status == "published")
}

# Courses as a Markdown table
print_courses <- function(type = c("graduate", "workshop"), file = "courses.csv") {
  type <- match.arg(type)
  x <- read_data(file)
  x <- x[x$type == type, ]
  x <- x[order(-x$year), ]
  cat("| Year | Course | Hours | Institution | Place |\n")
  cat("|:----:|:-------|:-----:|:------------|:------|\n")
  for (i in seq_len(nrow(x))) {
    cat("| ", x$year[i], " | ", x$title[i], " | ", x$hours[i], " | ",
        x$institution[i], " | ", x$place[i], " |\n", sep = "")
  }
}

# Mentees by level
print_mentees <- function(level = c("PhD", "MSc", "Undergraduate"), file = "mentees.csv") {
  level <- match.arg(level)
  x <- read_data(file)
  x <- x[x$level == level, ]
  x <- x[order(x$end != "present", -x$start), ]
  for (i in seq_len(nrow(x))) {
    period <- if (x$start[i] == x$end[i]) x$start[i] else paste0(x$start[i], "–", x$end[i])
    cat("- **", x$name[i], "** — ", x$role[i], " (", period, "). ",
        x$program[i], "\n", sep = "")
  }
}

n_mentees <- function(file = "mentees.csv") nrow(read_data(file))
