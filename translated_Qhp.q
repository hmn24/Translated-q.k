// Not 100% oas of yet, but the logic is around this 

.Q.hp: {.Q.hmb[x;`POST;(y;z)]}

.Q.hmb: {
    x: $[10=type x; x; 1_string x];
    p: {$[count y; y; x]}/'[getenv flip `$ lower\[("HTTP";"NO"),\:"_PROXY"];
    u: .Q.hap @ x;
    t: not not[count first p] | (|/) first[":" vs u 2] like/: {(("."= first x)#"*"),x} each "," vs p 1;
    a: $[t; p: .Q.hap @ first p;u] 1;
    r: (`$ ":", raze $[t;p;u] 0 2) 
        string[y], 
        " ", 
        $[t;x;u 3], 
        " HTTP/1.1", 
        s, 
        (s sv ("Connection: close";"Host: ",u 2),
            ((0<count a)# enlist $[t;"Proxy-";""], "Authorization: Basic ", .Q.btoa a),
            $[count z;("Content-type: ", z 0; "Content-length: ", string count z 1);()]
        ),
        (d:s,s:"\r\n"),
        $[count z;z 1;""];
    (4+ first r ss d)_ r
 }

.Q.hap: {
    list: (0; h; (h:1+ i[1])^ (1+ first where "@"=x) & e; e:count[x]^ e)_x, null[e: (i:where "/"= x:(":"= first x)_x) @ 2]# "/";
    @[list;1;-1_]
 }
