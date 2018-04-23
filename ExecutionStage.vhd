Library ieee;
use ieee.std_logic_1164.all;

entity ExecuteStage is

Port(
clk: in std_logic;
rst: in std_logic;


DecodeExecute: in std_logic_vector(54 downto 0);

inCtrlSignals: in std_logic_vector(15 downto 0);

--opcode	     : in std_logic_vector(4 downto 0); --needed to check if the instuction in execute is out instruction
--this could also be determined from iowrite but not sure;
ExMemRdstV   : in std_logic_vector(15 downto 0); --Dst multiplexer output in memory wb stage
ExMemRsrcV   : in std_logic_vector(15 downto 0); --Src multiplexer output in memory wb stage
WriteBack    : in std_logic_vector(31 downto 0);  --maps to WriteBack Register from 38 down to 7
x	     : in std_logic_vector(14 downto 0); --input from forwarding unit
fetchDecodeOpcode: in std_logic_vector(4 downto 0); --passed from decode stage for branch unit
--Output represents execution results as well as ctrl signals


outCtrlSignals: out std_logic_vector(12 downto 0);
ExecuteMemory:  out std_logic_vector(64 downto 0);
OutportOutput: out std_logic_vector(15 downto 0);

--Output from branch unit
branch	     : out std_logic;
flush	     : out std_logic



);

end entity;


Architecture ExecuteStageArch of ExecuteStage is

Signal T		: std_logic;
Signal incrementedPC	: std_logic_vector(9 downto 0);
Signal RsrcV		: std_logic_vector(15 downto 0);
Signal RdstV		: std_logic_vector(15 downto 0);
Signal imm		: std_logic_vector(15 downto 0);
Signal Rsrc		: std_logic_vector(2 downto 0);
Signal Rdst		: std_logic_vector(2 downto 0);
Signal opcode		: std_logic_vector(4 downto 0); --ALU op may change so be careful
Signal intIndicator	: std_logic;

--Data coming from WB stage
---------------------------
Signal WBDstData    :  std_logic_vector(15 downto 0);  --dst data in WB buffers
Signal WBSrcData    :  std_logic_vector(15 downto 0);  --src data in WB buffers 



--Input Ctrl Signals
---------------------
--TODO: write all input ctrlsigs as shown
---------------------------------------------
Signal IoWr		: std_logic;


Signal OutportInput	: std_logic_vector(15 downto 0);

begin

--Signals coming from WriteBack Stage
-------------------------------------
WBsrcData	<= 	WriteBack(31 downto 16);
WBdstData	<= 	WriteBack(15 downto 0);


--Decode Execute Register fields
---------------------------------
T		<= DecodeExecute(54);
intIndicator	<= DecodeExecute(53);
incrementedPC	<= DecodeExecute(52 downto 43);
RsrcV		<= DecodeExecute(42 downto 27);
RdstV		<= DecodeExecute(26 downto 11);
Rsrc		<= DecodeExecute(10 downto 8);
Rdst		<= DecodeExecute(7 downto 5);
opcode		<= DecodeExecute(4 downto 0);

--Decoding of Control Signals
-----------------------------

--ToDo: Write decoding of in ctrl signals as shown

IoWr		<= inCtrlSignals(0); --change the index it is not correct


--Output port and its Controller
--------------------------------
OutputPortController:entity work.outPortController port map(RsrcV,ExMemRdstV,ExMemRsrcV,WBDstData,WBSrcData,x,outPortInput );
Outputport          :entity work.nbitregisterf port map(outPortInput,rst,clk,IOWr,OutportOutput);


--TODO: Add Alu and its signals
---------------------------------


--TODO: Add muxes at src and dst values of alu
-----------------------------------------------



--TODO: Add Execute Memory register Its output is 65 bits and is declared in entity declaration above
--------------------------------------------------------------------------------------------------------



--TODO: Add branch unit here make sure that the opcode you pass to branch unit is fetchDecodeOpcode in entity declaration
--------------------------------------------------------------------------------------------------------------------------------


end ExecuteStageArch;
