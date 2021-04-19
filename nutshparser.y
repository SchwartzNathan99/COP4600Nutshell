%{
// This is ONLY a demo micro-shell whose purpose is to illustrate the need for and how to handle nested alias substitutions and how to use Flex start conditions.
// This is to help students learn these specific capabilities, the code is by far not a complete nutshell by any means.
// Only "alias name word", "cd word", and "bye" run.
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "global.h"

int yylex(void);
int yyerror(char *s);
int runCD(char* arg);
int runSetAlias(char *name, char *word);
int reassign(char *variable, char *word);
int runPrintenv();
%}

%union {char *string;}

%start cmd_line
%token <string> BYE CD STRING ALIAS	SETENV PRINTENV UNSETENV END


%%
cmd_line    :
	BYE END 		                {exit(1); return 1; }
	| CD STRING END        			{runCD($2); return 1;}
	| ALIAS STRING STRING END		{runSetAlias($2, $3); return 1;}
	| SETENV STRING STRING END      {reassign($2, $3); return 1;}
	| PRINTENV END                  {runPrintenv(); return 1; }
	| UNSETENV STRING END           {reassign($2, ""); return 1; }
	| UNALIAS STRING END				{runRemoveAlias($2); return 1;}
	| ALIAS END						{runGetAlias(); return 1;}
%%

int yyerror(char *s) {
  printf("%s\n",s);
  return 0;
  }

int runCD(char* arg) {
	if (arg[0] != '/') { // arg is relative path
		strcat(varTable.word[0], "/");
		strcat(varTable.word[0], arg);

		if(chdir(varTable.word[0]) == 0) {
			return 1;
		}
		else {
			getcwd(cwd, sizeof(cwd));
			strcpy(varTable.word[0], cwd);
			printf("Directory not found\n");
			return 1;
		}
	}
	else { // arg is absolute path
		if(chdir(arg) == 0){
			strcpy(varTable.word[0], arg);
			return 1;
		}
		else {
			printf("Directory not found\n");
                       	return 1;
		}
	}
}

int runSetAlias(char *name, char *word) {
	for (int i = 0; i < aliasIndex; i++) {
		if(strcmp(name, word) == 0){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if((strcmp(aliasTable.name[i], name) == 0) && (strcmp(aliasTable.word[i], word) == 0)){
			printf("Error, expansion of \"%s\" would create a loop.\n", name);
			return 1;
		}
		else if(strcmp(aliasTable.name[i], name) == 0) {
			strcpy(aliasTable.word[i], word);
			return 1;
		}
	}
	strcpy(aliasTable.name[aliasIndex], name);
	strcpy(aliasTable.word[aliasIndex], word);
	aliasIndex++;

	return 1;
}

int reassign(char *variable, char *word)
{
	for(int i = 0; i < varIndex; i++)
	{
		if (strcmp(varTable.var[i], variable) == 0)
		{
			printf("match found");
			strcpy(varTable.word[i], word);
			break;
		}
	}
	return 1;
}
int runPrintenv()
{
	for(int i = 0; i < varIndex; i++)
	{
		printf(varTable.var[i]);
		 printf("=");
		 printf(varTable.word[i]);
		 printf("\n");
	}
  
int runGetAlias() {
	for (int i = 0; i < aliasIndex; i++)
	{
		printf("Alias Name: %s\n", aliasTable.name[i]);
		printf("Alias Word: %s\n", aliasTable.word[i]);
	}

	return 1;
}

int runRemoveAlias(char *name) {
	int pos;

	for (int i = 0; i < aliasIndex; i++) {
		if(strcmp(aliasTable.name[i], name) == 0) {
			pos = i;
			return 1;
		}
	}

	for(int i = pos; i < aliasIndex; i++)
	{
		strcpy(aliasTable.name[i], aliasTable.name[i+1]);
		strcpy(aliasTable.word[i], aliasTable.word[i+1]);
	}

	aliasIndex--;
	return 1;
}