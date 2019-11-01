.Q.fpn1: {
    r: .Q.trp[y; h; {hclose x; '(y;z)} h: hopen":fifo://", 1_ string x]; 
    hclose h; 
    r
 }
.Q.fpn2: {[f;h;n] 
    b: "x"$ (); 
    while[count s: read1 h; 
        if[not n > count b,:s; 
            v: ` vs b, 0x0a; 
            if[1 < count v; f @ -1_ v];
            b: "x"$ last v
        ]
    ];
    if[count b; 
        f[` vs b]
    ]
 }
.Q.fpn:{.Q.fpn1[y; .Q.fpnFn2[x;;z]]}
