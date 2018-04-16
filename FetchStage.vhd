Library ieee;
use ieee.std_logic_1164.all;

Entity FetchStage is
port(

clk: in std_logic;
reset :in std_logic; --signal to load pc with M[0]
int   :in std_logic;
branch:in std_logic; --branch is an out from branch unit
rst   :in std_logic; --external signal to set all registers to 0
PCen  :in std_logic; --external signal from branch unit required for flushing
ret   :in std_logic; --Signal from execute memory stage to indicate ret or reti
flush :in std_logic; --Signal from branch unit

--Data and signals required from early branching
------------------------------------------------
x	   : in std_logic_vector(14 downto 0); --Signal from forwarding unit
ALUResult1 : in std_logic_vector(15 downto 0);
AlUResult2 : in std_logic_vector(15 downto 0);
MemoryData : in std_logic_vector(15 downto 0);
WBSrcData  : in std_logic_vector(15 downto 0); --Output of multiplexer in Memory Stage
WBDstData  : in std_logic_vector(15 downto 0); --Output of multiplexer in Memory Stage

decodedDstData: in std_logic_vector(15 downto 0); --is one of outputs of decoding stage

instructionMemoryDataIn: in std_logic_vector(15 downto 0);
--Output represents fetch decode register values required for the decoding stage

InstructionMemoryAddressOut: out std_logic_vector(9 downto 0);
FetchDecodeOutput: out std_logic_vector(36 downto 0)

);
end entity;


Architecture FetchStageArch of FetchStage is



Signal pcinput:	         std_logic_vector(9 downto 0);
Signal pcoutput:         std_logic_vector(9 downto 0);

begin



--PC Controller circuit is responsible for loading PC with correct Value
-------------------------------------------------------------------------
PC          	: entity work.nbitregister generic map(n=>10) port map(pcinput,rst,clk,PCen,pcoutput);
PCController	: entity work.PCController port map(x,int,ret,reset,branch,pcoutput,decodedDstData,ALUResult1,ALUResult2,MemoryData,WBSrcData ,WBDstData,pcinput);

--TODO : Handle instructions that shall be loaded on two times
--These are LDM - LDD - SHL -SHR - STD

--TODO: In the file InterruptHandlingModule.vhdl create the entity interrupt handling module and all of its signals

--TODO:Create Fetch decode Register of 37 bits and map its output to fetch decode output in entity declararation


--TODO: Go to files Decode - Execute - Memory and writeback and add any thing required for handling interrupts

--Dont forget to handle reset with interrupts and the case of m[0] and m[1]

--Set T and interrupt indicator in decodeexecute register mapping section in DEcode Stage.vhdl
end FetchStageArch;
