# sjevelazco.github.io

Personal academic website of **Santiago José Elías Velazco**, built with [Quarto](https://quarto.org) and R, and hosted (once published) on GitHub Pages.

## Structure

```
├── _quarto.yml            # site settings: navbar, theme, output folder
├── index.qmd              # Home (photo, short bio, selected papers, news)
├── bio.qmd                # Bio, positions, education, service, awards
├── research.qmd           # Research lines, projects, talks
├── publications.qmd       # Full list, generated from data/publications.csv
├── software.qmd           # flexsdm, adm, bdc, ENMTML, pyflexsdm, MSDM
├── teaching.qmd           # Philosophy, courses and mentees (from data/*.csv)
├── collaboration.qmd      # Graduate programs, mentors, collaborators
├── data/
│   ├── publications.csv   # one row per paper  ← edit to add papers
│   ├── courses.csv        # courses and workshops
│   └── mentees.csv        # students supervised
├── R/
│   ├── site_functions.R   # turns the CSVs into Markdown (used by the pages)
│   └── manage_site.R      # preview_site(), build_site(), add_publication(), ...
├── styles/custom.scss     # colours and fonts
├── images/                # profile photo, favicon
├── files/                 # CV (PDF)
└── docs/                  # rendered website (created by build_site())
```

## Requirements (one time)

1. Install [Quarto](https://quarto.org/docs/get-started/).
2. In R: `install.packages(c("rmarkdown", "knitr", "quarto"))`.

## Everyday use (from R / RStudio)

Open `sjevelazco.github.io.Rproj`, then:

```r
source("R/manage_site.R")

preview_site()   # live preview; the page reloads every time you save a file

# add a new paper (it appears on the Publications page automatically)
add_publication(
  citation = "Velazco, S.J.E., Coauthor, A. (2027). Title of the paper. Journal 10, e123.",
  year = 2027, doi = "10.xxxx/xxxxx", featured = FALSE
)

add_mentee(name = "Student Name", level = "MSc", role = "Advisor",
           program = "Federal University of ..., Graduate Program in ...", start = 2027)

build_site()     # renders everything into docs/
```

