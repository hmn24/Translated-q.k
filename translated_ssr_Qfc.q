//-- ssr_sub_fn is to allow ssr to be able to perform "bracketed" regex replacement such as ssr["asdfdasdf"; "d[ab]"; "12"]
/- If n = count x, it means there's no "[" found, same for count[x] = x?"]" too
ssr_sub_fn: {n: x?"["; 
            $[n= count x;
                n; 
                n+ .z.s $[count[x] = p: x?"]"; '"unmatched ]"; p]_ x: (n+ 2+ "^"= x[n+1])_ x
            ]
            };

//-- The ssr function in q format
/- (0, ssr_sub_fn[y, ""]) +/: x ss y    -->    This is meant to create the proper "cutting indices" for the string
/-  1+ 2* til floor 0.5* count x    -->    This is meant to create indices that goes in odd sequence
/- Why odd sequence? Cause the cutting indices are generated at the odd indices of newly cut x under "raze[0; (0, ssr_sub_fn[y, ""]) +/: x ss y]_ x"
/- (count 1, `long$()) 
/- (count 2, ,1)
/- (count 3, ,1)
/- (count 4, 1 3)
/- (count 5, 1 3)
/- (count 6, 1 3 5) so on and forth 
/- ssr is nothing more than a functional apply @[x;y;z]
ssr: {x: raze[0; (0, ssr_sub_fn[y, ""]) +/: x ss y]_ x;
    raze @[x; 1+ 2* til floor 0.5* count x; $[100h> type z; :[;z]; z]]
    }

.Q.fc: {$[1<n:count[y] & system "s"; raze x peach (n;0N)#y; x y]}

.Q.opt: {[o] x:: $[count i:where o like "-[^0-9]*"; i[0]#o; o]; ((`$ 1_ first@) each o)! 1_' o:i_o}

.Q.def: {x, {$[0h> type x; first; ::] type[first x]$y}'[key[y]#x; y]}
