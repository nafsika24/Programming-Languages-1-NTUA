          
fun parse file =
    let
        fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
    	val inStream = TextIO.openIn file

        (* Read an integer (number of countries) and consume newline. *)
    val len = readInt inStream
    val height = readInt inStream
    val _ = TextIO.inputLine inStream

        (* A function to read N integers from the open file. *)
    fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
      | readInts i acc = readInts (i - 1) (readInt inStream :: acc)

            fun aux acc =
          let
            val line = TextIO.inputLine inStream
          in
            if line = NONE
            then (rev acc)
            else ( aux ( explode (valOf line ) :: acc ))
        end;
        val world = aux []
    in
   	(len, height, world)
    end

fun solution map vertices length height = 
    let
        val parents = Array.array(vertices+1, 0)
        val sizes   = Array.array(vertices+1, 1)

        fun parent_init 0 = ()
          | parent_init vertices = (Array.update(parents, vertices, vertices); parent_init (vertices-1))

        fun root input = if ( input <> Array.sub(parents, input)) then (Array.update(parents, input, Array.sub(parents,Array.sub(parents,input)));root (Array.sub(parents, input)))
                         else ( input)

        fun union set_1 set_2 = 
            let 
                val parent_1 = root set_1;
                val parent_2 = root set_2;

            in 
                if Array.sub(sizes, parent_1) < Array.sub(sizes, parent_2) 
                    then (Array.update(parents, parent_1, parent_2); Array.update(sizes,parent_2, (Array.sub(sizes, parent_2) + Array.sub(sizes, parent_1))))
                else (Array.update(parents, parent_2, parent_1); Array.update(sizes,parent_1, Array.sub(sizes, parent_2) + Array.sub(sizes, parent_1)))

            end

        fun find vertice_1 vertice_2 = (root vertice_1) = (root vertice_2)

        fun up_border 0 = if Array2.sub(map, 0, 0) = #"U" then union 0 1 else ()
          | up_border len = if Array2.sub(map, 0, len) = #"U" then (union (len + 1) 0; up_border (len - 1)) else (up_border (len - 1))

        fun down 0 = if Array2.sub(map, height - 1, 0) = #"D" then union ((height-1)*length + 1 ) 0 else ()
          | down len = if Array2.sub(map, height - 1, len) = #"D" then (union ((height-1)*length + len + 1) 0; down (len - 1)) else (down (len - 1))

        fun left 0 = if Array2.sub(map, 0, 0) = #"L" then union 0 1 else ()
          | left len = if Array2.sub(map, len, 0) = #"L" then (union (len*(length) + 1) 0; left (len - 1)) else (left (len - 1))

        fun right 0 = if Array2.sub(map, 0, length-1) = #"R" then union length 0 else ()
          | right len = if Array2.sub(map, len, length-1) = #"R" then (union (length*(len+1)) 0; right (len - 1)) else (right (len - 1))

        fun merge a b item =
            case item of
                #"U"   => if a = 0 then () else union (length*a + b + 1) (length*(a-1) + b + 1)
            |   #"D"   => if a > height - 2 then () else union (length*a + b + 1) (length*(a+1) + b + 1)
            |   #"R"   => if b > length - 2 then () else union (length*a + b + 1) (length*a + b + 2)
            |   #"L"   => if b = 0 then () else union (length*a + b + 1) (length*a + b)

        fun traversal 0 0 = merge 0 0 (Array2.sub(map, 0, 0))
          | traversal x y = if y = ~1 then traversal (x-1) (length-1) else (merge x y (Array2.sub(map, x, y)); traversal x (y - 1))
        
        fun traversal1 0 0 = if find 1 0 then 0 else 1
          | traversal1 x y = if y = ~1 then traversal1 (x-1) (length-1) else (if find (length*x + y + 1)  0 then traversal1 x (y-1) else 1 +  traversal1 x (y-1))    
          
        fun check 1 = print(Bool.toString(find 0 1))
          | check x = (print(Int.toString(x) ^" : "^Bool.toString(find x 0)^"\n"); check (x - 1))
    in
      parent_init (vertices); left (height-1); right(height-1); up_border (length-1) ; down (length-1); traversal (height-1) (length-1); traversal1 (height-1) (length-1) 
    end

fun please (height, length, lst) = solution (Array2.fromList(lst)) (height*length) length height

fun loop_rooms file = print(Int.toString(please (parse file)) ^ "\n")