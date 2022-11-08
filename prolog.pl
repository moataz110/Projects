%General


convertBinToDec(0,0).
convertBinToDec(1,1).
convertBinToDec(B,D):- 
					   B > 1,
					   atom_number(A,B),	   
					   sub_atom(A,0,1,After,Z1),
                       atom_number(Z1,N),
                       sub_atom(A,1,After,0,Z2),
                       atom_number(Z2,B1),
                       convertBinToDec(B1,D1),
					   atom_length(A,L),
                       D is D1+((2*N)^(L-1)).
					   
					   
replaceIthItem(A,L,I,R):-
                replaceIthItemhelper(A,L,I,[],R).
replaceIthItemhelper(_,[],_,ACC,ACC).
replaceIthItemhelper(X,[H|T],I,ACC,R):-
                             I \= 0, I1 is I-1 , 
							 append(ACC,[H],NACC) , 
							 replaceIthItemhelper(X,T,I1,NACC,R).
replaceIthItemhelper(X,[_|T],I,ACC,R):-   
                                        I = 0, 
										I1 is I-1 ,
										append(ACC,[X],NACC), 
										replaceIthItemhelper(X,T,I1,NACC,R).
										
										
									
										
splitEvery(N,L,R):- 	splitEveryhelper(N,L,1,[],[],R).
splitEveryhelper(_,[],_,ACC,R,FinalR):- append(R,[ACC],FinalR).
splitEveryhelper(N,[H|T],S, ACC, R,FinalR):-   
                                               S =< N,
                                               S1 is S+1,
											   append(ACC,[H],NACC) ,
											  splitEveryhelper(N,T,S1,NACC,R,FinalR).
splitEveryhelper(N,[H|T],S,ACC,R,FinalR):-  S>N,
									 append(R,[ACC],NACC),
									 splitEveryhelper(N,[H|T],1,[],NACC,FinalR).
									 

                
                                             
                                            
																						
logBase2(1,0).
logBase2(X,N):-  
                 number(X),
				 X>0,
                  X1 is X// 2 ,
				  logBase2(X1,N1),
				  N is N1+1.
logBase2(X,N):-  number(N) , X is 2^N . 





                    
getNumBits(_,fullyAssoc,_,0).
getNumBits(X,setAssoc,_,R):- logBase2(X,R).
getNumBits(_,directMap,L,R):-  length(L,Y) , logBase2(Y,R).







fillZeros(S,0,S).
fillZeros(S,N,R):- 
					N > 0,
					N1 is N-1 , 
					string_concat("0",S,S1) ,
                    fillZeros(S1,N1,R).
					   

%directMap

getDataFromCache(Address,Cache,Data,0,directMap,BitsNum):- 
																atom_number(Address,A),
                                                                convertAddress(A,BitsNum,Tag,Idx,directMap),
                                                                 atom_number(T,Tag),
                                                                  L is 6-BitsNum-1,
                                                                 fillZeros(T,L,TAG),
																 convertBinToDec(Idx,I),
                                                                 nth0(I,Cache,Y),
                                                                 Y = item(tag(TAG),data(Data),1,0).	
								

		
															
convertAddress(Bin,BitsNum,Tag,Idx,directMap):-  	Idx is Bin mod (10^BitsNum)	,
                                                    Tag is Bin //(10^BitsNum).
													
													
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,hit):-
												getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
												NewCache = OldCache.

getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
												\+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
												atom_number(StringAddress,Address),
												convertAddress(Address,BitsNum,Tag,Idx,Type),
												replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).


runProgram([],OldCache,_,OldCache,[],[],Type,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,
[Data|OutputDataList],[Status|StatusList],Type,NumOfSets):-
getNumBits(NumOfSets,Type,OldCache,BitsNum),
(Type = setAssoc, Num = NumOfSets; Type \= setAssoc, Num = BitsNum),
getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,Num,Status),
runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,
Type,NumOfSets).
			

%fullyAssoc
			
getDataFromCache(Address,[item(tag(Address),data(D),1,_)|_],D,0,fullyAssoc,0).
getDataFromCache(Address,[item(tag(Tag),_,_,_)|T],Data,HopsNum,fullyAssoc,0):-  Tag\=Address , 
																				getDataFromCache(Address,T,Data,R,fullyAssoc,0), 
																				HopsNum is R + 1.
																				

convertAddress(Bin,0,Tag,0,fullyAssoc):- atom_number(B,Bin),
                                         atom_number(B,Tag).
										 
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,hit):-
												getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
												NewCache = OldCache.

getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
												\+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
												atom_number(StringAddress,Address),
												convertAddress(Address,BitsNum,Tag,Idx,Type),
												replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).


