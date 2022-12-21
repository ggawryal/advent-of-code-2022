// scala day15.scala && scala -J-Xmx4g Day15
import scala.io.Source
import scala.collection.mutable.HashSet
object Day16 {
    def main(args: Array[String]) = {
        val boundary = 4000000
        val targetY = boundary / 2
        val markedX: HashSet[Int] = HashSet()
        val onTheLine: HashSet[Int] = HashSet()


        var data : List[(Int, Int, Int, Int)] = List()

        val filename = "input/day15.in"
        for(line <- Source.fromFile(filename).getLines) {
            val regex = raw"=(\d+|-\d+)".r
            val coords = (for (m <- regex.findAllMatchIn(line)) yield m.group(1).toInt).toList
            data = data:+(coords(0), coords(1), coords(2), coords(3))
        }

        for((x,y,x2,y2) <- data) {
             if(y2 == targetY) {
                onTheLine += x2
            }

            val dist = (y2-y).abs + (x2-x).abs
            val r = dist-(targetY-y).abs
            ((x-r) to (x+r) foreach {(it: Int) => markedX += it})
        }
        println(markedX.size-onTheLine.size)

        val toCheck: HashSet[(Int,Int)] = HashSet()
        val beacons: HashSet[(Int,Int)] = HashSet()
        for((x,y,x2,y2) <- data) {
            val dist = (y2-y).abs + (x2-x).abs
            beacons += ((x2,y2))
            (x-dist-1).max(0) to (x+dist+1).min(boundary) foreach {
                (it: Int) => {
                    toCheck += ((it, y+(dist+1-(it-x).abs)))
                    toCheck += ((it, y-(dist+1-(it-x).abs)))
                }
            }
        }
        for ((p,q) <- toCheck --= beacons) {
            if(q >= 0 && q <= boundary) {
                var bad = false
                for((x,y,x2,y2) <- data) {
                    bad |= (y2-y).abs + (x2-x).abs >= (q-y).abs + (p-x).abs
                }
                if(!bad) {
                    println(p*1L*boundary+q)
                }
            }
        }

    }
}
