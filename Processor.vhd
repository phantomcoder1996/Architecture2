Library ieee;
use ieee.std_logic_1164.all;

entity processor is
Port(

reset: in std_logic; --external reset signal
clk:   in std_logic; 
int:   in std_logic; --external interrupt signal
rst:   in std_logic; --external signal for loading all registers with zeros

instructionMemIn: in std_logic_vector(15 downto 0);
DataMemoryIn:     in std_logic_vector(15 downto 0);

portInput:        in std_logic_vector(15 downto 0);


instructionMemoryAddress: out std_logic_vector(9 downto 0);
DataMemoryAddress	: out std_logic_vector(9 downto 0);
DataMemoryOut		: out std_logic_vector(15 downto 0)




);

end entity;


Architecture processorArch of processor is

--Signal from Execute

---Branch Signals From Execution 

SIGNAL Branch,Flush:std_logic;
SIGNAL ALUResult1 :  std_logic_vector(15 downto 0);
SIGNAL AlUResult2 :  std_logic_vector(15 downto 0);
--------------------
SIGNAL outCtrlSignals:  std_logic_vector(12 downto 0);
SIGNAL ExecuteMemory:   std_logic_vector(82 downto 0);
SIGNAL OutportOutput:  std_logic_vector(15 downto 0);

----Signals from Forwarding unit
SIGNAL x:std_logic_vector(14 downto 0);

------------Signals in Memory Stage 
SIGNAL WBSrcData  :  std_logic_vector(15 downto 0); --Output of multiplexer in Memory Stage
SIGNAL WBDstData  :  std_logic_vector(15 downto 0); --Output of multiplexer in Memory Stage
SIGNAL MemoryData : std_logic_vector(15 downto 0);
SIGNAL outCtrlSignals:  std_logic_vector(2 downto 0);
SIGNAL Immediate:std_logic_vector(15 downto 0) --immediate data to be written back
SIGNAL Address:     std_logic_vector( 9 downto 0);
SIGNAL ret:std_logic; --dont know where to find it
------- Signals From decode Stage 
SIGNAL decodedDstData:  std_logic_vector(15 downto 0);
SIGNAL FetchDecodeOutput: std_logic_vector(36 downto 0);--output from fetch input to decode
SIGNAL pushIntrEn:  std_logic;
SIGNAL start	   :  std_logic;
----------------------------------------------------------
SIGNAL CtrlSignals :  std_logic_vector(11 downto 0);
SIGNAL decodedDstD : std_logic_vector(15 downto 0); --Decoded data required for branching and will be needed by fetch stage
SIGNAL DecodeExecute:  std_logic_vector(54 downto 0);
SIGNAL FetchDecodeOpcode: out std_logic_vector( 4 downto 0); --needed for branch unit

--------------no idea where to get it  in fetch stage s
SIGNAL nextStageEn:std_logic;
SIGNAL DECEXRET: std_logic;--control signal from decode stage bit 8
SIGNAL EXECMEMRET:  std_logic;--control signal from execute stage bit 8

-----------Signals for write back 
SIGNAL WriteBack:  std_logic_vector(38 downto 0);
SIGNAL outCtrlSignalsWB:std_logic_vector( 2 downto 0);

begin

--TODO
-------
--Create an instance of forwarding unit
--Create instances for the stages of fetch- decode - execute -memory -wb stages
FetchStage: entity work.FetchStage port map(clk,reset,int,Branch,rst,ret,Flush,x,DECEXRET,EXECMEMRET,ALUResult1,AlUResult2,MemoryData,WBSrcData,WBDstData,decodedDstData,pushIntrEn,start,FetchDecodeOutput,nextStageEn);
DecodeStage: entity work.DecodeStage port map(clk,reset,int,rst,FetchDecodeOutput,WriteBack,outCtrlSignalsWB,nextStageEn,CtrlSignals,decodedDstD,DecodeExecute,FetchDecodeOpcode,pushIntrEn,start,DECEXRET);
ExecuteStage: entity work.ExecuteStage port map(clk,rst,DecodeExecute,CtrlSignals,WBDstData,WBSrcData,WriteBack,x,FetchDecodeOpcode,outCtrlSignals,ExecuteMemory,OutportOutput,ALUResult1,AlUResult2,Branch,Flush,EXECMEMRET);
MemoryStage:entity work.MemoryStage port map (clk,rst,ExecuteMemory,,x,outCtrlSignals,MemoryData,Address,WBSrcData,WBDstData,Immediate);
WBStage:entity work.WBStageport map (clk,rst,MemoryData,WBSrcData,WBDstData,Immediate,outCtrlSignals,WriteBack,outCtrlSignalsWB);
--Declare signals for all connections (rabena m3aki :D :D)

--After that Create a file for the interface of the processor with instruction memory and data memory as well as input port
--Instruction memory is in file instructionmemory.vhdl(sob7an allah) w datamemory is in file (ram.vhdl)

end processorArch;
