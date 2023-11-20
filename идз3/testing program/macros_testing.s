
.macro inputDialogString(%message, %buffer, %number)
.data
prompt: .asciz %message
.text
    li a7 54
    la a0 prompt
    la a1 %buffer
    li a2 %number
    ecall
.end_macro  

.macro inputDialogInt
.data
get_n: .asciz  "Get N: "
.text
	la a0 get_n
	li a7 51
	ecall
.end_macro