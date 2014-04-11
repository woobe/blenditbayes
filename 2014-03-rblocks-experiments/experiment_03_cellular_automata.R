## =============================================================================
## The #rBlocks Experiements - Cellular Automata
## =============================================================================

## Load packages
library(rblocks)
library(RColorBrewer)


## =============================================================================
## Core Parameters
## =============================================================================

side <- 50      # side - side of the game of life arena (matrix)
steps <- 170     # steps - number of animation steps
skips <- 20     # skips - initial frames to be dropped (burn out)
set.seed(3)  # Set seed for reproducible results


## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## Original Game of Life Arena Codes 
## http://www.r-bloggers.com/fast-conways-game-of-life-in-r/
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# the sideXside matrix, filled up with binomially
# distributed individuals
X <- matrix(nrow=side, ncol=side)
X[] <- rbinom(side^2,1,0.4)

# array that stores all of the simulation steps
# (so that it can be exported as a gif)
storage <- array(0, c(side, side, steps))

# the simulation                                             
for (i in 1:steps)
{
  # make the shifted copies of the original array
  allW = cbind( rep(0,side) , X[,-side] )
  allNW = rbind(rep(0,side),cbind(rep(0,side-1),X[-side,-side]))
  allN = rbind(rep(0,side),X[-side,])
  allNE = rbind(rep(0,side),cbind(X[-side,-1],rep(0,side-1)))
  allE = cbind(X[,-1],rep(0,side))
  allSE = rbind(cbind(X[-1,-1],rep(0,side-1)),rep(0,side))
  allS = rbind(X[-1,],rep(0,side))
  allSW = rbind(cbind(rep(0,side-1),X[-1,-side]),rep(0,side))
  
  # summation of the matrices
  X2 <- allW + allNW + allN + allNE + allE + allSE + allS + allSW
  
  # the rules of GoL are applied using logical subscripting
  X3 <- X
  X3[X==0 & X2==3] <- 1
  X3[X==1 & X2<2] <- 0
  X3[X==1 & X2>3] <- 0
  X <- X3
  
  # each simulation step is stored
  storage[,,i] <- X2
  # note that I am storing the array of Ni values -
  # - this is in order to make the animation prettier
}

storage <- storage/max(storage) # scaling the results
# to a 0-1 scale

## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## End of Original Codes
## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


## =============================================================================
## Create Animated GIF using 'rBlocks' and 'animation'
## =============================================================================

## unique values and colours
value_unique <- sort(unique(matrix(storage, ncol=1)), decreasing = F)
colour_unique <- colorRampPalette(brewer.pal(9,"Greys"))(length(value_unique)+1)[-1]

## Create GIF (500 x 500)
library(animation)

saveGIF({
  
  for (n_frame in (skips+1):steps){     ## drop the first n frames (burn out)
    
    ## Extract from storage
    a <- storage[, , n_frame]
    block_a <- make_block(a)
    
    ## Update Colours
    for (n in 1:length(value_unique)) {
      block_a[which(a[,] == value_unique[n])] <- colour_unique[n]
    }
    
    ## Display
    display(block_a)
    
  }
}, movie.name = "game_of_life_arena.gif", interval = 0.1, nmax = steps, ani.width = 500, 
ani.height = 500)

