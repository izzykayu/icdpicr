% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cat_trauma.R
\name{cat_trauma}
\alias{cat_trauma}
\title{Categorize trauma by adding AIS and ISS to a dataframe}
\usage{
cat_trauma(df, dx_pre, calc_method = 1, icd10 = TRUE,
  i10_iss_method = "roc_max")
}
\arguments{
\item{df}{A dataframe in wide format containing ICD-9 and/or ICD-10 diagnosis codes with a common column name prefix.
Diagnosis codes should be character strings and may have a decimal or not.}

\item{dx_pre}{Prefix for diagnosis code column names (example: dx1, dx2, etc.)}

\item{calc_method}{ISS calculation method:
Method 1 (default) will assign an ISS of 75 if any AIS is 6.
Method 2 will change any AIS = 6 to 5 and then calculate ISS normally.}

\item{icd10}{A logical value indicating whether ICD-10 codes should be considered or ignored.
If TRUE (default) then ICD-10 codes are handled based on the i10_iss_method argument
and ICD-10 mechanism codes will be included in E-code calculation.
If FALSE then ICD-10 codes are ignored.}

\item{i10_iss_method}{Method for calculating ISS from ICD10-CM codes. Must be one of:
\itemize{
\item "roc_max" (default) Table derived empirically from National Trauma Data Bank using ROC c-stat as objective. Details are included in ICDPIC-R package help documentation.
\item "gem_max" Table derived by mapping ICD 10 to ICD 9 using the CMS general equivalence mapping tables and then to ISS
       using the original ICDPIC table. Mapping conflicts handled by taking the max ISS.
\item "gem_min" Same as "gem_max" except that mapping conflicts are handled by taking the min ISS.
}}
}
\value{
A dataframe identical to the dataframe passed to the function with the following additional variables
         added:
         \itemize{
         \item sev_1-sev_n: AIS severity for diagnosis codes 1..n
         \item issbr_1-issbr_n: ISS body region for diagnosis codes 1..n
         \item mxaisbr1-mxaisbr6: maximum AIS severity for each of the 6 ISS body regions
         \item maxais: maximum AIS severity over all ISS body regions
         \item riss: computed injury severity score
         \item ecode_1-ecode_4: first 4 mechanism/E-Codes (including ICD10 if requested) found in each row of data
         \item mechmaj1-mechmaj4: CDC external cause of injury major mechanism for each E-Code captured
         \item mechmin1-mechmin4: CDC external cause of injury minor mechanism for each E-Code captured
         \item intent1-intent4: intent for each E-Code captured
         \item lowmech: lowest CDC external cause of injury major mechanism for all E-Codes captured
         }
}
\description{
For each observation this function will
\enumerate{
   \item assign a severity (AIS) and ISS body region values to each valid ICD-9-CM or ICD-10-CM trauma code,
   \item add variables for maximum severity of each body region,
   \item calculate ISS
   \item select first 4 e-codes/mechanism codes along with major mechanism, minor mechanism, and intent
}
}
\details{
Data should be in wide format:
\tabular{rrrr}{
ID  \tab  dx1 \tab  dx2 \tab dx3 \cr
31416 \tab   800.1 \tab   959.9 \tab   E910.9 \cr
31417  \tab 800.24  \tab 410.0 \tab
}

Codes for AIS severity:
\itemize{
      \item 1 = Minor
      \item 2 = Moderate
      \item 3 = Serious
      \item 4 = Severe
      \item 5 = Critical
      \item 6 = Unsurvivable
      \item 9 = Unknown
}
}
\examples{
df_in <- read.table(header = T, text = "
ident    dx1     dx2     dx3
31416   800.1   959.9   E910.9
31417   800.24  410.0   NA
")
df_out <- cat_trauma(df_in, "dx")

}

