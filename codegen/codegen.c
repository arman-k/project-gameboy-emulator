//This is a generator for various repetitive code and strings related to the opcodes.

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

//Holds properties of an instruction 
struct INSTRUCTION {
	int opcode;			// the opcode of the instruction in hex
	char* mnemonic;		// the mnemonic representation. eg. 'add', 'sub'
	char* operands[2];	// operands of this instruction. non-existent operands are marked null
	int length;			// the length of this instruction in bytes (not quite needed)
	int cycles;			// the number of CPU cycles that this instruction takes
	// 4 bytes representing Z,N,H,C flags
	//Z - Zero flag, N - Subtract flag, H - Half Carry Flag, C - Carry Flag
	//If a flag is not affected by this instruction, it is marked by '-'
	//If a flag is affected by this instruction, it is marked by its corresponding letter, 'Z', 'H', etc
	//If a flag is set by this instruction, it is marked by 1
	//If a flag is reset by this instruction, it is marked by 0
	char flags[4];		
};

void read_opdb(struct INSTRUCTION* inst[], char* filename);
void init_inst(struct INSTRUCTION* inst[], int i);
bool resolve_key_value_pair(struct INSTRUCTION* inst[], int i, char* key, char* value);
void generate_strings(char* filename, struct INSTRUCTION* inst_op[], struct INSTRUCTION* inst_cbop[]);
void g_format_string(FILE* fp, char* str);
void gen_disasm_inst(char* filename, struct INSTRUCTION* inst_op[], struct INSTRUCTION* inst_cbop[]);
int print_push_params(FILE* fp, struct INSTRUCTION* inst[], int i);
char* str_replace(char* str, char* orig, char* replace);
void print_opdb(struct INSTRUCTION* inst[]);

int main(int argc, char* argv[])
{
	struct INSTRUCTION* inst_op[256];	//contains non-prefixed instructions
	struct INSTRUCTION* inst_cbop[256];	//contains prefixed(CB) instructions
	
	if (argc < 3)
	{
		//Display command format
		fprintf(stderr, "Please provide parameters like this: \n> codegen [option] [filename]\n");
		fprintf(stderr, "Available options: \n");
		fprintf(stderr, "-s option generates strings for the disassembler");
		return -1;
	}
	char* option = argv[1];
	char* filename = argv[2];
	
	//Load the instructions from db to memory
	read_opdb(inst_op, "opdb.txt");
	read_opdb(inst_cbop, "opcbdb.txt");
	
	//Generate strings to be used in our disassembler
	if (!strcmp(option, "-s"))
	{
		generate_strings(filename, inst_op, inst_cbop);
	}
	if (!strcmp(option, "-i"))
	{
		gen_disasm_inst(filename, inst_op, inst_cbop);
	}
	
	return 0;
}

//Loads the instructions from db to memory
void read_opdb(struct INSTRUCTION* inst[], char* filename)
{
	int szline = 500;	//size of buffer
	char* line;			//buffer to store a line
	char* key;			//the key part of key-value pairs
	char* value;		//the value part of key-value pairs
	
	//Open the file specified by filename
	FILE* fp = fopen(filename, "r");	
	if (fp == NULL)
	{
		perror("Check if opdb.txt and opcbdb.txt exist in current folder");
		return;
	}
	
	//Allocate memory for buffer
	line = (char*) malloc(szline+1);
	int i;	
	for (i = 0; line && i < 256; i++)
	{
		//Allocate memory for current instruction block
		init_inst(inst, i);		
		for (;;)
		{
			if (fgets(line, szline, fp) == NULL) 
			{
				//If reached end-of-file, break
				free(line);
				line = NULL;
				break;
			}
			if (!strcmp(line, "\n")) break; 		//If newline reached, move on to next instruction block
			if (*line == '/' && *(line+1) == '/') 	//skip comments
			{
				i--;
				break;
			}
			
			key = strtok(line, " ");				//extract key
			value =  strtok(NULL, "\n"); 			//extract value
			//resolve the key/value pair
			if (!resolve_key_value_pair(inst, i, key, value))
			{
				//false is returned if the instruction was invalid
				//the next line therefore should be a newline
				//consume this line to move on to the next instruction block
				fgets(line, szline, fp);			
				break;
			}
		}
	}
	fclose(fp);
}

//Allocates memory for an instruction block and gives the properties default values
void init_inst(struct INSTRUCTION* inst[], int i)
{
	inst[i] = malloc(sizeof(struct INSTRUCTION));
	inst[i]->opcode = 0;
	inst[i]->mnemonic = NULL;
	inst[i]->operands[0] = NULL;
	inst[i]->operands[1] = NULL;
	inst[i]->length = 0;
	inst[i]->flags[0] = '-';
	inst[i]->flags[1] = '-';
	inst[i]->flags[2] = '-';
	inst[i]->flags[3] = '-';
}

