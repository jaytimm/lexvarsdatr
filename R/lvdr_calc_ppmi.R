#' Query CELEX database
#'
#' These functions make life easier when querying the behavioral datasets.
#'
#' @name lvdr_build_sparse_ppmi
#' @param form A word or affix
#' @param type A part-of-speach (of universal variety) or "PRE"|"SUF"
#' @return A data.frame

#' @export
#' @rdname lvdr_calc_ppmi

lvdr_calc_ppmi <- function (pmat,
                            make_symmetric = TRUE) {

  pmat <- as(pmat, 'dgCMatrix')
  pmat <- pmat[, order(colnames(pmat))] #1
  pmat <- pmat[order(rownames(pmat)), ]

  if (make_symmetric) {
    pmat <- Matrix::forceSymmetric(pmat)
  }

  tcmrs <- Matrix::rowSums(pmat) +1 #Still -- for weights.
  tcmcs <- Matrix::colSums(pmat) +1

  N <- sum(tcmrs) ## Compute relative frequency
  colp <- tcmcs/N
  rowp <- tcmrs/N

  pp <- pmat@p+1
  ip <- pmat@i+1

  tmpx <- rep(0,length(pmat@x))

  for(i in 1:(length(pmat@p)-1) ){
    ind <- pp[i]:(pp[i+1]-1)
    not0 <- ip[ind]

    icol <- pmat@x[ind]  ## Co-occur frequency
    tmp <- log( (icol/N) / (rowp[not0] * colp[i])) #PMI
    tmpx[ind] <- tmp}

  pmat@x <- tmpx
  pmat@x[pmat@x <= 0] <- 0 ##PPMI
  pmat@x[!is.finite(pmat@x)] <- 0
  pmat <- Matrix::drop0(pmat, tol=0)
}
