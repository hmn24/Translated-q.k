.Q.s: {
    $[(::) ~ x; 
        ""; 
        [
        res: @[.Q.S[system["c"] - 2 1; 0]; x; ::]; // Protected evaluation here
        ` sv $[10h = type res; raze .Q.s1 x; res]
        ]
    ]
 };

.Q.t0: {
    $[x > count y; (count[first y] #' " -"),y; y]
 };

// Padding mechanism
.Q.tab: {
    " " sv' (x* (or/) count''[y]) $/: y
 };

// Use HTTP size from \C
.Q.sw: {
    floor[.5* last system "C"] sublist x
 };

.Q.s2: {
    $[99h = t: type x;
            (or/[count each x] $ x: .Q.t0[count d; x]) ,' "| " ,/: .Q.t0[count x: .z.s key x] d: .z.s value x;
        98h = t;
            (1#x), enlist[count[first x]#"-"], 1_ x: .Q.tab[1] enlist[string key x], $[count first r: .z.s each value x: .Q.sw flip x; flip r; ()]; // Form the pretty looking tables here 
        not count x;
            ();
        t > 77h;
            .Q.s1 each x;
        t; 
            string x;
        or/[97h < t] or 0h > t: distinct type each x;
            .Q.s1 each x; 
        (1 < count distinct count each x) or $[1=count t; first[t] in 1 4 10h; 0];
            .Q.s1 each x; 
        .Q.tab[1] (.Q.s2 .Q.sw ::) each x
    ]
 };

.Q.S: {
    res: $[t and 77h > t: type z; 
                raze .Q.s1 z;
            99h < t;
                "\n" vs string z;
            [
            n: first[x] - 2* .Q.qt z;
            s: (y+n) < count z;
            sublistRange: (y; n-s);
            .Q.s2[sublistRange sublist z], $[s; enlist ".."; ()]
            ]
        ];
    {$[x < count y; #[x-2;y],".."; y]}'[x 1; res]
 };
