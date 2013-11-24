//
//  SourceCodeDefinition.h
//  PocketCoder
//
//  Created by VRS on 24/11/13.
//  Copyright (c) 2013 Viktor Sydorenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEMPL_ADA @"With Ada.Text_IO; Use Ada.Text_IO;\nWith Ada.Integer_Text_IO; Use Ada.Integer_Text_IO;\n\n-- your code goes here"
#define TEMPL_ASM_NASM207 @"global _start\n\nsection .data\n\nsection .text\n\n_start:\n; your code goes here\nje		exit\n\nexit:\nmov		eax, 01h		; exit()\nxor		ebx, ebx		; errno\nint		80h"
#define TEMPL_ASM_GCC472 @".data\n\n.text\n\n.global main\nmain:       # int main()\n            # {\n\n# your code goes here\n\nxor	%eax, %eax		# return 0;\nret\n# }"
#define TEMPL_AWK_GAWK @"BEGIN {\n    // your code goes here\n}\n\n{\n    // your code goes here\n}\n\nEND {\n    // your code goes here\n}"
#define TEMPL_AWK_MAWK TEMPL_AWK_GAWK
#define TEMPL_BASH @"#!/bin/bash\n# your code goes here"
#define TEMPL_BC @"/* write your code below */\n"
#define TEMPL_BRAINFUCK TEMPL_BC
#define TEMPL_C @"#include <stdio.h>\n\nint main(void) {\n    // your code goes here\n    return 0;\n}"
#define TEMPL_C_SHARP @"using System;\n\npublic class Test\n{\n    public static void Main()\n    {\n        // your code goes here\n}\n}"
#define TEMPL_CPP @"#include <iostream>\nusing namespace std;\n\nint main() {\n    // your code goes here\n    return 0;\n}"
#define TEMPL_CPP11 TEMPL_CPP
#define TEMPL_C99 @"#include <stdio.h>\n\nint main(void) {\n    // your code goes here\n    return 0;\n}"
#define TEMPL_CLIPS @"; your code goes here\n\n(exit)\n; empty line at the end"
#define TEMPL_CLOJURE @"; your code goes here\n"
#define TEMPL_COBOL @"IDENTIFICATION DIVISION.\nPROGRAM-ID. IDEONE.\n\nENVIRONMENT DIVISION.\n\nDATA DIVISION.\n\nPROCEDURE DIVISION.\n*>	your code goes here\nSTOP RUN."
#define TEMPL_COBOL85 @"IDENTIFICATION DIVISION.\nPROGRAM-ID. IDEONE.\n\nENVIRONMENT DIVISION.\n\nDATA DIVISION.\n\nPROCEDURE DIVISION.\n*>	your code goes here\nSTOP RUN.\n*> empty line at the end"
#define TEMPL_CLISP @"; your code goes here\n\n(exit)\n; empty line at the end"
#define TEMPL_D_DMD @""
#define TEMPL_ERLANG @"-module(prog).\n-export([main/0]).\n\nmain() ->\n% your code goes here\ntrue."
#define TEMPL_F_SHARP @"open System\n\n// your code goes here\n"
#define TEMPL_FACTOR @"USE: io\nIN: hello-world\n\n: hello ( -- )\n! your code goes here\n;\n\nMAIN: hello\nhello"
#define TEMPL_FALCON @"// your code goes here\n"
#define TEMPL_FORTH @"( your code goes here )"
#define TEMPL_FORTRAN @"program TEST\n    ! your code goes here\n    stop\nend"
#define TEMPL_GO @"package main\nimport \"fmt\"\n\nfunc main(){\n    // your code goes here\n}"
#define TEMPL_GROOVY @"// your code goes here\n"
#define TEMPL_HASKELL @"main = -- your code goes here"
#define TEMPL_ICON @"procedure main()\n# your code goes here\nend"
#define TEMPL_INTERCAL TEMPL_ICON
#define TEMPL_JAVA @"/* package whatever; // don't place package name! */\n\nimport java.util.*;\nimport java.lang.*;\nimport java.io.*;\n\n/* Name of the class has to be \"Main\" only if the class is public. */\nclass Ideone\n{\n    public static void main (String[] args) throws java.lang.Exception\n    {\n        // your code goes here\n    }\n}"
#define TEMPL_JAVA7 TEMPL_JAVA
#define TEMPL_JAVASCRIPT_RHINO @"importPackage(java.io);\nimportPackage(java.lang);\n\n// your code goes here"
#define TEMPL_JAVASCRIPT_SPIDER @"// your code goes here"
#define TEMPL_LUA @"-- your code goes here"
#define TEMPL_NEMERLE @"using System;\npublic class Test\n{\n    public static Main() : void\n    {\n        // your code goes here\n    }\n}"
#define TEMPL_NICE @"void main (String[] args)\n{\n    // your code goes here\n}"
#define TEMPL_NIMROD @"# your code goes here\n"
#define TEMPL_NODE_JS @"process.stdin.resume();\nprocess.stdin.setEncoding('utf8');\n\n// your code goes here\n"
#define TEMPL_OBJ_C @"#import <objc/objc.h>\n#import <objc/Object.h>\n\n@implementation TestObj\nint main()\n{\n    // your code goes here\n    return 0;\n}\n@end"
#define TEMPL_OCAML @"(* your code goes here *)\n"
#define TEMPL_OCTAVE @"# your code goes here\n"
#define TEMPL_OZ @"functor\nimport\nApplication\nSystem\n\ndefine\n% your code goes here\n{Application.exit 0}\nend"
#define TEMPL_PARI_GP @"\\ your code goes here"
#define TEMPL_PASCAL_FPC @"program ideone;\nbegin\n\n(* your code goes here *)\n\nend."
#define TEMPL_PASCAL_GPC TEMPL_PASCAL_FPC
#define TEMPL_PERL @"#!/usr/bin/perl\n# your code goes here"
#define TEMPL_PERL_6 TEMPL_PERL
#define TEMPL_PHP @"<?php\n\n// your code goes here"
#define TEMPL_PIKE @"int main() {\n// your code goes here\n}"
#define TEMPL_PROLOG_GNU @"int main() {\n// your code goes here\n}"
#define TEMPL_PROlOG_SWI @":- set_prolog_flag(verbose,silent).\n:- prompt(_, '').\n:- use_module(library(readutil)).\n\nmain:-\n    process,\n    halt.\n\nprocess:-\n    /* your code goes here */\n    true.\n\n:- main."
#define TEMPL_PYTHON @"# your code goes here\n"
#define TEMPL_PYTHON3 TEMPL_PYTHON
#define TEMPL_R @"# your code goes here\n"
#define TEMPL_RUBY @"# your code goes here\n"
#define TEMPL_SCALA @"object Main extends App {\n// your code goes here\n}"
#define TEMPL_SCHEME @"; your code goes here\n"
#define TEMPL_SMALLTALK @"\"your code goes here\"\n"
#define TEMPL_SQL @"-- your code goes here"
#define TEMPL_TCL @";# your code goes here"
#define TEMPL_TEXT @"your text goes here"
#define TEMPL_UNLAMBDA @"your text goes here"
#define TEMPL_VB_NET @"Imports System\n\nPublic Class Test\n    Public Shared Sub Main()\n        ' your code goes here\n    End Sub\nEnd Class"
#define TEMPL_WHITESPACE @""