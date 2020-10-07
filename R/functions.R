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

coco_tibble <- function(works, left, right, fdr, span) {
  surface_coco(
    a = works[[left]],
    b = works[[right]],
    fdr = fdr,
    span = span,
    nodes = c('back', 'eye', 'eyes', 'forehead', 'hand', 'hands', 'head', 'shoulder')
  )
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

arguments <- function(corpora, fdr, span) {
  tibble(left = corpora, right = corpora) %>%
    expand(
      left,
      right,
      fdr = fdr,
      span = cross2(span, span) %>%
        map(unlist) %>%
        map_chr(to_span_string)
    ) %>%
    filter(left != right)
}

arguments_df <- function() {
  arguments(c("DNov", "19C", "AAW", "ArTs", "ChiLit"), seq(0.01, 0.05, .01), 1:5) %>%
    split(f = .$left)
}

go_coco <- function(x, y) {
  x[[1]] %>%
    mutate(results = pmap(., partial(coco_tibble, works = y))) %>%
    unnest(cols = c(results))
}
