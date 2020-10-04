# The workflow plan data frame outlines what you are going to do.
plan <- drake_plan(
  raw_text = list(
    "DNov" = get_raw_text("DNov"),
    "19C" = get_raw_text("19C"),
    "AAW" = get_raw_text("AAW"),
    "ArTs" = get_raw_text("ArTs"),
    "ChiLit" = get_raw_text("ChiLit")
  ),
  works =  raw_text %>%
    map(compose(unlist, compose(stri_extract_all_words, stri_trans_tolower))),
  arguments = tibble(
    left = names(works),
    right = names(works)) %>%
    expand(
      left,
      right,
      fdr = c(0.01, 0.02),
      span = cross2(1:5, 1:5) %>%
        map(unlist) %>%
        map_chr(to_span_string)
    ),
  nested_results = arguments %>%
    filter(left != right) %>%
    mutate(results = pmap(., partial(coco_tibble, works = works))),
  results = nested_results %>%
    unnest(cols = c(results)) %>%
    mutate(
      label = map2_chr(
        x,
        y,
        ~ paste(format(.x, justify = "right", width = 10),
                format(.y, justify = "left", width = 10))
      )
    ),
  results_csv = write_csv(results, path = "results.csv"),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)
