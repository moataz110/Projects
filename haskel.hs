data Item a = It Tag (Data a) Bool Int | NotPresent deriving (Show, Eq)
data Tag = T Int deriving (Show, Eq)
data Data a = D a deriving (Show, Eq)
data Output a = Out (a, Int) | NoOutput deriving (Show, Eq)
convertBinToDec :: Integral a => a -> a
convertBinToDec 0  = 0 
convertBinToDec a = 2 * convertBinToDec(div a 10) + (mod a 10)

replaceIthItem :: t -> [t] -> Int -> [t]
replaceIthItem a (x:xs) b | b==0 = a:xs
                          | otherwise  = x:replaceIthItem a xs (sub b)
inc a = a+1
sub a  = a-1

splitEvery :: Int -> [a] -> [[a]]
splitEvery  _ [] = []
splitEvery  a l = x:splitEvery  a xs where (x,xs) = splitAt a l
                       
--logBase2 :: (Floating a) => a -> a -> a
logBase2 a = logBase 2 a
		   


atomNum :: String -> Int
atomNum s = read s 


		   
		   

--getNumBits :: (Integral a, RealFloat a1) => a1 -> [Char] -> [c] -> a
getNumBits _ "fullyAssoc" _ = 0
getNumBits a "setAssoc" _  = round (logBase 2 a) 
getNumBits _ "directMap" l  = round (logBase 2 (fromIntegral (length l)))					
					   
	
fillZeros l 0 = l
fillZeros l n = "0" ++ (fillZeros l (n-1)) 
		   

--convertAddress
-- directMap 
-- setAssoc
--fullyAssoc
convertAddress :: (Integral b1, Integral b2) => b1 -> b2 -> p -> (b1, b1)
convertAddress a b s = ( div a (10^b) , mod a (10^b))



--getDataFromCache 
--directMap
--getDataFromCache :: (Integral b, Eq a) =>[Char] -> [Item a] -> [Char] -> b -> Output a

getItem a l  n = l!!(convertBinToDec (mod (atomNum a) (10^n) ) )
getTag a n = atomNum(take ((length a ) - n ) a )
getDataFromCache a l "directMap" n = if ((getTag a n) == t)&& (v == True) then Out (d,0) else NoOutput
							where
							It (T t) (D d) v o =  getItem a l n  
	
						
getData :: (Integral b, Eq a) => [Char] -> [Item a] -> [a] -> [Char] -> b -> (Output a, [Item a])

getData stringAddress cache memory cacheType bitsNum
                                                    | x == NoOutput = replaceInCache tag index memory cache cacheType bitsNum
                                                    | otherwise = (getX x, cache)
                                                     where
                                                     x = getDataFromCache stringAddress cache cacheType bitsNum
                                                     address = read stringAddress:: Int
                                                     (tag, index) = convertAddress address bitsNum cacheType

getX (Out (d, _)) = d


runProgram :: (RealFloat a1, Eq a2) => [[Char]] -> [Item a2] -> [a2] -> [Char] -> a1 -> ([a2], [Item a2])							
runProgram [] cache _ _ _ = ([], cache)
runProgram (addr: xs) cache memory cacheType numOfSets = ((d:prevData), finalCache)
                                                          where
                                                          bitsNum = round(logBase2 numOfSets)
                                                          (d, updatedCache) = getData addr cache memory cacheType bitsNum
                                                          (prevData, finalCache) = runProgram xs updatedCache memory cacheType numOfSets
							
							
--fullyAssoc
getDataFromCacheF :: (Integral b, Eq a) => [Char] -> [Item a] -> [Char] -> b -> Output a

getDataFromCacheF a (It (T t) (D d) v o: xs) "fullyAssoc" 0 =  getDataFromCacheFhelper a (It (T t) (D d) v o: xs)  0 "fullyAssoc" 0 




getDataFromCacheFhelper _  [] _ _ _ = NoOutput 
getDataFromCacheFhelper a (It (T t) (D d) v o: xs)  h "fullyAssoc" 0  = if((atomNum a) == t) && (v == True) then Out (d,h)  
																											else getDataFromCacheFhelper a xs (h+1) "fullyAssoc" 0 		
		



getDataF :: (Eq t, Integral b) => String -> [Item t] -> [t] -> [Char] -> b -> (t, [Item t])	
getDataF stringAddress cache memory cacheType bitsNum
                                                     | x == NoOutput = replaceInCache tag index memory cache cacheType bitsNum
                                                     | otherwise = (getX x, cache)
                                                     where
                                                     x = getDataFromCache stringAddress cache cacheType bitsNum
                                                     address = read stringAddress:: Int
                                                     (tag, index) = convertAddress address bitsNum cacheType
                                                     getX (Out (d, _)) = d



runProgramF :: (RealFloat a1, Eq a2) => [[Char]] -> [Item a2] -> [a2] -> [Char] -> a1 -> ([a2], [Item a2])	
runProgramF [] cache _ _ _ = ([], cache)
runProgramF (addr: xs) cache memory cacheType numOfSets =
                                                         ((d:prevData), finalCache)
                                                         where
                                                         bitsNum = round(logBase2 numOfSets)
                                                         (d, updatedCache) = getData addr cache memory cacheType bitsNum
                                                         (prevData, finalCache) = runProgram xs updatedCache memory cacheType numOfSets			




			
--setAssoc
getDataFromCacheS :: (Integral b, Eq a) =>[Char] -> [Item a] -> [Char] -> b -> Output a																											
getDataFromCacheS  a (It (T t) (D d) v o: xs) "setAssoc" n  = getDataFromCacheF a (getset a (It (T t) (D d) v o: xs)  n) "fullyAssoc" 0  																											


getset _ [] _ = []
getset a  l  n =  (splitEvery 2 l)!!(convertBinToDec (index a n) )   

index a b = idx( convertAddress (atomNum a)  b "setAssoc" ) 
idx (x,xs) = xs


getDataS :: (Eq t, Integral b) => String -> [Item t] -> [t] -> [Char] -> b -> (t, [Item t])
getDataS stringAddress cache memory cacheType bitsNum
                                                     | x == NoOutput = replaceInCache tag index memory cache cacheType bitsNum
                                                     | otherwise = (getX x, cache)
                                                     where
                                                     x = getDataFromCache stringAddress cache cacheType bitsNum
                                                     address = read stringAddress:: Int
                                                     (tag, index) = convertAddress address bitsNum cacheType
                                                     getX (Out (d, _)) = d



runProgramS :: (RealFloat a1, Eq a2) => [[Char]] -> [Item a2] -> [a2] -> [Char] -> a1 -> ([a2], [Item a2])
runProgramS [] cache _ _ _ = ([], cache)
runProgramS (addr: xs) cache memory cacheType numOfSets =
                                                         ((d:prevData), finalCache)
                                                         where
                                                         bitsNum = round(logBase2 numOfSets)
                                                         (d, updatedCache) = getData addr cache memory cacheType bitsNum
                                                         (prevData, finalCache) = runProgram xs updatedCache memory cacheType numOfSets