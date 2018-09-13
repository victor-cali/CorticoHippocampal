-Spectral Granger Causality 
------------------

####  :link: Steps to generate Spectral GC   _(Parametric approach)_: 

1. *MVAR-modelling: Order Selection.* 
 
     **function.m:**

2. *MVAR-modelling: Implementation.*

    **ft_mvaranalysis.m: Fieldtrip implementation of BSMART.**

3. *Frequency domain conversion of MVAR.*

    **ft_freqanalysis.m: Fieldtrip function.**

3. *Computing Spectral Granger Causality.*

    **ft_connectivityanalysis.m: Fieldtrip function.**

5. *Statistical Analysis.*

    **function.m:**

Steps 3 to 4 contained in function: **gc_paper.m**
Steps 1 and 5: Work in progress. 

### :zap: Useful functions: 

* **granger_paper3.m:**  
*Plots spectral granger causality among brain regions for a single condition. * 
<img src="gr.png" width="400">

* **granger_paper4.m:**  
*Plots spectral granger causality among brain regions for all conditions. * 
<img src="gr_all.png" width="500">

:notebook:  Borrowed functions from: Fieldtrip, BSMART. 