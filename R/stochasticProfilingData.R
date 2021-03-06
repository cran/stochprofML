stochasticProfilingData <-
function() {

   cat("This function generates synthetic data from the stochastic profiling model.\nIn the following, you are asked to specify all settings. By pressing 'enter',\nyou choose the default option.\n\n")

   model.default <- 1
   TY.default <- 2
   k.default <- 100
   n.default <- 10
   m.default <- 1

   options(warn=-2)

   # choose model
   cat("---------\n")
   continue <- F
   this.text <- paste("Please choose the model you would like to generate data from:\n 1: LN-LN\n 2: rLN-LN\n 3: EXP-LN\n(default: ",model.default,")\n",sep="")
   while (!continue) {
      model <- readline(this.text)
      if (model=="") { model <- model.default }
      if (model=="LN-LN") { model <- 1 }
      else if (model=="rLN-LN") { model <- 2 }
      else if (model=="EXP-LN") { model <- 3 }
      if (model %in% c(1,2,3)) {
         continue <- T
      }
      else {
         this.text <- "Invalid choice. Please choose 1, 2 or 3 oder simply press 'enter' for the\ndefault option.\n"
      }
   }

   # choose TY
   cat("---------\n")
   continue <- F
   this.text <- paste("Please enter the number of different populations you would like to consider:\n(default: ",TY.default,")\n",sep="")
   while (!continue) {
      TY <- readline(this.text)
      if (TY=="") { TY <- TY.default }
      if (is.na(as.numeric(TY))) {
         this.text <- "Invalid choice. Please enter a finite natural number.\n"
      }
      else {
         TY <- as.numeric(TY)
         if (TY %in% 1:50) {
            continue <- T
         }
         else if (TY>50) {
            this.text <- "More than 50 populations are theoretically possible but not meaningful.\nPlease choose a smaller number.\n"
         }
         else {
            this.text <- "Invalid choice. Please enter a natural number.\n"
         }
      }
   }

   # choose k
   cat("---------\n")
   continue <- F
   this.text <- paste("Please enter the number of stochastic profiling observations you wish to generate:\n(default: ",k.default,")\n",sep="")
   while (!continue) {
      k <- readline(this.text)
      if (k=="") { k <- k.default }
      if (is.na(as.numeric(k))) {
         this.text <- "Invalid choice. Please enter a finite natural number.\n"
      }
      else {
         k <- as.numeric(k)
         if ((round(k)==k) && ((k>0) && (k<Inf))) {
            continue <- T
         }
         else {
            this.text <- "Invalid choice. Please enter a finite natural number.\n"
         }
      }
   }

   # choose n
   cat("---------\n")
   continue <- F
   this.text <- "Next we enter the number of cells that should enter each observation, which case do you want:\n 1: all observations should contain the same number of cells, or \n 2: each observation contains a different number of cells \n(default: 1).\n"
   while (!continue) {
       number <- readline(this.text)
       if (number=="") {
           number <- 1
           continue = T
       }
       if (number %in% 1:2) {
           continue = T
       }
       else {
           this.text <- "Invalid choice. Please try again.\n"
       }
   }

   if(number == 2){
   cat("---------\n")
   continue <- F
   this.text <- "How would you like to input the number of cells for each observation?\n 1: enter manually\n 2: read from file\n 3: enter the name of a variable\n(default: 1).\n"
   while (!continue) {
       input_n <- readline(this.text)
       if (input_n=="") {
           input_n <- 1
       }
       if (input_n %in% 1:3) {
           continue <- T
       }
       else {
           this.text <- "Invalid choice. Please try again.\n"
       }
   }
   if(input_n == 1){
       cat("---------\n")
       continue <- F
       this.text <- paste("Please enter the number of cells that should enter each observation:\nseparated by either commas or spaces,\ne.g. in case of five observations\n5, 10, 2, 10, 5\n or\n5 10 2 10 5.\n(default: ",n.default,")\n",sep="")

       while (!continue) {
           n <- readline(this.text)
           if (n=="") { n <- n.default }

           else{
               # try comma separation
               n.tmp <- suppressWarnings(as.numeric(unlist(strsplit(n, ","))))
               # try space separation
               if (any(is.na(n.tmp))) {
                   n <- suppressWarnings(as.numeric(unlist(strsplit(n, " "))))
               }
               else {
                   n <- n.tmp
               }
               if (any(is.na(n)) || (round(n)!=n)) {
                   this.text <- "Invalid choice. Please enter only finite natural numbers. Please try again.\n"
               }
               else {
                   if (any(abs(n)==Inf)) {
                       this.text <- "There are a infinite values. Please enter only finite natural numbers.\n"
                   }
                   else if (any(n<=0)) {
                       this.text <- "There are non-positive values. Please enter only finite natural numbers.\n"
                   }
                   else {
                       if (length(n) != 1 && length(n)!=k) {
                           this.text <- "The length of n does not agree with the number of\nobservations in the data. Please try again.\n"
                       }
                       else {
                           continue <- T
                       }
                   }
               }
           }
       }


   } else if (input_n == 2){
       # choose filename
       cat("---------\n")
       continue_alg <- F

       while(!continue_alg){
       continue <- F
       cat("The file should contain a data matrix with a one dimensional vector standing for the observations. Fields have to be separated by tabs or white\nspaces, but not by commas. If necessary, please delete the commas in the\ntext file using the \'replace all\' function of your text editor.\n")

       cat("\nPlease enter a valid path and filename, either a full path, e.g.\n",getwd(),"/mydata.txt\nor just a file name, e.g.\nmydata.txt.\nThe current directory is\n",getwd(),".\n",sep="")
       this.text <- ""


       while (!continue) {
           path <- readline(this.text)

           if (!file.exists(path)) {
               this.text <- "This file does not exist. Please try again.\n"
           }
           else {
               continue <- T
           }
       }

       continue <- F
       this.text <- "Does the file contains a column name? Please enter 'yes' or 'no'.\n"
       while (!continue) {
           cnames <- readline(this.text)
           if ((cnames=="") || (!(cnames %in% c("yes","no")))) {
               this.text <- "Please enter 'yes' or 'no'.\n"
           }
           else {
               continue <- T
           }
       }

       continue <- F
       this.text <- "Does the file contain row names? Please enter 'yes' or 'no'.\n"
       while (!continue) {
           rnames <- readline(this.text)
           if ((rnames=="") || (!(rnames %in% c("yes","no")))) {
               this.text <- "Please enter 'yes' or 'no'.\n"
           }
           else {
               continue <- T
           }
       }

       continue <- F
       this.text <- "Do the rows or the columns stand for the different observations?\n 1: rows\n 2: columns.\n"
       while (!continue) {
           dimn <- readline(this.text)
           if ((dimn=="") || (!(dimn %in% 1:2))) {
               this.text <- "Invalid choice. Please try again.\n"
           }
           else {
               continue <- T
           }
       }

       # read file

       if (rnames=="yes") {
          n <- read.table(file=path,header=(cnames=="yes"),row.names=1)
       }
       else {
           n <- read.table(file=path,header=(cnames=="yes"))
       }
       if (dimn==2) {
           n <- t(n)
       }


       if (any(is.na(n)) || any(round(n)!=n)) {
           cat("Invalid choice. Please enter finite natural numbers. Please try again.\n\n\n")
       } else {
           if (any(abs(n)==Inf)) {
               cat("There are infinite values. Please enter only finite natural numbers.\n\n\n")
           }
           else if (any(n<=0)) {
               cat("There are non-positive values. Please enter only finite natural numbers.\n\n\n")
               }
           else {
               if (length(n) != 1 && length(n)!=k) {
                   cat("The number of observations does not agree with the number of\nobservations of the data. Please try again.\n\n\n")
                }
               else {
                   continue_alg <- T
               }
           }
       }
       }



       } else if(input_n == 3){
       cat("---------\n")
       continue_alg <- F

       while(!continue_alg){
       continue <- F

       this.text <- "The variable should be a matrix with one dimension standing for the observations. Please enter the name of the variable.\n"
       while (!continue) {
           n_variablename <- readline(this.text)
           n_variable <- try(eval(parse(text=n_variablename)),silent=T)

           if (class(n_variable)=="try-error") {
               this.text <- "This variable does not exist. Please try again.\n"
           }
           else {
               continue <- T
               if (is.data.frame(n_variable)) {
                   cat("Data frame has been converted to matrix.\n")
                   n_variable <- as.matrix(n_variable)
               }
               if (!is.matrix(n_variable)) {
                   cat(paste("This is not a matrix. The variable is converted to a matrix with 1 column\nand ",length(n_variable)," rows.\n\n",sep=""))
                   n_variable <- matrix(n_variable,ncol=1)
               }
           }
       }

       continue <- F
       this.text <- "Do the rows or the columns stand for the different observations?\n 1: rows\n 2: columns.\n"
       while (!continue) {
           dimn <- readline(this.text)
           if ((dimn=="") || (!(dimn %in% 1:2))) {
               this.text <- "Invalid choice. Please try again.\n"
           }
           else {
               continue <- T
               if (dimn==1) {
                   n <- n_variable
               }
               else {
                   n<- t(n_variable)
               }
           }
       }
       if (is.null(colnames(n))) {
           n_cnames <- "no"
       }
       else {
           n_cnames <- "yes"
       }
       n_rnames <- "no"


       if (any(is.na(n)) || any(round(n)!=n)) {
           cat("Invalid choice. Please enter finite natural numbers. Please try again.\n\n\n")
       } else {
           if (any(abs(n)==Inf)) {
               cat("There are infinite values. Please enter only finite natural numbers.\n\n\n")
           }
           else if (any(n<=0)) {
               cat("There are non-positive values. Please enter only finite natural numbers.\n\n\n")
           }
           else {
               if (length(n) != 1 && length(n)!=k) {
                   cat("The number of observations does not agree with the number of\nobservations of the data. Please try again.\n\n\n")
               }
               else {
                   continue_alg <- T
               }
           }
       }


       }

       }
   }


   if(number == 1){
   cat("---------\n")
   continue <- F
   this.text <- paste("Please enter the number of cells that should enter each sample:\n(default: ",n.default,")\n",sep="")

   while (!continue) {
       n <- readline(this.text)
       if (n=="") { n <- n.default }

       else{
           # try comma separation
           n.tmp <- suppressWarnings(as.numeric(unlist(strsplit(n, ","))))
           # try space separation
           if (any(is.na(n.tmp))) {
               n <- suppressWarnings(as.numeric(unlist(strsplit(n, " "))))
           }
           else {
               n <- n.tmp
           }
           if (any(is.na(n))) {
               this.text <- "Invalid choice. Please enter a finite natural number. Please try again.\n"
           }
           else {
               if (any(abs(n)==Inf)) {
                   this.text <- "There is a infinite value. Please enter a finite natural number.\n"
               }
               else if (any(n<=0)) {
                   this.text <- "There is a non-positive value. Please enter a finite natural number.\n"
               }
               else {
                   if (length(n) != 1) {
                       this.text <- "Invalid choice. Please enter a finite natural number. Please try again.\n"
                   }
                   else {
                       continue <- T
                   }
               }
           }

       }

   }
   }

   # choose m
   cat("---------\n")
   continue <- F
   this.text <- paste("Please enter the number of co-expressed genes you would like to collect\nin one cluster\n(default: ",m.default,")\n",sep="")
   while (!continue) {
      m <- readline(this.text)
      if (m=="") { m <- m.default }
      if (is.na(as.numeric(m))) {
         this.text <- "Invalid choice. Please enter a finite natural number.\n"
      }
      else {
         m <- as.numeric(m)
         if ((round(m)==m) && ((m>0) && (m<Inf))) {
            continue <- T
         }
         else {
            this.text <- "Invalid choice. Please enter a finite natural number.\n"
         }
      }
   }

   # probabilities
   if (TY>1) {
      cat("---------\n")
      continue <- F
      add.text <- ""
      if (model==3) {
         add.text <- "\nNote that the last population is the one which follows the exponential\ndistribution and all others follow the lognormal distribution."
      }
      add.text2 <- ""
      if (((model %in% 1:2) && (TY>1)) || ((model ==3) && (TY>2))) {
         add.text2 <- "\nIt is recommended to choose the order of the populations such that\n(for the first gene, if there is more than one)\nlog-mean for population 1 >= log-mean for population 2 >= ..."
      }
      p.example <- runif(TY)
      p.example <- round(p.example/sum(p.example),2)
      p.string.comma <- p.example[1]
      p.string.space <- p.example[1]
      for (j in 2:TY) {
          p.string.comma <- paste(p.string.comma,p.example[j],sep=", ")
          p.string.space <- paste(p.string.space,p.example[j],sep=" ")
      }
      this.text <- paste("Please enter the probabilities for each of the ",TY," populations, e.g. type\n",p.string.comma,"\n or\n",p.string.space,".",add.text,add.text2,"\n",sep="")
      cat(this.text)
      this.text <- ""
      while (!continue) {
         p <- readline(this.text)
         if (p=="") {
            this.text <- "Please enter some numbers as there is no default value.\n"
         }
         else {
            # try comma separation
            p.tmp <- as.numeric(unlist(strsplit(p, ",")))
            # try space separation
            if (is.na(p.tmp)) {
               p <- as.numeric(unlist(strsplit(p, " ")))
            }
            else {
               p <- p.tmp
            }
            if (any(is.na(p))) {
               this.text <- "This is not a numeric vector. Please try again.\n"
            }
            else if (length(p)!=TY) {
               this.text <- paste("The vector of probabilities has to be of length ",TY,". Please try again.\n",sep="")
            }
            else if (any(p<0)) {
               this.text <- "All probabilities have to be non-negative. Please try again.\n"
            }
            else if (sum(p)!=1){
               this.text <- "The probabilities have to sum up to one. Please try again.\n"
            }
            else {
               continue <- T
            }
         }
      }
   }
   else {
      p <- 1
   }

   # log-means
   if ((model %in% 1:2) || ((model==3) && (TY>1))) {
      cat("---------\n")
      mu.list <- list()
      if (model %in% 1:2) {
         mu.example <- runif(TY,-3,2)
      }
      else {
         mu.example <- runif(TY-1,-3,2)
      }
      mu.example <- round(mu.example[order(mu.example,decreasing=T)],2)
      mu.string.comma <- mu.example[1]
      if (length(mu.example)>1) {
         for (j in 2:length(mu.example)) {
            mu.string.comma <- paste(mu.string.comma,mu.example[j],sep=", ")
         }
      }

      for (g in 1:m) {
         continue <- F
         add.text <- ""
         if (m>1) {
            add.text <- paste("\nFor gene number ",g,":\n",sep="")
         }
         if (g==1) {
            if (model %in% 1:2) {
               this.text <- paste("Please enter the log-means for each of the ",TY," populations, e.g. type\n",mu.string.comma,".\n",add.text,sep="")
            }
            else {
               this.text <- paste("Please enter the log-means for each of the ",TY-1," lognormal populations, e.g. type\n",mu.string.comma,"\nfor overall ",TY," populations.\n",add.text,sep="")
            }
         }
         else {
            this.text <- add.text
         }

         while (!continue) {
            mu <- readline(this.text)

            if (mu=="") {
               this.text <- "Please enter some numbers as there is no default value.\n"
            }
            else {
               # try comma separation
               mu.tmp <- as.numeric(unlist(strsplit(mu, ",")))
               # try space separation
               if (is.na(mu.tmp)) {
                  mu <- as.numeric(unlist(strsplit(mu, " ")))
               }
               else {
                  mu <- mu.tmp
               }
               if (any(is.na(mu))) {
                  this.text <- "This is not a numeric vector. Please try again.\n"
               }
               else {
                  if ((model %in% 1:2) && (length(mu)!=TY)) {
                     this.text <- paste("The vector of log-means has to be of length ",TY,". Please try again.\n",sep="")
                  }
                  else if ((model==3) && (length(mu)!=TY-1)) {
                     this.text <- paste("The vector of log-means has to be of length ",TY-1,". Please try again.\n",sep="")
                  }
                  else if (any(abs(mu)==Inf)) {
                     this.text <- paste("There are infinite values. Please choose finite ones.\n")
                  }
                  else {
                     continue <- T
                  }
               }
            }
         }
         mu.list[[g]] <- mu
      }
   }

   # log-sds
   if ((model %in% 1:2) || ((model==3) && (TY>1))) {
      cat("---------\n")
      if (model==1) {
         sigma.example <- runif(1,0,0.4)
      }
      else if (model==2) {
         sigma.example <- runif(TY,0,0.4)
      }
      else {
         sigma.example <- runif(TY-1,0,0.4)
      }
      sigma.example <- round(sigma.example,2)
      sigma.string.comma <- sigma.example[1]
      if (length(sigma.example)>1) {
         for (j in 2:length(sigma.example)) {
            sigma.string.comma <- paste(sigma.string.comma,sigma.example[j],sep=", ")
         }
      }

      continue <- F

      if (model==1) {
         this.text <- paste("Please enter the log-standard deviation, which is the same for all\npopulations, i.e. type e.g.\n",sigma.string.comma,"\nirrespectively of the number of populations.\n",sep="")
      }
      else if (model==2) {
         this.text <- paste("Please enter the log-standard deviations for each of the ",TY," populations,\ne.g. type\n",sigma.string.comma,"\nfor ",TY," populations.\n",sep="")
      }
      else if (model==3) {
         this.text <- paste("Please enter the log-standard deviations for each of the ",TY-1," lognormal\npopulations, e.g. type\n",sigma.string.comma,"\nfor overall ",TY," populations.\n",sep="")
      }

      while (!continue) {
         sigma <- readline(this.text)

         if (sigma=="") {
            this.text <- "Please enter some numbers as there is no default value.\n"
         }
         else {
            # try comma separation
            sigma.tmp <- as.numeric(unlist(strsplit(sigma, ",")))
            # try space separation
            if (any(is.na(sigma.tmp))) {
               sigma <- as.numeric(unlist(strsplit(sigma, " ")))
            }
            else {
               sigma <- sigma.tmp
            }
            if (is.na(sigma)) {
               this.text <- "This is not a numeric vector. Please try again.\n"
            }
            else {
               if ((model==1) && (length(sigma)!=1)) {
                  this.text <- paste("The vector of log-standard deviations has to be of length one.\nPlease try again.",sep="")
               }
               else if ((model==2) && (length(sigma)!=TY)) {
                  this.text <- paste("The vector of log-standard deviations has to be of length ",TY,".\nPlease try again.",sep="")
               }
               else if ((model==3) && (length(sigma)!=TY-1)) {
                  this.text <- paste("The vector of log-standard deviations has to be of length ",TY-1,".\nPlease try again.",sep="")
               }
               else if (any(sigma<=0)) {
                  this.text <- paste("There are non-positive values. Please choose positive ones.\n")
               }
               else if (any(abs(sigma)==Inf)) {
                  this.text <- paste("There are infinite values. Please choose finite ones.\n")
               }
               else {
                  continue <- T
               }
            }
         }
      }
   }

   # lambda
   if (model==3) {
      cat("---------\n")
      lambda.list <- list()
      lambda.example <- round(runif(1,0.5,10),1)

      for (g in 1:m) {
         continue <- F
         add.text <- ""
         if (m>1) {
            add.text <- paste("\nFor gene number ",g,":\n",sep="")
         }
         if (g==1) {
            this.text <- paste("Please enter the rate of the exponential distribution for the exponential\npopulation, e.g. type\n",lambda.example,".\n",add.text,sep="")
         }
         else {
            this.text <- add.text
         }

         while (!continue) {
            lambda <- readline(this.text)

            if (lambda=="") {
               this.text <- "Please enter some number as there is no default value.\n"
            }
            else {
               # try comma separation
               lambda.tmp <- as.numeric(unlist(strsplit(lambda, ",")))
               # try space separation
               if (any(is.na(lambda.tmp))) {
                  lambda <- as.numeric(unlist(strsplit(lambda, " ")))
               }
               else {
                  lambda <- lambda.tmp
               }
               if (is.na(lambda)) {
                  this.text <- "This is not a numeric vector. Please try again.\n"
               }
               else {
                  if (length(lambda)!=1) {
                     this.text <- paste("The vector of lambda values has to be of length one. Please try again.\n",sep="")
                  }
                  else if (lambda <= 0) {
                     this.text <- paste("lambda has to be positive. Please try again.\n",sep="")
                  }
                  else if (abs(lambda)==Inf) {
                     this.text <- paste("lambda is infinite. Please choose a finite value.\n")
                  }
                  else {
                     continue <- T
                  }
               }
            }
         }
         lambda.list[[g]] <- lambda
      }
   }

   # choose filename
   cat("---------\n")
   continue <- F
   this.text <- "Would you like to write the generated dataset to a file? (Be careful not to\noverwrite any existing file!) Please type 'yes' or 'no'.\n"
   while (!continue) {
      writetofile <- readline(this.text)
      if (writetofile=="no") {
         continue <- T
      }
      else if (writetofile=="yes") {
         continue <- T
         new.text <- paste("Please enter a valid path and filename, either a full path, e.g.\n",getwd(),"/mydata.txt\nor just a file name, e.g.\nmydata.txt.\nThe current directory is\n",getwd(),".\n",sep="")
         cat(new.text)
         new.text <- ""
         continue2 <- F
         while (!continue2) {
            path <- readline(new.text)
            if (!file.create(path)) {
               new.text <- "Invalid path. Please try again.\n"
            }
            else {
               continue2 <- T
            }
         }
      }
      else {
         this.text <- "Please type 'yes' or 'no'.\n"
      }
   }

   options(warn=0)

   par(ask=T)

   # Prompting finished!! Now generate data.


   if(length(n) == 1){
      N.matrix <- t(rmultinom(n=k, size=n, prob=p))
      } else {
      N.matrix <- matrix(0, nrow=k, ncol=length(p))
      for(j in 1:k){
         N.matrix[j,] <- t(rmultinom(n=1, size=n[j], prob=p))
      }
   }


   dataset <- matrix(NA,nrow=k,ncol=m)
   for (g in 1:m) {
       if (model==1) {
          set.model.functions("LN-LN")
          dataset[,g] <- r.sum.of.mixtures.LNLN(k,n,p,mu.list[[g]],rep(sigma,TY), N.matrix)
          x <- seq(round(min(dataset[,g])),round(max(dataset[,g])),(round(max(dataset[,g]))-round(min(dataset[,g])))/500)
          if(number == 1){
          y <- d.sum.of.mixtures.LNLN(x,n,p,mu.list[[g]],rep(sigma,TY),logdens=F)
          xlabel <- "Sum of mixtures of lognormals"
          }
          else{
          y <- mix.d.sum.of.mixtures.LNLN(x, n, p,mu.list[[g]], rep(sigma,TY))
          xlabel <- "Mixed density of mixtures of lognormals"
          }
       }
       else if (model==2) {
          set.model.functions("rLN-LN")
          dataset[,g] <- r.sum.of.mixtures.rLNLN(k,n,p,mu.list[[g]],sigma, N.matrix)
          x <- seq(round(min(dataset[,g])),round(max(dataset[,g])),(round(max(dataset[,g]))-round(min(dataset[,g])))/500)
          if(number == 1){
              y <- d.sum.of.mixtures.rLNLN(x,n,p,mu.list[[g]],sigma,logdens=F)
              xlabel <- "Sum of mixtures of lognormals"
          }
          else{
              y <- mix.d.sum.of.mixtures.rLNLN(x, n, p,mu.list[[g]], sigma)
              xlabel <- "Mixed density of mixtures of lognormals"
          }
        }
        else if (model==3) {
          set.model.functions("EXP-LN")
          dataset[,g] <- r.sum.of.mixtures.EXPLN(k,n,p,mu.list[[g]],sigma,lambda.list[[g]], N.matrix)
          x <- seq(round(min(dataset[,g])),round(max(dataset[,g])),(round(max(dataset[,g]))-round(min(dataset[,g])))/500)
          if(number == 1){
              y <- d.sum.of.mixtures.EXPLN(x,n,p,mu.list[[g]],sigma,lambda.list[[g]],logdens=F)
              xlabel <- "Sum of mixtures of lognormals and exponentials"
          }
          else{
              y <- mix.d.sum.of.mixtures.EXPLN(x, n, p,mu.list[[g]], sigma,lambda.list[[g]])
              xlabel <- "Mixed density of mixtures of lognormals and exponentials"
          }
       }
       hist(dataset[,g],main=paste("Gene",g),breaks=50,xlab=xlabel,ylab="Density",freq=F,col="lightgrey")
       lines(x,y,col="blue",lwd=3)
       if (number == 1){
       legend("topright",legend=c("data generating pdf"),col=c("blue"),lty=1,lwd=3)
       }
       else{
           legend("topright",legend=c("data generating mixed pdf"),col=c("blue"),lty=1,lwd=3)
       }
   }
   colnames(dataset) <- paste("gene",1:m)
   rownames(dataset) <- paste("observation",1:k)

   par(ask=F)

   # Print result.
   if (k>50) {
      cat("\n\nThe dataset has been generated. The first 50 observations are:\n\n")
   }
   else {
      cat("\n\nThe dataset has been generated:\n\n")
   }
   print(dataset[1:min(50,nrow(dataset)),,drop=F])

   if (writetofile=="yes") {
      write.table(dataset,path,col.names=T,row.names=F)
      cat(paste("\n\nThe full dataset has been written to\n",path,".\nIt is also stored in the .Last.value variable.\n\n",sep=""))
   }
   else {
      cat("\n\nThe full dataset is stored in the .Last.value variable.\n\n")
   }

   return(invisible(dataset))
}
