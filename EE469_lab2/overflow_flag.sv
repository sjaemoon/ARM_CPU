`timescale 1ns/10ps
module overflow_flag(top_a, top_b, cout_0, cout_1, overflow);
    input   logic   top_a, top_b, cout_0, cout_1;
    output  logic   overflow;

    /* Logic - Overflow occurs when:
        - A and B has the same sign (XNOR):
            Top carry and 2nd carry has a different val (XOR)
          In this case addition overflow occurs
    */
    logic carry_xor, sign_xor, sign_xnor, xor_0;

    //XOR Carries
    xor #0.05 carries (carry_xor, cout_0, cout_1);

    //XNOR signs A and B
    xor #0.05 signs0 (sign_xor, top_a, top_b);
    not #0.05 signs1 (sign_xnor, sign_xor);

    //AND gate for proper overflow detection

