# Your custom code is a bunch of functions.
create_plot <- function(data) {
  ggplot(data) +
    geom_histogram(aes(x = Ozone), binwidth = 10) +
    theme_gray(24)
}

coco_tibble <- function(works, left, right, fdr, span) {
  CorporaCoCo::surface_coco(
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