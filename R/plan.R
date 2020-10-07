# The workflow plan data frame outlines what you are going to do.
plan <- drake_plan(
  raw_text = list(
    "DNov" = get_raw_text("DNov"),
    "19C" = get_raw_text("19C"),
    "AAW" = get_raw_text("AAW"),
    "ArTs" = get_raw_text("ArTs"),
    "ChiLit" = get_raw_text("ChiLit")
  ),
  arguments_ = arguments_df(),
  results_ = target(
    go_coco(arguments_, raw_text),
    dynamic = map(arguments_)
  ),
  results_csv = write_csv(results_, path = "results.csv"),
  report = rmarkdown::render(
    knitr_in("report.Rmd"),
    output_file = file_out("report.html"),
    quiet = TRUE
  )
)
