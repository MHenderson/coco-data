get_raw_text <- function(shortcode) {
  Sys.getenv("CORPORA_PATH") %>%
    file.path(shortcode) %>%
    list.files(pattern = "*.txt", full.names = TRUE) %>%
    lapply(readLines) %>%
    unlist() %>%
    stri_trans_tolower() %>%
    stri_extract_all_words() %>%
    unlist()
}

# this function needs to return the inputs as well, as new columns
coco_tibble <- function(works, left, right, fdr, span) {
  surface_coco(
    a = works[[left]],
    b = works[[right]],
    fdr = fdr,
    span = span,
    nodes = c('back', 'eye', 'eyes', 'forehead', 'hand', 'hands', 'head', 'shoulder')
  ) %>%
  mutate(left = left, right = right, fdr = fdr, span = span)
}

to_span_string <- function(x){
  if (x[1] == x[2]) {
    result <- paste0(x[1], "LR")
  } else
  {
    result <- paste0(x[1], "L", x[2], "R")
  }
  return(result)
}
