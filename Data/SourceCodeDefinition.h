//
//  SourceCodeDefinition.h
//  PocketCoder
//
//  Created by VRS on 24/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Initial code template

#define TEMPL_ADA @"With Ada.Text_IO; Use Ada.Text_IO;\nWith Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;\n\n-- your code goes here"
#define TEMPL_ASM_NASM207 @"global _start\n\nsection .data\n\nsection .text\n\n_start:\n; your code goes here\nje		exit\n\nexit:\nmov		eax, 01h		; exit()\nxor		ebx, ebx		; errno\nint		80h"
#define TEMPL_ASM_GCC472 @".data\n\n.text\n\n.global main\nmain:       # int main()\n            # {\n\n# your code goes here\n\nxor	%eax, %eax		# return 0;\nret\n# }"
#define TEMPL_AWK_GAWK @"BEGIN {\n    // your code goes here\n}\n\n{\n    // your code goes here\n}\n\nEND {\n    // your code goes here\n}"
#define TEMPL_AWK_MAWK TEMPL_AWK_GAWK
#define TEMPL_BASH @"#!/bin/bash\n# your code goes here"
#define TEMPL_EMPTY_BC @"/* write your code below */\n"
#define TEMPL_EMPTY_BRAINFUCK TEMPL_EMPTY_BC
#define TEMPL_C @"#include <stdio.h>\n\nint main(void) {\n    // your code goes here\n    return 0;\n}"
#define TEMPL_C_SHARP @"using System;\n\npublic class Test\n{\n    public static void Main()\n    {\n        // your code goes here\n}\n}"
#define TEMPL_CPP_432 @"#include <iostream>\nusing namespace std;\n\nint main() {\n    // your code goes here\n    return 0;\n}"
#define TEMPL_CPP_481 TEMPL_CPP_432
#define TEMPL_CPP11 TEMPL_CPP_432
#define TEMPL_C99 @"#include <stdio.h>\n\nint main(void) {\n    // your code goes here\n    return 0;\n}"
#define TEMPL_CLIPS @"; your code goes here\n\n(exit)\n; empty line at the end"
#define TEMPL_EMPTY_CLOJURE @"; your code goes here\n"
#define TEMPL_COBOL @"IDENTIFICATION DIVISION.\nPROGRAM-ID. IDEONE.\n\nENVIRONMENT DIVISION.\n\nDATA DIVISION.\n\nPROCEDURE DIVISION.\n*>	your code goes here\nSTOP RUN."
#define TEMPL_COBOL85 @"IDENTIFICATION DIVISION.\nPROGRAM-ID. IDEONE.\n\nENVIRONMENT DIVISION.\n\nDATA DIVISION.\n\nPROCEDURE DIVISION.\n*>	your code goes here\nSTOP RUN.\n*> empty line at the end"
#define TEMPL_CLISP @"; your code goes here\n\n(exit)\n; empty line at the end"
#define TEMPL_EMPTY_D_DMD @""
#define TEMPL_ERLANG @"-module(prog).\n-export([main/0]).\n\nmain() ->\n% your code goes here\ntrue."
#define TEMPL_F_SHARP @"open System\n\n// your code goes here\n"
#define TEMPL_FACTOR @"USE: io\nIN: hello-world\n\n: hello ( -- )\n! your code goes here\n;\n\nMAIN: hello\nhello"
#define TEMPL_EMPTY_FALCON @"// your code goes here\n"
#define TEMPL_EMPTY_FORTH @"( your code goes here )"
#define TEMPL_FORTRAN @"program TEST\n    ! your code goes here\n    stop\nend"
#define TEMPL_GO @"package main\nimport \"fmt\"\n\nfunc main(){\n    // your code goes here\n}"
#define TEMPL_EMPTY_GROOVY @"// your code goes here\n"
#define TEMPL_HASKELL @"main = -- your code goes here"
#define TEMPL_ICON @"procedure main()\n# your code goes here\nend"
#define TEMPL_INTERCAL TEMPL_ICON
#define TEMPL_JAVA @"/* package whatever; // don't place package name! */\n\nimport java.util.*;\nimport java.lang.*;\nimport java.io.*;\n\n/* Name of the class has to be \"Main\" only if the class is public. */\nclass Ideone\n{\n    public static void main (String[] args) throws java.lang.Exception\n    {\n        // your code goes here\n    }\n}"
#define TEMPL_JAVA7 TEMPL_JAVA
#define TEMPL_JAVASCRIPT_RHINO @"importPackage(java.io);\nimportPackage(java.lang);\n\n// your code goes here"
#define TEMPL_EMPTY_JAVASCRIPT_SPIDER @"// your code goes here"
#define TEMPL_EMPTY_LUA @"-- your code goes here"
#define TEMPL_NEMERLE @"using System;\npublic class Test\n{\n    public static Main() : void\n    {\n        // your code goes here\n    }\n}"
#define TEMPL_NICE @"void main (String[] args)\n{\n    // your code goes here\n}"
#define TEMPL_EMPTY_NIMROD @"# your code goes here\n"
#define TEMPL_NODE_JS @"process.stdin.resume();\nprocess.stdin.setEncoding('utf8');\n\n// your code goes here\n"
#define TEMPL_OBJ_C @"#import <objc/objc.h>\n#import <objc/Object.h>\n\n@implementation TestObj\nint main()\n{\n    // your code goes here\n    return 0;\n}\n@end"
#define TEMPL_EMPTY_OCAML @"(* your code goes here *)\n"
#define TEMPL_EMPTY_OCTAVE @"# your code goes here\n"
#define TEMPL_OZ @"functor\nimport\nApplication\nSystem\n\ndefine\n% your code goes here\n{Application.exit 0}\nend"
#define TEMPL_EMPTY_PARI_GP @"\\ your code goes here"
#define TEMPL_PASCAL_FPC @"program ideone;\nbegin\n\n(* your code goes here *)\n\nend."
#define TEMPL_PASCAL_GPC TEMPL_PASCAL_FPC
#define TEMPL_PERL @"#!/usr/bin/perl\n# your code goes here"
#define TEMPL_PERL_6 TEMPL_PERL
#define TEMPL_PHP @"<?php\n\n// your code goes here\n\n?>"
#define TEMPL_PIKE @"int main() {\n// your code goes here\n}"
#define TEMPL_PROLOG_GNU @""
#define TEMPL_PROlOG_SWI @":- set_prolog_flag(verbose,silent).\n:- prompt(_, '').\n:- use_module(library(readutil)).\n\nmain:-\n    process,\n    halt.\n\nprocess:-\n    /* your code goes here */\n    true.\n\n:- main."
#define TEMPL_EMPTY_PYTHON @"# your code goes here\n"
#define TEMPL_EMPTY_PYTHON3 TEMPL_EMPTY_PYTHON
#define TEMPL_EMPTY_R @"# your code goes here\n"
#define TEMPL_EMPTY_RUBY @"# your code goes here\n"
#define TEMPL_SCALA @"object Main extends App {\n// your code goes here\n}"
#define TEMPL_EMPTY_SCHEME @"; your code goes here\n"
#define TEMPL_EMPTY_SMALLTALK @"\"your code goes here\"\n"
#define TEMPL_EMPTY_SQL @"-- your code goes here"
#define TEMPL_EMPTY_TCL @";# your code goes here"
#define TEMPL_EMPTY_TEXT @"your text goes here"
#define TEMPL_EMPTY_UNLAMBDA @"your text goes here"
#define TEMPL_VB_NET @"Imports System\n\nPublic Class Test\n    Public Shared Sub Main()\n        ' your code goes here\n    End Sub\nEnd Class"
#define TEMPL_EMPTY_WHITESPACE @""