//Resolves the key/value pair
bool resolve_key_value_pair(struct INSTRUCTION* inst[], int i, char* key, char* value)
{
	int szmnemonic = 10;	//size of a mnemonic
	int szoperand = 20;		//size of an operand
	
	if (!strcmp(key, "opcode:"))
	{
		//this was not really needed, as the opcodes are generated linearly 
		//from 0x00 to 0xFF. Did it just for the heck of it.
		sscanf(value, "0x%02x", &(inst[i]->opcode));
	}
	else if (!strcmp(key, "mnemonic:"))
	{
		inst[i]->mnemonic = (char*) malloc(szmnemonic+1);
		strncpy(inst[i]->mnemonic, value, szmnemonic);
		//return false if this instruction is invalid
		if (!strcmp(value, "invalid")) return false; 
	}
	else if (!strcmp(key, "operand:") || !strcmp(key, "operand1:"))
	{
		inst[i]->operands[0] = (char*) malloc(szoperand+1);
		strncpy(inst[i]->operands[0], value, szoperand);
	}
	else if (!strcmp(key, "operand2:"))
	{
		inst[i]->operands[1] = (char*) malloc(szoperand+1);
		strncpy(inst[i]->operands[1], value, szoperand);
	}
	else if (!strcmp(key, "length:"))
	{
		inst[i]->length = atoi(value);		//convert the value from string to int
	}
	else if (!strcmp(key, "cycles:"))
	{
		inst[i]->cycles = atoi(value);
	}
	else if (!strcmp(key, "flags:"))
	{
		int j;
		for (j = 0; j < 4; j++) 
		{
			inst[i]->flags[j] = value[j];	//fetch the flags
		}
	}
	
	return true;
}

//Prints a mirror of opdb or opcbdb (without comments)
//Was created initially for testing purposes. Not needed anymore
void print_opdb(struct INSTRUCTION* inst[])
{
	int i;
	for (i = 0; i < 256; i++)
	{
		printf("opcode: 0x%02X\n", inst[i]->opcode);
		printf("mnemonic: %s\n", inst[i]->mnemonic);
		if (!strcmp(inst[i]->mnemonic, "invalid"))
		{
			printf("\n");
			continue;
		}
		
		if (inst[i]->operands[0] != NULL && inst[i]->operands[1] != NULL)
		{
			printf("operand1: %s\n", inst[i]->operands[0]);
			printf("operand2: %s\n", inst[i]->operands[1]);
		}
		
		if (inst[i]->operands[0] != NULL && inst[i]->operands[1] == NULL)
		{
			printf("operand: %s\n", inst[i]->operands[0]);
		}
		
		printf("length: %d\n", inst[i]->length);
		printf("cycles: %d\n", inst[i]->cycles);
		char* f = inst[i]->flags;
		printf("flags: %c%c%c%c\n", f[0], f[1], f[2], f[3]);
		printf("\n");
	}
}

//Generates strings for disassembler
void generate_strings(char* filename, struct INSTRUCTION* inst_op[], struct INSTRUCTION* inst_cbop[])
{
	int i;
	char* tmp;
	FILE* fp = fopen(filename, "w");	
	if (fp == NULL)
	{
		perror("Failed to generate file");
		return;
	}
	
	fprintf(fp, "; This file is auto-generated by codegen. Don't modify it directly\n");
	fprintf(fp, "; Either modify the opcode db or the generation logic in codegen\n");
	fprintf(fp, "; These strings are used by the disassembler (produced by -s)\n\n");
	
	//Generate strings for non-prefixed instructions
	fprintf(fp, "\t; opcode strings\n\t");
	for (i = 0; i < 256; i++)
	{
		if (inst_op[i]->opcode != 0xCB)		//Skip the prefix instruction
		{
			fprintf(fp, ".a%02x db ", i);
			fprintf(fp, "\"%-5s  ", inst_op[i]->mnemonic);
			//format the operands with a format string in case the operand is a 8/16-bit data/address
			if (inst_op[i]->operands[0] != NULL)
				g_format_string(fp, inst_op[i]->operands[0]);				
			if (inst_op[i]->operands[1] != NULL)
			{
				fprintf(fp, ", ");
				g_format_string(fp, inst_op[i]->operands[1]);
			}
			fprintf(fp, "\",0\n\t");
		}
	}
	
	//Generate strings for prefixed(CB) instructions
	fprintf(fp, "\n\t; opcode with prefix 0xCB strings\n\t");
	for (i = 0; i < 256; i++)
	{
		fprintf(fp, ".b%02x db ", i);
		fprintf(fp, "\"%-5s  ", inst_cbop[i]->mnemonic);
		if (inst_cbop[i]->operands[0] != NULL) 
			g_format_string(fp, inst_cbop[i]->operands[0]);				
		if (inst_cbop[i]->operands[1] != NULL)
		{
			fprintf(fp, ", ");
			g_format_string(fp, inst_cbop[i]->operands[1]);
		}
		fprintf(fp, "\",0\n\t");
	}
	
	fclose(fp);
}

