#import,file "module.jai";
#import "Basic";

decl_example :: () {
	a, b := 10, "abcdef";
	//             proc & data names---+        +---captured identifiers
	//								   |	    |		+--procedure header		   +-- procedure body
	// 								   |        |		|						   |
	//                                 V        V       V						   V	
	#insert #run decl_lambda(#code {proc; data; a; b; (x : int, y := 20) -> (int); {
		print("hello from lambda!\n");
		print("args: x = %, y = %; captured: a = %, b = %\n", x, y, <<_a, <<_b);
		<<_a += 1;
		return x + y + <<_a;
	}});

	//	Here is how it will be expanded:

	//	proc, data := (x : int, y := 20, __data : *void) -> int {
	//		using cast(*struct{_a:*int;_b:*string;}) __data;
	// 		print("hello from lambda!\n");
	// 		print("args: x = %, y = %; captured: a = %, b = %\n", x, y, <<_a, <<_b);
	// 		<<_a += 1;
	// 		return x + y + <<_a;	
	//	}, *((struct{_a:*type_of(a);_b:*type_of(b);}).{*a, *b});

	proc(1, 2, data);
	proc(1, 2, data);
	result := proc(1, 2, data);
	print("result = %\n", result);
}

set_example :: () {
	a, b := 10, "abcdef";

	l : struct {
		proc : (int, int, *void)->(int);
		data : *void;		
	}

	// older version / version for non-structured lambdas

	//	assign_lambda(#code {l.proc; l.data; a; b; (x : int, y := 20) -> (int); {
	// 		print("hello from lambda!\n");
	// 		print("args: x = %, y = %; captured: a = %, b = %\n", x, y, <<_a, <<_b);
	// 		<<_a += 1;
	// 		return x + y + <<_a;
	// 	}});

	// for now, works only if struct has fields named exactly "proc" and "data"
	struct_lambda(#code {l; a; b; (x : int, y := 20) -> (int); {
		print("hello from lambda!\n");
		print("args: x = %, y = %; captured: a = %, b = %\n", x, y, <<_a, <<_b);
		<<_a += 1;
		return x + y + <<_a;
	}});

	l.proc(1, 2, l.data);
	l.proc(1, 2, l.data);
	result := l.proc(1, 2, l.data);
	print("result = %\n", result);	
}

#import "Compiler";
test_cto :: () -> Code {
	code :: #code A := x;
	root, nodes := compiler_get_nodes(code);
	return compiler_get_code(root);
}
test :: (parent_scope := #caller_code) -> Code #expand {
	#insert,scope(parent_scope) #run test_cto();
}

main :: () {
	// aptr : *int;
	// if false {

	// } else {
	// 	x := 20;
	// 	aptr = *x;
	// }
	// y := 15;
	// print("x = %", <<aptr);
	// x := 10;
	// test();
	decl_example();
	set_example();
}