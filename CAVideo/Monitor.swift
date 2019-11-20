class Monitor {

var n：Int
var e：Double

init(n:Int,e:Double) {

    self.n = n
    self.e = e
}
	
func checkException(v:Int) ->Bool {
  if n*v >=e {
     return false;
   }
  return true;
}	
}
