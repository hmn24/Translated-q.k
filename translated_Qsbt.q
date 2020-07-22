.Q.sbt: raze .Q.pl each ::;

.Q.pl: .Q.pl0 0;

.Q.fqk: {
    ("<" ~ first x) or x ~ first -3# value {}
 };

.Q.pl0: {
    .[{[f;x;y;z]
        g: {$[x > 0; x and count y; x or neg count y] # y};
        m: 1;
        isk: "k)" ~ 2# s: x 3;
        b: sums 0, 1+ count each s: ` vs s;
        n: 0 or b bin y: (0 or y) + 2* isk;
        sf: $[count x 1; x[1], $[0 > x 2;"";":",string n + x 2],": ";""];
        sn: {$[count x; _[2* ".." ~ 2#x; x],":"; x]} first x;
        h: "  ", 5$ "[", string[z], "]";
        if[("locked" ~ x 3) or $[f; 0b; .Q.fqk x 1];
            :h, "(", $[count sn; -1_sn; -2_sf], ")\n\n"
        ];
        h,: sf,sn;
        a: enlist #[(count[h]* n<1) + y - b n; " "],"^";     // Get arrow
        fnDef: g[neg m+1; (n+1)#s];                          // Get function definition
        h, ` sv #[n>m;""], fnDef, a, g[m;(n+1)_s]
    }[x]; 1_y; {.Q.dw "pl0\n";}]
 };