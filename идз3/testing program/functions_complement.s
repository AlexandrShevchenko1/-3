.include "macros.s"
.include "macros_testing.s"
.global decide_to_continue, process_data, replace, er_name

decide_to_continue:
        li t1 'Y'
        li t2 'N'
        addi sp sp -4
        sw ra (sp)
      input1:
        print_string("\nWould you like to continue testing? (Y/N): ")
        read_char
        beq t1 a0 yes1
        beq t2 a0 no1
        j input1
      yes1:
        li a0 1
        ret
      no1:
        li a0 0
        lw ra (sp)
        addi sp sp 4
        ret


constants
process_data:                                 # searches for a sequence
            addi sp sp -4
            sw ra (sp)
	    li s1 0                           # number of read characters 
	external_loop:
  	    beq s1 a3 stop_program_execution  # if we read 10kb then stop_program
	    ###############################################################
	    mv t4 s1
	    mv t0 a2                       # making copy for macros
	    la s2 strbuf 
        fill_strbuf:
            beqz a4 stop_reading           # when strbuf is full then stop
            beq s1 a3 stop_reading         # when we reach MAX_TEXT_SIZE then stop
	    read_opened_file(s2, t0)
	    beqz a0 make_iteration_be_last # when 0 symbols read then stop
	    addi s1 s1 1
	    addi s2 s2 1
	    addi a4 a4 -1
	    j fill_strbuf
        make_iteration_be_last:
	    mv a3 s1                       # program will go to stop_program_execution at next iteration
	stop_reading:
	    mv a2 t0                       # return back file descriptor
	    li a4 TEXT_SIZE                # set a4 back to 512 bytes
	    sub t4 s1 t4                   # store the lenght of read text
	    ###############################################################
	    # allocate memory to heap
	    mv a0 t4
	    addi sp sp -4
	    sw t4 (sp)                       # firstly storing read text size to stack
	new_mem:
		li a7 9
		ecall
		addi sp sp -4        
		sw a0 (sp)                   # secondly storing memory adress to stack
	    ###############################################################
	    # move contents from buffer to heap
	    li t0 0                          # counter
	    la t1 strbuf
	    lw t2 (sp)                       # heap - begining pointer 
	loop1:
		beq t0 t4 break
		lb t3 (t1)                   # move from buffer
		sb t3 (t2)                   # to heap 	
		addi t1 t1 1                 # move pointer of strbuf 
		addi t2 t2 1                 # move pointer of heap
		addi t0 t0 1 
		j loop1
	break:
	    ###############################################################
	    # execute task
	    mv t0 a5                         # N
	    li t1 0                          # counter for N
	    lw t2 (sp)                       # heap - begining pointer 
	    lw t3 4(sp)                      # size of the text
	    mv t4 zero                       # maximum element of current sequence
	    li t5 0                          # counter for size
	    addi sp sp 8                     # clean stack
	find_sequence:
	    beq t1 t0 found_sequence
	    beq t5 t3 finish_search
	    lb t6 (t2) 
	    bgt t6 t4 increment
	    li t1 1                          # the start of new sequence
	    mv t4 t6                         # first minimum
	    j continue
	increment:
	    addi t1 t1 1
	    mv t4 t6                         # new minimum
	continue:
	    addi t2 t2 1
	    addi t5 t5 1
	    j find_sequence
	       ###############################################################
	found_sequence:
	    li t6 '\0'
	    sb t6 (t2) # add to make the sequence a string 
	    li t6 -1
	    mul t1 t1 t6 
	    add t2 t2 t1                     # move pointer to the begining of the sequence
	    print_string("Sequence was found\n")
	    close_file(a2)                   # closing the file that was read from
	    inputDialogString("Input path to output file: ", output_file_name, NAME_SIZE)
            replace_enter_char(output_file_name)
	    open_file(output_file_name, 1)
	    mv a2 a0       	             # saving a file descriptor output.txt
	    write_to_file(t2, t0, a2)
	    mv a6 t2
	    jal results_to_console2
	    j finish
	       ###############################################################
	finish_search:
	   j external_loop
	stop_program_execution:
	   print_string("\nNo sequence found\n")
           ###############################################################
	finish:   
	    close_file(a2)
	    lw ra (sp)
	    addi sp sp 4
	    ret
	  
	  
results_to_console2:
        li t1 'Y'
        li t2 'N'
        addi sp sp -4
        sw ra (sp)
      input2:
        print_string("\nWould you like to see the sequence in the console (Y/N): ")
        read_char
        beq t1 a0 yes2
        beq t2 a0 no2
        j input2
      yes2:
        print_string("\n")
        print_str(a6)
      no2:
        lw ra (sp)
        addi sp sp 4
        ret


replace:
	li t4 '\n'
	mv t5 a0
	loop:
	    lb t6 (t5)
	    beq t4 t6 change
	    addi t5 t5 1
	    b loop
	change:
            sb zero (t5)
        ret


er_name:
    print_string("Incorrect file name\n")
    # completion of the program
    li		a7 10
    ecall
