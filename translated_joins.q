// wj[w;`sym`time;trade;(quote;(max;`ask);(min;`bid))]

// a: 1st Index
// b: 2nd Index
// e: (max;min)                         -> Given example above
// d: quote (filtered to f)
ww1: {[e;d;a;b] e @' d @\: a + til b - a};

// Following example above:
// a: (0 1) or 1
// w: -2 1 +\: trade.time 
// f: `sym`time 
// g: `sym
// y: trade
// z: (quote;(max;`ask);(min;`bid))
// e: flip ((max;`ask);(min;`bid))      -> Given example above
ww: {[a;w;f;y;z]
    f,:();
    e: flip 1_z;
    z: first z;
    g: -1_f;
    fn: $[count g; (f#z) bin @[f#y;last f;:;] @; z[first f] bin];
    idx: $[count g; (g#z)?g#y; 0] |/: a + fn each w;                // Indices of z falling within y
    y ,' flip f! flip  ww1[first e; z f: last e] .' flip idx        // (/' equiv to .')
 };

wj: {[w;f;y;z] ww[0 1;w;f;y;z]};        // Add 0 1 -> 1 is for the ww1 til function 
wj1: {[w;f;y;z] ww[1;w - 1 0;f;y;z]}    // Minus 1 0 since bin always take indices from left hand side

// Simple apply
.Q.ft: {
    $[$[(99h= type t:.Q.v y);98h= type value t;0]; 
        [n:count flip key y; n!x 0!y]; 
        x y
    ]
 };

.Q.ff: {
    $[(&/) key[flip y] in f:key flip x; x; x ,' (f_y) count[x]#0N]
 };

/ kdb 3.6 onwards change
.Q.ajf0: {[f;g;x;y;z]
  x,:();
  z:0!z;
  d:$[g;x_z;z];
  / f will determine what g/f function to use
  g:(:;^)f;
  f:(,;^)f;
  i:(x#z) bin x#y;
  j:-1 < i;
  $[(&/)j;
   f'[y;d i];
   flip .[flip .Q.ff[y;d]; (key flip d;j); g; value flip d i j:where j]
  ]
 };

aj:{.Q.ft[.Q.ajf0[0;1;x;;z]; y]};
aj0:{.Q.ft[.Q.ajf0[0;0;x;;z]; y]};

/ Older than kdb 3.6
ajf: {[isaj;x;y;z]
    d: $[isaj;x_;] z;
    i: (x#z) bin x#y;
    j: -1 < i;
    $[(&/) j;
        y ,' d i;
        flip .[flip .Q.ff[y;d]; (key flip d;j); :; value flip d i j: where j]
    ]
 };

aj: {.Q.ft[ajf[1b;x,();;0!z]; y]};
aj0: {.Q.ft[ajf[0b;x,();;0!z]; y]};

asof: {
    f: key $[99h = type y;;flip] y;
    (f_x) (f#x) bin y
 };

uj: {
    $[() ~ x; 
            y;
        98h = type x; 
            x, key[flip x: .Q.ff[x;y]] # .Q.ff[y;x];
        (distinct[key[x], key y]#x) lj y
    ]
 };

.Q.fl: {
    $[98h = t: type x;
            flip .z.s[flip x; flip y];
        99h = t;
            @[x,y; f; :; .z.s'[x f; y f@: where (f:key x) in key y]];
        t and t < 78h;
            x^y;
        @[y; i; :; x i: where (0 < count each x) & not count each y]
    ]
 };

ljf: {
    $[`s = attr y;
        aj[key flip key y; x; 0!y];
        [
        ljfn: {
            $[(&/) j: count[y: value y] > i?: key[flip i:key y]#x;
                .Q.fl[x; y i];
                [
                op: .Q.fl[#[f:key flip y; x:.Q.ff[x;y]] @ j; y i j: where j];
                flip .[flip x; (f;j); :; value flip op]
                ]
            ]
        }; 
        .Q.ft[ljfn[;y]; x]
        ];
    ]
 };