// Translated function from q.k for purposes of reference 

//-- If empty, automatically assign to 1, else only assign to 1 if its of dictionary type
.Q.qe: {$[count x; 99h = type x; 1]}

//-- To get the cache count populated within .Q.pn (via .Q.cn). This is called by .Q.dt
.Q.dt: {.Q.cn[y] @ where .Q.pv in x}

//-- .Q.cn would populate the .Q.pn cache for the first time when running it
.Q.cn: {$[count n: .Q.pn x: value flip x; n; .Q.pn[x]: {count .Q.p1[x;y;z]}'[x;.Q.pd;.Q.pv]]}

.Q.qb: {(2>count x) | type[x] & not 11= type x}

.Q.qa: {$[.Q.qb x;0; .Q.IN[first x; .Q.a0];1; (|/) .Q.qa each 1_x]}

//-- Check for statement such as (count distinct@; `column)
.Q.qd: {$[count ~ first x; distinct ~ first x[1]; 0]}

//-- Check for function in a defined list, generally used to check for functions within .Q.a0
.Q.IN: {$[99h< type x; x in y; 0]}

//-- .Q.ua, along with .Q.x0, .Q.x1, .Q.x2, is mainly used for Q to deal with composite functional trees, with aggregation functions split into map-reduce components
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

//-- .Q.foo is mainly used to index into each date partitions via .Q.p 
/- Note that (value flip t) would get the symbol name of the partitioned table of interest
.Q.foo: {[t;c;b;a;v;d]
    if[v;
        g: last ` vs b f:first key b;
        b:1_b
    ];
    raze $[v | not count a; .Q.fp[$[v; f,g; .Q.pf]]'[d;]; ::] .Q.p[(value flip t;c;b;a); d]
    }

//-- Note that ': refers to peach under .Q.p
/- .Q.p2[x]'/': can be viewed with the perspective of (,'/') (`a`b; (`a`b`c;`d`e`f))
/- The key is that it needed a convenient way of bridging such structures into .Q.p2 (which would need to take in (y;z) argument):
/- (`:/local/1/100;2006.01.02 2006.01.04)
/- (`:/local/2/101;(), 2006.01.03)
.Q.p:{$[not count .Q.D; .Q.p2[x;`:.]':[y]; (raze .Q.p2[x]'/':[(;)'[.Q.P @ i; y]]) @ iasc raze y@: i: where 0< count each y: {x @ where x in y}\:[.Q.D;y]]}

