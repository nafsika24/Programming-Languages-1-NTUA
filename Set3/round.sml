          
fun parse file =
    let
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    	val inStream = TextIO.openIn file

      val n = readInt inStream
      val k = readInt inStream
      val _ = TextIO.inputLine inStream

      fun readInts 0 acc = acc 
        | readInts i acc = readInts (i - 1) (readInt inStream :: acc)

    in
    (n, k, readInts (k) [])
    end

fun  solver lst N K = 
    let 
        fun create(i,j, res) = if(j = K) then res else create(i,j+1,i::res)  
        val y = create(0,0,[])
        val ending = N-1

        fun substact([],[],res) = res |
            substact(a,b,res) = if(hd(a)<hd(b)) then substact(tl(a),tl(b),(hd(a) - hd(b) + N)::res) else substact(tl(a),tl(b),(hd(a) - hd(b))::res)

        fun maximum [] = 0
        | maximum (x::xs) = foldl Int.max x xs

        fun listSum [] = 0
            | listSum (x::xs) = x + (listSum xs);

        
        fun apost x  = substact(x,lst,[])


        fun med l = maximum(l) +  maximum(l) - listSum(l)
        
        fun final_sums (l,counter,c,res) = if(counter = N-1) then res else
                        if(med(l) < 2 andalso listSum(l) < hd(res)) then final_sums ( apost(map(fn x=>x+c) y), counter + 1,c+1, [listSum(l),counter] )
                        else final_sums ( apost(map(fn x=>x+c) y), counter + 1,c+1, res )

        val x = final_sums( apost(y),0,1,[listSum(apost(y)),0])
    in  
     print(Int.toString(hd(x)) ^ " "); print(Int.toString(hd(tl x)) ^ "\n") 

    end
    
fun round file = 
  let  
    fun first (x,_,_) = x
    fun second (_,y,_) = y
    fun third (_,_,z) = z
    val read = parse file

  in solver (List.rev(third read)) (first read) (second read)
  end
