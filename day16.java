package com.aoc.day16;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.HashMap; 
import java.util.List; 
import java.util.stream.IntStream; 
import java.util.stream.Collectors;
import java.util.Arrays; 
import java.util.ArrayList; 
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
    public static class Pair<T,S> {
        public Pair(T x, S y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (o == this)
                return true;
            if (!(o instanceof Pair))
                return false;
            Pair other = (Pair)o;
            return other.x.equals(this.x) && other.y.equals(this.y);
        }
        @Override
        public int hashCode() {
            return 31 * x.hashCode() + y.hashCode() + 7;
        }
        T x;
        S y;
    }
    public static void main(String[] args) {
        try {
            Scanner scanner = new Scanner(new File("input/day16.in"));

            HashMap<String, List<String>> g = new HashMap<>();
            HashMap<Integer, Integer> flowRates = new HashMap<>();
            HashMap<String, Integer> nameToId = new HashMap<>();

            int nextBrokenValveId = 100;
            int nextGoodValveId = 0;
            Pattern pattern = Pattern.compile("Valve ([A-Z]*) has flow rate=(\\d*); tunnel\\S* lead\\S* to valve\\S* (.*)");
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                Matcher matcher = pattern.matcher(line);
                matcher.find();
                if(Integer.parseInt(matcher.group(2)) == 0) {
                    nameToId.put(matcher.group(1), nextBrokenValveId);
                    nextBrokenValveId++;
                }
                else {
                    nameToId.put(matcher.group(1), nextGoodValveId);
                    nextGoodValveId++;
                }
                flowRates.put(nameToId.get(matcher.group(1)), Integer.parseInt(matcher.group(2)));
                g.put(matcher.group(1), Arrays.asList(matcher.group(3).split(", ")));
            }
            scanner.close();

            HashMap<Pair<Integer,Integer>, Integer> distances = new HashMap<>();
            for(var i: nameToId.values())
                for(var j: nameToId.values())
                    distances.put(new Pair<>(i,j), i == j ? 0 : 1000);
            for(var name: g.keySet())
                for(var v: g.get(name)) {
                    distances.put(new Pair<>(nameToId.get(name), nameToId.get(v)), 1);
                }

            for(var k: nameToId.values())
                for(var i: nameToId.values())
                    for(var j: nameToId.values())
                        distances.put(new Pair<>(i,j), Integer.min(distances.get(new Pair<>(i,j)), distances.get(new Pair<>(i,k)) + distances.get(new Pair<>(k,j))));

            
            List<Integer> nonZeroValves = IntStream.rangeClosed(0, nextGoodValveId-1).boxed().collect(Collectors.toList());

            System.out.println("Subtask #1: "+solve(distances, flowRates, nonZeroValves, nameToId.get("AA"), 30));
          
            int res2 = 0;
            for(int m=0; m<(1<<nextGoodValveId); m++) {
                final int mask1 = m;
                final int mask2 = ((1<<nextGoodValveId)-1)^m;
                List<Integer> m1Values = IntStream.rangeClosed(0, nextGoodValveId-1).boxed().filter((Integer x) -> (mask1 & (1<<x))>0).collect(Collectors.toList());
                List<Integer> m2Values = IntStream.rangeClosed(0, nextGoodValveId-1).boxed().filter((Integer x) -> (mask2 & (1<<x))>0).collect(Collectors.toList());
                res2 = Integer.max(
                    res2, 
                    solve(distances, flowRates, m1Values, nameToId.get("AA"),26) +
                    solve(distances, flowRates, m2Values, nameToId.get("AA"),26)
                );
            }
            System.out.println("Subtask #2: "+res2);

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }

    private static int solve(HashMap<Pair<Integer,Integer>, Integer> distances, HashMap<Integer, Integer> flowRates, List<Integer> used, int startValveId, int max_days) {
        ArrayList<HashMap<Pair<Integer,Integer>, Integer> > dp = new ArrayList<>(); // dp[time][opened valves bitmask][last opened valve] = max pressure. Only considering good valves (with rate > 0)
        for(int i=0;i<max_days;i++)
            dp.add(new HashMap<>());

        for(int i=0;i<used.size();i++) {
            int d = 1+distances.get(new Pair<>(startValveId, used.get(i)));
            if(d < max_days) 
                dp.get(d).put(new Pair<>(1<<i, i), 0);
        }
        
        int ans = 0;
        for(int time=1;time<max_days;time++) {
            var curDp = dp.get(time);

            for(var k: curDp.keySet()) {
                int gain=0;
                for(int j=0;j<used.size();j++)
                    if((k.x & (1<<j)) > 0) 
                        gain += flowRates.get(used.get(j));
                ans = Integer.max(ans, curDp.get(k) + (max_days-time)*gain);
            }


            for(int mask=1; mask<(1<<used.size()); mask++) {
                if(Integer.bitCount(mask) == 1) continue;
                for(int i=0;i<used.size();i++) {
                    if((mask&(1<<i)) > 0) {
                        int mask2 = mask^(1<<i);
                        int gain = 0;
                        for(int j=0;j<used.size();j++)
                            if((mask2&(1<<j)) > 0)
                                gain += flowRates.get(used.get(j));

                        for(int j=0;j<used.size();j++) {
                            if((mask2&(1<<j)) > 0 && curDp.containsKey(new Pair<>(mask2,j))) {
                                int d = 1 + distances.get(new Pair<>(used.get(j),used.get(i)));
                                if(time + d < max_days) {
                                    var targetDp = dp.get(time + d);
                                    targetDp.put(new Pair<>(mask, i), Integer.max(targetDp.getOrDefault(new Pair<>(mask, i), 0), curDp.getOrDefault(new Pair<>(mask2, j), 0) + gain*d));
                                }
                            }
                        }
                    }
                }
            }
        }
        return ans;
    }

}
