import std.stdio;
import std.string;
import std.algorithm : moveAll;

const int subtask = 2;

T pop_front(T)(ref T[] xs) {
    T x = xs[0];
    moveAll(xs[1 .. $], xs[0 .. $-1]);
    --xs.length;
    return x;
}
void push_back(T)(ref T[] xs, T x) {
    xs ~= x;
}

void main() {
    auto f = File("input/day12.in");
    string s;

    foreach (line ; f.byLine) {
        s ~= line;
        s ~= "\n";
    }
    f.close();
    auto t = splitLines(s);
    
    int endI, endJ;

    int[][] dist = new int[][](t.length, t[0].length);
    int[] queueI = [];
    int[] queueJ = [];
    
    for(int i=0;i<t.length;i++) {
        for(int j=0; j<t[0].length; j++) {
            if(t[i][j] == 'S' || (subtask == 2 && t[i][j] == 'a')) {
                queueI.push_back(i);
                queueJ.push_back(j);
                dist[i][j] = 1;
            }
            if(t[i][j] == 'E')
                endI = i, endJ = j;
        }
    }

    int[] px = [1,-1,0,0];
    int[] py = [0,0,1,-1];

    while(!queueI.empty) {
        int i = queueI.pop_front();
        int j = queueJ.pop_front();
        for(int z=0;z<4;z++) {
            int i2 = i+px[z];
            int j2 = j+py[z];

            if(i2 >= 0 && j2 >=0 && i2 < t.length && j2 < t[i2].length) {
                if(dist[i2][j2] == 0 && (t[i2][j2] == 'E' ? 'z' : t[i2][j2])-(t[i][j] == 'S' ? 'a' : t[i][j]) <= 1) {
                    dist[i2][j2] = dist[i][j]+1;
                    queueI.push_back(i2);
                    queueJ.push_back(j2);
                }
            }
        }
    }
    writeln(dist[endI][endJ]-1);
}