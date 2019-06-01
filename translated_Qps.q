.Q.qe:{$[count x; 99h = type x; 1]}

.Q.dt: {.Q.cn[y] @ where .Q.pv in x}

.Q.qb: {(2>count x)|type[x] & not 11= type x}

.Q.qa: {$[.Q.qb x;0; .Q.IN[first x; .Q.a0];1; (|/) .Q.qa each 1_x]}

.Q.qd: {$[count ~ first x; distinct ~ first x[1]; 0]}

.Q.IN: {$[99h< type x; x in y; 0]}

.Q.ua: {((`$string til count u)!u; .Q.x2[; u: distinct raze .Q.x1 each x] each x: .Q.x0 each x)}

.Q.x0: {$[.Q.qb x; x; .Q.IN[first x; .Q.a1]; .Q.x0 .Q.a2[.Q.a1? first x] . 1_x; .Q.x0 each x]}

.Q.x1: {$[.Q.qb x; ();.Q.IN[first x; .Q.a0]; $[.Q.qd x; 1_x; enlist x]; raze .Q.x1 each 1_x]}

.Q.x2: {$[.Q.qb x;

            x;

        .Q.IN[first x; .Q.a0];

            $[.Q.qd x;

                (count distinct raze @; .Q.xy[x 1;y]);

                [

                y: .Q.xy[x;y];

                $[distinct ~ first x; (distinct raze@; y); count ~ first x; (sum;y); (first x;y)]

                ]

            ];

        .Q.x2[;y] each x

        ]}

.Q.xy: {`$ string first where x ~/: y}

.Q.foo: {[t;c;b;a;v;d]

    if[v;

        g: last ` vs b f:first key b;

        b:1_b

    ];

    raze $[v | not count a; d .Q.fp[$[v; f,g; .Q.pf]]'; ::] .Q.p[(value flip t;c;b;a); d]

    }

.Q.p:{$[not count .Q.D; .Q.p2[x;`:.]'[y]; (raze .Q.p2[x]'/'[.Q.P[i] (;)'[y]]) @ iasc raze y@: i:where 0< count each y:{x @ where x in y}\:[.Q.D;y]]}

.Q.fp: {flip (enlist[first x]!enlist count[z]# $[-7h= type y; y; last[x]$y]), flip z}

.Q.p2: {0!(?).@[x;0;.Q.p1[;y;z]]}

.Q.p1: {$[count .Q.pm; .Q.pm[x] (y;z); z in .Q.vt[y;x]; .Q.vp x; flip key[flip value x]!` sv .Q.dd[y;z], x]}

 

.Q.ps:{[t;c;b;a]

    if[-11h = type t; t: value t];

    if[not .Q.qe[a] & .Q.qe[b] | -1h = type b; '`nyi];

    d: .Q.pv;

    v: $[(q:0> type b); 0; (not count b); 0; (-11h= type v: first value b); .Q.pf ~ first ` vs v;  0];

    if[$[(not count c);0; (type first c);0; (-11h= type x: c[0] 1); .Q.pf ~ first ` vs x;  0];

        d@: where eval first c;

        c: 1_ c

    ];

    if[$[count c; 0; (g:value[a] ~ enlist[.Q.pf]) | value[a] ~ enlist (count;`i)];

        f: key a;

        j: .Q.dt[d] t;

        if[q; :flip f! enlist $[g; distinct d[where 0< j]; enlist sum j]];

        if[v & 1= count b; :?[flip (.Q.pf, f)! (d;j)[;where 0< j]; (); b; f!enlist (sum;first f)]]

    ];

    if[not count d;

        d: .Q.pv[where .Q.pv = last .Q.pv];

        c: enlist ()

    ];

    f: $[q; 0# `; key b];

    g: $[count a; .Q.qa @ first a; 0];

    $[(1= count d)| $[q; not g; .Q.u & .Q.pf ~ first value b];

        $[not q;(f xkey); b;distinct; ::] .Q.foo[t;c;b;a;v;d];

        eval (?; .Q.foo[t;c;$[q;()!();b];first a;v;d]; (); $[q;0b;f!f]; last a: $[g; .Q.ua[a]; (a;$[count a;(raze;)'[k!k: key a];()])])

    ]

}
