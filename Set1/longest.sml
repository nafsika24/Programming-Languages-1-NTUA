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
    (n, k, readInts (n) [])
    end


fun  solver lst N K = 
   let 
      val add_l = map (fn x => (x + K)) lst
      val total = map (fn x=> x*(~1)) add_l

     
      fun insert_L_min ((x::xs), 0) = (x::xs) | insert_L_min([],_) = []

      |  insert_L_min ((x::xs) ,n)  = if( x < hd(xs) ) then  x::insert_L_min (x::tl(xs), n-1) else hd(xs)::insert_L_min (hd(xs)::tl(xs) ,n-1) 
   

      fun insert_patata_max ((x::xs), 0) = (x::xs) | insert_patata_max([],_) = []

      |  insert_patata_max ((x::xs) ,n)  = if( x > hd(xs) ) then  x::insert_patata_max (x::tl(xs), n-1) else hd(xs)::insert_patata_max (hd(xs)::tl(xs) ,n-1) 
            
      fun find_max(0,0) = 0 |  find_max(x,y) = if(x>y) then x else y

      fun final ([],l2,i,j,maxd) = maxd + 1 
      | final(l1,[],i,j,maxd)  = maxd + 1
      | final (l1,l2,i,j,maxd) = if(i>N orelse j>N) then maxd+1
      else
        if( hd(l1) < hd(l2) ) then final (l1,tl(l2),i,j+1,find_max(maxd,j-i))
        else final (tl(l1),l2,i+1,j,maxd)

      fun check_res x = if(x <> N) then x-1 else x

       (* find prefix sums*)
       val prefix_sums = Array.array(N + 1, 0)
        fun fill_sums [] _ _ = ()
          | fill_sums (x::xs) acc counter = ((Array.update(prefix_sums, counter, (x + acc))); fill_sums xs (acc+x) (counter + 1))
      

    
        val x = fill_sums total 0 1
        fun arrayToList arr = Array.foldr (op ::) [] arr
        val y = arrayToList prefix_sums
        val prefix = tl(y)
        
      (* find L_min*)
      val L_min = hd(prefix)

      val test =  L_min::insert_L_min (prefix,N-1)
      val lmin = List.take(test,N)
      
      (* find maximum values*)

      (*keep the last elemt of the prefix sum*)
       val patata = List.last(prefix)
      val reversed_prefix = List.rev prefix
      val m = insert_patata_max(reversed_prefix,N-1)
     (*cut the last element *)
      val p =  patata::List.take(m,N-1)
      val rev = List.rev p
      val maxDif = ~1
      val pre_result =  final(lmin,rev,0,0,~1)
      val result = check_res pre_result
    in 
      print(Int.toString(result) ^ "\n")
    end

fun longest file = 
  let  
    fun first (x,_,_) = x
    fun second (_,y,_) = y
    fun third (_,_,z) = z
    val read = parse file

  in solver (List.rev(third read)) (first read) (second read)
  end