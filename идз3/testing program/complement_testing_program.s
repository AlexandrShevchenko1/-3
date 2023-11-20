.include "macros.s"
.include "macros_testing.s"

.global main
.global input_file_name, strbuf, output_file_name

constants # constants are inserted here
main: 

.data
input_file_name: .space NAME_SIZE          # the name of input file
strbuf: .space TEXT_SIZE                   # buffer for input file
output_file_name: .space NAME_SIZE   # the name of output file
.text
    loop:
    ###############################################################
    inputDialogString("\nInput file path: ", input_file_name, NAME_SIZE)
    replace_enter_char(input_file_name)
    # open input file in read-only mode
    open_file(input_file_name, 0)
    li a6 -1	        # checking for correct opening
    beq	a0 a6 er_name	# file opening error
    mv a2 a0       	# saving a file descriptor
    ###############################################################
    # for parameters we pass MAX_TEXT_SIZE, TEXT_SIZE, N 
    li a3 MAX_TEXT_SIZE 
    li a4 TEXT_SIZE
    inputDialogInt #get_N
    mv s3 a0
    mv a5 s3
    li a6 '\0'
    jal process_data
    ###############################################################
    jal decide_to_continue
    bnez a0 loop
    li a7 10
    ecall 