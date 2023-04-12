#import,file "module.jai";
#import "Basic";

main :: () {
	a, b := 10, "abcdef";

	#insert #run decl_lambda(#code {proc; data; a; b; (x : int, y := 20) -> (int); {
		print("hello from lambda!\n");
		print("args: x = %, y = %; captured: a = %, b = %\n", x, y, <<_a, <<_b);
		<<_a += 1;
		return x + y + <<_a;
	}});

	proc(1, 2, data);
	proc(1, 2, data);
	result := proc(1, 2, data);
	print("result = %\n", result);
}