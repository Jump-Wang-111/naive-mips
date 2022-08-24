// GLOBAL
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000

`define WriteEnable 1'b01
`define WriteDisable 1'b00
`define WriteFromRam 2'b10
`define WriteBus 1:0

`define ReadEnable 1'b1
`define ReadDisable 1'b0

`define AluOpBus 7:0
`define AluSelBus 2:0
`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0


// INST/FUNC

// LOGIC
`define FUNC_OR   6'b100101
`define FUNC_XOR 6'b100110
`define INST_ORI  6'b001101
`define INST_XORI 6'b001110
`define INST_LUI 6'b001111

// SHIFT
`define FUNC_SLL  6'b000000
`define FUNC_SRL  6'b000010

// ARITHMETIC
`define FUNC_SLT  6'b101010
`define FUNC_SLTU  6'b101011
`define FUNC_ADD  6'b100000
`define FUNC_ADDU  6'b100001
`define FUNC_SUB  6'b100010
`define FUNC_SUBU  6'b100011
`define INST_ADDI  6'b001000
`define INST_ADDIU  6'b001001  

`define INST_NOP 6'b000000

`define INST_SPECIAL 6'b000000
`define INST_REGIMM 6'b000001
/* ри╩С */
`define INST_SPECIAL2 6'b011100

// JUMP
`define INST_J  6'b000010
`define INST_JAL  6'b000011
`define FUNC_JR  6'b001000
`define INST_BEQ  6'b000100
`define INST_BNE  6'b000101

// LOAD/SAVE
`define INST_LW  6'b100011
`define INST_SW  6'b101011

//AluOp
`define ALU_OP_OR    8'b00100101
`define ALU_OP_XOR  8'b00100110
`define ALU_OP_ORI  8'b01011010
`define ALU_OP_XORI  8'b01011011
`define ALU_OP_LUI  8'b01011100   

`define ALU_OP_SLL  8'b01111100
`define ALU_OP_SRL  8'b00000010

`define ALU_OP_SLT 8'b00101010
`define ALU_OP_SLTU 8'b00101011
`define ALU_OP_ADD 8'b00100000
`define ALU_OP_ADDU 8'b00100001
`define ALU_OP_SUB 8'b00100010
`define ALU_OP_SUBU 8'b00100011
`define ALU_OP_ADDI 8'b01010101
`define ALU_OP_ADDIU 8'b01010110

`define ALU_OP_JAL  8'b01010000
`define ALU_OP_JR  8'b00001000
`define ALU_OP_BEQ  8'b01010001
`define ALU_OP_BNE  8'b01010010

`define ALU_OP_LW  8'b11100011
`define ALU_OP_SW  8'b11101011

`define ALU_OP_NOP    8'b00000000

// AluSel
`define ALU_RES_LOGIC 3'b001
`define ALU_RES_SHIFT 3'b010
`define ALU_RES_ARITHMETIC 3'b100
`define ALU_RES_JUMP_BRANCH 3'b110
`define ALU_RES_NOP 3'b000
`define ALU_RES_LOAD_STORE 3'b111	

// inst_rom
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17


// regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define ZeroRegAddr 5'b00000