.Q.fp: {flip (enlist[first x]!enlist count[z]# $[-7h= type y; y; last[x]$y]), flip z}

.Q.p2: {0!(?).@[x;0;.Q.p1[;y;z]]}

/- Note that key[value flip x] is meant to get the columns of interest of the specific date partition
/- "flip key[flip value x]!` sv .Q.dd[y;z], x]" is actually "flip `sym`time`num!`:./2010.01.01/t"
/ Note that as an example: (x;y;z) = (`t; `:.; 2010.01.01)
.Q.p1: {$[count .Q.pm; .Q.pm[x] (y;z); z in .Q.vt[y;x]; .Q.vp x; flip key[flip value x]! .Q.dd[y; z, x]]};

/- .Q.MAP would generate the mapped partitions on .Q.pm, allowing .Q.p1 to be quickened since it doesnt have to repeatedly access file handles
/- Would potentially need to modify it to speed up the caching process
/ - .Q.pm is a dictionary created with (`:.; 2010.01.01) as key and the actual memory-mapped tables as value as an e.g.
.Q.MAP: {
    {$[0 > type a: value flip 0! value x; x set value `$ -1_ string a;]} each a where not (a: system "a") in .Q.pt; 
    .Q.pm::();
    if[count .Q.pt; 
        .Q.pm:: .Q.pt! {(`u# .Q.pd,'.Q.pv)!.Q.p2[(x;();0b;())]'[.Q.pd; .Q.pv]} each .Q.pt
    ]
 }

fby: {$[count[x 1] = count y; @[count[y]# x[0] 0# x 1; g; :; x[0] each x[1] g:value group y];'length]}

//-- Actual map-reduce .Q.ps, which calls the sub-functions defined above
.Q.ps:{[t;c;b;a]
    if[-11h = type t; t: value t];
    if[not .Q.qe[a] & .Q.qe[b] | -1h = type b; '`nyi];
    d: .Q.pv;
    v: $[(q:0> type b); 0; (not count b); 0; (-11h= type v: first value b); .Q.pf ~ first ` vs v;  0];
    //-- This primarily handles the filtering of (date) partitions in the where clause for .Q.foo to individually index into 
    if[$[(not count c);0; (type first c);0; (-11h= type x: c[0] 1); .Q.pf ~ first ` vs x;  0];
        d@: where eval first c;
        c: 1_ c
    ];
    //-- For probably efficacy purposes, check if aggregate clauses just contain count[i] or partition, and generate them through this if-condition
    /- Example includes "select count i by date from t" or "select date by date from t", after where-date clauses have been removed above if it exists
    if[$[count c; 0; (g:value[a] ~ enlist[.Q.pf]) | value[a] ~ enlist (count;`i)];
        f: key a;
        j: .Q.dt[d] t;
        if[q; :flip f! enlist $[g; distinct d[where 0< j]; enlist sum j]];
        if[v & 1= count b; :?[flip (.Q.pf, f)! (d;j)[;where 0< j]; (); b; f!enlist (sum;first f)]]
    ];
    //-- Should there be no (date) partitions remaining post filtering in the if-condition specified
    /- Automatically assign where clauses to empty and assign the last partition in the d variable for meta preservation purposes
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

/- .Q.pf is `date
/- .Q.pd is `:/local/1/hdb/1`:/local/2/hdb/2 etc
/- .Q.pv is 2006.01.02 2006.01.03 etc
.Q.ind: {raze {.Q.fp[.Q.pf; p; .Q.p1[x; .Q.pd @ y; p: .Q.pv @ y] @ z]}[value flip x]'[i j; (j: where <>':[i])_ y - n @ i: (n: sums 0, .Q.cn x) bin y]}

// .Q.ft is an elegant way of handling the indexing of tables, since it identifies the number of keyed columns, unkey it initially for standard indexing
/ Then reapply the original keyed columns to restore its keyed table format
.Q.ft: {$[$[(99h= type t:.Q.v y);98h= type value t;0]; [n:count flip key y; n!x 0!y]; x y]}

.Q.bv:{
    g: $[(::) ~ x; max; min];
    x: `:.;
    P: $[`par.txt in key x; hsym `$ read0 .Q.dd[x;`par.txt]; enlist x];
    d: {.Q.dd'[x; d where (d: key x) like "[0-9]*"]} each P;
    `getPartDate set {("DMJJ" @ `date`month`year`int?.Q.pf) $ string last x: ` vs x};
    .Q.vt: ({where[count each x] @ group raze value x} {(getPartDate each x)! key each x} ::) each d;
    t: distinct raze key each .Q.vt;
    .Q.vt: t #/: .Q.vt;
    res: {i: y @ where x= y @ x:@[x; where x ~\: (); :; first 0# `. .Q.pf]; (i; x i)}[;g] each flip t #/: g''[.Q.vt];
    d: ` sv' (,'/) (P value[res][;0]; `$ string value[res][;1]; key res);
    .Q.vt: P! except[value .Q.pf]''[.Q.vt];
    .Q.vp: t! {flip[enlist[.Q.pf]!enlist 0# value .Q.pf] ,' flip (attr each value flip x) #' flip reverse 0# x:?[x;();0b;()]} each d;
    .Q.pt,: {x set flip (key[flip .Q.vp x] except .Q.pf)!x} each t except .Q.pt;
 };
