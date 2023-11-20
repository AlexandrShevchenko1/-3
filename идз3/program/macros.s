 .macro print_string(%prompt) # prints string
.data
prompt: .asciz %prompt
.text
	la a0 prompt
	li a7 4
	ecall
.end_macro

.macro print_str(%buffer)
	li a7 4
	mv a0 %buffer
	ecall
.end_macro	

.macro read_string(%buffer, %size) # reads_string
	la a0 %buffer
	li a1 %size
	li a7 8
	ecall
.end_macro


.macro read_char
        li a7 12
        ecall
.end_macro  
      

.macro open_file(%buffer, %flag) 
	li a7 1024     	# system call to open a file
	la a0 %buffer	# the name of the file to open
	li a1 %flag	
	ecall
.end_macro


.macro replace_enter_char(%buffer) # macro for function replace
	la a0 %buffer
	jal replace
.end_macro


.macro print_char(%reg)
	li a7 11
	mv a0 %reg
	ecall
.end_macro


.macro read_opened_file(%sp, %descrip)
        li   a7, 63             # system call to read from a file
	mv   a0, %descrip     
	mv   a1, %sp   
	li   a2, 1
	ecall  	                 # reading
.end_macro


.macro write_to_file(%buffer, %size, %descrip)
	li   a7, 64             # system call to write to a file
	mv   a0, %descrip      
	mv   a1, %buffer   
	mv   a2, %size 
	ecall                   # writing
.end_macro


.macro close_file(%descrip)
	li   a7, 57             # system call to close a file
	mv   a0, %descrip       
	ecall                   # closing file
.end_macro


.macro get_N
	print_string("Get N: ")
	li a7 5
	ecall
.end_macro


.macro constants
.eqv    NAME_SIZE 256	      # buffer size for the file name
.eqv    TEXT_SIZE 512	      # buffer size for text
.eqv    MAX_TEXT_SIZE 10000   # maximum text size 10 kb = 10k bytes	
.end_macro 