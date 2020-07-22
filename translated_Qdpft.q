// This is the function for the saving of tables
.Q.dpft: {[d;p;f;t;s]
    i: iasc t f;
    if[not min .Q.qm each r: flip .Q.enxs[$; d; .[`.; ` vs t]; s];
        '`unmappable
    ];
    /- Apply parted attributes on s column (i.e. sym column) on the (::;`p#) f= key r
    {[d;t;i;u;x] @[d; x; :; u @ t[x] @ i]}[d: .Q.par[d;p;t]; r; i;]'[(::;`p#) f= key r; key r];
    /- Modify .d file to incorporate the necessary columns
    @[d; `.d; :; f, r where not f= r: key r]
    /- Return the t value
    t
 }[;;;;`sym];

.Q.hdpf: {[h;d;p;f] 
    (@[`.;;0#] .Q.dpft[d;p;f]@) each t @ idesc (count value @) each t: tables[]; 
    if[h: @[hopen;h;0]; h system "l ."; hclose h]
 };

// .Q.qm is to make sure types are all uniform, else it would return a 0 and trigger the unmappable error above
.Q.qm: {$[(type[x] | not count x);1; (t: type first x);min t= type each x; 0]};

// This would construct the appropriate partitioned directory for the functional amend above in
/ {[d;t;i;u;x] @[d; x; :; u @ t[x] @ i]}
/ key `:XX.par.txt is to check if the file exists, if it does, it means its a segmented tables and par.txt has to be read to index to correct partition
/ This is carefully done through mod[p;count h: read0 h] to point to correct file path
.Q.par: {[d;p;t] ` sv ($[type key h: ` sv d,`par.txt; `$":", h mod[p;count h: read0 h]; d]; `$ string p; t)};

// This is mainly for the enumeration of the .Q.dpft
.Q.enxs: {[x;d;t;s]
    if[count c@: where {$[11h= type first x; min 11h= type each x; 11h= type x]} each t c: key flip t;
        (` sv d,s) ? distinct raze (distinct {$[0h= type x; raze x; x]} @) each t c
    ];
    @[t; c; {$[0h= type z; (-1_ sums 0, count each z)_ x[y; raze z]; x[y;z]]}[x;s]]
 };

.Q.chk: {
    if[x ~ (::);
        '"missing dir argument"
    ];
    f: {` sv' x ,' d where (d: key x) like "[0-9]*"};
    d: $[`par.txt in key x; raze f each hsym `$ read0 .Q.dd[x;`par.txt]; f x];
    d@: idesc (value string last ` vs) each d;
    u: distinct raze tabs: key each d;
    func: {[e;u;d] 
        {.Q.dd[x; y,`] set select from z}[d]'[u i; e i: where not u in key d]
    };
    schemaMap: {0# x . y,`}'[d flip[u in/: tabs] ?\: 1b; u];
    func[schemaMap; u] each d
 };

.Q.enx:{[s;d;x]
    chkSym: {$[11h = type first x; (&/) 11h = type each x; 11h = type x]};
    f: key flip x;
    if[count f@: where chkSym each x f;
        .Q.dd[d;`sym] ? distinct raze distinct each {$[0h = type x; raze x; x]} each x f
    ];
    fn: {$[0h = type y; (-1_ sums 0, count each y) _ x[`sym;raze y]; x[`sym;y]]};
    @[x; f; fn s]
 };

.Q.en: .Q.enx[?];
