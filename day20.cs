using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Day20AOC {
    class Program {

        static long Solve(long[] numbers, int iterations) {
            List<(long, int)> outputNumbers = numbers.Zip(Enumerable.Range(0, numbers.Length)).ToList();
            for(int _ = 0; _<iterations; _++) {
                for(int i=0; i<numbers.Length; i++) {
                    long v = numbers[i];
                    int pos = outputNumbers.FindIndex(x => x.Item1 == v && x.Item2 == i);
                    outputNumbers.RemoveAt(pos);
                    int newPosition = (int)(((pos+v) % outputNumbers.Count)+ outputNumbers.Count) % outputNumbers.Count;
                    outputNumbers.Insert(newPosition, (v, i));
                }
            }

            int currentPos = outputNumbers.FindIndex(x => x.Item1 == 0);
            long res = 0;
            for(int i = 0; i<3; i++) {
                currentPos = (currentPos+1000)%numbers.Length;
                res += outputNumbers[currentPos].Item1;
            }
            return res;
        }
        static void Main() {
            string[] lines = System.IO.File.ReadAllLines(Path.Join(@"input", @"day20.in"));
            checked {
                long[] numbers = Array.ConvertAll(lines, s => long.Parse(s));
                Console.WriteLine(Solve(numbers,1));

                for(int i=0;i<numbers.Length; i++)
                    numbers[i] *= 811589153L;
                Console.WriteLine(Solve(numbers, 10));
            }
        }
    }
}
