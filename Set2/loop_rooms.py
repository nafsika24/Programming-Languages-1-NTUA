
# The solution code is taken from this website (we changed only the input): https://www.geeksforgeeks.org/print-nodes-which-are-not-part-of-any-cycle-in-a-directed-graph/?ref=rp
# Python3 program for the above approach
import sys
sys.setrecursionlimit(15000) 
counter = 0
class Graph:
    def __init__(self, V):
        self.V = V
        self.adj = [[] for i in range(self.V)]
 
    def addEdge(self, v, w):    
        self.adj[v].append(w)
 
    # Function to perform DFS Traversal
    # and return True if current node v
    # formes cycle
    def printNodesNotInCycleUtil(self, v, visited,recStack, cyclePart):
 
        # If node v is unvisited
        if (visited[v] == False):
 
            # Mark the current node as
            # visited and part of
            # recursion stack
            visited[v] = True
            recStack[v] = True
 
            # Traverse the Adjacency
            # List of current node v
            for child in self.adj[v]:
 
                # If child node is unvisited
                if (not visited[child] and self.printNodesNotInCycleUtil(child, visited,recStack, cyclePart)):
 
                    # If child node is a part
                    # of cycle node
                    cyclePart[child] = 1
                    return True
 
                # If child node is visited
                elif (recStack[child]):
                    cyclePart[child] = 1
                    return True
 
        # Remove vertex from recursion stack
        recStack[v] = False
        return False
 
    # Function that print the nodes for
    # the given directed graph that are
    # not present in any cycle
    def printNodesNotInCycle(self):
 
        # Stores the visited node
        visited = [False for i in range(self.V)]
 
        # Stores nodes in recursion stack
        recStack = [False for i in range(self.V)]
 
        # Stores the nodes that are
        # part of any cycle
        cyclePart = [False for i in range(self.V)]
 
        # Traverse each node
        for i in range(self.V):
 
            # If current node is unvisited
            if (not visited[i]):
 
                # Perform DFS Traversal
                if(self.printNodesNotInCycleUtil(
                        i, visited, recStack,
                        cyclePart)):
 
                    # Mark as cycle node
                    # if it return True
                    cyclePart[i] = 1                 
        for i in range(self.V):
            if(cyclePart[i] == 0):
                global counter 
                counter += 1 
    # Driver Code

if __name__== '__main__':

    input_file = sys.argv[1]
    inp = open(input_file,'r')
    maze = inp.read().split('\n')[:]
    pos = maze.pop(0).split(' ')
    x = 0
    N , M = int(pos[0]) , int(pos[1])
    t = [[-1 for i in range(M)] for j in range(N)]
    for i in range(N):
        for j in range(M):
            t[i][j] = x          
            x = x + 1

    g = Graph(N*M)

    for i in range(N):
        for j in range(M):
            if(maze[i][j] == 'U'):
                if(i != 0):
                    g.addEdge(t[i][j],t[i-1][j])
            if(maze[i][j] == 'D'):
                if(i!=N-1):
                    g.addEdge(t[i][j],t[i+1][j])
            if(maze[i][j] == 'L'):
                if(j!=0):
                    g.addEdge(t[i][j],t[i][j-1])
            if(maze[i][j] == 'R'):
                if(j!=M-1):
                    g.addEdge(t[i][j],t[i][j+1])     
    g.printNodesNotInCycle()
    result = N*M -  counter 
    print(result)