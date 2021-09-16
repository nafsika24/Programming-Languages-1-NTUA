          
import java.io.*;
import java.util.Arrays;
import java.util.Collections;
import java.util.stream.IntStream;
import java.io.InputStream;

public class Round {
    public static void main(String[] args) throws Exception{
        
        final File input = new File(args[0]);
        final BufferedReader reader = new BufferedReader(new FileReader(input));
        final String l1 = reader.readLine();
        final String l2 = reader.readLine();
        reader.close();
        final String[] first = l1.split (" ");
        // cities
        final int N = Integer.parseInt(first[0]);
        // cars
        final int M = Integer.parseInt(first[1]);
        // initial state
        final String[] cit = l2.split(" ");
        final int [] cities = new int [M];

        for(int i = 0; i < M; i++){
            cities[i]= Integer.parseInt(cit[i]);
          }

          // dimiourgiou basikou pinaka
          int [] cities_arr = new int [N];
          Arrays.fill(cities_arr, 0);

          for(int i = 0; i<M; i++){
            int x = cities[i];
            cities_arr[x] = cities_arr[x] + 1;        
          }

          // evresh sum kai max apo thn arxiki katastasi [0,0,0,0]
          
          int sum = 0;
          int max = 0;

          for(int i = 0; i < M; i++){
              int temp;

              if(cities[i] == 0){
                    temp = 0;
              }
              else{
                  temp = -cities[i] + N;
              }

              if(max < temp){
                  max = temp;
              }
              sum = sum + temp;
          }
            int min = 0;
            int min_thesi = 0;
            int index = 0;

            if(2*max - sum < 2){
                min = sum;
                min_thesi = index;
            }
      
            int prim_pointer = cities_arr[0];
            int max_pointer = 0;
            for(int i = 1; i < N; i++){
                if(cities_arr[i]!=0){
                    max_pointer = cities_arr[i];
                    break;
                }
            }
            
            int indexp = 0;

            for( int i = 1; i < N; i++){
                prim_pointer = i;
                // find sum
               sum = sum + M - N*cities_arr[i];

               // find max_pointer
               for(int j = i+1; j < N; j++){
                   if(cities_arr[j]!=0){
                        max_pointer = cities_arr[j];
                        indexp = j;        
                        break;
                   }
                   else{
                       max_pointer = cities_arr[0];
                       indexp = 0;
                   }
               }
               if(indexp > prim_pointer){
                   max = N - indexp + prim_pointer; }
               else{
                   max = i;}
       
               if(2*max - sum < 2){
                   if(sum < min){
                       min  = sum;
                       min_thesi = i;
                   }
                }
            }
            System.out.print(min);
            System.out.println(" " + min_thesi);
    }
 }