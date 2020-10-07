# The workflow plan data frame outlines what you are going to do.
plan <- drake_plan(
  raw_text = list(
    "DNov" = get_raw_text("DNov"),
    "19C" = get_raw_text("19C"),
    "AAW" = get_raw_text("AAW"),
    "ArTs" = get_raw_text("ArTs"),
    "ChiLit" = get_raw_text("ChiLit")
  ),
  left = c("DNov", "19C", "AAW", "ArTs", "ChiLit"),
  right = c("DNov", "19C", "AAW", "ArTs", "ChiLit"),
  fdr = seq(0.01, 0.05, .01),
  span_left = 1:5,
  span_right = 1:5,
  results = target(
    coco_tibble(
      works = raw_text,
      left = left,
      right = right,
      fdr = fdr,
      span = to_span_string(c(span_left, span_right))
    ),
    dynamic = cross(left, right, fdr, span_left, span_right)
  ),
  results_csv = write_csv(results, path = "results.csv"),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)
