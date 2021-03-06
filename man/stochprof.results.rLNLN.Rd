\name{stochprof.results.rLNLN}
\alias{stochprof.results.rLNLN}
\title{
Evaluation of results from estimation of rLN-LN model
}
\description{
Evaluates the set of results that are passed to this function. That means, it removes entries where the target function is equal to infinity, it removes double entries, it removes unlikely parameter combinations (if there are too many) etc., and it sorts the data. When show.plots==T, the results are graphically displayed.
}
\usage{
stochprof.results.rLNLN(prev.result, TY, show.plots = T, plot.title = "",
   pdf.file, fix.mu = F)
}
\arguments{
  \item{prev.result}{
contains parameter combinations and the respective value of the target function. It is typically the output of 'stochprof.search.rLNLN'.
}
  \item{TY}{
number of types of cells assumed in the model
}
  \item{show.plots}{
if TRUE, the results are plotted. In particular, one plot is produced for each parameter, with the value of the parameter plotted against the value of the target function. This is not exactly the profile log-likelihood function because there is no conditioning on the other parameters being equal to the ML estimate. If the estimation procedure has converged, however, one can recognize the shape of the profile log-likelihood from these plots. A red bar indicates the position of the maximum likelihood estimator.
}
  \item{plot.title}{
title of each plot if show.plots==T
}
  \item{pdf.file}{
plots will be written into this file when this argument is not missing. The file has to include the entire path.
}
  \item{fix.mu}{
if TRUE, the log-mean of the lognormal distributions has been kept fixed. In that case, no plots will be produced for these parameters.
}
}
\value{
Matrix with sorted and evaluated results. The columns are exactly the same as those in 'prev.result'. The first row contains the best estimate.
}
\references{
"Parameterizing cell-to-cell regulatory heterogeneities via stochastic transcriptional profiles" by Sameer S Bajikar*, Christiane Fuchs*, Andreas Roller, Fabian J Theis^ and Kevin A Janes^: PNAS 2014, 111(5), E626-635 (* joint first authors, ^ joint last authors) <doi:10.1073/pnas.1311647111>

"Pheno-seq - linking visual features and gene expression in 3D cell culture systems" by Stephan M. Tirier, Jeongbin Park, Friedrich Preusser, Lisa Amrhein, Zuguang Gu, Simon Steiger, Jan-Philipp Mallm, Teresa Krieger, Marcel Waschow, Bjoern Eismann, Marta Gut, Ivo G. Gut, Karsten Rippe, Matthias Schlesner, Fabian Theis, Christiane Fuchs, Claudia R. Ball, Hanno Glimm, Roland Eils & Christian Conrad: Sci Rep 9, 12367 (2019) <doi:10.1038/s41598-019-48771-4>
}
\author{
Lisa Amrhein, Christiane Fuchs

Maintainer: Lisa Amrhein <amrheinlisa@gmail.com>
}
\keyword{ stochastic profiling }
