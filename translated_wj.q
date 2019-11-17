// indOne is indexOne, indTwo is indexTwo
// wj[w;c;t;(q;(::;`ask);(::;`bid))]
ww1: {[applyFn;qTabFiltered;indOne;indTwo] applyFn @' qTabFiltered @\: indOne + til indTwo - indOne}
ww:{[a;w;f;tTab;z]
    f,:(); // usually `sym`time
    e: flip 1_ z; // remove the qTab and flip the (::;`ask);(::;`bid) portion
    qTab: first z; // get the quote table
    fn: $[count g:-1_ f; (f# qTab) bin @[f# tTab;last f;:;]@; qTab[first f] bin]; // Fn to apply on window to use bin to locate position
    index: $[count g; (g# qTab)? g# tTab; 0] |/: a+ fn each w; // Get indices of qTab falling within tTab 
    tTab ,' flip aggCols! flip ww1[first e; qTab @ aggCols: last e]/'[flip index] // Output of tTab appended with results from ww1, with /' equiv to .'
 }
wj:{[w;f;y;z] ww[0 1;w;f;y;z]}; // Add 0 1 -> 1 is for the ww1 til function 
wj1:{[w;f;y;z] ww[1;w - 1 0;f;y;z]} // Minus 1 0 since bin always take indices from left hand side