runProgram([],OldCache,_,OldCache,[],[],Type,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,
[Data|OutputDataList],[Status|StatusList],Type,NumOfSets):-
getNumBits(NumOfSets,Type,OldCache,BitsNum),
(Type = setAssoc, Num = NumOfSets; Type \= setAssoc, Num = BitsNum),
getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,Num,Status),
runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,
Type,NumOfSets).


%setAssoc

 
getDataFromCache(Address,Cache,Data,HopsNum,setAssoc,1) :-                                atom_number(Address,A),
                                                                                              A=<1,
                                                                                         convertAddress(A,SetsNum,Tag,Idx,setAssoc),
															                             atom_number(T,Tag),
                                                                                         fillZeros(T,4,TAG),
																						 getData1(TAG,Cache,Data,HopsNum).
																						 
																						 
getDataFromCache(Address,Cache,Data,HopsNum,setAssoc,1) :-   
                                                                                         atom_number(Address,A),
																						  A>1,
                                                                                         convertAddress(A,SetsNum,Tag,Idx,setAssoc),
															                             atom_number(T,Tag),
															                             logBase2(SetsNum,E),
															                             L1 is  6-E-1,
                                                                                         fillZeros(T,L1,TAG),
                                                                                         getData1(TAG,Cache,Data,HopsNum).




getDataFromCache(Address,Cache,Data,HopsNum,setAssoc,SetsNum):-  
                                                                                          SetsNum > 1,
																						  atom_number(Address,A),
																						  A>1,
                                                                                         convertAddress(A,SetsNum,Tag,Idx,setAssoc),
															                             atom_number(T,Tag),
															                             logBase2(SetsNum,E),
															                             L1 is  6-E-1,
                                                                                         fillZeros(T,L1,TAG),
													                              		 length(Cache,L),
															                             N is L//SetsNum,
																						 splitEvery(N,Cache,L1),
																						 nth0(Idx,L1,L2),
																						 getData1(TAG,L2,Data,HopsNum).
															                            
																						
getDataFromCache(Address,Cache,Data,HopsNum,setAssoc,SetsNum):-  
                                                                                          SetsNum > 1,
																						  atom_number(Address,A),
																						  A=<1,
                                                                                         convertAddress(A,SetsNum,Tag,Idx,setAssoc),
															                             atom_number(T,Tag),
                                                                                         fillZeros(T,4,TAG),
													                              		 length(Cache,L),
															                             N is L//SetsNum,
																						 splitEvery(N,Cache,L1),
																						 nth0(Idx,L1,L2),
																						 getData1(TAG,L2,Data,HopsNum).
															                            																						
																						



getData1(Address,[item(tag(Address),data(D),1,_)|_],D,0).
getData1(Address,[item(tag(Tag),_,_,_)|T],Data,HopsNum):-                        
                                                                                 Tag\=Address ,
																				getData1(Address,T,Data,R),
                                                                                HopsNum is R+1.																				
																				
																				
getData1(Address,[item(tag(Address),_,0,_)|T],Data,HopsNum):-                        
																				getData1(Address,T,Data,R),
																				HopsNum is R+1.
																				
convertAddress(Bin,SetsNum,Tag,Idx,setAssoc):- convertBinToDec(	Bin,B),
                                               B>1,
                                              logBase2(SetsNum,R),
                                               Idx  is  Bin mod 10**R,
											   Tag is Bin//10**R.
											   

convertAddress(Bin,_,Tag,Idx,setAssoc):- convertBinToDec(	Bin,B),
                                               B =< 1,
											   Idx  = B ,
											   Tag  = 0.
											   
											   
getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,hit):-
												getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
												NewCache = OldCache.

getData(StringAddress,OldCache,Mem,NewCache,Data,HopsNum,Type,BitsNum,miss):-
												\+getDataFromCache(StringAddress,OldCache,Data,HopsNum,Type,BitsNum),
												atom_number(StringAddress,Address),
												convertAddress(Address,BitsNum,Tag,Idx,Type),
												replaceInCache(Tag,Idx,Mem,OldCache,NewCache,Data,Type,BitsNum).
												

runProgram([],OldCache,_,OldCache,[],[],Type,_).
runProgram([Address|AdressList],OldCache,Mem,FinalCache,
[Data|OutputDataList],[Status|StatusList],Type,NumOfSets):-
getNumBits(NumOfSets,Type,OldCache,BitsNum),
(Type = setAssoc, Num = NumOfSets; Type \= setAssoc, Num = BitsNum),
getData(Address,OldCache,Mem,NewCache,Data,HopsNum,Type,Num,Status),
runProgram(AdressList,NewCache,Mem,FinalCache,OutputDataList,StatusList,
Type,NumOfSets).
											