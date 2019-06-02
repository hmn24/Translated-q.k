//-- ssr_sub_fn is to allow ssr to be able to perform [123] either-or replacement
/- If n = count x, it means there's no "[" found, same for count[x] = x?"]" too
ssr_sub_fn: {n: x?"["; 
                $[n= count x;
                    n; 
                    (n+ .z.s $[count[x] = p: x?"]"; '"unmatched ]"; p] _ x: (n+ 2+ "^"= x[n+1])_x
                ]
            };

//-- The ssr function in q format
/- (0, ssr_sub_fn[y, ""]) +/: x ss y    -->    This is meant to create the proper "cutting indices" for the string
/-  1+ 2* til floor 0.5* count x    -->    This is meant to create indices that goes in odd sequence
/- Why odd sequence? Cause the cutting indices are generated at the odd indices of newly cut x under "x: raze[0; (0, ssr_sub_fn[y, ""]) +/: x ss y]_ x"
/- (count 1, `long$()) 
/- (count 2, ,1)
/- (count 3, ,1)
/- (count 4, 1 3)
/- (count 5, 1 3)
/- (count 6, 1 3 5) so on and forth 
ssr: {raze @[x; 1+ 2* til floor 0.5* count x: raze[0; (0, ssr_sub_fn[y, ""]) +/: x ss y]_ x; $[100h> type z; :[;z]; z]]}
