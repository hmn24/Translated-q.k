// Not 100% oas of yet, but the logic is around this 

.Q.hp: {.Q.hmb[x;`POST;(y;z)]}

.Q.hmb: {
    p: (^/) `$ getenv `$ lower\[("HTTP";"NO") ,\: "_PROXY"];
    u: .Q.hap -1! x;
    t: not null[first p] | (|/) first[":" vs u 2] like/: {#["."= first x; "*"], x} each "," vs string p 1;
    a: $[t; p:.Q.hap -1! first p; u] 1;
    r: (-1! `$ raze $[t;p;u] 0 2) string[y], 
        " ", 
        $[t; 1_ string x; u 3], 
        " HTTP/1.1", 
        s, 
        (
            s sv 
            ("Connection: close";"Host: ", u 2), 
            ((0< count a)# enlist $[t; "Proxy-"; ""], "Authorization: Basic ", (neg[c]_ .Q.b6 raze 64 vs' 256 sv' "i"$ 0N 3# a, c#0), (c: .q.mod[neg count a;3])# "="), 
            $[count z; ("Content-type: ", z 0;"Content-length: ", string count z 1);()]
        ), 
        (d:s, s:"\r\n"), 
        $[count z; z 1;""];
    (4+ first r ss d)_ r
    }
    
.Q.hap: {
    list: (0; h; (h:1+ i[1])^ (1+ first where "@"= x) & e; e:count[x]^ e)_ x, (null e:(i: where "/"= x:1_ string x) 2)# "/"; 
    @[list; 1; -1_]
    }
