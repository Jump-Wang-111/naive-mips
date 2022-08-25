// GLOBAL
`define InitialPc   32'hbfc00000
`define RstEnable   1'b1
`define RstDisable  1'b0
`define ZeroWord    32'h00000000

`define WriteEnable     1'b01
`define WriteDisable    1'b00
`define WriteFromRam    2'b10
`define WriteBus        1:0

`define ReadEnable  1'b1
`define ReadDisable 1'b0

`define AluOpBus            7:0
`define AluSelBus           2:0
`define InstValid           1'b0
`define InstInvalid         1'b1
`define Stop                1'b1
`define NoStop              1'b0
`define InDelaySlot         1'b1
`define NotInDelaySlot      1'b0
`define Branch              1'b1
`define NotBranch           1'b0
`define InterruptAssert     1'b1
`define InterruptNotAssert  1'b0
`define TrapAssert          1'b1
`define TrapNotAssert       1'b0
`define True_v              1'b1
`define False_v             1'b0
`define ChipEnable          1'b1
`define ChipDisable         1'b0


// INST/FUNC

`define INST_ORI    6'b001101
`define INST_ANDI   6'b001100
`define INST_XORI   6'b001110
`define FUNC_AND    6'b100100
`define FUNC_NOR    6'b100111

`define FUNC_OR     6'b100101
`define FUNC_XOR    6'b100110
`define INST_LUI    6'b001111
`define FUNC_SLL    6'b000000
`define FUNC_SLLV   6'b000100

`define FUNC_SRL    6'b000010
`define FUNC_SRLV   6'b000110
`define FUNC_SRA    6'b000011
`define FUNC_SRAV   6'b000111
`define FUNC_NOP    6'b000000

`define FUNC_SSNOP  6'b000000
`define FUNC_SYNC   6'b001111
`define FUNC_MOVN   6'b001011
`define FUNC_MOVZ   6'b001010
`define FUNC_ADD    6'b100000

`define FUNC_ADDU   6'b100001
`define FUNC_SUB    6'b100010
`define FUNC_SUBU   6'b100011
`define FUNC_SLT    6'b101010
`define FUNC_SLTU   6'b101011

`define INST_ADDI   6'b001000
`define INST_ADDIU  6'b001001 
`define INST_SLTI   6'b001010 
`define INST_SLTIU  6'b001011 
`define INST_J      6'b000010

`define INST_JAL    6'b000011
`define FUNC_JR     6'b001000
`define FUNC_JALR   6'b001001
`define INST_BEQ_B  6'b000100
`define RS_B    5'b00000
`define RT_B    5'b00000 

`define INST_BGTZ   6'b000111
`define INST_BLEZ   6'b000110
`define INST_BNE    6'b000101
`define INST_BLTZ_BLTZAL_BGEZ_BGEZAL_BAL   6'b000001
`define RT_BLTZ     5'b00000
`define RT_BLTZAL   5'b10000

`define RT_BGEZ     5'b00001
`define RT_BGEZAL   5'b10001
`define RS_BAL      5'b00000
`define RT_BAL      5'b10001
`define INST_LW     6'b100011
`define INST_SW     6'b101011

`define INST_LB     6'b100000
`define INST_SB     6'b101000
`define INST_LH     6'b100001
`define INST_SH     6'b101001

`define INST_SPECIAL 6'b000000

// JUMP

`define FUNC_JALR   6'b001001

// LOAD/SAVE
`define INST_LW     6'b100011
`define INST_SW     6'b101011

//AluOp
`define ALU_OP_ORI      1
`define ALU_OP_ANDI     2
`define ALU_OP_XORI     3
`define ALU_OP_AND      4
`define ALU_OP_NOR      5

`define ALU_OP_OR       6
`define ALU_OP_XOR      7
`define ALU_OP_LUI      8
`define ALU_OP_SLL      9
`define ALU_OP_SLLV     10

`define ALU_OP_SRL      11
`define ALU_OP_SRLV     12
`define ALU_OP_SRA      13
`define ALU_OP_SRAV     14
`define ALU_OP_NOP      15

`define ALU_OP_SSNOP    16
`define ALU_OP_SYNC     17
`define ALU_OP_MOVN     18
`define ALU_OP_MOVZ     19
`define ALU_OP_ADD      20

`define ALU_OP_ADDU     21
`define ALU_OP_SUB      22
`define ALU_OP_SUBU     23
`define ALU_OP_SLT      24
`define ALU_OP_SLTU     25

`define ALU_OP_ADDI     26
`define ALU_OP_ADDIU    27
`define ALU_OP_SLTI     28
`define ALU_OP_SLTIU    29
`define ALU_OP_J        30

`define ALU_OP_JAL      31
`define ALU_OP_JR       32
`define ALU_OP_JALR     33
`define ALU_OP_BEQ      34
`define ALU_OP_B        35

`define ALU_OP_BGTZ     36
`define ALU_OP_BLEZ     37
`define ALU_OP_BNE      38
`define ALU_OP_BLTZ     39
`define ALU_OP_BLTZAL   40

`define ALU_OP_BGEZ     41
`define ALU_OP_BGEZAL   42
`define ALU_OP_BAL      43
`define ALU_OP_LW       44
`define ALU_OP_SW       45

`define ALU_OP_LB       46
`define ALU_OP_SB       47
`define ALU_OP_LH       48
`define ALU_OP_SH       49

// AluSel
`define ALU_RES_LOGIC       3'b001
`define ALU_RES_SHIFT       3'b010
`define ALU_RES_ARITHMETIC  3'b100
`define ALU_RES_JUMP_BRANCH 3'b110
`define ALU_RES_NOP         3'b000
`define ALU_RES_LOAD_STORE  3'b111	

// inst_rom
`define InstAddrBus     31:0
`define InstBus         31:0
`define InstMemNum      131071
`define InstMemNumLog2  17


// regfile
`define RegAddrBus      4:0
`define RegBus          31:0
`define RegWidth        32
`define DoubleRegWidth  64
`define DoubleRegBus    63:0
`define RegNum          32
`define RegNumLog2      5
`define ZeroRegAddr     5'b00000
