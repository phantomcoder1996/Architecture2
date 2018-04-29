Library ieee;
use ieee.std_logic_1164.all;

Entity MemoryStage is
Port(

clk: in std_logic;
rst: in std_logic;

ExecuteMemory: in std_logic_vector(64 downto 0);
MemWBRDst    : in std_logic_vector(15 downto 0); --forwarded from write back stage
inctrlSignals: in std_logic_vector(12 downto 0); --not sure from the number (reem and mariam should tell me about their signals->(hager)
x: in std_logic_vector(14 downto 0); --Output from forwarding unit


--Output represents memory results and ctrl signals required for the next stage

outCtrlSignals: out std_logic_vector(2 downto 0);

MemoryData: out std_logic_vector( 15 downto 0);--Data to be written in data memory
Address:    out std_logic_vector( 9 downto 0); --Address of data memory

AluOut1:out std_logic_vector(15 downto 0);
AluOut2: out std_logic_vector(15 downto 0);
Immediate:out std_logic_vector(15 downto 0) --immediate data to be written back

);


end entity;


Architecture MemoryStageArch of MemoryStage is

Signal incrementedPC	: std_logic_vector(9 downto 0);
Signal AluO2_RsrcV	: std_logic_vector(15 downto 0);
Signal AluO1		: std_logic_vector(15 downto 0);
Signal RdstV_imm	: std_logic_vector(15 downto 0);
Signal Rsrc		: std_logic_vector(2 downto 0);
Signal Rdst		: std_logic_vector(2 downto 0);
Signal intIndicator	: std_logic;

begin

--Execute Memory register fields
---------------------------------
intIndicator		<= ExecuteMemory(64);
incrementedPC		<= ExecuteMemory(63 downto 54);
AluO2_RsrcV		<= ExecuteMemory(53 downto 38);
AluO1			<= ExecuteMemory(37 downto 22);
RdstV_imm		<= ExecuteMemory(21 downto 6);
Rsrc			<= ExecuteMemory(5 downto 3);
Rdst			<= ExecuteMemory(2 downto 0);

--TODO: Decode in ctrlSigs here
--------------------------------


Immediate		<=RdstV_imm;

--TODO: Multiplexer for address
--This mux chooses between 
--0- ALUO1 (This is the value of SP)
--1- ALUO1+1 (This is the value of SP+1)
--2- RdstV_Imm (This represents effective address)
--Its selection is as follows 
--00=> pop/ret/reti These have the CtrlSignals memRead='1' and Rsrc=="110'
--01=> push/call/int These have the CtrlSignals memWrite='1' and Rsrc='110'
--10=>LDD/STD  (memread=1 and rsrc!="110" ) and memwrite=1 and rsrc!="110"


--TODO: Mux1 and Mux2 for data(I will send you the drawing)
--Mux2 chooses between
--0=> Output of mux1
--1=> MemWBRdst
--Sel of Mux2=> x(4) or x(5)

--Mux1 chooses between 
--0=>incrementedPC
--1=>ALUO2_RsrcV 
--2=>RdstV_Imm
--sel 00=> when call
-----01=> when STD
-----10=> when Push
 


end MemoryStageArch;
