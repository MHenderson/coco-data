# The workflow plan data frame outlines what you are going to do.
plan <- drake_plan(
  raw_data = list(
    "DNov" = unlist(lapply(list.files(file.path(corpora_path, "DNov"), pattern = "*.txt", full.names = TRUE), readLines)),
    "19C" = unlist(lapply(list.files(file.path(corpora_path, "19C"), pattern = "*.txt", full.names = TRUE), readLines)),
    "AAW" = unlist(lapply(list.files(file.path(corpora_path, "AAW"), pattern = "*.txt", full.names = TRUE), readLines)),
    "ArTs" = unlist(lapply(list.files(file.path(corpora_path, "ArTs"), pattern = "*.txt", full.names = TRUE), readLines)),
    "ChiLit" = unlist(lapply(list.files(file.path(corpora_path, "ChiLit"), pattern = "*.txt", full.names = TRUE), readLines))
  ),
  works =  raw_data %>%
    purrr::map(purrr::compose(unlist, purrr::compose(stringi::stri_extract_all_words, stringi::stri_trans_tolower))),
  arguments = tibble(
    left = names(works),
    right = names(works)
  ) %>%
    expand(
      left,
      right,
      fdr = c(0.01, 0.02),
      span = purrr::cross2(1:5, 1:5) %>% purrr::map(unlist) %>% purrr::map_chr(to_span_string)
    ),
  nested_results = arguments %>%
    filter(left != right) %>%
    mutate(results = purrr::pmap(., purrr::partial(coco_tibble, works = works))),
  results = nested_results %>%
    tidyr::unnest(cols = c(results)) %>%
    dplyr::mutate(
      label = purrr::map2_chr(
        x,
        y,
        ~ paste(format(.x, justify = "right", width = 10), format(.y, justify = "left", width = 10))
      )
    ),
  results_csv = readr::write_csv(results, path = "results.csv")
  
)
