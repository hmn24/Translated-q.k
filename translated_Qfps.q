// For purposes of opening the named pipe and closing it post-function completion
.Q.fpn1: {
    r: .Q.trp[y; h; {hclose x; '(y;z)} h: hopen ":fifo://", 1_ string x]; 
    hclose h; 
    r
 }
 
 // For purposes of parsing the named pipe
 / `char$ 0x0a would give "\n"
 / ` vs b, 0x0a is purposes of parsing it back into char form
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
 
.Q.fpn:{.Q.fpn1[y; .Q.fpn2[x;;z]]}



.Q.fsn1: {[f;s;x;n] 
    r: read1 (s;x;n);
    i: count[r]^ 1+ last where "\n"= r;
    f[` vs i# r];
    x + i
 }
.Q.fsn: {[f;s;n] .Q.fsn1[f;s;;n]/[hcount[s]>; 0]}
.Q.fs: .Q.fsn[;;131000]
