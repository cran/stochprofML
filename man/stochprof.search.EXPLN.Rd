\name{stochprof.search.EXPLN}
\alias{stochprof.search.EXPLN}
\title{
Calculation of the log likelihood function of the EXP-LN model
}
\description{
Calculates the log likelihood function of the parameters of the EXP-LN model for a given dataset at certain parameter values.
}
\usage{
stochprof.search.EXPLN(dataset, n, TY, method = "grid", M = 10,
   par.range = NULL, prev.result = NULL, fix.mu = F, fixed.mu,
   genenames = NULL, print.output = F, use.constraints = F)
}
\arguments{
  \item{dataset}{
matrix which contains the cumulated expression data over all cells in a tissue sample. Columns represent genes, rows represent tissue samples.
}
  \item{n}{
number of cells taken from each tissue sample. This can also be a vector stating how many cells are in each sample separatly
}
  \item{TY}{
number of types of cells that is assumed in the stochastic model
}
  \item{method}{
determines whether a grid search or the Nelder-Mead algorithm should be applied:
If method=="grid", the log likelihood function is simply evaluated at certain parameter values that are randomly drawn. If method=="optim", a Nelder-Mead search starts at a randomly drawn set of parameter values in order to find a local maximum. The resulting locally optimal parameter is stored in the results matrix as one row.
}
  \item{M}{
number of randomly drawn parameter combinations
}
  \item{par.range}{
range from which the parameter values should be randomly drawn. This is a matrix with the number of rows being equal to the number of model parameters. The first columns contains the lower bound, the second column the upper bound. If par.range==NULL, some rather large range is defined.
}
  \item{prev.result}{
can contain results from former calls of this function
}
  \item{fix.mu}{
if TRUE, the log-means are kept fixed in the estimation procedure. Otherwise, they are to be estimated.
}
  \item{fixed.mu}{
vector containing the values to which the log-means should be fixed if fix.mu==T. The order of components is as follows:

(mu_type_1_gene_1, mu_type_1_gene_2, ...,

 mu_type_2_gene_1, mu_type_2_gene_2, ...).

This argument needs to be specified only when fix.mu==T.
}
  \item{genenames}{
names of the genes in the dataset. For genenames==NULL, the genes will simply be enumerated according to the column numbers in the dataset.
}
  \item{print.output}{
if TRUE, interim results of the grid search and numerical optimization are printed into the console throughout the estimation procedure
}
  \item{use.constraints}{
if TRUE, constraints on the individual population densities are applied; see \code{penalty.constraint.EXPLN} for details.
}
}
\details{
The values at which the target function is calculated are randomly drawn from some range specified by "par.range". If method=="grid", the target function is simply evaluated
 at such a randomly drawn parameter vector. If method=="optim", this randomly drawn vector is
 passed to the Nelder-Mead algorithm as a starting value in order to search for a local
 maximum around it.
}
\value{
A matrix with the following entries: Each row corresponds to one parameter combination. All columns but the last one contain the parameter values at which the log likelihood function has been computed. The column names are the parameter names. The last column ("target") is the negative log likelihood function computed at the respective parameter vector. For numerical  reasons, this target value is set to the minimum of 10^7 and the actual value.
}
\references{
"Parameterizing cell-to-cell regulatory heterogeneities via stochastic transcriptional profiles" by Sameer S Bajikar*, Christiane Fuchs*, Andreas Roller, Fabian J Theis^ and Kevin A Janes^: PNAS 2014, 111(5), E626-635 (* joint first authors, ^ joint last authors) <doi:10.1073/pnas.1311647111>

"Pheno-seq - linking visual features and gene expression in 3D cell culture systems" by Stephan M. Tirier, Jeongbin Park, Friedrich Preusser, Lisa Amrhein, Zuguang Gu, Simon Steiger, Jan-Philipp Mallm, Teresa Krieger, Marcel Waschow, Bjoern Eismann, Marta Gut, Ivo G. Gut, Karsten Rippe, Matthias Schlesner, Fabian Theis, Christiane Fuchs, Claudia R. Ball, Hanno Glimm, Roland Eils & Christian Conrad: Sci Rep 9, 12367 (2019) <doi:10.1038/s41598-019-48771-4>
}
\author{
Lisa Amrhein, Christiane Fuchs

Maintainer: Lisa Amrhein <amrheinlisa@gmail.com>
}
\keyword{ maximum likelihood estimation }
\keyword{ stochastic profiling }