#pragma mark HelloWorld

#define HW_ADA @"with Ada.Text_IO;\n\nprocedure Hello_World is\n  use Ada.Text_IO;\nbegin\n  Put_Line(\"Hello, world!\");\nend;"
#define HW_ASM_NASM207 @"global _start\nsection .data\nsection .text\n\n_start:\n    je  exit\n\nexit:\n    mov    eax,  01h\n    xor    ebx,  ebx\n    int    80h"
#define HW_ASM_GCC472 @".data\nx:\n    .string \"Hello \"\ns:\n    .string \"world!\\n\\0\"\n.text\n.global main\nmain:\n    pushl  $x\n    call  printf\n    pushl  $s\n    call  printf\n    addl  $8,  %esp\n\nbreak:\n    xor  %eax,  %eax\n    ret"
#define HW_AWK_GAWK @"BEGIN {\n}\n\n{\n\n}\n\nEND {\n}"
#define HW_AWK_MAWK @"BEGIN {\n\n    print \"Hello, world!\"\n\n}"
#define HW_BASH @"#!/bin/bash\n\necho Hello, world!"
#define HW_BC @"x = 5;\n\n/* multiplication table */\nfor (i=1; i<=x; ++i) {\n    for (j=1; j<=x; ++j)\n        print i*j, \"\\t\"\n    print \"\\n\"\n}\n\n/* compute the pi number accurately to 5 decimal places */\nscale=x\nprint \"\\npi = \", 4*a(1), \"\\n\"\n\n/* factorial */\ndefine f(n) {\n    if (n <= 1)\n        return 1;\n    return n * f(n-1);\n}\n\nprint \"\\n\";\nprint \"1! = \", f(1), \"\\n\";\nprint \"5! = \", f(5), \"\\n\";\nprint x, \"! = \", f(x), \"\\n\";"
#define HW_BRAINFUCK @"+++++ +++++ [ > +++++ ++  > +++++ +++++ > +++ > + <<<< - ] > ++ . > + . +++++ ++ . . +++ . > ++ . << +++++ +++++ +++++ . > . +++ . ----- - . ----- --- . > + . > ."
#define HW_C @"#include <stdio.h>\n\nint main(int argc, char *argv[]) {\n    printf(\"Hello, world!\\n\");\n    return 0;\n}"
#define HW_C_SHARP @"using System;\n\nclass Program {\n    public static void Main() {\n        Console.WriteLine(\"Hello, world!\");\n    }\n}"
#define HW_CPP_432 @"#include <iostream>\n\nint main() {\n\n    std::cout << \"Hello, World.\";\n    return 0;\n\n}"
#define HW_CPP_481 @"#include <iostream>\n\nint main() {\n\n    std::cout << \"Hello, World.\";\n    return 0;\n\n}"
#define HW_CPP11 @"#include <iostream>\nusing namespace std;\n\nint main() {\n  auto func = [] () {\n    cout << \"Hello world\";\n  };\n  func();\n}"
#define HW_C99 @"#include <stdio.h>\n\nint main(void)\n{\n    puts(\"Hello World!\");\n}"
#define HW_CLIPS @"(printout t \"Hello World!\" crlf)"
#define HW_CLOJURE @"(println \"Hello world!\")"
#define HW_COBOL @"program-id. hello.\nprocedure division.\n    display \"Hello World!\".\n    stop run."
#define HW_COBOL85 @"identification division.\nprogram-id. SimpleHelloWorld.\n\nprocedure division.\n000-Main.\n    display 'Hello World'.\n    stop run.\n"
#define HW_CLISP @"(format t \"Hello, world!~%\")"
#define HW_D_DMD @"import std.stdio;\n\nvoid main()\n{\n    writeln(\"Hello, world!\");\n}"
#define HW_ERLANG @"-module(prog).\n-export([main/0]).\n\nmain() ->\n    io:fwrite(\"Hello, world!\")."
#define HW_F_SHARP @"printfn \"Hello, world!\""
#define HW_FACTOR @"USE: io\n\n\"Hello, World!\" print"
#define HW_FALCON @"printl( \"Hello, world!\" )"
#define HW_FORTH @".\" Hello, world! \""
#define HW_FORTRAN @"program hello\n    write (*,*) 'Hello, world!'\nend program hello"
#define HW_GO @"package main\nimport \"fmt\"\n\nfunc main() {\n    fmt.Printf(\"Hello, World\")\n}"
#define HW_GROOVY @"println \"Hello, world!\""
#define HW_HASKELL @"main = putStrLn \"Hello, world!\""
#define HW_ICON @"procedure main(args)\n    write(\"Hello, World!\");\nend"
#define HW_INTERCAL @""
#define HW_JAVA @"/* package whatever; // don't place package name! */\n\nimport java.util.*;\nimport java.lang.*;\nimport java.io.*;\n\n/* Name of the class has to be \"Main\" only if the class is public. */\nclass Ideone\n{\n	public static void main (String[] args) throws java.lang.Exception\n	{\n		System.out.println(\"Hello World!\");\n	}\n}"
#define HW_JAVA7 HW_JAVA
#define HW_JAVASCRIPT_RHINO @"importPackage(java.io);\nimportPackage(java.lang);\n\nprint('Hello, World!');"
#define HW_JAVASCRIPT_SPIDER @"print('Hello, World!');"
#define HW_LUA @"print \"Hello World!\""
#define HW_NEMERLE @"using System;\npublic class Test\n{\n    public static Main() : void\n    {\n        System.Console.WriteLine (\"Hello, World!\");\n    }\n}"
#define HW_NICE @"void main (String[] args)\n{\n    System.out.println(\"Hello, World!\");\n}"
#define HW_NIMROD @"echo(\"Hello, World!\")\n"
#define HW_NODE_JS @"process.stdin.resume();\nprocess.stdin.setEncoding('utf8');\n\nconsole.log(\"Hello, world!\");\n"
#define HW_OBJ_C @"#import <objc/objc.h>\n#import <objc/Object.h>\n\n@implementation TestObj\nint main()\n{\n    printf(\"Hello, World!\");\n    return 0;\n}\n@end"
#define HW_OCAML @"print_endline \"Hello, World!\"\n"
#define HW_OCTAVE @"disp(\"Hello, World!\");\n"
#define HW_OZ @"functor\nimport\nApplication\nSystem\n\ndefine\n{Show \"Hello, World!\"}\n{Application.exit 0}\nend"
#define HW_PARI_GP @"print(\"Hello, world!\")"
#define HW_PASCAL_FPC @"program ideone;\nbegin\n\nwriteln('Hello, world!');\n\nend."
#define HW_PASCAL_GPC HW_PASCAL_FPC
#define HW_PERL @"#!/usr/bin/perl\nprint \"Hello, world!\\n";
#define HW_PERL_6 HW_PERL
#define HW_PHP @"<?php\n\necho \"Hello, world!\n\";\n\n?>"
#define HW_PIKE @"int main() {\nwrite(\"Hello, world!\\n\");\n}"
#define HW_PROLOG_GNU @""
#define HW_PROlOG_SWI @":- set_prolog_flag(verbose,silent).\n:- prompt(_, '').\n:- use_module(library(readutil)).\n\nmain:-\n    process,\n    halt.\n\nprocess:- write('Hello, world!'), nl.\n    true.\n\n:- main."
#define HW_PYTHON @"print \"Hello, World!\"\n"
#define HW_PYTHON3 @"print(\"Hello, World!\")"
#define HW_R @"cat(\"Hello, World!\\n\")"
#define HW_RUBY @"puts \"Hello, World!\""
#define HW_SCALA @"object Main extends App {\nprintln(\"Hello, World!\")\n}"
#define HW_SCHEME @"(display \"Hello, World!\")\n(newline)"
#define HW_SMALLTALK @"Transcript show: 'Hello, World!'; cr.\n"
#define HW_SQL @"create table tbl(str varchar(20));\ninsert into tbl values('Hello world!');\nselect * from tbl;"
#define HW_TCL @"puts \"Hello, World!\""
#define HW_TEXT @"out:\"Hello, World\""
#define HW_UNLAMBDA @"`r`````````````.H.e.l.l.o.,. .W.o.r.l.d.!i"
#define HW_VB_NET @"Imports System\n\nPublic Class Test\n    Public Shared Sub Main()\n        Console.WriteLine (\"Hello, World!\")\n    End Sub\nEnd Class"
#define HW_WHITESPACE @""