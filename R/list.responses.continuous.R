# Copyright (C) 2010-2012 Leo Lahti
# Contact: Leo Lahti <leo.lahti@iki.fi>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

#' Description: Investigate association of a continuous variable and the modes
#' 
#' Arguments: 
#' @param annotation.df annotation data.frame with discrete factor levels, rows
#' named by the samples
#' @param model NetResponse model object
#' @param method method for quantifying the association
#' @param min.size minimum sample size for a response
#' @param qth q-value threshold
#' @param verbose verbose 
#' @param data data (samples x features)
#' @param rounding rounding digits
#'
#' Returns:
#' @return Table listing all associations between the factor levels and
#' responses
#' @author Contact: Leo Lahti \email{leo.lahti@@iki.fi}
#' @references See citation("netresponse")
#' @export
#' @keywords utilities

list.responses.continuous <- function (annotation.df, model, method = "t-test", min.size = 1, qth = Inf, verbose = TRUE, data = NULL, rounding = NULL) {

  # annotation.df <- annot[rownames(dat), continuous.vars]; model <- model[[id]]; method <- "t-test"; min.size = 1; qth = qth; data = t(dat[, gpt]); rounding = 3; model <- model.bu[[id]]
  # annotation.df <- annot[names(vec), continuous.vars]; model; min.size = 1; data = vec; rounding = 3; method <- "t-test";

  # Collect the tables from all factors and levels here
  collected.table <- NULL

  for (fnam in colnames(annotation.df)) { 

    if (verbose) { message(fnam) }

    annotation.vector <- annotation.df[[fnam]]
    names(annotation.vector) <- rownames(annotation.df)

    # quantify association to each response for the continuous variable
    responses.per.cont <- continuous.responses(annotation.vector, model, method = method, min.size = min.size, data = data)
    responses.per.cont$annotation <- rep(fnam, nrow(responses.per.cont))

    collected.table <- rbind(collected.table, responses.per.cont)

  }

  if (nrow(collected.table) > 0) {

    collected.table$qvalue <- rep(NA, nrow(collected.table))
    nainds <- is.na(collected.table$pvalue)
    if (sum(!nainds) > 100) {
      qv <- qvalue(collected.table$pvalue[!nainds], pi0.method = "bootstrap")
      if (("qvalues" %in% names(qv)) && sum(!nainds) > 0) {
        collected.table$qvalue[!nainds] <- qv$qvalues
      } else {
        warning("Too few values for qvalue estimation, skipped")
        collected.table$qvalue[!nainds] <- rep(NA, sum(!nainds))
      }
    } 

    if (sum(nainds) > 0) {
      warning("Removing entries where p/q values could not be calculated due to small sample size and/or missing values")
      collected.table <- collected.table[!nainds,]
    }

    # Order by pvalues
    collected.table <- collected.table[order(collected.table$pvalue),]

    # Filtering based on qvalues, if qvalues are available
    if (any(!is.na(collected.table$qvalue)) && !is.null(qth)) {
      collected.table <- collected.table[collected.table$qvalue < qth, ]
    } 
  } else {
    collected.table <- NULL
  }

  if (length(collected.table) == 0) { collected.table <- NULL} 


  if (!is.null(rounding)) {
    collected.table$qvalue <- round(collected.table$qvalue, rounding)
    collected.table$pvalue <- round(collected.table$pvalue, rounding)
    collected.table$mean.difference <- round(collected.table$mean.difference, rounding)
  }  

  collected.table

}
