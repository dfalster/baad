fillDerivedVariables <- function(x){
  
  x <- within(x, {
    c.d <- as.numeric(c.d)
    m.rt <- as.numeric(m.rt)
    a.cp <- as.numeric(a.cp)
    d.cr <- as.numeric(d.cr)
    
    # Missing leaf area when leaf mass and LMA are OK.
    ii <- is.na(a.lf) & !is.na(m.lf) & !is.na(ma.ilf)
    a.lf[ii] <- m.lf[ii] / ma.ilf[ii] 
    
    # Height to crown base if tree height and crown depth are OK.
    ii <- is.na(h.c) & !is.na(c.d) & !is.na(h.t)
    h.c[ii] <- h.t[ii] - c.d[ii]
    
    # Stem area  / DBH at breast height or base.
    ii <- is.na(a.stbh) & !is.na(d.bh)
    a.stbh[ii] <- (pi/4)*d.bh[ii]^2
    
    ii <- is.na(a.stba) & !is.na(d.ba)
    a.stba[ii] <- (pi/4)*d.ba[ii]^2
    
    # Again, the other way around.
    ii <- !is.na(a.stbh) & is.na(d.bh)
    d.bh[ii] <- sqrt(a.stbh[ii] / (pi/4))
    
    ii <- !is.na(a.stba) & is.na(d.ba)
    d.ba[ii] <- sqrt(a.stba[ii] / (pi/4))
    
    # Stem mass
    ii <- is.na(m.st) & !is.na(m.ss) & !is.na(m.sh) & 
      !is.na(m.sb)
    m.st[ii] <- m.ss[ii] + m.sh[ii] + m.sb[ii]
    
    # total aboveground mass.
    ii <- is.na(m.so) & !is.na(m.lf) & !is.na(m.st)
    m.so[ii] <- m.lf[ii] + m.st[ii]
    
    # total root mass
    ii <- is.na(m.rt) & !is.na(m.rf) & !is.na(m.rc)
    m.rt[ii] <- m.rf[ii] + m.rc[ii]
    
    # Total mass.
    ii <- is.na(m.to) & !is.na(m.rt) & !is.na(m.so)
    m.to[ii] <- m.rt[ii] + m.so[ii]
    
    # crown width
    ii <- is.na(d.cr) & !is.na(a.cp)
    d.cr[ii] <- sqrt(a.cp[ii]/(pi/4))
    
    # crown area
    ii <- !is.na(d.cr) & is.na(a.cp)
    a.cp[ii] <- (pi/4)*d.cr[ii]^2
  })
  
return(x)  
}