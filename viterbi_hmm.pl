%refer to https://ja.wikipedia.org/wiki/ビタビアルゴリズム

%?-s_new,[-'viterbi_hmm.pl'],test_viterbi_hmm.
test_viterbi_hmm:-
 OB=['歩','買','掃'],
 ST=[['雨',0.6],['晴',0.4]],
 C=['雨','晴'],
 viterbi(OB,ST,C,R),write(R).
 
viterbi(A,B,C,Z):-viterbi(A,B,C,B,C,0,T-T,X-X,R),reverse(R,Z).
 
viterbi([],_,_,_,_,_,_,_,[]):-!.
viterbi([A|L],[],[N],ST,CD,U,T-[U],X-[],Z):-
	viterbi2(CD,T,W),
	viterbi(L,W,CD,W,CD,0,V-V,Y-Y,R),viterbi3(R,X,0,[],Z).
viterbi([A|L],[],[D|N],ST,CD,U,T-[U|S],X,R):-
	viterbi([A|L],ST,N,ST,CD,0,T-S,X,R).
viterbi([A|L],[[B,C]|M],[D|N],ST,CD,U,T,X-[[B,D,X2]|X3],R):-
	p2(B,D,F),p3(B,A,E),X2 is C*(E*F),Z is X2+U, %write([A,B,C,D,E,F,Z]),nl,
	viterbi([A|L],M,[D|N],ST,CD,Z,T,X-X3,R).

viterbi2([],[],[]):-!.
viterbi2([A|L],[B|M],[[A,B]|N]):-
	viterbi2(L,M,N).

viterbi3(A,[],_,B,C):-
	append(A,B,C).
viterbi3([],[[C,A,B]|M],N,_,R):-
	B>N,!,
	viterbi3([],M,B,[C,A],R).
viterbi3([A,B|L],[[C,A,D]|M],N,_,R):-
	D>N,!,
		viterbi3([A,B|L],M,D,[C],R).
viterbi3(A,[B|M],N,X,R):-!,
	viterbi3(A,M,N,X,R).
 
:- public reverse/2.
reverse(L,R):-rev(L,[],R).
rev([],L,L).
rev([A|L],R,B):-rev(L,[A|R],B).
 
p2('雨','雨',0.7).
p2('雨','晴',0.3).
p2('晴','雨',0.4).
p2('晴','晴',0.6).
 
p3('雨','歩',0.1).
p3('雨','買',0.4).
p3('雨','掃',0.5).
p3('晴','歩',0.6).
p3('晴','買',0.3).
p3('晴','掃',0.1).
 
%?-test_viterbi_hmm.
%[晴,雨,雨,雨]
