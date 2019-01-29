
* **spec_loop_improve.m:**
*Calls .fig files with non-normalized spectrograms and changes color scaling settings to improve visualization of spindles. :warning: UPDATE: Avoid using. This approach gives wrong results for Non-learning baseline.*
<img src="example_improve.png" width="600">

####  :link: Post-Processing steps for spectrograms: :warning: Outdated. Check next section. 

1. **spec_loop_improve.m:**
*Visualizes spindles.*

2. **spec_skipto_high.m:**
*High frequency statistics.*

3. **colorbar_among_conditions.m:**
*Equal colorbar range among conditions.*

4. **axis_among_conditions.m:**
*Equal Y-axis for traces among conditions.*

5. **same_axis.m:**
*Equal Y-axis and colorbar among brain areas.*