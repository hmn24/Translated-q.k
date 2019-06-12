meta: {([key c] .Q.ty each t; f: .Q.fk each t; a: attr each t: value c: .Q.V x)};

.Q.ty: {$[0h > x: .Q.tx x; upper t @ neg x; t x]};

.Q.tx: {$[(76h < t) | not t: type x; 
                $[0<t:type first x; neg t; 0]; 
            20h > t; 
                t; 
            11h= t: type x: value .Q.nv @ key x;
                t;
            98h = t;
                7h;
            1= count x: flip key x;
                .Q.tx @ first x;
            7h]};

.Q.nv: {$["." ~ first string x;x; `$"..", string x]};

.Q.V: {$[.Q.qp x: .Q.v x;
                (enlist[.Q.pf]!enlist value .Q.pf), flip $[(not x in key .Q.d0[]) & (x: value flip x) in key first value .Q.vt; .Q.vp x; .Q.d0[] @ x];
            0h> type first x: flip 0! x;
                x @' key x;
            x]};
            
// This is responsible for taking the last partition (date) meta 
.Q.d0: {.Q.dd[last .Q.pd; last .Q.pv]};
