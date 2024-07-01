.data


num: .asciz "%2d "

row_num: .asciz "  %d "

space: .asciz "     "

new_line: .asciz "\n"

item: .asciz "  %c"

    //
    // The Game description data structure
    //
    .equ    game_rows, 0
    .equ    game_cols, 4
    .equ    game_array, 8
    .equ    game_size, 16
    //
    // The Game cell data structure
    // This is the contents of a location in the array
    //
    .equ    cell_expected, 0
    .equ    cell_actual, 4
    .equ    cell_size, 8


.text

.global create_game

//
// Create the game abstract data type
// void *create_game(int rows, int cols)
//
create_game:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    mov w19, w0      // rows
    mov w20, w1      // cols

    mov w0, #1
    mov w1, #game_size
    bl calloc       // allocate

    //
    // Set the data structure initial values
    //
    str w19,[x0, #game_rows]
    str w20,[x0, #game_cols]

    mov x21, x0      // game pointer

    //
    // Allocate the game array
    //
    mul w0,w19,w20        // row * cols
    mov w1,#cell_size   // Cell size
    bl calloc

    str x0,[x21,#game_array]

    mov x0,x21

create_game_done:
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret


.global destroy_game
//
// void destroy_game(void *game)
// Destroy the game, freeing all memory
//
destroy_game:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    mov x19, x0         //Move the pointer to x19

    ldr x0, [x19, #game_array]
    bl free             //Free Memory

    mov x0, x19
    bl free

    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

.global get_rows

//
// Get the number of rows in the game
// int get_rows(void *game)
//
get_rows:
        ldr w0, [x0, #game_rows]
        ret

.global get_cols

//
// Get the number of columns in the game
// int get_cols(void *game)
//
get_cols:
        ldr w0, [x0, #game_cols]
        ret

.global display_game

//
// Display the game
//
//
//Variables
//
//x19 - game ptr
//x20 - number of cols
//x21 - i
//x22 - number of rows
//x23 - j
//
//
display_game:
        stp x29, x30, [sp, #-16]!
        stp x19, x20, [sp, #-16]!
        stp x21, x22, [sp, #-16]!
        stp x23, x24, [sp, #-16]! 

        mov x19, x0             //Move pointer to x19

        bl get_cols
        mov x20, x0             //Move number of cols into x20
        mov x21, #1             //Start i at 1

        ldr x0, =space
        bl printf               //Load in starting spaces
        b first_loop

first_loop:
        //Check Condition
        cmp x21, x20            //Compare i to number of cols
        bgt first_loop_end

        //Otherwise
        mov x1, x21
        ldr x0, =num
        bl printf

        add x21, x21, #1        //i++
        b first_loop

first_loop_end:
        ldr x0, =new_line
        bl printf

        mov x0, x19             //Move in ptr
        bl get_rows             //Get number of rows
        mov x22, x0             //Move rows to x22
        mov x23, #1             //Set j to 1

        b main_loop

main_loop:
        //Check Conditions
        cmp x23, x22            //Compare j and number of rows
        bgt end_main_loop

        mov x1, x23
        ldr x0, =row_num
        bl printf

        mov x21, #1             //Set i to 1
        b inner_loop            //Jump to inner loop

inner_loop:
        //Check Condition
        cmp x21, x20            //Compare i to number of cols
        bgt main_loop_reset     // if i is greater than number of cols, reset main loop

        //Otherwise
        mov x0, x19             //Move in game ptr
        mov x1, x23
        mov x2, x21
        bl game_index           //Call to game index

        //Get value at that spot
        ldr w1, [x0, #cell_actual]
        ldr x0, =item
        bl printf

        add x21, x21, #1        //i++
        b inner_loop            //Back to top of loop

main_loop_reset:
        add x23, x23, #1        //j++
        ldr x0, =new_line
        bl printf

        b main_loop             //loop back to top


end_main_loop:
        ldr x0, =new_line
        bl printf
        b display_game_end

display_game_end:
        ldp x23, x24, [sp], #16
        ldp x21, x22, [sp], #16
        ldp x19, x20, [sp], #16
        ldp x29, x30, [sp], #16
        ret
//
.global set_cell_actual
//
// int set_cell_actual(void *game, int row, int col, char ch);
// Returns: 1 if the answer value is correct
//
set_cell_actual:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    mov w19, w3                 //Save ch in w19

    bl game_index               //Get the ptr to the ch
    ldr w20, [x0, #cell_expected]       //Load in Expected cell
    str w19, [x0, #cell_actual]         //Store Ch

    cmp w19, w20                        //Compare actual to expected
    beq Correct
    b Wrong

Correct:
        mov w0, #1
        b set_cell_actual_done

Wrong:
        mov w0, #0
        b set_cell_actual_done

set_cell_actual_done:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

.global set_cell_expected

//
// void set_cell_expected(void *game, int row, int col, char ch);
//
set_cell_expected:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    mov w19, w3                 // save ch in w19
    bl game_index

    str w19, [x0, #cell_expected]  // save ch into game


    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret


.global game_win

//
// int game_win(void *game)
// Returns true when the game is done/won
//
//Variables
//x19 - game ptr
//x20 - number of rows
//x21 - number of cols
//x22 - i
//x23 - j
//x24 - 
//
game_win:
        stp x29, x30, [sp, #-16]!
        stp x19, x20, [sp, #-16]!
        stp x21, x22, [sp, #-16]!
        stp x23, x24, [sp, #-16]!

        mov x19, x0             //Move game *ptr to x19

        bl get_rows             //Get the Number of rows
        mov x20, x0             //Move number of rows to x20

        mov x0, x19             //Move game ptr to x0
        bl get_cols             //Get number of cols
        mov x21, x0             //Move number of cols to x21

        mov x22, #1             //Set i to 1
        b row_loop              //Jump to row_loop

row_loop:
        //Check condition
        cmp x22, x20            //Compare i to number of rows
        bgt Win                 //if greater than, then win

        //Othwerwise
        mov x23, #1             //set j to 1
        b col_loop

col_loop:
        //Check Conditions
        cmp x23, x21            //Compare j to number of cols
        bgt reset_row_loop      //Reset the row loop

        //Get index
        mov x0, x19             //Move game ptr to x0
        mov x1, x22             //Move rows to x1(i)
        mov x2, x23             //Move cols to x2(j)
        bl game_index           //Call to game index function

        ldr w1, [x0, #cell_actual]              //Load in actual value
        ldr w2, [x0, #cell_expected]            //Load in correct answer

        cmp w1, w2              //Compare two values
        bne Loss                //If != it is a loss

        //Otherwise move on
        add x23, x23, #1        //j++
        b col_loop              //Back to top of col_loop

reset_row_loop:
        add x22, x22, #1        //i++
        b row_loop              //Jump to top of row loop

Win:
        mov x0, #1
        b game_win_done

Loss:
        mov x0, #0
        b game_win_done

game_win_done:
        ldp x23, x24, [sp], #16
        ldp x21, x22, [sp], #16
        ldp x19, x20, [sp], #16
        ldp x29, x30, [sp], #16
        ret
.global game_index
//
// int *game_index(void *game, int row, int col)
// Get the address of a row and column in the cells
//   
game_index:
        sub w1, w1, #1          //row - 1
        sub w2, w2, #1          //col - 1

        ldr w3, [x0, #game_cols]                //Get the Number of Cols
        mov w5, #cell_size

        mul w6, w1, w3                          //r * cols
        add w6, w6, w2                          // (r * cols + c)
        mul w6, w6, w5                          // (r * cols + c) * cell_size   


        ldr x4, [x0, #game_array]
        add x0, x4, w6, uxtw

        ret