//Formats the operands with a format string in case the operand is a 8/16-bit data/address
void g_format_string(FILE* fp, char* str)
{
	if (strstr(str, "d8"))
	{
		fprintf(fp, "%s", str_replace(str, "d8", "0x%02x"));
	}
	else if (strstr(str, "a8"))
	{
		fprintf(fp, "%s", str_replace(str, "a8", "0x%02x"));
	}
	else if (strstr(str, "r8"))
	{
		fprintf(fp, "%s", str_replace(str, "r8", "0x%02x"));
	}
	else if (strstr(str, "d16"))
	{
		fprintf(fp, "%s", str_replace(str, "d16", "0x%02x%02x"));
	}
	else if (strstr(str, "a16"))
	{
		fprintf(fp, "%s", str_replace(str, "a16", "0x%02x%02x"));
	}
	else
	{
		//in case there are no r8, a8, d8, a16, d16 tokens in the operand,
		//print the string without formatting
		fprintf(fp, "%s", str);
	}
}

void gen_disasm_inst(char* filename, struct INSTRUCTION* inst_op[], struct INSTRUCTION* inst_cbop[])
{
	int i;
	int bytes_pushed;
	FILE* fp = fopen(filename, "w");	
	if (fp == NULL)
	{
		perror("Failed to generate file");
		return;
	}
	fprintf(fp, "; This file is auto-generated by codegen. Don't modify it directly\n");
	fprintf(fp, "; Either modify the opcode db or the generation logic in codegen\n");
	fprintf(fp, "; These instructions are used by the disassembler (produced by -i)\n\n");
		
	fprintf(fp, "\t; opcode print instructions\n");
	for (i = 0; i < 256; i++)
	{
		bytes_pushed = 1;
		if (inst_op[i]->opcode != 0xCB)
		{
			fprintf(fp, "@@:\n\t");
			fprintf(fp, "cmp\t\tal, 0x%02x\n\t", i);
			fprintf(fp, "jne\t\t@f\n\t");
			bytes_pushed += print_push_params(fp, inst_op, i);
			fprintf(fp, "push\t.a%02x\n\t", i);
			fprintf(fp, "call\t[printf]\n\t");
			fprintf(fp, "add\t\tesp, 4");
			if (bytes_pushed > 1)
				fprintf(fp, "*%d\n\t", bytes_pushed);
			else
				fprintf(fp, "\n\t");
			fprintf(fp, "mov\t\tesi, dword[ebp+.pc]\n\t");
			fprintf(fp, "add\t\tdword[esi], %d\n\t", bytes_pushed);
			fprintf(fp, "jmp\t\t.exit\n");
		}
	}
	
	fprintf(fp, "\n\t; opcode (with prefix 0xCB) print instructions\n.cb_ops:\n");
	for (i = 0; i < 256; i++)
	{
		fprintf(fp, "@@:\n\t");
		fprintf(fp, "cmp\t\tal, 0x%02x\n\t", i);
		fprintf(fp, "jne\t\t@f\n\t");
		fprintf(fp, "push\t.b%02x\n\t", i);
		fprintf(fp, "call\t[printf]\n\t");
		fprintf(fp, "add\t\tesp, 4\n\t");
		fprintf(fp, "mov\t\tesi, dword[ebp+.pc]\n\t");
		fprintf(fp, "add\t\tdword[esi], 2\n\t");
		fprintf(fp, "jmp\t\t.exit\n");
	}
	fprintf(fp, "@@:\n.exit:\n");
	fclose(fp);
}

int print_push_params(FILE* fp, struct INSTRUCTION* inst[], int i)
{
	int j;
	for (j = 0; j < 2; j++)
	{
		if (inst[i]->operands[j] != NULL)
		{
			if (strstr(inst[i]->operands[j], "d8") || \
			strstr(inst[i]->operands[j], "a8") || \
			strstr(inst[i]->operands[j], "r8"))
			{
				fprintf(fp, "push\tdword[ebp+.param1]\n\t");
				return 1;
			}
			else if (strstr(inst[i]->operands[j], "d16") || \
			strstr(inst[i]->operands[j], "a16"))
			{
				fprintf(fp, "push\tdword[ebp+.param1]\n\t");
				fprintf(fp, "push\tdword[ebp+.param2]\n\t");
				return 2;
			}
		}
	}
	return 0;
}

//A helper function which replaces orig from str with rep
//Not really important to understand
char* str_replace(char* str, char* orig, char* rep)
{
	int diff = strlen(rep) - strlen(orig);
	char* newstr = (char*) malloc(strlen(str)+diff+1);
	char* tmp = newstr;
	char* off = strstr(str, orig);
	while (str != off) 
	{
		*(tmp++) = *(str++); 
	}
	while (*rep != 0)
	{
		*(tmp++) = *(rep++);
	}
	off += strlen(orig);
	while (*off != 0)
	{
		*(tmp++) = *(off++);
	}
	*tmp = 0;
	
	return newstr;
}
