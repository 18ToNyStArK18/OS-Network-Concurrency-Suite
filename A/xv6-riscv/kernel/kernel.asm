
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	85010113          	addi	sp,sp,-1968 # 8000b850 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7dd97ca7>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e2a78793          	addi	a5,a5,-470 # 80000eae <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	2bd020ef          	jal	80002bd6 <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	7b4000ef          	jal	800008da <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f05a                	sd	s6,32(sp)
    80000186:	ec5e                	sd	s7,24(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8b2a                	mv	s6,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000192:	00013517          	auipc	a0,0x13
    80000196:	6be50513          	addi	a0,a0,1726 # 80013850 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00013497          	auipc	s1,0x13
    800001a2:	6b248493          	addi	s1,s1,1714 # 80013850 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00013917          	auipc	s2,0x13
    800001aa:	74290913          	addi	s2,s2,1858 # 800138e8 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	6f7010ef          	jal	800020b4 <myproc>
    800001c2:	0a9020ef          	jal	80002a6a <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	606020ef          	jal	800027d2 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00013717          	auipc	a4,0x13
    800001e2:	67270713          	addi	a4,a4,1650 # 80013850 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04da8663          	beq	s5,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	855a                	mv	a0,s6
    80000210:	17d020ef          	jal	80002b8c <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fa8b63          	beq	s5,a5,80000276 <consoleread+0x100>
    80000224:	7aa2                	ld	s5,40(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	00013517          	auipc	a0,0x13
    8000022c:	62850513          	addi	a0,a0,1576 # 80013850 <cons>
    80000230:	28d000ef          	jal	80000cbc <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7b02                	ld	s6,32(sp)
    80000244:	6be2                	ld	s7,24(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0179fa63          	bgeu	s3,s7,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	00013717          	auipc	a4,0x13
    80000252:	68f72d23          	sw	a5,1690(a4) # 800138e8 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00013517          	auipc	a0,0x13
    80000268:	5ec50513          	addi	a0,a0,1516 # 80013850 <cons>
    8000026c:	251000ef          	jal	80000cbc <release>
  return target - n;
    80000270:	413b853b          	subw	a0,s7,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	6e4000ef          	jal	8000096e <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	6d6000ef          	jal	8000096e <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	6ce000ef          	jal	8000096e <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	6c8000ef          	jal	8000096e <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	1101                	addi	sp,sp,-32
    800002ae:	ec06                	sd	ra,24(sp)
    800002b0:	e822                	sd	s0,16(sp)
    800002b2:	e426                	sd	s1,8(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00013517          	auipc	a0,0x13
    800002bc:	59850513          	addi	a0,a0,1432 # 80013850 <cons>
    800002c0:	169000ef          	jal	80000c28 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48d63          	beq	s1,a5,80000360 <consoleintr+0xb4>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48263          	beq	s1,a5,800003b4 <consoleintr+0x108>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49363          	bne	s1,a5,800003dc <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800002da:	147020ef          	jal	80002c20 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00013517          	auipc	a0,0x13
    800002e2:	57250513          	addi	a0,a0,1394 # 80013850 <cons>
    800002e6:	1d7000ef          	jal	80000cbc <release>
}
    800002ea:	60e2                	ld	ra,24(sp)
    800002ec:	6442                	ld	s0,16(sp)
    800002ee:	64a2                	ld	s1,8(sp)
    800002f0:	6105                	addi	sp,sp,32
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0af48e63          	beq	s1,a5,800003b4 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	00013717          	auipc	a4,0x13
    80000300:	55470713          	addi	a4,a4,1364 # 80013850 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48563          	beq	s1,a5,800003e2 <consoleintr+0x136>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	00013717          	auipc	a4,0x13
    80000326:	52e70713          	addi	a4,a4,1326 # 80013850 <cons>
    8000032a:	0a072683          	lw	a3,160(a4)
    8000032e:	0016879b          	addiw	a5,a3,1
    80000332:	863e                	mv	a2,a5
    80000334:	0af72023          	sw	a5,160(a4)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	9736                	add	a4,a4,a3
    8000033e:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	ff648713          	addi	a4,s1,-10
    80000346:	c371                	beqz	a4,8000040a <consoleintr+0x15e>
    80000348:	14f1                	addi	s1,s1,-4
    8000034a:	c0e1                	beqz	s1,8000040a <consoleintr+0x15e>
    8000034c:	00013717          	auipc	a4,0x13
    80000350:	59c72703          	lw	a4,1436(a4) # 800138e8 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00013717          	auipc	a4,0x13
    80000366:	4ee70713          	addi	a4,a4,1262 # 80013850 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00013497          	auipc	s1,0x13
    80000376:	4de48493          	addi	s1,s1,1246 # 80013850 <cons>
    while(cons.e != cons.w &&
    8000037a:	4929                	li	s2,10
    8000037c:	02f70863          	beq	a4,a5,800003ac <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000380:	37fd                	addiw	a5,a5,-1
    80000382:	07f7f713          	andi	a4,a5,127
    80000386:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000388:	01874703          	lbu	a4,24(a4)
    8000038c:	03270263          	beq	a4,s2,800003b0 <consoleintr+0x104>
      cons.e--;
    80000390:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000394:	10000513          	li	a0,256
    80000398:	ee3ff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    8000039c:	0a04a783          	lw	a5,160(s1)
    800003a0:	09c4a703          	lw	a4,156(s1)
    800003a4:	fcf71ee3          	bne	a4,a5,80000380 <consoleintr+0xd4>
    800003a8:	6902                	ld	s2,0(sp)
    800003aa:	bf15                	j	800002de <consoleintr+0x32>
    800003ac:	6902                	ld	s2,0(sp)
    800003ae:	bf05                	j	800002de <consoleintr+0x32>
    800003b0:	6902                	ld	s2,0(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b4:	00013717          	auipc	a4,0x13
    800003b8:	49c70713          	addi	a4,a4,1180 # 80013850 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00013717          	auipc	a4,0x13
    800003ce:	52f72323          	sw	a5,1318(a4) # 800138f0 <cons+0xa0>
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	ea5ff0ef          	jal	8000027a <consputc>
    800003da:	b711                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	f00481e3          	beqz	s1,800002de <consoleintr+0x32>
    800003e0:	bf31                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003e2:	4529                	li	a0,10
    800003e4:	e97ff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e8:	00013797          	auipc	a5,0x13
    800003ec:	46878793          	addi	a5,a5,1128 # 80013850 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00013797          	auipc	a5,0x13
    8000040e:	4ec7a123          	sw	a2,1250(a5) # 800138ec <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00013517          	auipc	a0,0x13
    80000416:	4d650513          	addi	a0,a0,1238 # 800138e8 <cons+0x98>
    8000041a:	404020ef          	jal	8000281e <wakeup>
    8000041e:	b5c1                	j	800002de <consoleintr+0x32>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00008597          	auipc	a1,0x8
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80008000 <etext>
    80000430:	00013517          	auipc	a0,0x13
    80000434:	42050513          	addi	a0,a0,1056 # 80013850 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	02265797          	auipc	a5,0x2265
    80000444:	58078793          	addi	a5,a5,1408 # 822659c0 <devsw>
    80000448:	00000717          	auipc	a4,0x0
    8000044c:	d2e70713          	addi	a4,a4,-722 # 80000176 <consoleread>
    80000450:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000452:	00000717          	auipc	a4,0x0
    80000456:	c8270713          	addi	a4,a4,-894 # 800000d4 <consolewrite>
    8000045a:	ef98                	sd	a4,24(a5)
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f04a                	sd	s2,32(sp)
    8000046c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046e:	c219                	beqz	a2,80000474 <printint+0x10>
    80000470:	08054163          	bltz	a0,800004f2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000474:	4301                	li	t1,0

  i = 0;
    80000476:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000047a:	86ca                	mv	a3,s2
  i = 0;
    8000047c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00008817          	auipc	a6,0x8
    80000482:	5c280813          	addi	a6,a6,1474 # 80008a40 <digits>
    80000486:	88ba                	mv	a7,a4
    80000488:	0017061b          	addiw	a2,a4,1
    8000048c:	8732                	mv	a4,a2
    8000048e:	02b577b3          	remu	a5,a0,a1
    80000492:	97c2                	add	a5,a5,a6
    80000494:	0007c783          	lbu	a5,0(a5)
    80000498:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000049c:	87aa                	mv	a5,a0
    8000049e:	02b55533          	divu	a0,a0,a1
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	feb7f1e3          	bgeu	a5,a1,80000486 <printint+0x22>

  if(sign)
    800004a8:	00030c63          	beqz	t1,800004c0 <printint+0x5c>
    buf[i++] = '-';
    800004ac:	fe060793          	addi	a5,a2,-32
    800004b0:	00878633          	add	a2,a5,s0
    800004b4:	02d00793          	li	a5,45
    800004b8:	fef60423          	sb	a5,-24(a2)
    800004bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800004c0:	02e05463          	blez	a4,800004e8 <printint+0x84>
    800004c4:	f426                	sd	s1,40(sp)
    800004c6:	377d                	addiw	a4,a4,-1
    800004c8:	00e904b3          	add	s1,s2,a4
    800004cc:	197d                	addi	s2,s2,-1
    800004ce:	993a                	add	s2,s2,a4
    800004d0:	1702                	slli	a4,a4,0x20
    800004d2:	9301                	srli	a4,a4,0x20
    800004d4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004d8:	0004c503          	lbu	a0,0(s1)
    800004dc:	d9fff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x74>
    800004e6:	74a2                	ld	s1,40(sp)
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4305                	li	t1,1
    x = -xx;
    800004f8:	bfbd                	j	80000476 <printint+0x12>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	f0ca                	sd	s2,96(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	892a                	mv	s2,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	0000b797          	auipc	a5,0xb
    8000051c:	30c7a783          	lw	a5,780(a5) # 8000b824 <panicking>
    80000520:	cf9d                	beqz	a5,8000055e <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	00094503          	lbu	a0,0(s2)
    8000052e:	22050663          	beqz	a0,8000075a <printf+0x260>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	ecce                	sd	s3,88(sp)
    80000536:	e8d2                	sd	s4,80(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	fc5e                	sd	s7,56(sp)
    8000053e:	f862                	sd	s8,48(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4a01                	li	s4,0
    if(cx != '%'){
    80000546:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000054a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000054e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000552:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000556:	4b29                	li	s6,10
    if(c0 == 'd'){
    80000558:	06400b93          	li	s7,100
    8000055c:	a015                	j	80000580 <printf+0x86>
    acquire(&pr.lock);
    8000055e:	00013517          	auipc	a0,0x13
    80000562:	39a50513          	addi	a0,a0,922 # 800138f8 <pr>
    80000566:	6c2000ef          	jal	80000c28 <acquire>
    8000056a:	bf65                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056c:	d0fff0ef          	jal	8000027a <consputc>
      continue;
    80000570:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	2485                	addiw	s1,s1,1
    80000574:	8a26                	mv	s4,s1
    80000576:	94ca                	add	s1,s1,s2
    80000578:	0004c503          	lbu	a0,0(s1)
    8000057c:	1c050663          	beqz	a0,80000748 <printf+0x24e>
    if(cx != '%'){
    80000580:	ff3516e3          	bne	a0,s3,8000056c <printf+0x72>
    i++;
    80000584:	001a079b          	addiw	a5,s4,1
    80000588:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058a:	00f90733          	add	a4,s2,a5
    8000058e:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000592:	200a8963          	beqz	s5,800007a4 <printf+0x2aa>
    80000596:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059a:	1e068c63          	beqz	a3,80000792 <printf+0x298>
    if(c0 == 'd'){
    8000059e:	037a8863          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800005a2:	f94a8713          	addi	a4,s5,-108
    800005a6:	00173713          	seqz	a4,a4
    800005aa:	f9c68613          	addi	a2,a3,-100
    800005ae:	ee05                	bnez	a2,800005e6 <printf+0xec>
    800005b0:	cb1d                	beqz	a4,800005e6 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	85da                	mv	a1,s6
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	ea1ff0ef          	jal	80000464 <printint>
      i += 1;
    800005c8:	002a049b          	addiw	s1,s4,2
    800005cc:	b75d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	85da                	mv	a1,s6
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e85ff0ef          	jal	80000464 <printint>
    800005e4:	b779                	j	80000572 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800005e6:	97ca                	add	a5,a5,s2
    800005e8:	8636                	mv	a2,a3
    800005ea:	0027c683          	lbu	a3,2(a5)
    800005ee:	a2c9                	j	800007b0 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005f0:	f8843783          	ld	a5,-120(s0)
    800005f4:	00878713          	addi	a4,a5,8
    800005f8:	f8e43423          	sd	a4,-120(s0)
    800005fc:	4605                	li	a2,1
    800005fe:	45a9                	li	a1,10
    80000600:	6388                	ld	a0,0(a5)
    80000602:	e63ff0ef          	jal	80000464 <printint>
      i += 2;
    80000606:	003a049b          	addiw	s1,s4,3
    8000060a:	b7a5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000060c:	f8843783          	ld	a5,-120(s0)
    80000610:	00878713          	addi	a4,a5,8
    80000614:	f8e43423          	sd	a4,-120(s0)
    80000618:	4601                	li	a2,0
    8000061a:	85da                	mv	a1,s6
    8000061c:	0007e503          	lwu	a0,0(a5)
    80000620:	e45ff0ef          	jal	80000464 <printint>
    80000624:	b7b9                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4601                	li	a2,0
    80000634:	85da                	mv	a1,s6
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2dff0ef          	jal	80000464 <printint>
      i += 1;
    8000063c:	002a049b          	addiw	s1,s4,2
    80000640:	bf0d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45a9                	li	a1,10
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e11ff0ef          	jal	80000464 <printint>
      i += 2;
    80000658:	003a049b          	addiw	s1,s4,3
    8000065c:	bf19                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4601                	li	a2,0
    8000066c:	45c1                	li	a1,16
    8000066e:	0007e503          	lwu	a0,0(a5)
    80000672:	df3ff0ef          	jal	80000464 <printint>
    80000676:	bdf5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	45c1                	li	a1,16
    80000686:	6388                	ld	a0,0(a5)
    80000688:	dddff0ef          	jal	80000464 <printint>
      i += 1;
    8000068c:	002a049b          	addiw	s1,s4,2
    80000690:	b5cd                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45c1                	li	a1,16
    800006a2:	6388                	ld	a0,0(a5)
    800006a4:	dc1ff0ef          	jal	80000464 <printint>
      i += 2;
    800006a8:	003a049b          	addiw	s1,s4,3
    800006ac:	b5d9                	j	80000572 <printf+0x78>
    800006ae:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c0:	03000513          	li	a0,48
    800006c4:	bb7ff0ef          	jal	8000027a <consputc>
  consputc('x');
    800006c8:	07800513          	li	a0,120
    800006cc:	bafff0ef          	jal	8000027a <consputc>
    800006d0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	00008c97          	auipc	s9,0x8
    800006d6:	36ec8c93          	addi	s9,s9,878 # 80008a40 <digits>
    800006da:	03cad793          	srli	a5,s5,0x3c
    800006de:	97e6                	add	a5,a5,s9
    800006e0:	0007c503          	lbu	a0,0(a5)
    800006e4:	b97ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e8:	0a92                	slli	s5,s5,0x4
    800006ea:	3a7d                	addiw	s4,s4,-1
    800006ec:	fe0a17e3          	bnez	s4,800006da <printf+0x1e0>
    800006f0:	7ca2                	ld	s9,40(sp)
    800006f2:	b541                	j	80000572 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	4388                	lw	a0,0(a5)
    80000702:	b79ff0ef          	jal	8000027a <consputc>
    80000706:	b5b5                	j	80000572 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80000708:	f8843783          	ld	a5,-120(s0)
    8000070c:	00878713          	addi	a4,a5,8
    80000710:	f8e43423          	sd	a4,-120(s0)
    80000714:	0007ba03          	ld	s4,0(a5)
    80000718:	000a0d63          	beqz	s4,80000732 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000071c:	000a4503          	lbu	a0,0(s4)
    80000720:	e40509e3          	beqz	a0,80000572 <printf+0x78>
        consputc(*s);
    80000724:	b57ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    80000728:	0a05                	addi	s4,s4,1
    8000072a:	000a4503          	lbu	a0,0(s4)
    8000072e:	f97d                	bnez	a0,80000724 <printf+0x22a>
    80000730:	b589                	j	80000572 <printf+0x78>
        s = "(null)";
    80000732:	00008a17          	auipc	s4,0x8
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7dd                	j	80000724 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80000740:	8556                	mv	a0,s5
    80000742:	b39ff0ef          	jal	8000027a <consputc>
    80000746:	b535                	j	80000572 <printf+0x78>
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000075a:	0000b797          	auipc	a5,0xb
    8000075e:	0ca7a783          	lw	a5,202(a5) # 8000b824 <panicking>
    80000762:	c38d                	beqz	a5,80000784 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80000764:	4501                	li	a0,0
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7d02                	ld	s10,32(sp)
    80000780:	6de2                	ld	s11,24(sp)
    80000782:	bfe1                	j	8000075a <printf+0x260>
    release(&pr.lock);
    80000784:	00013517          	auipc	a0,0x13
    80000788:	17450513          	addi	a0,a0,372 # 800138f8 <pr>
    8000078c:	530000ef          	jal	80000cbc <release>
  return 0;
    80000790:	bfd1                	j	80000764 <printf+0x26a>
    if(c0 == 'd'){
    80000792:	e37a8ee3          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80000796:	f94a8713          	addi	a4,s5,-108
    8000079a:	00173713          	seqz	a4,a4
    8000079e:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007a0:	4781                	li	a5,0
    800007a2:	a00d                	j	800007c4 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a4:	f94a8713          	addi	a4,s5,-108
    800007a8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007ac:	8656                	mv	a2,s5
    800007ae:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007b0:	f9460793          	addi	a5,a2,-108
    800007b4:	0017b793          	seqz	a5,a5
    800007b8:	8ff9                	and	a5,a5,a4
    800007ba:	f9c68593          	addi	a1,a3,-100
    800007be:	e199                	bnez	a1,800007c4 <printf+0x2ca>
    800007c0:	e20798e3          	bnez	a5,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800007c4:	e58a84e3          	beq	s5,s8,8000060c <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800007c8:	f8b60593          	addi	a1,a2,-117
    800007cc:	e199                	bnez	a1,800007d2 <printf+0x2d8>
    800007ce:	e4071ce3          	bnez	a4,80000626 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800007d2:	f8b68593          	addi	a1,a3,-117
    800007d6:	e199                	bnez	a1,800007dc <printf+0x2e2>
    800007d8:	e60795e3          	bnez	a5,80000642 <printf+0x148>
    } else if(c0 == 'x'){
    800007dc:	e9aa81e3          	beq	s5,s10,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800007e0:	f8860613          	addi	a2,a2,-120
    800007e4:	e219                	bnez	a2,800007ea <printf+0x2f0>
    800007e6:	e80719e3          	bnez	a4,80000678 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800007ea:	f8868693          	addi	a3,a3,-120
    800007ee:	e299                	bnez	a3,800007f4 <printf+0x2fa>
    800007f0:	ea0791e3          	bnez	a5,80000692 <printf+0x198>
    } else if(c0 == 'p'){
    800007f4:	ebba8de3          	beq	s5,s11,800006ae <printf+0x1b4>
    } else if(c0 == 'c'){
    800007f8:	06300793          	li	a5,99
    800007fc:	eefa8ce3          	beq	s5,a5,800006f4 <printf+0x1fa>
    } else if(c0 == 's'){
    80000800:	07300793          	li	a5,115
    80000804:	f0fa82e3          	beq	s5,a5,80000708 <printf+0x20e>
    } else if(c0 == '%'){
    80000808:	02500793          	li	a5,37
    8000080c:	f2fa8ae3          	beq	s5,a5,80000740 <printf+0x246>
    } else if(c0 == 0){
    80000810:	f60a80e3          	beqz	s5,80000770 <printf+0x276>
      consputc('%');
    80000814:	02500513          	li	a0,37
    80000818:	a63ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    8000081c:	8556                	mv	a0,s5
    8000081e:	a5dff0ef          	jal	8000027a <consputc>
    80000822:	bb81                	j	80000572 <printf+0x78>

0000000080000824 <panic>:

void
panic(char *s)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	e04a                	sd	s2,0(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	892a                	mv	s2,a0
  panicking = 1;
    80000832:	4485                	li	s1,1
    80000834:	0000b797          	auipc	a5,0xb
    80000838:	fe97a823          	sw	s1,-16(a5) # 8000b824 <panicking>
  printf("panic: ");
    8000083c:	00007517          	auipc	a0,0x7
    80000840:	7dc50513          	addi	a0,a0,2012 # 80008018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00007517          	auipc	a0,0x7
    8000084e:	7d650513          	addi	a0,a0,2006 # 80008020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	0000b797          	auipc	a5,0xb
    8000085a:	fc97a523          	sw	s1,-54(a5) # 8000b820 <panicked>
  for(;;)
    8000085e:	a001                	j	8000085e <panic+0x3a>

0000000080000860 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000868:	00007597          	auipc	a1,0x7
    8000086c:	7c058593          	addi	a1,a1,1984 # 80008028 <etext+0x28>
    80000870:	00013517          	auipc	a0,0x13
    80000874:	08850513          	addi	a0,a0,136 # 800138f8 <pr>
    80000878:	326000ef          	jal	80000b9e <initlock>
}
    8000087c:	60a2                	ld	ra,8(sp)
    8000087e:	6402                	ld	s0,0(sp)
    80000880:	0141                	addi	sp,sp,16
    80000882:	8082                	ret

0000000080000884 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000088c:	100007b7          	lui	a5,0x10000
    80000890:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000894:	10000737          	lui	a4,0x10000
    80000898:	f8000693          	li	a3,-128
    8000089c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008a0:	468d                	li	a3,3
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008aa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008ae:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008b2:	8732                	mv	a4,a2
    800008b4:	461d                	li	a2,7
    800008b6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ba:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008be:	00007597          	auipc	a1,0x7
    800008c2:	77258593          	addi	a1,a1,1906 # 80008030 <etext+0x30>
    800008c6:	00013517          	auipc	a0,0x13
    800008ca:	04a50513          	addi	a0,a0,74 # 80013910 <tx_lock>
    800008ce:	2d0000ef          	jal	80000b9e <initlock>
}
    800008d2:	60a2                	ld	ra,8(sp)
    800008d4:	6402                	ld	s0,0(sp)
    800008d6:	0141                	addi	sp,sp,16
    800008d8:	8082                	ret

00000000800008da <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008da:	715d                	addi	sp,sp,-80
    800008dc:	e486                	sd	ra,72(sp)
    800008de:	e0a2                	sd	s0,64(sp)
    800008e0:	fc26                	sd	s1,56(sp)
    800008e2:	ec56                	sd	s5,24(sp)
    800008e4:	0880                	addi	s0,sp,80
    800008e6:	8aaa                	mv	s5,a0
    800008e8:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008ea:	00013517          	auipc	a0,0x13
    800008ee:	02650513          	addi	a0,a0,38 # 80013910 <tx_lock>
    800008f2:	336000ef          	jal	80000c28 <acquire>

  int i = 0;
  while(i < n){ 
    800008f6:	06905063          	blez	s1,80000956 <uartwrite+0x7c>
    800008fa:	f84a                	sd	s2,48(sp)
    800008fc:	f44e                	sd	s3,40(sp)
    800008fe:	f052                	sd	s4,32(sp)
    80000900:	e85a                	sd	s6,16(sp)
    80000902:	e45e                	sd	s7,8(sp)
    80000904:	8a56                	mv	s4,s5
    80000906:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000908:	0000b497          	auipc	s1,0xb
    8000090c:	f2448493          	addi	s1,s1,-220 # 8000b82c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00013997          	auipc	s3,0x13
    80000914:	00098993          	mv	s3,s3
    80000918:	0000b917          	auipc	s2,0xb
    8000091c:	f1090913          	addi	s2,s2,-240 # 8000b828 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80000920:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000924:	4b05                	li	s6,1
    80000926:	a005                	j	80000946 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000928:	85ce                	mv	a1,s3
    8000092a:	854a                	mv	a0,s2
    8000092c:	6a7010ef          	jal	800027d2 <sleep>
    while(tx_busy != 0){
    80000930:	409c                	lw	a5,0(s1)
    80000932:	fbfd                	bnez	a5,80000928 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000934:	000a4783          	lbu	a5,0(s4)
    80000938:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000093c:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80000940:	0a05                	addi	s4,s4,1
    80000942:	015a0563          	beq	s4,s5,8000094c <uartwrite+0x72>
    while(tx_busy != 0){
    80000946:	409c                	lw	a5,0(s1)
    80000948:	f3e5                	bnez	a5,80000928 <uartwrite+0x4e>
    8000094a:	b7ed                	j	80000934 <uartwrite+0x5a>
    8000094c:	7942                	ld	s2,48(sp)
    8000094e:	79a2                	ld	s3,40(sp)
    80000950:	7a02                	ld	s4,32(sp)
    80000952:	6b42                	ld	s6,16(sp)
    80000954:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000956:	00013517          	auipc	a0,0x13
    8000095a:	fba50513          	addi	a0,a0,-70 # 80013910 <tx_lock>
    8000095e:	35e000ef          	jal	80000cbc <release>
}
    80000962:	60a6                	ld	ra,72(sp)
    80000964:	6406                	ld	s0,64(sp)
    80000966:	74e2                	ld	s1,56(sp)
    80000968:	6ae2                	ld	s5,24(sp)
    8000096a:	6161                	addi	sp,sp,80
    8000096c:	8082                	ret

000000008000096e <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
    80000978:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000097a:	0000b797          	auipc	a5,0xb
    8000097e:	eaa7a783          	lw	a5,-342(a5) # 8000b824 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	0000b797          	auipc	a5,0xb
    80000988:	e9c7a783          	lw	a5,-356(a5) # 8000b820 <panicked>
    8000098c:	ef85                	bnez	a5,800009c4 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000098e:	10000737          	lui	a4,0x10000
    80000992:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000994:	00074783          	lbu	a5,0(a4)
    80000998:	0207f793          	andi	a5,a5,32
    8000099c:	dfe5                	beqz	a5,80000994 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000099e:	0ff4f513          	zext.b	a0,s1
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800009aa:	0000b797          	auipc	a5,0xb
    800009ae:	e7a7a783          	lw	a5,-390(a5) # 8000b824 <panicking>
    800009b2:	cb91                	beqz	a5,800009c6 <uartputc_sync+0x58>
    pop_off();
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    push_off();
    800009be:	226000ef          	jal	80000be4 <push_off>
    800009c2:	b7c9                	j	80000984 <uartputc_sync+0x16>
    for(;;)
    800009c4:	a001                	j	800009c4 <uartputc_sync+0x56>
    pop_off();
    800009c6:	2a6000ef          	jal	80000c6c <pop_off>
}
    800009ca:	b7ed                	j	800009b4 <uartputc_sync+0x46>

00000000800009cc <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800009d4:	100007b7          	lui	a5,0x10000
    800009d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009dc:	8b85                	andi	a5,a5,1
    800009de:	cb89                	beqz	a5,800009f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009e8:	60a2                	ld	ra,8(sp)
    800009ea:	6402                	ld	s0,0(sp)
    800009ec:	0141                	addi	sp,sp,16
    800009ee:	8082                	ret
    return -1;
    800009f0:	557d                	li	a0,-1
    800009f2:	bfdd                	j	800009e8 <uartgetc+0x1c>

00000000800009f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a06:	00013517          	auipc	a0,0x13
    80000a0a:	f0a50513          	addi	a0,a0,-246 # 80013910 <tx_lock>
    80000a0e:	21a000ef          	jal	80000c28 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000a12:	100007b7          	lui	a5,0x10000
    80000a16:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1a:	0207f793          	andi	a5,a5,32
    80000a1e:	ef99                	bnez	a5,80000a3c <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a20:	00013517          	auipc	a0,0x13
    80000a24:	ef050513          	addi	a0,a0,-272 # 80013910 <tx_lock>
    80000a28:	294000ef          	jal	80000cbc <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	f9fff0ef          	jal	800009cc <uartgetc>
    if(c == -1)
    80000a32:	02950063          	beq	a0,s1,80000a52 <uartintr+0x5e>
      break;
    consoleintr(c);
    80000a36:	877ff0ef          	jal	800002ac <consoleintr>
  while(1){
    80000a3a:	bfd5                	j	80000a2e <uartintr+0x3a>
    tx_busy = 0;
    80000a3c:	0000b797          	auipc	a5,0xb
    80000a40:	de07a823          	sw	zero,-528(a5) # 8000b82c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	0000b517          	auipc	a0,0xb
    80000a48:	de450513          	addi	a0,a0,-540 # 8000b828 <tx_chan>
    80000a4c:	5d3010ef          	jal	8000281e <wakeup>
    80000a50:	bfc1                	j	80000a20 <uartintr+0x2c>
  }
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	02266797          	auipc	a5,0x2266
    80000a6c:	0f078793          	addi	a5,a5,240 # 82266b58 <end>
    80000a70:	00f53733          	sltu	a4,a0,a5
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	17fd                	addi	a5,a5,-1
    80000a7a:	00a7b7b3          	sltu	a5,a5,a0
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	ef95                	bnez	a5,80000abc <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	eb95                	bnez	a5,80000abc <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	26a000ef          	jal	80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a92:	00013917          	auipc	s2,0x13
    80000a96:	e9690913          	addi	s2,s2,-362 # 80013928 <kmem>
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	18c000ef          	jal	80000c28 <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	210000ef          	jal	80000cbc <release>
}
    80000ab0:	60e2                	ld	ra,24(sp)
    80000ab2:	6442                	ld	s0,16(sp)
    80000ab4:	64a2                	ld	s1,8(sp)
    80000ab6:	6902                	ld	s2,0(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    panic("kfree");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80008038 <etext+0x38>
    80000ac4:	d61ff0ef          	jal	80000824 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e263          	bltu	a1,s1,80000b06 <freerange+0x3e>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	f67ff0ef          	jal	80000a5c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afa:	94ce                	add	s1,s1,s3
    80000afc:	fe997be3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b00:	6942                	ld	s2,16(sp)
    80000b02:	69a2                	ld	s3,8(sp)
    80000b04:	6a02                	ld	s4,0(sp)
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6145                	addi	sp,sp,48
    80000b0e:	8082                	ret

0000000080000b10 <kinit>:
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b18:	00007597          	auipc	a1,0x7
    80000b1c:	52858593          	addi	a1,a1,1320 # 80008040 <etext+0x40>
    80000b20:	00013517          	auipc	a0,0x13
    80000b24:	e0850513          	addi	a0,a0,-504 # 80013928 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	02266517          	auipc	a0,0x2266
    80000b34:	02850513          	addi	a0,a0,40 # 82266b58 <end>
    80000b38:	f91ff0ef          	jal	80000ac8 <freerange>
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret

0000000080000b44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b4e:	00013517          	auipc	a0,0x13
    80000b52:	dda50513          	addi	a0,a0,-550 # 80013928 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00013497          	auipc	s1,0x13
    80000b5e:	de64b483          	ld	s1,-538(s1) # 80013940 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00013717          	auipc	a4,0x13
    80000b6a:	dcf73d23          	sd	a5,-550(a4) # 80013940 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00013517          	auipc	a0,0x13
    80000b72:	dba50513          	addi	a0,a0,-582 # 80013928 <kmem>
    80000b76:	146000ef          	jal	80000cbc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7a:	6605                	lui	a2,0x1
    80000b7c:	4595                	li	a1,5
    80000b7e:	8526                	mv	a0,s1
    80000b80:	178000ef          	jal	80000cf8 <memset>
  return (void*)r;
}
    80000b84:	8526                	mv	a0,s1
    80000b86:	60e2                	ld	ra,24(sp)
    80000b88:	6442                	ld	s0,16(sp)
    80000b8a:	64a2                	ld	s1,8(sp)
    80000b8c:	6105                	addi	sp,sp,32
    80000b8e:	8082                	ret
  release(&kmem.lock);
    80000b90:	00013517          	auipc	a0,0x13
    80000b94:	d9850513          	addi	a0,a0,-616 # 80013928 <kmem>
    80000b98:	124000ef          	jal	80000cbc <release>
  if(r)
    80000b9c:	b7e5                	j	80000b84 <kalloc+0x40>

0000000080000b9e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b9e:	1141                	addi	sp,sp,-16
    80000ba0:	e406                	sd	ra,8(sp)
    80000ba2:	e022                	sd	s0,0(sp)
    80000ba4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ba8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bac:	00053823          	sd	zero,16(a0)
}
    80000bb0:	60a2                	ld	ra,8(sp)
    80000bb2:	6402                	ld	s0,0(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	411c                	lw	a5,0(a0)
    80000bba:	e399                	bnez	a5,80000bc0 <holding+0x8>
    80000bbc:	4501                	li	a0,0
  return r;
}
    80000bbe:	8082                	ret
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bca:	691c                	ld	a5,16(a0)
    80000bcc:	84be                	mv	s1,a5
    80000bce:	4c6010ef          	jal	80002094 <mycpu>
    80000bd2:	40a48533          	sub	a0,s1,a0
    80000bd6:	00153513          	seqz	a0,a0
}
    80000bda:	60e2                	ld	ra,24(sp)
    80000bdc:	6442                	ld	s0,16(sp)
    80000bde:	64a2                	ld	s1,8(sp)
    80000be0:	6105                	addi	sp,sp,32
    80000be2:	8082                	ret

0000000080000be4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bee:	100027f3          	csrr	a5,sstatus
    80000bf2:	84be                	mv	s1,a5
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bfe:	496010ef          	jal	80002094 <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	48e010ef          	jal	80002094 <mycpu>
    80000c0a:	5d3c                	lw	a5,120(a0)
    80000c0c:	2785                	addiw	a5,a5,1
    80000c0e:	dd3c                	sw	a5,120(a0)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    mycpu()->intena = old;
    80000c1a:	47a010ef          	jal	80002094 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c1e:	0014d793          	srli	a5,s1,0x1
    80000c22:	8b85                	andi	a5,a5,1
    80000c24:	dd7c                	sw	a5,124(a0)
    80000c26:	b7c5                	j	80000c06 <push_off+0x22>

0000000080000c28 <acquire>:
{
    80000c28:	1101                	addi	sp,sp,-32
    80000c2a:	ec06                	sd	ra,24(sp)
    80000c2c:	e822                	sd	s0,16(sp)
    80000c2e:	e426                	sd	s1,8(sp)
    80000c30:	1000                	addi	s0,sp,32
    80000c32:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c34:	fb1ff0ef          	jal	80000be4 <push_off>
  if(holding(lk))
    80000c38:	8526                	mv	a0,s1
    80000c3a:	f7fff0ef          	jal	80000bb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e105                	bnez	a0,80000c60 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x1a>
  __sync_synchronize();
    80000c4c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c50:	444010ef          	jal	80002094 <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	3e850513          	addi	a0,a0,1000 # 80008048 <etext+0x48>
    80000c68:	bbdff0ef          	jal	80000824 <panic>

0000000080000c6c <pop_off>:

void
pop_off(void)
{
    80000c6c:	1141                	addi	sp,sp,-16
    80000c6e:	e406                	sd	ra,8(sp)
    80000c70:	e022                	sd	s0,0(sp)
    80000c72:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c74:	420010ef          	jal	80002094 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7e:	e39d                	bnez	a5,80000ca4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c80:	5d3c                	lw	a5,120(a0)
    80000c82:	02f05763          	blez	a5,80000cb0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c86:	37fd                	addiw	a5,a5,-1
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb89                	bnez	a5,80000c9c <pop_off+0x30>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80008050 <etext+0x50>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3b850513          	addi	a0,a0,952 # 80008068 <etext+0x68>
    80000cb8:	b6dff0ef          	jal	80000824 <panic>

0000000080000cbc <release>:
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
    80000cc6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc8:	ef1ff0ef          	jal	80000bb8 <holding>
    80000ccc:	c105                	beqz	a0,80000cec <release+0x30>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cd6:	0310000f          	fence	rw,w
    80000cda:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cde:	f8fff0ef          	jal	80000c6c <pop_off>
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret
    panic("release");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	38450513          	addi	a0,a0,900 # 80008070 <etext+0x70>
    80000cf4:	b31ff0ef          	jal	80000824 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e406                	sd	ra,8(sp)
    80000cfc:	e022                	sd	s0,0(sp)
    80000cfe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1e>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x14>
  }
  return dst;
}
    80000d16:	60a2                	ld	ra,8(sp)
    80000d18:	6402                	ld	s0,0(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e406                	sd	ra,8(sp)
    80000d22:	e022                	sd	s0,0(sp)
    80000d24:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d26:	c61d                	beqz	a2,80000d54 <memcmp+0x36>
    80000d28:	1602                	slli	a2,a2,0x20
    80000d2a:	9201                	srli	a2,a2,0x20
    80000d2c:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x12>
  }

  return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x2e>
      return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	60a2                	ld	ra,8(sp)
    80000d4e:	6402                	ld	s0,0(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  return 0;
    80000d54:	4501                	li	a0,0
    80000d56:	bfdd                	j	80000d4c <memcmp+0x2e>

0000000080000d58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d60:	c205                	beqz	a2,80000d80 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d62:	02a5e363          	bltu	a1,a0,80000d88 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d66:	1602                	slli	a2,a2,0x20
    80000d68:	9201                	srli	a2,a2,0x20
    80000d6a:	00c587b3          	add	a5,a1,a2
{
    80000d6e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d70:	0585                	addi	a1,a1,1
    80000d72:	0705                	addi	a4,a4,1
    80000d74:	fff5c683          	lbu	a3,-1(a1)
    80000d78:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d7c:	feb79ae3          	bne	a5,a1,80000d70 <memmove+0x18>

  return dst;
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
  if(s < d && s + n > d){
    80000d88:	02061693          	slli	a3,a2,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	00d58733          	add	a4,a1,a3
    80000d92:	fce57ae3          	bgeu	a0,a4,80000d66 <memmove+0xe>
    d += n;
    80000d96:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d98:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d9c:	1782                	slli	a5,a5,0x20
    80000d9e:	9381                	srli	a5,a5,0x20
    80000da0:	fff7c793          	not	a5,a5
    80000da4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da6:	177d                	addi	a4,a4,-1
    80000da8:	16fd                	addi	a3,a3,-1
    80000daa:	00074603          	lbu	a2,0(a4)
    80000dae:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000db2:	fee79ae3          	bne	a5,a4,80000da6 <memmove+0x4e>
    80000db6:	b7e9                	j	80000d80 <memmove+0x28>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	f99ff0ef          	jal	80000d58 <memmove>
}
    80000dc4:	60a2                	ld	ra,8(sp)
    80000dc6:	6402                	ld	s0,0(sp)
    80000dc8:	0141                	addi	sp,sp,16
    80000dca:	8082                	ret

0000000080000dcc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dcc:	1141                	addi	sp,sp,-16
    80000dce:	e406                	sd	ra,8(sp)
    80000dd0:	e022                	sd	s0,0(sp)
    80000dd2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd4:	ce11                	beqz	a2,80000df0 <strncmp+0x24>
    80000dd6:	00054783          	lbu	a5,0(a0)
    80000dda:	cf89                	beqz	a5,80000df4 <strncmp+0x28>
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	00f71a63          	bne	a4,a5,80000df4 <strncmp+0x28>
    n--, p++, q++;
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	0505                	addi	a0,a0,1
    80000de8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dea:	f675                	bnez	a2,80000dd6 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dec:	4501                	li	a0,0
    80000dee:	a801                	j	80000dfe <strncmp+0x32>
    80000df0:	4501                	li	a0,0
    80000df2:	a031                	j	80000dfe <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000df4:	00054503          	lbu	a0,0(a0)
    80000df8:	0005c783          	lbu	a5,0(a1)
    80000dfc:	9d1d                	subw	a0,a0,a5
}
    80000dfe:	60a2                	ld	ra,8(sp)
    80000e00:	6402                	ld	s0,0(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e406                	sd	ra,8(sp)
    80000e0a:	e022                	sd	s0,0(sp)
    80000e0c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e0e:	87aa                	mv	a5,a0
    80000e10:	a011                	j	80000e14 <strncpy+0xe>
    80000e12:	8636                	mv	a2,a3
    80000e14:	02c05863          	blez	a2,80000e44 <strncpy+0x3e>
    80000e18:	fff6069b          	addiw	a3,a2,-1
    80000e1c:	8836                	mv	a6,a3
    80000e1e:	0785                	addi	a5,a5,1
    80000e20:	0005c703          	lbu	a4,0(a1)
    80000e24:	fee78fa3          	sb	a4,-1(a5)
    80000e28:	0585                	addi	a1,a1,1
    80000e2a:	f765                	bnez	a4,80000e12 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e2c:	873e                	mv	a4,a5
    80000e2e:	01005b63          	blez	a6,80000e44 <strncpy+0x3e>
    80000e32:	9fb1                	addw	a5,a5,a2
    80000e34:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e36:	0705                	addi	a4,a4,1
    80000e38:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e3c:	40e786bb          	subw	a3,a5,a4
    80000e40:	fed04be3          	bgtz	a3,80000e36 <strncpy+0x30>
  return os;
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2e>
    80000e58:	fff6069b          	addiw	a3,a2,-1
    80000e5c:	1682                	slli	a3,a3,0x20
    80000e5e:	9281                	srli	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x2a>
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	60a2                	ld	ra,8(sp)
    80000e7c:	6402                	ld	s0,0(sp)
    80000e7e:	0141                	addi	sp,sp,16
    80000e80:	8082                	ret

0000000080000e82 <strlen>:

int
strlen(const char *s)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8a:	00054783          	lbu	a5,0(a0)
    80000e8e:	cf91                	beqz	a5,80000eaa <strlen+0x28>
    80000e90:	00150793          	addi	a5,a0,1
    80000e94:	86be                	mv	a3,a5
    80000e96:	0785                	addi	a5,a5,1
    80000e98:	fff7c703          	lbu	a4,-1(a5)
    80000e9c:	ff65                	bnez	a4,80000e94 <strlen+0x12>
    80000e9e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000ea2:	60a2                	ld	ra,8(sp)
    80000ea4:	6402                	ld	s0,0(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eaa:	4501                	li	a0,0
    80000eac:	bfdd                	j	80000ea2 <strlen+0x20>

0000000080000eae <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e406                	sd	ra,8(sp)
    80000eb2:	e022                	sd	s0,0(sp)
    80000eb4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb6:	1ca010ef          	jal	80002080 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	0000b717          	auipc	a4,0xb
    80000ebe:	97670713          	addi	a4,a4,-1674 # 8000b830 <started>
  if(cpuid() == 0){
    80000ec2:	c51d                	beqz	a0,80000ef0 <main+0x42>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x16>
      ;
    __sync_synchronize();
    80000eca:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ece:	1b2010ef          	jal	80002080 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1bc50513          	addi	a0,a0,444 # 80008090 <etext+0x90>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	679010ef          	jal	80002d5c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	360050ef          	jal	80006248 <plicinithart>
  }

  scheduler();        
    80000eec:	746010ef          	jal	80002632 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	24850513          	addi	a0,a0,584 # 80008140 <etext+0x140>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	17450513          	addi	a0,a0,372 # 80008078 <etext+0x78>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	23050513          	addi	a0,a0,560 # 80008140 <etext+0x140>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2cc000ef          	jal	800011ec <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	09e010ef          	jal	80001fc6 <procinit>
    trapinit();      // trap vectors
    80000f2c:	60d010ef          	jal	80002d38 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	62d010ef          	jal	80002d5c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	2fa050ef          	jal	8000622e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	310050ef          	jal	80006248 <plicinithart>
    binit();         // buffer cache
    80000f3c:	6f0020ef          	jal	8000362c <binit>
    iinit();         // inode table
    80000f40:	443020ef          	jal	80003b82 <iinit>
    fileinit();      // file table
    80000f44:	36f030ef          	jal	80004ab2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	3f0050ef          	jal	80006338 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	482010ef          	jal	800023ce <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	0000b717          	auipc	a4,0xb
    80000f5a:	8cf72d23          	sw	a5,-1830(a4) # 8000b830 <started>
    80000f5e:	b779                	j	80000eec <main+0x3e>

0000000080000f60 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
    void
kvminithart()
{
    80000f60:	1141                	addi	sp,sp,-16
    80000f62:	e406                	sd	ra,8(sp)
    80000f64:	e022                	sd	s0,0(sp)
    80000f66:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f68:	12000073          	sfence.vma
    // wait for any previous writes to the page table memory to finish.
    sfence_vma();

    w_satp(MAKE_SATP(kernel_pagetable));
    80000f6c:	0000b797          	auipc	a5,0xb
    80000f70:	8cc7b783          	ld	a5,-1844(a5) # 8000b838 <kernel_pagetable>
    80000f74:	83b1                	srli	a5,a5,0xc
    80000f76:	577d                	li	a4,-1
    80000f78:	177e                	slli	a4,a4,0x3f
    80000f7a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f7c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f80:	12000073          	sfence.vma

    // flush stale entries from the TLB.
    sfence_vma();
}
    80000f84:	60a2                	ld	ra,8(sp)
    80000f86:	6402                	ld	s0,0(sp)
    80000f88:	0141                	addi	sp,sp,16
    80000f8a:	8082                	ret

0000000080000f8c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
    pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f8c:	7139                	addi	sp,sp,-64
    80000f8e:	fc06                	sd	ra,56(sp)
    80000f90:	f822                	sd	s0,48(sp)
    80000f92:	f426                	sd	s1,40(sp)
    80000f94:	f04a                	sd	s2,32(sp)
    80000f96:	ec4e                	sd	s3,24(sp)
    80000f98:	e852                	sd	s4,16(sp)
    80000f9a:	e456                	sd	s5,8(sp)
    80000f9c:	e05a                	sd	s6,0(sp)
    80000f9e:	0080                	addi	s0,sp,64
    80000fa0:	84aa                	mv	s1,a0
    80000fa2:	89ae                	mv	s3,a1
    80000fa4:	8b32                	mv	s6,a2
    if(va >= MAXVA)
    80000fa6:	57fd                	li	a5,-1
    80000fa8:	83e9                	srli	a5,a5,0x1a
    80000faa:	4a79                	li	s4,30
        panic("walk");

    for(int level = 2; level > 0; level--) {
    80000fac:	4ab1                	li	s5,12
    if(va >= MAXVA)
    80000fae:	04b7e263          	bltu	a5,a1,80000ff2 <walk+0x66>
        pte_t *pte = &pagetable[PX(level, va)];
    80000fb2:	0149d933          	srl	s2,s3,s4
    80000fb6:	1ff97913          	andi	s2,s2,511
    80000fba:	090e                	slli	s2,s2,0x3
    80000fbc:	9926                	add	s2,s2,s1
        if(*pte & PTE_V) {
    80000fbe:	00093483          	ld	s1,0(s2)
    80000fc2:	0014f793          	andi	a5,s1,1
    80000fc6:	cf85                	beqz	a5,80000ffe <walk+0x72>
            pagetable = (pagetable_t)PTE2PA(*pte);
    80000fc8:	80a9                	srli	s1,s1,0xa
    80000fca:	04b2                	slli	s1,s1,0xc
    for(int level = 2; level > 0; level--) {
    80000fcc:	3a5d                	addiw	s4,s4,-9
    80000fce:	ff5a12e3          	bne	s4,s5,80000fb2 <walk+0x26>
                return 0;
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
    80000fd2:	00c9d513          	srli	a0,s3,0xc
    80000fd6:	1ff57513          	andi	a0,a0,511
    80000fda:	050e                	slli	a0,a0,0x3
    80000fdc:	9526                	add	a0,a0,s1
}
    80000fde:	70e2                	ld	ra,56(sp)
    80000fe0:	7442                	ld	s0,48(sp)
    80000fe2:	74a2                	ld	s1,40(sp)
    80000fe4:	7902                	ld	s2,32(sp)
    80000fe6:	69e2                	ld	s3,24(sp)
    80000fe8:	6a42                	ld	s4,16(sp)
    80000fea:	6aa2                	ld	s5,8(sp)
    80000fec:	6b02                	ld	s6,0(sp)
    80000fee:	6121                	addi	sp,sp,64
    80000ff0:	8082                	ret
        panic("walk");
    80000ff2:	00007517          	auipc	a0,0x7
    80000ff6:	0b650513          	addi	a0,a0,182 # 800080a8 <etext+0xa8>
    80000ffa:	82bff0ef          	jal	80000824 <panic>
            if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ffe:	020b0263          	beqz	s6,80001022 <walk+0x96>
    80001002:	b43ff0ef          	jal	80000b44 <kalloc>
    80001006:	84aa                	mv	s1,a0
    80001008:	d979                	beqz	a0,80000fde <walk+0x52>
            memset(pagetable, 0, PGSIZE);
    8000100a:	6605                	lui	a2,0x1
    8000100c:	4581                	li	a1,0
    8000100e:	cebff0ef          	jal	80000cf8 <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    80001012:	00c4d793          	srli	a5,s1,0xc
    80001016:	07aa                	slli	a5,a5,0xa
    80001018:	0017e793          	ori	a5,a5,1
    8000101c:	00f93023          	sd	a5,0(s2)
    80001020:	b775                	j	80000fcc <walk+0x40>
                return 0;
    80001022:	4501                	li	a0,0
    80001024:	bf6d                	j	80000fde <walk+0x52>

0000000080001026 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if(va >= MAXVA)
    80001026:	57fd                	li	a5,-1
    80001028:	83e9                	srli	a5,a5,0x1a
    8000102a:	00b7f463          	bgeu	a5,a1,80001032 <walkaddr+0xc>
        return 0;
    8000102e:	4501                	li	a0,0
        return 0;
    if((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80001030:	8082                	ret
{
    80001032:	1141                	addi	sp,sp,-16
    80001034:	e406                	sd	ra,8(sp)
    80001036:	e022                	sd	s0,0(sp)
    80001038:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    8000103a:	4601                	li	a2,0
    8000103c:	f51ff0ef          	jal	80000f8c <walk>
    if(pte == 0)
    80001040:	c901                	beqz	a0,80001050 <walkaddr+0x2a>
    if((*pte & PTE_V) == 0)
    80001042:	611c                	ld	a5,0(a0)
    if((*pte & PTE_U) == 0)
    80001044:	0117f693          	andi	a3,a5,17
    80001048:	4745                	li	a4,17
        return 0;
    8000104a:	4501                	li	a0,0
    if((*pte & PTE_U) == 0)
    8000104c:	00e68663          	beq	a3,a4,80001058 <walkaddr+0x32>
}
    80001050:	60a2                	ld	ra,8(sp)
    80001052:	6402                	ld	s0,0(sp)
    80001054:	0141                	addi	sp,sp,16
    80001056:	8082                	ret
    pa = PTE2PA(*pte);
    80001058:	83a9                	srli	a5,a5,0xa
    8000105a:	00c79513          	slli	a0,a5,0xc
    return pa;
    8000105e:	bfcd                	j	80001050 <walkaddr+0x2a>

0000000080001060 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
    int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001060:	715d                	addi	sp,sp,-80
    80001062:	e486                	sd	ra,72(sp)
    80001064:	e0a2                	sd	s0,64(sp)
    80001066:	fc26                	sd	s1,56(sp)
    80001068:	f84a                	sd	s2,48(sp)
    8000106a:	f44e                	sd	s3,40(sp)
    8000106c:	f052                	sd	s4,32(sp)
    8000106e:	ec56                	sd	s5,24(sp)
    80001070:	e85a                	sd	s6,16(sp)
    80001072:	e45e                	sd	s7,8(sp)
    80001074:	0880                	addi	s0,sp,80
    uint64 a, last;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    80001076:	03459793          	slli	a5,a1,0x34
    8000107a:	eba1                	bnez	a5,800010ca <mappages+0x6a>
    8000107c:	8a2a                	mv	s4,a0
    8000107e:	8aba                	mv	s5,a4
        panic("mappages: va not aligned");

    if((size % PGSIZE) != 0)
    80001080:	03461793          	slli	a5,a2,0x34
    80001084:	eba9                	bnez	a5,800010d6 <mappages+0x76>
        panic("mappages: size not aligned");

    if(size == 0)
    80001086:	ce31                	beqz	a2,800010e2 <mappages+0x82>
        panic("mappages: size");

    a = va;
    last = va + size - PGSIZE;
    80001088:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000108c:	80060613          	addi	a2,a2,-2048
    80001090:	00b60933          	add	s2,a2,a1
    a = va;
    80001094:	84ae                	mv	s1,a1
    for(;;){
        if((pte = walk(pagetable, a, 1)) == 0)
    80001096:	4b05                	li	s6,1
    80001098:	40b689b3          	sub	s3,a3,a1
        if(*pte & PTE_V)
            panic("mappages: remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if(a == last)
            break;
        a += PGSIZE;
    8000109c:	6b85                	lui	s7,0x1
        if((pte = walk(pagetable, a, 1)) == 0)
    8000109e:	865a                	mv	a2,s6
    800010a0:	85a6                	mv	a1,s1
    800010a2:	8552                	mv	a0,s4
    800010a4:	ee9ff0ef          	jal	80000f8c <walk>
    800010a8:	c929                	beqz	a0,800010fa <mappages+0x9a>
        if(*pte & PTE_V)
    800010aa:	611c                	ld	a5,0(a0)
    800010ac:	8b85                	andi	a5,a5,1
    800010ae:	e3a1                	bnez	a5,800010ee <mappages+0x8e>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800010b0:	013487b3          	add	a5,s1,s3
    800010b4:	83b1                	srli	a5,a5,0xc
    800010b6:	07aa                	slli	a5,a5,0xa
    800010b8:	0157e7b3          	or	a5,a5,s5
    800010bc:	0017e793          	ori	a5,a5,1
    800010c0:	e11c                	sd	a5,0(a0)
        if(a == last)
    800010c2:	05248863          	beq	s1,s2,80001112 <mappages+0xb2>
        a += PGSIZE;
    800010c6:	94de                	add	s1,s1,s7
        if((pte = walk(pagetable, a, 1)) == 0)
    800010c8:	bfd9                	j	8000109e <mappages+0x3e>
        panic("mappages: va not aligned");
    800010ca:	00007517          	auipc	a0,0x7
    800010ce:	fe650513          	addi	a0,a0,-26 # 800080b0 <etext+0xb0>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
        panic("mappages: size not aligned");
    800010d6:	00007517          	auipc	a0,0x7
    800010da:	ffa50513          	addi	a0,a0,-6 # 800080d0 <etext+0xd0>
    800010de:	f46ff0ef          	jal	80000824 <panic>
        panic("mappages: size");
    800010e2:	00007517          	auipc	a0,0x7
    800010e6:	00e50513          	addi	a0,a0,14 # 800080f0 <etext+0xf0>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
            panic("mappages: remap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	01250513          	addi	a0,a0,18 # 80008100 <etext+0x100>
    800010f6:	f2eff0ef          	jal	80000824 <panic>
            return -1;
    800010fa:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    800010fc:	60a6                	ld	ra,72(sp)
    800010fe:	6406                	ld	s0,64(sp)
    80001100:	74e2                	ld	s1,56(sp)
    80001102:	7942                	ld	s2,48(sp)
    80001104:	79a2                	ld	s3,40(sp)
    80001106:	7a02                	ld	s4,32(sp)
    80001108:	6ae2                	ld	s5,24(sp)
    8000110a:	6b42                	ld	s6,16(sp)
    8000110c:	6ba2                	ld	s7,8(sp)
    8000110e:	6161                	addi	sp,sp,80
    80001110:	8082                	ret
    return 0;
    80001112:	4501                	li	a0,0
    80001114:	b7e5                	j	800010fc <mappages+0x9c>

0000000080001116 <kvmmap>:
{
    80001116:	1141                	addi	sp,sp,-16
    80001118:	e406                	sd	ra,8(sp)
    8000111a:	e022                	sd	s0,0(sp)
    8000111c:	0800                	addi	s0,sp,16
    8000111e:	87b6                	mv	a5,a3
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001120:	86b2                	mv	a3,a2
    80001122:	863e                	mv	a2,a5
    80001124:	f3dff0ef          	jal	80001060 <mappages>
    80001128:	e509                	bnez	a0,80001132 <kvmmap+0x1c>
}
    8000112a:	60a2                	ld	ra,8(sp)
    8000112c:	6402                	ld	s0,0(sp)
    8000112e:	0141                	addi	sp,sp,16
    80001130:	8082                	ret
        panic("kvmmap");
    80001132:	00007517          	auipc	a0,0x7
    80001136:	fde50513          	addi	a0,a0,-34 # 80008110 <etext+0x110>
    8000113a:	eeaff0ef          	jal	80000824 <panic>

000000008000113e <kvmmake>:
{
    8000113e:	1101                	addi	sp,sp,-32
    80001140:	ec06                	sd	ra,24(sp)
    80001142:	e822                	sd	s0,16(sp)
    80001144:	e426                	sd	s1,8(sp)
    80001146:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t) kalloc();
    80001148:	9fdff0ef          	jal	80000b44 <kalloc>
    8000114c:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    8000114e:	6605                	lui	a2,0x1
    80001150:	4581                	li	a1,0
    80001152:	ba7ff0ef          	jal	80000cf8 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001156:	4719                	li	a4,6
    80001158:	6685                	lui	a3,0x1
    8000115a:	10000637          	lui	a2,0x10000
    8000115e:	85b2                	mv	a1,a2
    80001160:	8526                	mv	a0,s1
    80001162:	fb5ff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001166:	4719                	li	a4,6
    80001168:	6685                	lui	a3,0x1
    8000116a:	10001637          	lui	a2,0x10001
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	fa5ff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001176:	4719                	li	a4,6
    80001178:	040006b7          	lui	a3,0x4000
    8000117c:	0c000637          	lui	a2,0xc000
    80001180:	85b2                	mv	a1,a2
    80001182:	8526                	mv	a0,s1
    80001184:	f93ff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001188:	4729                	li	a4,10
    8000118a:	80007697          	auipc	a3,0x80007
    8000118e:	e7668693          	addi	a3,a3,-394 # 8000 <_entry-0x7fff8000>
    80001192:	4605                	li	a2,1
    80001194:	067e                	slli	a2,a2,0x1f
    80001196:	85b2                	mv	a1,a2
    80001198:	8526                	mv	a0,s1
    8000119a:	f7dff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119e:	4719                	li	a4,6
    800011a0:	00007697          	auipc	a3,0x7
    800011a4:	e6068693          	addi	a3,a3,-416 # 80008000 <etext>
    800011a8:	47c5                	li	a5,17
    800011aa:	07ee                	slli	a5,a5,0x1b
    800011ac:	40d786b3          	sub	a3,a5,a3
    800011b0:	00007617          	auipc	a2,0x7
    800011b4:	e5060613          	addi	a2,a2,-432 # 80008000 <etext>
    800011b8:	85b2                	mv	a1,a2
    800011ba:	8526                	mv	a0,s1
    800011bc:	f5bff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	4729                	li	a4,10
    800011c2:	6685                	lui	a3,0x1
    800011c4:	00006617          	auipc	a2,0x6
    800011c8:	e3c60613          	addi	a2,a2,-452 # 80007000 <_trampoline>
    800011cc:	040005b7          	lui	a1,0x4000
    800011d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d2:	05b2                	slli	a1,a1,0xc
    800011d4:	8526                	mv	a0,s1
    800011d6:	f41ff0ef          	jal	80001116 <kvmmap>
    proc_mapstacks(kpgtbl);
    800011da:	8526                	mv	a0,s1
    800011dc:	543000ef          	jal	80001f1e <proc_mapstacks>
}
    800011e0:	8526                	mv	a0,s1
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <kvminit>:
{
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e406                	sd	ra,8(sp)
    800011f0:	e022                	sd	s0,0(sp)
    800011f2:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    800011f4:	f4bff0ef          	jal	8000113e <kvmmake>
    800011f8:	0000a797          	auipc	a5,0xa
    800011fc:	64a7b023          	sd	a0,1600(a5) # 8000b838 <kernel_pagetable>
}
    80001200:	60a2                	ld	ra,8(sp)
    80001202:	6402                	ld	s0,0(sp)
    80001204:	0141                	addi	sp,sp,16
    80001206:	8082                	ret

0000000080001208 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
    pagetable_t
uvmcreate()
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    80001212:	933ff0ef          	jal	80000b44 <kalloc>
    80001216:	84aa                	mv	s1,a0
    if(pagetable == 0)
    80001218:	c509                	beqz	a0,80001222 <uvmcreate+0x1a>
        return 0;
    memset(pagetable, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	adbff0ef          	jal	80000cf8 <memset>
    return pagetable;
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
    void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000122e:	7139                	addi	sp,sp,-64
    80001230:	fc06                	sd	ra,56(sp)
    80001232:	f822                	sd	s0,48(sp)
    80001234:	0080                	addi	s0,sp,64
    uint64 a;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    80001236:	03459793          	slli	a5,a1,0x34
    8000123a:	e38d                	bnez	a5,8000125c <uvmunmap+0x2e>
    8000123c:	f04a                	sd	s2,32(sp)
    8000123e:	ec4e                	sd	s3,24(sp)
    80001240:	e852                	sd	s4,16(sp)
    80001242:	e456                	sd	s5,8(sp)
    80001244:	e05a                	sd	s6,0(sp)
    80001246:	8a2a                	mv	s4,a0
    80001248:	892e                	mv	s2,a1
    8000124a:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124c:	0632                	slli	a2,a2,0xc
    8000124e:	00b609b3          	add	s3,a2,a1
    80001252:	6b05                	lui	s6,0x1
    80001254:	0535f963          	bgeu	a1,s3,800012a6 <uvmunmap+0x78>
    80001258:	f426                	sd	s1,40(sp)
    8000125a:	a015                	j	8000127e <uvmunmap+0x50>
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	e05a                	sd	s6,0(sp)
        panic("uvmunmap: not aligned");
    80001268:	00007517          	auipc	a0,0x7
    8000126c:	eb050513          	addi	a0,a0,-336 # 80008118 <etext+0x118>
    80001270:	db4ff0ef          	jal	80000824 <panic>
            continue;
        if(do_free){
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        *pte = 0;
    80001274:	0004b023          	sd	zero,0(s1)
    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001278:	995a                	add	s2,s2,s6
    8000127a:	03397563          	bgeu	s2,s3,800012a4 <uvmunmap+0x76>
        if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000127e:	4601                	li	a2,0
    80001280:	85ca                	mv	a1,s2
    80001282:	8552                	mv	a0,s4
    80001284:	d09ff0ef          	jal	80000f8c <walk>
    80001288:	84aa                	mv	s1,a0
    8000128a:	d57d                	beqz	a0,80001278 <uvmunmap+0x4a>
        if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000128c:	611c                	ld	a5,0(a0)
    8000128e:	0017f713          	andi	a4,a5,1
    80001292:	d37d                	beqz	a4,80001278 <uvmunmap+0x4a>
        if(do_free){
    80001294:	fe0a80e3          	beqz	s5,80001274 <uvmunmap+0x46>
            uint64 pa = PTE2PA(*pte);
    80001298:	83a9                	srli	a5,a5,0xa
            kfree((void*)pa);
    8000129a:	00c79513          	slli	a0,a5,0xc
    8000129e:	fbeff0ef          	jal	80000a5c <kfree>
    800012a2:	bfc9                	j	80001274 <uvmunmap+0x46>
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	7902                	ld	s2,32(sp)
    800012a8:	69e2                	ld	s3,24(sp)
    800012aa:	6a42                	ld	s4,16(sp)
    800012ac:	6aa2                	ld	s5,8(sp)
    800012ae:	6b02                	ld	s6,0(sp)
    }
}
    800012b0:	70e2                	ld	ra,56(sp)
    800012b2:	7442                	ld	s0,48(sp)
    800012b4:	6121                	addi	sp,sp,64
    800012b6:	8082                	ret

00000000800012b8 <handle_pgfault>:
{
    800012b8:	7115                	addi	sp,sp,-224
    800012ba:	ed86                	sd	ra,216(sp)
    800012bc:	e9a2                	sd	s0,208(sp)
    800012be:	e1ca                	sd	s2,192(sp)
    800012c0:	e566                	sd	s9,136(sp)
    800012c2:	e16a                	sd	s10,128(sp)
    800012c4:	1180                	addi	s0,sp,224
    800012c6:	8d2a                	mv	s10,a0
    800012c8:	892e                	mv	s2,a1
    800012ca:	8cb2                	mv	s9,a2
    struct proc *p = myproc();
    800012cc:	5e9000ef          	jal	800020b4 <myproc>
    if(va >= MAXVA){
    800012d0:	57fd                	li	a5,-1
    800012d2:	83e9                	srli	a5,a5,0x1a
    800012d4:	5727e763          	bltu	a5,s2,80001842 <handle_pgfault+0x58a>
    800012d8:	e5a6                	sd	s1,200(sp)
    800012da:	fd4e                	sd	s3,184(sp)
    800012dc:	f952                	sd	s4,176(sp)
    800012de:	84aa                	mv	s1,a0
    mem = kalloc();
    800012e0:	865ff0ef          	jal	80000b44 <kalloc>
    800012e4:	89aa                	mv	s3,a0
    if(mem == 0){
    800012e6:	c925                	beqz	a0,80001356 <handle_pgfault+0x9e>
       va = PGROUNDDOWN(va);
    800012e8:	77fd                	lui	a5,0xfffff
    800012ea:	00f97933          	and	s2,s2,a5
    memset(mem, 0, PGSIZE);
    800012ee:	6605                	lui	a2,0x1
    800012f0:	4581                	li	a1,0
    800012f2:	854e                	mv	a0,s3
    800012f4:	a05ff0ef          	jal	80000cf8 <memset>
    for(int i = 0; i < p->num_swappped_pages; i++){
    800012f8:	000897b7          	lui	a5,0x89
    800012fc:	97a6                	add	a5,a5,s1
    800012fe:	1cc7a603          	lw	a2,460(a5) # 891cc <_entry-0x7ff76e34>
    80001302:	00c05f63          	blez	a2,80001320 <handle_pgfault+0x68>
    80001306:	00089737          	lui	a4,0x89
    8000130a:	df070713          	addi	a4,a4,-528 # 88df0 <_entry-0x7ff77210>
    8000130e:	9726                	add	a4,a4,s1
    80001310:	4781                	li	a5,0
        if(p->swapped_pages[i].va == va){
    80001312:	6314                	ld	a3,0(a4)
    80001314:	23268463          	beq	a3,s2,8000153c <handle_pgfault+0x284>
    for(int i = 0; i < p->num_swappped_pages; i++){
    80001318:	2785                	addiw	a5,a5,1
    8000131a:	0741                	addi	a4,a4,16
    8000131c:	fec79be3          	bne	a5,a2,80001312 <handle_pgfault+0x5a>
        readi(p->exec_ip, 0, (uint64)&elf, 0, sizeof(elf));
    80001320:	04000713          	li	a4,64
    80001324:	4681                	li	a3,0
    80001326:	f6040613          	addi	a2,s0,-160
    8000132a:	4581                	li	a1,0
    8000132c:	1704b503          	ld	a0,368(s1)
    80001330:	5ad020ef          	jal	800040dc <readi>
        for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    80001334:	f9845783          	lhu	a5,-104(s0)
    80001338:	42078463          	beqz	a5,80001760 <handle_pgfault+0x4a8>
    8000133c:	f556                	sd	s5,168(sp)
    8000133e:	f15a                	sd	s6,160(sp)
    80001340:	ed5e                	sd	s7,152(sp)
    80001342:	e962                	sd	s8,144(sp)
    80001344:	f8042683          	lw	a3,-128(s0)
    80001348:	4a01                	li	s4,0
            readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    8000134a:	f2840c13          	addi	s8,s0,-216
    8000134e:	03800b93          	li	s7,56
            if(ph.type == ELF_PROG_LOAD && (va >= ph.vaddr && va < ph.vaddr + ph.memsz)) {
    80001352:	4b05                	li	s6,1
    80001354:	a681                	j	80001694 <handle_pgfault+0x3dc>
    80001356:	f556                	sd	s5,168(sp)
    printf("[pid %d] MEMFULL\n",p->pid);
    80001358:	588c                	lw	a1,48(s1)
    8000135a:	00007517          	auipc	a0,0x7
    8000135e:	dd650513          	addi	a0,a0,-554 # 80008130 <etext+0x130>
    80001362:	998ff0ef          	jal	800004fa <printf>
    for(int i = 1;i<p->num_resident;i++){
    80001366:	000897b7          	lui	a5,0x89
    8000136a:	97a6                	add	a5,a5,s1
    8000136c:	1b07a503          	lw	a0,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001370:	4785                	li	a5,1
    80001372:	02a7d663          	bge	a5,a0,8000139e <handle_pgfault+0xe6>
    80001376:	28848693          	addi	a3,s1,648
    int victim_inx = 0;
    8000137a:	4581                	li	a1,0
    for(int i = 1;i<p->num_resident;i++){
    8000137c:	873e                	mv	a4,a5
    8000137e:	a029                	j	80001388 <handle_pgfault+0xd0>
    80001380:	2705                	addiw	a4,a4,1
    80001382:	06c1                	addi	a3,a3,16 # 1010 <_entry-0x7fffeff0>
    80001384:	00a70e63          	beq	a4,a0,800013a0 <handle_pgfault+0xe8>
        if(p->resident_pages[i].seq < p->resident_pages[victim_inx].seq){
    80001388:	00459793          	slli	a5,a1,0x4
    8000138c:	27078793          	addi	a5,a5,624
    80001390:	97a6                	add	a5,a5,s1
    80001392:	4290                	lw	a2,0(a3)
    80001394:	479c                	lw	a5,8(a5)
    80001396:	fef655e3          	bge	a2,a5,80001380 <handle_pgfault+0xc8>
            victim_inx = i;
    8000139a:	85ba                	mv	a1,a4
    8000139c:	b7d5                	j	80001380 <handle_pgfault+0xc8>
    int victim_inx = 0;
    8000139e:	4581                	li	a1,0
    uint64 va = p->resident_pages[victim_inx].va;
    800013a0:	0592                	slli	a1,a1,0x4
    800013a2:	00b48a33          	add	s4,s1,a1
    800013a6:	270a3a83          	ld	s5,624(s4)
    int dirty = p->resident_pages[victim_inx].dirty;
    800013aa:	27ca2983          	lw	s3,636(s4)
    printf("[pid %d] VICTIM va=0x%lx seq=%d algo=FIFO\n",p->pid,va,seq);
    800013ae:	278a2683          	lw	a3,632(s4)
    800013b2:	8656                	mv	a2,s5
    800013b4:	588c                	lw	a1,48(s1)
    800013b6:	00007517          	auipc	a0,0x7
    800013ba:	d9250513          	addi	a0,a0,-622 # 80008148 <etext+0x148>
    800013be:	93cff0ef          	jal	800004fa <printf>
    if(dirty){
    800013c2:	10098563          	beqz	s3,800014cc <handle_pgfault+0x214>
        printf("[pid %d] EVICT va=0x%lx state=dirty\n",p->pid,va);
    800013c6:	8656                	mv	a2,s5
    800013c8:	588c                	lw	a1,48(s1)
    800013ca:	00007517          	auipc	a0,0x7
    800013ce:	dae50513          	addi	a0,a0,-594 # 80008178 <etext+0x178>
    800013d2:	928ff0ef          	jal	800004fa <printf>
    for(int i=0;i<MAX_SWAP_PAGES;i++){
    800013d6:	18048793          	addi	a5,s1,384
    800013da:	4981                	li	s3,0
    800013dc:	03c00693          	li	a3,60
        if(p->swap_slots[i]==0){
    800013e0:	4398                	lw	a4,0(a5)
    800013e2:	cf1d                	beqz	a4,80001420 <handle_pgfault+0x168>
    for(int i=0;i<MAX_SWAP_PAGES;i++){
    800013e4:	2985                	addiw	s3,s3,1 # ffffffff80013911 <end+0xfffffffefddacdb9>
    800013e6:	0791                	addi	a5,a5,4
    800013e8:	fed99ce3          	bne	s3,a3,800013e0 <handle_pgfault+0x128>
            printf("[pid %d] SWAPFULL\n", p->pid);
    800013ec:	588c                	lw	a1,48(s1)
    800013ee:	00007517          	auipc	a0,0x7
    800013f2:	db250513          	addi	a0,a0,-590 # 800081a0 <etext+0x1a0>
    800013f6:	904ff0ef          	jal	800004fa <printf>
            printf("[pid %d] KILL swap-exhausted\n", p->pid);
    800013fa:	588c                	lw	a1,48(s1)
    800013fc:	00007517          	auipc	a0,0x7
    80001400:	dbc50513          	addi	a0,a0,-580 # 800081b8 <etext+0x1b8>
    80001404:	8f6ff0ef          	jal	800004fa <printf>
            kexit(-1);
    80001408:	557d                	li	a0,-1
    8000140a:	4e8010ef          	jal	800028f2 <kexit>
            setkilled(p);
    8000140e:	8526                	mv	a0,s1
    80001410:	636010ef          	jal	80002a46 <setkilled>
            return -1;
    80001414:	557d                	li	a0,-1
    80001416:	64ae                	ld	s1,200(sp)
    80001418:	79ea                	ld	s3,184(sp)
    8000141a:	7a4a                	ld	s4,176(sp)
    8000141c:	7aaa                	ld	s5,168(sp)
    8000141e:	a425                	j	80001646 <handle_pgfault+0x38e>
            p->swap_slots[i]=1;
    80001420:	00299793          	slli	a5,s3,0x2
    80001424:	18078793          	addi	a5,a5,384
    80001428:	97a6                	add	a5,a5,s1
    8000142a:	4705                	li	a4,1
    8000142c:	c398                	sw	a4,0(a5)
        if(slot == -1){
    8000142e:	57fd                	li	a5,-1
    80001430:	faf98ee3          	beq	s3,a5,800013ec <handle_pgfault+0x134>
    80001434:	f15a                	sd	s6,160(sp)
        printf("[pid %d] SWAPOUT va=0x%lx slot=%d\n", p->pid, va, slot);
    80001436:	86ce                	mv	a3,s3
    80001438:	8656                	mv	a2,s5
    8000143a:	588c                	lw	a1,48(s1)
    8000143c:	00007517          	auipc	a0,0x7
    80001440:	d9c50513          	addi	a0,a0,-612 # 800081d8 <etext+0x1d8>
    80001444:	8b6ff0ef          	jal	800004fa <printf>
        uint64 pa = walkaddr(p->pagetable, va);
    80001448:	85d6                	mv	a1,s5
    8000144a:	68a8                	ld	a0,80(s1)
    8000144c:	bdbff0ef          	jal	80001026 <walkaddr>
    80001450:	8b2a                	mv	s6,a0
        begin_op();
    80001452:	304030ef          	jal	80004756 <begin_op>
    if(p->swap_file == 0)
    80001456:	1784b783          	ld	a5,376(s1)
    8000145a:	cfa1                	beqz	a5,800014b2 <handle_pgfault+0x1fa>
    ilock(p->swap_file->ip);
    8000145c:	6f88                	ld	a0,24(a5)
    8000145e:	0ed020ef          	jal	80003d4a <ilock>
    int result = writei(p->swap_file->ip, 0, (uint64)page_content, slot * PGSIZE, PGSIZE);
    80001462:	1784b783          	ld	a5,376(s1)
    80001466:	6705                	lui	a4,0x1
    80001468:	00c9969b          	slliw	a3,s3,0xc
    8000146c:	865a                	mv	a2,s6
    8000146e:	4581                	li	a1,0
    80001470:	6f88                	ld	a0,24(a5)
    80001472:	55d020ef          	jal	800041ce <writei>
    80001476:	8b2a                	mv	s6,a0
    iunlock(p->swap_file->ip);
    80001478:	1784b783          	ld	a5,376(s1)
    8000147c:	6f88                	ld	a0,24(a5)
    8000147e:	17b020ef          	jal	80003df8 <iunlock>
        if (swap_write_page(p, slot, (char*)pa) != 0) {
    80001482:	6785                	lui	a5,0x1
    80001484:	02fb1763          	bne	s6,a5,800014b2 <handle_pgfault+0x1fa>
        end_op();
    80001488:	33e030ef          	jal	800047c6 <end_op>
        p->swapped_pages[p->num_swappped_pages].va = va;
    8000148c:	00089637          	lui	a2,0x89
    80001490:	00c486b3          	add	a3,s1,a2
    80001494:	1cc6a703          	lw	a4,460(a3)
    80001498:	00471793          	slli	a5,a4,0x4
    8000149c:	97a6                	add	a5,a5,s1
    8000149e:	97b2                	add	a5,a5,a2
    800014a0:	df57b823          	sd	s5,-528(a5) # df0 <_entry-0x7ffff210>
        p->swapped_pages[p->num_swappped_pages].slot = slot;
    800014a4:	df37ac23          	sw	s3,-520(a5)
        p->num_swappped_pages++;
    800014a8:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    800014aa:	1ce6a623          	sw	a4,460(a3)
    800014ae:	7b0a                	ld	s6,160(sp)
    800014b0:	a835                	j	800014ec <handle_pgfault+0x234>
            end_op();
    800014b2:	314030ef          	jal	800047c6 <end_op>
            printf("[pid %d] Write failed max file size execeded\n",p->pid);
    800014b6:	588c                	lw	a1,48(s1)
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d4850513          	addi	a0,a0,-696 # 80008200 <etext+0x200>
    800014c0:	83aff0ef          	jal	800004fa <printf>
            kexit(-1);
    800014c4:	557d                	li	a0,-1
    800014c6:	42c010ef          	jal	800028f2 <kexit>
    800014ca:	bf7d                	j	80001488 <handle_pgfault+0x1d0>
        printf("[pid %d] EVICT va=0x%lx state=clean\n",p->pid,va);
    800014cc:	8656                	mv	a2,s5
    800014ce:	588c                	lw	a1,48(s1)
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	d6050513          	addi	a0,a0,-672 # 80008230 <etext+0x230>
    800014d8:	822ff0ef          	jal	800004fa <printf>
        printf("[pid %d] DISCARD va=0x%lx\n",p->pid,va);
    800014dc:	8656                	mv	a2,s5
    800014de:	588c                	lw	a1,48(s1)
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	d7850513          	addi	a0,a0,-648 # 80008258 <etext+0x258>
    800014e8:	812ff0ef          	jal	800004fa <printf>
    uvmunmap(p->pagetable,va,1,1);
    800014ec:	4685                	li	a3,1
    800014ee:	8636                	mv	a2,a3
    800014f0:	85d6                	mv	a1,s5
    800014f2:	68a8                	ld	a0,80(s1)
    800014f4:	d3bff0ef          	jal	8000122e <uvmunmap>
    p->resident_pages[victim_inx] = p->resident_pages[p->num_resident - 1];
    800014f8:	000897b7          	lui	a5,0x89
    800014fc:	97a6                	add	a5,a5,s1
    800014fe:	1b07a703          	lw	a4,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001502:	377d                	addiw	a4,a4,-1
    80001504:	00471693          	slli	a3,a4,0x4
    80001508:	27068693          	addi	a3,a3,624
    8000150c:	96a6                	add	a3,a3,s1
    8000150e:	6290                	ld	a2,0(a3)
    80001510:	26ca3823          	sd	a2,624(s4)
    80001514:	6694                	ld	a3,8(a3)
    80001516:	26da3c23          	sd	a3,632(s4)
    p->num_resident--;
    8000151a:	1ae7a823          	sw	a4,432(a5)
        mem = kalloc();
    8000151e:	e26ff0ef          	jal	80000b44 <kalloc>
    80001522:	89aa                	mv	s3,a0
        if(mem == 0){
    80001524:	c119                	beqz	a0,8000152a <handle_pgfault+0x272>
    80001526:	7aaa                	ld	s5,168(sp)
    80001528:	b3c1                	j	800012e8 <handle_pgfault+0x30>
    8000152a:	f15a                	sd	s6,160(sp)
    8000152c:	ed5e                	sd	s7,152(sp)
    8000152e:	e962                	sd	s8,144(sp)
            panic("kalloc failed after eviction");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	d4850513          	addi	a0,a0,-696 # 80008278 <etext+0x278>
    80001538:	aecff0ef          	jal	80000824 <panic>
            swap_slot = p->swapped_pages[i].slot;
    8000153c:	0792                	slli	a5,a5,0x4
    8000153e:	97a6                	add	a5,a5,s1
    80001540:	000896b7          	lui	a3,0x89
    80001544:	97b6                	add	a5,a5,a3
    80001546:	df87aa03          	lw	s4,-520(a5)
            p->swapped_pages[i] = p->swapped_pages[p->num_swappped_pages - 1];
    8000154a:	367d                	addiw	a2,a2,-1 # 88fff <_entry-0x7ff77001>
    8000154c:	6725                	lui	a4,0x9
    8000154e:	8df70713          	addi	a4,a4,-1825 # 88df <_entry-0x7fff7721>
    80001552:	9732                	add	a4,a4,a2
    80001554:	0712                	slli	a4,a4,0x4
    80001556:	9726                	add	a4,a4,s1
    80001558:	630c                	ld	a1,0(a4)
    8000155a:	deb7b823          	sd	a1,-528(a5)
    8000155e:	6718                	ld	a4,8(a4)
    80001560:	dee7bc23          	sd	a4,-520(a5)
            p->num_swappped_pages--;
    80001564:	96a6                	add	a3,a3,s1
    80001566:	1cc6a623          	sw	a2,460(a3) # 891cc <_entry-0x7ff76e34>
            p->swap_slots[swap_slot] = 0; // Free the slot
    8000156a:	002a1793          	slli	a5,s4,0x2
    8000156e:	18078793          	addi	a5,a5,384
    80001572:	97a6                	add	a5,a5,s1
    80001574:	0007a023          	sw	zero,0(a5)
    if(swap_slot != -1) {
    80001578:	57fd                	li	a5,-1
    8000157a:	dafa03e3          	beq	s4,a5,80001320 <handle_pgfault+0x68>
        printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    8000157e:	00007717          	auipc	a4,0x7
    80001582:	d1a70713          	addi	a4,a4,-742 # 80008298 <etext+0x298>
    80001586:	86e6                	mv	a3,s9
    80001588:	864a                	mv	a2,s2
    8000158a:	588c                	lw	a1,48(s1)
    8000158c:	00007517          	auipc	a0,0x7
    80001590:	d1450513          	addi	a0,a0,-748 # 800082a0 <etext+0x2a0>
    80001594:	f67fe0ef          	jal	800004fa <printf>
        printf("[pid %d] SWAPIN va=0x%lx slot=%d\n", p->pid, va, swap_slot);
    80001598:	86d2                	mv	a3,s4
    8000159a:	864a                	mv	a2,s2
    8000159c:	588c                	lw	a1,48(s1)
    8000159e:	00007517          	auipc	a0,0x7
    800015a2:	d3250513          	addi	a0,a0,-718 # 800082d0 <etext+0x2d0>
    800015a6:	f55fe0ef          	jal	800004fa <printf>
        begin_op();
    800015aa:	1ac030ef          	jal	80004756 <begin_op>
        ilock(p->swap_file->ip);
    800015ae:	1784b783          	ld	a5,376(s1)
    800015b2:	6f88                	ld	a0,24(a5)
    800015b4:	796020ef          	jal	80003d4a <ilock>
        if(readi(p->swap_file->ip, 0, (uint64)mem, swap_slot * PGSIZE, PGSIZE) != PGSIZE){
    800015b8:	1784b783          	ld	a5,376(s1)
    800015bc:	6705                	lui	a4,0x1
    800015be:	00ca169b          	slliw	a3,s4,0xc
    800015c2:	864e                	mv	a2,s3
    800015c4:	4581                	li	a1,0
    800015c6:	6f88                	ld	a0,24(a5)
    800015c8:	315020ef          	jal	800040dc <readi>
    800015cc:	6785                	lui	a5,0x1
    800015ce:	08f51363          	bne	a0,a5,80001654 <handle_pgfault+0x39c>
        iunlock(p->swap_file->ip);
    800015d2:	1784b783          	ld	a5,376(s1)
    800015d6:	6f88                	ld	a0,24(a5)
    800015d8:	021020ef          	jal	80003df8 <iunlock>
        end_op();
    800015dc:	1ea030ef          	jal	800047c6 <end_op>
        if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    800015e0:	4749                	li	a4,18
    800015e2:	86ce                	mv	a3,s3
    800015e4:	6605                	lui	a2,0x1
    800015e6:	85ca                	mv	a1,s2
    800015e8:	856a                	mv	a0,s10
    800015ea:	a77ff0ef          	jal	80001060 <mappages>
    800015ee:	e541                	bnez	a0,80001676 <handle_pgfault+0x3be>
    if(p->num_resident >= MAX_RESIDENT_PAGES){
    800015f0:	000897b7          	lui	a5,0x89
    800015f4:	97a6                	add	a5,a5,s1
    800015f6:	1b07a703          	lw	a4,432(a5) # 891b0 <_entry-0x7ff76e50>
    800015fa:	67a5                	lui	a5,0x9
    800015fc:	8b778793          	addi	a5,a5,-1865 # 88b7 <_entry-0x7fff7749>
    80001600:	22e7c763          	blt	a5,a4,8000182e <handle_pgfault+0x576>
    p->resident_pages[i].va = va;
    80001604:	00471613          	slli	a2,a4,0x4
    80001608:	9626                	add	a2,a2,s1
    8000160a:	27263823          	sd	s2,624(a2) # 1270 <_entry-0x7fffed90>
    p->resident_pages[i].seq = p->next_fifo_seq++;
    8000160e:	000897b7          	lui	a5,0x89
    80001612:	97a6                	add	a5,a5,s1
    80001614:	1c87a583          	lw	a1,456(a5) # 891c8 <_entry-0x7ff76e38>
    80001618:	0015869b          	addiw	a3,a1,1
    8000161c:	1cd7a423          	sw	a3,456(a5)
    80001620:	26b62c23          	sw	a1,632(a2)
    p->resident_pages[i].dirty = 0;
    80001624:	26062e23          	sw	zero,636(a2)
    p->num_resident++;
    80001628:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000162a:	1ae7a823          	sw	a4,432(a5)
    printf("[pid %d] RESIDENT va=0x%lx seq=%d\n", p->pid, va, p->next_fifo_seq);
    8000162e:	864a                	mv	a2,s2
    80001630:	588c                	lw	a1,48(s1)
    80001632:	00007517          	auipc	a0,0x7
    80001636:	d4e50513          	addi	a0,a0,-690 # 80008380 <etext+0x380>
    8000163a:	ec1fe0ef          	jal	800004fa <printf>
    return 0; // Success
    8000163e:	4501                	li	a0,0
}
    80001640:	64ae                	ld	s1,200(sp)
    80001642:	79ea                	ld	s3,184(sp)
    80001644:	7a4a                	ld	s4,176(sp)
}
    80001646:	60ee                	ld	ra,216(sp)
    80001648:	644e                	ld	s0,208(sp)
    8000164a:	690e                	ld	s2,192(sp)
    8000164c:	6caa                	ld	s9,136(sp)
    8000164e:	6d0a                	ld	s10,128(sp)
    80001650:	612d                	addi	sp,sp,224
    80001652:	8082                	ret
    80001654:	f556                	sd	s5,168(sp)
    80001656:	f15a                	sd	s6,160(sp)
    80001658:	ed5e                	sd	s7,152(sp)
    8000165a:	e962                	sd	s8,144(sp)
            iunlock(p->swap_file->ip);
    8000165c:	1784b783          	ld	a5,376(s1)
    80001660:	6f88                	ld	a0,24(a5)
    80001662:	796020ef          	jal	80003df8 <iunlock>
            end_op();
    80001666:	160030ef          	jal	800047c6 <end_op>
            panic("swap_read_page failed");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	c8e50513          	addi	a0,a0,-882 # 800082f8 <etext+0x2f8>
    80001672:	9b2ff0ef          	jal	80000824 <panic>
            kfree(mem); return -1;
    80001676:	854e                	mv	a0,s3
    80001678:	be4ff0ef          	jal	80000a5c <kfree>
    8000167c:	557d                	li	a0,-1
    8000167e:	64ae                	ld	s1,200(sp)
    80001680:	79ea                	ld	s3,184(sp)
    80001682:	7a4a                	ld	s4,176(sp)
    80001684:	b7c9                	j	80001646 <handle_pgfault+0x38e>
        for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    80001686:	2a05                	addiw	s4,s4,1
    80001688:	038a869b          	addiw	a3,s5,56
    8000168c:	f9845783          	lhu	a5,-104(s0)
    80001690:	0cfa5463          	bge	s4,a5,80001758 <handle_pgfault+0x4a0>
            readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    80001694:	8ab6                	mv	s5,a3
    80001696:	875e                	mv	a4,s7
    80001698:	8662                	mv	a2,s8
    8000169a:	4581                	li	a1,0
    8000169c:	1704b503          	ld	a0,368(s1)
    800016a0:	23d020ef          	jal	800040dc <readi>
            if(ph.type == ELF_PROG_LOAD && (va >= ph.vaddr && va < ph.vaddr + ph.memsz)) {
    800016a4:	f2842783          	lw	a5,-216(s0)
    800016a8:	fd679fe3          	bne	a5,s6,80001686 <handle_pgfault+0x3ce>
    800016ac:	f3843783          	ld	a5,-200(s0)
    800016b0:	fcf96be3          	bltu	s2,a5,80001686 <handle_pgfault+0x3ce>
    800016b4:	f5043703          	ld	a4,-176(s0)
    800016b8:	973e                	add	a4,a4,a5
    800016ba:	fce976e3          	bgeu	s2,a4,80001686 <handle_pgfault+0x3ce>
                file_offset = ph.off + (va - ph.vaddr);
    800016be:	0009069b          	sext.w	a3,s2
    800016c2:	0007861b          	sext.w	a2,a5
    800016c6:	f3043a03          	ld	s4,-208(s0)
    800016ca:	40fa0a3b          	subw	s4,s4,a5
    800016ce:	012a0a3b          	addw	s4,s4,s2
                file_size_to_read = ph.filesz > (va - ph.vaddr) ? ph.filesz - (va - ph.vaddr) : 0;
    800016d2:	f4843703          	ld	a4,-184(s0)
    800016d6:	40f907b3          	sub	a5,s2,a5
    800016da:	4b01                	li	s6,0
    800016dc:	00e7fb63          	bgeu	a5,a4,800016f2 <handle_pgfault+0x43a>
    800016e0:	00c707bb          	addw	a5,a4,a2
    800016e4:	9f95                	subw	a5,a5,a3
    800016e6:	8b3e                	mv	s6,a5
                if(file_size_to_read > PGSIZE) file_size_to_read = PGSIZE;
    800016e8:	6705                	lui	a4,0x1
    800016ea:	00f77363          	bgeu	a4,a5,800016f0 <handle_pgfault+0x438>
    800016ee:	6b05                	lui	s6,0x1
    800016f0:	2b01                	sext.w	s6,s6
                perm_flags = flags2perm(ph.flags) | PTE_U;
    800016f2:	f2c42503          	lw	a0,-212(s0)
    800016f6:	321030ef          	jal	80005216 <flags2perm>
    800016fa:	8aaa                	mv	s5,a0
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    800016fc:	00007717          	auipc	a4,0x7
    80001700:	c1470713          	addi	a4,a4,-1004 # 80008310 <etext+0x310>
    80001704:	86e6                	mv	a3,s9
    80001706:	864a                	mv	a2,s2
    80001708:	588c                	lw	a1,48(s1)
    8000170a:	00007517          	auipc	a0,0x7
    8000170e:	b9650513          	addi	a0,a0,-1130 # 800082a0 <etext+0x2a0>
    80001712:	de9fe0ef          	jal	800004fa <printf>
            printf("[pid %d] LOADEXEC va=0x%lx\n", p->pid, va);
    80001716:	864a                	mv	a2,s2
    80001718:	588c                	lw	a1,48(s1)
    8000171a:	00007517          	auipc	a0,0x7
    8000171e:	bfe50513          	addi	a0,a0,-1026 # 80008318 <etext+0x318>
    80001722:	dd9fe0ef          	jal	800004fa <printf>
            if(readi(p->exec_ip, 0, (uint64)mem, file_offset, file_size_to_read) != file_size_to_read) {
    80001726:	875a                	mv	a4,s6
    80001728:	86d2                	mv	a3,s4
    8000172a:	864e                	mv	a2,s3
    8000172c:	4581                	li	a1,0
    8000172e:	1704b503          	ld	a0,368(s1)
    80001732:	1ab020ef          	jal	800040dc <readi>
    80001736:	09651263          	bne	a0,s6,800017ba <handle_pgfault+0x502>
                perm_flags = flags2perm(ph.flags) | PTE_U;
    8000173a:	010ae713          	ori	a4,s5,16
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, perm_flags) != 0) {
    8000173e:	2701                	sext.w	a4,a4
    80001740:	86ce                	mv	a3,s3
    80001742:	6605                	lui	a2,0x1
    80001744:	85ca                	mv	a1,s2
    80001746:	856a                	mv	a0,s10
    80001748:	919ff0ef          	jal	80001060 <mappages>
    8000174c:	ed3d                	bnez	a0,800017ca <handle_pgfault+0x512>
    8000174e:	7aaa                	ld	s5,168(sp)
    80001750:	7b0a                	ld	s6,160(sp)
    80001752:	6bea                	ld	s7,152(sp)
    80001754:	6c4a                	ld	s8,144(sp)
    80001756:	bd69                	j	800015f0 <handle_pgfault+0x338>
    80001758:	7aaa                	ld	s5,168(sp)
    8000175a:	7b0a                	ld	s6,160(sp)
    8000175c:	6bea                	ld	s7,152(sp)
    8000175e:	6c4a                	ld	s8,144(sp)
        } else if (va < p->sz) {
    80001760:	64bc                	ld	a5,72(s1)
    80001762:	06f96c63          	bltu	s2,a5,800017da <handle_pgfault+0x522>
        } else if(va >= p->trapframe->sp - PGSIZE && va < MAXVA) {
    80001766:	6cbc                	ld	a5,88(s1)
    80001768:	7b9c                	ld	a5,48(a5)
    8000176a:	80078793          	addi	a5,a5,-2048
    8000176e:	80078793          	addi	a5,a5,-2048
    80001772:	0af96663          	bltu	s2,a5,8000181e <handle_pgfault+0x566>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    80001776:	00007717          	auipc	a4,0x7
    8000177a:	bea70713          	addi	a4,a4,-1046 # 80008360 <etext+0x360>
    8000177e:	86e6                	mv	a3,s9
    80001780:	864a                	mv	a2,s2
    80001782:	588c                	lw	a1,48(s1)
    80001784:	00007517          	auipc	a0,0x7
    80001788:	b1c50513          	addi	a0,a0,-1252 # 800082a0 <etext+0x2a0>
    8000178c:	d6ffe0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n", p->pid, va);
    80001790:	864a                	mv	a2,s2
    80001792:	588c                	lw	a1,48(s1)
    80001794:	00007517          	auipc	a0,0x7
    80001798:	bac50513          	addi	a0,a0,-1108 # 80008340 <etext+0x340>
    8000179c:	d5ffe0ef          	jal	800004fa <printf>
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    800017a0:	4749                	li	a4,18
    800017a2:	86ce                	mv	a3,s3
    800017a4:	6605                	lui	a2,0x1
    800017a6:	85ca                	mv	a1,s2
    800017a8:	856a                	mv	a0,s10
    800017aa:	8b7ff0ef          	jal	80001060 <mappages>
    800017ae:	e40501e3          	beqz	a0,800015f0 <handle_pgfault+0x338>
                kfree(mem); return -1;
    800017b2:	854e                	mv	a0,s3
    800017b4:	aa8ff0ef          	jal	80000a5c <kfree>
    800017b8:	a0b5                	j	80001824 <handle_pgfault+0x56c>
                kfree(mem); return -1;
    800017ba:	854e                	mv	a0,s3
    800017bc:	aa0ff0ef          	jal	80000a5c <kfree>
    800017c0:	7aaa                	ld	s5,168(sp)
    800017c2:	7b0a                	ld	s6,160(sp)
    800017c4:	6bea                	ld	s7,152(sp)
    800017c6:	6c4a                	ld	s8,144(sp)
    800017c8:	a8b1                	j	80001824 <handle_pgfault+0x56c>
                kfree(mem); return -1;
    800017ca:	854e                	mv	a0,s3
    800017cc:	a90ff0ef          	jal	80000a5c <kfree>
    800017d0:	7aaa                	ld	s5,168(sp)
    800017d2:	7b0a                	ld	s6,160(sp)
    800017d4:	6bea                	ld	s7,152(sp)
    800017d6:	6c4a                	ld	s8,144(sp)
    800017d8:	a0b1                	j	80001824 <handle_pgfault+0x56c>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    800017da:	00007717          	auipc	a4,0x7
    800017de:	b5e70713          	addi	a4,a4,-1186 # 80008338 <etext+0x338>
    800017e2:	86e6                	mv	a3,s9
    800017e4:	864a                	mv	a2,s2
    800017e6:	588c                	lw	a1,48(s1)
    800017e8:	00007517          	auipc	a0,0x7
    800017ec:	ab850513          	addi	a0,a0,-1352 # 800082a0 <etext+0x2a0>
    800017f0:	d0bfe0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n", p->pid, va);
    800017f4:	864a                	mv	a2,s2
    800017f6:	588c                	lw	a1,48(s1)
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	b4850513          	addi	a0,a0,-1208 # 80008340 <etext+0x340>
    80001800:	cfbfe0ef          	jal	800004fa <printf>
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    80001804:	4749                	li	a4,18
    80001806:	86ce                	mv	a3,s3
    80001808:	6605                	lui	a2,0x1
    8000180a:	85ca                	mv	a1,s2
    8000180c:	856a                	mv	a0,s10
    8000180e:	853ff0ef          	jal	80001060 <mappages>
    80001812:	dc050fe3          	beqz	a0,800015f0 <handle_pgfault+0x338>
                kfree(mem); return -1;
    80001816:	854e                	mv	a0,s3
    80001818:	a44ff0ef          	jal	80000a5c <kfree>
    8000181c:	a021                	j	80001824 <handle_pgfault+0x56c>
            kfree(mem);
    8000181e:	854e                	mv	a0,s3
    80001820:	a3cff0ef          	jal	80000a5c <kfree>
                kfree(mem); return -1;
    80001824:	557d                	li	a0,-1
    80001826:	64ae                	ld	s1,200(sp)
    80001828:	79ea                	ld	s3,184(sp)
    8000182a:	7a4a                	ld	s4,176(sp)
    8000182c:	bd29                	j	80001646 <handle_pgfault+0x38e>
    8000182e:	f556                	sd	s5,168(sp)
    80001830:	f15a                	sd	s6,160(sp)
    80001832:	ed5e                	sd	s7,152(sp)
    80001834:	e962                	sd	s8,144(sp)
        panic("Resident set full\n");
    80001836:	00007517          	auipc	a0,0x7
    8000183a:	b3250513          	addi	a0,a0,-1230 # 80008368 <etext+0x368>
    8000183e:	fe7fe0ef          	jal	80000824 <panic>
        return -1;
    80001842:	557d                	li	a0,-1
    80001844:	b509                	j	80001646 <handle_pgfault+0x38e>

0000000080001846 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001846:	1101                	addi	sp,sp,-32
    80001848:	ec06                	sd	ra,24(sp)
    8000184a:	e822                	sd	s0,16(sp)
    8000184c:	e426                	sd	s1,8(sp)
    8000184e:	1000                	addi	s0,sp,32
    if(newsz >= oldsz)
        return oldsz;
    80001850:	84ae                	mv	s1,a1
    if(newsz >= oldsz)
    80001852:	00b67d63          	bgeu	a2,a1,8000186c <uvmdealloc+0x26>
    80001856:	84b2                	mv	s1,a2

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001858:	6785                	lui	a5,0x1
    8000185a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000185c:	00f60733          	add	a4,a2,a5
    80001860:	76fd                	lui	a3,0xfffff
    80001862:	8f75                	and	a4,a4,a3
    80001864:	97ae                	add	a5,a5,a1
    80001866:	8ff5                	and	a5,a5,a3
    80001868:	00f76863          	bltu	a4,a5,80001878 <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    8000186c:	8526                	mv	a0,s1
    8000186e:	60e2                	ld	ra,24(sp)
    80001870:	6442                	ld	s0,16(sp)
    80001872:	64a2                	ld	s1,8(sp)
    80001874:	6105                	addi	sp,sp,32
    80001876:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001878:	8f99                	sub	a5,a5,a4
    8000187a:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000187c:	4685                	li	a3,1
    8000187e:	0007861b          	sext.w	a2,a5
    80001882:	85ba                	mv	a1,a4
    80001884:	9abff0ef          	jal	8000122e <uvmunmap>
    80001888:	b7d5                	j	8000186c <uvmdealloc+0x26>

000000008000188a <uvmalloc>:
    if(newsz < oldsz)
    8000188a:	0ab66163          	bltu	a2,a1,8000192c <uvmalloc+0xa2>
{
    8000188e:	715d                	addi	sp,sp,-80
    80001890:	e486                	sd	ra,72(sp)
    80001892:	e0a2                	sd	s0,64(sp)
    80001894:	f84a                	sd	s2,48(sp)
    80001896:	f052                	sd	s4,32(sp)
    80001898:	ec56                	sd	s5,24(sp)
    8000189a:	e45e                	sd	s7,8(sp)
    8000189c:	0880                	addi	s0,sp,80
    8000189e:	8aaa                	mv	s5,a0
    800018a0:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800018a2:	6785                	lui	a5,0x1
    800018a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018a6:	95be                	add	a1,a1,a5
    800018a8:	77fd                	lui	a5,0xfffff
    800018aa:	00f5f933          	and	s2,a1,a5
    800018ae:	8bca                	mv	s7,s2
    for(a = oldsz; a < newsz; a += PGSIZE){
    800018b0:	08c97063          	bgeu	s2,a2,80001930 <uvmalloc+0xa6>
    800018b4:	fc26                	sd	s1,56(sp)
    800018b6:	f44e                	sd	s3,40(sp)
    800018b8:	e85a                	sd	s6,16(sp)
        memset(mem, 0, PGSIZE);
    800018ba:	6985                	lui	s3,0x1
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018bc:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800018c0:	a84ff0ef          	jal	80000b44 <kalloc>
    800018c4:	84aa                	mv	s1,a0
        if(mem == 0){
    800018c6:	c50d                	beqz	a0,800018f0 <uvmalloc+0x66>
        memset(mem, 0, PGSIZE);
    800018c8:	864e                	mv	a2,s3
    800018ca:	4581                	li	a1,0
    800018cc:	c2cff0ef          	jal	80000cf8 <memset>
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018d0:	875a                	mv	a4,s6
    800018d2:	86a6                	mv	a3,s1
    800018d4:	864e                	mv	a2,s3
    800018d6:	85ca                	mv	a1,s2
    800018d8:	8556                	mv	a0,s5
    800018da:	f86ff0ef          	jal	80001060 <mappages>
    800018de:	e915                	bnez	a0,80001912 <uvmalloc+0x88>
    for(a = oldsz; a < newsz; a += PGSIZE){
    800018e0:	994e                	add	s2,s2,s3
    800018e2:	fd496fe3          	bltu	s2,s4,800018c0 <uvmalloc+0x36>
    return newsz;
    800018e6:	8552                	mv	a0,s4
    800018e8:	74e2                	ld	s1,56(sp)
    800018ea:	79a2                	ld	s3,40(sp)
    800018ec:	6b42                	ld	s6,16(sp)
    800018ee:	a811                	j	80001902 <uvmalloc+0x78>
            uvmdealloc(pagetable, a, oldsz);
    800018f0:	865e                	mv	a2,s7
    800018f2:	85ca                	mv	a1,s2
    800018f4:	8556                	mv	a0,s5
    800018f6:	f51ff0ef          	jal	80001846 <uvmdealloc>
            return 0;
    800018fa:	4501                	li	a0,0
    800018fc:	74e2                	ld	s1,56(sp)
    800018fe:	79a2                	ld	s3,40(sp)
    80001900:	6b42                	ld	s6,16(sp)
}
    80001902:	60a6                	ld	ra,72(sp)
    80001904:	6406                	ld	s0,64(sp)
    80001906:	7942                	ld	s2,48(sp)
    80001908:	7a02                	ld	s4,32(sp)
    8000190a:	6ae2                	ld	s5,24(sp)
    8000190c:	6ba2                	ld	s7,8(sp)
    8000190e:	6161                	addi	sp,sp,80
    80001910:	8082                	ret
            kfree(mem);
    80001912:	8526                	mv	a0,s1
    80001914:	948ff0ef          	jal	80000a5c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    80001918:	865e                	mv	a2,s7
    8000191a:	85ca                	mv	a1,s2
    8000191c:	8556                	mv	a0,s5
    8000191e:	f29ff0ef          	jal	80001846 <uvmdealloc>
            return 0;
    80001922:	4501                	li	a0,0
    80001924:	74e2                	ld	s1,56(sp)
    80001926:	79a2                	ld	s3,40(sp)
    80001928:	6b42                	ld	s6,16(sp)
    8000192a:	bfe1                	j	80001902 <uvmalloc+0x78>
        return oldsz;
    8000192c:	852e                	mv	a0,a1
}
    8000192e:	8082                	ret
    return newsz;
    80001930:	8532                	mv	a0,a2
    80001932:	bfc1                	j	80001902 <uvmalloc+0x78>

0000000080001934 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
    void
freewalk(pagetable_t pagetable)
{
    80001934:	7179                	addi	sp,sp,-48
    80001936:	f406                	sd	ra,40(sp)
    80001938:	f022                	sd	s0,32(sp)
    8000193a:	ec26                	sd	s1,24(sp)
    8000193c:	e84a                	sd	s2,16(sp)
    8000193e:	e44e                	sd	s3,8(sp)
    80001940:	e052                	sd	s4,0(sp)
    80001942:	1800                	addi	s0,sp,48
    80001944:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for(int i = 0; i < 512; i++){
    80001946:	84aa                	mv	s1,a0
    80001948:	6905                	lui	s2,0x1
    8000194a:	992a                	add	s2,s2,a0
        pte_t pte = pagetable[i];
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000194c:	4985                	li	s3,1
    8000194e:	a021                	j	80001956 <freewalk+0x22>
    for(int i = 0; i < 512; i++){
    80001950:	04a1                	addi	s1,s1,8
    80001952:	01248f63          	beq	s1,s2,80001970 <freewalk+0x3c>
        pte_t pte = pagetable[i];
    80001956:	609c                	ld	a5,0(s1)
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001958:	00f7f713          	andi	a4,a5,15
    8000195c:	ff371ae3          	bne	a4,s3,80001950 <freewalk+0x1c>
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    80001960:	83a9                	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    80001962:	00c79513          	slli	a0,a5,0xc
    80001966:	fcfff0ef          	jal	80001934 <freewalk>
            pagetable[i] = 0;
    8000196a:	0004b023          	sd	zero,0(s1)
    8000196e:	b7cd                	j	80001950 <freewalk+0x1c>
        } else if(pte & PTE_V){
        }
    }
    kfree((void*)pagetable);
    80001970:	8552                	mv	a0,s4
    80001972:	8eaff0ef          	jal	80000a5c <kfree>
}
    80001976:	70a2                	ld	ra,40(sp)
    80001978:	7402                	ld	s0,32(sp)
    8000197a:	64e2                	ld	s1,24(sp)
    8000197c:	6942                	ld	s2,16(sp)
    8000197e:	69a2                	ld	s3,8(sp)
    80001980:	6a02                	ld	s4,0(sp)
    80001982:	6145                	addi	sp,sp,48
    80001984:	8082                	ret

0000000080001986 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
    void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001986:	1101                	addi	sp,sp,-32
    80001988:	ec06                	sd	ra,24(sp)
    8000198a:	e822                	sd	s0,16(sp)
    8000198c:	e426                	sd	s1,8(sp)
    8000198e:	1000                	addi	s0,sp,32
    80001990:	84aa                	mv	s1,a0
    if(sz > 0)
    80001992:	e989                	bnez	a1,800019a4 <uvmfree+0x1e>
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    freewalk(pagetable);
    80001994:	8526                	mv	a0,s1
    80001996:	f9fff0ef          	jal	80001934 <freewalk>
}
    8000199a:	60e2                	ld	ra,24(sp)
    8000199c:	6442                	ld	s0,16(sp)
    8000199e:	64a2                	ld	s1,8(sp)
    800019a0:	6105                	addi	sp,sp,32
    800019a2:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800019a4:	6785                	lui	a5,0x1
    800019a6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800019a8:	95be                	add	a1,a1,a5
    800019aa:	4685                	li	a3,1
    800019ac:	00c5d613          	srli	a2,a1,0xc
    800019b0:	4581                	li	a1,0
    800019b2:	87dff0ef          	jal	8000122e <uvmunmap>
    800019b6:	bff9                	j	80001994 <uvmfree+0xe>

00000000800019b8 <uvmcopy>:
{
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;
    for(i = 0; i < sz; i += PGSIZE){
    800019b8:	ca45                	beqz	a2,80001a68 <uvmcopy+0xb0>
{
    800019ba:	715d                	addi	sp,sp,-80
    800019bc:	e486                	sd	ra,72(sp)
    800019be:	e0a2                	sd	s0,64(sp)
    800019c0:	fc26                	sd	s1,56(sp)
    800019c2:	f84a                	sd	s2,48(sp)
    800019c4:	f44e                	sd	s3,40(sp)
    800019c6:	f052                	sd	s4,32(sp)
    800019c8:	ec56                	sd	s5,24(sp)
    800019ca:	e85a                	sd	s6,16(sp)
    800019cc:	e45e                	sd	s7,8(sp)
    800019ce:	e062                	sd	s8,0(sp)
    800019d0:	0880                	addi	s0,sp,80
    800019d2:	8b2a                	mv	s6,a0
    800019d4:	8bae                	mv	s7,a1
    800019d6:	8ab2                	mv	s5,a2
    for(i = 0; i < sz; i += PGSIZE){
    800019d8:	4901                	li	s2,0
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto err;
        memmove(mem, (char*)pa, PGSIZE);
    800019da:	6a05                	lui	s4,0x1
            pte_t *child_pte = walk(new,i,1);
    800019dc:	4c05                	li	s8,1
    800019de:	a03d                	j	80001a0c <uvmcopy+0x54>
        if((mem = kalloc()) == 0)
    800019e0:	964ff0ef          	jal	80000b44 <kalloc>
    800019e4:	84aa                	mv	s1,a0
    800019e6:	c939                	beqz	a0,80001a3c <uvmcopy+0x84>
        pa = PTE2PA(*pte);
    800019e8:	00a9d593          	srli	a1,s3,0xa
        memmove(mem, (char*)pa, PGSIZE);
    800019ec:	8652                	mv	a2,s4
    800019ee:	05b2                	slli	a1,a1,0xc
    800019f0:	b68ff0ef          	jal	80000d58 <memmove>
        if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800019f4:	3ff9f713          	andi	a4,s3,1023
    800019f8:	86a6                	mv	a3,s1
    800019fa:	8652                	mv	a2,s4
    800019fc:	85ca                	mv	a1,s2
    800019fe:	855e                	mv	a0,s7
    80001a00:	e60ff0ef          	jal	80001060 <mappages>
    80001a04:	e90d                	bnez	a0,80001a36 <uvmcopy+0x7e>
    for(i = 0; i < sz; i += PGSIZE){
    80001a06:	9952                	add	s2,s2,s4
    80001a08:	05597363          	bgeu	s2,s5,80001a4e <uvmcopy+0x96>
        if((pte = walk(old, i, 0)) == 0)
    80001a0c:	4601                	li	a2,0
    80001a0e:	85ca                	mv	a1,s2
    80001a10:	855a                	mv	a0,s6
    80001a12:	d7aff0ef          	jal	80000f8c <walk>
    80001a16:	84aa                	mv	s1,a0
    80001a18:	d57d                	beqz	a0,80001a06 <uvmcopy+0x4e>
        if((*pte & PTE_V) == 0){
    80001a1a:	00053983          	ld	s3,0(a0)
    80001a1e:	0019f793          	andi	a5,s3,1
    80001a22:	ffdd                	bnez	a5,800019e0 <uvmcopy+0x28>
            pte_t *child_pte = walk(new,i,1);
    80001a24:	8662                	mv	a2,s8
    80001a26:	85ca                	mv	a1,s2
    80001a28:	855e                	mv	a0,s7
    80001a2a:	d62ff0ef          	jal	80000f8c <walk>
            if(child_pte == 0)
    80001a2e:	c519                	beqz	a0,80001a3c <uvmcopy+0x84>
            *child_pte = *pte;
    80001a30:	609c                	ld	a5,0(s1)
    80001a32:	e11c                	sd	a5,0(a0)
            continue;
    80001a34:	bfc9                	j	80001a06 <uvmcopy+0x4e>
            kfree(mem);
    80001a36:	8526                	mv	a0,s1
    80001a38:	824ff0ef          	jal	80000a5c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80001a3c:	4685                	li	a3,1
    80001a3e:	00c95613          	srli	a2,s2,0xc
    80001a42:	4581                	li	a1,0
    80001a44:	855e                	mv	a0,s7
    80001a46:	fe8ff0ef          	jal	8000122e <uvmunmap>
    return -1;
    80001a4a:	557d                	li	a0,-1
    80001a4c:	a011                	j	80001a50 <uvmcopy+0x98>
    return 0;
    80001a4e:	4501                	li	a0,0
}
    80001a50:	60a6                	ld	ra,72(sp)
    80001a52:	6406                	ld	s0,64(sp)
    80001a54:	74e2                	ld	s1,56(sp)
    80001a56:	7942                	ld	s2,48(sp)
    80001a58:	79a2                	ld	s3,40(sp)
    80001a5a:	7a02                	ld	s4,32(sp)
    80001a5c:	6ae2                	ld	s5,24(sp)
    80001a5e:	6b42                	ld	s6,16(sp)
    80001a60:	6ba2                	ld	s7,8(sp)
    80001a62:	6c02                	ld	s8,0(sp)
    80001a64:	6161                	addi	sp,sp,80
    80001a66:	8082                	ret
    return 0;
    80001a68:	4501                	li	a0,0
}
    80001a6a:	8082                	ret

0000000080001a6c <uvmclear>:
*/
// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
    void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001a6c:	1141                	addi	sp,sp,-16
    80001a6e:	e406                	sd	ra,8(sp)
    80001a70:	e022                	sd	s0,0(sp)
    80001a72:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80001a74:	4601                	li	a2,0
    80001a76:	d16ff0ef          	jal	80000f8c <walk>
    if(pte == 0)
    80001a7a:	c901                	beqz	a0,80001a8a <uvmclear+0x1e>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80001a7c:	611c                	ld	a5,0(a0)
    80001a7e:	9bbd                	andi	a5,a5,-17
    80001a80:	e11c                	sd	a5,0(a0)
}
    80001a82:	60a2                	ld	ra,8(sp)
    80001a84:	6402                	ld	s0,0(sp)
    80001a86:	0141                	addi	sp,sp,16
    80001a88:	8082                	ret
        panic("uvmclear");
    80001a8a:	00007517          	auipc	a0,0x7
    80001a8e:	91e50513          	addi	a0,a0,-1762 # 800083a8 <etext+0x3a8>
    80001a92:	d93fe0ef          	jal	80000824 <panic>

0000000080001a96 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
    int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80001a96:	7119                	addi	sp,sp,-128
    80001a98:	fc86                	sd	ra,120(sp)
    80001a9a:	f8a2                	sd	s0,112(sp)
    80001a9c:	e8d2                	sd	s4,80(sp)
    80001a9e:	e4d6                	sd	s5,72(sp)
    80001aa0:	e0da                	sd	s6,64(sp)
    80001aa2:	fc5e                	sd	s7,56(sp)
    80001aa4:	f06a                	sd	s10,32(sp)
    80001aa6:	0100                	addi	s0,sp,128
    80001aa8:	8b2a                	mv	s6,a0
    80001aaa:	8a2e                	mv	s4,a1
    80001aac:	8bb2                	mv	s7,a2
    80001aae:	8ab6                	mv	s5,a3
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ab0:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001ab4:	47b1                	li	a5,12
    80001ab6:	00007697          	auipc	a3,0x7
    80001aba:	85a68693          	addi	a3,a3,-1958 # 80008310 <etext+0x310>
    80001abe:	f8d43023          	sd	a3,-128(s0)
    80001ac2:	00f70d63          	beq	a4,a5,80001adc <copyout+0x46>
    80001ac6:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80001aca:	47b5                	li	a5,13
    else { access_type = "write"; }
    80001acc:	00007697          	auipc	a3,0x7
    80001ad0:	8ec68693          	addi	a3,a3,-1812 # 800083b8 <etext+0x3b8>
    80001ad4:	f8d43023          	sd	a3,-128(s0)
    else if (r_scause() == 13) { access_type = "read"; }
    80001ad8:	02f70763          	beq	a4,a5,80001b06 <copyout+0x70>

    uint64 n, va0, pa0;
    pte_t *pte;
    struct proc * p = myproc();
    80001adc:	5d8000ef          	jal	800020b4 <myproc>
    80001ae0:	8d2a                	mv	s10,a0
    while(len > 0){
    80001ae2:	100a8663          	beqz	s5,80001bee <copyout+0x158>
    80001ae6:	f4a6                	sd	s1,104(sp)
    80001ae8:	f0ca                	sd	s2,96(sp)
    80001aea:	ecce                	sd	s3,88(sp)
    80001aec:	f862                	sd	s8,48(sp)
    80001aee:	f466                	sd	s9,40(sp)
    80001af0:	ec6e                	sd	s11,24(sp)
        va0 = PGROUNDDOWN(dstva);
    80001af2:	7dfd                	lui	s11,0xfffff
        if(va0 >= MAXVA)
    80001af4:	57fd                	li	a5,-1
    80001af6:	83e9                	srli	a5,a5,0x1a
    80001af8:	f8f43423          	sd	a5,-120(s0)
            return -1;

        pa0 = walkaddr(pagetable, va0);
        if(pa0 == 0) {
            int in_text = (va0 >= p->text_start && va0 < p->text_end);
    80001afc:	00089c37          	lui	s8,0x89
    80001b00:	9c2a                	add	s8,s8,a0
        pte = walk(pagetable, va0, 0);
        // forbid copyout over read-only user text pages.
        if((*pte & PTE_W) == 0)
            return -1;

        n = PGSIZE - (dstva - va0);
    80001b02:	6c85                	lui	s9,0x1
    80001b04:	a895                	j	80001b78 <copyout+0xe2>
    else if (r_scause() == 13) { access_type = "read"; }
    80001b06:	00007797          	auipc	a5,0x7
    80001b0a:	c8a78793          	addi	a5,a5,-886 # 80008790 <etext+0x790>
    80001b0e:	f8f43023          	sd	a5,-128(s0)
    80001b12:	b7e9                	j	80001adc <copyout+0x46>
            if (!in_text && !in_data && !in_heap && !in_stack)
    80001b14:	8f4d                	or	a4,a4,a1
    80001b16:	8fd9                	or	a5,a5,a4
    80001b18:	8edd                	or	a3,a3,a5
    80001b1a:	0e068c63          	beqz	a3,80001c12 <copyout+0x17c>
            if(handle_pgfault(pagetable, va0,access_type) != 0) {
    80001b1e:	f8043603          	ld	a2,-128(s0)
    80001b22:	85a6                	mv	a1,s1
    80001b24:	855a                	mv	a0,s6
    80001b26:	f92ff0ef          	jal	800012b8 <handle_pgfault>
    80001b2a:	0e051c63          	bnez	a0,80001c22 <copyout+0x18c>
            pa0 = walkaddr(pagetable, va0); // Retry getting the address
    80001b2e:	85a6                	mv	a1,s1
    80001b30:	855a                	mv	a0,s6
    80001b32:	cf4ff0ef          	jal	80001026 <walkaddr>
    80001b36:	892a                	mv	s2,a0
            if(pa0 == 0) 
    80001b38:	0e050d63          	beqz	a0,80001c32 <copyout+0x19c>
        pte = walk(pagetable, va0, 0);
    80001b3c:	4601                	li	a2,0
    80001b3e:	85a6                	mv	a1,s1
    80001b40:	855a                	mv	a0,s6
    80001b42:	c4aff0ef          	jal	80000f8c <walk>
        if((*pte & PTE_W) == 0)
    80001b46:	611c                	ld	a5,0(a0)
    80001b48:	8b91                	andi	a5,a5,4
    80001b4a:	0e078c63          	beqz	a5,80001c42 <copyout+0x1ac>
        n = PGSIZE - (dstva - va0);
    80001b4e:	414489b3          	sub	s3,s1,s4
    80001b52:	99e6                	add	s3,s3,s9
        if(n > len)
    80001b54:	013af363          	bgeu	s5,s3,80001b5a <copyout+0xc4>
    80001b58:	89d6                	mv	s3,s5
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001b5a:	409a0533          	sub	a0,s4,s1
    80001b5e:	0009861b          	sext.w	a2,s3
    80001b62:	85de                	mv	a1,s7
    80001b64:	954a                	add	a0,a0,s2
    80001b66:	9f2ff0ef          	jal	80000d58 <memmove>

        len -= n;
    80001b6a:	413a8ab3          	sub	s5,s5,s3
        src += n;
    80001b6e:	9bce                	add	s7,s7,s3
        dstva = va0 + PGSIZE;
    80001b70:	01948a33          	add	s4,s1,s9
    while(len > 0){
    80001b74:	060a8563          	beqz	s5,80001bde <copyout+0x148>
        va0 = PGROUNDDOWN(dstva);
    80001b78:	01ba74b3          	and	s1,s4,s11
        if(va0 >= MAXVA)
    80001b7c:	f8843783          	ld	a5,-120(s0)
    80001b80:	0697e963          	bltu	a5,s1,80001bf2 <copyout+0x15c>
        pa0 = walkaddr(pagetable, va0);
    80001b84:	85a6                	mv	a1,s1
    80001b86:	855a                	mv	a0,s6
    80001b88:	c9eff0ef          	jal	80001026 <walkaddr>
    80001b8c:	892a                	mv	s2,a0
        if(pa0 == 0) {
    80001b8e:	f55d                	bnez	a0,80001b3c <copyout+0xa6>
            int in_text = (va0 >= p->text_start && va0 < p->text_end);
    80001b90:	1d0c2783          	lw	a5,464(s8) # 891d0 <_entry-0x7ff76e30>
    80001b94:	4701                	li	a4,0
    80001b96:	00f4e663          	bltu	s1,a5,80001ba2 <copyout+0x10c>
    80001b9a:	1d4c2703          	lw	a4,468(s8)
    80001b9e:	00e4b733          	sltu	a4,s1,a4
            int in_data = (va0 >= p->data_start && va0 < p->data_end);
    80001ba2:	1d8c2783          	lw	a5,472(s8)
    80001ba6:	4581                	li	a1,0
    80001ba8:	00f4e663          	bltu	s1,a5,80001bb4 <copyout+0x11e>
    80001bac:	1dcc2583          	lw	a1,476(s8)
    80001bb0:	00b4b5b3          	sltu	a1,s1,a1
            int in_heap = (va0 >= p->heap_start && va0 < p->sz);
    80001bb4:	168d3683          	ld	a3,360(s10)
    80001bb8:	4781                	li	a5,0
    80001bba:	00d4e663          	bltu	s1,a3,80001bc6 <copyout+0x130>
    80001bbe:	048d3783          	ld	a5,72(s10)
    80001bc2:	00f4b7b3          	sltu	a5,s1,a5
            int in_stack = (va0 < p->stack_top && va0 >= p->stack_top - USERSTACK * PGSIZE);
    80001bc6:	1e4c2603          	lw	a2,484(s8)
    80001bca:	4681                	li	a3,0
    80001bcc:	f4c4f4e3          	bgeu	s1,a2,80001b14 <copyout+0x7e>
    80001bd0:	76fd                	lui	a3,0xfffff
    80001bd2:	9e35                	addw	a2,a2,a3
    80001bd4:	00c4b633          	sltu	a2,s1,a2
    80001bd8:	00163693          	seqz	a3,a2
    80001bdc:	bf25                	j	80001b14 <copyout+0x7e>
    }
    return 0;
    80001bde:	4501                	li	a0,0
    80001be0:	74a6                	ld	s1,104(sp)
    80001be2:	7906                	ld	s2,96(sp)
    80001be4:	69e6                	ld	s3,88(sp)
    80001be6:	7c42                	ld	s8,48(sp)
    80001be8:	7ca2                	ld	s9,40(sp)
    80001bea:	6de2                	ld	s11,24(sp)
    80001bec:	a811                	j	80001c00 <copyout+0x16a>
    80001bee:	4501                	li	a0,0
    80001bf0:	a801                	j	80001c00 <copyout+0x16a>
            return -1;
    80001bf2:	557d                	li	a0,-1
    80001bf4:	74a6                	ld	s1,104(sp)
    80001bf6:	7906                	ld	s2,96(sp)
    80001bf8:	69e6                	ld	s3,88(sp)
    80001bfa:	7c42                	ld	s8,48(sp)
    80001bfc:	7ca2                	ld	s9,40(sp)
    80001bfe:	6de2                	ld	s11,24(sp)
}
    80001c00:	70e6                	ld	ra,120(sp)
    80001c02:	7446                	ld	s0,112(sp)
    80001c04:	6a46                	ld	s4,80(sp)
    80001c06:	6aa6                	ld	s5,72(sp)
    80001c08:	6b06                	ld	s6,64(sp)
    80001c0a:	7be2                	ld	s7,56(sp)
    80001c0c:	7d02                	ld	s10,32(sp)
    80001c0e:	6109                	addi	sp,sp,128
    80001c10:	8082                	ret
                return -1;
    80001c12:	557d                	li	a0,-1
    80001c14:	74a6                	ld	s1,104(sp)
    80001c16:	7906                	ld	s2,96(sp)
    80001c18:	69e6                	ld	s3,88(sp)
    80001c1a:	7c42                	ld	s8,48(sp)
    80001c1c:	7ca2                	ld	s9,40(sp)
    80001c1e:	6de2                	ld	s11,24(sp)
    80001c20:	b7c5                	j	80001c00 <copyout+0x16a>
                return -1;
    80001c22:	557d                	li	a0,-1
    80001c24:	74a6                	ld	s1,104(sp)
    80001c26:	7906                	ld	s2,96(sp)
    80001c28:	69e6                	ld	s3,88(sp)
    80001c2a:	7c42                	ld	s8,48(sp)
    80001c2c:	7ca2                	ld	s9,40(sp)
    80001c2e:	6de2                	ld	s11,24(sp)
    80001c30:	bfc1                	j	80001c00 <copyout+0x16a>
                return -1;
    80001c32:	557d                	li	a0,-1
    80001c34:	74a6                	ld	s1,104(sp)
    80001c36:	7906                	ld	s2,96(sp)
    80001c38:	69e6                	ld	s3,88(sp)
    80001c3a:	7c42                	ld	s8,48(sp)
    80001c3c:	7ca2                	ld	s9,40(sp)
    80001c3e:	6de2                	ld	s11,24(sp)
    80001c40:	b7c1                	j	80001c00 <copyout+0x16a>
            return -1;
    80001c42:	557d                	li	a0,-1
    80001c44:	74a6                	ld	s1,104(sp)
    80001c46:	7906                	ld	s2,96(sp)
    80001c48:	69e6                	ld	s3,88(sp)
    80001c4a:	7c42                	ld	s8,48(sp)
    80001c4c:	7ca2                	ld	s9,40(sp)
    80001c4e:	6de2                	ld	s11,24(sp)
    80001c50:	bf45                	j	80001c00 <copyout+0x16a>

0000000080001c52 <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
    int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80001c52:	7159                	addi	sp,sp,-112
    80001c54:	f486                	sd	ra,104(sp)
    80001c56:	f0a2                	sd	s0,96(sp)
    80001c58:	e4ce                	sd	s3,72(sp)
    80001c5a:	e0d2                	sd	s4,64(sp)
    80001c5c:	fc56                	sd	s5,56(sp)
    80001c5e:	f45e                	sd	s7,40(sp)
    80001c60:	ec66                	sd	s9,24(sp)
    80001c62:	e46e                	sd	s11,8(sp)
    80001c64:	1880                	addi	s0,sp,112
    80001c66:	8baa                	mv	s7,a0
    80001c68:	8aae                	mv	s5,a1
    80001c6a:	89b2                	mv	s3,a2
    80001c6c:	8a36                	mv	s4,a3
    80001c6e:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001c72:	47b1                	li	a5,12
    80001c74:	00006d97          	auipc	s11,0x6
    80001c78:	69cd8d93          	addi	s11,s11,1692 # 80008310 <etext+0x310>
    80001c7c:	00f70b63          	beq	a4,a5,80001c92 <copyin+0x40>
    80001c80:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80001c84:	47b5                	li	a5,13
    else { access_type = "write"; }
    80001c86:	00006d97          	auipc	s11,0x6
    80001c8a:	732d8d93          	addi	s11,s11,1842 # 800083b8 <etext+0x3b8>
    else if (r_scause() == 13) { access_type = "read"; }
    80001c8e:	02f70263          	beq	a4,a5,80001cb2 <copyin+0x60>

    struct proc *p = myproc();
    80001c92:	422000ef          	jal	800020b4 <myproc>
    80001c96:	8caa                	mv	s9,a0
    uint64 n, va0, pa0;

    while(len > 0){
    80001c98:	0e0a0963          	beqz	s4,80001d8a <copyin+0x138>
    80001c9c:	eca6                	sd	s1,88(sp)
    80001c9e:	e8ca                	sd	s2,80(sp)
    80001ca0:	f85a                	sd	s6,48(sp)
    80001ca2:	f062                	sd	s8,32(sp)
    80001ca4:	e86a                	sd	s10,16(sp)
        va0 = PGROUNDDOWN(srcva);
    80001ca6:	7d7d                	lui	s10,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if(pa0 == 0) {
            int in_text = (va0 >= p->text_start && va0 < p->text_end);
    80001ca8:	00089b37          	lui	s6,0x89
    80001cac:	9b2a                	add	s6,s6,a0
            pa0 = walkaddr(pagetable, va0); 
            if(pa0 == 0)
                return -1;
        }

        n = PGSIZE - (srcva - va0);
    80001cae:	6c05                	lui	s8,0x1
    80001cb0:	a861                	j	80001d48 <copyin+0xf6>
    else if (r_scause() == 13) { access_type = "read"; }
    80001cb2:	00007d97          	auipc	s11,0x7
    80001cb6:	aded8d93          	addi	s11,s11,-1314 # 80008790 <etext+0x790>
    80001cba:	bfe1                	j	80001c92 <copyin+0x40>
            int in_data = (va0 >= p->data_start && va0 < p->data_end);
    80001cbc:	1d8b2783          	lw	a5,472(s6) # 891d8 <_entry-0x7ff76e28>
    80001cc0:	4581                	li	a1,0
    80001cc2:	00f4e663          	bltu	s1,a5,80001cce <copyin+0x7c>
    80001cc6:	1dcb2583          	lw	a1,476(s6)
    80001cca:	00b4b5b3          	sltu	a1,s1,a1
            int in_heap = (va0 >= p->heap_start && va0 < p->sz);
    80001cce:	168cb683          	ld	a3,360(s9) # 1168 <_entry-0x7fffee98>
    80001cd2:	4781                	li	a5,0
    80001cd4:	00d4e663          	bltu	s1,a3,80001ce0 <copyin+0x8e>
    80001cd8:	048cb783          	ld	a5,72(s9)
    80001cdc:	00f4b7b3          	sltu	a5,s1,a5
            int in_stack = (va0 < p->stack_top && va0 >= p->stack_top - USERSTACK * PGSIZE);
    80001ce0:	1e4b2603          	lw	a2,484(s6)
    80001ce4:	4681                	li	a3,0
    80001ce6:	00c4f863          	bgeu	s1,a2,80001cf6 <copyin+0xa4>
    80001cea:	76fd                	lui	a3,0xfffff
    80001cec:	9e35                	addw	a2,a2,a3
    80001cee:	00c4b633          	sltu	a2,s1,a2
    80001cf2:	00163693          	seqz	a3,a2
            if (!in_text && !in_data && !in_heap && !in_stack && p->pid != 2)
    80001cf6:	8f4d                	or	a4,a4,a1
    80001cf8:	8fd9                	or	a5,a5,a4
    80001cfa:	8edd                	or	a3,a3,a5
    80001cfc:	e691                	bnez	a3,80001d08 <copyin+0xb6>
    80001cfe:	030ca783          	lw	a5,48(s9)
    80001d02:	4709                	li	a4,2
    80001d04:	08e79563          	bne	a5,a4,80001d8e <copyin+0x13c>
            if(handle_pgfault(pagetable, va0,access_type) != 0) {
    80001d08:	866e                	mv	a2,s11
    80001d0a:	85a6                	mv	a1,s1
    80001d0c:	855e                	mv	a0,s7
    80001d0e:	daaff0ef          	jal	800012b8 <handle_pgfault>
    80001d12:	e549                	bnez	a0,80001d9c <copyin+0x14a>
            pa0 = walkaddr(pagetable, va0); 
    80001d14:	85a6                	mv	a1,s1
    80001d16:	855e                	mv	a0,s7
    80001d18:	b0eff0ef          	jal	80001026 <walkaddr>
            if(pa0 == 0)
    80001d1c:	c559                	beqz	a0,80001daa <copyin+0x158>
        n = PGSIZE - (srcva - va0);
    80001d1e:	41348933          	sub	s2,s1,s3
    80001d22:	9962                	add	s2,s2,s8
        if(n > len)
    80001d24:	012a7363          	bgeu	s4,s2,80001d2a <copyin+0xd8>
    80001d28:	8952                	mv	s2,s4
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001d2a:	409985b3          	sub	a1,s3,s1
    80001d2e:	0009061b          	sext.w	a2,s2
    80001d32:	95aa                	add	a1,a1,a0
    80001d34:	8556                	mv	a0,s5
    80001d36:	822ff0ef          	jal	80000d58 <memmove>
        len -= n;
    80001d3a:	412a0a33          	sub	s4,s4,s2
        dst += n;
    80001d3e:	9aca                	add	s5,s5,s2
        srcva = va0 + PGSIZE;
    80001d40:	018489b3          	add	s3,s1,s8
    while(len > 0){
    80001d44:	020a0363          	beqz	s4,80001d6a <copyin+0x118>
        va0 = PGROUNDDOWN(srcva);
    80001d48:	01a9f4b3          	and	s1,s3,s10
        pa0 = walkaddr(pagetable, va0);
    80001d4c:	85a6                	mv	a1,s1
    80001d4e:	855e                	mv	a0,s7
    80001d50:	ad6ff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0) {
    80001d54:	f569                	bnez	a0,80001d1e <copyin+0xcc>
            int in_text = (va0 >= p->text_start && va0 < p->text_end);
    80001d56:	1d0b2783          	lw	a5,464(s6)
    80001d5a:	4701                	li	a4,0
    80001d5c:	f6f4e0e3          	bltu	s1,a5,80001cbc <copyin+0x6a>
    80001d60:	1d4b2703          	lw	a4,468(s6)
    80001d64:	00e4b733          	sltu	a4,s1,a4
    80001d68:	bf91                	j	80001cbc <copyin+0x6a>
    }
    return 0;
    80001d6a:	4501                	li	a0,0
    80001d6c:	64e6                	ld	s1,88(sp)
    80001d6e:	6946                	ld	s2,80(sp)
    80001d70:	7b42                	ld	s6,48(sp)
    80001d72:	7c02                	ld	s8,32(sp)
    80001d74:	6d42                	ld	s10,16(sp)
}
    80001d76:	70a6                	ld	ra,104(sp)
    80001d78:	7406                	ld	s0,96(sp)
    80001d7a:	69a6                	ld	s3,72(sp)
    80001d7c:	6a06                	ld	s4,64(sp)
    80001d7e:	7ae2                	ld	s5,56(sp)
    80001d80:	7ba2                	ld	s7,40(sp)
    80001d82:	6ce2                	ld	s9,24(sp)
    80001d84:	6da2                	ld	s11,8(sp)
    80001d86:	6165                	addi	sp,sp,112
    80001d88:	8082                	ret
    return 0;
    80001d8a:	4501                	li	a0,0
    80001d8c:	b7ed                	j	80001d76 <copyin+0x124>
                return -1;
    80001d8e:	557d                	li	a0,-1
    80001d90:	64e6                	ld	s1,88(sp)
    80001d92:	6946                	ld	s2,80(sp)
    80001d94:	7b42                	ld	s6,48(sp)
    80001d96:	7c02                	ld	s8,32(sp)
    80001d98:	6d42                	ld	s10,16(sp)
    80001d9a:	bff1                	j	80001d76 <copyin+0x124>
                return -1;
    80001d9c:	557d                	li	a0,-1
    80001d9e:	64e6                	ld	s1,88(sp)
    80001da0:	6946                	ld	s2,80(sp)
    80001da2:	7b42                	ld	s6,48(sp)
    80001da4:	7c02                	ld	s8,32(sp)
    80001da6:	6d42                	ld	s10,16(sp)
    80001da8:	b7f9                	j	80001d76 <copyin+0x124>
                return -1;
    80001daa:	557d                	li	a0,-1
    80001dac:	64e6                	ld	s1,88(sp)
    80001dae:	6946                	ld	s2,80(sp)
    80001db0:	7b42                	ld	s6,48(sp)
    80001db2:	7c02                	ld	s8,32(sp)
    80001db4:	6d42                	ld	s10,16(sp)
    80001db6:	b7c1                	j	80001d76 <copyin+0x124>

0000000080001db8 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
    int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80001db8:	715d                	addi	sp,sp,-80
    80001dba:	e486                	sd	ra,72(sp)
    80001dbc:	e0a2                	sd	s0,64(sp)
    80001dbe:	fc26                	sd	s1,56(sp)
    80001dc0:	f44e                	sd	s3,40(sp)
    80001dc2:	f052                	sd	s4,32(sp)
    80001dc4:	ec56                	sd	s5,24(sp)
    80001dc6:	e85a                	sd	s6,16(sp)
    80001dc8:	e45e                	sd	s7,8(sp)
    80001dca:	0880                	addi	s0,sp,80
    80001dcc:	8aaa                	mv	s5,a0
    80001dce:	84ae                	mv	s1,a1
    80001dd0:	8bb2                	mv	s7,a2
    80001dd2:	89b6                	mv	s3,a3
    80001dd4:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001dd8:	47b1                	li	a5,12
    80001dda:	00f70463          	beq	a4,a5,80001de2 <copyinstr+0x2a>
    80001dde:	142027f3          	csrr	a5,scause
    else if (r_scause() == 13) { access_type = "read"; }
    else { access_type = "write"; }
    uint64 n, va0, pa0;
    int got_null = 0;
    while(got_null == 0 && max > 0){
        va0 = PGROUNDDOWN(srcva);
    80001de2:	7b7d                	lui	s6,0xfffff
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); // Retry
            if(pa0 == 0) return -1;
        }
        n = PGSIZE - (srcva - va0);
    80001de4:	6a05                	lui	s4,0x1
    while(got_null == 0 && max > 0){
    80001de6:	4781                	li	a5,0
    80001de8:	00098863          	beqz	s3,80001df8 <copyinstr+0x40>
    80001dec:	f84a                	sd	s2,48(sp)
    80001dee:	a82d                	j	80001e28 <copyinstr+0x70>
        if(n > max)
            n = max;
        char *p = (char *) (pa0 + (srcva - va0));
        while(n > 0){
            if(*p == '\0'){
                *dst = '\0';
    80001df0:	00078023          	sb	zero,0(a5)
                got_null = 1;
    80001df4:	4785                	li	a5,1
    80001df6:	7942                	ld	s2,48(sp)
            p++;
            dst++;
        }
        srcva = va0 + PGSIZE;
    }
    if(got_null){
    80001df8:	0017c793          	xori	a5,a5,1
    80001dfc:	40f0053b          	negw	a0,a5
        return 0;
    } else {
        return -1;
    }
}
    80001e00:	60a6                	ld	ra,72(sp)
    80001e02:	6406                	ld	s0,64(sp)
    80001e04:	74e2                	ld	s1,56(sp)
    80001e06:	79a2                	ld	s3,40(sp)
    80001e08:	7a02                	ld	s4,32(sp)
    80001e0a:	6ae2                	ld	s5,24(sp)
    80001e0c:	6b42                	ld	s6,16(sp)
    80001e0e:	6ba2                	ld	s7,8(sp)
    80001e10:	6161                	addi	sp,sp,80
    80001e12:	8082                	ret
    80001e14:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001e18:	9726                	add	a4,a4,s1
            --max;
    80001e1a:	40b709b3          	sub	s3,a4,a1
        srcva = va0 + PGSIZE;
    80001e1e:	01490bb3          	add	s7,s2,s4
    while(got_null == 0 && max > 0){
    80001e22:	04e58463          	beq	a1,a4,80001e6a <copyinstr+0xb2>
{
    80001e26:	84be                	mv	s1,a5
        va0 = PGROUNDDOWN(srcva);
    80001e28:	016bf933          	and	s2,s7,s6
        pa0 = walkaddr(pagetable, va0);
    80001e2c:	85ca                	mv	a1,s2
    80001e2e:	8556                	mv	a0,s5
    80001e30:	9f6ff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0){
    80001e34:	cd15                	beqz	a0,80001e70 <copyinstr+0xb8>
        n = PGSIZE - (srcva - va0);
    80001e36:	417906b3          	sub	a3,s2,s7
    80001e3a:	96d2                	add	a3,a3,s4
        if(n > max)
    80001e3c:	00d9f363          	bgeu	s3,a3,80001e42 <copyinstr+0x8a>
    80001e40:	86ce                	mv	a3,s3
        while(n > 0){
    80001e42:	ca95                	beqz	a3,80001e76 <copyinstr+0xbe>
        char *p = (char *) (pa0 + (srcva - va0));
    80001e44:	01750633          	add	a2,a0,s7
    80001e48:	41260633          	sub	a2,a2,s2
    80001e4c:	87a6                	mv	a5,s1
            if(*p == '\0'){
    80001e4e:	8e05                	sub	a2,a2,s1
        while(n > 0){
    80001e50:	96a6                	add	a3,a3,s1
    80001e52:	85be                	mv	a1,a5
            if(*p == '\0'){
    80001e54:	00f60733          	add	a4,a2,a5
    80001e58:	00074703          	lbu	a4,0(a4)
    80001e5c:	db51                	beqz	a4,80001df0 <copyinstr+0x38>
                *dst = *p;
    80001e5e:	00e78023          	sb	a4,0(a5)
            dst++;
    80001e62:	0785                	addi	a5,a5,1
        while(n > 0){
    80001e64:	fed797e3          	bne	a5,a3,80001e52 <copyinstr+0x9a>
    80001e68:	b775                	j	80001e14 <copyinstr+0x5c>
    80001e6a:	4781                	li	a5,0
    80001e6c:	7942                	ld	s2,48(sp)
    80001e6e:	b769                	j	80001df8 <copyinstr+0x40>
            return-1;
    80001e70:	557d                	li	a0,-1
    80001e72:	7942                	ld	s2,48(sp)
    80001e74:	b771                	j	80001e00 <copyinstr+0x48>
        srcva = va0 + PGSIZE;
    80001e76:	6b85                	lui	s7,0x1
    80001e78:	9bca                	add	s7,s7,s2
    80001e7a:	87a6                	mv	a5,s1
    80001e7c:	b76d                	j	80001e26 <copyinstr+0x6e>

0000000080001e7e <ismapped>:
// out of physical memory, and physical address if successful.


    int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001e7e:	1141                	addi	sp,sp,-16
    80001e80:	e406                	sd	ra,8(sp)
    80001e82:	e022                	sd	s0,0(sp)
    80001e84:	0800                	addi	s0,sp,16
    pte_t *pte = walk(pagetable, va, 0);
    80001e86:	4601                	li	a2,0
    80001e88:	904ff0ef          	jal	80000f8c <walk>
    if (pte == 0) {
    80001e8c:	c119                	beqz	a0,80001e92 <ismapped+0x14>
        return 0;
    }
    if (*pte & PTE_V){
    80001e8e:	6108                	ld	a0,0(a0)
    80001e90:	8905                	andi	a0,a0,1
        return 1;
    }
    return 0;
}
    80001e92:	60a2                	ld	ra,8(sp)
    80001e94:	6402                	ld	s0,0(sp)
    80001e96:	0141                	addi	sp,sp,16
    80001e98:	8082                	ret

0000000080001e9a <vmfault>:
{
    80001e9a:	7179                	addi	sp,sp,-48
    80001e9c:	f406                	sd	ra,40(sp)
    80001e9e:	f022                	sd	s0,32(sp)
    80001ea0:	e84a                	sd	s2,16(sp)
    80001ea2:	e44e                	sd	s3,8(sp)
    80001ea4:	1800                	addi	s0,sp,48
    80001ea6:	89aa                	mv	s3,a0
    80001ea8:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001eaa:	20a000ef          	jal	800020b4 <myproc>
    if (va >= p->sz)
    80001eae:	653c                	ld	a5,72(a0)
    80001eb0:	00f96a63          	bltu	s2,a5,80001ec4 <vmfault+0x2a>
        return 0;
    80001eb4:	4981                	li	s3,0
}
    80001eb6:	854e                	mv	a0,s3
    80001eb8:	70a2                	ld	ra,40(sp)
    80001eba:	7402                	ld	s0,32(sp)
    80001ebc:	6942                	ld	s2,16(sp)
    80001ebe:	69a2                	ld	s3,8(sp)
    80001ec0:	6145                	addi	sp,sp,48
    80001ec2:	8082                	ret
    80001ec4:	ec26                	sd	s1,24(sp)
    80001ec6:	e052                	sd	s4,0(sp)
    80001ec8:	84aa                	mv	s1,a0
    va = PGROUNDDOWN(va);
    80001eca:	77fd                	lui	a5,0xfffff
    80001ecc:	00f97a33          	and	s4,s2,a5
    if(ismapped(pagetable, va)) {
    80001ed0:	85d2                	mv	a1,s4
    80001ed2:	854e                	mv	a0,s3
    80001ed4:	fabff0ef          	jal	80001e7e <ismapped>
        return 0;
    80001ed8:	4981                	li	s3,0
    if(ismapped(pagetable, va)) {
    80001eda:	c501                	beqz	a0,80001ee2 <vmfault+0x48>
    80001edc:	64e2                	ld	s1,24(sp)
    80001ede:	6a02                	ld	s4,0(sp)
    80001ee0:	bfd9                	j	80001eb6 <vmfault+0x1c>
    mem = (uint64) kalloc(); // Just allocates memory
    80001ee2:	c63fe0ef          	jal	80000b44 <kalloc>
    80001ee6:	892a                	mv	s2,a0
    if(mem == 0)
    80001ee8:	c905                	beqz	a0,80001f18 <vmfault+0x7e>
    mem = (uint64) kalloc(); // Just allocates memory
    80001eea:	89aa                	mv	s3,a0
    memset((void *) mem, 0, PGSIZE);
    80001eec:	6605                	lui	a2,0x1
    80001eee:	4581                	li	a1,0
    80001ef0:	e09fe0ef          	jal	80000cf8 <memset>
    if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80001ef4:	4759                	li	a4,22
    80001ef6:	86ca                	mv	a3,s2
    80001ef8:	6605                	lui	a2,0x1
    80001efa:	85d2                	mv	a1,s4
    80001efc:	68a8                	ld	a0,80(s1)
    80001efe:	962ff0ef          	jal	80001060 <mappages>
    80001f02:	e501                	bnez	a0,80001f0a <vmfault+0x70>
    80001f04:	64e2                	ld	s1,24(sp)
    80001f06:	6a02                	ld	s4,0(sp)
    80001f08:	b77d                	j	80001eb6 <vmfault+0x1c>
        kfree((void *)mem);
    80001f0a:	854a                	mv	a0,s2
    80001f0c:	b51fe0ef          	jal	80000a5c <kfree>
        return 0;
    80001f10:	4981                	li	s3,0
    80001f12:	64e2                	ld	s1,24(sp)
    80001f14:	6a02                	ld	s4,0(sp)
    80001f16:	b745                	j	80001eb6 <vmfault+0x1c>
    80001f18:	64e2                	ld	s1,24(sp)
    80001f1a:	6a02                	ld	s4,0(sp)
    80001f1c:	bf69                	j	80001eb6 <vmfault+0x1c>

0000000080001f1e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001f1e:	711d                	addi	sp,sp,-96
    80001f20:	ec86                	sd	ra,88(sp)
    80001f22:	e8a2                	sd	s0,80(sp)
    80001f24:	e4a6                	sd	s1,72(sp)
    80001f26:	e0ca                	sd	s2,64(sp)
    80001f28:	fc4e                	sd	s3,56(sp)
    80001f2a:	f852                	sd	s4,48(sp)
    80001f2c:	f456                	sd	s5,40(sp)
    80001f2e:	f05a                	sd	s6,32(sp)
    80001f30:	ec5e                	sd	s7,24(sp)
    80001f32:	e862                	sd	s8,16(sp)
    80001f34:	e466                	sd	s9,8(sp)
    80001f36:	1080                	addi	s0,sp,96
    80001f38:	8aaa                	mv	s5,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f3a:	00012497          	auipc	s1,0x12
    80001f3e:	e3e48493          	addi	s1,s1,-450 # 80013d78 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001f42:	8ca6                	mv	s9,s1
    80001f44:	223c97b7          	lui	a5,0x223c9
    80001f48:	51578793          	addi	a5,a5,1301 # 223c9515 <_entry-0x5dc36aeb>
    80001f4c:	58185937          	lui	s2,0x58185
    80001f50:	ccf90913          	addi	s2,s2,-817 # 58184ccf <_entry-0x27e7b331>
    80001f54:	1902                	slli	s2,s2,0x20
    80001f56:	993e                	add	s2,s2,a5
    80001f58:	040009b7          	lui	s3,0x4000
    80001f5c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001f5e:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f60:	4c19                	li	s8,6
    80001f62:	6b85                	lui	s7,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f64:	00089a37          	lui	s4,0x89
    80001f68:	1e8a0a13          	addi	s4,s4,488 # 891e8 <_entry-0x7ff76e18>
    80001f6c:	0225ab17          	auipc	s6,0x225a
    80001f70:	80cb0b13          	addi	s6,s6,-2036 # 8225b778 <tickslock>
    char *pa = kalloc();
    80001f74:	bd1fe0ef          	jal	80000b44 <kalloc>
    80001f78:	862a                	mv	a2,a0
    if(pa == 0)
    80001f7a:	c121                	beqz	a0,80001fba <proc_mapstacks+0x9c>
    uint64 va = KSTACK((int) (p - proc));
    80001f7c:	419485b3          	sub	a1,s1,s9
    80001f80:	858d                	srai	a1,a1,0x3
    80001f82:	032585b3          	mul	a1,a1,s2
    80001f86:	05b6                	slli	a1,a1,0xd
    80001f88:	6789                	lui	a5,0x2
    80001f8a:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f8c:	8762                	mv	a4,s8
    80001f8e:	86de                	mv	a3,s7
    80001f90:	40b985b3          	sub	a1,s3,a1
    80001f94:	8556                	mv	a0,s5
    80001f96:	980ff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f9a:	94d2                	add	s1,s1,s4
    80001f9c:	fd649ce3          	bne	s1,s6,80001f74 <proc_mapstacks+0x56>
  }
}
    80001fa0:	60e6                	ld	ra,88(sp)
    80001fa2:	6446                	ld	s0,80(sp)
    80001fa4:	64a6                	ld	s1,72(sp)
    80001fa6:	6906                	ld	s2,64(sp)
    80001fa8:	79e2                	ld	s3,56(sp)
    80001faa:	7a42                	ld	s4,48(sp)
    80001fac:	7aa2                	ld	s5,40(sp)
    80001fae:	7b02                	ld	s6,32(sp)
    80001fb0:	6be2                	ld	s7,24(sp)
    80001fb2:	6c42                	ld	s8,16(sp)
    80001fb4:	6ca2                	ld	s9,8(sp)
    80001fb6:	6125                	addi	sp,sp,96
    80001fb8:	8082                	ret
      panic("kalloc");
    80001fba:	00006517          	auipc	a0,0x6
    80001fbe:	40650513          	addi	a0,a0,1030 # 800083c0 <etext+0x3c0>
    80001fc2:	863fe0ef          	jal	80000824 <panic>

0000000080001fc6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001fc6:	715d                	addi	sp,sp,-80
    80001fc8:	e486                	sd	ra,72(sp)
    80001fca:	e0a2                	sd	s0,64(sp)
    80001fcc:	fc26                	sd	s1,56(sp)
    80001fce:	f84a                	sd	s2,48(sp)
    80001fd0:	f44e                	sd	s3,40(sp)
    80001fd2:	f052                	sd	s4,32(sp)
    80001fd4:	ec56                	sd	s5,24(sp)
    80001fd6:	e85a                	sd	s6,16(sp)
    80001fd8:	e45e                	sd	s7,8(sp)
    80001fda:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001fdc:	00006597          	auipc	a1,0x6
    80001fe0:	3ec58593          	addi	a1,a1,1004 # 800083c8 <etext+0x3c8>
    80001fe4:	00012517          	auipc	a0,0x12
    80001fe8:	96450513          	addi	a0,a0,-1692 # 80013948 <pid_lock>
    80001fec:	bb3fe0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001ff0:	00006597          	auipc	a1,0x6
    80001ff4:	3e058593          	addi	a1,a1,992 # 800083d0 <etext+0x3d0>
    80001ff8:	00012517          	auipc	a0,0x12
    80001ffc:	96850513          	addi	a0,a0,-1688 # 80013960 <wait_lock>
    80002000:	b9ffe0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002004:	00012497          	auipc	s1,0x12
    80002008:	d7448493          	addi	s1,s1,-652 # 80013d78 <proc>
      initlock(&p->lock, "proc");
    8000200c:	00006b97          	auipc	s7,0x6
    80002010:	3d4b8b93          	addi	s7,s7,980 # 800083e0 <etext+0x3e0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80002014:	8b26                	mv	s6,s1
    80002016:	223c97b7          	lui	a5,0x223c9
    8000201a:	51578793          	addi	a5,a5,1301 # 223c9515 <_entry-0x5dc36aeb>
    8000201e:	58185937          	lui	s2,0x58185
    80002022:	ccf90913          	addi	s2,s2,-817 # 58184ccf <_entry-0x27e7b331>
    80002026:	1902                	slli	s2,s2,0x20
    80002028:	993e                	add	s2,s2,a5
    8000202a:	040009b7          	lui	s3,0x4000
    8000202e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80002030:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002032:	00089a37          	lui	s4,0x89
    80002036:	1e8a0a13          	addi	s4,s4,488 # 891e8 <_entry-0x7ff76e18>
    8000203a:	02259a97          	auipc	s5,0x2259
    8000203e:	73ea8a93          	addi	s5,s5,1854 # 8225b778 <tickslock>
      initlock(&p->lock, "proc");
    80002042:	85de                	mv	a1,s7
    80002044:	8526                	mv	a0,s1
    80002046:	b59fe0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    8000204a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000204e:	416487b3          	sub	a5,s1,s6
    80002052:	878d                	srai	a5,a5,0x3
    80002054:	032787b3          	mul	a5,a5,s2
    80002058:	07b6                	slli	a5,a5,0xd
    8000205a:	6709                	lui	a4,0x2
    8000205c:	9fb9                	addw	a5,a5,a4
    8000205e:	40f987b3          	sub	a5,s3,a5
    80002062:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80002064:	94d2                	add	s1,s1,s4
    80002066:	fd549ee3          	bne	s1,s5,80002042 <procinit+0x7c>
  }
}
    8000206a:	60a6                	ld	ra,72(sp)
    8000206c:	6406                	ld	s0,64(sp)
    8000206e:	74e2                	ld	s1,56(sp)
    80002070:	7942                	ld	s2,48(sp)
    80002072:	79a2                	ld	s3,40(sp)
    80002074:	7a02                	ld	s4,32(sp)
    80002076:	6ae2                	ld	s5,24(sp)
    80002078:	6b42                	ld	s6,16(sp)
    8000207a:	6ba2                	ld	s7,8(sp)
    8000207c:	6161                	addi	sp,sp,80
    8000207e:	8082                	ret

0000000080002080 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80002080:	1141                	addi	sp,sp,-16
    80002082:	e406                	sd	ra,8(sp)
    80002084:	e022                	sd	s0,0(sp)
    80002086:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80002088:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000208a:	2501                	sext.w	a0,a0
    8000208c:	60a2                	ld	ra,8(sp)
    8000208e:	6402                	ld	s0,0(sp)
    80002090:	0141                	addi	sp,sp,16
    80002092:	8082                	ret

0000000080002094 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80002094:	1141                	addi	sp,sp,-16
    80002096:	e406                	sd	ra,8(sp)
    80002098:	e022                	sd	s0,0(sp)
    8000209a:	0800                	addi	s0,sp,16
    8000209c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000209e:	2781                	sext.w	a5,a5
    800020a0:	079e                	slli	a5,a5,0x7
  return c;
}
    800020a2:	00012517          	auipc	a0,0x12
    800020a6:	8d650513          	addi	a0,a0,-1834 # 80013978 <cpus>
    800020aa:	953e                	add	a0,a0,a5
    800020ac:	60a2                	ld	ra,8(sp)
    800020ae:	6402                	ld	s0,0(sp)
    800020b0:	0141                	addi	sp,sp,16
    800020b2:	8082                	ret

00000000800020b4 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800020b4:	1101                	addi	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	e426                	sd	s1,8(sp)
    800020bc:	1000                	addi	s0,sp,32
  push_off();
    800020be:	b27fe0ef          	jal	80000be4 <push_off>
    800020c2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800020c4:	2781                	sext.w	a5,a5
    800020c6:	079e                	slli	a5,a5,0x7
    800020c8:	00012717          	auipc	a4,0x12
    800020cc:	88070713          	addi	a4,a4,-1920 # 80013948 <pid_lock>
    800020d0:	97ba                	add	a5,a5,a4
    800020d2:	7b9c                	ld	a5,48(a5)
    800020d4:	84be                	mv	s1,a5
  pop_off();
    800020d6:	b97fe0ef          	jal	80000c6c <pop_off>
  return p;
}
    800020da:	8526                	mv	a0,s1
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800020e6:	7179                	addi	sp,sp,-48
    800020e8:	f406                	sd	ra,40(sp)
    800020ea:	f022                	sd	s0,32(sp)
    800020ec:	ec26                	sd	s1,24(sp)
    800020ee:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    800020f0:	fc5ff0ef          	jal	800020b4 <myproc>
    800020f4:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    800020f6:	bc7fe0ef          	jal	80000cbc <release>

  if (first) {
    800020fa:	00009797          	auipc	a5,0x9
    800020fe:	7167a783          	lw	a5,1814(a5) # 8000b810 <first.1>
    80002102:	cf95                	beqz	a5,8000213e <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80002104:	4505                	li	a0,1
    80002106:	739010ef          	jal	8000403e <fsinit>

    first = 0;
    8000210a:	00009797          	auipc	a5,0x9
    8000210e:	7007a323          	sw	zero,1798(a5) # 8000b810 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80002112:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80002116:	00006797          	auipc	a5,0x6
    8000211a:	2d278793          	addi	a5,a5,722 # 800083e8 <etext+0x3e8>
    8000211e:	fcf43823          	sd	a5,-48(s0)
    80002122:	fc043c23          	sd	zero,-40(s0)
    80002126:	fd040593          	addi	a1,s0,-48
    8000212a:	853e                	mv	a0,a5
    8000212c:	222030ef          	jal	8000534e <kexec>
    80002130:	6cbc                	ld	a5,88(s1)
    80002132:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80002134:	6cbc                	ld	a5,88(s1)
    80002136:	7bb8                	ld	a4,112(a5)
    80002138:	57fd                	li	a5,-1
    8000213a:	02f70d63          	beq	a4,a5,80002174 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    8000213e:	43b000ef          	jal	80002d78 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002142:	68a8                	ld	a0,80(s1)
    80002144:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002146:	04000737          	lui	a4,0x4000
    8000214a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000214c:	0732                	slli	a4,a4,0xc
    8000214e:	00005797          	auipc	a5,0x5
    80002152:	f4e78793          	addi	a5,a5,-178 # 8000709c <userret>
    80002156:	00005697          	auipc	a3,0x5
    8000215a:	eaa68693          	addi	a3,a3,-342 # 80007000 <_trampoline>
    8000215e:	8f95                	sub	a5,a5,a3
    80002160:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002162:	577d                	li	a4,-1
    80002164:	177e                	slli	a4,a4,0x3f
    80002166:	8d59                	or	a0,a0,a4
    80002168:	9782                	jalr	a5
}
    8000216a:	70a2                	ld	ra,40(sp)
    8000216c:	7402                	ld	s0,32(sp)
    8000216e:	64e2                	ld	s1,24(sp)
    80002170:	6145                	addi	sp,sp,48
    80002172:	8082                	ret
      panic("exec");
    80002174:	00006517          	auipc	a0,0x6
    80002178:	19c50513          	addi	a0,a0,412 # 80008310 <etext+0x310>
    8000217c:	ea8fe0ef          	jal	80000824 <panic>

0000000080002180 <allocpid>:
{
    80002180:	1101                	addi	sp,sp,-32
    80002182:	ec06                	sd	ra,24(sp)
    80002184:	e822                	sd	s0,16(sp)
    80002186:	e426                	sd	s1,8(sp)
    80002188:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000218a:	00011517          	auipc	a0,0x11
    8000218e:	7be50513          	addi	a0,a0,1982 # 80013948 <pid_lock>
    80002192:	a97fe0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80002196:	00009797          	auipc	a5,0x9
    8000219a:	67e78793          	addi	a5,a5,1662 # 8000b814 <nextpid>
    8000219e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800021a0:	0014871b          	addiw	a4,s1,1
    800021a4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800021a6:	00011517          	auipc	a0,0x11
    800021aa:	7a250513          	addi	a0,a0,1954 # 80013948 <pid_lock>
    800021ae:	b0ffe0ef          	jal	80000cbc <release>
}
    800021b2:	8526                	mv	a0,s1
    800021b4:	60e2                	ld	ra,24(sp)
    800021b6:	6442                	ld	s0,16(sp)
    800021b8:	64a2                	ld	s1,8(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <proc_pagetable>:
{
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	e426                	sd	s1,8(sp)
    800021c6:	e04a                	sd	s2,0(sp)
    800021c8:	1000                	addi	s0,sp,32
    800021ca:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800021cc:	83cff0ef          	jal	80001208 <uvmcreate>
    800021d0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800021d2:	cd05                	beqz	a0,8000220a <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800021d4:	4729                	li	a4,10
    800021d6:	00005697          	auipc	a3,0x5
    800021da:	e2a68693          	addi	a3,a3,-470 # 80007000 <_trampoline>
    800021de:	6605                	lui	a2,0x1
    800021e0:	040005b7          	lui	a1,0x4000
    800021e4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800021e6:	05b2                	slli	a1,a1,0xc
    800021e8:	e79fe0ef          	jal	80001060 <mappages>
    800021ec:	02054663          	bltz	a0,80002218 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800021f0:	4719                	li	a4,6
    800021f2:	05893683          	ld	a3,88(s2)
    800021f6:	6605                	lui	a2,0x1
    800021f8:	020005b7          	lui	a1,0x2000
    800021fc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800021fe:	05b6                	slli	a1,a1,0xd
    80002200:	8526                	mv	a0,s1
    80002202:	e5ffe0ef          	jal	80001060 <mappages>
    80002206:	00054f63          	bltz	a0,80002224 <proc_pagetable+0x66>
}
    8000220a:	8526                	mv	a0,s1
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	64a2                	ld	s1,8(sp)
    80002212:	6902                	ld	s2,0(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret
    uvmfree(pagetable, 0);
    80002218:	4581                	li	a1,0
    8000221a:	8526                	mv	a0,s1
    8000221c:	f6aff0ef          	jal	80001986 <uvmfree>
    return 0;
    80002220:	4481                	li	s1,0
    80002222:	b7e5                	j	8000220a <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002224:	4681                	li	a3,0
    80002226:	4605                	li	a2,1
    80002228:	040005b7          	lui	a1,0x4000
    8000222c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000222e:	05b2                	slli	a1,a1,0xc
    80002230:	8526                	mv	a0,s1
    80002232:	ffdfe0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    80002236:	4581                	li	a1,0
    80002238:	8526                	mv	a0,s1
    8000223a:	f4cff0ef          	jal	80001986 <uvmfree>
    return 0;
    8000223e:	4481                	li	s1,0
    80002240:	b7e9                	j	8000220a <proc_pagetable+0x4c>

0000000080002242 <proc_freepagetable>:
{
    80002242:	1101                	addi	sp,sp,-32
    80002244:	ec06                	sd	ra,24(sp)
    80002246:	e822                	sd	s0,16(sp)
    80002248:	e426                	sd	s1,8(sp)
    8000224a:	e04a                	sd	s2,0(sp)
    8000224c:	1000                	addi	s0,sp,32
    8000224e:	84aa                	mv	s1,a0
    80002250:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002252:	4681                	li	a3,0
    80002254:	4605                	li	a2,1
    80002256:	040005b7          	lui	a1,0x4000
    8000225a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000225c:	05b2                	slli	a1,a1,0xc
    8000225e:	fd1fe0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002262:	4681                	li	a3,0
    80002264:	4605                	li	a2,1
    80002266:	020005b7          	lui	a1,0x2000
    8000226a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000226c:	05b6                	slli	a1,a1,0xd
    8000226e:	8526                	mv	a0,s1
    80002270:	fbffe0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    80002274:	85ca                	mv	a1,s2
    80002276:	8526                	mv	a0,s1
    80002278:	f0eff0ef          	jal	80001986 <uvmfree>
}
    8000227c:	60e2                	ld	ra,24(sp)
    8000227e:	6442                	ld	s0,16(sp)
    80002280:	64a2                	ld	s1,8(sp)
    80002282:	6902                	ld	s2,0(sp)
    80002284:	6105                	addi	sp,sp,32
    80002286:	8082                	ret

0000000080002288 <freeproc>:
{
    80002288:	1101                	addi	sp,sp,-32
    8000228a:	ec06                	sd	ra,24(sp)
    8000228c:	e822                	sd	s0,16(sp)
    8000228e:	e426                	sd	s1,8(sp)
    80002290:	1000                	addi	s0,sp,32
    80002292:	84aa                	mv	s1,a0
  if(p->trapframe)
    80002294:	6d28                	ld	a0,88(a0)
    80002296:	c119                	beqz	a0,8000229c <freeproc+0x14>
    kfree((void*)p->trapframe);
    80002298:	fc4fe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    8000229c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800022a0:	68a8                	ld	a0,80(s1)
    800022a2:	c501                	beqz	a0,800022aa <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800022a4:	64ac                	ld	a1,72(s1)
    800022a6:	f9dff0ef          	jal	80002242 <proc_freepagetable>
  p->pagetable = 0;
    800022aa:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800022ae:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800022b2:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800022b6:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800022ba:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800022be:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800022c2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800022c6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800022ca:	0004ac23          	sw	zero,24(s1)
  if(p->exec_ip)
    800022ce:	1704b503          	ld	a0,368(s1)
    800022d2:	c119                	beqz	a0,800022d8 <freeproc+0x50>
      iput(p->exec_ip);
    800022d4:	3f9010ef          	jal	80003ecc <iput>
}
    800022d8:	60e2                	ld	ra,24(sp)
    800022da:	6442                	ld	s0,16(sp)
    800022dc:	64a2                	ld	s1,8(sp)
    800022de:	6105                	addi	sp,sp,32
    800022e0:	8082                	ret

00000000800022e2 <allocproc>:
{
    800022e2:	7179                	addi	sp,sp,-48
    800022e4:	f406                	sd	ra,40(sp)
    800022e6:	f022                	sd	s0,32(sp)
    800022e8:	ec26                	sd	s1,24(sp)
    800022ea:	e84a                	sd	s2,16(sp)
    800022ec:	e44e                	sd	s3,8(sp)
    800022ee:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    800022f0:	00012497          	auipc	s1,0x12
    800022f4:	a8848493          	addi	s1,s1,-1400 # 80013d78 <proc>
    800022f8:	00089937          	lui	s2,0x89
    800022fc:	1e890913          	addi	s2,s2,488 # 891e8 <_entry-0x7ff76e18>
    80002300:	02259997          	auipc	s3,0x2259
    80002304:	47898993          	addi	s3,s3,1144 # 8225b778 <tickslock>
    acquire(&p->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	91ffe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    8000230e:	4c9c                	lw	a5,24(s1)
    80002310:	cb89                	beqz	a5,80002322 <allocproc+0x40>
      release(&p->lock);
    80002312:	8526                	mv	a0,s1
    80002314:	9a9fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002318:	94ca                	add	s1,s1,s2
    8000231a:	ff3497e3          	bne	s1,s3,80002308 <allocproc+0x26>
  return 0;
    8000231e:	4481                	li	s1,0
    80002320:	a8bd                	j	8000239e <allocproc+0xbc>
  p->pid = allocpid();
    80002322:	e5fff0ef          	jal	80002180 <allocpid>
    80002326:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002328:	4785                	li	a5,1
    8000232a:	cc9c                	sw	a5,24(s1)
  p->next_fifo_seq = 0;
    8000232c:	000897b7          	lui	a5,0x89
    80002330:	97a6                	add	a5,a5,s1
    80002332:	1c07a423          	sw	zero,456(a5) # 891c8 <_entry-0x7ff76e38>
  p->num_resident = 0;
    80002336:	1a07a823          	sw	zero,432(a5)
  p->num_swappped_pages=0;
    8000233a:	1c07a623          	sw	zero,460(a5)
  p->swap_path[0]='\0';
    8000233e:	1a078a23          	sb	zero,436(a5)
  p->text_end=0;
    80002342:	1c07aa23          	sw	zero,468(a5)
  p->text_start=0;
    80002346:	1c07a823          	sw	zero,464(a5)
  p->data_start=0;
    8000234a:	1c07ac23          	sw	zero,472(a5)
  p->data_end=0;
    8000234e:	1c07ae23          	sw	zero,476(a5)
  p->stack_top=0;
    80002352:	1e07a223          	sw	zero,484(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    80002356:	18048793          	addi	a5,s1,384
    8000235a:	27048713          	addi	a4,s1,624
      p->swap_slots[i]=0;
    8000235e:	0007a023          	sw	zero,0(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    80002362:	0791                	addi	a5,a5,4
    80002364:	fee79de3          	bne	a5,a4,8000235e <allocproc+0x7c>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002368:	fdcfe0ef          	jal	80000b44 <kalloc>
    8000236c:	892a                	mv	s2,a0
    8000236e:	eca8                	sd	a0,88(s1)
    80002370:	cd1d                	beqz	a0,800023ae <allocproc+0xcc>
  p->pagetable = proc_pagetable(p);
    80002372:	8526                	mv	a0,s1
    80002374:	e4bff0ef          	jal	800021be <proc_pagetable>
    80002378:	892a                	mv	s2,a0
    8000237a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000237c:	c129                	beqz	a0,800023be <allocproc+0xdc>
  memset(&p->context, 0, sizeof(p->context));
    8000237e:	07000613          	li	a2,112
    80002382:	4581                	li	a1,0
    80002384:	06048513          	addi	a0,s1,96
    80002388:	971fe0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    8000238c:	00000797          	auipc	a5,0x0
    80002390:	d5a78793          	addi	a5,a5,-678 # 800020e6 <forkret>
    80002394:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002396:	60bc                	ld	a5,64(s1)
    80002398:	6705                	lui	a4,0x1
    8000239a:	97ba                	add	a5,a5,a4
    8000239c:	f4bc                	sd	a5,104(s1)
}
    8000239e:	8526                	mv	a0,s1
    800023a0:	70a2                	ld	ra,40(sp)
    800023a2:	7402                	ld	s0,32(sp)
    800023a4:	64e2                	ld	s1,24(sp)
    800023a6:	6942                	ld	s2,16(sp)
    800023a8:	69a2                	ld	s3,8(sp)
    800023aa:	6145                	addi	sp,sp,48
    800023ac:	8082                	ret
    freeproc(p);
    800023ae:	8526                	mv	a0,s1
    800023b0:	ed9ff0ef          	jal	80002288 <freeproc>
    release(&p->lock);
    800023b4:	8526                	mv	a0,s1
    800023b6:	907fe0ef          	jal	80000cbc <release>
    return 0;
    800023ba:	84ca                	mv	s1,s2
    800023bc:	b7cd                	j	8000239e <allocproc+0xbc>
    freeproc(p);
    800023be:	8526                	mv	a0,s1
    800023c0:	ec9ff0ef          	jal	80002288 <freeproc>
    release(&p->lock);
    800023c4:	8526                	mv	a0,s1
    800023c6:	8f7fe0ef          	jal	80000cbc <release>
    return 0;
    800023ca:	84ca                	mv	s1,s2
    800023cc:	bfc9                	j	8000239e <allocproc+0xbc>

00000000800023ce <userinit>:
{
    800023ce:	1101                	addi	sp,sp,-32
    800023d0:	ec06                	sd	ra,24(sp)
    800023d2:	e822                	sd	s0,16(sp)
    800023d4:	e426                	sd	s1,8(sp)
    800023d6:	1000                	addi	s0,sp,32
  p = allocproc();
    800023d8:	f0bff0ef          	jal	800022e2 <allocproc>
    800023dc:	84aa                	mv	s1,a0
  initproc = p;
    800023de:	00009797          	auipc	a5,0x9
    800023e2:	46a7b123          	sd	a0,1122(a5) # 8000b840 <initproc>
  p->cwd = namei("/");
    800023e6:	00006517          	auipc	a0,0x6
    800023ea:	00a50513          	addi	a0,a0,10 # 800083f0 <etext+0x3f0>
    800023ee:	18a020ef          	jal	80004578 <namei>
    800023f2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800023f6:	478d                	li	a5,3
    800023f8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	8c1fe0ef          	jal	80000cbc <release>
}
    80002400:	60e2                	ld	ra,24(sp)
    80002402:	6442                	ld	s0,16(sp)
    80002404:	64a2                	ld	s1,8(sp)
    80002406:	6105                	addi	sp,sp,32
    80002408:	8082                	ret

000000008000240a <growproc>:
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	e426                	sd	s1,8(sp)
    80002412:	e04a                	sd	s2,0(sp)
    80002414:	1000                	addi	s0,sp,32
    80002416:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002418:	c9dff0ef          	jal	800020b4 <myproc>
    8000241c:	892a                	mv	s2,a0
  sz = p->sz;
    8000241e:	652c                	ld	a1,72(a0)
  if(n > 0){
    80002420:	02905963          	blez	s1,80002452 <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80002424:	00b48633          	add	a2,s1,a1
    80002428:	020007b7          	lui	a5,0x2000
    8000242c:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    8000242e:	07b6                	slli	a5,a5,0xd
    80002430:	02c7ea63          	bltu	a5,a2,80002464 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002434:	4691                	li	a3,4
    80002436:	6928                	ld	a0,80(a0)
    80002438:	c52ff0ef          	jal	8000188a <uvmalloc>
    8000243c:	85aa                	mv	a1,a0
    8000243e:	c50d                	beqz	a0,80002468 <growproc+0x5e>
  p->sz = sz;
    80002440:	04b93423          	sd	a1,72(s2)
  return 0;
    80002444:	4501                	li	a0,0
}
    80002446:	60e2                	ld	ra,24(sp)
    80002448:	6442                	ld	s0,16(sp)
    8000244a:	64a2                	ld	s1,8(sp)
    8000244c:	6902                	ld	s2,0(sp)
    8000244e:	6105                	addi	sp,sp,32
    80002450:	8082                	ret
  } else if(n < 0){
    80002452:	fe04d7e3          	bgez	s1,80002440 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002456:	00b48633          	add	a2,s1,a1
    8000245a:	6928                	ld	a0,80(a0)
    8000245c:	beaff0ef          	jal	80001846 <uvmdealloc>
    80002460:	85aa                	mv	a1,a0
    80002462:	bff9                	j	80002440 <growproc+0x36>
      return -1;
    80002464:	557d                	li	a0,-1
    80002466:	b7c5                	j	80002446 <growproc+0x3c>
      return -1;
    80002468:	557d                	li	a0,-1
    8000246a:	bff1                	j	80002446 <growproc+0x3c>

000000008000246c <kfork>:
{
    8000246c:	7139                	addi	sp,sp,-64
    8000246e:	fc06                	sd	ra,56(sp)
    80002470:	f822                	sd	s0,48(sp)
    80002472:	f426                	sd	s1,40(sp)
    80002474:	e852                	sd	s4,16(sp)
    80002476:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002478:	c3dff0ef          	jal	800020b4 <myproc>
    8000247c:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    8000247e:	e65ff0ef          	jal	800022e2 <allocproc>
    80002482:	1a050663          	beqz	a0,8000262e <kfork+0x1c2>
    80002486:	ec4e                	sd	s3,24(sp)
    80002488:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000248a:	048a3603          	ld	a2,72(s4)
    8000248e:	692c                	ld	a1,80(a0)
    80002490:	050a3503          	ld	a0,80(s4)
    80002494:	d24ff0ef          	jal	800019b8 <uvmcopy>
    80002498:	0e054d63          	bltz	a0,80002592 <kfork+0x126>
    8000249c:	f04a                	sd	s2,32(sp)
    8000249e:	e456                	sd	s5,8(sp)
  np->sz = p->sz;
    800024a0:	048a3783          	ld	a5,72(s4)
    800024a4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800024a8:	058a3683          	ld	a3,88(s4)
    800024ac:	87b6                	mv	a5,a3
    800024ae:	0589b703          	ld	a4,88(s3)
    800024b2:	12068693          	addi	a3,a3,288
    800024b6:	6388                	ld	a0,0(a5)
    800024b8:	678c                	ld	a1,8(a5)
    800024ba:	6b90                	ld	a2,16(a5)
    800024bc:	e308                	sd	a0,0(a4)
    800024be:	e70c                	sd	a1,8(a4)
    800024c0:	eb10                	sd	a2,16(a4)
    800024c2:	6f90                	ld	a2,24(a5)
    800024c4:	ef10                	sd	a2,24(a4)
    800024c6:	02078793          	addi	a5,a5,32
    800024ca:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    800024ce:	fed794e3          	bne	a5,a3,800024b6 <kfork+0x4a>
  np->heap_start = p->heap_start;
    800024d2:	168a3783          	ld	a5,360(s4)
    800024d6:	16f9b423          	sd	a5,360(s3)
  np->num_resident = p->num_resident;
    800024da:	000897b7          	lui	a5,0x89
    800024de:	00fa0733          	add	a4,s4,a5
    800024e2:	1b072683          	lw	a3,432(a4)
    800024e6:	97ce                	add	a5,a5,s3
    800024e8:	1ad7a823          	sw	a3,432(a5) # 891b0 <_entry-0x7ff76e50>
  np->next_fifo_seq = p->next_fifo_seq;
    800024ec:	1c872683          	lw	a3,456(a4)
    800024f0:	1cd7a423          	sw	a3,456(a5)
  np->num_swappped_pages = p->num_swappped_pages;
    800024f4:	1cc72683          	lw	a3,460(a4)
    800024f8:	1cd7a623          	sw	a3,460(a5)
  for (i = 0; i < p->num_resident; i++) {
    800024fc:	1b072783          	lw	a5,432(a4)
    80002500:	02f05563          	blez	a5,8000252a <kfork+0xbe>
    80002504:	270a0713          	addi	a4,s4,624
    80002508:	27098793          	addi	a5,s3,624
    8000250c:	4681                	li	a3,0
    8000250e:	000895b7          	lui	a1,0x89
    80002512:	95d2                	add	a1,a1,s4
    np->resident_pages[i] = p->resident_pages[i];
    80002514:	6310                	ld	a2,0(a4)
    80002516:	e390                	sd	a2,0(a5)
    80002518:	6710                	ld	a2,8(a4)
    8000251a:	e790                	sd	a2,8(a5)
  for (i = 0; i < p->num_resident; i++) {
    8000251c:	2685                	addiw	a3,a3,1
    8000251e:	0741                	addi	a4,a4,16
    80002520:	07c1                	addi	a5,a5,16
    80002522:	1b05a603          	lw	a2,432(a1) # 891b0 <_entry-0x7ff76e50>
    80002526:	fec6c7e3          	blt	a3,a2,80002514 <kfork+0xa8>
  for (i = 0; i < p->num_swappped_pages; i++) {
    8000252a:	000897b7          	lui	a5,0x89
    8000252e:	97d2                	add	a5,a5,s4
    80002530:	1cc7a783          	lw	a5,460(a5) # 891cc <_entry-0x7ff76e34>
    80002534:	02f05863          	blez	a5,80002564 <kfork+0xf8>
    80002538:	000897b7          	lui	a5,0x89
    8000253c:	df078793          	addi	a5,a5,-528 # 88df0 <_entry-0x7ff77210>
    80002540:	00fa0733          	add	a4,s4,a5
    80002544:	97ce                	add	a5,a5,s3
    80002546:	4681                	li	a3,0
    80002548:	000895b7          	lui	a1,0x89
    8000254c:	95d2                	add	a1,a1,s4
    np->swapped_pages[i] = p->swapped_pages[i];
    8000254e:	6310                	ld	a2,0(a4)
    80002550:	e390                	sd	a2,0(a5)
    80002552:	6710                	ld	a2,8(a4)
    80002554:	e790                	sd	a2,8(a5)
  for (i = 0; i < p->num_swappped_pages; i++) {
    80002556:	2685                	addiw	a3,a3,1
    80002558:	0741                	addi	a4,a4,16
    8000255a:	07c1                	addi	a5,a5,16
    8000255c:	1cc5a603          	lw	a2,460(a1) # 891cc <_entry-0x7ff76e34>
    80002560:	fec6c7e3          	blt	a3,a2,8000254e <kfork+0xe2>
  for (i = 0; i < MAX_SWAP_PAGES; i++) {
    80002564:	180a0793          	addi	a5,s4,384
    80002568:	18098713          	addi	a4,s3,384
    8000256c:	270a0613          	addi	a2,s4,624
    np->swap_slots[i] = p->swap_slots[i];
    80002570:	4394                	lw	a3,0(a5)
    80002572:	c314                	sw	a3,0(a4)
  for (i = 0; i < MAX_SWAP_PAGES; i++) {
    80002574:	0791                	addi	a5,a5,4
    80002576:	0711                	addi	a4,a4,4
    80002578:	fec79ce3          	bne	a5,a2,80002570 <kfork+0x104>
  np->trapframe->a0 = 0;
    8000257c:	0589b783          	ld	a5,88(s3)
    80002580:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002584:	0d0a0493          	addi	s1,s4,208
    80002588:	0d098913          	addi	s2,s3,208
    8000258c:	150a0a93          	addi	s5,s4,336
    80002590:	a831                	j	800025ac <kfork+0x140>
    freeproc(np);
    80002592:	854e                	mv	a0,s3
    80002594:	cf5ff0ef          	jal	80002288 <freeproc>
    release(&np->lock);
    80002598:	854e                	mv	a0,s3
    8000259a:	f22fe0ef          	jal	80000cbc <release>
    return -1;
    8000259e:	54fd                	li	s1,-1
    800025a0:	69e2                	ld	s3,24(sp)
    800025a2:	a8bd                	j	80002620 <kfork+0x1b4>
  for(i = 0; i < NOFILE; i++)
    800025a4:	04a1                	addi	s1,s1,8
    800025a6:	0921                	addi	s2,s2,8
    800025a8:	01548963          	beq	s1,s5,800025ba <kfork+0x14e>
    if(p->ofile[i])
    800025ac:	6088                	ld	a0,0(s1)
    800025ae:	d97d                	beqz	a0,800025a4 <kfork+0x138>
      np->ofile[i] = filedup(p->ofile[i]);
    800025b0:	584020ef          	jal	80004b34 <filedup>
    800025b4:	00a93023          	sd	a0,0(s2)
    800025b8:	b7f5                	j	800025a4 <kfork+0x138>
  np->cwd = idup(p->cwd);
    800025ba:	150a3503          	ld	a0,336(s4)
    800025be:	756010ef          	jal	80003d14 <idup>
    800025c2:	14a9b823          	sd	a0,336(s3)
  if(p->exec_ip)
    800025c6:	170a3503          	ld	a0,368(s4)
    800025ca:	c509                	beqz	a0,800025d4 <kfork+0x168>
    np->exec_ip = idup(p->exec_ip);
    800025cc:	748010ef          	jal	80003d14 <idup>
    800025d0:	16a9b823          	sd	a0,368(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800025d4:	4641                	li	a2,16
    800025d6:	158a0593          	addi	a1,s4,344
    800025da:	15898513          	addi	a0,s3,344
    800025de:	86ffe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    800025e2:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    800025e6:	854e                	mv	a0,s3
    800025e8:	ed4fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    800025ec:	00011517          	auipc	a0,0x11
    800025f0:	37450513          	addi	a0,a0,884 # 80013960 <wait_lock>
    800025f4:	e34fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    800025f8:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    800025fc:	00011517          	auipc	a0,0x11
    80002600:	36450513          	addi	a0,a0,868 # 80013960 <wait_lock>
    80002604:	eb8fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80002608:	854e                	mv	a0,s3
    8000260a:	e1efe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    8000260e:	478d                	li	a5,3
    80002610:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002614:	854e                	mv	a0,s3
    80002616:	ea6fe0ef          	jal	80000cbc <release>
  return pid;
    8000261a:	7902                	ld	s2,32(sp)
    8000261c:	69e2                	ld	s3,24(sp)
    8000261e:	6aa2                	ld	s5,8(sp)
}
    80002620:	8526                	mv	a0,s1
    80002622:	70e2                	ld	ra,56(sp)
    80002624:	7442                	ld	s0,48(sp)
    80002626:	74a2                	ld	s1,40(sp)
    80002628:	6a42                	ld	s4,16(sp)
    8000262a:	6121                	addi	sp,sp,64
    8000262c:	8082                	ret
    return -1;
    8000262e:	54fd                	li	s1,-1
    80002630:	bfc5                	j	80002620 <kfork+0x1b4>

0000000080002632 <scheduler>:
{
    80002632:	715d                	addi	sp,sp,-80
    80002634:	e486                	sd	ra,72(sp)
    80002636:	e0a2                	sd	s0,64(sp)
    80002638:	fc26                	sd	s1,56(sp)
    8000263a:	f84a                	sd	s2,48(sp)
    8000263c:	f44e                	sd	s3,40(sp)
    8000263e:	f052                	sd	s4,32(sp)
    80002640:	ec56                	sd	s5,24(sp)
    80002642:	e85a                	sd	s6,16(sp)
    80002644:	e45e                	sd	s7,8(sp)
    80002646:	e062                	sd	s8,0(sp)
    80002648:	0880                	addi	s0,sp,80
    8000264a:	8792                	mv	a5,tp
  int id = r_tp();
    8000264c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000264e:	00779b13          	slli	s6,a5,0x7
    80002652:	00011717          	auipc	a4,0x11
    80002656:	2f670713          	addi	a4,a4,758 # 80013948 <pid_lock>
    8000265a:	975a                	add	a4,a4,s6
    8000265c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002660:	00011717          	auipc	a4,0x11
    80002664:	32070713          	addi	a4,a4,800 # 80013980 <cpus+0x8>
    80002668:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000266a:	4c11                	li	s8,4
        c->proc = p;
    8000266c:	079e                	slli	a5,a5,0x7
    8000266e:	00011a17          	auipc	s4,0x11
    80002672:	2daa0a13          	addi	s4,s4,730 # 80013948 <pid_lock>
    80002676:	9a3e                	add	s4,s4,a5
        found = 1;
    80002678:	4b85                	li	s7,1
    8000267a:	a091                	j	800026be <scheduler+0x8c>
      release(&p->lock);
    8000267c:	8526                	mv	a0,s1
    8000267e:	e3efe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002682:	94ca                	add	s1,s1,s2
    80002684:	02259797          	auipc	a5,0x2259
    80002688:	0f478793          	addi	a5,a5,244 # 8225b778 <tickslock>
    8000268c:	02f48563          	beq	s1,a5,800026b6 <scheduler+0x84>
      acquire(&p->lock);
    80002690:	8526                	mv	a0,s1
    80002692:	d96fe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80002696:	4c9c                	lw	a5,24(s1)
    80002698:	ff3792e3          	bne	a5,s3,8000267c <scheduler+0x4a>
        p->state = RUNNING;
    8000269c:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800026a0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800026a4:	06048593          	addi	a1,s1,96
    800026a8:	855a                	mv	a0,s6
    800026aa:	624000ef          	jal	80002cce <swtch>
        c->proc = 0;
    800026ae:	020a3823          	sd	zero,48(s4)
        found = 1;
    800026b2:	8ade                	mv	s5,s7
    800026b4:	b7e1                	j	8000267c <scheduler+0x4a>
    if(found == 0) {
    800026b6:	000a9463          	bnez	s5,800026be <scheduler+0x8c>
      asm volatile("wfi");
    800026ba:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026c2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026c6:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ca:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026ce:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026d0:	10079073          	csrw	sstatus,a5
    int found = 0;
    800026d4:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800026d6:	00011497          	auipc	s1,0x11
    800026da:	6a248493          	addi	s1,s1,1698 # 80013d78 <proc>
      if(p->state == RUNNABLE) {
    800026de:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800026e0:	00089937          	lui	s2,0x89
    800026e4:	1e890913          	addi	s2,s2,488 # 891e8 <_entry-0x7ff76e18>
    800026e8:	b765                	j	80002690 <scheduler+0x5e>

00000000800026ea <sched>:
{
    800026ea:	7179                	addi	sp,sp,-48
    800026ec:	f406                	sd	ra,40(sp)
    800026ee:	f022                	sd	s0,32(sp)
    800026f0:	ec26                	sd	s1,24(sp)
    800026f2:	e84a                	sd	s2,16(sp)
    800026f4:	e44e                	sd	s3,8(sp)
    800026f6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800026f8:	9bdff0ef          	jal	800020b4 <myproc>
    800026fc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800026fe:	cbafe0ef          	jal	80000bb8 <holding>
    80002702:	c935                	beqz	a0,80002776 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002704:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002706:	2781                	sext.w	a5,a5
    80002708:	079e                	slli	a5,a5,0x7
    8000270a:	00011717          	auipc	a4,0x11
    8000270e:	23e70713          	addi	a4,a4,574 # 80013948 <pid_lock>
    80002712:	97ba                	add	a5,a5,a4
    80002714:	0a87a703          	lw	a4,168(a5)
    80002718:	4785                	li	a5,1
    8000271a:	06f71463          	bne	a4,a5,80002782 <sched+0x98>
  if(p->state == RUNNING)
    8000271e:	4c98                	lw	a4,24(s1)
    80002720:	4791                	li	a5,4
    80002722:	06f70663          	beq	a4,a5,8000278e <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002726:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000272a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000272c:	e7bd                	bnez	a5,8000279a <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000272e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002730:	00011917          	auipc	s2,0x11
    80002734:	21890913          	addi	s2,s2,536 # 80013948 <pid_lock>
    80002738:	2781                	sext.w	a5,a5
    8000273a:	079e                	slli	a5,a5,0x7
    8000273c:	97ca                	add	a5,a5,s2
    8000273e:	0ac7a983          	lw	s3,172(a5)
    80002742:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002744:	2781                	sext.w	a5,a5
    80002746:	079e                	slli	a5,a5,0x7
    80002748:	07a1                	addi	a5,a5,8
    8000274a:	00011597          	auipc	a1,0x11
    8000274e:	22e58593          	addi	a1,a1,558 # 80013978 <cpus>
    80002752:	95be                	add	a1,a1,a5
    80002754:	06048513          	addi	a0,s1,96
    80002758:	576000ef          	jal	80002cce <swtch>
    8000275c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000275e:	2781                	sext.w	a5,a5
    80002760:	079e                	slli	a5,a5,0x7
    80002762:	993e                	add	s2,s2,a5
    80002764:	0b392623          	sw	s3,172(s2)
}
    80002768:	70a2                	ld	ra,40(sp)
    8000276a:	7402                	ld	s0,32(sp)
    8000276c:	64e2                	ld	s1,24(sp)
    8000276e:	6942                	ld	s2,16(sp)
    80002770:	69a2                	ld	s3,8(sp)
    80002772:	6145                	addi	sp,sp,48
    80002774:	8082                	ret
    panic("sched p->lock");
    80002776:	00006517          	auipc	a0,0x6
    8000277a:	c8250513          	addi	a0,a0,-894 # 800083f8 <etext+0x3f8>
    8000277e:	8a6fe0ef          	jal	80000824 <panic>
    panic("sched locks");
    80002782:	00006517          	auipc	a0,0x6
    80002786:	c8650513          	addi	a0,a0,-890 # 80008408 <etext+0x408>
    8000278a:	89afe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    8000278e:	00006517          	auipc	a0,0x6
    80002792:	c8a50513          	addi	a0,a0,-886 # 80008418 <etext+0x418>
    80002796:	88efe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    8000279a:	00006517          	auipc	a0,0x6
    8000279e:	c8e50513          	addi	a0,a0,-882 # 80008428 <etext+0x428>
    800027a2:	882fe0ef          	jal	80000824 <panic>

00000000800027a6 <yield>:
{
    800027a6:	1101                	addi	sp,sp,-32
    800027a8:	ec06                	sd	ra,24(sp)
    800027aa:	e822                	sd	s0,16(sp)
    800027ac:	e426                	sd	s1,8(sp)
    800027ae:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800027b0:	905ff0ef          	jal	800020b4 <myproc>
    800027b4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800027b6:	c72fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    800027ba:	478d                	li	a5,3
    800027bc:	cc9c                	sw	a5,24(s1)
  sched();
    800027be:	f2dff0ef          	jal	800026ea <sched>
  release(&p->lock);
    800027c2:	8526                	mv	a0,s1
    800027c4:	cf8fe0ef          	jal	80000cbc <release>
}
    800027c8:	60e2                	ld	ra,24(sp)
    800027ca:	6442                	ld	s0,16(sp)
    800027cc:	64a2                	ld	s1,8(sp)
    800027ce:	6105                	addi	sp,sp,32
    800027d0:	8082                	ret

00000000800027d2 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800027d2:	7179                	addi	sp,sp,-48
    800027d4:	f406                	sd	ra,40(sp)
    800027d6:	f022                	sd	s0,32(sp)
    800027d8:	ec26                	sd	s1,24(sp)
    800027da:	e84a                	sd	s2,16(sp)
    800027dc:	e44e                	sd	s3,8(sp)
    800027de:	1800                	addi	s0,sp,48
    800027e0:	89aa                	mv	s3,a0
    800027e2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027e4:	8d1ff0ef          	jal	800020b4 <myproc>
    800027e8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800027ea:	c3efe0ef          	jal	80000c28 <acquire>
  release(lk);
    800027ee:	854a                	mv	a0,s2
    800027f0:	cccfe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    800027f4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800027f8:	4789                	li	a5,2
    800027fa:	cc9c                	sw	a5,24(s1)

  sched();
    800027fc:	eefff0ef          	jal	800026ea <sched>

  // Tidy up.
  p->chan = 0;
    80002800:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002804:	8526                	mv	a0,s1
    80002806:	cb6fe0ef          	jal	80000cbc <release>
  acquire(lk);
    8000280a:	854a                	mv	a0,s2
    8000280c:	c1cfe0ef          	jal	80000c28 <acquire>
}
    80002810:	70a2                	ld	ra,40(sp)
    80002812:	7402                	ld	s0,32(sp)
    80002814:	64e2                	ld	s1,24(sp)
    80002816:	6942                	ld	s2,16(sp)
    80002818:	69a2                	ld	s3,8(sp)
    8000281a:	6145                	addi	sp,sp,48
    8000281c:	8082                	ret

000000008000281e <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000281e:	7139                	addi	sp,sp,-64
    80002820:	fc06                	sd	ra,56(sp)
    80002822:	f822                	sd	s0,48(sp)
    80002824:	f426                	sd	s1,40(sp)
    80002826:	f04a                	sd	s2,32(sp)
    80002828:	ec4e                	sd	s3,24(sp)
    8000282a:	e852                	sd	s4,16(sp)
    8000282c:	e456                	sd	s5,8(sp)
    8000282e:	e05a                	sd	s6,0(sp)
    80002830:	0080                	addi	s0,sp,64
    80002832:	8aaa                	mv	s5,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002834:	00011497          	auipc	s1,0x11
    80002838:	54448493          	addi	s1,s1,1348 # 80013d78 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000283c:	4a09                	li	s4,2
        p->state = RUNNABLE;
    8000283e:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002840:	00089937          	lui	s2,0x89
    80002844:	1e890913          	addi	s2,s2,488 # 891e8 <_entry-0x7ff76e18>
    80002848:	02259997          	auipc	s3,0x2259
    8000284c:	f3098993          	addi	s3,s3,-208 # 8225b778 <tickslock>
    80002850:	a039                	j	8000285e <wakeup+0x40>
      }
      release(&p->lock);
    80002852:	8526                	mv	a0,s1
    80002854:	c68fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002858:	94ca                	add	s1,s1,s2
    8000285a:	03348263          	beq	s1,s3,8000287e <wakeup+0x60>
    if(p != myproc()){
    8000285e:	857ff0ef          	jal	800020b4 <myproc>
    80002862:	fe950be3          	beq	a0,s1,80002858 <wakeup+0x3a>
      acquire(&p->lock);
    80002866:	8526                	mv	a0,s1
    80002868:	bc0fe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000286c:	4c9c                	lw	a5,24(s1)
    8000286e:	ff4792e3          	bne	a5,s4,80002852 <wakeup+0x34>
    80002872:	709c                	ld	a5,32(s1)
    80002874:	fd579fe3          	bne	a5,s5,80002852 <wakeup+0x34>
        p->state = RUNNABLE;
    80002878:	0164ac23          	sw	s6,24(s1)
    8000287c:	bfd9                	j	80002852 <wakeup+0x34>
    }
  }
}
    8000287e:	70e2                	ld	ra,56(sp)
    80002880:	7442                	ld	s0,48(sp)
    80002882:	74a2                	ld	s1,40(sp)
    80002884:	7902                	ld	s2,32(sp)
    80002886:	69e2                	ld	s3,24(sp)
    80002888:	6a42                	ld	s4,16(sp)
    8000288a:	6aa2                	ld	s5,8(sp)
    8000288c:	6b02                	ld	s6,0(sp)
    8000288e:	6121                	addi	sp,sp,64
    80002890:	8082                	ret

0000000080002892 <reparent>:
{
    80002892:	7139                	addi	sp,sp,-64
    80002894:	fc06                	sd	ra,56(sp)
    80002896:	f822                	sd	s0,48(sp)
    80002898:	f426                	sd	s1,40(sp)
    8000289a:	f04a                	sd	s2,32(sp)
    8000289c:	ec4e                	sd	s3,24(sp)
    8000289e:	e852                	sd	s4,16(sp)
    800028a0:	e456                	sd	s5,8(sp)
    800028a2:	0080                	addi	s0,sp,64
    800028a4:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800028a6:	00011497          	auipc	s1,0x11
    800028aa:	4d248493          	addi	s1,s1,1234 # 80013d78 <proc>
      pp->parent = initproc;
    800028ae:	00009a97          	auipc	s5,0x9
    800028b2:	f92a8a93          	addi	s5,s5,-110 # 8000b840 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800028b6:	00089937          	lui	s2,0x89
    800028ba:	1e890913          	addi	s2,s2,488 # 891e8 <_entry-0x7ff76e18>
    800028be:	02259a17          	auipc	s4,0x2259
    800028c2:	ebaa0a13          	addi	s4,s4,-326 # 8225b778 <tickslock>
    800028c6:	a021                	j	800028ce <reparent+0x3c>
    800028c8:	94ca                	add	s1,s1,s2
    800028ca:	01448b63          	beq	s1,s4,800028e0 <reparent+0x4e>
    if(pp->parent == p){
    800028ce:	7c9c                	ld	a5,56(s1)
    800028d0:	ff379ce3          	bne	a5,s3,800028c8 <reparent+0x36>
      pp->parent = initproc;
    800028d4:	000ab503          	ld	a0,0(s5)
    800028d8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800028da:	f45ff0ef          	jal	8000281e <wakeup>
    800028de:	b7ed                	j	800028c8 <reparent+0x36>
}
    800028e0:	70e2                	ld	ra,56(sp)
    800028e2:	7442                	ld	s0,48(sp)
    800028e4:	74a2                	ld	s1,40(sp)
    800028e6:	7902                	ld	s2,32(sp)
    800028e8:	69e2                	ld	s3,24(sp)
    800028ea:	6a42                	ld	s4,16(sp)
    800028ec:	6aa2                	ld	s5,8(sp)
    800028ee:	6121                	addi	sp,sp,64
    800028f0:	8082                	ret

00000000800028f2 <kexit>:
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	e84a                	sd	s2,16(sp)
    800028fc:	e44e                	sd	s3,8(sp)
    800028fe:	e052                	sd	s4,0(sp)
    80002900:	1800                	addi	s0,sp,48
    80002902:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002904:	fb0ff0ef          	jal	800020b4 <myproc>
    80002908:	892a                	mv	s2,a0
  if(p == initproc)
    8000290a:	00009797          	auipc	a5,0x9
    8000290e:	f367b783          	ld	a5,-202(a5) # 8000b840 <initproc>
    80002912:	0d050493          	addi	s1,a0,208
    80002916:	15050993          	addi	s3,a0,336
    8000291a:	00a79b63          	bne	a5,a0,80002930 <kexit+0x3e>
    panic("init exiting");
    8000291e:	00006517          	auipc	a0,0x6
    80002922:	b2250513          	addi	a0,a0,-1246 # 80008440 <etext+0x440>
    80002926:	efffd0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000292a:	04a1                	addi	s1,s1,8
    8000292c:	01348963          	beq	s1,s3,8000293e <kexit+0x4c>
    if(p->ofile[fd]){
    80002930:	6088                	ld	a0,0(s1)
    80002932:	dd65                	beqz	a0,8000292a <kexit+0x38>
      fileclose(f);
    80002934:	246020ef          	jal	80004b7a <fileclose>
      p->ofile[fd] = 0;
    80002938:	0004b023          	sd	zero,0(s1)
    8000293c:	b7fd                	j	8000292a <kexit+0x38>
  if(p->swap_file){
    8000293e:	17893783          	ld	a5,376(s2)
    80002942:	cf8d                	beqz	a5,8000297c <kexit+0x8a>
    printf("[pid %d] SWAPCLEANUP freed_slots=%d\n", p->pid, p->num_swappped_pages);
    80002944:	000897b7          	lui	a5,0x89
    80002948:	97ca                	add	a5,a5,s2
    8000294a:	1cc7a603          	lw	a2,460(a5) # 891cc <_entry-0x7ff76e34>
    8000294e:	03092583          	lw	a1,48(s2)
    80002952:	00006517          	auipc	a0,0x6
    80002956:	afe50513          	addi	a0,a0,-1282 # 80008450 <etext+0x450>
    8000295a:	ba1fd0ef          	jal	800004fa <printf>
    begin_op(); // Start a file system transaction.
    8000295e:	5f9010ef          	jal	80004756 <begin_op>
    itrunc(p->swap_file->ip);
    80002962:	17893783          	ld	a5,376(s2)
    80002966:	6f88                	ld	a0,24(a5)
    80002968:	4d0010ef          	jal	80003e38 <itrunc>
    fileclose(p->swap_file);
    8000296c:	17893503          	ld	a0,376(s2)
    80002970:	20a020ef          	jal	80004b7a <fileclose>
    p->swap_file = 0; // Clear the pointer.
    80002974:	16093c23          	sd	zero,376(s2)
    end_op(); // End the transaction.
    80002978:	64f010ef          	jal	800047c6 <end_op>
  begin_op();
    8000297c:	5db010ef          	jal	80004756 <begin_op>
  iput(p->cwd);
    80002980:	15093503          	ld	a0,336(s2)
    80002984:	548010ef          	jal	80003ecc <iput>
  end_op();
    80002988:	63f010ef          	jal	800047c6 <end_op>
  p->cwd = 0;
    8000298c:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    80002990:	00011517          	auipc	a0,0x11
    80002994:	fd050513          	addi	a0,a0,-48 # 80013960 <wait_lock>
    80002998:	a90fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    8000299c:	854a                	mv	a0,s2
    8000299e:	ef5ff0ef          	jal	80002892 <reparent>
  wakeup(p->parent);
    800029a2:	03893503          	ld	a0,56(s2)
    800029a6:	e79ff0ef          	jal	8000281e <wakeup>
  acquire(&p->lock);
    800029aa:	854a                	mv	a0,s2
    800029ac:	a7cfe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800029b0:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    800029b4:	4795                	li	a5,5
    800029b6:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    800029ba:	00011517          	auipc	a0,0x11
    800029be:	fa650513          	addi	a0,a0,-90 # 80013960 <wait_lock>
    800029c2:	afafe0ef          	jal	80000cbc <release>
  sched();
    800029c6:	d25ff0ef          	jal	800026ea <sched>
  panic("zombie exit");
    800029ca:	00006517          	auipc	a0,0x6
    800029ce:	aae50513          	addi	a0,a0,-1362 # 80008478 <etext+0x478>
    800029d2:	e53fd0ef          	jal	80000824 <panic>

00000000800029d6 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800029d6:	7179                	addi	sp,sp,-48
    800029d8:	f406                	sd	ra,40(sp)
    800029da:	f022                	sd	s0,32(sp)
    800029dc:	ec26                	sd	s1,24(sp)
    800029de:	e84a                	sd	s2,16(sp)
    800029e0:	e44e                	sd	s3,8(sp)
    800029e2:	e052                	sd	s4,0(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800029e8:	00011497          	auipc	s1,0x11
    800029ec:	39048493          	addi	s1,s1,912 # 80013d78 <proc>
    800029f0:	000899b7          	lui	s3,0x89
    800029f4:	1e898993          	addi	s3,s3,488 # 891e8 <_entry-0x7ff76e18>
    800029f8:	02259a17          	auipc	s4,0x2259
    800029fc:	d80a0a13          	addi	s4,s4,-640 # 8225b778 <tickslock>
    acquire(&p->lock);
    80002a00:	8526                	mv	a0,s1
    80002a02:	a26fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    80002a06:	589c                	lw	a5,48(s1)
    80002a08:	01278a63          	beq	a5,s2,80002a1c <kkill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	aaefe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a12:	94ce                	add	s1,s1,s3
    80002a14:	ff4496e3          	bne	s1,s4,80002a00 <kkill+0x2a>
  }
  return -1;
    80002a18:	557d                	li	a0,-1
    80002a1a:	a819                	j	80002a30 <kkill+0x5a>
      p->killed = 1;
    80002a1c:	4785                	li	a5,1
    80002a1e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002a20:	4c98                	lw	a4,24(s1)
    80002a22:	4789                	li	a5,2
    80002a24:	00f70e63          	beq	a4,a5,80002a40 <kkill+0x6a>
      release(&p->lock);
    80002a28:	8526                	mv	a0,s1
    80002a2a:	a92fe0ef          	jal	80000cbc <release>
      return 0;
    80002a2e:	4501                	li	a0,0
}
    80002a30:	70a2                	ld	ra,40(sp)
    80002a32:	7402                	ld	s0,32(sp)
    80002a34:	64e2                	ld	s1,24(sp)
    80002a36:	6942                	ld	s2,16(sp)
    80002a38:	69a2                	ld	s3,8(sp)
    80002a3a:	6a02                	ld	s4,0(sp)
    80002a3c:	6145                	addi	sp,sp,48
    80002a3e:	8082                	ret
        p->state = RUNNABLE;
    80002a40:	478d                	li	a5,3
    80002a42:	cc9c                	sw	a5,24(s1)
    80002a44:	b7d5                	j	80002a28 <kkill+0x52>

0000000080002a46 <setkilled>:

void
setkilled(struct proc *p)
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	1000                	addi	s0,sp,32
    80002a50:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002a52:	9d6fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002a56:	4785                	li	a5,1
    80002a58:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	a60fe0ef          	jal	80000cbc <release>
}
    80002a60:	60e2                	ld	ra,24(sp)
    80002a62:	6442                	ld	s0,16(sp)
    80002a64:	64a2                	ld	s1,8(sp)
    80002a66:	6105                	addi	sp,sp,32
    80002a68:	8082                	ret

0000000080002a6a <killed>:

int
killed(struct proc *p)
{
    80002a6a:	1101                	addi	sp,sp,-32
    80002a6c:	ec06                	sd	ra,24(sp)
    80002a6e:	e822                	sd	s0,16(sp)
    80002a70:	e426                	sd	s1,8(sp)
    80002a72:	e04a                	sd	s2,0(sp)
    80002a74:	1000                	addi	s0,sp,32
    80002a76:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002a78:	9b0fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    80002a7c:	549c                	lw	a5,40(s1)
    80002a7e:	893e                	mv	s2,a5
  release(&p->lock);
    80002a80:	8526                	mv	a0,s1
    80002a82:	a3afe0ef          	jal	80000cbc <release>
  return k;
}
    80002a86:	854a                	mv	a0,s2
    80002a88:	60e2                	ld	ra,24(sp)
    80002a8a:	6442                	ld	s0,16(sp)
    80002a8c:	64a2                	ld	s1,8(sp)
    80002a8e:	6902                	ld	s2,0(sp)
    80002a90:	6105                	addi	sp,sp,32
    80002a92:	8082                	ret

0000000080002a94 <kwait>:
{
    80002a94:	715d                	addi	sp,sp,-80
    80002a96:	e486                	sd	ra,72(sp)
    80002a98:	e0a2                	sd	s0,64(sp)
    80002a9a:	fc26                	sd	s1,56(sp)
    80002a9c:	f84a                	sd	s2,48(sp)
    80002a9e:	f44e                	sd	s3,40(sp)
    80002aa0:	f052                	sd	s4,32(sp)
    80002aa2:	ec56                	sd	s5,24(sp)
    80002aa4:	e85a                	sd	s6,16(sp)
    80002aa6:	e45e                	sd	s7,8(sp)
    80002aa8:	0880                	addi	s0,sp,80
    80002aaa:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002aac:	e08ff0ef          	jal	800020b4 <myproc>
    80002ab0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002ab2:	00011517          	auipc	a0,0x11
    80002ab6:	eae50513          	addi	a0,a0,-338 # 80013960 <wait_lock>
    80002aba:	96efe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    80002abe:	4a95                	li	s5,5
        havekids = 1;
    80002ac0:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002ac2:	000899b7          	lui	s3,0x89
    80002ac6:	1e898993          	addi	s3,s3,488 # 891e8 <_entry-0x7ff76e18>
    80002aca:	02259a17          	auipc	s4,0x2259
    80002ace:	caea0a13          	addi	s4,s4,-850 # 8225b778 <tickslock>
    80002ad2:	a879                	j	80002b70 <kwait+0xdc>
          pid = pp->pid;
    80002ad4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002ad8:	000b8c63          	beqz	s7,80002af0 <kwait+0x5c>
    80002adc:	4691                	li	a3,4
    80002ade:	02c48613          	addi	a2,s1,44
    80002ae2:	85de                	mv	a1,s7
    80002ae4:	05093503          	ld	a0,80(s2)
    80002ae8:	faffe0ef          	jal	80001a96 <copyout>
    80002aec:	02054a63          	bltz	a0,80002b20 <kwait+0x8c>
          freeproc(pp);
    80002af0:	8526                	mv	a0,s1
    80002af2:	f96ff0ef          	jal	80002288 <freeproc>
          release(&pp->lock);
    80002af6:	8526                	mv	a0,s1
    80002af8:	9c4fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    80002afc:	00011517          	auipc	a0,0x11
    80002b00:	e6450513          	addi	a0,a0,-412 # 80013960 <wait_lock>
    80002b04:	9b8fe0ef          	jal	80000cbc <release>
}
    80002b08:	854e                	mv	a0,s3
    80002b0a:	60a6                	ld	ra,72(sp)
    80002b0c:	6406                	ld	s0,64(sp)
    80002b0e:	74e2                	ld	s1,56(sp)
    80002b10:	7942                	ld	s2,48(sp)
    80002b12:	79a2                	ld	s3,40(sp)
    80002b14:	7a02                	ld	s4,32(sp)
    80002b16:	6ae2                	ld	s5,24(sp)
    80002b18:	6b42                	ld	s6,16(sp)
    80002b1a:	6ba2                	ld	s7,8(sp)
    80002b1c:	6161                	addi	sp,sp,80
    80002b1e:	8082                	ret
            release(&pp->lock);
    80002b20:	8526                	mv	a0,s1
    80002b22:	99afe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002b26:	00011517          	auipc	a0,0x11
    80002b2a:	e3a50513          	addi	a0,a0,-454 # 80013960 <wait_lock>
    80002b2e:	98efe0ef          	jal	80000cbc <release>
            return -1;
    80002b32:	59fd                	li	s3,-1
    80002b34:	bfd1                	j	80002b08 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002b36:	94ce                	add	s1,s1,s3
    80002b38:	03448063          	beq	s1,s4,80002b58 <kwait+0xc4>
      if(pp->parent == p){
    80002b3c:	7c9c                	ld	a5,56(s1)
    80002b3e:	ff279ce3          	bne	a5,s2,80002b36 <kwait+0xa2>
        acquire(&pp->lock);
    80002b42:	8526                	mv	a0,s1
    80002b44:	8e4fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    80002b48:	4c9c                	lw	a5,24(s1)
    80002b4a:	f95785e3          	beq	a5,s5,80002ad4 <kwait+0x40>
        release(&pp->lock);
    80002b4e:	8526                	mv	a0,s1
    80002b50:	96cfe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002b54:	875a                	mv	a4,s6
    80002b56:	b7c5                	j	80002b36 <kwait+0xa2>
    if(!havekids || killed(p)){
    80002b58:	c315                	beqz	a4,80002b7c <kwait+0xe8>
    80002b5a:	854a                	mv	a0,s2
    80002b5c:	f0fff0ef          	jal	80002a6a <killed>
    80002b60:	ed11                	bnez	a0,80002b7c <kwait+0xe8>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002b62:	00011597          	auipc	a1,0x11
    80002b66:	dfe58593          	addi	a1,a1,-514 # 80013960 <wait_lock>
    80002b6a:	854a                	mv	a0,s2
    80002b6c:	c67ff0ef          	jal	800027d2 <sleep>
    havekids = 0;
    80002b70:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002b72:	00011497          	auipc	s1,0x11
    80002b76:	20648493          	addi	s1,s1,518 # 80013d78 <proc>
    80002b7a:	b7c9                	j	80002b3c <kwait+0xa8>
      release(&wait_lock);
    80002b7c:	00011517          	auipc	a0,0x11
    80002b80:	de450513          	addi	a0,a0,-540 # 80013960 <wait_lock>
    80002b84:	938fe0ef          	jal	80000cbc <release>
      return -1;
    80002b88:	59fd                	li	s3,-1
    80002b8a:	bfbd                	j	80002b08 <kwait+0x74>

0000000080002b8c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002b8c:	7179                	addi	sp,sp,-48
    80002b8e:	f406                	sd	ra,40(sp)
    80002b90:	f022                	sd	s0,32(sp)
    80002b92:	ec26                	sd	s1,24(sp)
    80002b94:	e84a                	sd	s2,16(sp)
    80002b96:	e44e                	sd	s3,8(sp)
    80002b98:	e052                	sd	s4,0(sp)
    80002b9a:	1800                	addi	s0,sp,48
    80002b9c:	84aa                	mv	s1,a0
    80002b9e:	8a2e                	mv	s4,a1
    80002ba0:	89b2                	mv	s3,a2
    80002ba2:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002ba4:	d10ff0ef          	jal	800020b4 <myproc>
  if(user_dst){
    80002ba8:	cc99                	beqz	s1,80002bc6 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002baa:	86ca                	mv	a3,s2
    80002bac:	864e                	mv	a2,s3
    80002bae:	85d2                	mv	a1,s4
    80002bb0:	6928                	ld	a0,80(a0)
    80002bb2:	ee5fe0ef          	jal	80001a96 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002bb6:	70a2                	ld	ra,40(sp)
    80002bb8:	7402                	ld	s0,32(sp)
    80002bba:	64e2                	ld	s1,24(sp)
    80002bbc:	6942                	ld	s2,16(sp)
    80002bbe:	69a2                	ld	s3,8(sp)
    80002bc0:	6a02                	ld	s4,0(sp)
    80002bc2:	6145                	addi	sp,sp,48
    80002bc4:	8082                	ret
    memmove((char *)dst, src, len);
    80002bc6:	0009061b          	sext.w	a2,s2
    80002bca:	85ce                	mv	a1,s3
    80002bcc:	8552                	mv	a0,s4
    80002bce:	98afe0ef          	jal	80000d58 <memmove>
    return 0;
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	b7cd                	j	80002bb6 <either_copyout+0x2a>

0000000080002bd6 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002bd6:	7179                	addi	sp,sp,-48
    80002bd8:	f406                	sd	ra,40(sp)
    80002bda:	f022                	sd	s0,32(sp)
    80002bdc:	ec26                	sd	s1,24(sp)
    80002bde:	e84a                	sd	s2,16(sp)
    80002be0:	e44e                	sd	s3,8(sp)
    80002be2:	e052                	sd	s4,0(sp)
    80002be4:	1800                	addi	s0,sp,48
    80002be6:	8a2a                	mv	s4,a0
    80002be8:	84ae                	mv	s1,a1
    80002bea:	89b2                	mv	s3,a2
    80002bec:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002bee:	cc6ff0ef          	jal	800020b4 <myproc>
  if(user_src){
    80002bf2:	cc99                	beqz	s1,80002c10 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002bf4:	86ca                	mv	a3,s2
    80002bf6:	864e                	mv	a2,s3
    80002bf8:	85d2                	mv	a1,s4
    80002bfa:	6928                	ld	a0,80(a0)
    80002bfc:	856ff0ef          	jal	80001c52 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002c00:	70a2                	ld	ra,40(sp)
    80002c02:	7402                	ld	s0,32(sp)
    80002c04:	64e2                	ld	s1,24(sp)
    80002c06:	6942                	ld	s2,16(sp)
    80002c08:	69a2                	ld	s3,8(sp)
    80002c0a:	6a02                	ld	s4,0(sp)
    80002c0c:	6145                	addi	sp,sp,48
    80002c0e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002c10:	0009061b          	sext.w	a2,s2
    80002c14:	85ce                	mv	a1,s3
    80002c16:	8552                	mv	a0,s4
    80002c18:	940fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002c1c:	8526                	mv	a0,s1
    80002c1e:	b7cd                	j	80002c00 <either_copyin+0x2a>

0000000080002c20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002c20:	715d                	addi	sp,sp,-80
    80002c22:	e486                	sd	ra,72(sp)
    80002c24:	e0a2                	sd	s0,64(sp)
    80002c26:	fc26                	sd	s1,56(sp)
    80002c28:	f84a                	sd	s2,48(sp)
    80002c2a:	f44e                	sd	s3,40(sp)
    80002c2c:	f052                	sd	s4,32(sp)
    80002c2e:	ec56                	sd	s5,24(sp)
    80002c30:	e85a                	sd	s6,16(sp)
    80002c32:	e45e                	sd	s7,8(sp)
    80002c34:	e062                	sd	s8,0(sp)
    80002c36:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002c38:	00005517          	auipc	a0,0x5
    80002c3c:	50850513          	addi	a0,a0,1288 # 80008140 <etext+0x140>
    80002c40:	8bbfd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002c44:	00011497          	auipc	s1,0x11
    80002c48:	28c48493          	addi	s1,s1,652 # 80013ed0 <proc+0x158>
    80002c4c:	02259997          	auipc	s3,0x2259
    80002c50:	c8498993          	addi	s3,s3,-892 # 8225b8d0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c54:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    80002c56:	00006a17          	auipc	s4,0x6
    80002c5a:	832a0a13          	addi	s4,s4,-1998 # 80008488 <etext+0x488>
    printf("%d %s %s", p->pid, state, p->name);
    80002c5e:	00006b17          	auipc	s6,0x6
    80002c62:	832b0b13          	addi	s6,s6,-1998 # 80008490 <etext+0x490>
    printf("\n");
    80002c66:	00005a97          	auipc	s5,0x5
    80002c6a:	4daa8a93          	addi	s5,s5,1242 # 80008140 <etext+0x140>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c6e:	00006c17          	auipc	s8,0x6
    80002c72:	deac0c13          	addi	s8,s8,-534 # 80008a58 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002c76:	00089937          	lui	s2,0x89
    80002c7a:	1e890913          	addi	s2,s2,488 # 891e8 <_entry-0x7ff76e18>
    80002c7e:	a821                	j	80002c96 <procdump+0x76>
    printf("%d %s %s", p->pid, state, p->name);
    80002c80:	ed86a583          	lw	a1,-296(a3)
    80002c84:	855a                	mv	a0,s6
    80002c86:	875fd0ef          	jal	800004fa <printf>
    printf("\n");
    80002c8a:	8556                	mv	a0,s5
    80002c8c:	86ffd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002c90:	94ca                	add	s1,s1,s2
    80002c92:	03348263          	beq	s1,s3,80002cb6 <procdump+0x96>
    if(p->state == UNUSED)
    80002c96:	86a6                	mv	a3,s1
    80002c98:	ec04a783          	lw	a5,-320(s1)
    80002c9c:	dbf5                	beqz	a5,80002c90 <procdump+0x70>
      state = "???";
    80002c9e:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ca0:	fefbe0e3          	bltu	s7,a5,80002c80 <procdump+0x60>
    80002ca4:	02079713          	slli	a4,a5,0x20
    80002ca8:	01d75793          	srli	a5,a4,0x1d
    80002cac:	97e2                	add	a5,a5,s8
    80002cae:	6390                	ld	a2,0(a5)
    80002cb0:	fa61                	bnez	a2,80002c80 <procdump+0x60>
      state = "???";
    80002cb2:	8652                	mv	a2,s4
    80002cb4:	b7f1                	j	80002c80 <procdump+0x60>
  }
}
    80002cb6:	60a6                	ld	ra,72(sp)
    80002cb8:	6406                	ld	s0,64(sp)
    80002cba:	74e2                	ld	s1,56(sp)
    80002cbc:	7942                	ld	s2,48(sp)
    80002cbe:	79a2                	ld	s3,40(sp)
    80002cc0:	7a02                	ld	s4,32(sp)
    80002cc2:	6ae2                	ld	s5,24(sp)
    80002cc4:	6b42                	ld	s6,16(sp)
    80002cc6:	6ba2                	ld	s7,8(sp)
    80002cc8:	6c02                	ld	s8,0(sp)
    80002cca:	6161                	addi	sp,sp,80
    80002ccc:	8082                	ret

0000000080002cce <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002cce:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002cd2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002cd6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002cd8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002cda:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002cde:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002ce2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002ce6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002cea:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002cee:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002cf2:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002cf6:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002cfa:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002cfe:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002d02:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002d06:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002d0a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002d0c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002d0e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002d12:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002d16:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002d1a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002d1e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002d22:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002d26:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002d2a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002d2e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002d32:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002d36:	8082                	ret

0000000080002d38 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002d38:	1141                	addi	sp,sp,-16
    80002d3a:	e406                	sd	ra,8(sp)
    80002d3c:	e022                	sd	s0,0(sp)
    80002d3e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002d40:	00005597          	auipc	a1,0x5
    80002d44:	79058593          	addi	a1,a1,1936 # 800084d0 <etext+0x4d0>
    80002d48:	02259517          	auipc	a0,0x2259
    80002d4c:	a3050513          	addi	a0,a0,-1488 # 8225b778 <tickslock>
    80002d50:	e4ffd0ef          	jal	80000b9e <initlock>
}
    80002d54:	60a2                	ld	ra,8(sp)
    80002d56:	6402                	ld	s0,0(sp)
    80002d58:	0141                	addi	sp,sp,16
    80002d5a:	8082                	ret

0000000080002d5c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002d5c:	1141                	addi	sp,sp,-16
    80002d5e:	e406                	sd	ra,8(sp)
    80002d60:	e022                	sd	s0,0(sp)
    80002d62:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d64:	00003797          	auipc	a5,0x3
    80002d68:	46c78793          	addi	a5,a5,1132 # 800061d0 <kernelvec>
    80002d6c:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002d70:	60a2                	ld	ra,8(sp)
    80002d72:	6402                	ld	s0,0(sp)
    80002d74:	0141                	addi	sp,sp,16
    80002d76:	8082                	ret

0000000080002d78 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
    void
prepare_return(void)
{
    80002d78:	1141                	addi	sp,sp,-16
    80002d7a:	e406                	sd	ra,8(sp)
    80002d7c:	e022                	sd	s0,0(sp)
    80002d7e:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002d80:	b34ff0ef          	jal	800020b4 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002d88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d8a:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(). because a trap from kernel
    // code to usertrap would be a disaster, turn off interrupts.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002d8e:	04000737          	lui	a4,0x4000
    80002d92:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002d94:	0732                	slli	a4,a4,0xc
    80002d96:	00004797          	auipc	a5,0x4
    80002d9a:	26a78793          	addi	a5,a5,618 # 80007000 <_trampoline>
    80002d9e:	00004697          	auipc	a3,0x4
    80002da2:	26268693          	addi	a3,a3,610 # 80007000 <_trampoline>
    80002da6:	8f95                	sub	a5,a5,a3
    80002da8:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002daa:	10579073          	csrw	stvec,a5
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002dae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002db0:	18002773          	csrr	a4,satp
    80002db4:	e398                	sd	a4,0(a5)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002db6:	6d38                	ld	a4,88(a0)
    80002db8:	613c                	ld	a5,64(a0)
    80002dba:	6685                	lui	a3,0x1
    80002dbc:	97b6                	add	a5,a5,a3
    80002dbe:	e71c                	sd	a5,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002dc0:	6d3c                	ld	a5,88(a0)
    80002dc2:	00000717          	auipc	a4,0x0
    80002dc6:	0fc70713          	addi	a4,a4,252 # 80002ebe <usertrap>
    80002dca:	eb98                	sd	a4,16(a5)
    p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002dcc:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002dce:	8712                	mv	a4,tp
    80002dd0:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dd2:	100027f3          	csrr	a5,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002dd6:	eff7f793          	andi	a5,a5,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002dda:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dde:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002de2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002de4:	6f9c                	ld	a5,24(a5)
    80002de6:	14179073          	csrw	sepc,a5
}
    80002dea:	60a2                	ld	ra,8(sp)
    80002dec:	6402                	ld	s0,0(sp)
    80002dee:	0141                	addi	sp,sp,16
    80002df0:	8082                	ret

0000000080002df2 <clockintr>:
    w_sstatus(sstatus);
}

    void
clockintr()
{
    80002df2:	1141                	addi	sp,sp,-16
    80002df4:	e406                	sd	ra,8(sp)
    80002df6:	e022                	sd	s0,0(sp)
    80002df8:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    80002dfa:	a86ff0ef          	jal	80002080 <cpuid>
    80002dfe:	cd11                	beqz	a0,80002e1a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002e00:	c01027f3          	rdtime	a5
    }

    // ask for the next timer interrupt. this also clears
    // the interrupt request. 1000000 is about a tenth
    // of a second.
    w_stimecmp(r_time() + 1000000);
    80002e04:	000f4737          	lui	a4,0xf4
    80002e08:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002e0c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002e0e:	14d79073          	csrw	stimecmp,a5
}
    80002e12:	60a2                	ld	ra,8(sp)
    80002e14:	6402                	ld	s0,0(sp)
    80002e16:	0141                	addi	sp,sp,16
    80002e18:	8082                	ret
        acquire(&tickslock);
    80002e1a:	02259517          	auipc	a0,0x2259
    80002e1e:	95e50513          	addi	a0,a0,-1698 # 8225b778 <tickslock>
    80002e22:	e07fd0ef          	jal	80000c28 <acquire>
        ticks++;
    80002e26:	00009717          	auipc	a4,0x9
    80002e2a:	a2270713          	addi	a4,a4,-1502 # 8000b848 <ticks>
    80002e2e:	431c                	lw	a5,0(a4)
    80002e30:	2785                	addiw	a5,a5,1
    80002e32:	c31c                	sw	a5,0(a4)
        wakeup(&ticks);
    80002e34:	853a                	mv	a0,a4
    80002e36:	9e9ff0ef          	jal	8000281e <wakeup>
        release(&tickslock);
    80002e3a:	02259517          	auipc	a0,0x2259
    80002e3e:	93e50513          	addi	a0,a0,-1730 # 8225b778 <tickslock>
    80002e42:	e7bfd0ef          	jal	80000cbc <release>
    80002e46:	bf6d                	j	80002e00 <clockintr+0xe>

0000000080002e48 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
    int
devintr()
{
    80002e48:	1101                	addi	sp,sp,-32
    80002e4a:	ec06                	sd	ra,24(sp)
    80002e4c:	e822                	sd	s0,16(sp)
    80002e4e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e50:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if(scause == 0x8000000000000009L){
    80002e54:	57fd                	li	a5,-1
    80002e56:	17fe                	slli	a5,a5,0x3f
    80002e58:	07a5                	addi	a5,a5,9
    80002e5a:	00f70c63          	beq	a4,a5,80002e72 <devintr+0x2a>
        // now allowed to interrupt again.
        if(irq)
            plic_complete(irq);

        return 1;
    } else if(scause == 0x8000000000000005L){
    80002e5e:	57fd                	li	a5,-1
    80002e60:	17fe                	slli	a5,a5,0x3f
    80002e62:	0795                	addi	a5,a5,5
        // timer interrupt.
        clockintr();
        return 2;
    } else {
        return 0;
    80002e64:	4501                	li	a0,0
    } else if(scause == 0x8000000000000005L){
    80002e66:	04f70863          	beq	a4,a5,80002eb6 <devintr+0x6e>
    }
}
    80002e6a:	60e2                	ld	ra,24(sp)
    80002e6c:	6442                	ld	s0,16(sp)
    80002e6e:	6105                	addi	sp,sp,32
    80002e70:	8082                	ret
    80002e72:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002e74:	408030ef          	jal	8000627c <plic_claim>
    80002e78:	872a                	mv	a4,a0
    80002e7a:	84aa                	mv	s1,a0
        if(irq == UART0_IRQ){
    80002e7c:	47a9                	li	a5,10
    80002e7e:	00f50963          	beq	a0,a5,80002e90 <devintr+0x48>
        } else if(irq == VIRTIO0_IRQ){
    80002e82:	4785                	li	a5,1
    80002e84:	00f50963          	beq	a0,a5,80002e96 <devintr+0x4e>
        return 1;
    80002e88:	4505                	li	a0,1
        } else if(irq){
    80002e8a:	eb09                	bnez	a4,80002e9c <devintr+0x54>
    80002e8c:	64a2                	ld	s1,8(sp)
    80002e8e:	bff1                	j	80002e6a <devintr+0x22>
            uartintr();
    80002e90:	b65fd0ef          	jal	800009f4 <uartintr>
        if(irq)
    80002e94:	a819                	j	80002eaa <devintr+0x62>
            virtio_disk_intr();
    80002e96:	07d030ef          	jal	80006712 <virtio_disk_intr>
        if(irq)
    80002e9a:	a801                	j	80002eaa <devintr+0x62>
            printf("unexpected interrupt irq=%d\n", irq);
    80002e9c:	85ba                	mv	a1,a4
    80002e9e:	00005517          	auipc	a0,0x5
    80002ea2:	63a50513          	addi	a0,a0,1594 # 800084d8 <etext+0x4d8>
    80002ea6:	e54fd0ef          	jal	800004fa <printf>
            plic_complete(irq);
    80002eaa:	8526                	mv	a0,s1
    80002eac:	3f0030ef          	jal	8000629c <plic_complete>
        return 1;
    80002eb0:	4505                	li	a0,1
    80002eb2:	64a2                	ld	s1,8(sp)
    80002eb4:	bf5d                	j	80002e6a <devintr+0x22>
        clockintr();
    80002eb6:	f3dff0ef          	jal	80002df2 <clockintr>
        return 2;
    80002eba:	4509                	li	a0,2
    80002ebc:	b77d                	j	80002e6a <devintr+0x22>

0000000080002ebe <usertrap>:
{
    80002ebe:	7179                	addi	sp,sp,-48
    80002ec0:	f406                	sd	ra,40(sp)
    80002ec2:	f022                	sd	s0,32(sp)
    80002ec4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ec6:	100027f3          	csrr	a5,sstatus
    if((r_sstatus() & SSTATUS_SPP) != 0)
    80002eca:	1007f793          	andi	a5,a5,256
    80002ece:	e7c5                	bnez	a5,80002f76 <usertrap+0xb8>
    80002ed0:	ec26                	sd	s1,24(sp)
    80002ed2:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ed4:	00003797          	auipc	a5,0x3
    80002ed8:	2fc78793          	addi	a5,a5,764 # 800061d0 <kernelvec>
    80002edc:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002ee0:	9d4ff0ef          	jal	800020b4 <myproc>
    80002ee4:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002ee6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ee8:	14102773          	csrr	a4,sepc
    80002eec:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002eee:	14202773          	csrr	a4,scause
    if(r_scause() == 8){
    80002ef2:	47a1                	li	a5,8
    80002ef4:	08f70a63          	beq	a4,a5,80002f88 <usertrap+0xca>
    } else if((which_dev = devintr()) != 0){
    80002ef8:	f51ff0ef          	jal	80002e48 <devintr>
    80002efc:	892a                	mv	s2,a0
    80002efe:	18051063          	bnez	a0,8000307e <usertrap+0x1c0>
    80002f02:	14202773          	csrr	a4,scause
    }else if((r_scause() == 12 || r_scause() == 15 || r_scause() == 13)) { // Page fault occurred
    80002f06:	47b1                	li	a5,12
    80002f08:	00f70c63          	beq	a4,a5,80002f20 <usertrap+0x62>
    80002f0c:	14202773          	csrr	a4,scause
    80002f10:	47bd                	li	a5,15
    80002f12:	00f70763          	beq	a4,a5,80002f20 <usertrap+0x62>
    80002f16:	14202773          	csrr	a4,scause
    80002f1a:	47b5                	li	a5,13
    80002f1c:	12f71a63          	bne	a4,a5,80003050 <usertrap+0x192>
    80002f20:	e44e                	sd	s3,8(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f22:	143027f3          	csrr	a5,stval
    80002f26:	89be                	mv	s3,a5
        pte_t *pte = walk(p->pagetable, va, 0);
    80002f28:	4601                	li	a2,0
    80002f2a:	85be                	mv	a1,a5
    80002f2c:	68a8                	ld	a0,80(s1)
    80002f2e:	85efe0ef          	jal	80000f8c <walk>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f32:	142027f3          	csrr	a5,scause
        if(r_scause() == 15 && pte != 0 && (*pte & PTE_V) && !(*pte & PTE_W)) {
    80002f36:	c119                	beqz	a0,80002f3c <usertrap+0x7e>
    80002f38:	17c5                	addi	a5,a5,-15
    80002f3a:	cfc1                	beqz	a5,80002fd2 <usertrap+0x114>
    80002f3c:	14202773          	csrr	a4,scause
            if (r_scause() == 12) { access_type = "exec"; }
    80002f40:	47b1                	li	a5,12
    80002f42:	00005697          	auipc	a3,0x5
    80002f46:	3ce68693          	addi	a3,a3,974 # 80008310 <etext+0x310>
    80002f4a:	8936                	mv	s2,a3
    80002f4c:	00f70c63          	beq	a4,a5,80002f64 <usertrap+0xa6>
    80002f50:	14202773          	csrr	a4,scause
            else if (r_scause() == 13) { access_type = "read"; }
    80002f54:	47b5                	li	a5,13
            else { access_type = "write"; }
    80002f56:	00005697          	auipc	a3,0x5
    80002f5a:	46268693          	addi	a3,a3,1122 # 800083b8 <etext+0x3b8>
    80002f5e:	8936                	mv	s2,a3
            else if (r_scause() == 13) { access_type = "read"; }
    80002f60:	0cf70463          	beq	a4,a5,80003028 <usertrap+0x16a>
            if(handle_pgfault(p->pagetable, va, access_type) < 0) {
    80002f64:	864a                	mv	a2,s2
    80002f66:	85ce                	mv	a1,s3
    80002f68:	68a8                	ld	a0,80(s1)
    80002f6a:	b4efe0ef          	jal	800012b8 <handle_pgfault>
    80002f6e:	0c054363          	bltz	a0,80003034 <usertrap+0x176>
    80002f72:	69a2                	ld	s3,8(sp)
    80002f74:	a80d                	j	80002fa6 <usertrap+0xe8>
    80002f76:	ec26                	sd	s1,24(sp)
    80002f78:	e84a                	sd	s2,16(sp)
    80002f7a:	e44e                	sd	s3,8(sp)
        panic("usertrap: not from user mode");
    80002f7c:	00005517          	auipc	a0,0x5
    80002f80:	57c50513          	addi	a0,a0,1404 # 800084f8 <etext+0x4f8>
    80002f84:	8a1fd0ef          	jal	80000824 <panic>
        if(killed(p))
    80002f88:	ae3ff0ef          	jal	80002a6a <killed>
    80002f8c:	ed1d                	bnez	a0,80002fca <usertrap+0x10c>
        p->trapframe->epc += 4;
    80002f8e:	6cb8                	ld	a4,88(s1)
    80002f90:	6f1c                	ld	a5,24(a4)
    80002f92:	0791                	addi	a5,a5,4
    80002f94:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f96:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002f9a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f9e:	10079073          	csrw	sstatus,a5
        syscall();
    80002fa2:	2de000ef          	jal	80003280 <syscall>
    if(killed(p))
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	ac3ff0ef          	jal	80002a6a <killed>
    80002fac:	0c051e63          	bnez	a0,80003088 <usertrap+0x1ca>
    prepare_return();
    80002fb0:	dc9ff0ef          	jal	80002d78 <prepare_return>
    uint64 satp = MAKE_SATP(p->pagetable);
    80002fb4:	68a8                	ld	a0,80(s1)
    80002fb6:	8131                	srli	a0,a0,0xc
    80002fb8:	57fd                	li	a5,-1
    80002fba:	17fe                	slli	a5,a5,0x3f
    80002fbc:	8d5d                	or	a0,a0,a5
}
    80002fbe:	64e2                	ld	s1,24(sp)
    80002fc0:	6942                	ld	s2,16(sp)
    80002fc2:	70a2                	ld	ra,40(sp)
    80002fc4:	7402                	ld	s0,32(sp)
    80002fc6:	6145                	addi	sp,sp,48
    80002fc8:	8082                	ret
            kexit(-1);
    80002fca:	557d                	li	a0,-1
    80002fcc:	927ff0ef          	jal	800028f2 <kexit>
    80002fd0:	bf7d                	j	80002f8e <usertrap+0xd0>
        if(r_scause() == 15 && pte != 0 && (*pte & PTE_V) && !(*pte & PTE_W)) {
    80002fd2:	611c                	ld	a5,0(a0)
    80002fd4:	0057f693          	andi	a3,a5,5
    80002fd8:	4705                	li	a4,1
    80002fda:	f6e691e3          	bne	a3,a4,80002f3c <usertrap+0x7e>
            *pte |= PTE_W;
    80002fde:	0047e793          	ori	a5,a5,4
    80002fe2:	e11c                	sd	a5,0(a0)
            for(int i = 0; i < p->num_resident; i++) {
    80002fe4:	000897b7          	lui	a5,0x89
    80002fe8:	97a6                	add	a5,a5,s1
    80002fea:	1b07a583          	lw	a1,432(a5) # 891b0 <_entry-0x7ff76e50>
    80002fee:	0ab05963          	blez	a1,800030a0 <usertrap+0x1e2>
    80002ff2:	27048713          	addi	a4,s1,624
    80002ff6:	87ca                	mv	a5,s2
                if(p->resident_pages[i].va == PGROUNDDOWN(va)) {
    80002ff8:	767d                	lui	a2,0xfffff
    80002ffa:	00c9f633          	and	a2,s3,a2
    80002ffe:	6314                	ld	a3,0(a4)
    80003000:	00c68c63          	beq	a3,a2,80003018 <usertrap+0x15a>
            for(int i = 0; i < p->num_resident; i++) {
    80003004:	2785                	addiw	a5,a5,1
    80003006:	0741                	addi	a4,a4,16
    80003008:	feb79be3          	bne	a5,a1,80002ffe <usertrap+0x140>
    if(killed(p))
    8000300c:	8526                	mv	a0,s1
    8000300e:	a5dff0ef          	jal	80002a6a <killed>
    80003012:	e549                	bnez	a0,8000309c <usertrap+0x1de>
    80003014:	69a2                	ld	s3,8(sp)
    80003016:	bf69                	j	80002fb0 <usertrap+0xf2>
                    p->resident_pages[i].dirty = 1;
    80003018:	0792                	slli	a5,a5,0x4
    8000301a:	27078793          	addi	a5,a5,624
    8000301e:	97a6                	add	a5,a5,s1
    80003020:	4705                	li	a4,1
    80003022:	c7d8                	sw	a4,12(a5)
                    break;
    80003024:	69a2                	ld	s3,8(sp)
    80003026:	b741                	j	80002fa6 <usertrap+0xe8>
            else if (r_scause() == 13) { access_type = "read"; }
    80003028:	00005797          	auipc	a5,0x5
    8000302c:	76878793          	addi	a5,a5,1896 # 80008790 <etext+0x790>
    80003030:	893e                	mv	s2,a5
    80003032:	bf0d                	j	80002f64 <usertrap+0xa6>
                printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, va, access_type);
    80003034:	86ca                	mv	a3,s2
    80003036:	864e                	mv	a2,s3
    80003038:	588c                	lw	a1,48(s1)
    8000303a:	00005517          	auipc	a0,0x5
    8000303e:	4de50513          	addi	a0,a0,1246 # 80008518 <etext+0x518>
    80003042:	cb8fd0ef          	jal	800004fa <printf>
                setkilled(p);
    80003046:	8526                	mv	a0,s1
    80003048:	9ffff0ef          	jal	80002a46 <setkilled>
    8000304c:	69a2                	ld	s3,8(sp)
    8000304e:	bfa1                	j	80002fa6 <usertrap+0xe8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003050:	142025f3          	csrr	a1,scause
            printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80003054:	5890                	lw	a2,48(s1)
    80003056:	00005517          	auipc	a0,0x5
    8000305a:	4fa50513          	addi	a0,a0,1274 # 80008550 <etext+0x550>
    8000305e:	c9cfd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003062:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003066:	14302673          	csrr	a2,stval
            printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000306a:	00005517          	auipc	a0,0x5
    8000306e:	51650513          	addi	a0,a0,1302 # 80008580 <etext+0x580>
    80003072:	c88fd0ef          	jal	800004fa <printf>
            setkilled(p);
    80003076:	8526                	mv	a0,s1
    80003078:	9cfff0ef          	jal	80002a46 <setkilled>
    8000307c:	b72d                	j	80002fa6 <usertrap+0xe8>
    if(killed(p))
    8000307e:	8526                	mv	a0,s1
    80003080:	9ebff0ef          	jal	80002a6a <killed>
    80003084:	c511                	beqz	a0,80003090 <usertrap+0x1d2>
    80003086:	a011                	j	8000308a <usertrap+0x1cc>
    80003088:	4901                	li	s2,0
        kexit(-1);
    8000308a:	557d                	li	a0,-1
    8000308c:	867ff0ef          	jal	800028f2 <kexit>
    if(which_dev == 2)
    80003090:	4789                	li	a5,2
    80003092:	f0f91fe3          	bne	s2,a5,80002fb0 <usertrap+0xf2>
        yield();
    80003096:	f10ff0ef          	jal	800027a6 <yield>
    8000309a:	bf19                	j	80002fb0 <usertrap+0xf2>
    8000309c:	69a2                	ld	s3,8(sp)
    8000309e:	b7f5                	j	8000308a <usertrap+0x1cc>
    800030a0:	69a2                	ld	s3,8(sp)
    800030a2:	b711                	j	80002fa6 <usertrap+0xe8>

00000000800030a4 <kerneltrap>:
{
    800030a4:	7179                	addi	sp,sp,-48
    800030a6:	f406                	sd	ra,40(sp)
    800030a8:	f022                	sd	s0,32(sp)
    800030aa:	ec26                	sd	s1,24(sp)
    800030ac:	e84a                	sd	s2,16(sp)
    800030ae:	e44e                	sd	s3,8(sp)
    800030b0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030b2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030b6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030ba:	142027f3          	csrr	a5,scause
    800030be:	89be                	mv	s3,a5
    if((sstatus & SSTATUS_SPP) == 0)
    800030c0:	1004f793          	andi	a5,s1,256
    800030c4:	c795                	beqz	a5,800030f0 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800030c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800030ca:	8b89                	andi	a5,a5,2
    if(intr_get() != 0)
    800030cc:	eb85                	bnez	a5,800030fc <kerneltrap+0x58>
    if((which_dev = devintr()) == 0){
    800030ce:	d7bff0ef          	jal	80002e48 <devintr>
    800030d2:	c91d                	beqz	a0,80003108 <kerneltrap+0x64>
    if(which_dev == 2 && myproc() != 0)
    800030d4:	4789                	li	a5,2
    800030d6:	04f50a63          	beq	a0,a5,8000312a <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800030da:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030de:	10049073          	csrw	sstatus,s1
}
    800030e2:	70a2                	ld	ra,40(sp)
    800030e4:	7402                	ld	s0,32(sp)
    800030e6:	64e2                	ld	s1,24(sp)
    800030e8:	6942                	ld	s2,16(sp)
    800030ea:	69a2                	ld	s3,8(sp)
    800030ec:	6145                	addi	sp,sp,48
    800030ee:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    800030f0:	00005517          	auipc	a0,0x5
    800030f4:	4b850513          	addi	a0,a0,1208 # 800085a8 <etext+0x5a8>
    800030f8:	f2cfd0ef          	jal	80000824 <panic>
        panic("kerneltrap: interrupts enabled");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	4d450513          	addi	a0,a0,1236 # 800085d0 <etext+0x5d0>
    80003104:	f20fd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003108:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000310c:	143026f3          	csrr	a3,stval
        printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80003110:	85ce                	mv	a1,s3
    80003112:	00005517          	auipc	a0,0x5
    80003116:	4de50513          	addi	a0,a0,1246 # 800085f0 <etext+0x5f0>
    8000311a:	be0fd0ef          	jal	800004fa <printf>
        panic("kerneltrap");
    8000311e:	00005517          	auipc	a0,0x5
    80003122:	4fa50513          	addi	a0,a0,1274 # 80008618 <etext+0x618>
    80003126:	efefd0ef          	jal	80000824 <panic>
    if(which_dev == 2 && myproc() != 0)
    8000312a:	f8bfe0ef          	jal	800020b4 <myproc>
    8000312e:	d555                	beqz	a0,800030da <kerneltrap+0x36>
        yield();
    80003130:	e76ff0ef          	jal	800027a6 <yield>
    80003134:	b75d                	j	800030da <kerneltrap+0x36>

0000000080003136 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003136:	1101                	addi	sp,sp,-32
    80003138:	ec06                	sd	ra,24(sp)
    8000313a:	e822                	sd	s0,16(sp)
    8000313c:	e426                	sd	s1,8(sp)
    8000313e:	1000                	addi	s0,sp,32
    80003140:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003142:	f73fe0ef          	jal	800020b4 <myproc>
  switch (n) {
    80003146:	4795                	li	a5,5
    80003148:	0497e163          	bltu	a5,s1,8000318a <argraw+0x54>
    8000314c:	048a                	slli	s1,s1,0x2
    8000314e:	00006717          	auipc	a4,0x6
    80003152:	93a70713          	addi	a4,a4,-1734 # 80008a88 <states.0+0x30>
    80003156:	94ba                	add	s1,s1,a4
    80003158:	409c                	lw	a5,0(s1)
    8000315a:	97ba                	add	a5,a5,a4
    8000315c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000315e:	6d3c                	ld	a5,88(a0)
    80003160:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003162:	60e2                	ld	ra,24(sp)
    80003164:	6442                	ld	s0,16(sp)
    80003166:	64a2                	ld	s1,8(sp)
    80003168:	6105                	addi	sp,sp,32
    8000316a:	8082                	ret
    return p->trapframe->a1;
    8000316c:	6d3c                	ld	a5,88(a0)
    8000316e:	7fa8                	ld	a0,120(a5)
    80003170:	bfcd                	j	80003162 <argraw+0x2c>
    return p->trapframe->a2;
    80003172:	6d3c                	ld	a5,88(a0)
    80003174:	63c8                	ld	a0,128(a5)
    80003176:	b7f5                	j	80003162 <argraw+0x2c>
    return p->trapframe->a3;
    80003178:	6d3c                	ld	a5,88(a0)
    8000317a:	67c8                	ld	a0,136(a5)
    8000317c:	b7dd                	j	80003162 <argraw+0x2c>
    return p->trapframe->a4;
    8000317e:	6d3c                	ld	a5,88(a0)
    80003180:	6bc8                	ld	a0,144(a5)
    80003182:	b7c5                	j	80003162 <argraw+0x2c>
    return p->trapframe->a5;
    80003184:	6d3c                	ld	a5,88(a0)
    80003186:	6fc8                	ld	a0,152(a5)
    80003188:	bfe9                	j	80003162 <argraw+0x2c>
  panic("argraw");
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	49e50513          	addi	a0,a0,1182 # 80008628 <etext+0x628>
    80003192:	e92fd0ef          	jal	80000824 <panic>

0000000080003196 <fetchaddr>:
{
    80003196:	1101                	addi	sp,sp,-32
    80003198:	ec06                	sd	ra,24(sp)
    8000319a:	e822                	sd	s0,16(sp)
    8000319c:	e426                	sd	s1,8(sp)
    8000319e:	e04a                	sd	s2,0(sp)
    800031a0:	1000                	addi	s0,sp,32
    800031a2:	84aa                	mv	s1,a0
    800031a4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800031a6:	f0ffe0ef          	jal	800020b4 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800031aa:	653c                	ld	a5,72(a0)
    800031ac:	02f4f663          	bgeu	s1,a5,800031d8 <fetchaddr+0x42>
    800031b0:	00848713          	addi	a4,s1,8
    800031b4:	02e7e463          	bltu	a5,a4,800031dc <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800031b8:	46a1                	li	a3,8
    800031ba:	8626                	mv	a2,s1
    800031bc:	85ca                	mv	a1,s2
    800031be:	6928                	ld	a0,80(a0)
    800031c0:	a93fe0ef          	jal	80001c52 <copyin>
    800031c4:	00a03533          	snez	a0,a0
    800031c8:	40a0053b          	negw	a0,a0
}
    800031cc:	60e2                	ld	ra,24(sp)
    800031ce:	6442                	ld	s0,16(sp)
    800031d0:	64a2                	ld	s1,8(sp)
    800031d2:	6902                	ld	s2,0(sp)
    800031d4:	6105                	addi	sp,sp,32
    800031d6:	8082                	ret
    return -1;
    800031d8:	557d                	li	a0,-1
    800031da:	bfcd                	j	800031cc <fetchaddr+0x36>
    800031dc:	557d                	li	a0,-1
    800031de:	b7fd                	j	800031cc <fetchaddr+0x36>

00000000800031e0 <fetchstr>:
{
    800031e0:	7179                	addi	sp,sp,-48
    800031e2:	f406                	sd	ra,40(sp)
    800031e4:	f022                	sd	s0,32(sp)
    800031e6:	ec26                	sd	s1,24(sp)
    800031e8:	e84a                	sd	s2,16(sp)
    800031ea:	e44e                	sd	s3,8(sp)
    800031ec:	1800                	addi	s0,sp,48
    800031ee:	89aa                	mv	s3,a0
    800031f0:	84ae                	mv	s1,a1
    800031f2:	8932                	mv	s2,a2
  struct proc *p = myproc();
    800031f4:	ec1fe0ef          	jal	800020b4 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800031f8:	86ca                	mv	a3,s2
    800031fa:	864e                	mv	a2,s3
    800031fc:	85a6                	mv	a1,s1
    800031fe:	6928                	ld	a0,80(a0)
    80003200:	bb9fe0ef          	jal	80001db8 <copyinstr>
    80003204:	00054c63          	bltz	a0,8000321c <fetchstr+0x3c>
  return strlen(buf);
    80003208:	8526                	mv	a0,s1
    8000320a:	c79fd0ef          	jal	80000e82 <strlen>
}
    8000320e:	70a2                	ld	ra,40(sp)
    80003210:	7402                	ld	s0,32(sp)
    80003212:	64e2                	ld	s1,24(sp)
    80003214:	6942                	ld	s2,16(sp)
    80003216:	69a2                	ld	s3,8(sp)
    80003218:	6145                	addi	sp,sp,48
    8000321a:	8082                	ret
    return -1;
    8000321c:	557d                	li	a0,-1
    8000321e:	bfc5                	j	8000320e <fetchstr+0x2e>

0000000080003220 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003220:	1101                	addi	sp,sp,-32
    80003222:	ec06                	sd	ra,24(sp)
    80003224:	e822                	sd	s0,16(sp)
    80003226:	e426                	sd	s1,8(sp)
    80003228:	1000                	addi	s0,sp,32
    8000322a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000322c:	f0bff0ef          	jal	80003136 <argraw>
    80003230:	c088                	sw	a0,0(s1)
}
    80003232:	60e2                	ld	ra,24(sp)
    80003234:	6442                	ld	s0,16(sp)
    80003236:	64a2                	ld	s1,8(sp)
    80003238:	6105                	addi	sp,sp,32
    8000323a:	8082                	ret

000000008000323c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000323c:	1101                	addi	sp,sp,-32
    8000323e:	ec06                	sd	ra,24(sp)
    80003240:	e822                	sd	s0,16(sp)
    80003242:	e426                	sd	s1,8(sp)
    80003244:	1000                	addi	s0,sp,32
    80003246:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003248:	eefff0ef          	jal	80003136 <argraw>
    8000324c:	e088                	sd	a0,0(s1)
}
    8000324e:	60e2                	ld	ra,24(sp)
    80003250:	6442                	ld	s0,16(sp)
    80003252:	64a2                	ld	s1,8(sp)
    80003254:	6105                	addi	sp,sp,32
    80003256:	8082                	ret

0000000080003258 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003258:	1101                	addi	sp,sp,-32
    8000325a:	ec06                	sd	ra,24(sp)
    8000325c:	e822                	sd	s0,16(sp)
    8000325e:	e426                	sd	s1,8(sp)
    80003260:	e04a                	sd	s2,0(sp)
    80003262:	1000                	addi	s0,sp,32
    80003264:	892e                	mv	s2,a1
    80003266:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80003268:	ecfff0ef          	jal	80003136 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    8000326c:	8626                	mv	a2,s1
    8000326e:	85ca                	mv	a1,s2
    80003270:	f71ff0ef          	jal	800031e0 <fetchstr>
}
    80003274:	60e2                	ld	ra,24(sp)
    80003276:	6442                	ld	s0,16(sp)
    80003278:	64a2                	ld	s1,8(sp)
    8000327a:	6902                	ld	s2,0(sp)
    8000327c:	6105                	addi	sp,sp,32
    8000327e:	8082                	ret

0000000080003280 <syscall>:
[SYS_memstat] sys_memstat,
};

void
syscall(void)
{
    80003280:	1101                	addi	sp,sp,-32
    80003282:	ec06                	sd	ra,24(sp)
    80003284:	e822                	sd	s0,16(sp)
    80003286:	e426                	sd	s1,8(sp)
    80003288:	e04a                	sd	s2,0(sp)
    8000328a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000328c:	e29fe0ef          	jal	800020b4 <myproc>
    80003290:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80003292:	05853903          	ld	s2,88(a0)
    80003296:	0a893783          	ld	a5,168(s2)
    8000329a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000329e:	37fd                	addiw	a5,a5,-1
    800032a0:	4755                	li	a4,21
    800032a2:	00f76f63          	bltu	a4,a5,800032c0 <syscall+0x40>
    800032a6:	00369713          	slli	a4,a3,0x3
    800032aa:	00005797          	auipc	a5,0x5
    800032ae:	7f678793          	addi	a5,a5,2038 # 80008aa0 <syscalls>
    800032b2:	97ba                	add	a5,a5,a4
    800032b4:	639c                	ld	a5,0(a5)
    800032b6:	c789                	beqz	a5,800032c0 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800032b8:	9782                	jalr	a5
    800032ba:	06a93823          	sd	a0,112(s2)
    800032be:	a829                	j	800032d8 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800032c0:	15848613          	addi	a2,s1,344
    800032c4:	588c                	lw	a1,48(s1)
    800032c6:	00005517          	auipc	a0,0x5
    800032ca:	36a50513          	addi	a0,a0,874 # 80008630 <etext+0x630>
    800032ce:	a2cfd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800032d2:	6cbc                	ld	a5,88(s1)
    800032d4:	577d                	li	a4,-1
    800032d6:	fbb8                	sd	a4,112(a5)
  }
}
    800032d8:	60e2                	ld	ra,24(sp)
    800032da:	6442                	ld	s0,16(sp)
    800032dc:	64a2                	ld	s1,8(sp)
    800032de:	6902                	ld	s2,0(sp)
    800032e0:	6105                	addi	sp,sp,32
    800032e2:	8082                	ret

00000000800032e4 <sys_memstat>:
// In kernel/sysproc.c (add at the end of the file)


uint64
sys_memstat(void)
{
    800032e4:	81010113          	addi	sp,sp,-2032
    800032e8:	7e113423          	sd	ra,2024(sp)
    800032ec:	7e813023          	sd	s0,2016(sp)
    800032f0:	7c913c23          	sd	s1,2008(sp)
    800032f4:	7f010413          	addi	s0,sp,2032
    800032f8:	db010113          	addi	sp,sp,-592
  uint64 info_ptr;
  struct proc *p = myproc();
    800032fc:	db9fe0ef          	jal	800020b4 <myproc>
    80003300:	84aa                	mv	s1,a0
  struct proc_mem_stat k_info; // Kernel-space copy of the struct

  argaddr(0, &info_ptr);
    80003302:	fd840593          	addi	a1,s0,-40
    80003306:	4501                	li	a0,0
    80003308:	f35ff0ef          	jal	8000323c <argaddr>

  // 1. Fill in the basic process-wide statistics.
  k_info.pid = p->pid;
    8000330c:	80040793          	addi	a5,s0,-2048
    80003310:	1781                	addi	a5,a5,-32
    80003312:	5898                	lw	a4,48(s1)
    80003314:	dee7a023          	sw	a4,-544(a5)
  k_info.num_resident_pages = p->num_resident;
    80003318:	00089737          	lui	a4,0x89
    8000331c:	9726                	add	a4,a4,s1
    8000331e:	1b072503          	lw	a0,432(a4) # 891b0 <_entry-0x7ff76e50>
    80003322:	dea7a423          	sw	a0,-536(a5)
  k_info.num_swapped_pages = p->num_swappped_pages;
    80003326:	1cc72883          	lw	a7,460(a4)
    8000332a:	df17a623          	sw	a7,-532(a5)
  k_info.next_fifo_seq = p->next_fifo_seq;
    8000332e:	1c872703          	lw	a4,456(a4)
    80003332:	dee7a823          	sw	a4,-528(a5)
  k_info.num_pages_total = p->sz / PGSIZE;
    80003336:	64b8                	ld	a4,72(s1)
    80003338:	00c75693          	srli	a3,a4,0xc
    8000333c:	ded7a223          	sw	a3,-540(a5)

  // 2. Iterate through the process's virtual pages to get per-page stats.
  int page_count = 0;
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    80003340:	c75d                	beqz	a4,800033ee <sys_memstat+0x10a>
    80003342:	80040613          	addi	a2,s0,-2048
    80003346:	1601                	addi	a2,a2,-32 # ffffffffffffefe0 <end+0xffffffff7dd98488>
    80003348:	df460613          	addi	a2,a2,-524
    8000334c:	4681                	li	a3,0
  int page_count = 0;
    8000334e:	4e01                	li	t3,0
    k_info.pages[page_count].va = va;
    k_info.pages[page_count].state = UNMAPPED;
    k_info.pages[page_count].is_dirty = 0;
    k_info.pages[page_count].seq = -1;
    80003350:	537d                	li	t1,-1
    80003352:	00089fb7          	lui	t6,0x89
    80003356:	df0f8f93          	addi	t6,t6,-528 # 88df0 <_entry-0x7ff77210>
    if (is_res) continue;

    // Is the page swapped?
    for (int i = 0; i < p->num_swappped_pages; i++) {
      if (p->swapped_pages[i].va == va) {
        k_info.pages[page_count].state = SWAPPED;
    8000335a:	4389                	li	t2,2
        k_info.pages[page_count].swap_slot = p->swapped_pages[i].slot;
    8000335c:	62a5                	lui	t0,0x9
    8000335e:	8df28293          	addi	t0,t0,-1825 # 88df <_entry-0x7fff7721>
        k_info.pages[page_count].state = RESIDENT;
    80003362:	4f05                	li	t5,1
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    80003364:	6e85                	lui	t4,0x1
    80003366:	a805                	j	80003396 <sys_memstat+0xb2>
        k_info.pages[page_count].state = RESIDENT;
    80003368:	01e82223          	sw	t5,4(a6)
        k_info.pages[page_count].is_dirty = p->resident_pages[i].dirty;
    8000336c:	0792                	slli	a5,a5,0x4
    8000336e:	97a6                	add	a5,a5,s1
    80003370:	27c7a703          	lw	a4,636(a5)
    80003374:	00e82423          	sw	a4,8(a6)
        k_info.pages[page_count].seq = p->resident_pages[i].seq;
    80003378:	2787a783          	lw	a5,632(a5)
    8000337c:	00f82623          	sw	a5,12(a6)
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    80003380:	96f6                	add	a3,a3,t4
    80003382:	001e079b          	addiw	a5,t3,1
    80003386:	8e3e                	mv	t3,a5
    80003388:	0651                	addi	a2,a2,20
    8000338a:	64b8                	ld	a4,72(s1)
    8000338c:	06e6f163          	bgeu	a3,a4,800033ee <sys_memstat+0x10a>
    80003390:	0807a793          	slti	a5,a5,128
    80003394:	cfa9                	beqz	a5,800033ee <sys_memstat+0x10a>
    k_info.pages[page_count].va = va;
    80003396:	8832                	mv	a6,a2
    80003398:	c214                	sw	a3,0(a2)
    k_info.pages[page_count].state = UNMAPPED;
    8000339a:	00062223          	sw	zero,4(a2)
    k_info.pages[page_count].is_dirty = 0;
    8000339e:	00062423          	sw	zero,8(a2)
    k_info.pages[page_count].seq = -1;
    800033a2:	00662623          	sw	t1,12(a2)
    k_info.pages[page_count].swap_slot = -1;
    800033a6:	00662823          	sw	t1,16(a2)
    for (int i = 0; i < p->num_resident; i++) {
    800033aa:	00a05c63          	blez	a0,800033c2 <sys_memstat+0xde>
    800033ae:	27048713          	addi	a4,s1,624
    800033b2:	4781                	li	a5,0
      if (p->resident_pages[i].va == va) {
    800033b4:	630c                	ld	a1,0(a4)
    800033b6:	fad589e3          	beq	a1,a3,80003368 <sys_memstat+0x84>
    for (int i = 0; i < p->num_resident; i++) {
    800033ba:	2785                	addiw	a5,a5,1
    800033bc:	0741                	addi	a4,a4,16
    800033be:	fef51be3          	bne	a0,a5,800033b4 <sys_memstat+0xd0>
    for (int i = 0; i < p->num_swappped_pages; i++) {
    800033c2:	fb105fe3          	blez	a7,80003380 <sys_memstat+0x9c>
    800033c6:	01f48733          	add	a4,s1,t6
    800033ca:	4781                	li	a5,0
      if (p->swapped_pages[i].va == va) {
    800033cc:	630c                	ld	a1,0(a4)
    800033ce:	00d58763          	beq	a1,a3,800033dc <sys_memstat+0xf8>
    for (int i = 0; i < p->num_swappped_pages; i++) {
    800033d2:	2785                	addiw	a5,a5,1
    800033d4:	0741                	addi	a4,a4,16
    800033d6:	fef89be3          	bne	a7,a5,800033cc <sys_memstat+0xe8>
    800033da:	b75d                	j	80003380 <sys_memstat+0x9c>
        k_info.pages[page_count].state = SWAPPED;
    800033dc:	00782223          	sw	t2,4(a6)
        k_info.pages[page_count].swap_slot = p->swapped_pages[i].slot;
    800033e0:	9796                	add	a5,a5,t0
    800033e2:	0792                	slli	a5,a5,0x4
    800033e4:	97a6                	add	a5,a5,s1
    800033e6:	479c                	lw	a5,8(a5)
    800033e8:	00f82823          	sw	a5,16(a6)
        break;
    800033ec:	bf51                	j	80003380 <sys_memstat+0x9c>
      }
    }
  }

  // 3. Copy the completed structure to the user-provided pointer.
  if (copyout(p->pagetable, info_ptr, (char *)&k_info, sizeof(k_info)) < 0)
    800033ee:	6685                	lui	a3,0x1
    800033f0:	a1468693          	addi	a3,a3,-1516 # a14 <_entry-0x7ffff5ec>
    800033f4:	80040613          	addi	a2,s0,-2048
    800033f8:	1601                	addi	a2,a2,-32
    800033fa:	de060613          	addi	a2,a2,-544
    800033fe:	fd843583          	ld	a1,-40(s0)
    80003402:	68a8                	ld	a0,80(s1)
    80003404:	e92fe0ef          	jal	80001a96 <copyout>
    return -1;

  return 0;
}
    80003408:	957d                	srai	a0,a0,0x3f
    8000340a:	25010113          	addi	sp,sp,592
    8000340e:	7e813083          	ld	ra,2024(sp)
    80003412:	7e013403          	ld	s0,2016(sp)
    80003416:	7d813483          	ld	s1,2008(sp)
    8000341a:	7f010113          	addi	sp,sp,2032
    8000341e:	8082                	ret

0000000080003420 <sys_exit>:
uint64
sys_exit(void)
{
    80003420:	1101                	addi	sp,sp,-32
    80003422:	ec06                	sd	ra,24(sp)
    80003424:	e822                	sd	s0,16(sp)
    80003426:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003428:	fec40593          	addi	a1,s0,-20
    8000342c:	4501                	li	a0,0
    8000342e:	df3ff0ef          	jal	80003220 <argint>
  kexit(n);
    80003432:	fec42503          	lw	a0,-20(s0)
    80003436:	cbcff0ef          	jal	800028f2 <kexit>
  return 0;  // not reached
}
    8000343a:	4501                	li	a0,0
    8000343c:	60e2                	ld	ra,24(sp)
    8000343e:	6442                	ld	s0,16(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003444:	1141                	addi	sp,sp,-16
    80003446:	e406                	sd	ra,8(sp)
    80003448:	e022                	sd	s0,0(sp)
    8000344a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000344c:	c69fe0ef          	jal	800020b4 <myproc>
}
    80003450:	5908                	lw	a0,48(a0)
    80003452:	60a2                	ld	ra,8(sp)
    80003454:	6402                	ld	s0,0(sp)
    80003456:	0141                	addi	sp,sp,16
    80003458:	8082                	ret

000000008000345a <sys_fork>:

uint64
sys_fork(void)
{
    8000345a:	1141                	addi	sp,sp,-16
    8000345c:	e406                	sd	ra,8(sp)
    8000345e:	e022                	sd	s0,0(sp)
    80003460:	0800                	addi	s0,sp,16
  return kfork();
    80003462:	80aff0ef          	jal	8000246c <kfork>
}
    80003466:	60a2                	ld	ra,8(sp)
    80003468:	6402                	ld	s0,0(sp)
    8000346a:	0141                	addi	sp,sp,16
    8000346c:	8082                	ret

000000008000346e <sys_wait>:

uint64
sys_wait(void)
{
    8000346e:	1101                	addi	sp,sp,-32
    80003470:	ec06                	sd	ra,24(sp)
    80003472:	e822                	sd	s0,16(sp)
    80003474:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003476:	fe840593          	addi	a1,s0,-24
    8000347a:	4501                	li	a0,0
    8000347c:	dc1ff0ef          	jal	8000323c <argaddr>
  return kwait(p);
    80003480:	fe843503          	ld	a0,-24(s0)
    80003484:	e10ff0ef          	jal	80002a94 <kwait>
}
    80003488:	60e2                	ld	ra,24(sp)
    8000348a:	6442                	ld	s0,16(sp)
    8000348c:	6105                	addi	sp,sp,32
    8000348e:	8082                	ret

0000000080003490 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003490:	715d                	addi	sp,sp,-80
    80003492:	e486                	sd	ra,72(sp)
    80003494:	e0a2                	sd	s0,64(sp)
    80003496:	fc26                	sd	s1,56(sp)
    80003498:	0880                	addi	s0,sp,80
  uint64 addr;
  int n;

  argint(0, &n);
    8000349a:	fbc40593          	addi	a1,s0,-68
    8000349e:	4501                	li	a0,0
    800034a0:	d81ff0ef          	jal	80003220 <argint>
  addr = myproc()->sz;
    800034a4:	c11fe0ef          	jal	800020b4 <myproc>
    800034a8:	6524                	ld	s1,72(a0)

  if (n > 0) {
    800034aa:	fbc42783          	lw	a5,-68(s0)
    800034ae:	02f05363          	blez	a5,800034d4 <sys_sbrk+0x44>
    if(addr + n < addr || addr + n > TRAPFRAME) // Check for overflow or exceeding max address
    800034b2:	97a6                	add	a5,a5,s1
    800034b4:	02000737          	lui	a4,0x2000
    800034b8:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    800034ba:	0736                	slli	a4,a4,0xd
    800034bc:	06f76663          	bltu	a4,a5,80003528 <sys_sbrk+0x98>
    800034c0:	0697e463          	bltu	a5,s1,80003528 <sys_sbrk+0x98>
      return -1;
    myproc()->sz += n;
    800034c4:	bf1fe0ef          	jal	800020b4 <myproc>
    800034c8:	fbc42703          	lw	a4,-68(s0)
    800034cc:	653c                	ld	a5,72(a0)
    800034ce:	97ba                	add	a5,a5,a4
    800034d0:	e53c                	sd	a5,72(a0)
    800034d2:	a019                	j	800034d8 <sys_sbrk+0x48>
  } else if (n < 0) {
    800034d4:	0007c863          	bltz	a5,800034e4 <sys_sbrk+0x54>
  if(growproc(n) < 0) {
    return -1;
  }
  */
  return addr;
}
    800034d8:	8526                	mv	a0,s1
    800034da:	60a6                	ld	ra,72(sp)
    800034dc:	6406                	ld	s0,64(sp)
    800034de:	74e2                	ld	s1,56(sp)
    800034e0:	6161                	addi	sp,sp,80
    800034e2:	8082                	ret
    800034e4:	f84a                	sd	s2,48(sp)
    800034e6:	f44e                	sd	s3,40(sp)
    800034e8:	f052                	sd	s4,32(sp)
    800034ea:	ec56                	sd	s5,24(sp)
    myproc()->sz = uvmdealloc(myproc()->pagetable, myproc()->sz, myproc()->sz + n);
    800034ec:	bc9fe0ef          	jal	800020b4 <myproc>
    800034f0:	05053903          	ld	s2,80(a0)
    800034f4:	bc1fe0ef          	jal	800020b4 <myproc>
    800034f8:	04853983          	ld	s3,72(a0)
    800034fc:	bb9fe0ef          	jal	800020b4 <myproc>
    80003500:	fbc42783          	lw	a5,-68(s0)
    80003504:	6538                	ld	a4,72(a0)
    80003506:	00e78a33          	add	s4,a5,a4
    8000350a:	babfe0ef          	jal	800020b4 <myproc>
    8000350e:	8aaa                	mv	s5,a0
    80003510:	8652                	mv	a2,s4
    80003512:	85ce                	mv	a1,s3
    80003514:	854a                	mv	a0,s2
    80003516:	b30fe0ef          	jal	80001846 <uvmdealloc>
    8000351a:	04aab423          	sd	a0,72(s5)
    8000351e:	7942                	ld	s2,48(sp)
    80003520:	79a2                	ld	s3,40(sp)
    80003522:	7a02                	ld	s4,32(sp)
    80003524:	6ae2                	ld	s5,24(sp)
    80003526:	bf4d                	j	800034d8 <sys_sbrk+0x48>
      return -1;
    80003528:	54fd                	li	s1,-1
    8000352a:	b77d                	j	800034d8 <sys_sbrk+0x48>

000000008000352c <sys_pause>:

uint64
sys_pause(void)
{
    8000352c:	7139                	addi	sp,sp,-64
    8000352e:	fc06                	sd	ra,56(sp)
    80003530:	f822                	sd	s0,48(sp)
    80003532:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003534:	fcc40593          	addi	a1,s0,-52
    80003538:	4501                	li	a0,0
    8000353a:	ce7ff0ef          	jal	80003220 <argint>
  if(n < 0)
    8000353e:	fcc42783          	lw	a5,-52(s0)
    80003542:	0607c863          	bltz	a5,800035b2 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80003546:	02258517          	auipc	a0,0x2258
    8000354a:	23250513          	addi	a0,a0,562 # 8225b778 <tickslock>
    8000354e:	edafd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80003552:	fcc42783          	lw	a5,-52(s0)
    80003556:	c3b9                	beqz	a5,8000359c <sys_pause+0x70>
    80003558:	f426                	sd	s1,40(sp)
    8000355a:	f04a                	sd	s2,32(sp)
    8000355c:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    8000355e:	00008997          	auipc	s3,0x8
    80003562:	2ea9a983          	lw	s3,746(s3) # 8000b848 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003566:	02258917          	auipc	s2,0x2258
    8000356a:	21290913          	addi	s2,s2,530 # 8225b778 <tickslock>
    8000356e:	00008497          	auipc	s1,0x8
    80003572:	2da48493          	addi	s1,s1,730 # 8000b848 <ticks>
    if(killed(myproc())){
    80003576:	b3ffe0ef          	jal	800020b4 <myproc>
    8000357a:	cf0ff0ef          	jal	80002a6a <killed>
    8000357e:	ed0d                	bnez	a0,800035b8 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80003580:	85ca                	mv	a1,s2
    80003582:	8526                	mv	a0,s1
    80003584:	a4eff0ef          	jal	800027d2 <sleep>
  while(ticks - ticks0 < n){
    80003588:	409c                	lw	a5,0(s1)
    8000358a:	413787bb          	subw	a5,a5,s3
    8000358e:	fcc42703          	lw	a4,-52(s0)
    80003592:	fee7e2e3          	bltu	a5,a4,80003576 <sys_pause+0x4a>
    80003596:	74a2                	ld	s1,40(sp)
    80003598:	7902                	ld	s2,32(sp)
    8000359a:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000359c:	02258517          	auipc	a0,0x2258
    800035a0:	1dc50513          	addi	a0,a0,476 # 8225b778 <tickslock>
    800035a4:	f18fd0ef          	jal	80000cbc <release>
  return 0;
    800035a8:	4501                	li	a0,0
}
    800035aa:	70e2                	ld	ra,56(sp)
    800035ac:	7442                	ld	s0,48(sp)
    800035ae:	6121                	addi	sp,sp,64
    800035b0:	8082                	ret
    n = 0;
    800035b2:	fc042623          	sw	zero,-52(s0)
    800035b6:	bf41                	j	80003546 <sys_pause+0x1a>
      release(&tickslock);
    800035b8:	02258517          	auipc	a0,0x2258
    800035bc:	1c050513          	addi	a0,a0,448 # 8225b778 <tickslock>
    800035c0:	efcfd0ef          	jal	80000cbc <release>
      return -1;
    800035c4:	557d                	li	a0,-1
    800035c6:	74a2                	ld	s1,40(sp)
    800035c8:	7902                	ld	s2,32(sp)
    800035ca:	69e2                	ld	s3,24(sp)
    800035cc:	bff9                	j	800035aa <sys_pause+0x7e>

00000000800035ce <sys_kill>:

uint64
sys_kill(void)
{
    800035ce:	1101                	addi	sp,sp,-32
    800035d0:	ec06                	sd	ra,24(sp)
    800035d2:	e822                	sd	s0,16(sp)
    800035d4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800035d6:	fec40593          	addi	a1,s0,-20
    800035da:	4501                	li	a0,0
    800035dc:	c45ff0ef          	jal	80003220 <argint>
  return kkill(pid);
    800035e0:	fec42503          	lw	a0,-20(s0)
    800035e4:	bf2ff0ef          	jal	800029d6 <kkill>
}
    800035e8:	60e2                	ld	ra,24(sp)
    800035ea:	6442                	ld	s0,16(sp)
    800035ec:	6105                	addi	sp,sp,32
    800035ee:	8082                	ret

00000000800035f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800035fa:	02258517          	auipc	a0,0x2258
    800035fe:	17e50513          	addi	a0,a0,382 # 8225b778 <tickslock>
    80003602:	e26fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80003606:	00008797          	auipc	a5,0x8
    8000360a:	2427a783          	lw	a5,578(a5) # 8000b848 <ticks>
    8000360e:	84be                	mv	s1,a5
  release(&tickslock);
    80003610:	02258517          	auipc	a0,0x2258
    80003614:	16850513          	addi	a0,a0,360 # 8225b778 <tickslock>
    80003618:	ea4fd0ef          	jal	80000cbc <release>
  return xticks;
}
    8000361c:	02049513          	slli	a0,s1,0x20
    80003620:	9101                	srli	a0,a0,0x20
    80003622:	60e2                	ld	ra,24(sp)
    80003624:	6442                	ld	s0,16(sp)
    80003626:	64a2                	ld	s1,8(sp)
    80003628:	6105                	addi	sp,sp,32
    8000362a:	8082                	ret

000000008000362c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000362c:	7179                	addi	sp,sp,-48
    8000362e:	f406                	sd	ra,40(sp)
    80003630:	f022                	sd	s0,32(sp)
    80003632:	ec26                	sd	s1,24(sp)
    80003634:	e84a                	sd	s2,16(sp)
    80003636:	e44e                	sd	s3,8(sp)
    80003638:	e052                	sd	s4,0(sp)
    8000363a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000363c:	00005597          	auipc	a1,0x5
    80003640:	01458593          	addi	a1,a1,20 # 80008650 <etext+0x650>
    80003644:	02258517          	auipc	a0,0x2258
    80003648:	14c50513          	addi	a0,a0,332 # 8225b790 <bcache>
    8000364c:	d52fd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003650:	02260797          	auipc	a5,0x2260
    80003654:	14078793          	addi	a5,a5,320 # 82263790 <bcache+0x8000>
    80003658:	02260717          	auipc	a4,0x2260
    8000365c:	3a070713          	addi	a4,a4,928 # 822639f8 <bcache+0x8268>
    80003660:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003664:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003668:	02258497          	auipc	s1,0x2258
    8000366c:	14048493          	addi	s1,s1,320 # 8225b7a8 <bcache+0x18>
    b->next = bcache.head.next;
    80003670:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003672:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003674:	00005a17          	auipc	s4,0x5
    80003678:	fe4a0a13          	addi	s4,s4,-28 # 80008658 <etext+0x658>
    b->next = bcache.head.next;
    8000367c:	2b893783          	ld	a5,696(s2)
    80003680:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003682:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003686:	85d2                	mv	a1,s4
    80003688:	01048513          	addi	a0,s1,16
    8000368c:	328010ef          	jal	800049b4 <initsleeplock>
    bcache.head.next->prev = b;
    80003690:	2b893783          	ld	a5,696(s2)
    80003694:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003696:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000369a:	45848493          	addi	s1,s1,1112
    8000369e:	fd349fe3          	bne	s1,s3,8000367c <binit+0x50>
  }
}
    800036a2:	70a2                	ld	ra,40(sp)
    800036a4:	7402                	ld	s0,32(sp)
    800036a6:	64e2                	ld	s1,24(sp)
    800036a8:	6942                	ld	s2,16(sp)
    800036aa:	69a2                	ld	s3,8(sp)
    800036ac:	6a02                	ld	s4,0(sp)
    800036ae:	6145                	addi	sp,sp,48
    800036b0:	8082                	ret

00000000800036b2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800036b2:	7179                	addi	sp,sp,-48
    800036b4:	f406                	sd	ra,40(sp)
    800036b6:	f022                	sd	s0,32(sp)
    800036b8:	ec26                	sd	s1,24(sp)
    800036ba:	e84a                	sd	s2,16(sp)
    800036bc:	e44e                	sd	s3,8(sp)
    800036be:	1800                	addi	s0,sp,48
    800036c0:	892a                	mv	s2,a0
    800036c2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800036c4:	02258517          	auipc	a0,0x2258
    800036c8:	0cc50513          	addi	a0,a0,204 # 8225b790 <bcache>
    800036cc:	d5cfd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800036d0:	02260497          	auipc	s1,0x2260
    800036d4:	3784b483          	ld	s1,888(s1) # 82263a48 <bcache+0x82b8>
    800036d8:	02260797          	auipc	a5,0x2260
    800036dc:	32078793          	addi	a5,a5,800 # 822639f8 <bcache+0x8268>
    800036e0:	02f48b63          	beq	s1,a5,80003716 <bread+0x64>
    800036e4:	873e                	mv	a4,a5
    800036e6:	a021                	j	800036ee <bread+0x3c>
    800036e8:	68a4                	ld	s1,80(s1)
    800036ea:	02e48663          	beq	s1,a4,80003716 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800036ee:	449c                	lw	a5,8(s1)
    800036f0:	ff279ce3          	bne	a5,s2,800036e8 <bread+0x36>
    800036f4:	44dc                	lw	a5,12(s1)
    800036f6:	ff3799e3          	bne	a5,s3,800036e8 <bread+0x36>
      b->refcnt++;
    800036fa:	40bc                	lw	a5,64(s1)
    800036fc:	2785                	addiw	a5,a5,1
    800036fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003700:	02258517          	auipc	a0,0x2258
    80003704:	09050513          	addi	a0,a0,144 # 8225b790 <bcache>
    80003708:	db4fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    8000370c:	01048513          	addi	a0,s1,16
    80003710:	2da010ef          	jal	800049ea <acquiresleep>
      return b;
    80003714:	a889                	j	80003766 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003716:	02260497          	auipc	s1,0x2260
    8000371a:	32a4b483          	ld	s1,810(s1) # 82263a40 <bcache+0x82b0>
    8000371e:	02260797          	auipc	a5,0x2260
    80003722:	2da78793          	addi	a5,a5,730 # 822639f8 <bcache+0x8268>
    80003726:	00f48863          	beq	s1,a5,80003736 <bread+0x84>
    8000372a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000372c:	40bc                	lw	a5,64(s1)
    8000372e:	cb91                	beqz	a5,80003742 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003730:	64a4                	ld	s1,72(s1)
    80003732:	fee49de3          	bne	s1,a4,8000372c <bread+0x7a>
  panic("bget: no buffers");
    80003736:	00005517          	auipc	a0,0x5
    8000373a:	f2a50513          	addi	a0,a0,-214 # 80008660 <etext+0x660>
    8000373e:	8e6fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80003742:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003746:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000374a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000374e:	4785                	li	a5,1
    80003750:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003752:	02258517          	auipc	a0,0x2258
    80003756:	03e50513          	addi	a0,a0,62 # 8225b790 <bcache>
    8000375a:	d62fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    8000375e:	01048513          	addi	a0,s1,16
    80003762:	288010ef          	jal	800049ea <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003766:	409c                	lw	a5,0(s1)
    80003768:	cb89                	beqz	a5,8000377a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000376a:	8526                	mv	a0,s1
    8000376c:	70a2                	ld	ra,40(sp)
    8000376e:	7402                	ld	s0,32(sp)
    80003770:	64e2                	ld	s1,24(sp)
    80003772:	6942                	ld	s2,16(sp)
    80003774:	69a2                	ld	s3,8(sp)
    80003776:	6145                	addi	sp,sp,48
    80003778:	8082                	ret
    virtio_disk_rw(b, 0);
    8000377a:	4581                	li	a1,0
    8000377c:	8526                	mv	a0,s1
    8000377e:	583020ef          	jal	80006500 <virtio_disk_rw>
    b->valid = 1;
    80003782:	4785                	li	a5,1
    80003784:	c09c                	sw	a5,0(s1)
  return b;
    80003786:	b7d5                	j	8000376a <bread+0xb8>

0000000080003788 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003788:	1101                	addi	sp,sp,-32
    8000378a:	ec06                	sd	ra,24(sp)
    8000378c:	e822                	sd	s0,16(sp)
    8000378e:	e426                	sd	s1,8(sp)
    80003790:	1000                	addi	s0,sp,32
    80003792:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003794:	0541                	addi	a0,a0,16
    80003796:	2d2010ef          	jal	80004a68 <holdingsleep>
    8000379a:	c911                	beqz	a0,800037ae <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000379c:	4585                	li	a1,1
    8000379e:	8526                	mv	a0,s1
    800037a0:	561020ef          	jal	80006500 <virtio_disk_rw>
}
    800037a4:	60e2                	ld	ra,24(sp)
    800037a6:	6442                	ld	s0,16(sp)
    800037a8:	64a2                	ld	s1,8(sp)
    800037aa:	6105                	addi	sp,sp,32
    800037ac:	8082                	ret
    panic("bwrite");
    800037ae:	00005517          	auipc	a0,0x5
    800037b2:	eca50513          	addi	a0,a0,-310 # 80008678 <etext+0x678>
    800037b6:	86efd0ef          	jal	80000824 <panic>

00000000800037ba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037c8:	01050913          	addi	s2,a0,16
    800037cc:	854a                	mv	a0,s2
    800037ce:	29a010ef          	jal	80004a68 <holdingsleep>
    800037d2:	c125                	beqz	a0,80003832 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800037d4:	854a                	mv	a0,s2
    800037d6:	25a010ef          	jal	80004a30 <releasesleep>

  acquire(&bcache.lock);
    800037da:	02258517          	auipc	a0,0x2258
    800037de:	fb650513          	addi	a0,a0,-74 # 8225b790 <bcache>
    800037e2:	c46fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    800037e6:	40bc                	lw	a5,64(s1)
    800037e8:	37fd                	addiw	a5,a5,-1
    800037ea:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800037ec:	e79d                	bnez	a5,8000381a <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800037ee:	68b8                	ld	a4,80(s1)
    800037f0:	64bc                	ld	a5,72(s1)
    800037f2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800037f4:	68b8                	ld	a4,80(s1)
    800037f6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800037f8:	02260797          	auipc	a5,0x2260
    800037fc:	f9878793          	addi	a5,a5,-104 # 82263790 <bcache+0x8000>
    80003800:	2b87b703          	ld	a4,696(a5)
    80003804:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003806:	02260717          	auipc	a4,0x2260
    8000380a:	1f270713          	addi	a4,a4,498 # 822639f8 <bcache+0x8268>
    8000380e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003810:	2b87b703          	ld	a4,696(a5)
    80003814:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003816:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000381a:	02258517          	auipc	a0,0x2258
    8000381e:	f7650513          	addi	a0,a0,-138 # 8225b790 <bcache>
    80003822:	c9afd0ef          	jal	80000cbc <release>
}
    80003826:	60e2                	ld	ra,24(sp)
    80003828:	6442                	ld	s0,16(sp)
    8000382a:	64a2                	ld	s1,8(sp)
    8000382c:	6902                	ld	s2,0(sp)
    8000382e:	6105                	addi	sp,sp,32
    80003830:	8082                	ret
    panic("brelse");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	e4e50513          	addi	a0,a0,-434 # 80008680 <etext+0x680>
    8000383a:	febfc0ef          	jal	80000824 <panic>

000000008000383e <bpin>:

void
bpin(struct buf *b) {
    8000383e:	1101                	addi	sp,sp,-32
    80003840:	ec06                	sd	ra,24(sp)
    80003842:	e822                	sd	s0,16(sp)
    80003844:	e426                	sd	s1,8(sp)
    80003846:	1000                	addi	s0,sp,32
    80003848:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000384a:	02258517          	auipc	a0,0x2258
    8000384e:	f4650513          	addi	a0,a0,-186 # 8225b790 <bcache>
    80003852:	bd6fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80003856:	40bc                	lw	a5,64(s1)
    80003858:	2785                	addiw	a5,a5,1
    8000385a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000385c:	02258517          	auipc	a0,0x2258
    80003860:	f3450513          	addi	a0,a0,-204 # 8225b790 <bcache>
    80003864:	c58fd0ef          	jal	80000cbc <release>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <bunpin>:

void
bunpin(struct buf *b) {
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	1000                	addi	s0,sp,32
    8000387c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000387e:	02258517          	auipc	a0,0x2258
    80003882:	f1250513          	addi	a0,a0,-238 # 8225b790 <bcache>
    80003886:	ba2fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    8000388a:	40bc                	lw	a5,64(s1)
    8000388c:	37fd                	addiw	a5,a5,-1
    8000388e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003890:	02258517          	auipc	a0,0x2258
    80003894:	f0050513          	addi	a0,a0,-256 # 8225b790 <bcache>
    80003898:	c24fd0ef          	jal	80000cbc <release>
}
    8000389c:	60e2                	ld	ra,24(sp)
    8000389e:	6442                	ld	s0,16(sp)
    800038a0:	64a2                	ld	s1,8(sp)
    800038a2:	6105                	addi	sp,sp,32
    800038a4:	8082                	ret

00000000800038a6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800038a6:	1101                	addi	sp,sp,-32
    800038a8:	ec06                	sd	ra,24(sp)
    800038aa:	e822                	sd	s0,16(sp)
    800038ac:	e426                	sd	s1,8(sp)
    800038ae:	e04a                	sd	s2,0(sp)
    800038b0:	1000                	addi	s0,sp,32
    800038b2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800038b4:	00d5d79b          	srliw	a5,a1,0xd
    800038b8:	02260597          	auipc	a1,0x2260
    800038bc:	5b45a583          	lw	a1,1460(a1) # 82263e6c <sb+0x1c>
    800038c0:	9dbd                	addw	a1,a1,a5
    800038c2:	df1ff0ef          	jal	800036b2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800038c6:	0074f713          	andi	a4,s1,7
    800038ca:	4785                	li	a5,1
    800038cc:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800038d0:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800038d2:	90d9                	srli	s1,s1,0x36
    800038d4:	00950733          	add	a4,a0,s1
    800038d8:	05874703          	lbu	a4,88(a4)
    800038dc:	00e7f6b3          	and	a3,a5,a4
    800038e0:	c29d                	beqz	a3,80003906 <bfree+0x60>
    800038e2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800038e4:	94aa                	add	s1,s1,a0
    800038e6:	fff7c793          	not	a5,a5
    800038ea:	8f7d                	and	a4,a4,a5
    800038ec:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800038f0:	000010ef          	jal	800048f0 <log_write>
  brelse(bp);
    800038f4:	854a                	mv	a0,s2
    800038f6:	ec5ff0ef          	jal	800037ba <brelse>
}
    800038fa:	60e2                	ld	ra,24(sp)
    800038fc:	6442                	ld	s0,16(sp)
    800038fe:	64a2                	ld	s1,8(sp)
    80003900:	6902                	ld	s2,0(sp)
    80003902:	6105                	addi	sp,sp,32
    80003904:	8082                	ret
    panic("freeing free block");
    80003906:	00005517          	auipc	a0,0x5
    8000390a:	d8250513          	addi	a0,a0,-638 # 80008688 <etext+0x688>
    8000390e:	f17fc0ef          	jal	80000824 <panic>

0000000080003912 <balloc>:
{
    80003912:	715d                	addi	sp,sp,-80
    80003914:	e486                	sd	ra,72(sp)
    80003916:	e0a2                	sd	s0,64(sp)
    80003918:	fc26                	sd	s1,56(sp)
    8000391a:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000391c:	02260797          	auipc	a5,0x2260
    80003920:	5387a783          	lw	a5,1336(a5) # 82263e54 <sb+0x4>
    80003924:	0e078263          	beqz	a5,80003a08 <balloc+0xf6>
    80003928:	f84a                	sd	s2,48(sp)
    8000392a:	f44e                	sd	s3,40(sp)
    8000392c:	f052                	sd	s4,32(sp)
    8000392e:	ec56                	sd	s5,24(sp)
    80003930:	e85a                	sd	s6,16(sp)
    80003932:	e45e                	sd	s7,8(sp)
    80003934:	e062                	sd	s8,0(sp)
    80003936:	8baa                	mv	s7,a0
    80003938:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000393a:	02260b17          	auipc	s6,0x2260
    8000393e:	516b0b13          	addi	s6,s6,1302 # 82263e50 <sb>
      m = 1 << (bi % 8);
    80003942:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003944:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003946:	6c09                	lui	s8,0x2
    80003948:	a09d                	j	800039ae <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000394a:	97ca                	add	a5,a5,s2
    8000394c:	8e55                	or	a2,a2,a3
    8000394e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003952:	854a                	mv	a0,s2
    80003954:	79d000ef          	jal	800048f0 <log_write>
        brelse(bp);
    80003958:	854a                	mv	a0,s2
    8000395a:	e61ff0ef          	jal	800037ba <brelse>
  bp = bread(dev, bno);
    8000395e:	85a6                	mv	a1,s1
    80003960:	855e                	mv	a0,s7
    80003962:	d51ff0ef          	jal	800036b2 <bread>
    80003966:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003968:	40000613          	li	a2,1024
    8000396c:	4581                	li	a1,0
    8000396e:	05850513          	addi	a0,a0,88
    80003972:	b86fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80003976:	854a                	mv	a0,s2
    80003978:	779000ef          	jal	800048f0 <log_write>
  brelse(bp);
    8000397c:	854a                	mv	a0,s2
    8000397e:	e3dff0ef          	jal	800037ba <brelse>
}
    80003982:	7942                	ld	s2,48(sp)
    80003984:	79a2                	ld	s3,40(sp)
    80003986:	7a02                	ld	s4,32(sp)
    80003988:	6ae2                	ld	s5,24(sp)
    8000398a:	6b42                	ld	s6,16(sp)
    8000398c:	6ba2                	ld	s7,8(sp)
    8000398e:	6c02                	ld	s8,0(sp)
}
    80003990:	8526                	mv	a0,s1
    80003992:	60a6                	ld	ra,72(sp)
    80003994:	6406                	ld	s0,64(sp)
    80003996:	74e2                	ld	s1,56(sp)
    80003998:	6161                	addi	sp,sp,80
    8000399a:	8082                	ret
    brelse(bp);
    8000399c:	854a                	mv	a0,s2
    8000399e:	e1dff0ef          	jal	800037ba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800039a2:	015c0abb          	addw	s5,s8,s5
    800039a6:	004b2783          	lw	a5,4(s6)
    800039aa:	04faf863          	bgeu	s5,a5,800039fa <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800039ae:	40dad59b          	sraiw	a1,s5,0xd
    800039b2:	01cb2783          	lw	a5,28(s6)
    800039b6:	9dbd                	addw	a1,a1,a5
    800039b8:	855e                	mv	a0,s7
    800039ba:	cf9ff0ef          	jal	800036b2 <bread>
    800039be:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039c0:	004b2503          	lw	a0,4(s6)
    800039c4:	84d6                	mv	s1,s5
    800039c6:	4701                	li	a4,0
    800039c8:	fca4fae3          	bgeu	s1,a0,8000399c <balloc+0x8a>
      m = 1 << (bi % 8);
    800039cc:	00777693          	andi	a3,a4,7
    800039d0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800039d4:	41f7579b          	sraiw	a5,a4,0x1f
    800039d8:	01d7d79b          	srliw	a5,a5,0x1d
    800039dc:	9fb9                	addw	a5,a5,a4
    800039de:	4037d79b          	sraiw	a5,a5,0x3
    800039e2:	00f90633          	add	a2,s2,a5
    800039e6:	05864603          	lbu	a2,88(a2)
    800039ea:	00c6f5b3          	and	a1,a3,a2
    800039ee:	ddb1                	beqz	a1,8000394a <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039f0:	2705                	addiw	a4,a4,1
    800039f2:	2485                	addiw	s1,s1,1
    800039f4:	fd471ae3          	bne	a4,s4,800039c8 <balloc+0xb6>
    800039f8:	b755                	j	8000399c <balloc+0x8a>
    800039fa:	7942                	ld	s2,48(sp)
    800039fc:	79a2                	ld	s3,40(sp)
    800039fe:	7a02                	ld	s4,32(sp)
    80003a00:	6ae2                	ld	s5,24(sp)
    80003a02:	6b42                	ld	s6,16(sp)
    80003a04:	6ba2                	ld	s7,8(sp)
    80003a06:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003a08:	00005517          	auipc	a0,0x5
    80003a0c:	c9850513          	addi	a0,a0,-872 # 800086a0 <etext+0x6a0>
    80003a10:	aebfc0ef          	jal	800004fa <printf>
  return 0;
    80003a14:	4481                	li	s1,0
    80003a16:	bfad                	j	80003990 <balloc+0x7e>

0000000080003a18 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003a18:	7179                	addi	sp,sp,-48
    80003a1a:	f406                	sd	ra,40(sp)
    80003a1c:	f022                	sd	s0,32(sp)
    80003a1e:	ec26                	sd	s1,24(sp)
    80003a20:	e84a                	sd	s2,16(sp)
    80003a22:	e44e                	sd	s3,8(sp)
    80003a24:	1800                	addi	s0,sp,48
    80003a26:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003a28:	47ad                	li	a5,11
    80003a2a:	02b7e363          	bltu	a5,a1,80003a50 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003a2e:	02059793          	slli	a5,a1,0x20
    80003a32:	01e7d593          	srli	a1,a5,0x1e
    80003a36:	00b509b3          	add	s3,a0,a1
    80003a3a:	0509a483          	lw	s1,80(s3)
    80003a3e:	e0b5                	bnez	s1,80003aa2 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003a40:	4108                	lw	a0,0(a0)
    80003a42:	ed1ff0ef          	jal	80003912 <balloc>
    80003a46:	84aa                	mv	s1,a0
      if(addr == 0)
    80003a48:	cd29                	beqz	a0,80003aa2 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003a4a:	04a9a823          	sw	a0,80(s3)
    80003a4e:	a891                	j	80003aa2 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003a50:	ff45879b          	addiw	a5,a1,-12
    80003a54:	873e                	mv	a4,a5
    80003a56:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003a58:	0ff00793          	li	a5,255
    80003a5c:	06e7e763          	bltu	a5,a4,80003aca <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003a60:	08052483          	lw	s1,128(a0)
    80003a64:	e891                	bnez	s1,80003a78 <bmap+0x60>
      addr = balloc(ip->dev);
    80003a66:	4108                	lw	a0,0(a0)
    80003a68:	eabff0ef          	jal	80003912 <balloc>
    80003a6c:	84aa                	mv	s1,a0
      if(addr == 0)
    80003a6e:	c915                	beqz	a0,80003aa2 <bmap+0x8a>
    80003a70:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003a72:	08a92023          	sw	a0,128(s2)
    80003a76:	a011                	j	80003a7a <bmap+0x62>
    80003a78:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003a7a:	85a6                	mv	a1,s1
    80003a7c:	00092503          	lw	a0,0(s2)
    80003a80:	c33ff0ef          	jal	800036b2 <bread>
    80003a84:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003a86:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003a8a:	02099713          	slli	a4,s3,0x20
    80003a8e:	01e75593          	srli	a1,a4,0x1e
    80003a92:	97ae                	add	a5,a5,a1
    80003a94:	89be                	mv	s3,a5
    80003a96:	4384                	lw	s1,0(a5)
    80003a98:	cc89                	beqz	s1,80003ab2 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003a9a:	8552                	mv	a0,s4
    80003a9c:	d1fff0ef          	jal	800037ba <brelse>
    return addr;
    80003aa0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	70a2                	ld	ra,40(sp)
    80003aa6:	7402                	ld	s0,32(sp)
    80003aa8:	64e2                	ld	s1,24(sp)
    80003aaa:	6942                	ld	s2,16(sp)
    80003aac:	69a2                	ld	s3,8(sp)
    80003aae:	6145                	addi	sp,sp,48
    80003ab0:	8082                	ret
      addr = balloc(ip->dev);
    80003ab2:	00092503          	lw	a0,0(s2)
    80003ab6:	e5dff0ef          	jal	80003912 <balloc>
    80003aba:	84aa                	mv	s1,a0
      if(addr){
    80003abc:	dd79                	beqz	a0,80003a9a <bmap+0x82>
        a[bn] = addr;
    80003abe:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003ac2:	8552                	mv	a0,s4
    80003ac4:	62d000ef          	jal	800048f0 <log_write>
    80003ac8:	bfc9                	j	80003a9a <bmap+0x82>
    80003aca:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003acc:	00005517          	auipc	a0,0x5
    80003ad0:	bec50513          	addi	a0,a0,-1044 # 800086b8 <etext+0x6b8>
    80003ad4:	d51fc0ef          	jal	80000824 <panic>

0000000080003ad8 <iget>:
{
    80003ad8:	7179                	addi	sp,sp,-48
    80003ada:	f406                	sd	ra,40(sp)
    80003adc:	f022                	sd	s0,32(sp)
    80003ade:	ec26                	sd	s1,24(sp)
    80003ae0:	e84a                	sd	s2,16(sp)
    80003ae2:	e44e                	sd	s3,8(sp)
    80003ae4:	e052                	sd	s4,0(sp)
    80003ae6:	1800                	addi	s0,sp,48
    80003ae8:	892a                	mv	s2,a0
    80003aea:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003aec:	02260517          	auipc	a0,0x2260
    80003af0:	38450513          	addi	a0,a0,900 # 82263e70 <itable>
    80003af4:	934fd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80003af8:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003afa:	02260497          	auipc	s1,0x2260
    80003afe:	38e48493          	addi	s1,s1,910 # 82263e88 <itable+0x18>
    80003b02:	02262697          	auipc	a3,0x2262
    80003b06:	e1668693          	addi	a3,a3,-490 # 82265918 <log>
    80003b0a:	a809                	j	80003b1c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b0c:	e781                	bnez	a5,80003b14 <iget+0x3c>
    80003b0e:	00099363          	bnez	s3,80003b14 <iget+0x3c>
      empty = ip;
    80003b12:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b14:	08848493          	addi	s1,s1,136
    80003b18:	02d48563          	beq	s1,a3,80003b42 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003b1c:	449c                	lw	a5,8(s1)
    80003b1e:	fef057e3          	blez	a5,80003b0c <iget+0x34>
    80003b22:	4098                	lw	a4,0(s1)
    80003b24:	ff2718e3          	bne	a4,s2,80003b14 <iget+0x3c>
    80003b28:	40d8                	lw	a4,4(s1)
    80003b2a:	ff4715e3          	bne	a4,s4,80003b14 <iget+0x3c>
      ip->ref++;
    80003b2e:	2785                	addiw	a5,a5,1
    80003b30:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003b32:	02260517          	auipc	a0,0x2260
    80003b36:	33e50513          	addi	a0,a0,830 # 82263e70 <itable>
    80003b3a:	982fd0ef          	jal	80000cbc <release>
      return ip;
    80003b3e:	89a6                	mv	s3,s1
    80003b40:	a015                	j	80003b64 <iget+0x8c>
  if(empty == 0)
    80003b42:	02098a63          	beqz	s3,80003b76 <iget+0x9e>
  ip->dev = dev;
    80003b46:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003b4a:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003b4e:	4785                	li	a5,1
    80003b50:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003b54:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003b58:	02260517          	auipc	a0,0x2260
    80003b5c:	31850513          	addi	a0,a0,792 # 82263e70 <itable>
    80003b60:	95cfd0ef          	jal	80000cbc <release>
}
    80003b64:	854e                	mv	a0,s3
    80003b66:	70a2                	ld	ra,40(sp)
    80003b68:	7402                	ld	s0,32(sp)
    80003b6a:	64e2                	ld	s1,24(sp)
    80003b6c:	6942                	ld	s2,16(sp)
    80003b6e:	69a2                	ld	s3,8(sp)
    80003b70:	6a02                	ld	s4,0(sp)
    80003b72:	6145                	addi	sp,sp,48
    80003b74:	8082                	ret
    panic("iget: no inodes");
    80003b76:	00005517          	auipc	a0,0x5
    80003b7a:	b5a50513          	addi	a0,a0,-1190 # 800086d0 <etext+0x6d0>
    80003b7e:	ca7fc0ef          	jal	80000824 <panic>

0000000080003b82 <iinit>:
{
    80003b82:	7179                	addi	sp,sp,-48
    80003b84:	f406                	sd	ra,40(sp)
    80003b86:	f022                	sd	s0,32(sp)
    80003b88:	ec26                	sd	s1,24(sp)
    80003b8a:	e84a                	sd	s2,16(sp)
    80003b8c:	e44e                	sd	s3,8(sp)
    80003b8e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b90:	00005597          	auipc	a1,0x5
    80003b94:	b5058593          	addi	a1,a1,-1200 # 800086e0 <etext+0x6e0>
    80003b98:	02260517          	auipc	a0,0x2260
    80003b9c:	2d850513          	addi	a0,a0,728 # 82263e70 <itable>
    80003ba0:	ffffc0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ba4:	02260497          	auipc	s1,0x2260
    80003ba8:	2f448493          	addi	s1,s1,756 # 82263e98 <itable+0x28>
    80003bac:	02262997          	auipc	s3,0x2262
    80003bb0:	d7c98993          	addi	s3,s3,-644 # 82265928 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003bb4:	00005917          	auipc	s2,0x5
    80003bb8:	b3490913          	addi	s2,s2,-1228 # 800086e8 <etext+0x6e8>
    80003bbc:	85ca                	mv	a1,s2
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	5f5000ef          	jal	800049b4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003bc4:	08848493          	addi	s1,s1,136
    80003bc8:	ff349ae3          	bne	s1,s3,80003bbc <iinit+0x3a>
}
    80003bcc:	70a2                	ld	ra,40(sp)
    80003bce:	7402                	ld	s0,32(sp)
    80003bd0:	64e2                	ld	s1,24(sp)
    80003bd2:	6942                	ld	s2,16(sp)
    80003bd4:	69a2                	ld	s3,8(sp)
    80003bd6:	6145                	addi	sp,sp,48
    80003bd8:	8082                	ret

0000000080003bda <ialloc>:
{
    80003bda:	7139                	addi	sp,sp,-64
    80003bdc:	fc06                	sd	ra,56(sp)
    80003bde:	f822                	sd	s0,48(sp)
    80003be0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003be2:	02260717          	auipc	a4,0x2260
    80003be6:	27a72703          	lw	a4,634(a4) # 82263e5c <sb+0xc>
    80003bea:	4785                	li	a5,1
    80003bec:	06e7f063          	bgeu	a5,a4,80003c4c <ialloc+0x72>
    80003bf0:	f426                	sd	s1,40(sp)
    80003bf2:	f04a                	sd	s2,32(sp)
    80003bf4:	ec4e                	sd	s3,24(sp)
    80003bf6:	e852                	sd	s4,16(sp)
    80003bf8:	e456                	sd	s5,8(sp)
    80003bfa:	e05a                	sd	s6,0(sp)
    80003bfc:	8aaa                	mv	s5,a0
    80003bfe:	8b2e                	mv	s6,a1
    80003c00:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003c02:	02260a17          	auipc	s4,0x2260
    80003c06:	24ea0a13          	addi	s4,s4,590 # 82263e50 <sb>
    80003c0a:	00495593          	srli	a1,s2,0x4
    80003c0e:	018a2783          	lw	a5,24(s4)
    80003c12:	9dbd                	addw	a1,a1,a5
    80003c14:	8556                	mv	a0,s5
    80003c16:	a9dff0ef          	jal	800036b2 <bread>
    80003c1a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003c1c:	05850993          	addi	s3,a0,88
    80003c20:	00f97793          	andi	a5,s2,15
    80003c24:	079a                	slli	a5,a5,0x6
    80003c26:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003c28:	00099783          	lh	a5,0(s3)
    80003c2c:	cb9d                	beqz	a5,80003c62 <ialloc+0x88>
    brelse(bp);
    80003c2e:	b8dff0ef          	jal	800037ba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c32:	0905                	addi	s2,s2,1
    80003c34:	00ca2703          	lw	a4,12(s4)
    80003c38:	0009079b          	sext.w	a5,s2
    80003c3c:	fce7e7e3          	bltu	a5,a4,80003c0a <ialloc+0x30>
    80003c40:	74a2                	ld	s1,40(sp)
    80003c42:	7902                	ld	s2,32(sp)
    80003c44:	69e2                	ld	s3,24(sp)
    80003c46:	6a42                	ld	s4,16(sp)
    80003c48:	6aa2                	ld	s5,8(sp)
    80003c4a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003c4c:	00005517          	auipc	a0,0x5
    80003c50:	aa450513          	addi	a0,a0,-1372 # 800086f0 <etext+0x6f0>
    80003c54:	8a7fc0ef          	jal	800004fa <printf>
  return 0;
    80003c58:	4501                	li	a0,0
}
    80003c5a:	70e2                	ld	ra,56(sp)
    80003c5c:	7442                	ld	s0,48(sp)
    80003c5e:	6121                	addi	sp,sp,64
    80003c60:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003c62:	04000613          	li	a2,64
    80003c66:	4581                	li	a1,0
    80003c68:	854e                	mv	a0,s3
    80003c6a:	88efd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003c6e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c72:	8526                	mv	a0,s1
    80003c74:	47d000ef          	jal	800048f0 <log_write>
      brelse(bp);
    80003c78:	8526                	mv	a0,s1
    80003c7a:	b41ff0ef          	jal	800037ba <brelse>
      return iget(dev, inum);
    80003c7e:	0009059b          	sext.w	a1,s2
    80003c82:	8556                	mv	a0,s5
    80003c84:	e55ff0ef          	jal	80003ad8 <iget>
    80003c88:	74a2                	ld	s1,40(sp)
    80003c8a:	7902                	ld	s2,32(sp)
    80003c8c:	69e2                	ld	s3,24(sp)
    80003c8e:	6a42                	ld	s4,16(sp)
    80003c90:	6aa2                	ld	s5,8(sp)
    80003c92:	6b02                	ld	s6,0(sp)
    80003c94:	b7d9                	j	80003c5a <ialloc+0x80>

0000000080003c96 <iupdate>:
{
    80003c96:	1101                	addi	sp,sp,-32
    80003c98:	ec06                	sd	ra,24(sp)
    80003c9a:	e822                	sd	s0,16(sp)
    80003c9c:	e426                	sd	s1,8(sp)
    80003c9e:	e04a                	sd	s2,0(sp)
    80003ca0:	1000                	addi	s0,sp,32
    80003ca2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ca4:	415c                	lw	a5,4(a0)
    80003ca6:	0047d79b          	srliw	a5,a5,0x4
    80003caa:	02260597          	auipc	a1,0x2260
    80003cae:	1be5a583          	lw	a1,446(a1) # 82263e68 <sb+0x18>
    80003cb2:	9dbd                	addw	a1,a1,a5
    80003cb4:	4108                	lw	a0,0(a0)
    80003cb6:	9fdff0ef          	jal	800036b2 <bread>
    80003cba:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003cbc:	05850793          	addi	a5,a0,88
    80003cc0:	40d8                	lw	a4,4(s1)
    80003cc2:	8b3d                	andi	a4,a4,15
    80003cc4:	071a                	slli	a4,a4,0x6
    80003cc6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003cc8:	04449703          	lh	a4,68(s1)
    80003ccc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003cd0:	04649703          	lh	a4,70(s1)
    80003cd4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003cd8:	04849703          	lh	a4,72(s1)
    80003cdc:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003ce0:	04a49703          	lh	a4,74(s1)
    80003ce4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003ce8:	44f8                	lw	a4,76(s1)
    80003cea:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003cec:	03400613          	li	a2,52
    80003cf0:	05048593          	addi	a1,s1,80
    80003cf4:	00c78513          	addi	a0,a5,12
    80003cf8:	860fd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003cfc:	854a                	mv	a0,s2
    80003cfe:	3f3000ef          	jal	800048f0 <log_write>
  brelse(bp);
    80003d02:	854a                	mv	a0,s2
    80003d04:	ab7ff0ef          	jal	800037ba <brelse>
}
    80003d08:	60e2                	ld	ra,24(sp)
    80003d0a:	6442                	ld	s0,16(sp)
    80003d0c:	64a2                	ld	s1,8(sp)
    80003d0e:	6902                	ld	s2,0(sp)
    80003d10:	6105                	addi	sp,sp,32
    80003d12:	8082                	ret

0000000080003d14 <idup>:
{
    80003d14:	1101                	addi	sp,sp,-32
    80003d16:	ec06                	sd	ra,24(sp)
    80003d18:	e822                	sd	s0,16(sp)
    80003d1a:	e426                	sd	s1,8(sp)
    80003d1c:	1000                	addi	s0,sp,32
    80003d1e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d20:	02260517          	auipc	a0,0x2260
    80003d24:	15050513          	addi	a0,a0,336 # 82263e70 <itable>
    80003d28:	f01fc0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003d2c:	449c                	lw	a5,8(s1)
    80003d2e:	2785                	addiw	a5,a5,1
    80003d30:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d32:	02260517          	auipc	a0,0x2260
    80003d36:	13e50513          	addi	a0,a0,318 # 82263e70 <itable>
    80003d3a:	f83fc0ef          	jal	80000cbc <release>
}
    80003d3e:	8526                	mv	a0,s1
    80003d40:	60e2                	ld	ra,24(sp)
    80003d42:	6442                	ld	s0,16(sp)
    80003d44:	64a2                	ld	s1,8(sp)
    80003d46:	6105                	addi	sp,sp,32
    80003d48:	8082                	ret

0000000080003d4a <ilock>:
{
    80003d4a:	1101                	addi	sp,sp,-32
    80003d4c:	ec06                	sd	ra,24(sp)
    80003d4e:	e822                	sd	s0,16(sp)
    80003d50:	e426                	sd	s1,8(sp)
    80003d52:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d54:	cd19                	beqz	a0,80003d72 <ilock+0x28>
    80003d56:	84aa                	mv	s1,a0
    80003d58:	451c                	lw	a5,8(a0)
    80003d5a:	00f05c63          	blez	a5,80003d72 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003d5e:	0541                	addi	a0,a0,16
    80003d60:	48b000ef          	jal	800049ea <acquiresleep>
  if(ip->valid == 0){
    80003d64:	40bc                	lw	a5,64(s1)
    80003d66:	cf89                	beqz	a5,80003d80 <ilock+0x36>
}
    80003d68:	60e2                	ld	ra,24(sp)
    80003d6a:	6442                	ld	s0,16(sp)
    80003d6c:	64a2                	ld	s1,8(sp)
    80003d6e:	6105                	addi	sp,sp,32
    80003d70:	8082                	ret
    80003d72:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d74:	00005517          	auipc	a0,0x5
    80003d78:	99450513          	addi	a0,a0,-1644 # 80008708 <etext+0x708>
    80003d7c:	aa9fc0ef          	jal	80000824 <panic>
    80003d80:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d82:	40dc                	lw	a5,4(s1)
    80003d84:	0047d79b          	srliw	a5,a5,0x4
    80003d88:	02260597          	auipc	a1,0x2260
    80003d8c:	0e05a583          	lw	a1,224(a1) # 82263e68 <sb+0x18>
    80003d90:	9dbd                	addw	a1,a1,a5
    80003d92:	4088                	lw	a0,0(s1)
    80003d94:	91fff0ef          	jal	800036b2 <bread>
    80003d98:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d9a:	05850593          	addi	a1,a0,88
    80003d9e:	40dc                	lw	a5,4(s1)
    80003da0:	8bbd                	andi	a5,a5,15
    80003da2:	079a                	slli	a5,a5,0x6
    80003da4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003da6:	00059783          	lh	a5,0(a1)
    80003daa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003dae:	00259783          	lh	a5,2(a1)
    80003db2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003db6:	00459783          	lh	a5,4(a1)
    80003dba:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003dbe:	00659783          	lh	a5,6(a1)
    80003dc2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003dc6:	459c                	lw	a5,8(a1)
    80003dc8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003dca:	03400613          	li	a2,52
    80003dce:	05b1                	addi	a1,a1,12
    80003dd0:	05048513          	addi	a0,s1,80
    80003dd4:	f85fc0ef          	jal	80000d58 <memmove>
    brelse(bp);
    80003dd8:	854a                	mv	a0,s2
    80003dda:	9e1ff0ef          	jal	800037ba <brelse>
    ip->valid = 1;
    80003dde:	4785                	li	a5,1
    80003de0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003de2:	04449783          	lh	a5,68(s1)
    80003de6:	c399                	beqz	a5,80003dec <ilock+0xa2>
    80003de8:	6902                	ld	s2,0(sp)
    80003dea:	bfbd                	j	80003d68 <ilock+0x1e>
      panic("ilock: no type");
    80003dec:	00005517          	auipc	a0,0x5
    80003df0:	92450513          	addi	a0,a0,-1756 # 80008710 <etext+0x710>
    80003df4:	a31fc0ef          	jal	80000824 <panic>

0000000080003df8 <iunlock>:
{
    80003df8:	1101                	addi	sp,sp,-32
    80003dfa:	ec06                	sd	ra,24(sp)
    80003dfc:	e822                	sd	s0,16(sp)
    80003dfe:	e426                	sd	s1,8(sp)
    80003e00:	e04a                	sd	s2,0(sp)
    80003e02:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e04:	c505                	beqz	a0,80003e2c <iunlock+0x34>
    80003e06:	84aa                	mv	s1,a0
    80003e08:	01050913          	addi	s2,a0,16
    80003e0c:	854a                	mv	a0,s2
    80003e0e:	45b000ef          	jal	80004a68 <holdingsleep>
    80003e12:	cd09                	beqz	a0,80003e2c <iunlock+0x34>
    80003e14:	449c                	lw	a5,8(s1)
    80003e16:	00f05b63          	blez	a5,80003e2c <iunlock+0x34>
  releasesleep(&ip->lock);
    80003e1a:	854a                	mv	a0,s2
    80003e1c:	415000ef          	jal	80004a30 <releasesleep>
}
    80003e20:	60e2                	ld	ra,24(sp)
    80003e22:	6442                	ld	s0,16(sp)
    80003e24:	64a2                	ld	s1,8(sp)
    80003e26:	6902                	ld	s2,0(sp)
    80003e28:	6105                	addi	sp,sp,32
    80003e2a:	8082                	ret
    panic("iunlock");
    80003e2c:	00005517          	auipc	a0,0x5
    80003e30:	8f450513          	addi	a0,a0,-1804 # 80008720 <etext+0x720>
    80003e34:	9f1fc0ef          	jal	80000824 <panic>

0000000080003e38 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e38:	7179                	addi	sp,sp,-48
    80003e3a:	f406                	sd	ra,40(sp)
    80003e3c:	f022                	sd	s0,32(sp)
    80003e3e:	ec26                	sd	s1,24(sp)
    80003e40:	e84a                	sd	s2,16(sp)
    80003e42:	e44e                	sd	s3,8(sp)
    80003e44:	1800                	addi	s0,sp,48
    80003e46:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e48:	05050493          	addi	s1,a0,80
    80003e4c:	08050913          	addi	s2,a0,128
    80003e50:	a021                	j	80003e58 <itrunc+0x20>
    80003e52:	0491                	addi	s1,s1,4
    80003e54:	01248b63          	beq	s1,s2,80003e6a <itrunc+0x32>
    if(ip->addrs[i]){
    80003e58:	408c                	lw	a1,0(s1)
    80003e5a:	dde5                	beqz	a1,80003e52 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e5c:	0009a503          	lw	a0,0(s3)
    80003e60:	a47ff0ef          	jal	800038a6 <bfree>
      ip->addrs[i] = 0;
    80003e64:	0004a023          	sw	zero,0(s1)
    80003e68:	b7ed                	j	80003e52 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e6a:	0809a583          	lw	a1,128(s3)
    80003e6e:	ed89                	bnez	a1,80003e88 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e70:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e74:	854e                	mv	a0,s3
    80003e76:	e21ff0ef          	jal	80003c96 <iupdate>
}
    80003e7a:	70a2                	ld	ra,40(sp)
    80003e7c:	7402                	ld	s0,32(sp)
    80003e7e:	64e2                	ld	s1,24(sp)
    80003e80:	6942                	ld	s2,16(sp)
    80003e82:	69a2                	ld	s3,8(sp)
    80003e84:	6145                	addi	sp,sp,48
    80003e86:	8082                	ret
    80003e88:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e8a:	0009a503          	lw	a0,0(s3)
    80003e8e:	825ff0ef          	jal	800036b2 <bread>
    80003e92:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e94:	05850493          	addi	s1,a0,88
    80003e98:	45850913          	addi	s2,a0,1112
    80003e9c:	a021                	j	80003ea4 <itrunc+0x6c>
    80003e9e:	0491                	addi	s1,s1,4
    80003ea0:	01248963          	beq	s1,s2,80003eb2 <itrunc+0x7a>
      if(a[j])
    80003ea4:	408c                	lw	a1,0(s1)
    80003ea6:	dde5                	beqz	a1,80003e9e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003ea8:	0009a503          	lw	a0,0(s3)
    80003eac:	9fbff0ef          	jal	800038a6 <bfree>
    80003eb0:	b7fd                	j	80003e9e <itrunc+0x66>
    brelse(bp);
    80003eb2:	8552                	mv	a0,s4
    80003eb4:	907ff0ef          	jal	800037ba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003eb8:	0809a583          	lw	a1,128(s3)
    80003ebc:	0009a503          	lw	a0,0(s3)
    80003ec0:	9e7ff0ef          	jal	800038a6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ec4:	0809a023          	sw	zero,128(s3)
    80003ec8:	6a02                	ld	s4,0(sp)
    80003eca:	b75d                	j	80003e70 <itrunc+0x38>

0000000080003ecc <iput>:
{
    80003ecc:	1101                	addi	sp,sp,-32
    80003ece:	ec06                	sd	ra,24(sp)
    80003ed0:	e822                	sd	s0,16(sp)
    80003ed2:	e426                	sd	s1,8(sp)
    80003ed4:	1000                	addi	s0,sp,32
    80003ed6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003ed8:	02260517          	auipc	a0,0x2260
    80003edc:	f9850513          	addi	a0,a0,-104 # 82263e70 <itable>
    80003ee0:	d49fc0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ee4:	4498                	lw	a4,8(s1)
    80003ee6:	4785                	li	a5,1
    80003ee8:	02f70063          	beq	a4,a5,80003f08 <iput+0x3c>
  ip->ref--;
    80003eec:	449c                	lw	a5,8(s1)
    80003eee:	37fd                	addiw	a5,a5,-1
    80003ef0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ef2:	02260517          	auipc	a0,0x2260
    80003ef6:	f7e50513          	addi	a0,a0,-130 # 82263e70 <itable>
    80003efa:	dc3fc0ef          	jal	80000cbc <release>
}
    80003efe:	60e2                	ld	ra,24(sp)
    80003f00:	6442                	ld	s0,16(sp)
    80003f02:	64a2                	ld	s1,8(sp)
    80003f04:	6105                	addi	sp,sp,32
    80003f06:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f08:	40bc                	lw	a5,64(s1)
    80003f0a:	d3ed                	beqz	a5,80003eec <iput+0x20>
    80003f0c:	04a49783          	lh	a5,74(s1)
    80003f10:	fff1                	bnez	a5,80003eec <iput+0x20>
    80003f12:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003f14:	01048793          	addi	a5,s1,16
    80003f18:	893e                	mv	s2,a5
    80003f1a:	853e                	mv	a0,a5
    80003f1c:	2cf000ef          	jal	800049ea <acquiresleep>
    release(&itable.lock);
    80003f20:	02260517          	auipc	a0,0x2260
    80003f24:	f5050513          	addi	a0,a0,-176 # 82263e70 <itable>
    80003f28:	d95fc0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	f0bff0ef          	jal	80003e38 <itrunc>
    ip->type = 0;
    80003f32:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f36:	8526                	mv	a0,s1
    80003f38:	d5fff0ef          	jal	80003c96 <iupdate>
    ip->valid = 0;
    80003f3c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f40:	854a                	mv	a0,s2
    80003f42:	2ef000ef          	jal	80004a30 <releasesleep>
    acquire(&itable.lock);
    80003f46:	02260517          	auipc	a0,0x2260
    80003f4a:	f2a50513          	addi	a0,a0,-214 # 82263e70 <itable>
    80003f4e:	cdbfc0ef          	jal	80000c28 <acquire>
    80003f52:	6902                	ld	s2,0(sp)
    80003f54:	bf61                	j	80003eec <iput+0x20>

0000000080003f56 <iunlockput>:
{
    80003f56:	1101                	addi	sp,sp,-32
    80003f58:	ec06                	sd	ra,24(sp)
    80003f5a:	e822                	sd	s0,16(sp)
    80003f5c:	e426                	sd	s1,8(sp)
    80003f5e:	1000                	addi	s0,sp,32
    80003f60:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f62:	e97ff0ef          	jal	80003df8 <iunlock>
  iput(ip);
    80003f66:	8526                	mv	a0,s1
    80003f68:	f65ff0ef          	jal	80003ecc <iput>
}
    80003f6c:	60e2                	ld	ra,24(sp)
    80003f6e:	6442                	ld	s0,16(sp)
    80003f70:	64a2                	ld	s1,8(sp)
    80003f72:	6105                	addi	sp,sp,32
    80003f74:	8082                	ret

0000000080003f76 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003f76:	02260717          	auipc	a4,0x2260
    80003f7a:	ee672703          	lw	a4,-282(a4) # 82263e5c <sb+0xc>
    80003f7e:	4785                	li	a5,1
    80003f80:	0ae7fe63          	bgeu	a5,a4,8000403c <ireclaim+0xc6>
{
    80003f84:	7139                	addi	sp,sp,-64
    80003f86:	fc06                	sd	ra,56(sp)
    80003f88:	f822                	sd	s0,48(sp)
    80003f8a:	f426                	sd	s1,40(sp)
    80003f8c:	f04a                	sd	s2,32(sp)
    80003f8e:	ec4e                	sd	s3,24(sp)
    80003f90:	e852                	sd	s4,16(sp)
    80003f92:	e456                	sd	s5,8(sp)
    80003f94:	e05a                	sd	s6,0(sp)
    80003f96:	0080                	addi	s0,sp,64
    80003f98:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003f9a:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003f9c:	02260a17          	auipc	s4,0x2260
    80003fa0:	eb4a0a13          	addi	s4,s4,-332 # 82263e50 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003fa4:	00004b17          	auipc	s6,0x4
    80003fa8:	784b0b13          	addi	s6,s6,1924 # 80008728 <etext+0x728>
    80003fac:	a099                	j	80003ff2 <ireclaim+0x7c>
    80003fae:	85ce                	mv	a1,s3
    80003fb0:	855a                	mv	a0,s6
    80003fb2:	d48fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003fb6:	85ce                	mv	a1,s3
    80003fb8:	8556                	mv	a0,s5
    80003fba:	b1fff0ef          	jal	80003ad8 <iget>
    80003fbe:	89aa                	mv	s3,a0
    brelse(bp);
    80003fc0:	854a                	mv	a0,s2
    80003fc2:	ff8ff0ef          	jal	800037ba <brelse>
    if (ip) {
    80003fc6:	00098f63          	beqz	s3,80003fe4 <ireclaim+0x6e>
      begin_op();
    80003fca:	78c000ef          	jal	80004756 <begin_op>
      ilock(ip);
    80003fce:	854e                	mv	a0,s3
    80003fd0:	d7bff0ef          	jal	80003d4a <ilock>
      iunlock(ip);
    80003fd4:	854e                	mv	a0,s3
    80003fd6:	e23ff0ef          	jal	80003df8 <iunlock>
      iput(ip);
    80003fda:	854e                	mv	a0,s3
    80003fdc:	ef1ff0ef          	jal	80003ecc <iput>
      end_op();
    80003fe0:	7e6000ef          	jal	800047c6 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003fe4:	0485                	addi	s1,s1,1
    80003fe6:	00ca2703          	lw	a4,12(s4)
    80003fea:	0004879b          	sext.w	a5,s1
    80003fee:	02e7fd63          	bgeu	a5,a4,80004028 <ireclaim+0xb2>
    80003ff2:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003ff6:	0044d593          	srli	a1,s1,0x4
    80003ffa:	018a2783          	lw	a5,24(s4)
    80003ffe:	9dbd                	addw	a1,a1,a5
    80004000:	8556                	mv	a0,s5
    80004002:	eb0ff0ef          	jal	800036b2 <bread>
    80004006:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80004008:	05850793          	addi	a5,a0,88
    8000400c:	00f9f713          	andi	a4,s3,15
    80004010:	071a                	slli	a4,a4,0x6
    80004012:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80004014:	00079703          	lh	a4,0(a5)
    80004018:	c701                	beqz	a4,80004020 <ireclaim+0xaa>
    8000401a:	00679783          	lh	a5,6(a5)
    8000401e:	dbc1                	beqz	a5,80003fae <ireclaim+0x38>
    brelse(bp);
    80004020:	854a                	mv	a0,s2
    80004022:	f98ff0ef          	jal	800037ba <brelse>
    if (ip) {
    80004026:	bf7d                	j	80003fe4 <ireclaim+0x6e>
}
    80004028:	70e2                	ld	ra,56(sp)
    8000402a:	7442                	ld	s0,48(sp)
    8000402c:	74a2                	ld	s1,40(sp)
    8000402e:	7902                	ld	s2,32(sp)
    80004030:	69e2                	ld	s3,24(sp)
    80004032:	6a42                	ld	s4,16(sp)
    80004034:	6aa2                	ld	s5,8(sp)
    80004036:	6b02                	ld	s6,0(sp)
    80004038:	6121                	addi	sp,sp,64
    8000403a:	8082                	ret
    8000403c:	8082                	ret

000000008000403e <fsinit>:
fsinit(int dev) {
    8000403e:	1101                	addi	sp,sp,-32
    80004040:	ec06                	sd	ra,24(sp)
    80004042:	e822                	sd	s0,16(sp)
    80004044:	e426                	sd	s1,8(sp)
    80004046:	e04a                	sd	s2,0(sp)
    80004048:	1000                	addi	s0,sp,32
    8000404a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000404c:	4585                	li	a1,1
    8000404e:	e64ff0ef          	jal	800036b2 <bread>
    80004052:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004054:	02000613          	li	a2,32
    80004058:	05850593          	addi	a1,a0,88
    8000405c:	02260517          	auipc	a0,0x2260
    80004060:	df450513          	addi	a0,a0,-524 # 82263e50 <sb>
    80004064:	cf5fc0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80004068:	8526                	mv	a0,s1
    8000406a:	f50ff0ef          	jal	800037ba <brelse>
  if(sb.magic != FSMAGIC)
    8000406e:	02260717          	auipc	a4,0x2260
    80004072:	de272703          	lw	a4,-542(a4) # 82263e50 <sb>
    80004076:	102037b7          	lui	a5,0x10203
    8000407a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000407e:	02f71263          	bne	a4,a5,800040a2 <fsinit+0x64>
  initlog(dev, &sb);
    80004082:	02260597          	auipc	a1,0x2260
    80004086:	dce58593          	addi	a1,a1,-562 # 82263e50 <sb>
    8000408a:	854a                	mv	a0,s2
    8000408c:	648000ef          	jal	800046d4 <initlog>
  ireclaim(dev);
    80004090:	854a                	mv	a0,s2
    80004092:	ee5ff0ef          	jal	80003f76 <ireclaim>
}
    80004096:	60e2                	ld	ra,24(sp)
    80004098:	6442                	ld	s0,16(sp)
    8000409a:	64a2                	ld	s1,8(sp)
    8000409c:	6902                	ld	s2,0(sp)
    8000409e:	6105                	addi	sp,sp,32
    800040a0:	8082                	ret
    panic("invalid file system");
    800040a2:	00004517          	auipc	a0,0x4
    800040a6:	6a650513          	addi	a0,a0,1702 # 80008748 <etext+0x748>
    800040aa:	f7afc0ef          	jal	80000824 <panic>

00000000800040ae <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800040ae:	1141                	addi	sp,sp,-16
    800040b0:	e406                	sd	ra,8(sp)
    800040b2:	e022                	sd	s0,0(sp)
    800040b4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800040b6:	411c                	lw	a5,0(a0)
    800040b8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800040ba:	415c                	lw	a5,4(a0)
    800040bc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800040be:	04451783          	lh	a5,68(a0)
    800040c2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800040c6:	04a51783          	lh	a5,74(a0)
    800040ca:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800040ce:	04c56783          	lwu	a5,76(a0)
    800040d2:	e99c                	sd	a5,16(a1)
}
    800040d4:	60a2                	ld	ra,8(sp)
    800040d6:	6402                	ld	s0,0(sp)
    800040d8:	0141                	addi	sp,sp,16
    800040da:	8082                	ret

00000000800040dc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040dc:	457c                	lw	a5,76(a0)
    800040de:	0ed7e663          	bltu	a5,a3,800041ca <readi+0xee>
{
    800040e2:	7159                	addi	sp,sp,-112
    800040e4:	f486                	sd	ra,104(sp)
    800040e6:	f0a2                	sd	s0,96(sp)
    800040e8:	eca6                	sd	s1,88(sp)
    800040ea:	e0d2                	sd	s4,64(sp)
    800040ec:	fc56                	sd	s5,56(sp)
    800040ee:	f85a                	sd	s6,48(sp)
    800040f0:	f45e                	sd	s7,40(sp)
    800040f2:	1880                	addi	s0,sp,112
    800040f4:	8b2a                	mv	s6,a0
    800040f6:	8bae                	mv	s7,a1
    800040f8:	8a32                	mv	s4,a2
    800040fa:	84b6                	mv	s1,a3
    800040fc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800040fe:	9f35                	addw	a4,a4,a3
    return 0;
    80004100:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004102:	0ad76b63          	bltu	a4,a3,800041b8 <readi+0xdc>
    80004106:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004108:	00e7f463          	bgeu	a5,a4,80004110 <readi+0x34>
    n = ip->size - off;
    8000410c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004110:	080a8b63          	beqz	s5,800041a6 <readi+0xca>
    80004114:	e8ca                	sd	s2,80(sp)
    80004116:	f062                	sd	s8,32(sp)
    80004118:	ec66                	sd	s9,24(sp)
    8000411a:	e86a                	sd	s10,16(sp)
    8000411c:	e46e                	sd	s11,8(sp)
    8000411e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004120:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004124:	5c7d                	li	s8,-1
    80004126:	a80d                	j	80004158 <readi+0x7c>
    80004128:	020d1d93          	slli	s11,s10,0x20
    8000412c:	020ddd93          	srli	s11,s11,0x20
    80004130:	05890613          	addi	a2,s2,88
    80004134:	86ee                	mv	a3,s11
    80004136:	963e                	add	a2,a2,a5
    80004138:	85d2                	mv	a1,s4
    8000413a:	855e                	mv	a0,s7
    8000413c:	a51fe0ef          	jal	80002b8c <either_copyout>
    80004140:	05850363          	beq	a0,s8,80004186 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004144:	854a                	mv	a0,s2
    80004146:	e74ff0ef          	jal	800037ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000414a:	013d09bb          	addw	s3,s10,s3
    8000414e:	009d04bb          	addw	s1,s10,s1
    80004152:	9a6e                	add	s4,s4,s11
    80004154:	0559f363          	bgeu	s3,s5,8000419a <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80004158:	00a4d59b          	srliw	a1,s1,0xa
    8000415c:	855a                	mv	a0,s6
    8000415e:	8bbff0ef          	jal	80003a18 <bmap>
    80004162:	85aa                	mv	a1,a0
    if(addr == 0)
    80004164:	c139                	beqz	a0,800041aa <readi+0xce>
    bp = bread(ip->dev, addr);
    80004166:	000b2503          	lw	a0,0(s6)
    8000416a:	d48ff0ef          	jal	800036b2 <bread>
    8000416e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004170:	3ff4f793          	andi	a5,s1,1023
    80004174:	40fc873b          	subw	a4,s9,a5
    80004178:	413a86bb          	subw	a3,s5,s3
    8000417c:	8d3a                	mv	s10,a4
    8000417e:	fae6f5e3          	bgeu	a3,a4,80004128 <readi+0x4c>
    80004182:	8d36                	mv	s10,a3
    80004184:	b755                	j	80004128 <readi+0x4c>
      brelse(bp);
    80004186:	854a                	mv	a0,s2
    80004188:	e32ff0ef          	jal	800037ba <brelse>
      tot = -1;
    8000418c:	59fd                	li	s3,-1
      break;
    8000418e:	6946                	ld	s2,80(sp)
    80004190:	7c02                	ld	s8,32(sp)
    80004192:	6ce2                	ld	s9,24(sp)
    80004194:	6d42                	ld	s10,16(sp)
    80004196:	6da2                	ld	s11,8(sp)
    80004198:	a831                	j	800041b4 <readi+0xd8>
    8000419a:	6946                	ld	s2,80(sp)
    8000419c:	7c02                	ld	s8,32(sp)
    8000419e:	6ce2                	ld	s9,24(sp)
    800041a0:	6d42                	ld	s10,16(sp)
    800041a2:	6da2                	ld	s11,8(sp)
    800041a4:	a801                	j	800041b4 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041a6:	89d6                	mv	s3,s5
    800041a8:	a031                	j	800041b4 <readi+0xd8>
    800041aa:	6946                	ld	s2,80(sp)
    800041ac:	7c02                	ld	s8,32(sp)
    800041ae:	6ce2                	ld	s9,24(sp)
    800041b0:	6d42                	ld	s10,16(sp)
    800041b2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800041b4:	854e                	mv	a0,s3
    800041b6:	69a6                	ld	s3,72(sp)
}
    800041b8:	70a6                	ld	ra,104(sp)
    800041ba:	7406                	ld	s0,96(sp)
    800041bc:	64e6                	ld	s1,88(sp)
    800041be:	6a06                	ld	s4,64(sp)
    800041c0:	7ae2                	ld	s5,56(sp)
    800041c2:	7b42                	ld	s6,48(sp)
    800041c4:	7ba2                	ld	s7,40(sp)
    800041c6:	6165                	addi	sp,sp,112
    800041c8:	8082                	ret
    return 0;
    800041ca:	4501                	li	a0,0
}
    800041cc:	8082                	ret

00000000800041ce <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800041ce:	457c                	lw	a5,76(a0)
    800041d0:	0ed7eb63          	bltu	a5,a3,800042c6 <writei+0xf8>
{
    800041d4:	7159                	addi	sp,sp,-112
    800041d6:	f486                	sd	ra,104(sp)
    800041d8:	f0a2                	sd	s0,96(sp)
    800041da:	e8ca                	sd	s2,80(sp)
    800041dc:	e0d2                	sd	s4,64(sp)
    800041de:	fc56                	sd	s5,56(sp)
    800041e0:	f85a                	sd	s6,48(sp)
    800041e2:	f45e                	sd	s7,40(sp)
    800041e4:	1880                	addi	s0,sp,112
    800041e6:	8aaa                	mv	s5,a0
    800041e8:	8bae                	mv	s7,a1
    800041ea:	8a32                	mv	s4,a2
    800041ec:	8936                	mv	s2,a3
    800041ee:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800041f0:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE){
    800041f4:	00043737          	lui	a4,0x43
    800041f8:	0cf76963          	bltu	a4,a5,800042ca <writei+0xfc>
    800041fc:	0cd7e763          	bltu	a5,a3,800042ca <writei+0xfc>
    80004200:	e4ce                	sd	s3,72(sp)
    return -1;
  }
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004202:	0a0b0a63          	beqz	s6,800042b6 <writei+0xe8>
    80004206:	eca6                	sd	s1,88(sp)
    80004208:	f062                	sd	s8,32(sp)
    8000420a:	ec66                	sd	s9,24(sp)
    8000420c:	e86a                	sd	s10,16(sp)
    8000420e:	e46e                	sd	s11,8(sp)
    80004210:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004212:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004216:	5c7d                	li	s8,-1
    80004218:	a825                	j	80004250 <writei+0x82>
    8000421a:	020d1d93          	slli	s11,s10,0x20
    8000421e:	020ddd93          	srli	s11,s11,0x20
    80004222:	05848513          	addi	a0,s1,88
    80004226:	86ee                	mv	a3,s11
    80004228:	8652                	mv	a2,s4
    8000422a:	85de                	mv	a1,s7
    8000422c:	953e                	add	a0,a0,a5
    8000422e:	9a9fe0ef          	jal	80002bd6 <either_copyin>
    80004232:	05850663          	beq	a0,s8,8000427e <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004236:	8526                	mv	a0,s1
    80004238:	6b8000ef          	jal	800048f0 <log_write>
    brelse(bp);
    8000423c:	8526                	mv	a0,s1
    8000423e:	d7cff0ef          	jal	800037ba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004242:	013d09bb          	addw	s3,s10,s3
    80004246:	012d093b          	addw	s2,s10,s2
    8000424a:	9a6e                	add	s4,s4,s11
    8000424c:	0369fc63          	bgeu	s3,s6,80004284 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80004250:	00a9559b          	srliw	a1,s2,0xa
    80004254:	8556                	mv	a0,s5
    80004256:	fc2ff0ef          	jal	80003a18 <bmap>
    8000425a:	85aa                	mv	a1,a0
    if(addr == 0)
    8000425c:	c505                	beqz	a0,80004284 <writei+0xb6>
    bp = bread(ip->dev, addr);
    8000425e:	000aa503          	lw	a0,0(s5)
    80004262:	c50ff0ef          	jal	800036b2 <bread>
    80004266:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004268:	3ff97793          	andi	a5,s2,1023
    8000426c:	40fc873b          	subw	a4,s9,a5
    80004270:	413b06bb          	subw	a3,s6,s3
    80004274:	8d3a                	mv	s10,a4
    80004276:	fae6f2e3          	bgeu	a3,a4,8000421a <writei+0x4c>
    8000427a:	8d36                	mv	s10,a3
    8000427c:	bf79                	j	8000421a <writei+0x4c>
      brelse(bp);
    8000427e:	8526                	mv	a0,s1
    80004280:	d3aff0ef          	jal	800037ba <brelse>
  }

  if(off > ip->size)
    80004284:	04caa783          	lw	a5,76(s5)
    80004288:	0327f963          	bgeu	a5,s2,800042ba <writei+0xec>
    ip->size = off;
    8000428c:	052aa623          	sw	s2,76(s5)
    80004290:	64e6                	ld	s1,88(sp)
    80004292:	7c02                	ld	s8,32(sp)
    80004294:	6ce2                	ld	s9,24(sp)
    80004296:	6d42                	ld	s10,16(sp)
    80004298:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000429a:	8556                	mv	a0,s5
    8000429c:	9fbff0ef          	jal	80003c96 <iupdate>

  return tot;
    800042a0:	854e                	mv	a0,s3
    800042a2:	69a6                	ld	s3,72(sp)
}
    800042a4:	70a6                	ld	ra,104(sp)
    800042a6:	7406                	ld	s0,96(sp)
    800042a8:	6946                	ld	s2,80(sp)
    800042aa:	6a06                	ld	s4,64(sp)
    800042ac:	7ae2                	ld	s5,56(sp)
    800042ae:	7b42                	ld	s6,48(sp)
    800042b0:	7ba2                	ld	s7,40(sp)
    800042b2:	6165                	addi	sp,sp,112
    800042b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042b6:	89da                	mv	s3,s6
    800042b8:	b7cd                	j	8000429a <writei+0xcc>
    800042ba:	64e6                	ld	s1,88(sp)
    800042bc:	7c02                	ld	s8,32(sp)
    800042be:	6ce2                	ld	s9,24(sp)
    800042c0:	6d42                	ld	s10,16(sp)
    800042c2:	6da2                	ld	s11,8(sp)
    800042c4:	bfd9                	j	8000429a <writei+0xcc>
    return -1;
    800042c6:	557d                	li	a0,-1
}
    800042c8:	8082                	ret
    return -1;
    800042ca:	557d                	li	a0,-1
    800042cc:	bfe1                	j	800042a4 <writei+0xd6>

00000000800042ce <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800042ce:	1141                	addi	sp,sp,-16
    800042d0:	e406                	sd	ra,8(sp)
    800042d2:	e022                	sd	s0,0(sp)
    800042d4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800042d6:	4639                	li	a2,14
    800042d8:	af5fc0ef          	jal	80000dcc <strncmp>
}
    800042dc:	60a2                	ld	ra,8(sp)
    800042de:	6402                	ld	s0,0(sp)
    800042e0:	0141                	addi	sp,sp,16
    800042e2:	8082                	ret

00000000800042e4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800042e4:	711d                	addi	sp,sp,-96
    800042e6:	ec86                	sd	ra,88(sp)
    800042e8:	e8a2                	sd	s0,80(sp)
    800042ea:	e4a6                	sd	s1,72(sp)
    800042ec:	e0ca                	sd	s2,64(sp)
    800042ee:	fc4e                	sd	s3,56(sp)
    800042f0:	f852                	sd	s4,48(sp)
    800042f2:	f456                	sd	s5,40(sp)
    800042f4:	f05a                	sd	s6,32(sp)
    800042f6:	ec5e                	sd	s7,24(sp)
    800042f8:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800042fa:	04451703          	lh	a4,68(a0)
    800042fe:	4785                	li	a5,1
    80004300:	00f71f63          	bne	a4,a5,8000431e <dirlookup+0x3a>
    80004304:	892a                	mv	s2,a0
    80004306:	8aae                	mv	s5,a1
    80004308:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000430a:	457c                	lw	a5,76(a0)
    8000430c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000430e:	fa040a13          	addi	s4,s0,-96
    80004312:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004314:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004318:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000431a:	e39d                	bnez	a5,80004340 <dirlookup+0x5c>
    8000431c:	a8b9                	j	8000437a <dirlookup+0x96>
    panic("dirlookup not DIR");
    8000431e:	00004517          	auipc	a0,0x4
    80004322:	44250513          	addi	a0,a0,1090 # 80008760 <etext+0x760>
    80004326:	cfefc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    8000432a:	00004517          	auipc	a0,0x4
    8000432e:	44e50513          	addi	a0,a0,1102 # 80008778 <etext+0x778>
    80004332:	cf2fc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004336:	24c1                	addiw	s1,s1,16
    80004338:	04c92783          	lw	a5,76(s2)
    8000433c:	02f4fe63          	bgeu	s1,a5,80004378 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004340:	874e                	mv	a4,s3
    80004342:	86a6                	mv	a3,s1
    80004344:	8652                	mv	a2,s4
    80004346:	4581                	li	a1,0
    80004348:	854a                	mv	a0,s2
    8000434a:	d93ff0ef          	jal	800040dc <readi>
    8000434e:	fd351ee3          	bne	a0,s3,8000432a <dirlookup+0x46>
    if(de.inum == 0)
    80004352:	fa045783          	lhu	a5,-96(s0)
    80004356:	d3e5                	beqz	a5,80004336 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80004358:	85da                	mv	a1,s6
    8000435a:	8556                	mv	a0,s5
    8000435c:	f73ff0ef          	jal	800042ce <namecmp>
    80004360:	f979                	bnez	a0,80004336 <dirlookup+0x52>
      if(poff)
    80004362:	000b8463          	beqz	s7,8000436a <dirlookup+0x86>
        *poff = off;
    80004366:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000436a:	fa045583          	lhu	a1,-96(s0)
    8000436e:	00092503          	lw	a0,0(s2)
    80004372:	f66ff0ef          	jal	80003ad8 <iget>
    80004376:	a011                	j	8000437a <dirlookup+0x96>
  return 0;
    80004378:	4501                	li	a0,0
}
    8000437a:	60e6                	ld	ra,88(sp)
    8000437c:	6446                	ld	s0,80(sp)
    8000437e:	64a6                	ld	s1,72(sp)
    80004380:	6906                	ld	s2,64(sp)
    80004382:	79e2                	ld	s3,56(sp)
    80004384:	7a42                	ld	s4,48(sp)
    80004386:	7aa2                	ld	s5,40(sp)
    80004388:	7b02                	ld	s6,32(sp)
    8000438a:	6be2                	ld	s7,24(sp)
    8000438c:	6125                	addi	sp,sp,96
    8000438e:	8082                	ret

0000000080004390 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004390:	711d                	addi	sp,sp,-96
    80004392:	ec86                	sd	ra,88(sp)
    80004394:	e8a2                	sd	s0,80(sp)
    80004396:	e4a6                	sd	s1,72(sp)
    80004398:	e0ca                	sd	s2,64(sp)
    8000439a:	fc4e                	sd	s3,56(sp)
    8000439c:	f852                	sd	s4,48(sp)
    8000439e:	f456                	sd	s5,40(sp)
    800043a0:	f05a                	sd	s6,32(sp)
    800043a2:	ec5e                	sd	s7,24(sp)
    800043a4:	e862                	sd	s8,16(sp)
    800043a6:	e466                	sd	s9,8(sp)
    800043a8:	e06a                	sd	s10,0(sp)
    800043aa:	1080                	addi	s0,sp,96
    800043ac:	84aa                	mv	s1,a0
    800043ae:	8b2e                	mv	s6,a1
    800043b0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800043b2:	00054703          	lbu	a4,0(a0)
    800043b6:	02f00793          	li	a5,47
    800043ba:	00f70f63          	beq	a4,a5,800043d8 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800043be:	cf7fd0ef          	jal	800020b4 <myproc>
    800043c2:	15053503          	ld	a0,336(a0)
    800043c6:	94fff0ef          	jal	80003d14 <idup>
    800043ca:	8a2a                	mv	s4,a0
  while(*path == '/')
    800043cc:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800043d0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800043d2:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800043d4:	4b85                	li	s7,1
    800043d6:	a879                	j	80004474 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800043d8:	4585                	li	a1,1
    800043da:	852e                	mv	a0,a1
    800043dc:	efcff0ef          	jal	80003ad8 <iget>
    800043e0:	8a2a                	mv	s4,a0
    800043e2:	b7ed                	j	800043cc <namex+0x3c>
      iunlockput(ip);
    800043e4:	8552                	mv	a0,s4
    800043e6:	b71ff0ef          	jal	80003f56 <iunlockput>
      return 0;
    800043ea:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800043ec:	8552                	mv	a0,s4
    800043ee:	60e6                	ld	ra,88(sp)
    800043f0:	6446                	ld	s0,80(sp)
    800043f2:	64a6                	ld	s1,72(sp)
    800043f4:	6906                	ld	s2,64(sp)
    800043f6:	79e2                	ld	s3,56(sp)
    800043f8:	7a42                	ld	s4,48(sp)
    800043fa:	7aa2                	ld	s5,40(sp)
    800043fc:	7b02                	ld	s6,32(sp)
    800043fe:	6be2                	ld	s7,24(sp)
    80004400:	6c42                	ld	s8,16(sp)
    80004402:	6ca2                	ld	s9,8(sp)
    80004404:	6d02                	ld	s10,0(sp)
    80004406:	6125                	addi	sp,sp,96
    80004408:	8082                	ret
      iunlock(ip);
    8000440a:	8552                	mv	a0,s4
    8000440c:	9edff0ef          	jal	80003df8 <iunlock>
      return ip;
    80004410:	bff1                	j	800043ec <namex+0x5c>
      iunlockput(ip);
    80004412:	8552                	mv	a0,s4
    80004414:	b43ff0ef          	jal	80003f56 <iunlockput>
      return 0;
    80004418:	8a4a                	mv	s4,s2
    8000441a:	bfc9                	j	800043ec <namex+0x5c>
  len = path - s;
    8000441c:	40990633          	sub	a2,s2,s1
    80004420:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004424:	09ac5463          	bge	s8,s10,800044ac <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80004428:	8666                	mv	a2,s9
    8000442a:	85a6                	mv	a1,s1
    8000442c:	8556                	mv	a0,s5
    8000442e:	92bfc0ef          	jal	80000d58 <memmove>
    80004432:	84ca                	mv	s1,s2
  while(*path == '/')
    80004434:	0004c783          	lbu	a5,0(s1)
    80004438:	01379763          	bne	a5,s3,80004446 <namex+0xb6>
    path++;
    8000443c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000443e:	0004c783          	lbu	a5,0(s1)
    80004442:	ff378de3          	beq	a5,s3,8000443c <namex+0xac>
    ilock(ip);
    80004446:	8552                	mv	a0,s4
    80004448:	903ff0ef          	jal	80003d4a <ilock>
    if(ip->type != T_DIR){
    8000444c:	044a1783          	lh	a5,68(s4)
    80004450:	f9779ae3          	bne	a5,s7,800043e4 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80004454:	000b0563          	beqz	s6,8000445e <namex+0xce>
    80004458:	0004c783          	lbu	a5,0(s1)
    8000445c:	d7dd                	beqz	a5,8000440a <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000445e:	4601                	li	a2,0
    80004460:	85d6                	mv	a1,s5
    80004462:	8552                	mv	a0,s4
    80004464:	e81ff0ef          	jal	800042e4 <dirlookup>
    80004468:	892a                	mv	s2,a0
    8000446a:	d545                	beqz	a0,80004412 <namex+0x82>
    iunlockput(ip);
    8000446c:	8552                	mv	a0,s4
    8000446e:	ae9ff0ef          	jal	80003f56 <iunlockput>
    ip = next;
    80004472:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004474:	0004c783          	lbu	a5,0(s1)
    80004478:	01379763          	bne	a5,s3,80004486 <namex+0xf6>
    path++;
    8000447c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000447e:	0004c783          	lbu	a5,0(s1)
    80004482:	ff378de3          	beq	a5,s3,8000447c <namex+0xec>
  if(*path == 0)
    80004486:	cf8d                	beqz	a5,800044c0 <namex+0x130>
  while(*path != '/' && *path != 0)
    80004488:	0004c783          	lbu	a5,0(s1)
    8000448c:	fd178713          	addi	a4,a5,-47
    80004490:	cb19                	beqz	a4,800044a6 <namex+0x116>
    80004492:	cb91                	beqz	a5,800044a6 <namex+0x116>
    80004494:	8926                	mv	s2,s1
    path++;
    80004496:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80004498:	00094783          	lbu	a5,0(s2)
    8000449c:	fd178713          	addi	a4,a5,-47
    800044a0:	df35                	beqz	a4,8000441c <namex+0x8c>
    800044a2:	fbf5                	bnez	a5,80004496 <namex+0x106>
    800044a4:	bfa5                	j	8000441c <namex+0x8c>
    800044a6:	8926                	mv	s2,s1
  len = path - s;
    800044a8:	4d01                	li	s10,0
    800044aa:	4601                	li	a2,0
    memmove(name, s, len);
    800044ac:	2601                	sext.w	a2,a2
    800044ae:	85a6                	mv	a1,s1
    800044b0:	8556                	mv	a0,s5
    800044b2:	8a7fc0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    800044b6:	9d56                	add	s10,s10,s5
    800044b8:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7dd984a8>
    800044bc:	84ca                	mv	s1,s2
    800044be:	bf9d                	j	80004434 <namex+0xa4>
  if(nameiparent){
    800044c0:	f20b06e3          	beqz	s6,800043ec <namex+0x5c>
    iput(ip);
    800044c4:	8552                	mv	a0,s4
    800044c6:	a07ff0ef          	jal	80003ecc <iput>
    return 0;
    800044ca:	4a01                	li	s4,0
    800044cc:	b705                	j	800043ec <namex+0x5c>

00000000800044ce <dirlink>:
{
    800044ce:	715d                	addi	sp,sp,-80
    800044d0:	e486                	sd	ra,72(sp)
    800044d2:	e0a2                	sd	s0,64(sp)
    800044d4:	f84a                	sd	s2,48(sp)
    800044d6:	ec56                	sd	s5,24(sp)
    800044d8:	e85a                	sd	s6,16(sp)
    800044da:	0880                	addi	s0,sp,80
    800044dc:	892a                	mv	s2,a0
    800044de:	8aae                	mv	s5,a1
    800044e0:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800044e2:	4601                	li	a2,0
    800044e4:	e01ff0ef          	jal	800042e4 <dirlookup>
    800044e8:	ed1d                	bnez	a0,80004526 <dirlink+0x58>
    800044ea:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044ec:	04c92483          	lw	s1,76(s2)
    800044f0:	c4b9                	beqz	s1,8000453e <dirlink+0x70>
    800044f2:	f44e                	sd	s3,40(sp)
    800044f4:	f052                	sd	s4,32(sp)
    800044f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044f8:	fb040a13          	addi	s4,s0,-80
    800044fc:	49c1                	li	s3,16
    800044fe:	874e                	mv	a4,s3
    80004500:	86a6                	mv	a3,s1
    80004502:	8652                	mv	a2,s4
    80004504:	4581                	li	a1,0
    80004506:	854a                	mv	a0,s2
    80004508:	bd5ff0ef          	jal	800040dc <readi>
    8000450c:	03351163          	bne	a0,s3,8000452e <dirlink+0x60>
    if(de.inum == 0)
    80004510:	fb045783          	lhu	a5,-80(s0)
    80004514:	c39d                	beqz	a5,8000453a <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004516:	24c1                	addiw	s1,s1,16
    80004518:	04c92783          	lw	a5,76(s2)
    8000451c:	fef4e1e3          	bltu	s1,a5,800044fe <dirlink+0x30>
    80004520:	79a2                	ld	s3,40(sp)
    80004522:	7a02                	ld	s4,32(sp)
    80004524:	a829                	j	8000453e <dirlink+0x70>
    iput(ip);
    80004526:	9a7ff0ef          	jal	80003ecc <iput>
    return -1;
    8000452a:	557d                	li	a0,-1
    8000452c:	a83d                	j	8000456a <dirlink+0x9c>
      panic("dirlink read");
    8000452e:	00004517          	auipc	a0,0x4
    80004532:	25a50513          	addi	a0,a0,602 # 80008788 <etext+0x788>
    80004536:	aeefc0ef          	jal	80000824 <panic>
    8000453a:	79a2                	ld	s3,40(sp)
    8000453c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000453e:	4639                	li	a2,14
    80004540:	85d6                	mv	a1,s5
    80004542:	fb240513          	addi	a0,s0,-78
    80004546:	8c1fc0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    8000454a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000454e:	4741                	li	a4,16
    80004550:	86a6                	mv	a3,s1
    80004552:	fb040613          	addi	a2,s0,-80
    80004556:	4581                	li	a1,0
    80004558:	854a                	mv	a0,s2
    8000455a:	c75ff0ef          	jal	800041ce <writei>
    8000455e:	1541                	addi	a0,a0,-16
    80004560:	00a03533          	snez	a0,a0
    80004564:	40a0053b          	negw	a0,a0
    80004568:	74e2                	ld	s1,56(sp)
}
    8000456a:	60a6                	ld	ra,72(sp)
    8000456c:	6406                	ld	s0,64(sp)
    8000456e:	7942                	ld	s2,48(sp)
    80004570:	6ae2                	ld	s5,24(sp)
    80004572:	6b42                	ld	s6,16(sp)
    80004574:	6161                	addi	sp,sp,80
    80004576:	8082                	ret

0000000080004578 <namei>:

struct inode*
namei(char *path)
{
    80004578:	1101                	addi	sp,sp,-32
    8000457a:	ec06                	sd	ra,24(sp)
    8000457c:	e822                	sd	s0,16(sp)
    8000457e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004580:	fe040613          	addi	a2,s0,-32
    80004584:	4581                	li	a1,0
    80004586:	e0bff0ef          	jal	80004390 <namex>
}
    8000458a:	60e2                	ld	ra,24(sp)
    8000458c:	6442                	ld	s0,16(sp)
    8000458e:	6105                	addi	sp,sp,32
    80004590:	8082                	ret

0000000080004592 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004592:	1141                	addi	sp,sp,-16
    80004594:	e406                	sd	ra,8(sp)
    80004596:	e022                	sd	s0,0(sp)
    80004598:	0800                	addi	s0,sp,16
    8000459a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000459c:	4585                	li	a1,1
    8000459e:	df3ff0ef          	jal	80004390 <namex>
}
    800045a2:	60a2                	ld	ra,8(sp)
    800045a4:	6402                	ld	s0,0(sp)
    800045a6:	0141                	addi	sp,sp,16
    800045a8:	8082                	ret

00000000800045aa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800045aa:	1101                	addi	sp,sp,-32
    800045ac:	ec06                	sd	ra,24(sp)
    800045ae:	e822                	sd	s0,16(sp)
    800045b0:	e426                	sd	s1,8(sp)
    800045b2:	e04a                	sd	s2,0(sp)
    800045b4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800045b6:	02261917          	auipc	s2,0x2261
    800045ba:	36290913          	addi	s2,s2,866 # 82265918 <log>
    800045be:	01892583          	lw	a1,24(s2)
    800045c2:	02492503          	lw	a0,36(s2)
    800045c6:	8ecff0ef          	jal	800036b2 <bread>
    800045ca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800045cc:	02892603          	lw	a2,40(s2)
    800045d0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800045d2:	00c05f63          	blez	a2,800045f0 <write_head+0x46>
    800045d6:	02261717          	auipc	a4,0x2261
    800045da:	36e70713          	addi	a4,a4,878 # 82265944 <log+0x2c>
    800045de:	87aa                	mv	a5,a0
    800045e0:	060a                	slli	a2,a2,0x2
    800045e2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800045e4:	4314                	lw	a3,0(a4)
    800045e6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800045e8:	0711                	addi	a4,a4,4
    800045ea:	0791                	addi	a5,a5,4
    800045ec:	fec79ce3          	bne	a5,a2,800045e4 <write_head+0x3a>
  }
  bwrite(buf);
    800045f0:	8526                	mv	a0,s1
    800045f2:	996ff0ef          	jal	80003788 <bwrite>
  brelse(buf);
    800045f6:	8526                	mv	a0,s1
    800045f8:	9c2ff0ef          	jal	800037ba <brelse>
}
    800045fc:	60e2                	ld	ra,24(sp)
    800045fe:	6442                	ld	s0,16(sp)
    80004600:	64a2                	ld	s1,8(sp)
    80004602:	6902                	ld	s2,0(sp)
    80004604:	6105                	addi	sp,sp,32
    80004606:	8082                	ret

0000000080004608 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004608:	02261797          	auipc	a5,0x2261
    8000460c:	3387a783          	lw	a5,824(a5) # 82265940 <log+0x28>
    80004610:	0cf05163          	blez	a5,800046d2 <install_trans+0xca>
{
    80004614:	715d                	addi	sp,sp,-80
    80004616:	e486                	sd	ra,72(sp)
    80004618:	e0a2                	sd	s0,64(sp)
    8000461a:	fc26                	sd	s1,56(sp)
    8000461c:	f84a                	sd	s2,48(sp)
    8000461e:	f44e                	sd	s3,40(sp)
    80004620:	f052                	sd	s4,32(sp)
    80004622:	ec56                	sd	s5,24(sp)
    80004624:	e85a                	sd	s6,16(sp)
    80004626:	e45e                	sd	s7,8(sp)
    80004628:	e062                	sd	s8,0(sp)
    8000462a:	0880                	addi	s0,sp,80
    8000462c:	8b2a                	mv	s6,a0
    8000462e:	02261a97          	auipc	s5,0x2261
    80004632:	316a8a93          	addi	s5,s5,790 # 82265944 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004636:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004638:	00004c17          	auipc	s8,0x4
    8000463c:	160c0c13          	addi	s8,s8,352 # 80008798 <etext+0x798>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004640:	02261a17          	auipc	s4,0x2261
    80004644:	2d8a0a13          	addi	s4,s4,728 # 82265918 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004648:	40000b93          	li	s7,1024
    8000464c:	a025                	j	80004674 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000464e:	000aa603          	lw	a2,0(s5)
    80004652:	85ce                	mv	a1,s3
    80004654:	8562                	mv	a0,s8
    80004656:	ea5fb0ef          	jal	800004fa <printf>
    8000465a:	a839                	j	80004678 <install_trans+0x70>
    brelse(lbuf);
    8000465c:	854a                	mv	a0,s2
    8000465e:	95cff0ef          	jal	800037ba <brelse>
    brelse(dbuf);
    80004662:	8526                	mv	a0,s1
    80004664:	956ff0ef          	jal	800037ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004668:	2985                	addiw	s3,s3,1
    8000466a:	0a91                	addi	s5,s5,4
    8000466c:	028a2783          	lw	a5,40(s4)
    80004670:	04f9d563          	bge	s3,a5,800046ba <install_trans+0xb2>
    if(recovering) {
    80004674:	fc0b1de3          	bnez	s6,8000464e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004678:	018a2583          	lw	a1,24(s4)
    8000467c:	013585bb          	addw	a1,a1,s3
    80004680:	2585                	addiw	a1,a1,1
    80004682:	024a2503          	lw	a0,36(s4)
    80004686:	82cff0ef          	jal	800036b2 <bread>
    8000468a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000468c:	000aa583          	lw	a1,0(s5)
    80004690:	024a2503          	lw	a0,36(s4)
    80004694:	81eff0ef          	jal	800036b2 <bread>
    80004698:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000469a:	865e                	mv	a2,s7
    8000469c:	05890593          	addi	a1,s2,88
    800046a0:	05850513          	addi	a0,a0,88
    800046a4:	eb4fc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    800046a8:	8526                	mv	a0,s1
    800046aa:	8deff0ef          	jal	80003788 <bwrite>
    if(recovering == 0)
    800046ae:	fa0b17e3          	bnez	s6,8000465c <install_trans+0x54>
      bunpin(dbuf);
    800046b2:	8526                	mv	a0,s1
    800046b4:	9beff0ef          	jal	80003872 <bunpin>
    800046b8:	b755                	j	8000465c <install_trans+0x54>
}
    800046ba:	60a6                	ld	ra,72(sp)
    800046bc:	6406                	ld	s0,64(sp)
    800046be:	74e2                	ld	s1,56(sp)
    800046c0:	7942                	ld	s2,48(sp)
    800046c2:	79a2                	ld	s3,40(sp)
    800046c4:	7a02                	ld	s4,32(sp)
    800046c6:	6ae2                	ld	s5,24(sp)
    800046c8:	6b42                	ld	s6,16(sp)
    800046ca:	6ba2                	ld	s7,8(sp)
    800046cc:	6c02                	ld	s8,0(sp)
    800046ce:	6161                	addi	sp,sp,80
    800046d0:	8082                	ret
    800046d2:	8082                	ret

00000000800046d4 <initlog>:
{
    800046d4:	7179                	addi	sp,sp,-48
    800046d6:	f406                	sd	ra,40(sp)
    800046d8:	f022                	sd	s0,32(sp)
    800046da:	ec26                	sd	s1,24(sp)
    800046dc:	e84a                	sd	s2,16(sp)
    800046de:	e44e                	sd	s3,8(sp)
    800046e0:	1800                	addi	s0,sp,48
    800046e2:	84aa                	mv	s1,a0
    800046e4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800046e6:	02261917          	auipc	s2,0x2261
    800046ea:	23290913          	addi	s2,s2,562 # 82265918 <log>
    800046ee:	00004597          	auipc	a1,0x4
    800046f2:	0ca58593          	addi	a1,a1,202 # 800087b8 <etext+0x7b8>
    800046f6:	854a                	mv	a0,s2
    800046f8:	ca6fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    800046fc:	0149a583          	lw	a1,20(s3)
    80004700:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80004704:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80004708:	8526                	mv	a0,s1
    8000470a:	fa9fe0ef          	jal	800036b2 <bread>
  log.lh.n = lh->n;
    8000470e:	4d30                	lw	a2,88(a0)
    80004710:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80004714:	00c05f63          	blez	a2,80004732 <initlog+0x5e>
    80004718:	87aa                	mv	a5,a0
    8000471a:	02261717          	auipc	a4,0x2261
    8000471e:	22a70713          	addi	a4,a4,554 # 82265944 <log+0x2c>
    80004722:	060a                	slli	a2,a2,0x2
    80004724:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004726:	4ff4                	lw	a3,92(a5)
    80004728:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000472a:	0791                	addi	a5,a5,4
    8000472c:	0711                	addi	a4,a4,4
    8000472e:	fec79ce3          	bne	a5,a2,80004726 <initlog+0x52>
  brelse(buf);
    80004732:	888ff0ef          	jal	800037ba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004736:	4505                	li	a0,1
    80004738:	ed1ff0ef          	jal	80004608 <install_trans>
  log.lh.n = 0;
    8000473c:	02261797          	auipc	a5,0x2261
    80004740:	2007a223          	sw	zero,516(a5) # 82265940 <log+0x28>
  write_head(); // clear the log
    80004744:	e67ff0ef          	jal	800045aa <write_head>
}
    80004748:	70a2                	ld	ra,40(sp)
    8000474a:	7402                	ld	s0,32(sp)
    8000474c:	64e2                	ld	s1,24(sp)
    8000474e:	6942                	ld	s2,16(sp)
    80004750:	69a2                	ld	s3,8(sp)
    80004752:	6145                	addi	sp,sp,48
    80004754:	8082                	ret

0000000080004756 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004756:	1101                	addi	sp,sp,-32
    80004758:	ec06                	sd	ra,24(sp)
    8000475a:	e822                	sd	s0,16(sp)
    8000475c:	e426                	sd	s1,8(sp)
    8000475e:	e04a                	sd	s2,0(sp)
    80004760:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004762:	02261517          	auipc	a0,0x2261
    80004766:	1b650513          	addi	a0,a0,438 # 82265918 <log>
    8000476a:	cbefc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    8000476e:	02261497          	auipc	s1,0x2261
    80004772:	1aa48493          	addi	s1,s1,426 # 82265918 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004776:	4979                	li	s2,30
    80004778:	a029                	j	80004782 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000477a:	85a6                	mv	a1,s1
    8000477c:	8526                	mv	a0,s1
    8000477e:	854fe0ef          	jal	800027d2 <sleep>
    if(log.committing){
    80004782:	509c                	lw	a5,32(s1)
    80004784:	fbfd                	bnez	a5,8000477a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004786:	4cd8                	lw	a4,28(s1)
    80004788:	2705                	addiw	a4,a4,1
    8000478a:	0027179b          	slliw	a5,a4,0x2
    8000478e:	9fb9                	addw	a5,a5,a4
    80004790:	0017979b          	slliw	a5,a5,0x1
    80004794:	5494                	lw	a3,40(s1)
    80004796:	9fb5                	addw	a5,a5,a3
    80004798:	00f95763          	bge	s2,a5,800047a6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000479c:	85a6                	mv	a1,s1
    8000479e:	8526                	mv	a0,s1
    800047a0:	832fe0ef          	jal	800027d2 <sleep>
    800047a4:	bff9                	j	80004782 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800047a6:	02261797          	auipc	a5,0x2261
    800047aa:	18e7a723          	sw	a4,398(a5) # 82265934 <log+0x1c>
      release(&log.lock);
    800047ae:	02261517          	auipc	a0,0x2261
    800047b2:	16a50513          	addi	a0,a0,362 # 82265918 <log>
    800047b6:	d06fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    800047ba:	60e2                	ld	ra,24(sp)
    800047bc:	6442                	ld	s0,16(sp)
    800047be:	64a2                	ld	s1,8(sp)
    800047c0:	6902                	ld	s2,0(sp)
    800047c2:	6105                	addi	sp,sp,32
    800047c4:	8082                	ret

00000000800047c6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800047c6:	7139                	addi	sp,sp,-64
    800047c8:	fc06                	sd	ra,56(sp)
    800047ca:	f822                	sd	s0,48(sp)
    800047cc:	f426                	sd	s1,40(sp)
    800047ce:	f04a                	sd	s2,32(sp)
    800047d0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800047d2:	02261497          	auipc	s1,0x2261
    800047d6:	14648493          	addi	s1,s1,326 # 82265918 <log>
    800047da:	8526                	mv	a0,s1
    800047dc:	c4cfc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    800047e0:	4cdc                	lw	a5,28(s1)
    800047e2:	37fd                	addiw	a5,a5,-1
    800047e4:	893e                	mv	s2,a5
    800047e6:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800047e8:	509c                	lw	a5,32(s1)
    800047ea:	e7b1                	bnez	a5,80004836 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800047ec:	04091e63          	bnez	s2,80004848 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    800047f0:	02261497          	auipc	s1,0x2261
    800047f4:	12848493          	addi	s1,s1,296 # 82265918 <log>
    800047f8:	4785                	li	a5,1
    800047fa:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800047fc:	8526                	mv	a0,s1
    800047fe:	cbefc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004802:	549c                	lw	a5,40(s1)
    80004804:	06f04463          	bgtz	a5,8000486c <end_op+0xa6>
    acquire(&log.lock);
    80004808:	02261517          	auipc	a0,0x2261
    8000480c:	11050513          	addi	a0,a0,272 # 82265918 <log>
    80004810:	c18fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80004814:	02261797          	auipc	a5,0x2261
    80004818:	1207a223          	sw	zero,292(a5) # 82265938 <log+0x20>
    wakeup(&log);
    8000481c:	02261517          	auipc	a0,0x2261
    80004820:	0fc50513          	addi	a0,a0,252 # 82265918 <log>
    80004824:	ffbfd0ef          	jal	8000281e <wakeup>
    release(&log.lock);
    80004828:	02261517          	auipc	a0,0x2261
    8000482c:	0f050513          	addi	a0,a0,240 # 82265918 <log>
    80004830:	c8cfc0ef          	jal	80000cbc <release>
}
    80004834:	a035                	j	80004860 <end_op+0x9a>
    80004836:	ec4e                	sd	s3,24(sp)
    80004838:	e852                	sd	s4,16(sp)
    8000483a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000483c:	00004517          	auipc	a0,0x4
    80004840:	f8450513          	addi	a0,a0,-124 # 800087c0 <etext+0x7c0>
    80004844:	fe1fb0ef          	jal	80000824 <panic>
    wakeup(&log);
    80004848:	02261517          	auipc	a0,0x2261
    8000484c:	0d050513          	addi	a0,a0,208 # 82265918 <log>
    80004850:	fcffd0ef          	jal	8000281e <wakeup>
  release(&log.lock);
    80004854:	02261517          	auipc	a0,0x2261
    80004858:	0c450513          	addi	a0,a0,196 # 82265918 <log>
    8000485c:	c60fc0ef          	jal	80000cbc <release>
}
    80004860:	70e2                	ld	ra,56(sp)
    80004862:	7442                	ld	s0,48(sp)
    80004864:	74a2                	ld	s1,40(sp)
    80004866:	7902                	ld	s2,32(sp)
    80004868:	6121                	addi	sp,sp,64
    8000486a:	8082                	ret
    8000486c:	ec4e                	sd	s3,24(sp)
    8000486e:	e852                	sd	s4,16(sp)
    80004870:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004872:	02261a97          	auipc	s5,0x2261
    80004876:	0d2a8a93          	addi	s5,s5,210 # 82265944 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000487a:	02261a17          	auipc	s4,0x2261
    8000487e:	09ea0a13          	addi	s4,s4,158 # 82265918 <log>
    80004882:	018a2583          	lw	a1,24(s4)
    80004886:	012585bb          	addw	a1,a1,s2
    8000488a:	2585                	addiw	a1,a1,1
    8000488c:	024a2503          	lw	a0,36(s4)
    80004890:	e23fe0ef          	jal	800036b2 <bread>
    80004894:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004896:	000aa583          	lw	a1,0(s5)
    8000489a:	024a2503          	lw	a0,36(s4)
    8000489e:	e15fe0ef          	jal	800036b2 <bread>
    800048a2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800048a4:	40000613          	li	a2,1024
    800048a8:	05850593          	addi	a1,a0,88
    800048ac:	05848513          	addi	a0,s1,88
    800048b0:	ca8fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    800048b4:	8526                	mv	a0,s1
    800048b6:	ed3fe0ef          	jal	80003788 <bwrite>
    brelse(from);
    800048ba:	854e                	mv	a0,s3
    800048bc:	efffe0ef          	jal	800037ba <brelse>
    brelse(to);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ef9fe0ef          	jal	800037ba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048c6:	2905                	addiw	s2,s2,1
    800048c8:	0a91                	addi	s5,s5,4
    800048ca:	028a2783          	lw	a5,40(s4)
    800048ce:	faf94ae3          	blt	s2,a5,80004882 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800048d2:	cd9ff0ef          	jal	800045aa <write_head>
    install_trans(0); // Now install writes to home locations
    800048d6:	4501                	li	a0,0
    800048d8:	d31ff0ef          	jal	80004608 <install_trans>
    log.lh.n = 0;
    800048dc:	02261797          	auipc	a5,0x2261
    800048e0:	0607a223          	sw	zero,100(a5) # 82265940 <log+0x28>
    write_head();    // Erase the transaction from the log
    800048e4:	cc7ff0ef          	jal	800045aa <write_head>
    800048e8:	69e2                	ld	s3,24(sp)
    800048ea:	6a42                	ld	s4,16(sp)
    800048ec:	6aa2                	ld	s5,8(sp)
    800048ee:	bf29                	j	80004808 <end_op+0x42>

00000000800048f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800048f0:	1101                	addi	sp,sp,-32
    800048f2:	ec06                	sd	ra,24(sp)
    800048f4:	e822                	sd	s0,16(sp)
    800048f6:	e426                	sd	s1,8(sp)
    800048f8:	1000                	addi	s0,sp,32
    800048fa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800048fc:	02261517          	auipc	a0,0x2261
    80004900:	01c50513          	addi	a0,a0,28 # 82265918 <log>
    80004904:	b24fc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004908:	02261617          	auipc	a2,0x2261
    8000490c:	03862603          	lw	a2,56(a2) # 82265940 <log+0x28>
    80004910:	47f5                	li	a5,29
    80004912:	04c7cd63          	blt	a5,a2,8000496c <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004916:	02261797          	auipc	a5,0x2261
    8000491a:	01e7a783          	lw	a5,30(a5) # 82265934 <log+0x1c>
    8000491e:	04f05d63          	blez	a5,80004978 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004922:	4781                	li	a5,0
    80004924:	06c05063          	blez	a2,80004984 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004928:	44cc                	lw	a1,12(s1)
    8000492a:	02261717          	auipc	a4,0x2261
    8000492e:	01a70713          	addi	a4,a4,26 # 82265944 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004932:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004934:	4314                	lw	a3,0(a4)
    80004936:	04b68763          	beq	a3,a1,80004984 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    8000493a:	2785                	addiw	a5,a5,1
    8000493c:	0711                	addi	a4,a4,4
    8000493e:	fef61be3          	bne	a2,a5,80004934 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004942:	060a                	slli	a2,a2,0x2
    80004944:	02060613          	addi	a2,a2,32
    80004948:	02261797          	auipc	a5,0x2261
    8000494c:	fd078793          	addi	a5,a5,-48 # 82265918 <log>
    80004950:	97b2                	add	a5,a5,a2
    80004952:	44d8                	lw	a4,12(s1)
    80004954:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004956:	8526                	mv	a0,s1
    80004958:	ee7fe0ef          	jal	8000383e <bpin>
    log.lh.n++;
    8000495c:	02261717          	auipc	a4,0x2261
    80004960:	fbc70713          	addi	a4,a4,-68 # 82265918 <log>
    80004964:	571c                	lw	a5,40(a4)
    80004966:	2785                	addiw	a5,a5,1
    80004968:	d71c                	sw	a5,40(a4)
    8000496a:	a815                	j	8000499e <log_write+0xae>
    panic("too big a transaction");
    8000496c:	00004517          	auipc	a0,0x4
    80004970:	e6450513          	addi	a0,a0,-412 # 800087d0 <etext+0x7d0>
    80004974:	eb1fb0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80004978:	00004517          	auipc	a0,0x4
    8000497c:	e7050513          	addi	a0,a0,-400 # 800087e8 <etext+0x7e8>
    80004980:	ea5fb0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80004984:	00279693          	slli	a3,a5,0x2
    80004988:	02068693          	addi	a3,a3,32
    8000498c:	02261717          	auipc	a4,0x2261
    80004990:	f8c70713          	addi	a4,a4,-116 # 82265918 <log>
    80004994:	9736                	add	a4,a4,a3
    80004996:	44d4                	lw	a3,12(s1)
    80004998:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000499a:	faf60ee3          	beq	a2,a5,80004956 <log_write+0x66>
  }
  release(&log.lock);
    8000499e:	02261517          	auipc	a0,0x2261
    800049a2:	f7a50513          	addi	a0,a0,-134 # 82265918 <log>
    800049a6:	b16fc0ef          	jal	80000cbc <release>
}
    800049aa:	60e2                	ld	ra,24(sp)
    800049ac:	6442                	ld	s0,16(sp)
    800049ae:	64a2                	ld	s1,8(sp)
    800049b0:	6105                	addi	sp,sp,32
    800049b2:	8082                	ret

00000000800049b4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800049b4:	1101                	addi	sp,sp,-32
    800049b6:	ec06                	sd	ra,24(sp)
    800049b8:	e822                	sd	s0,16(sp)
    800049ba:	e426                	sd	s1,8(sp)
    800049bc:	e04a                	sd	s2,0(sp)
    800049be:	1000                	addi	s0,sp,32
    800049c0:	84aa                	mv	s1,a0
    800049c2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800049c4:	00004597          	auipc	a1,0x4
    800049c8:	e4458593          	addi	a1,a1,-444 # 80008808 <etext+0x808>
    800049cc:	0521                	addi	a0,a0,8
    800049ce:	9d0fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    800049d2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800049d6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049da:	0204a423          	sw	zero,40(s1)
}
    800049de:	60e2                	ld	ra,24(sp)
    800049e0:	6442                	ld	s0,16(sp)
    800049e2:	64a2                	ld	s1,8(sp)
    800049e4:	6902                	ld	s2,0(sp)
    800049e6:	6105                	addi	sp,sp,32
    800049e8:	8082                	ret

00000000800049ea <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049ea:	1101                	addi	sp,sp,-32
    800049ec:	ec06                	sd	ra,24(sp)
    800049ee:	e822                	sd	s0,16(sp)
    800049f0:	e426                	sd	s1,8(sp)
    800049f2:	e04a                	sd	s2,0(sp)
    800049f4:	1000                	addi	s0,sp,32
    800049f6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049f8:	00850913          	addi	s2,a0,8
    800049fc:	854a                	mv	a0,s2
    800049fe:	a2afc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004a02:	409c                	lw	a5,0(s1)
    80004a04:	c799                	beqz	a5,80004a12 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004a06:	85ca                	mv	a1,s2
    80004a08:	8526                	mv	a0,s1
    80004a0a:	dc9fd0ef          	jal	800027d2 <sleep>
  while (lk->locked) {
    80004a0e:	409c                	lw	a5,0(s1)
    80004a10:	fbfd                	bnez	a5,80004a06 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004a12:	4785                	li	a5,1
    80004a14:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004a16:	e9efd0ef          	jal	800020b4 <myproc>
    80004a1a:	591c                	lw	a5,48(a0)
    80004a1c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004a1e:	854a                	mv	a0,s2
    80004a20:	a9cfc0ef          	jal	80000cbc <release>
}
    80004a24:	60e2                	ld	ra,24(sp)
    80004a26:	6442                	ld	s0,16(sp)
    80004a28:	64a2                	ld	s1,8(sp)
    80004a2a:	6902                	ld	s2,0(sp)
    80004a2c:	6105                	addi	sp,sp,32
    80004a2e:	8082                	ret

0000000080004a30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a30:	1101                	addi	sp,sp,-32
    80004a32:	ec06                	sd	ra,24(sp)
    80004a34:	e822                	sd	s0,16(sp)
    80004a36:	e426                	sd	s1,8(sp)
    80004a38:	e04a                	sd	s2,0(sp)
    80004a3a:	1000                	addi	s0,sp,32
    80004a3c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a3e:	00850913          	addi	s2,a0,8
    80004a42:	854a                	mv	a0,s2
    80004a44:	9e4fc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    80004a48:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a4c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a50:	8526                	mv	a0,s1
    80004a52:	dcdfd0ef          	jal	8000281e <wakeup>
  release(&lk->lk);
    80004a56:	854a                	mv	a0,s2
    80004a58:	a64fc0ef          	jal	80000cbc <release>
}
    80004a5c:	60e2                	ld	ra,24(sp)
    80004a5e:	6442                	ld	s0,16(sp)
    80004a60:	64a2                	ld	s1,8(sp)
    80004a62:	6902                	ld	s2,0(sp)
    80004a64:	6105                	addi	sp,sp,32
    80004a66:	8082                	ret

0000000080004a68 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a68:	7179                	addi	sp,sp,-48
    80004a6a:	f406                	sd	ra,40(sp)
    80004a6c:	f022                	sd	s0,32(sp)
    80004a6e:	ec26                	sd	s1,24(sp)
    80004a70:	e84a                	sd	s2,16(sp)
    80004a72:	1800                	addi	s0,sp,48
    80004a74:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a76:	00850913          	addi	s2,a0,8
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	9acfc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a80:	409c                	lw	a5,0(s1)
    80004a82:	ef81                	bnez	a5,80004a9a <holdingsleep+0x32>
    80004a84:	4481                	li	s1,0
  release(&lk->lk);
    80004a86:	854a                	mv	a0,s2
    80004a88:	a34fc0ef          	jal	80000cbc <release>
  return r;
}
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	70a2                	ld	ra,40(sp)
    80004a90:	7402                	ld	s0,32(sp)
    80004a92:	64e2                	ld	s1,24(sp)
    80004a94:	6942                	ld	s2,16(sp)
    80004a96:	6145                	addi	sp,sp,48
    80004a98:	8082                	ret
    80004a9a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a9c:	0284a983          	lw	s3,40(s1)
    80004aa0:	e14fd0ef          	jal	800020b4 <myproc>
    80004aa4:	5904                	lw	s1,48(a0)
    80004aa6:	413484b3          	sub	s1,s1,s3
    80004aaa:	0014b493          	seqz	s1,s1
    80004aae:	69a2                	ld	s3,8(sp)
    80004ab0:	bfd9                	j	80004a86 <holdingsleep+0x1e>

0000000080004ab2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004ab2:	1141                	addi	sp,sp,-16
    80004ab4:	e406                	sd	ra,8(sp)
    80004ab6:	e022                	sd	s0,0(sp)
    80004ab8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004aba:	00004597          	auipc	a1,0x4
    80004abe:	d5e58593          	addi	a1,a1,-674 # 80008818 <etext+0x818>
    80004ac2:	02261517          	auipc	a0,0x2261
    80004ac6:	f9e50513          	addi	a0,a0,-98 # 82265a60 <ftable>
    80004aca:	8d4fc0ef          	jal	80000b9e <initlock>
}
    80004ace:	60a2                	ld	ra,8(sp)
    80004ad0:	6402                	ld	s0,0(sp)
    80004ad2:	0141                	addi	sp,sp,16
    80004ad4:	8082                	ret

0000000080004ad6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004ad6:	1101                	addi	sp,sp,-32
    80004ad8:	ec06                	sd	ra,24(sp)
    80004ada:	e822                	sd	s0,16(sp)
    80004adc:	e426                	sd	s1,8(sp)
    80004ade:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ae0:	02261517          	auipc	a0,0x2261
    80004ae4:	f8050513          	addi	a0,a0,-128 # 82265a60 <ftable>
    80004ae8:	940fc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004aec:	02261497          	auipc	s1,0x2261
    80004af0:	f8c48493          	addi	s1,s1,-116 # 82265a78 <ftable+0x18>
    80004af4:	02262717          	auipc	a4,0x2262
    80004af8:	f2470713          	addi	a4,a4,-220 # 82266a18 <disk>
    if(f->ref == 0){
    80004afc:	40dc                	lw	a5,4(s1)
    80004afe:	cf89                	beqz	a5,80004b18 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b00:	02848493          	addi	s1,s1,40
    80004b04:	fee49ce3          	bne	s1,a4,80004afc <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b08:	02261517          	auipc	a0,0x2261
    80004b0c:	f5850513          	addi	a0,a0,-168 # 82265a60 <ftable>
    80004b10:	9acfc0ef          	jal	80000cbc <release>
  return 0;
    80004b14:	4481                	li	s1,0
    80004b16:	a809                	j	80004b28 <filealloc+0x52>
      f->ref = 1;
    80004b18:	4785                	li	a5,1
    80004b1a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b1c:	02261517          	auipc	a0,0x2261
    80004b20:	f4450513          	addi	a0,a0,-188 # 82265a60 <ftable>
    80004b24:	998fc0ef          	jal	80000cbc <release>
}
    80004b28:	8526                	mv	a0,s1
    80004b2a:	60e2                	ld	ra,24(sp)
    80004b2c:	6442                	ld	s0,16(sp)
    80004b2e:	64a2                	ld	s1,8(sp)
    80004b30:	6105                	addi	sp,sp,32
    80004b32:	8082                	ret

0000000080004b34 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b34:	1101                	addi	sp,sp,-32
    80004b36:	ec06                	sd	ra,24(sp)
    80004b38:	e822                	sd	s0,16(sp)
    80004b3a:	e426                	sd	s1,8(sp)
    80004b3c:	1000                	addi	s0,sp,32
    80004b3e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b40:	02261517          	auipc	a0,0x2261
    80004b44:	f2050513          	addi	a0,a0,-224 # 82265a60 <ftable>
    80004b48:	8e0fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004b4c:	40dc                	lw	a5,4(s1)
    80004b4e:	02f05063          	blez	a5,80004b6e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004b52:	2785                	addiw	a5,a5,1
    80004b54:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b56:	02261517          	auipc	a0,0x2261
    80004b5a:	f0a50513          	addi	a0,a0,-246 # 82265a60 <ftable>
    80004b5e:	95efc0ef          	jal	80000cbc <release>
  return f;
}
    80004b62:	8526                	mv	a0,s1
    80004b64:	60e2                	ld	ra,24(sp)
    80004b66:	6442                	ld	s0,16(sp)
    80004b68:	64a2                	ld	s1,8(sp)
    80004b6a:	6105                	addi	sp,sp,32
    80004b6c:	8082                	ret
    panic("filedup");
    80004b6e:	00004517          	auipc	a0,0x4
    80004b72:	cb250513          	addi	a0,a0,-846 # 80008820 <etext+0x820>
    80004b76:	caffb0ef          	jal	80000824 <panic>

0000000080004b7a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b7a:	7139                	addi	sp,sp,-64
    80004b7c:	fc06                	sd	ra,56(sp)
    80004b7e:	f822                	sd	s0,48(sp)
    80004b80:	f426                	sd	s1,40(sp)
    80004b82:	0080                	addi	s0,sp,64
    80004b84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b86:	02261517          	auipc	a0,0x2261
    80004b8a:	eda50513          	addi	a0,a0,-294 # 82265a60 <ftable>
    80004b8e:	89afc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004b92:	40dc                	lw	a5,4(s1)
    80004b94:	04f05a63          	blez	a5,80004be8 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004b98:	37fd                	addiw	a5,a5,-1
    80004b9a:	c0dc                	sw	a5,4(s1)
    80004b9c:	06f04063          	bgtz	a5,80004bfc <fileclose+0x82>
    80004ba0:	f04a                	sd	s2,32(sp)
    80004ba2:	ec4e                	sd	s3,24(sp)
    80004ba4:	e852                	sd	s4,16(sp)
    80004ba6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004ba8:	0004a903          	lw	s2,0(s1)
    80004bac:	0094c783          	lbu	a5,9(s1)
    80004bb0:	89be                	mv	s3,a5
    80004bb2:	689c                	ld	a5,16(s1)
    80004bb4:	8a3e                	mv	s4,a5
    80004bb6:	6c9c                	ld	a5,24(s1)
    80004bb8:	8abe                	mv	s5,a5
  f->ref = 0;
    80004bba:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bbe:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004bc2:	02261517          	auipc	a0,0x2261
    80004bc6:	e9e50513          	addi	a0,a0,-354 # 82265a60 <ftable>
    80004bca:	8f2fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    80004bce:	4785                	li	a5,1
    80004bd0:	04f90163          	beq	s2,a5,80004c12 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bd4:	ffe9079b          	addiw	a5,s2,-2
    80004bd8:	4705                	li	a4,1
    80004bda:	04f77563          	bgeu	a4,a5,80004c24 <fileclose+0xaa>
    80004bde:	7902                	ld	s2,32(sp)
    80004be0:	69e2                	ld	s3,24(sp)
    80004be2:	6a42                	ld	s4,16(sp)
    80004be4:	6aa2                	ld	s5,8(sp)
    80004be6:	a00d                	j	80004c08 <fileclose+0x8e>
    80004be8:	f04a                	sd	s2,32(sp)
    80004bea:	ec4e                	sd	s3,24(sp)
    80004bec:	e852                	sd	s4,16(sp)
    80004bee:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004bf0:	00004517          	auipc	a0,0x4
    80004bf4:	c3850513          	addi	a0,a0,-968 # 80008828 <etext+0x828>
    80004bf8:	c2dfb0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004bfc:	02261517          	auipc	a0,0x2261
    80004c00:	e6450513          	addi	a0,a0,-412 # 82265a60 <ftable>
    80004c04:	8b8fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c08:	70e2                	ld	ra,56(sp)
    80004c0a:	7442                	ld	s0,48(sp)
    80004c0c:	74a2                	ld	s1,40(sp)
    80004c0e:	6121                	addi	sp,sp,64
    80004c10:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c12:	85ce                	mv	a1,s3
    80004c14:	8552                	mv	a0,s4
    80004c16:	348000ef          	jal	80004f5e <pipeclose>
    80004c1a:	7902                	ld	s2,32(sp)
    80004c1c:	69e2                	ld	s3,24(sp)
    80004c1e:	6a42                	ld	s4,16(sp)
    80004c20:	6aa2                	ld	s5,8(sp)
    80004c22:	b7dd                	j	80004c08 <fileclose+0x8e>
    begin_op();
    80004c24:	b33ff0ef          	jal	80004756 <begin_op>
    iput(ff.ip);
    80004c28:	8556                	mv	a0,s5
    80004c2a:	aa2ff0ef          	jal	80003ecc <iput>
    end_op();
    80004c2e:	b99ff0ef          	jal	800047c6 <end_op>
    80004c32:	7902                	ld	s2,32(sp)
    80004c34:	69e2                	ld	s3,24(sp)
    80004c36:	6a42                	ld	s4,16(sp)
    80004c38:	6aa2                	ld	s5,8(sp)
    80004c3a:	b7f9                	j	80004c08 <fileclose+0x8e>

0000000080004c3c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c3c:	715d                	addi	sp,sp,-80
    80004c3e:	e486                	sd	ra,72(sp)
    80004c40:	e0a2                	sd	s0,64(sp)
    80004c42:	fc26                	sd	s1,56(sp)
    80004c44:	f052                	sd	s4,32(sp)
    80004c46:	0880                	addi	s0,sp,80
    80004c48:	84aa                	mv	s1,a0
    80004c4a:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004c4c:	c68fd0ef          	jal	800020b4 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c50:	409c                	lw	a5,0(s1)
    80004c52:	37f9                	addiw	a5,a5,-2
    80004c54:	4705                	li	a4,1
    80004c56:	04f76263          	bltu	a4,a5,80004c9a <filestat+0x5e>
    80004c5a:	f84a                	sd	s2,48(sp)
    80004c5c:	f44e                	sd	s3,40(sp)
    80004c5e:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004c60:	6c88                	ld	a0,24(s1)
    80004c62:	8e8ff0ef          	jal	80003d4a <ilock>
    stati(f->ip, &st);
    80004c66:	fb840913          	addi	s2,s0,-72
    80004c6a:	85ca                	mv	a1,s2
    80004c6c:	6c88                	ld	a0,24(s1)
    80004c6e:	c40ff0ef          	jal	800040ae <stati>
    iunlock(f->ip);
    80004c72:	6c88                	ld	a0,24(s1)
    80004c74:	984ff0ef          	jal	80003df8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c78:	46e1                	li	a3,24
    80004c7a:	864a                	mv	a2,s2
    80004c7c:	85d2                	mv	a1,s4
    80004c7e:	0509b503          	ld	a0,80(s3)
    80004c82:	e15fc0ef          	jal	80001a96 <copyout>
    80004c86:	41f5551b          	sraiw	a0,a0,0x1f
    80004c8a:	7942                	ld	s2,48(sp)
    80004c8c:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004c8e:	60a6                	ld	ra,72(sp)
    80004c90:	6406                	ld	s0,64(sp)
    80004c92:	74e2                	ld	s1,56(sp)
    80004c94:	7a02                	ld	s4,32(sp)
    80004c96:	6161                	addi	sp,sp,80
    80004c98:	8082                	ret
  return -1;
    80004c9a:	557d                	li	a0,-1
    80004c9c:	bfcd                	j	80004c8e <filestat+0x52>

0000000080004c9e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c9e:	7179                	addi	sp,sp,-48
    80004ca0:	f406                	sd	ra,40(sp)
    80004ca2:	f022                	sd	s0,32(sp)
    80004ca4:	e84a                	sd	s2,16(sp)
    80004ca6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ca8:	00854783          	lbu	a5,8(a0)
    80004cac:	cfd1                	beqz	a5,80004d48 <fileread+0xaa>
    80004cae:	ec26                	sd	s1,24(sp)
    80004cb0:	e44e                	sd	s3,8(sp)
    80004cb2:	84aa                	mv	s1,a0
    80004cb4:	892e                	mv	s2,a1
    80004cb6:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004cb8:	411c                	lw	a5,0(a0)
    80004cba:	4705                	li	a4,1
    80004cbc:	04e78363          	beq	a5,a4,80004d02 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004cc0:	470d                	li	a4,3
    80004cc2:	04e78763          	beq	a5,a4,80004d10 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004cc6:	4709                	li	a4,2
    80004cc8:	06e79a63          	bne	a5,a4,80004d3c <fileread+0x9e>
    ilock(f->ip);
    80004ccc:	6d08                	ld	a0,24(a0)
    80004cce:	87cff0ef          	jal	80003d4a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004cd2:	874e                	mv	a4,s3
    80004cd4:	5094                	lw	a3,32(s1)
    80004cd6:	864a                	mv	a2,s2
    80004cd8:	4585                	li	a1,1
    80004cda:	6c88                	ld	a0,24(s1)
    80004cdc:	c00ff0ef          	jal	800040dc <readi>
    80004ce0:	892a                	mv	s2,a0
    80004ce2:	00a05563          	blez	a0,80004cec <fileread+0x4e>
      f->off += r;
    80004ce6:	509c                	lw	a5,32(s1)
    80004ce8:	9fa9                	addw	a5,a5,a0
    80004cea:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004cec:	6c88                	ld	a0,24(s1)
    80004cee:	90aff0ef          	jal	80003df8 <iunlock>
    80004cf2:	64e2                	ld	s1,24(sp)
    80004cf4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004cf6:	854a                	mv	a0,s2
    80004cf8:	70a2                	ld	ra,40(sp)
    80004cfa:	7402                	ld	s0,32(sp)
    80004cfc:	6942                	ld	s2,16(sp)
    80004cfe:	6145                	addi	sp,sp,48
    80004d00:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d02:	6908                	ld	a0,16(a0)
    80004d04:	3b0000ef          	jal	800050b4 <piperead>
    80004d08:	892a                	mv	s2,a0
    80004d0a:	64e2                	ld	s1,24(sp)
    80004d0c:	69a2                	ld	s3,8(sp)
    80004d0e:	b7e5                	j	80004cf6 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d10:	02451783          	lh	a5,36(a0)
    80004d14:	03079693          	slli	a3,a5,0x30
    80004d18:	92c1                	srli	a3,a3,0x30
    80004d1a:	4725                	li	a4,9
    80004d1c:	02d76963          	bltu	a4,a3,80004d4e <fileread+0xb0>
    80004d20:	0792                	slli	a5,a5,0x4
    80004d22:	02261717          	auipc	a4,0x2261
    80004d26:	c9e70713          	addi	a4,a4,-866 # 822659c0 <devsw>
    80004d2a:	97ba                	add	a5,a5,a4
    80004d2c:	639c                	ld	a5,0(a5)
    80004d2e:	c78d                	beqz	a5,80004d58 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004d30:	4505                	li	a0,1
    80004d32:	9782                	jalr	a5
    80004d34:	892a                	mv	s2,a0
    80004d36:	64e2                	ld	s1,24(sp)
    80004d38:	69a2                	ld	s3,8(sp)
    80004d3a:	bf75                	j	80004cf6 <fileread+0x58>
    panic("fileread");
    80004d3c:	00004517          	auipc	a0,0x4
    80004d40:	afc50513          	addi	a0,a0,-1284 # 80008838 <etext+0x838>
    80004d44:	ae1fb0ef          	jal	80000824 <panic>
    return -1;
    80004d48:	57fd                	li	a5,-1
    80004d4a:	893e                	mv	s2,a5
    80004d4c:	b76d                	j	80004cf6 <fileread+0x58>
      return -1;
    80004d4e:	57fd                	li	a5,-1
    80004d50:	893e                	mv	s2,a5
    80004d52:	64e2                	ld	s1,24(sp)
    80004d54:	69a2                	ld	s3,8(sp)
    80004d56:	b745                	j	80004cf6 <fileread+0x58>
    80004d58:	57fd                	li	a5,-1
    80004d5a:	893e                	mv	s2,a5
    80004d5c:	64e2                	ld	s1,24(sp)
    80004d5e:	69a2                	ld	s3,8(sp)
    80004d60:	bf59                	j	80004cf6 <fileread+0x58>

0000000080004d62 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004d62:	00954783          	lbu	a5,9(a0)
    80004d66:	10078f63          	beqz	a5,80004e84 <filewrite+0x122>
{
    80004d6a:	711d                	addi	sp,sp,-96
    80004d6c:	ec86                	sd	ra,88(sp)
    80004d6e:	e8a2                	sd	s0,80(sp)
    80004d70:	e0ca                	sd	s2,64(sp)
    80004d72:	f456                	sd	s5,40(sp)
    80004d74:	f05a                	sd	s6,32(sp)
    80004d76:	1080                	addi	s0,sp,96
    80004d78:	892a                	mv	s2,a0
    80004d7a:	8b2e                	mv	s6,a1
    80004d7c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d7e:	411c                	lw	a5,0(a0)
    80004d80:	4705                	li	a4,1
    80004d82:	02e78a63          	beq	a5,a4,80004db6 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d86:	470d                	li	a4,3
    80004d88:	02e78b63          	beq	a5,a4,80004dbe <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d8c:	4709                	li	a4,2
    80004d8e:	0ce79f63          	bne	a5,a4,80004e6c <filewrite+0x10a>
    80004d92:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d94:	0ac05a63          	blez	a2,80004e48 <filewrite+0xe6>
    80004d98:	e4a6                	sd	s1,72(sp)
    80004d9a:	fc4e                	sd	s3,56(sp)
    80004d9c:	ec5e                	sd	s7,24(sp)
    80004d9e:	e862                	sd	s8,16(sp)
    80004da0:	e466                	sd	s9,8(sp)
    int i = 0;
    80004da2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004da4:	6b85                	lui	s7,0x1
    80004da6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004daa:	6785                	lui	a5,0x1
    80004dac:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004db0:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004db2:	4c05                	li	s8,1
    80004db4:	a8ad                	j	80004e2e <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004db6:	6908                	ld	a0,16(a0)
    80004db8:	204000ef          	jal	80004fbc <pipewrite>
    80004dbc:	a04d                	j	80004e5e <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004dbe:	02451783          	lh	a5,36(a0)
    80004dc2:	03079693          	slli	a3,a5,0x30
    80004dc6:	92c1                	srli	a3,a3,0x30
    80004dc8:	4725                	li	a4,9
    80004dca:	0ad76f63          	bltu	a4,a3,80004e88 <filewrite+0x126>
    80004dce:	0792                	slli	a5,a5,0x4
    80004dd0:	02261717          	auipc	a4,0x2261
    80004dd4:	bf070713          	addi	a4,a4,-1040 # 822659c0 <devsw>
    80004dd8:	97ba                	add	a5,a5,a4
    80004dda:	679c                	ld	a5,8(a5)
    80004ddc:	cbc5                	beqz	a5,80004e8c <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80004dde:	4505                	li	a0,1
    80004de0:	9782                	jalr	a5
    80004de2:	a8b5                	j	80004e5e <filewrite+0xfc>
      if(n1 > max)
    80004de4:	2981                	sext.w	s3,s3
      begin_op();
    80004de6:	971ff0ef          	jal	80004756 <begin_op>
      ilock(f->ip);
    80004dea:	01893503          	ld	a0,24(s2)
    80004dee:	f5dfe0ef          	jal	80003d4a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004df2:	874e                	mv	a4,s3
    80004df4:	02092683          	lw	a3,32(s2)
    80004df8:	016a0633          	add	a2,s4,s6
    80004dfc:	85e2                	mv	a1,s8
    80004dfe:	01893503          	ld	a0,24(s2)
    80004e02:	bccff0ef          	jal	800041ce <writei>
    80004e06:	84aa                	mv	s1,a0
    80004e08:	00a05763          	blez	a0,80004e16 <filewrite+0xb4>
        f->off += r;
    80004e0c:	02092783          	lw	a5,32(s2)
    80004e10:	9fa9                	addw	a5,a5,a0
    80004e12:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e16:	01893503          	ld	a0,24(s2)
    80004e1a:	fdffe0ef          	jal	80003df8 <iunlock>
      end_op();
    80004e1e:	9a9ff0ef          	jal	800047c6 <end_op>

      if(r != n1){
    80004e22:	02999563          	bne	s3,s1,80004e4c <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004e26:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004e2a:	015a5963          	bge	s4,s5,80004e3c <filewrite+0xda>
      int n1 = n - i;
    80004e2e:	414a87bb          	subw	a5,s5,s4
    80004e32:	89be                	mv	s3,a5
      if(n1 > max)
    80004e34:	fafbd8e3          	bge	s7,a5,80004de4 <filewrite+0x82>
    80004e38:	89e6                	mv	s3,s9
    80004e3a:	b76d                	j	80004de4 <filewrite+0x82>
    80004e3c:	64a6                	ld	s1,72(sp)
    80004e3e:	79e2                	ld	s3,56(sp)
    80004e40:	6be2                	ld	s7,24(sp)
    80004e42:	6c42                	ld	s8,16(sp)
    80004e44:	6ca2                	ld	s9,8(sp)
    80004e46:	a801                	j	80004e56 <filewrite+0xf4>
    int i = 0;
    80004e48:	4a01                	li	s4,0
    80004e4a:	a031                	j	80004e56 <filewrite+0xf4>
    80004e4c:	64a6                	ld	s1,72(sp)
    80004e4e:	79e2                	ld	s3,56(sp)
    80004e50:	6be2                	ld	s7,24(sp)
    80004e52:	6c42                	ld	s8,16(sp)
    80004e54:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004e56:	034a9d63          	bne	s5,s4,80004e90 <filewrite+0x12e>
    80004e5a:	8556                	mv	a0,s5
    80004e5c:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e5e:	60e6                	ld	ra,88(sp)
    80004e60:	6446                	ld	s0,80(sp)
    80004e62:	6906                	ld	s2,64(sp)
    80004e64:	7aa2                	ld	s5,40(sp)
    80004e66:	7b02                	ld	s6,32(sp)
    80004e68:	6125                	addi	sp,sp,96
    80004e6a:	8082                	ret
    80004e6c:	e4a6                	sd	s1,72(sp)
    80004e6e:	fc4e                	sd	s3,56(sp)
    80004e70:	f852                	sd	s4,48(sp)
    80004e72:	ec5e                	sd	s7,24(sp)
    80004e74:	e862                	sd	s8,16(sp)
    80004e76:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004e78:	00004517          	auipc	a0,0x4
    80004e7c:	9d050513          	addi	a0,a0,-1584 # 80008848 <etext+0x848>
    80004e80:	9a5fb0ef          	jal	80000824 <panic>
    return -1;
    80004e84:	557d                	li	a0,-1
}
    80004e86:	8082                	ret
      return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	bfd1                	j	80004e5e <filewrite+0xfc>
    80004e8c:	557d                	li	a0,-1
    80004e8e:	bfc1                	j	80004e5e <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004e90:	557d                	li	a0,-1
    80004e92:	7a42                	ld	s4,48(sp)
    80004e94:	b7e9                	j	80004e5e <filewrite+0xfc>

0000000080004e96 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e96:	7179                	addi	sp,sp,-48
    80004e98:	f406                	sd	ra,40(sp)
    80004e9a:	f022                	sd	s0,32(sp)
    80004e9c:	ec26                	sd	s1,24(sp)
    80004e9e:	e052                	sd	s4,0(sp)
    80004ea0:	1800                	addi	s0,sp,48
    80004ea2:	84aa                	mv	s1,a0
    80004ea4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004ea6:	0005b023          	sd	zero,0(a1)
    80004eaa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004eae:	c29ff0ef          	jal	80004ad6 <filealloc>
    80004eb2:	e088                	sd	a0,0(s1)
    80004eb4:	c549                	beqz	a0,80004f3e <pipealloc+0xa8>
    80004eb6:	c21ff0ef          	jal	80004ad6 <filealloc>
    80004eba:	00aa3023          	sd	a0,0(s4)
    80004ebe:	cd25                	beqz	a0,80004f36 <pipealloc+0xa0>
    80004ec0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004ec2:	c83fb0ef          	jal	80000b44 <kalloc>
    80004ec6:	892a                	mv	s2,a0
    80004ec8:	c12d                	beqz	a0,80004f2a <pipealloc+0x94>
    80004eca:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004ecc:	4985                	li	s3,1
    80004ece:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004ed2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ed6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004eda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004ede:	00004597          	auipc	a1,0x4
    80004ee2:	97a58593          	addi	a1,a1,-1670 # 80008858 <etext+0x858>
    80004ee6:	cb9fb0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004eea:	609c                	ld	a5,0(s1)
    80004eec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ef0:	609c                	ld	a5,0(s1)
    80004ef2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ef6:	609c                	ld	a5,0(s1)
    80004ef8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004efc:	609c                	ld	a5,0(s1)
    80004efe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f02:	000a3783          	ld	a5,0(s4)
    80004f06:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f0a:	000a3783          	ld	a5,0(s4)
    80004f0e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f12:	000a3783          	ld	a5,0(s4)
    80004f16:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004f1a:	000a3783          	ld	a5,0(s4)
    80004f1e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004f22:	4501                	li	a0,0
    80004f24:	6942                	ld	s2,16(sp)
    80004f26:	69a2                	ld	s3,8(sp)
    80004f28:	a01d                	j	80004f4e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004f2a:	6088                	ld	a0,0(s1)
    80004f2c:	c119                	beqz	a0,80004f32 <pipealloc+0x9c>
    80004f2e:	6942                	ld	s2,16(sp)
    80004f30:	a029                	j	80004f3a <pipealloc+0xa4>
    80004f32:	6942                	ld	s2,16(sp)
    80004f34:	a029                	j	80004f3e <pipealloc+0xa8>
    80004f36:	6088                	ld	a0,0(s1)
    80004f38:	c10d                	beqz	a0,80004f5a <pipealloc+0xc4>
    fileclose(*f0);
    80004f3a:	c41ff0ef          	jal	80004b7a <fileclose>
  if(*f1)
    80004f3e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004f42:	557d                	li	a0,-1
  if(*f1)
    80004f44:	c789                	beqz	a5,80004f4e <pipealloc+0xb8>
    fileclose(*f1);
    80004f46:	853e                	mv	a0,a5
    80004f48:	c33ff0ef          	jal	80004b7a <fileclose>
  return -1;
    80004f4c:	557d                	li	a0,-1
}
    80004f4e:	70a2                	ld	ra,40(sp)
    80004f50:	7402                	ld	s0,32(sp)
    80004f52:	64e2                	ld	s1,24(sp)
    80004f54:	6a02                	ld	s4,0(sp)
    80004f56:	6145                	addi	sp,sp,48
    80004f58:	8082                	ret
  return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	bfcd                	j	80004f4e <pipealloc+0xb8>

0000000080004f5e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f5e:	1101                	addi	sp,sp,-32
    80004f60:	ec06                	sd	ra,24(sp)
    80004f62:	e822                	sd	s0,16(sp)
    80004f64:	e426                	sd	s1,8(sp)
    80004f66:	e04a                	sd	s2,0(sp)
    80004f68:	1000                	addi	s0,sp,32
    80004f6a:	84aa                	mv	s1,a0
    80004f6c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f6e:	cbbfb0ef          	jal	80000c28 <acquire>
  if(writable){
    80004f72:	02090763          	beqz	s2,80004fa0 <pipeclose+0x42>
    pi->writeopen = 0;
    80004f76:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f7a:	21848513          	addi	a0,s1,536
    80004f7e:	8a1fd0ef          	jal	8000281e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f82:	2204a783          	lw	a5,544(s1)
    80004f86:	e781                	bnez	a5,80004f8e <pipeclose+0x30>
    80004f88:	2244a783          	lw	a5,548(s1)
    80004f8c:	c38d                	beqz	a5,80004fae <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004f8e:	8526                	mv	a0,s1
    80004f90:	d2dfb0ef          	jal	80000cbc <release>
}
    80004f94:	60e2                	ld	ra,24(sp)
    80004f96:	6442                	ld	s0,16(sp)
    80004f98:	64a2                	ld	s1,8(sp)
    80004f9a:	6902                	ld	s2,0(sp)
    80004f9c:	6105                	addi	sp,sp,32
    80004f9e:	8082                	ret
    pi->readopen = 0;
    80004fa0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004fa4:	21c48513          	addi	a0,s1,540
    80004fa8:	877fd0ef          	jal	8000281e <wakeup>
    80004fac:	bfd9                	j	80004f82 <pipeclose+0x24>
    release(&pi->lock);
    80004fae:	8526                	mv	a0,s1
    80004fb0:	d0dfb0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004fb4:	8526                	mv	a0,s1
    80004fb6:	aa7fb0ef          	jal	80000a5c <kfree>
    80004fba:	bfe9                	j	80004f94 <pipeclose+0x36>

0000000080004fbc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004fbc:	7159                	addi	sp,sp,-112
    80004fbe:	f486                	sd	ra,104(sp)
    80004fc0:	f0a2                	sd	s0,96(sp)
    80004fc2:	eca6                	sd	s1,88(sp)
    80004fc4:	e8ca                	sd	s2,80(sp)
    80004fc6:	e4ce                	sd	s3,72(sp)
    80004fc8:	e0d2                	sd	s4,64(sp)
    80004fca:	fc56                	sd	s5,56(sp)
    80004fcc:	1880                	addi	s0,sp,112
    80004fce:	84aa                	mv	s1,a0
    80004fd0:	8aae                	mv	s5,a1
    80004fd2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004fd4:	8e0fd0ef          	jal	800020b4 <myproc>
    80004fd8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004fda:	8526                	mv	a0,s1
    80004fdc:	c4dfb0ef          	jal	80000c28 <acquire>
  while(i < n){
    80004fe0:	0d405263          	blez	s4,800050a4 <pipewrite+0xe8>
    80004fe4:	f85a                	sd	s6,48(sp)
    80004fe6:	f45e                	sd	s7,40(sp)
    80004fe8:	f062                	sd	s8,32(sp)
    80004fea:	ec66                	sd	s9,24(sp)
    80004fec:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004fee:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ff0:	f9f40c13          	addi	s8,s0,-97
    80004ff4:	4b85                	li	s7,1
    80004ff6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004ff8:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ffc:	21c48c93          	addi	s9,s1,540
    80005000:	a82d                	j	8000503a <pipewrite+0x7e>
      release(&pi->lock);
    80005002:	8526                	mv	a0,s1
    80005004:	cb9fb0ef          	jal	80000cbc <release>
      return -1;
    80005008:	597d                	li	s2,-1
    8000500a:	7b42                	ld	s6,48(sp)
    8000500c:	7ba2                	ld	s7,40(sp)
    8000500e:	7c02                	ld	s8,32(sp)
    80005010:	6ce2                	ld	s9,24(sp)
    80005012:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005014:	854a                	mv	a0,s2
    80005016:	70a6                	ld	ra,104(sp)
    80005018:	7406                	ld	s0,96(sp)
    8000501a:	64e6                	ld	s1,88(sp)
    8000501c:	6946                	ld	s2,80(sp)
    8000501e:	69a6                	ld	s3,72(sp)
    80005020:	6a06                	ld	s4,64(sp)
    80005022:	7ae2                	ld	s5,56(sp)
    80005024:	6165                	addi	sp,sp,112
    80005026:	8082                	ret
      wakeup(&pi->nread);
    80005028:	856a                	mv	a0,s10
    8000502a:	ff4fd0ef          	jal	8000281e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000502e:	85a6                	mv	a1,s1
    80005030:	8566                	mv	a0,s9
    80005032:	fa0fd0ef          	jal	800027d2 <sleep>
  while(i < n){
    80005036:	05495a63          	bge	s2,s4,8000508a <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000503a:	2204a783          	lw	a5,544(s1)
    8000503e:	d3f1                	beqz	a5,80005002 <pipewrite+0x46>
    80005040:	854e                	mv	a0,s3
    80005042:	a29fd0ef          	jal	80002a6a <killed>
    80005046:	fd55                	bnez	a0,80005002 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005048:	2184a783          	lw	a5,536(s1)
    8000504c:	21c4a703          	lw	a4,540(s1)
    80005050:	2007879b          	addiw	a5,a5,512
    80005054:	fcf70ae3          	beq	a4,a5,80005028 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005058:	86de                	mv	a3,s7
    8000505a:	01590633          	add	a2,s2,s5
    8000505e:	85e2                	mv	a1,s8
    80005060:	0509b503          	ld	a0,80(s3)
    80005064:	beffc0ef          	jal	80001c52 <copyin>
    80005068:	05650063          	beq	a0,s6,800050a8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000506c:	21c4a783          	lw	a5,540(s1)
    80005070:	0017871b          	addiw	a4,a5,1
    80005074:	20e4ae23          	sw	a4,540(s1)
    80005078:	1ff7f793          	andi	a5,a5,511
    8000507c:	97a6                	add	a5,a5,s1
    8000507e:	f9f44703          	lbu	a4,-97(s0)
    80005082:	00e78c23          	sb	a4,24(a5)
      i++;
    80005086:	2905                	addiw	s2,s2,1
    80005088:	b77d                	j	80005036 <pipewrite+0x7a>
    8000508a:	7b42                	ld	s6,48(sp)
    8000508c:	7ba2                	ld	s7,40(sp)
    8000508e:	7c02                	ld	s8,32(sp)
    80005090:	6ce2                	ld	s9,24(sp)
    80005092:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005094:	21848513          	addi	a0,s1,536
    80005098:	f86fd0ef          	jal	8000281e <wakeup>
  release(&pi->lock);
    8000509c:	8526                	mv	a0,s1
    8000509e:	c1ffb0ef          	jal	80000cbc <release>
  return i;
    800050a2:	bf8d                	j	80005014 <pipewrite+0x58>
  int i = 0;
    800050a4:	4901                	li	s2,0
    800050a6:	b7fd                	j	80005094 <pipewrite+0xd8>
    800050a8:	7b42                	ld	s6,48(sp)
    800050aa:	7ba2                	ld	s7,40(sp)
    800050ac:	7c02                	ld	s8,32(sp)
    800050ae:	6ce2                	ld	s9,24(sp)
    800050b0:	6d42                	ld	s10,16(sp)
    800050b2:	b7cd                	j	80005094 <pipewrite+0xd8>

00000000800050b4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800050b4:	711d                	addi	sp,sp,-96
    800050b6:	ec86                	sd	ra,88(sp)
    800050b8:	e8a2                	sd	s0,80(sp)
    800050ba:	e4a6                	sd	s1,72(sp)
    800050bc:	e0ca                	sd	s2,64(sp)
    800050be:	fc4e                	sd	s3,56(sp)
    800050c0:	f852                	sd	s4,48(sp)
    800050c2:	f456                	sd	s5,40(sp)
    800050c4:	1080                	addi	s0,sp,96
    800050c6:	84aa                	mv	s1,a0
    800050c8:	892e                	mv	s2,a1
    800050ca:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800050cc:	fe9fc0ef          	jal	800020b4 <myproc>
    800050d0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800050d2:	8526                	mv	a0,s1
    800050d4:	b55fb0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050d8:	2184a703          	lw	a4,536(s1)
    800050dc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050e0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050e4:	02f71763          	bne	a4,a5,80005112 <piperead+0x5e>
    800050e8:	2244a783          	lw	a5,548(s1)
    800050ec:	cf85                	beqz	a5,80005124 <piperead+0x70>
    if(killed(pr)){
    800050ee:	8552                	mv	a0,s4
    800050f0:	97bfd0ef          	jal	80002a6a <killed>
    800050f4:	e11d                	bnez	a0,8000511a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050f6:	85a6                	mv	a1,s1
    800050f8:	854e                	mv	a0,s3
    800050fa:	ed8fd0ef          	jal	800027d2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050fe:	2184a703          	lw	a4,536(s1)
    80005102:	21c4a783          	lw	a5,540(s1)
    80005106:	fef701e3          	beq	a4,a5,800050e8 <piperead+0x34>
    8000510a:	f05a                	sd	s6,32(sp)
    8000510c:	ec5e                	sd	s7,24(sp)
    8000510e:	e862                	sd	s8,16(sp)
    80005110:	a829                	j	8000512a <piperead+0x76>
    80005112:	f05a                	sd	s6,32(sp)
    80005114:	ec5e                	sd	s7,24(sp)
    80005116:	e862                	sd	s8,16(sp)
    80005118:	a809                	j	8000512a <piperead+0x76>
      release(&pi->lock);
    8000511a:	8526                	mv	a0,s1
    8000511c:	ba1fb0ef          	jal	80000cbc <release>
      return -1;
    80005120:	59fd                	li	s3,-1
    80005122:	a0a5                	j	8000518a <piperead+0xd6>
    80005124:	f05a                	sd	s6,32(sp)
    80005126:	ec5e                	sd	s7,24(sp)
    80005128:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000512a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000512c:	faf40c13          	addi	s8,s0,-81
    80005130:	4b85                	li	s7,1
    80005132:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005134:	05505163          	blez	s5,80005176 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80005138:	2184a783          	lw	a5,536(s1)
    8000513c:	21c4a703          	lw	a4,540(s1)
    80005140:	02f70b63          	beq	a4,a5,80005176 <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    80005144:	1ff7f793          	andi	a5,a5,511
    80005148:	97a6                	add	a5,a5,s1
    8000514a:	0187c783          	lbu	a5,24(a5)
    8000514e:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80005152:	86de                	mv	a3,s7
    80005154:	8662                	mv	a2,s8
    80005156:	85ca                	mv	a1,s2
    80005158:	050a3503          	ld	a0,80(s4)
    8000515c:	93bfc0ef          	jal	80001a96 <copyout>
    80005160:	03650f63          	beq	a0,s6,8000519e <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80005164:	2184a783          	lw	a5,536(s1)
    80005168:	2785                	addiw	a5,a5,1
    8000516a:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000516e:	2985                	addiw	s3,s3,1
    80005170:	0905                	addi	s2,s2,1
    80005172:	fd3a93e3          	bne	s5,s3,80005138 <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005176:	21c48513          	addi	a0,s1,540
    8000517a:	ea4fd0ef          	jal	8000281e <wakeup>
  release(&pi->lock);
    8000517e:	8526                	mv	a0,s1
    80005180:	b3dfb0ef          	jal	80000cbc <release>
    80005184:	7b02                	ld	s6,32(sp)
    80005186:	6be2                	ld	s7,24(sp)
    80005188:	6c42                	ld	s8,16(sp)
  return i;
}
    8000518a:	854e                	mv	a0,s3
    8000518c:	60e6                	ld	ra,88(sp)
    8000518e:	6446                	ld	s0,80(sp)
    80005190:	64a6                	ld	s1,72(sp)
    80005192:	6906                	ld	s2,64(sp)
    80005194:	79e2                	ld	s3,56(sp)
    80005196:	7a42                	ld	s4,48(sp)
    80005198:	7aa2                	ld	s5,40(sp)
    8000519a:	6125                	addi	sp,sp,96
    8000519c:	8082                	ret
      if(i == 0)
    8000519e:	fc099ce3          	bnez	s3,80005176 <piperead+0xc2>
        i = -1;
    800051a2:	89aa                	mv	s3,a0
    800051a4:	bfc9                	j	80005176 <piperead+0xc2>

00000000800051a6 <ulazymalloc>:
//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
struct inode* create(char *path, short type, short major, short minor);
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
uint64 a;

  if(va_end < va_start)
    800051a6:	04b66a63          	bltu	a2,a1,800051fa <ulazymalloc+0x54>
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
    800051aa:	7139                	addi	sp,sp,-64
    800051ac:	fc06                	sd	ra,56(sp)
    800051ae:	f822                	sd	s0,48(sp)
    800051b0:	f426                	sd	s1,40(sp)
    800051b2:	f04a                	sd	s2,32(sp)
    800051b4:	e852                	sd	s4,16(sp)
    800051b6:	0080                	addi	s0,sp,64
    800051b8:	8a2a                	mv	s4,a0
    800051ba:	8932                	mv	s2,a2
    return va_start;

  va_start = PGROUNDUP(va_start);
    800051bc:	6785                	lui	a5,0x1
    800051be:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800051c0:	95be                	add	a1,a1,a5
    800051c2:	77fd                	lui	a5,0xfffff
    800051c4:	00f5f4b3          	and	s1,a1,a5
  for(a = va_start; a < va_end; a += PGSIZE){
    800051c8:	02c4fb63          	bgeu	s1,a2,800051fe <ulazymalloc+0x58>
    800051cc:	ec4e                	sd	s3,24(sp)
    800051ce:	e456                	sd	s5,8(sp)
    800051d0:	e05a                	sd	s6,0(sp)
    pte_t *pte = walk(pagetable, a, 1);
    800051d2:	4a85                	li	s5,1
      // In case of failure, we don't have a simple way to deallocate just this segment,
      // so we let kexec handle the full cleanup.
      return 0;
    }
    // Mark as User-accessible with given permissions, but NOT valid (PTE_V=0).
    *pte = PTE_U | xperm;
    800051d4:	0106e993          	ori	s3,a3,16
  for(a = va_start; a < va_end; a += PGSIZE){
    800051d8:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable, a, 1);
    800051da:	8656                	mv	a2,s5
    800051dc:	85a6                	mv	a1,s1
    800051de:	8552                	mv	a0,s4
    800051e0:	dadfb0ef          	jal	80000f8c <walk>
    if(pte == 0){
    800051e4:	cd19                	beqz	a0,80005202 <ulazymalloc+0x5c>
    *pte = PTE_U | xperm;
    800051e6:	01353023          	sd	s3,0(a0)
  for(a = va_start; a < va_end; a += PGSIZE){
    800051ea:	94da                	add	s1,s1,s6
    800051ec:	ff24e7e3          	bltu	s1,s2,800051da <ulazymalloc+0x34>
  }
  return va_end;
    800051f0:	854a                	mv	a0,s2
    800051f2:	69e2                	ld	s3,24(sp)
    800051f4:	6aa2                	ld	s5,8(sp)
    800051f6:	6b02                	ld	s6,0(sp)
    800051f8:	a801                	j	80005208 <ulazymalloc+0x62>
    return va_start;
    800051fa:	852e                	mv	a0,a1
}
    800051fc:	8082                	ret
  return va_end;
    800051fe:	8532                	mv	a0,a2
    80005200:	a021                	j	80005208 <ulazymalloc+0x62>
    80005202:	69e2                	ld	s3,24(sp)
    80005204:	6aa2                	ld	s5,8(sp)
    80005206:	6b02                	ld	s6,0(sp)
}
    80005208:	70e2                	ld	ra,56(sp)
    8000520a:	7442                	ld	s0,48(sp)
    8000520c:	74a2                	ld	s1,40(sp)
    8000520e:	7902                	ld	s2,32(sp)
    80005210:	6a42                	ld	s4,16(sp)
    80005212:	6121                	addi	sp,sp,64
    80005214:	8082                	ret

0000000080005216 <flags2perm>:
// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80005216:	1141                	addi	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	addi	s0,sp,16
    8000521e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005220:	0035151b          	slliw	a0,a0,0x3
    80005224:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80005226:	0027f713          	andi	a4,a5,2
    8000522a:	c319                	beqz	a4,80005230 <flags2perm+0x1a>
      perm |= PTE_W;
    8000522c:	00456513          	ori	a0,a0,4
    if(flags & ELF_PROG_FLAG_READ)
    80005230:	8b91                	andi	a5,a5,4
    80005232:	c399                	beqz	a5,80005238 <flags2perm+0x22>
      perm |= PTE_R;
    80005234:	00256513          	ori	a0,a0,2
    return perm;
}
    80005238:	60a2                	ld	ra,8(sp)
    8000523a:	6402                	ld	s0,0(sp)
    8000523c:	0141                	addi	sp,sp,16
    8000523e:	8082                	ret

0000000080005240 <itoa>:
void
itoa(int n, char *buf, int min_width)
{
    80005240:	1141                	addi	sp,sp,-16
    80005242:	e406                	sd	ra,8(sp)
    80005244:	e022                	sd	s0,0(sp)
    80005246:	0800                	addi	s0,sp,16
  int i = 0;
  if (n == 0) {
    80005248:	c921                	beqz	a0,80005298 <itoa+0x58>
    buf[i++] = '0';
  } else {
    // Generate digits in reverse order.
    while(n > 0){
    8000524a:	86ae                	mv	a3,a1
      buf[i++] = (n % 10) + '0';
    8000524c:	666668b7          	lui	a7,0x66666
    80005250:	66788893          	addi	a7,a7,1639 # 66666667 <_entry-0x19999999>
    while(n > 0){
    80005254:	4325                	li	t1,9
    80005256:	02a05f63          	blez	a0,80005294 <itoa+0x54>
      buf[i++] = (n % 10) + '0';
    8000525a:	03150733          	mul	a4,a0,a7
    8000525e:	9709                	srai	a4,a4,0x22
    80005260:	41f5579b          	sraiw	a5,a0,0x1f
    80005264:	9f1d                	subw	a4,a4,a5
    80005266:	0027179b          	slliw	a5,a4,0x2
    8000526a:	9fb9                	addw	a5,a5,a4
    8000526c:	0017979b          	slliw	a5,a5,0x1
    80005270:	40f507bb          	subw	a5,a0,a5
    80005274:	0307879b          	addiw	a5,a5,48 # fffffffffffff030 <end+0xffffffff7dd984d8>
    80005278:	00f68023          	sb	a5,0(a3)
      n /= 10;
    8000527c:	882a                	mv	a6,a0
    8000527e:	853a                	mv	a0,a4
    while(n > 0){
    80005280:	87b6                	mv	a5,a3
    80005282:	0685                	addi	a3,a3,1
    80005284:	fd034be3          	blt	t1,a6,8000525a <itoa+0x1a>
      buf[i++] = (n % 10) + '0';
    80005288:	40b786bb          	subw	a3,a5,a1
    8000528c:	2685                	addiw	a3,a3,1
    }
  }

  // Add padding if needed.
  while(i < min_width){
    8000528e:	00c6cc63          	blt	a3,a2,800052a6 <itoa+0x66>
    80005292:	a081                	j	800052d2 <itoa+0x92>
  int i = 0;
    80005294:	4681                	li	a3,0
    80005296:	a031                	j	800052a2 <itoa+0x62>
    buf[i++] = '0';
    80005298:	03000793          	li	a5,48
    8000529c:	00f58023          	sb	a5,0(a1)
    800052a0:	4685                	li	a3,1
  while(i < min_width){
    800052a2:	06c6d963          	bge	a3,a2,80005314 <itoa+0xd4>
    800052a6:	87b6                	mv	a5,a3
    buf[i++] = '0';
    800052a8:	03000513          	li	a0,48
    800052ac:	00f58733          	add	a4,a1,a5
    800052b0:	00a70023          	sb	a0,0(a4)
  while(i < min_width){
    800052b4:	0785                	addi	a5,a5,1
    800052b6:	0007871b          	sext.w	a4,a5
    800052ba:	fec749e3          	blt	a4,a2,800052ac <itoa+0x6c>
    800052be:	87b6                	mv	a5,a3
    800052c0:	4701                	li	a4,0
    800052c2:	00c6d563          	bge	a3,a2,800052cc <itoa+0x8c>
    800052c6:	fff6071b          	addiw	a4,a2,-1
    800052ca:	9f15                	subw	a4,a4,a3
    800052cc:	2785                	addiw	a5,a5,1
    800052ce:	00f706bb          	addw	a3,a4,a5
  }

  buf[i] = '\0';
    800052d2:	00d587b3          	add	a5,a1,a3
    800052d6:	00078023          	sb	zero,0(a5)

  // Reverse the entire string to get the correct order.
  for(int j = 0; j < i/2; j++){
    800052da:	4785                	li	a5,1
    800052dc:	02d7d863          	bge	a5,a3,8000530c <itoa+0xcc>
    800052e0:	01f6d51b          	srliw	a0,a3,0x1f
    800052e4:	9d35                	addw	a0,a0,a3
    800052e6:	4015551b          	sraiw	a0,a0,0x1
    800052ea:	87ae                	mv	a5,a1
    800052ec:	15fd                	addi	a1,a1,-1
    800052ee:	95b6                	add	a1,a1,a3
    800052f0:	4701                	li	a4,0
    char temp = buf[j];
    800052f2:	0007c683          	lbu	a3,0(a5)
    buf[j] = buf[i-j-1];
    800052f6:	0005c603          	lbu	a2,0(a1)
    800052fa:	00c78023          	sb	a2,0(a5)
    buf[i-j-1] = temp;
    800052fe:	00d58023          	sb	a3,0(a1)
  for(int j = 0; j < i/2; j++){
    80005302:	2705                	addiw	a4,a4,1
    80005304:	0785                	addi	a5,a5,1
    80005306:	15fd                	addi	a1,a1,-1
    80005308:	fea745e3          	blt	a4,a0,800052f2 <itoa+0xb2>
  }
}
    8000530c:	60a2                	ld	ra,8(sp)
    8000530e:	6402                	ld	s0,0(sp)
    80005310:	0141                	addi	sp,sp,16
    80005312:	8082                	ret
  buf[i] = '\0';
    80005314:	96ae                	add	a3,a3,a1
    80005316:	00068023          	sb	zero,0(a3)
  for(int j = 0; j < i/2; j++){
    8000531a:	bfcd                	j	8000530c <itoa+0xcc>

000000008000531c <strcat>:


char*
strcat(char *dest, const char *src)
{
    8000531c:	1141                	addi	sp,sp,-16
    8000531e:	e406                	sd	ra,8(sp)
    80005320:	e022                	sd	s0,0(sp)
    80005322:	0800                	addi	s0,sp,16
    char *d = dest;
    // Move pointer to the end of the destination string.
    while (*d) {
    80005324:	00054783          	lbu	a5,0(a0)
    80005328:	c38d                	beqz	a5,8000534a <strcat+0x2e>
    char *d = dest;
    8000532a:	87aa                	mv	a5,a0
        d++;
    8000532c:	0785                	addi	a5,a5,1
    while (*d) {
    8000532e:	0007c703          	lbu	a4,0(a5)
    80005332:	ff6d                	bnez	a4,8000532c <strcat+0x10>
    }
    // Copy characters from source to the end of destination.
    while ((*d++ = *src++)) {
    80005334:	0585                	addi	a1,a1,1
    80005336:	0785                	addi	a5,a5,1
    80005338:	fff5c703          	lbu	a4,-1(a1)
    8000533c:	fee78fa3          	sb	a4,-1(a5)
    80005340:	fb75                	bnez	a4,80005334 <strcat+0x18>
        ;
    }
    return dest;
}
    80005342:	60a2                	ld	ra,8(sp)
    80005344:	6402                	ld	s0,0(sp)
    80005346:	0141                	addi	sp,sp,16
    80005348:	8082                	ret
    char *d = dest;
    8000534a:	87aa                	mv	a5,a0
    8000534c:	b7e5                	j	80005334 <strcat+0x18>

000000008000534e <kexec>:
//
// In kernel/exec.c, replace the existing kexec function

int
kexec(char *path, char **argv)
{
    8000534e:	db010113          	addi	sp,sp,-592
    80005352:	24113423          	sd	ra,584(sp)
    80005356:	24813023          	sd	s0,576(sp)
    8000535a:	22913c23          	sd	s1,568(sp)
    8000535e:	23213823          	sd	s2,560(sp)
    80005362:	23313423          	sd	s3,552(sp)
    80005366:	21813023          	sd	s8,512(sp)
    8000536a:	ffe6                	sd	s9,504(sp)
    8000536c:	0c80                	addi	s0,sp,592
    8000536e:	8c2a                	mv	s8,a0
    80005370:	8cae                	mv	s9,a1
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005372:	d43fc0ef          	jal	800020b4 <myproc>
    80005376:	892a                	mv	s2,a0
  char pid_str[16];
  char swap_path[32];
  safestrcpy(swap_path,"/pgswp",sizeof(swap_path));
    80005378:	de840493          	addi	s1,s0,-536
    8000537c:	02000613          	li	a2,32
    80005380:	00003597          	auipc	a1,0x3
    80005384:	4e058593          	addi	a1,a1,1248 # 80008860 <etext+0x860>
    80005388:	8526                	mv	a0,s1
    8000538a:	ac3fb0ef          	jal	80000e4c <safestrcpy>
  safestrcpy(p->swap_path,swap_path,sizeof(swap_path));
    8000538e:	02000613          	li	a2,32
    80005392:	85a6                	mv	a1,s1
    80005394:	00089537          	lui	a0,0x89
    80005398:	1b450513          	addi	a0,a0,436 # 891b4 <_entry-0x7ff76e4c>
    8000539c:	954a                	add	a0,a0,s2
    8000539e:	aaffb0ef          	jal	80000e4c <safestrcpy>
  itoa(p->pid,pid_str,5);
    800053a2:	e0840993          	addi	s3,s0,-504
    800053a6:	4615                	li	a2,5
    800053a8:	85ce                	mv	a1,s3
    800053aa:	03092503          	lw	a0,48(s2)
    800053ae:	e93ff0ef          	jal	80005240 <itoa>
  strcat(swap_path,pid_str);
    800053b2:	85ce                	mv	a1,s3
    800053b4:	8526                	mv	a0,s1
    800053b6:	f67ff0ef          	jal	8000531c <strcat>
  uint64 text_start = -1, text_end = 0;
  uint64 data_start = -1, data_end = 0;

  begin_op();
    800053ba:	b9cff0ef          	jal	80004756 <begin_op>
  // 'create' returns an inode pointer (the on-disk representation).
 ip = create(swap_path, T_FILE, 0, 0);
    800053be:	4681                	li	a3,0
    800053c0:	4601                	li	a2,0
    800053c2:	4589                	li	a1,2
    800053c4:	8526                	mv	a0,s1
    800053c6:	05b000ef          	jal	80005c20 <create>
  if(ip == 0){
    800053ca:	cd51                	beqz	a0,80005466 <kexec+0x118>
    800053cc:	84aa                	mv	s1,a0
    end_op();
    goto bad;
  }

  // Allocate a 'file' structure (the in-memory handle).
  if((p->swap_file = filealloc()) == 0){
    800053ce:	f08ff0ef          	jal	80004ad6 <filealloc>
    800053d2:	16a93c23          	sd	a0,376(s2)
    800053d6:	cd41                	beqz	a0,8000546e <kexec+0x120>
    end_op();
    goto bad;
  }

  // Configure the file handle.
  p->swap_file->type = FD_INODE;
    800053d8:	4789                	li	a5,2
    800053da:	c11c                	sw	a5,0(a0)
  p->swap_file->ip = ip; // Link the handle to the on-disk inode.
    800053dc:	17893783          	ld	a5,376(s2)
    800053e0:	ef84                	sd	s1,24(a5)
  p->swap_file->readable = 1;
    800053e2:	17893703          	ld	a4,376(s2)
    800053e6:	4785                	li	a5,1
    800053e8:	00f70423          	sb	a5,8(a4)
  p->swap_file->writable = 1;
    800053ec:	17893703          	ld	a4,376(s2)
    800053f0:	00f704a3          	sb	a5,9(a4)

  iunlock(ip ); // Unlock the inode; create() returns it locked.
    800053f4:	8526                	mv	a0,s1
    800053f6:	a03fe0ef          	jal	80003df8 <iunlock>
  end_op();
    800053fa:	bccff0ef          	jal	800047c6 <end_op>

  begin_op();
    800053fe:	b58ff0ef          	jal	80004756 <begin_op>

  if((ip = namei(path)) == 0){
    80005402:	8562                	mv	a0,s8
    80005404:	974ff0ef          	jal	80004578 <namei>
    80005408:	84aa                	mv	s1,a0
    8000540a:	c925                	beqz	a0,8000547a <kexec+0x12c>
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
    8000540c:	93ffe0ef          	jal	80003d4a <ilock>
   // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005410:	04000713          	li	a4,64
    80005414:	4681                	li	a3,0
    80005416:	e5040613          	addi	a2,s0,-432
    8000541a:	4581                	li	a1,0
    8000541c:	8526                	mv	a0,s1
    8000541e:	cbffe0ef          	jal	800040dc <readi>
    80005422:	04000793          	li	a5,64
    80005426:	00f51a63          	bne	a0,a5,8000543a <kexec+0xec>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000542a:	e5042703          	lw	a4,-432(s0)
    8000542e:	464c47b7          	lui	a5,0x464c4
    80005432:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005436:	04f70c63          	beq	a4,a5,8000548e <kexec+0x140>

bad:
  if(pagetable)
      proc_freepagetable(pagetable, sz);
  if(ip){
      iunlockput(ip);
    8000543a:	8526                	mv	a0,s1
    8000543c:	b1bfe0ef          	jal	80003f56 <iunlockput>
      end_op();
    80005440:	b86ff0ef          	jal	800047c6 <end_op>
  }
  return -1;
    80005444:	557d                	li	a0,-1
}
    80005446:	24813083          	ld	ra,584(sp)
    8000544a:	24013403          	ld	s0,576(sp)
    8000544e:	23813483          	ld	s1,568(sp)
    80005452:	23013903          	ld	s2,560(sp)
    80005456:	22813983          	ld	s3,552(sp)
    8000545a:	20013c03          	ld	s8,512(sp)
    8000545e:	7cfe                	ld	s9,504(sp)
    80005460:	25010113          	addi	sp,sp,592
    80005464:	8082                	ret
    end_op();
    80005466:	b60ff0ef          	jal	800047c6 <end_op>
  return -1;
    8000546a:	557d                	li	a0,-1
    8000546c:	bfe9                	j	80005446 <kexec+0xf8>
    iunlockput(ip); // Clean up the created inode if filealloc fails.
    8000546e:	8526                	mv	a0,s1
    80005470:	ae7fe0ef          	jal	80003f56 <iunlockput>
    end_op();
    80005474:	b52ff0ef          	jal	800047c6 <end_op>
  if(pagetable)
    80005478:	b7c9                	j	8000543a <kexec+0xec>
    end_op();
    8000547a:	b4cff0ef          	jal	800047c6 <end_op>
    printf("exec checkpoint FAIL: namei failed\n");
    8000547e:	00003517          	auipc	a0,0x3
    80005482:	3ea50513          	addi	a0,a0,1002 # 80008868 <etext+0x868>
    80005486:	874fb0ef          	jal	800004fa <printf>
    return -1;
    8000548a:	557d                	li	a0,-1
    8000548c:	bf6d                	j	80005446 <kexec+0xf8>
    8000548e:	f7ee                	sd	s11,488(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005490:	854a                	mv	a0,s2
    80005492:	d2dfc0ef          	jal	800021be <proc_pagetable>
    80005496:	8daa                	mv	s11,a0
    80005498:	2e050663          	beqz	a0,80005784 <kexec+0x436>
    8000549c:	23413023          	sd	s4,544(sp)
    800054a0:	21513c23          	sd	s5,536(sp)
    800054a4:	21613823          	sd	s6,528(sp)
    800054a8:	21713423          	sd	s7,520(sp)
    800054ac:	fbea                	sd	s10,496(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054ae:	e8845783          	lhu	a5,-376(s0)
    800054b2:	cbe5                	beqz	a5,800055a2 <kexec+0x254>
    800054b4:	e7042683          	lw	a3,-400(s0)
  uint64 data_start = -1, data_end = 0;
    800054b8:	da043c23          	sd	zero,-584(s0)
    800054bc:	57fd                	li	a5,-1
    800054be:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    800054c2:	dc043023          	sd	zero,-576(s0)
    800054c6:	dcf43823          	sd	a5,-560(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800054ca:	4d01                	li	s10,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054cc:	4a81                	li	s5,0
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054ce:	03800b13          	li	s6,56
      if(ph.vaddr % PGSIZE != 0)
    800054d2:	6785                	lui	a5,0x1
    800054d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800054d6:	dcf43c23          	sd	a5,-552(s0)
    800054da:	a091                	j	8000551e <kexec+0x1d0>
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    800054dc:	dd443823          	sd	s4,-560(s0)
          if (ph.vaddr + ph.memsz > text_end) text_end = ph.vaddr + ph.memsz;
    800054e0:	dc043783          	ld	a5,-576(s0)
    800054e4:	0137f463          	bgeu	a5,s3,800054ec <kexec+0x19e>
    800054e8:	dd343023          	sd	s3,-576(s0)
      if((ulazymalloc(pagetable, ph.vaddr, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800054ec:	d2bff0ef          	jal	80005216 <flags2perm>
    800054f0:	86aa                	mv	a3,a0
    800054f2:	864e                	mv	a2,s3
    800054f4:	85d2                	mv	a1,s4
    800054f6:	856e                	mv	a0,s11
    800054f8:	cafff0ef          	jal	800051a6 <ulazymalloc>
    800054fc:	28050663          	beqz	a0,80005788 <kexec+0x43a>
      if(ph.vaddr + ph.memsz > sz)
    80005500:	e2843783          	ld	a5,-472(s0)
    80005504:	e4043703          	ld	a4,-448(s0)
    80005508:	97ba                	add	a5,a5,a4
    8000550a:	00fd7363          	bgeu	s10,a5,80005510 <kexec+0x1c2>
    8000550e:	8d3e                	mv	s10,a5
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005510:	2a85                	addiw	s5,s5,1
    80005512:	038b869b          	addiw	a3,s7,56
    80005516:	e8845783          	lhu	a5,-376(s0)
    8000551a:	08fade63          	bge	s5,a5,800055b6 <kexec+0x268>
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000551e:	8bb6                	mv	s7,a3
    80005520:	875a                	mv	a4,s6
    80005522:	e1840613          	addi	a2,s0,-488
    80005526:	4581                	li	a1,0
    80005528:	8526                	mv	a0,s1
    8000552a:	bb3fe0ef          	jal	800040dc <readi>
    8000552e:	25651d63          	bne	a0,s6,80005788 <kexec+0x43a>
      if(ph.type != ELF_PROG_LOAD)
    80005532:	e1842783          	lw	a5,-488(s0)
    80005536:	4705                	li	a4,1
    80005538:	fce79ce3          	bne	a5,a4,80005510 <kexec+0x1c2>
      if(ph.memsz < ph.filesz)
    8000553c:	e4043983          	ld	s3,-448(s0)
    80005540:	e3843783          	ld	a5,-456(s0)
    80005544:	24f9e263          	bltu	s3,a5,80005788 <kexec+0x43a>
      if(ph.vaddr + ph.memsz < ph.vaddr)
    80005548:	e2843a03          	ld	s4,-472(s0)
    8000554c:	99d2                	add	s3,s3,s4
    8000554e:	2349ed63          	bltu	s3,s4,80005788 <kexec+0x43a>
      if(ph.vaddr % PGSIZE != 0)
    80005552:	dd843783          	ld	a5,-552(s0)
    80005556:	00fa77b3          	and	a5,s4,a5
    8000555a:	22079763          	bnez	a5,80005788 <kexec+0x43a>
      if (ph.flags & ELF_PROG_FLAG_EXEC) { // Text segment
    8000555e:	e1c42503          	lw	a0,-484(s0)
    80005562:	00e577b3          	and	a5,a0,a4
    80005566:	cb99                	beqz	a5,8000557c <kexec+0x22e>
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    80005568:	dd043783          	ld	a5,-560(s0)
    8000556c:	577d                	li	a4,-1
    8000556e:	f6e787e3          	beq	a5,a4,800054dc <kexec+0x18e>
    80005572:	f6fa77e3          	bgeu	s4,a5,800054e0 <kexec+0x192>
    80005576:	dd443823          	sd	s4,-560(s0)
    8000557a:	b79d                	j	800054e0 <kexec+0x192>
          if (data_start == -1 || ph.vaddr < data_start) data_start = ph.vaddr;
    8000557c:	dc843783          	ld	a5,-568(s0)
    80005580:	577d                	li	a4,-1
    80005582:	00e78763          	beq	a5,a4,80005590 <kexec+0x242>
    80005586:	00fa7763          	bgeu	s4,a5,80005594 <kexec+0x246>
    8000558a:	dd443423          	sd	s4,-568(s0)
    8000558e:	a019                	j	80005594 <kexec+0x246>
    80005590:	dd443423          	sd	s4,-568(s0)
          if (ph.vaddr + ph.memsz > data_end) data_end = ph.vaddr + ph.memsz;
    80005594:	db843783          	ld	a5,-584(s0)
    80005598:	f537fae3          	bgeu	a5,s3,800054ec <kexec+0x19e>
    8000559c:	db343c23          	sd	s3,-584(s0)
    800055a0:	b7b1                	j	800054ec <kexec+0x19e>
  uint64 data_start = -1, data_end = 0;
    800055a2:	da043c23          	sd	zero,-584(s0)
    800055a6:	57fd                	li	a5,-1
    800055a8:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    800055ac:	dc043023          	sd	zero,-576(s0)
    800055b0:	dcf43823          	sd	a5,-560(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055b4:	4d01                	li	s10,0
  p->exec_ip = idup(ip);
    800055b6:	8526                	mv	a0,s1
    800055b8:	f5cfe0ef          	jal	80003d14 <idup>
    800055bc:	16a93823          	sd	a0,368(s2)
  iunlockput(ip);
    800055c0:	8526                	mv	a0,s1
    800055c2:	995fe0ef          	jal	80003f56 <iunlockput>
  end_op();
    800055c6:	a00ff0ef          	jal	800047c6 <end_op>
  p = myproc();
    800055ca:	aebfc0ef          	jal	800020b4 <myproc>
    800055ce:	892a                	mv	s2,a0
    800055d0:	dca43c23          	sd	a0,-552(s0)
  uint64 oldsz = p->sz;
    800055d4:	653c                	ld	a5,72(a0)
    800055d6:	daf43823          	sd	a5,-592(s0)
  p->heap_start = sz;
    800055da:	17a53423          	sd	s10,360(a0)
  sz = PGROUNDUP(sz);
    800055de:	6485                	lui	s1,0x1
    800055e0:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    800055e2:	94ea                	add	s1,s1,s10
    800055e4:	77fd                	lui	a5,0xfffff
    800055e6:	8cfd                	and	s1,s1,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800055e8:	4691                	li	a3,4
    800055ea:	6609                	lui	a2,0x2
    800055ec:	9626                	add	a2,a2,s1
    800055ee:	85a6                	mv	a1,s1
    800055f0:	856e                	mv	a0,s11
    800055f2:	a98fc0ef          	jal	8000188a <uvmalloc>
    800055f6:	8d2a                	mv	s10,a0
    800055f8:	e10d                	bnez	a0,8000561a <kexec+0x2cc>
      proc_freepagetable(pagetable, sz);
    800055fa:	85a6                	mv	a1,s1
    800055fc:	856e                	mv	a0,s11
    800055fe:	c45fc0ef          	jal	80002242 <proc_freepagetable>
  return -1;
    80005602:	557d                	li	a0,-1
    80005604:	22013a03          	ld	s4,544(sp)
    80005608:	21813a83          	ld	s5,536(sp)
    8000560c:	21013b03          	ld	s6,528(sp)
    80005610:	20813b83          	ld	s7,520(sp)
    80005614:	7d5e                	ld	s10,496(sp)
    80005616:	7dbe                	ld	s11,488(sp)
    80005618:	b53d                	j	80005446 <kexec+0xf8>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000561a:	75f9                	lui	a1,0xffffe
    8000561c:	84aa                	mv	s1,a0
    8000561e:	95aa                	add	a1,a1,a0
    80005620:	856e                	mv	a0,s11
    80005622:	c4afc0ef          	jal	80001a6c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80005626:	800d0a13          	addi	s4,s10,-2048
    8000562a:	800a0a13          	addi	s4,s4,-2048
  p->text_start = text_start;
    8000562e:	000897b7          	lui	a5,0x89
    80005632:	97ca                	add	a5,a5,s2
    80005634:	dd043603          	ld	a2,-560(s0)
    80005638:	1cc7a823          	sw	a2,464(a5) # 891d0 <_entry-0x7ff76e30>
  p->text_end = text_end;
    8000563c:	dc043683          	ld	a3,-576(s0)
    80005640:	1cd7aa23          	sw	a3,468(a5)
  p->data_start = data_start;
    80005644:	dc843703          	ld	a4,-568(s0)
    80005648:	1ce7ac23          	sw	a4,472(a5)
  p->data_end = data_end;
    8000564c:	db843503          	ld	a0,-584(s0)
    80005650:	1ca7ae23          	sw	a0,476(a5)
  p->stack_top = sp;
    80005654:	1fa7a223          	sw	s10,484(a5)
  printf("[pid %d] INIT-LAZYMAP text=[0x%lx,0x%lx) data=[0x%lx,0x%lx) heap_start=0x%lx stack_top=0x%lx\n",
    80005658:	88ea                	mv	a7,s10
    8000565a:	16893803          	ld	a6,360(s2)
    8000565e:	87aa                	mv	a5,a0
    80005660:	03092583          	lw	a1,48(s2)
    80005664:	00003517          	auipc	a0,0x3
    80005668:	22c50513          	addi	a0,a0,556 # 80008890 <etext+0x890>
    8000566c:	e8ffa0ef          	jal	800004fa <printf>
  for(argc = 0; argv[argc]; argc++) {
    80005670:	000cb503          	ld	a0,0(s9)
    80005674:	4a81                	li	s5,0
      ustack[argc] = sp;
    80005676:	e9040993          	addi	s3,s0,-368
      if(argc >= MAXARG)
    8000567a:	02000913          	li	s2,32
  for(argc = 0; argv[argc]; argc++) {
    8000567e:	c921                	beqz	a0,800056ce <kexec+0x380>
      sp -= strlen(argv[argc]) + 1;
    80005680:	803fb0ef          	jal	80000e82 <strlen>
    80005684:	2505                	addiw	a0,a0,1
    80005686:	40a48533          	sub	a0,s1,a0
      sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000568a:	ff057493          	andi	s1,a0,-16
      if(sp < stackbase)
    8000568e:	1144ec63          	bltu	s1,s4,800057a6 <kexec+0x458>
      if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005692:	8be6                	mv	s7,s9
    80005694:	000cbb03          	ld	s6,0(s9)
    80005698:	855a                	mv	a0,s6
    8000569a:	fe8fb0ef          	jal	80000e82 <strlen>
    8000569e:	0015069b          	addiw	a3,a0,1
    800056a2:	865a                	mv	a2,s6
    800056a4:	85a6                	mv	a1,s1
    800056a6:	856e                	mv	a0,s11
    800056a8:	beefc0ef          	jal	80001a96 <copyout>
    800056ac:	0e054f63          	bltz	a0,800057aa <kexec+0x45c>
      ustack[argc] = sp;
    800056b0:	003a9793          	slli	a5,s5,0x3
    800056b4:	97ce                	add	a5,a5,s3
    800056b6:	e384                	sd	s1,0(a5)
  for(argc = 0; argv[argc]; argc++) {
    800056b8:	0a85                	addi	s5,s5,1
    800056ba:	008c8793          	addi	a5,s9,8
    800056be:	8cbe                	mv	s9,a5
    800056c0:	008bb503          	ld	a0,8(s7)
    800056c4:	c509                	beqz	a0,800056ce <kexec+0x380>
      if(argc >= MAXARG)
    800056c6:	fb2a9de3          	bne	s5,s2,80005680 <kexec+0x332>
  sz = sz1;
    800056ca:	84ea                	mv	s1,s10
    800056cc:	b73d                	j	800055fa <kexec+0x2ac>
  ustack[argc] = 0;
    800056ce:	003a9793          	slli	a5,s5,0x3
    800056d2:	fc078793          	addi	a5,a5,-64
    800056d6:	fd040713          	addi	a4,s0,-48
    800056da:	97ba                	add	a5,a5,a4
    800056dc:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800056e0:	003a9693          	slli	a3,s5,0x3
    800056e4:	06a1                	addi	a3,a3,8
    800056e6:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    800056e8:	ff04fb13          	andi	s6,s1,-16
  sz = sz1;
    800056ec:	84ea                	mv	s1,s10
  if(sp < stackbase)
    800056ee:	f14b66e3          	bltu	s6,s4,800055fa <kexec+0x2ac>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800056f2:	e9040613          	addi	a2,s0,-368
    800056f6:	85da                	mv	a1,s6
    800056f8:	856e                	mv	a0,s11
    800056fa:	b9cfc0ef          	jal	80001a96 <copyout>
    800056fe:	ee054ee3          	bltz	a0,800055fa <kexec+0x2ac>
  p->trapframe->a1 = sp;
    80005702:	dd843783          	ld	a5,-552(s0)
    80005706:	6fbc                	ld	a5,88(a5)
    80005708:	0767bc23          	sd	s6,120(a5)
  for(last=s=path; *s; s++)
    8000570c:	000c4703          	lbu	a4,0(s8)
    80005710:	cf11                	beqz	a4,8000572c <kexec+0x3de>
    80005712:	001c0793          	addi	a5,s8,1
      if(*s == '/')
    80005716:	02f00693          	li	a3,47
    8000571a:	a029                	j	80005724 <kexec+0x3d6>
  for(last=s=path; *s; s++)
    8000571c:	0785                	addi	a5,a5,1
    8000571e:	fff7c703          	lbu	a4,-1(a5)
    80005722:	c709                	beqz	a4,8000572c <kexec+0x3de>
      if(*s == '/')
    80005724:	fed71ce3          	bne	a4,a3,8000571c <kexec+0x3ce>
          last = s+1;
    80005728:	8c3e                	mv	s8,a5
    8000572a:	bfcd                	j	8000571c <kexec+0x3ce>
  safestrcpy(p->name, last, sizeof(p->name));
    8000572c:	4641                	li	a2,16
    8000572e:	85e2                	mv	a1,s8
    80005730:	dd843483          	ld	s1,-552(s0)
    80005734:	15848513          	addi	a0,s1,344
    80005738:	f14fb0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    8000573c:	68a8                	ld	a0,80(s1)
  p->num_resident = 0; 
    8000573e:	000897b7          	lui	a5,0x89
    80005742:	97a6                	add	a5,a5,s1
    80005744:	1a07a823          	sw	zero,432(a5) # 891b0 <_entry-0x7ff76e50>
  p->next_fifo_seq = 0;
    80005748:	1c07a423          	sw	zero,456(a5)
  p->pagetable = pagetable;
    8000574c:	05b4b823          	sd	s11,80(s1)
  p->sz = sz;
    80005750:	05a4b423          	sd	s10,72(s1)
  p->trapframe->epc = elf.entry;
    80005754:	6cbc                	ld	a5,88(s1)
    80005756:	e6843703          	ld	a4,-408(s0)
    8000575a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;
    8000575c:	6cbc                	ld	a5,88(s1)
    8000575e:	0367b823          	sd	s6,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005762:	db043583          	ld	a1,-592(s0)
    80005766:	addfc0ef          	jal	80002242 <proc_freepagetable>
  return argc;
    8000576a:	000a851b          	sext.w	a0,s5
    8000576e:	22013a03          	ld	s4,544(sp)
    80005772:	21813a83          	ld	s5,536(sp)
    80005776:	21013b03          	ld	s6,528(sp)
    8000577a:	20813b83          	ld	s7,520(sp)
    8000577e:	7d5e                	ld	s10,496(sp)
    80005780:	7dbe                	ld	s11,488(sp)
    80005782:	b1d1                	j	80005446 <kexec+0xf8>
    80005784:	7dbe                	ld	s11,488(sp)
    80005786:	b955                	j	8000543a <kexec+0xec>
      proc_freepagetable(pagetable, sz);
    80005788:	85ea                	mv	a1,s10
    8000578a:	856e                	mv	a0,s11
    8000578c:	ab7fc0ef          	jal	80002242 <proc_freepagetable>
  if(ip){
    80005790:	22013a03          	ld	s4,544(sp)
    80005794:	21813a83          	ld	s5,536(sp)
    80005798:	21013b03          	ld	s6,528(sp)
    8000579c:	20813b83          	ld	s7,520(sp)
    800057a0:	7d5e                	ld	s10,496(sp)
    800057a2:	7dbe                	ld	s11,488(sp)
    800057a4:	b959                	j	8000543a <kexec+0xec>
  sz = sz1;
    800057a6:	84ea                	mv	s1,s10
    800057a8:	bd89                	j	800055fa <kexec+0x2ac>
    800057aa:	84ea                	mv	s1,s10
    800057ac:	b5b9                	j	800055fa <kexec+0x2ac>

00000000800057ae <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800057ae:	7179                	addi	sp,sp,-48
    800057b0:	f406                	sd	ra,40(sp)
    800057b2:	f022                	sd	s0,32(sp)
    800057b4:	ec26                	sd	s1,24(sp)
    800057b6:	e84a                	sd	s2,16(sp)
    800057b8:	1800                	addi	s0,sp,48
    800057ba:	892e                	mv	s2,a1
    800057bc:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800057be:	fdc40593          	addi	a1,s0,-36
    800057c2:	a5ffd0ef          	jal	80003220 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800057c6:	fdc42703          	lw	a4,-36(s0)
    800057ca:	47bd                	li	a5,15
    800057cc:	02e7ea63          	bltu	a5,a4,80005800 <argfd+0x52>
    800057d0:	8e5fc0ef          	jal	800020b4 <myproc>
    800057d4:	fdc42703          	lw	a4,-36(s0)
    800057d8:	00371793          	slli	a5,a4,0x3
    800057dc:	0d078793          	addi	a5,a5,208
    800057e0:	953e                	add	a0,a0,a5
    800057e2:	611c                	ld	a5,0(a0)
    800057e4:	c385                	beqz	a5,80005804 <argfd+0x56>
    return -1;
  if(pfd)
    800057e6:	00090463          	beqz	s2,800057ee <argfd+0x40>
    *pfd = fd;
    800057ea:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800057ee:	4501                	li	a0,0
  if(pf)
    800057f0:	c091                	beqz	s1,800057f4 <argfd+0x46>
    *pf = f;
    800057f2:	e09c                	sd	a5,0(s1)
}
    800057f4:	70a2                	ld	ra,40(sp)
    800057f6:	7402                	ld	s0,32(sp)
    800057f8:	64e2                	ld	s1,24(sp)
    800057fa:	6942                	ld	s2,16(sp)
    800057fc:	6145                	addi	sp,sp,48
    800057fe:	8082                	ret
    return -1;
    80005800:	557d                	li	a0,-1
    80005802:	bfcd                	j	800057f4 <argfd+0x46>
    80005804:	557d                	li	a0,-1
    80005806:	b7fd                	j	800057f4 <argfd+0x46>

0000000080005808 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005808:	1101                	addi	sp,sp,-32
    8000580a:	ec06                	sd	ra,24(sp)
    8000580c:	e822                	sd	s0,16(sp)
    8000580e:	e426                	sd	s1,8(sp)
    80005810:	1000                	addi	s0,sp,32
    80005812:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005814:	8a1fc0ef          	jal	800020b4 <myproc>
    80005818:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000581a:	0d050793          	addi	a5,a0,208
    8000581e:	4501                	li	a0,0
    80005820:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005822:	6398                	ld	a4,0(a5)
    80005824:	cb19                	beqz	a4,8000583a <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80005826:	2505                	addiw	a0,a0,1
    80005828:	07a1                	addi	a5,a5,8
    8000582a:	fed51ce3          	bne	a0,a3,80005822 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000582e:	557d                	li	a0,-1
}
    80005830:	60e2                	ld	ra,24(sp)
    80005832:	6442                	ld	s0,16(sp)
    80005834:	64a2                	ld	s1,8(sp)
    80005836:	6105                	addi	sp,sp,32
    80005838:	8082                	ret
      p->ofile[fd] = f;
    8000583a:	00351793          	slli	a5,a0,0x3
    8000583e:	0d078793          	addi	a5,a5,208
    80005842:	963e                	add	a2,a2,a5
    80005844:	e204                	sd	s1,0(a2)
      return fd;
    80005846:	b7ed                	j	80005830 <fdalloc+0x28>

0000000080005848 <sys_dup>:

uint64
sys_dup(void)
{
    80005848:	7179                	addi	sp,sp,-48
    8000584a:	f406                	sd	ra,40(sp)
    8000584c:	f022                	sd	s0,32(sp)
    8000584e:	1800                	addi	s0,sp,48
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    80005850:	fd840613          	addi	a2,s0,-40
    80005854:	4581                	li	a1,0
    80005856:	4501                	li	a0,0
    80005858:	f57ff0ef          	jal	800057ae <argfd>
    return -1;
    8000585c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000585e:	02054363          	bltz	a0,80005884 <sys_dup+0x3c>
    80005862:	ec26                	sd	s1,24(sp)
    80005864:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005866:	fd843483          	ld	s1,-40(s0)
    8000586a:	8526                	mv	a0,s1
    8000586c:	f9dff0ef          	jal	80005808 <fdalloc>
    80005870:	892a                	mv	s2,a0
    return -1;
    80005872:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005874:	00054d63          	bltz	a0,8000588e <sys_dup+0x46>
  filedup(f);
    80005878:	8526                	mv	a0,s1
    8000587a:	abaff0ef          	jal	80004b34 <filedup>
  return fd;
    8000587e:	87ca                	mv	a5,s2
    80005880:	64e2                	ld	s1,24(sp)
    80005882:	6942                	ld	s2,16(sp)
}
    80005884:	853e                	mv	a0,a5
    80005886:	70a2                	ld	ra,40(sp)
    80005888:	7402                	ld	s0,32(sp)
    8000588a:	6145                	addi	sp,sp,48
    8000588c:	8082                	ret
    8000588e:	64e2                	ld	s1,24(sp)
    80005890:	6942                	ld	s2,16(sp)
    80005892:	bfcd                	j	80005884 <sys_dup+0x3c>

0000000080005894 <sys_read>:

uint64
sys_read(void)
{
    80005894:	7179                	addi	sp,sp,-48
    80005896:	f406                	sd	ra,40(sp)
    80005898:	f022                	sd	s0,32(sp)
    8000589a:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    8000589c:	fd840593          	addi	a1,s0,-40
    800058a0:	4505                	li	a0,1
    800058a2:	99bfd0ef          	jal	8000323c <argaddr>
  argint(2, &n);
    800058a6:	fe440593          	addi	a1,s0,-28
    800058aa:	4509                	li	a0,2
    800058ac:	975fd0ef          	jal	80003220 <argint>
  if(argfd(0, 0, &f) < 0)
    800058b0:	fe840613          	addi	a2,s0,-24
    800058b4:	4581                	li	a1,0
    800058b6:	4501                	li	a0,0
    800058b8:	ef7ff0ef          	jal	800057ae <argfd>
    800058bc:	87aa                	mv	a5,a0
    return -1;
    800058be:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058c0:	0007ca63          	bltz	a5,800058d4 <sys_read+0x40>
  return fileread(f, p, n);
    800058c4:	fe442603          	lw	a2,-28(s0)
    800058c8:	fd843583          	ld	a1,-40(s0)
    800058cc:	fe843503          	ld	a0,-24(s0)
    800058d0:	bceff0ef          	jal	80004c9e <fileread>
}
    800058d4:	70a2                	ld	ra,40(sp)
    800058d6:	7402                	ld	s0,32(sp)
    800058d8:	6145                	addi	sp,sp,48
    800058da:	8082                	ret

00000000800058dc <sys_write>:

uint64
sys_write(void)
{
    800058dc:	7179                	addi	sp,sp,-48
    800058de:	f406                	sd	ra,40(sp)
    800058e0:	f022                	sd	s0,32(sp)
    800058e2:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    800058e4:	fd840593          	addi	a1,s0,-40
    800058e8:	4505                	li	a0,1
    800058ea:	953fd0ef          	jal	8000323c <argaddr>
  argint(2, &n);
    800058ee:	fe440593          	addi	a1,s0,-28
    800058f2:	4509                	li	a0,2
    800058f4:	92dfd0ef          	jal	80003220 <argint>
  if(argfd(0, 0, &f) < 0)
    800058f8:	fe840613          	addi	a2,s0,-24
    800058fc:	4581                	li	a1,0
    800058fe:	4501                	li	a0,0
    80005900:	eafff0ef          	jal	800057ae <argfd>
    80005904:	87aa                	mv	a5,a0
    return -1;
    80005906:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005908:	0007ca63          	bltz	a5,8000591c <sys_write+0x40>

  return filewrite(f, p, n);
    8000590c:	fe442603          	lw	a2,-28(s0)
    80005910:	fd843583          	ld	a1,-40(s0)
    80005914:	fe843503          	ld	a0,-24(s0)
    80005918:	c4aff0ef          	jal	80004d62 <filewrite>
}
    8000591c:	70a2                	ld	ra,40(sp)
    8000591e:	7402                	ld	s0,32(sp)
    80005920:	6145                	addi	sp,sp,48
    80005922:	8082                	ret

0000000080005924 <sys_close>:

uint64
sys_close(void)
{
    80005924:	1101                	addi	sp,sp,-32
    80005926:	ec06                	sd	ra,24(sp)
    80005928:	e822                	sd	s0,16(sp)
    8000592a:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    8000592c:	fe040613          	addi	a2,s0,-32
    80005930:	fec40593          	addi	a1,s0,-20
    80005934:	4501                	li	a0,0
    80005936:	e79ff0ef          	jal	800057ae <argfd>
    return -1;
    8000593a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000593c:	02054163          	bltz	a0,8000595e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005940:	f74fc0ef          	jal	800020b4 <myproc>
    80005944:	fec42783          	lw	a5,-20(s0)
    80005948:	078e                	slli	a5,a5,0x3
    8000594a:	0d078793          	addi	a5,a5,208
    8000594e:	953e                	add	a0,a0,a5
    80005950:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005954:	fe043503          	ld	a0,-32(s0)
    80005958:	a22ff0ef          	jal	80004b7a <fileclose>
  return 0;
    8000595c:	4781                	li	a5,0
}
    8000595e:	853e                	mv	a0,a5
    80005960:	60e2                	ld	ra,24(sp)
    80005962:	6442                	ld	s0,16(sp)
    80005964:	6105                	addi	sp,sp,32
    80005966:	8082                	ret

0000000080005968 <sys_fstat>:

uint64
sys_fstat(void)
{
    80005968:	1101                	addi	sp,sp,-32
    8000596a:	ec06                	sd	ra,24(sp)
    8000596c:	e822                	sd	s0,16(sp)
    8000596e:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    80005970:	fe040593          	addi	a1,s0,-32
    80005974:	4505                	li	a0,1
    80005976:	8c7fd0ef          	jal	8000323c <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000597a:	fe840613          	addi	a2,s0,-24
    8000597e:	4581                	li	a1,0
    80005980:	4501                	li	a0,0
    80005982:	e2dff0ef          	jal	800057ae <argfd>
    80005986:	87aa                	mv	a5,a0
    return -1;
    80005988:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000598a:	0007c863          	bltz	a5,8000599a <sys_fstat+0x32>
  return filestat(f, st);
    8000598e:	fe043583          	ld	a1,-32(s0)
    80005992:	fe843503          	ld	a0,-24(s0)
    80005996:	aa6ff0ef          	jal	80004c3c <filestat>
}
    8000599a:	60e2                	ld	ra,24(sp)
    8000599c:	6442                	ld	s0,16(sp)
    8000599e:	6105                	addi	sp,sp,32
    800059a0:	8082                	ret

00000000800059a2 <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    800059a2:	7169                	addi	sp,sp,-304
    800059a4:	f606                	sd	ra,296(sp)
    800059a6:	f222                	sd	s0,288(sp)
    800059a8:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059aa:	08000613          	li	a2,128
    800059ae:	ed040593          	addi	a1,s0,-304
    800059b2:	4501                	li	a0,0
    800059b4:	8a5fd0ef          	jal	80003258 <argstr>
    return -1;
    800059b8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059ba:	0c054e63          	bltz	a0,80005a96 <sys_link+0xf4>
    800059be:	08000613          	li	a2,128
    800059c2:	f5040593          	addi	a1,s0,-176
    800059c6:	4505                	li	a0,1
    800059c8:	891fd0ef          	jal	80003258 <argstr>
    return -1;
    800059cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059ce:	0c054463          	bltz	a0,80005a96 <sys_link+0xf4>
    800059d2:	ee26                	sd	s1,280(sp)

  begin_op();
    800059d4:	d83fe0ef          	jal	80004756 <begin_op>
  if((ip = namei(old)) == 0){
    800059d8:	ed040513          	addi	a0,s0,-304
    800059dc:	b9dfe0ef          	jal	80004578 <namei>
    800059e0:	84aa                	mv	s1,a0
    800059e2:	c53d                	beqz	a0,80005a50 <sys_link+0xae>
    end_op();
    return -1;
  }

  ilock(ip);
    800059e4:	b66fe0ef          	jal	80003d4a <ilock>
  if(ip->type == T_DIR){
    800059e8:	04449703          	lh	a4,68(s1)
    800059ec:	4785                	li	a5,1
    800059ee:	06f70663          	beq	a4,a5,80005a5a <sys_link+0xb8>
    800059f2:	ea4a                	sd	s2,272(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
    800059f4:	04a4d783          	lhu	a5,74(s1)
    800059f8:	2785                	addiw	a5,a5,1
    800059fa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059fe:	8526                	mv	a0,s1
    80005a00:	a96fe0ef          	jal	80003c96 <iupdate>
  iunlock(ip);
    80005a04:	8526                	mv	a0,s1
    80005a06:	bf2fe0ef          	jal	80003df8 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80005a0a:	fd040593          	addi	a1,s0,-48
    80005a0e:	f5040513          	addi	a0,s0,-176
    80005a12:	b81fe0ef          	jal	80004592 <nameiparent>
    80005a16:	892a                	mv	s2,a0
    80005a18:	cd21                	beqz	a0,80005a70 <sys_link+0xce>
    goto bad;
  ilock(dp);
    80005a1a:	b30fe0ef          	jal	80003d4a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005a1e:	854a                	mv	a0,s2
    80005a20:	00092703          	lw	a4,0(s2)
    80005a24:	409c                	lw	a5,0(s1)
    80005a26:	04f71263          	bne	a4,a5,80005a6a <sys_link+0xc8>
    80005a2a:	40d0                	lw	a2,4(s1)
    80005a2c:	fd040593          	addi	a1,s0,-48
    80005a30:	a9ffe0ef          	jal	800044ce <dirlink>
    80005a34:	02054b63          	bltz	a0,80005a6a <sys_link+0xc8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
    80005a38:	854a                	mv	a0,s2
    80005a3a:	d1cfe0ef          	jal	80003f56 <iunlockput>
  iput(ip);
    80005a3e:	8526                	mv	a0,s1
    80005a40:	c8cfe0ef          	jal	80003ecc <iput>

  end_op();
    80005a44:	d83fe0ef          	jal	800047c6 <end_op>

  return 0;
    80005a48:	4781                	li	a5,0
    80005a4a:	64f2                	ld	s1,280(sp)
    80005a4c:	6952                	ld	s2,272(sp)
    80005a4e:	a0a1                	j	80005a96 <sys_link+0xf4>
    end_op();
    80005a50:	d77fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005a54:	57fd                	li	a5,-1
    80005a56:	64f2                	ld	s1,280(sp)
    80005a58:	a83d                	j	80005a96 <sys_link+0xf4>
    iunlockput(ip);
    80005a5a:	8526                	mv	a0,s1
    80005a5c:	cfafe0ef          	jal	80003f56 <iunlockput>
    end_op();
    80005a60:	d67fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005a64:	57fd                	li	a5,-1
    80005a66:	64f2                	ld	s1,280(sp)
    80005a68:	a03d                	j	80005a96 <sys_link+0xf4>
    iunlockput(dp);
    80005a6a:	854a                	mv	a0,s2
    80005a6c:	ceafe0ef          	jal	80003f56 <iunlockput>

bad:
  ilock(ip);
    80005a70:	8526                	mv	a0,s1
    80005a72:	ad8fe0ef          	jal	80003d4a <ilock>
  ip->nlink--;
    80005a76:	04a4d783          	lhu	a5,74(s1)
    80005a7a:	37fd                	addiw	a5,a5,-1
    80005a7c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a80:	8526                	mv	a0,s1
    80005a82:	a14fe0ef          	jal	80003c96 <iupdate>
  iunlockput(ip);
    80005a86:	8526                	mv	a0,s1
    80005a88:	ccefe0ef          	jal	80003f56 <iunlockput>
  end_op();
    80005a8c:	d3bfe0ef          	jal	800047c6 <end_op>
  return -1;
    80005a90:	57fd                	li	a5,-1
    80005a92:	64f2                	ld	s1,280(sp)
    80005a94:	6952                	ld	s2,272(sp)
}
    80005a96:	853e                	mv	a0,a5
    80005a98:	70b2                	ld	ra,296(sp)
    80005a9a:	7412                	ld	s0,288(sp)
    80005a9c:	6155                	addi	sp,sp,304
    80005a9e:	8082                	ret

0000000080005aa0 <sys_unlink>:
  return 1;
}

uint64
sys_unlink(void)
{
    80005aa0:	7151                	addi	sp,sp,-240
    80005aa2:	f586                	sd	ra,232(sp)
    80005aa4:	f1a2                	sd	s0,224(sp)
    80005aa6:	1980                	addi	s0,sp,240
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80005aa8:	08000613          	li	a2,128
    80005aac:	f3040593          	addi	a1,s0,-208
    80005ab0:	4501                	li	a0,0
    80005ab2:	fa6fd0ef          	jal	80003258 <argstr>
    80005ab6:	14054d63          	bltz	a0,80005c10 <sys_unlink+0x170>
    80005aba:	eda6                	sd	s1,216(sp)
    return -1;

  begin_op();
    80005abc:	c9bfe0ef          	jal	80004756 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ac0:	fb040593          	addi	a1,s0,-80
    80005ac4:	f3040513          	addi	a0,s0,-208
    80005ac8:	acbfe0ef          	jal	80004592 <nameiparent>
    80005acc:	84aa                	mv	s1,a0
    80005ace:	c955                	beqz	a0,80005b82 <sys_unlink+0xe2>
    end_op();
    return -1;
  }

  ilock(dp);
    80005ad0:	a7afe0ef          	jal	80003d4a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ad4:	00003597          	auipc	a1,0x3
    80005ad8:	e1c58593          	addi	a1,a1,-484 # 800088f0 <etext+0x8f0>
    80005adc:	fb040513          	addi	a0,s0,-80
    80005ae0:	feefe0ef          	jal	800042ce <namecmp>
    80005ae4:	10050b63          	beqz	a0,80005bfa <sys_unlink+0x15a>
    80005ae8:	00003597          	auipc	a1,0x3
    80005aec:	e1058593          	addi	a1,a1,-496 # 800088f8 <etext+0x8f8>
    80005af0:	fb040513          	addi	a0,s0,-80
    80005af4:	fdafe0ef          	jal	800042ce <namecmp>
    80005af8:	10050163          	beqz	a0,80005bfa <sys_unlink+0x15a>
    80005afc:	e9ca                	sd	s2,208(sp)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80005afe:	f2c40613          	addi	a2,s0,-212
    80005b02:	fb040593          	addi	a1,s0,-80
    80005b06:	8526                	mv	a0,s1
    80005b08:	fdcfe0ef          	jal	800042e4 <dirlookup>
    80005b0c:	892a                	mv	s2,a0
    80005b0e:	0e050563          	beqz	a0,80005bf8 <sys_unlink+0x158>
    80005b12:	e5ce                	sd	s3,200(sp)
    goto bad;
  ilock(ip);
    80005b14:	a36fe0ef          	jal	80003d4a <ilock>

  if(ip->nlink < 1)
    80005b18:	04a91783          	lh	a5,74(s2)
    80005b1c:	06f05863          	blez	a5,80005b8c <sys_unlink+0xec>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b20:	04491703          	lh	a4,68(s2)
    80005b24:	4785                	li	a5,1
    80005b26:	06f70963          	beq	a4,a5,80005b98 <sys_unlink+0xf8>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
    80005b2a:	fc040993          	addi	s3,s0,-64
    80005b2e:	4641                	li	a2,16
    80005b30:	4581                	li	a1,0
    80005b32:	854e                	mv	a0,s3
    80005b34:	9c4fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b38:	4741                	li	a4,16
    80005b3a:	f2c42683          	lw	a3,-212(s0)
    80005b3e:	864e                	mv	a2,s3
    80005b40:	4581                	li	a1,0
    80005b42:	8526                	mv	a0,s1
    80005b44:	e8afe0ef          	jal	800041ce <writei>
    80005b48:	47c1                	li	a5,16
    80005b4a:	08f51863          	bne	a0,a5,80005bda <sys_unlink+0x13a>
    panic("unlink: writei");
  if(ip->type == T_DIR){
    80005b4e:	04491703          	lh	a4,68(s2)
    80005b52:	4785                	li	a5,1
    80005b54:	08f70963          	beq	a4,a5,80005be6 <sys_unlink+0x146>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
    80005b58:	8526                	mv	a0,s1
    80005b5a:	bfcfe0ef          	jal	80003f56 <iunlockput>

  ip->nlink--;
    80005b5e:	04a95783          	lhu	a5,74(s2)
    80005b62:	37fd                	addiw	a5,a5,-1
    80005b64:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b68:	854a                	mv	a0,s2
    80005b6a:	92cfe0ef          	jal	80003c96 <iupdate>
  iunlockput(ip);
    80005b6e:	854a                	mv	a0,s2
    80005b70:	be6fe0ef          	jal	80003f56 <iunlockput>

  end_op();
    80005b74:	c53fe0ef          	jal	800047c6 <end_op>

  return 0;
    80005b78:	4501                	li	a0,0
    80005b7a:	64ee                	ld	s1,216(sp)
    80005b7c:	694e                	ld	s2,208(sp)
    80005b7e:	69ae                	ld	s3,200(sp)
    80005b80:	a061                	j	80005c08 <sys_unlink+0x168>
    end_op();
    80005b82:	c45fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005b86:	557d                	li	a0,-1
    80005b88:	64ee                	ld	s1,216(sp)
    80005b8a:	a8bd                	j	80005c08 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80005b8c:	00003517          	auipc	a0,0x3
    80005b90:	d7450513          	addi	a0,a0,-652 # 80008900 <etext+0x900>
    80005b94:	c91fa0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b98:	04c92703          	lw	a4,76(s2)
    80005b9c:	02000793          	li	a5,32
    80005ba0:	f8e7f5e3          	bgeu	a5,a4,80005b2a <sys_unlink+0x8a>
    80005ba4:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ba6:	4741                	li	a4,16
    80005ba8:	86ce                	mv	a3,s3
    80005baa:	f1840613          	addi	a2,s0,-232
    80005bae:	4581                	li	a1,0
    80005bb0:	854a                	mv	a0,s2
    80005bb2:	d2afe0ef          	jal	800040dc <readi>
    80005bb6:	47c1                	li	a5,16
    80005bb8:	00f51b63          	bne	a0,a5,80005bce <sys_unlink+0x12e>
    if(de.inum != 0)
    80005bbc:	f1845783          	lhu	a5,-232(s0)
    80005bc0:	ebb1                	bnez	a5,80005c14 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bc2:	29c1                	addiw	s3,s3,16
    80005bc4:	04c92783          	lw	a5,76(s2)
    80005bc8:	fcf9efe3          	bltu	s3,a5,80005ba6 <sys_unlink+0x106>
    80005bcc:	bfb9                	j	80005b2a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005bce:	00003517          	auipc	a0,0x3
    80005bd2:	d4a50513          	addi	a0,a0,-694 # 80008918 <etext+0x918>
    80005bd6:	c4ffa0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80005bda:	00003517          	auipc	a0,0x3
    80005bde:	d5650513          	addi	a0,a0,-682 # 80008930 <etext+0x930>
    80005be2:	c43fa0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005be6:	04a4d783          	lhu	a5,74(s1)
    80005bea:	37fd                	addiw	a5,a5,-1
    80005bec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bf0:	8526                	mv	a0,s1
    80005bf2:	8a4fe0ef          	jal	80003c96 <iupdate>
    80005bf6:	b78d                	j	80005b58 <sys_unlink+0xb8>
    80005bf8:	694e                	ld	s2,208(sp)

bad:
  iunlockput(dp);
    80005bfa:	8526                	mv	a0,s1
    80005bfc:	b5afe0ef          	jal	80003f56 <iunlockput>
  end_op();
    80005c00:	bc7fe0ef          	jal	800047c6 <end_op>
  return -1;
    80005c04:	557d                	li	a0,-1
    80005c06:	64ee                	ld	s1,216(sp)
}
    80005c08:	70ae                	ld	ra,232(sp)
    80005c0a:	740e                	ld	s0,224(sp)
    80005c0c:	616d                	addi	sp,sp,240
    80005c0e:	8082                	ret
    return -1;
    80005c10:	557d                	li	a0,-1
    80005c12:	bfdd                	j	80005c08 <sys_unlink+0x168>
    iunlockput(ip);
    80005c14:	854a                	mv	a0,s2
    80005c16:	b40fe0ef          	jal	80003f56 <iunlockput>
    goto bad;
    80005c1a:	694e                	ld	s2,208(sp)
    80005c1c:	69ae                	ld	s3,200(sp)
    80005c1e:	bff1                	j	80005bfa <sys_unlink+0x15a>

0000000080005c20 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
    80005c20:	715d                	addi	sp,sp,-80
    80005c22:	e486                	sd	ra,72(sp)
    80005c24:	e0a2                	sd	s0,64(sp)
    80005c26:	fc26                	sd	s1,56(sp)
    80005c28:	f84a                	sd	s2,48(sp)
    80005c2a:	f44e                	sd	s3,40(sp)
    80005c2c:	f052                	sd	s4,32(sp)
    80005c2e:	ec56                	sd	s5,24(sp)
    80005c30:	e85a                	sd	s6,16(sp)
    80005c32:	0880                	addi	s0,sp,80
    80005c34:	892e                	mv	s2,a1
    80005c36:	8a2e                	mv	s4,a1
    80005c38:	8ab2                	mv	s5,a2
    80005c3a:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005c3c:	fb040593          	addi	a1,s0,-80
    80005c40:	953fe0ef          	jal	80004592 <nameiparent>
    80005c44:	84aa                	mv	s1,a0
    80005c46:	10050763          	beqz	a0,80005d54 <create+0x134>
    return 0;

  ilock(dp);
    80005c4a:	900fe0ef          	jal	80003d4a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005c4e:	4601                	li	a2,0
    80005c50:	fb040593          	addi	a1,s0,-80
    80005c54:	8526                	mv	a0,s1
    80005c56:	e8efe0ef          	jal	800042e4 <dirlookup>
    80005c5a:	89aa                	mv	s3,a0
    80005c5c:	c131                	beqz	a0,80005ca0 <create+0x80>
    iunlockput(dp);
    80005c5e:	8526                	mv	a0,s1
    80005c60:	af6fe0ef          	jal	80003f56 <iunlockput>
    ilock(ip);
    80005c64:	854e                	mv	a0,s3
    80005c66:	8e4fe0ef          	jal	80003d4a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005c6a:	4789                	li	a5,2
    80005c6c:	02f91563          	bne	s2,a5,80005c96 <create+0x76>
    80005c70:	0449d783          	lhu	a5,68(s3)
    80005c74:	37f9                	addiw	a5,a5,-2
    80005c76:	17c2                	slli	a5,a5,0x30
    80005c78:	93c1                	srli	a5,a5,0x30
    80005c7a:	4705                	li	a4,1
    80005c7c:	00f76d63          	bltu	a4,a5,80005c96 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005c80:	854e                	mv	a0,s3
    80005c82:	60a6                	ld	ra,72(sp)
    80005c84:	6406                	ld	s0,64(sp)
    80005c86:	74e2                	ld	s1,56(sp)
    80005c88:	7942                	ld	s2,48(sp)
    80005c8a:	79a2                	ld	s3,40(sp)
    80005c8c:	7a02                	ld	s4,32(sp)
    80005c8e:	6ae2                	ld	s5,24(sp)
    80005c90:	6b42                	ld	s6,16(sp)
    80005c92:	6161                	addi	sp,sp,80
    80005c94:	8082                	ret
    iunlockput(ip);
    80005c96:	854e                	mv	a0,s3
    80005c98:	abefe0ef          	jal	80003f56 <iunlockput>
    return 0;
    80005c9c:	4981                	li	s3,0
    80005c9e:	b7cd                	j	80005c80 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005ca0:	85ca                	mv	a1,s2
    80005ca2:	4088                	lw	a0,0(s1)
    80005ca4:	f37fd0ef          	jal	80003bda <ialloc>
    80005ca8:	892a                	mv	s2,a0
    80005caa:	cd15                	beqz	a0,80005ce6 <create+0xc6>
  ilock(ip);
    80005cac:	89efe0ef          	jal	80003d4a <ilock>
  ip->major = major;
    80005cb0:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005cb4:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005cb8:	4785                	li	a5,1
    80005cba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005cbe:	854a                	mv	a0,s2
    80005cc0:	fd7fd0ef          	jal	80003c96 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005cc4:	4705                	li	a4,1
    80005cc6:	02ea0463          	beq	s4,a4,80005cee <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005cca:	00492603          	lw	a2,4(s2)
    80005cce:	fb040593          	addi	a1,s0,-80
    80005cd2:	8526                	mv	a0,s1
    80005cd4:	ffafe0ef          	jal	800044ce <dirlink>
    80005cd8:	06054263          	bltz	a0,80005d3c <create+0x11c>
  iunlockput(dp);
    80005cdc:	8526                	mv	a0,s1
    80005cde:	a78fe0ef          	jal	80003f56 <iunlockput>
  return ip;
    80005ce2:	89ca                	mv	s3,s2
    80005ce4:	bf71                	j	80005c80 <create+0x60>
    iunlockput(dp);
    80005ce6:	8526                	mv	a0,s1
    80005ce8:	a6efe0ef          	jal	80003f56 <iunlockput>
    return 0;
    80005cec:	bf51                	j	80005c80 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005cee:	00492603          	lw	a2,4(s2)
    80005cf2:	00003597          	auipc	a1,0x3
    80005cf6:	bfe58593          	addi	a1,a1,-1026 # 800088f0 <etext+0x8f0>
    80005cfa:	854a                	mv	a0,s2
    80005cfc:	fd2fe0ef          	jal	800044ce <dirlink>
    80005d00:	02054e63          	bltz	a0,80005d3c <create+0x11c>
    80005d04:	40d0                	lw	a2,4(s1)
    80005d06:	00003597          	auipc	a1,0x3
    80005d0a:	bf258593          	addi	a1,a1,-1038 # 800088f8 <etext+0x8f8>
    80005d0e:	854a                	mv	a0,s2
    80005d10:	fbefe0ef          	jal	800044ce <dirlink>
    80005d14:	02054463          	bltz	a0,80005d3c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005d18:	00492603          	lw	a2,4(s2)
    80005d1c:	fb040593          	addi	a1,s0,-80
    80005d20:	8526                	mv	a0,s1
    80005d22:	facfe0ef          	jal	800044ce <dirlink>
    80005d26:	00054b63          	bltz	a0,80005d3c <create+0x11c>
    dp->nlink++;  // for ".."
    80005d2a:	04a4d783          	lhu	a5,74(s1)
    80005d2e:	2785                	addiw	a5,a5,1
    80005d30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d34:	8526                	mv	a0,s1
    80005d36:	f61fd0ef          	jal	80003c96 <iupdate>
    80005d3a:	b74d                	j	80005cdc <create+0xbc>
  ip->nlink = 0;
    80005d3c:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005d40:	854a                	mv	a0,s2
    80005d42:	f55fd0ef          	jal	80003c96 <iupdate>
  iunlockput(ip);
    80005d46:	854a                	mv	a0,s2
    80005d48:	a0efe0ef          	jal	80003f56 <iunlockput>
  iunlockput(dp);
    80005d4c:	8526                	mv	a0,s1
    80005d4e:	a08fe0ef          	jal	80003f56 <iunlockput>
  return 0;
    80005d52:	b73d                	j	80005c80 <create+0x60>
    return 0;
    80005d54:	89aa                	mv	s3,a0
    80005d56:	b72d                	j	80005c80 <create+0x60>

0000000080005d58 <sys_open>:

uint64
sys_open(void)
{
    80005d58:	7131                	addi	sp,sp,-192
    80005d5a:	fd06                	sd	ra,184(sp)
    80005d5c:	f922                	sd	s0,176(sp)
    80005d5e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d60:	f4c40593          	addi	a1,s0,-180
    80005d64:	4505                	li	a0,1
    80005d66:	cbafd0ef          	jal	80003220 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d6a:	08000613          	li	a2,128
    80005d6e:	f5040593          	addi	a1,s0,-176
    80005d72:	4501                	li	a0,0
    80005d74:	ce4fd0ef          	jal	80003258 <argstr>
    80005d78:	87aa                	mv	a5,a0
    return -1;
    80005d7a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d7c:	0a07c363          	bltz	a5,80005e22 <sys_open+0xca>
    80005d80:	f526                	sd	s1,168(sp)

  begin_op();
    80005d82:	9d5fe0ef          	jal	80004756 <begin_op>

  if(omode & O_CREATE){
    80005d86:	f4c42783          	lw	a5,-180(s0)
    80005d8a:	2007f793          	andi	a5,a5,512
    80005d8e:	c3dd                	beqz	a5,80005e34 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005d90:	4681                	li	a3,0
    80005d92:	4601                	li	a2,0
    80005d94:	4589                	li	a1,2
    80005d96:	f5040513          	addi	a0,s0,-176
    80005d9a:	e87ff0ef          	jal	80005c20 <create>
    80005d9e:	84aa                	mv	s1,a0
    if(ip == 0){
    80005da0:	c549                	beqz	a0,80005e2a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005da2:	04449703          	lh	a4,68(s1)
    80005da6:	478d                	li	a5,3
    80005da8:	00f71763          	bne	a4,a5,80005db6 <sys_open+0x5e>
    80005dac:	0464d703          	lhu	a4,70(s1)
    80005db0:	47a5                	li	a5,9
    80005db2:	0ae7ee63          	bltu	a5,a4,80005e6e <sys_open+0x116>
    80005db6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005db8:	d1ffe0ef          	jal	80004ad6 <filealloc>
    80005dbc:	892a                	mv	s2,a0
    80005dbe:	c561                	beqz	a0,80005e86 <sys_open+0x12e>
    80005dc0:	ed4e                	sd	s3,152(sp)
    80005dc2:	a47ff0ef          	jal	80005808 <fdalloc>
    80005dc6:	89aa                	mv	s3,a0
    80005dc8:	0a054b63          	bltz	a0,80005e7e <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005dcc:	04449703          	lh	a4,68(s1)
    80005dd0:	478d                	li	a5,3
    80005dd2:	0cf70363          	beq	a4,a5,80005e98 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005dd6:	4789                	li	a5,2
    80005dd8:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005ddc:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005de0:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005de4:	f4c42783          	lw	a5,-180(s0)
    80005de8:	0017f713          	andi	a4,a5,1
    80005dec:	00174713          	xori	a4,a4,1
    80005df0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005df4:	0037f713          	andi	a4,a5,3
    80005df8:	00e03733          	snez	a4,a4
    80005dfc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005e00:	4007f793          	andi	a5,a5,1024
    80005e04:	c791                	beqz	a5,80005e10 <sys_open+0xb8>
    80005e06:	04449703          	lh	a4,68(s1)
    80005e0a:	4789                	li	a5,2
    80005e0c:	08f70d63          	beq	a4,a5,80005ea6 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005e10:	8526                	mv	a0,s1
    80005e12:	fe7fd0ef          	jal	80003df8 <iunlock>
  end_op();
    80005e16:	9b1fe0ef          	jal	800047c6 <end_op>

  return fd;
    80005e1a:	854e                	mv	a0,s3
    80005e1c:	74aa                	ld	s1,168(sp)
    80005e1e:	790a                	ld	s2,160(sp)
    80005e20:	69ea                	ld	s3,152(sp)
}
    80005e22:	70ea                	ld	ra,184(sp)
    80005e24:	744a                	ld	s0,176(sp)
    80005e26:	6129                	addi	sp,sp,192
    80005e28:	8082                	ret
      end_op();
    80005e2a:	99dfe0ef          	jal	800047c6 <end_op>
      return -1;
    80005e2e:	557d                	li	a0,-1
    80005e30:	74aa                	ld	s1,168(sp)
    80005e32:	bfc5                	j	80005e22 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005e34:	f5040513          	addi	a0,s0,-176
    80005e38:	f40fe0ef          	jal	80004578 <namei>
    80005e3c:	84aa                	mv	s1,a0
    80005e3e:	c11d                	beqz	a0,80005e64 <sys_open+0x10c>
    ilock(ip);
    80005e40:	f0bfd0ef          	jal	80003d4a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e44:	04449703          	lh	a4,68(s1)
    80005e48:	4785                	li	a5,1
    80005e4a:	f4f71ce3          	bne	a4,a5,80005da2 <sys_open+0x4a>
    80005e4e:	f4c42783          	lw	a5,-180(s0)
    80005e52:	d3b5                	beqz	a5,80005db6 <sys_open+0x5e>
      iunlockput(ip);
    80005e54:	8526                	mv	a0,s1
    80005e56:	900fe0ef          	jal	80003f56 <iunlockput>
      end_op();
    80005e5a:	96dfe0ef          	jal	800047c6 <end_op>
      return -1;
    80005e5e:	557d                	li	a0,-1
    80005e60:	74aa                	ld	s1,168(sp)
    80005e62:	b7c1                	j	80005e22 <sys_open+0xca>
      end_op();
    80005e64:	963fe0ef          	jal	800047c6 <end_op>
      return -1;
    80005e68:	557d                	li	a0,-1
    80005e6a:	74aa                	ld	s1,168(sp)
    80005e6c:	bf5d                	j	80005e22 <sys_open+0xca>
    iunlockput(ip);
    80005e6e:	8526                	mv	a0,s1
    80005e70:	8e6fe0ef          	jal	80003f56 <iunlockput>
    end_op();
    80005e74:	953fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005e78:	557d                	li	a0,-1
    80005e7a:	74aa                	ld	s1,168(sp)
    80005e7c:	b75d                	j	80005e22 <sys_open+0xca>
      fileclose(f);
    80005e7e:	854a                	mv	a0,s2
    80005e80:	cfbfe0ef          	jal	80004b7a <fileclose>
    80005e84:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005e86:	8526                	mv	a0,s1
    80005e88:	8cefe0ef          	jal	80003f56 <iunlockput>
    end_op();
    80005e8c:	93bfe0ef          	jal	800047c6 <end_op>
    return -1;
    80005e90:	557d                	li	a0,-1
    80005e92:	74aa                	ld	s1,168(sp)
    80005e94:	790a                	ld	s2,160(sp)
    80005e96:	b771                	j	80005e22 <sys_open+0xca>
    f->type = FD_DEVICE;
    80005e98:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005e9c:	04649783          	lh	a5,70(s1)
    80005ea0:	02f91223          	sh	a5,36(s2)
    80005ea4:	bf35                	j	80005de0 <sys_open+0x88>
    itrunc(ip);
    80005ea6:	8526                	mv	a0,s1
    80005ea8:	f91fd0ef          	jal	80003e38 <itrunc>
    80005eac:	b795                	j	80005e10 <sys_open+0xb8>

0000000080005eae <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005eae:	7175                	addi	sp,sp,-144
    80005eb0:	e506                	sd	ra,136(sp)
    80005eb2:	e122                	sd	s0,128(sp)
    80005eb4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005eb6:	8a1fe0ef          	jal	80004756 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005eba:	08000613          	li	a2,128
    80005ebe:	f7040593          	addi	a1,s0,-144
    80005ec2:	4501                	li	a0,0
    80005ec4:	b94fd0ef          	jal	80003258 <argstr>
    80005ec8:	02054363          	bltz	a0,80005eee <sys_mkdir+0x40>
    80005ecc:	4681                	li	a3,0
    80005ece:	4601                	li	a2,0
    80005ed0:	4585                	li	a1,1
    80005ed2:	f7040513          	addi	a0,s0,-144
    80005ed6:	d4bff0ef          	jal	80005c20 <create>
    80005eda:	c911                	beqz	a0,80005eee <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005edc:	87afe0ef          	jal	80003f56 <iunlockput>
  end_op();
    80005ee0:	8e7fe0ef          	jal	800047c6 <end_op>
  return 0;
    80005ee4:	4501                	li	a0,0
}
    80005ee6:	60aa                	ld	ra,136(sp)
    80005ee8:	640a                	ld	s0,128(sp)
    80005eea:	6149                	addi	sp,sp,144
    80005eec:	8082                	ret
    end_op();
    80005eee:	8d9fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005ef2:	557d                	li	a0,-1
    80005ef4:	bfcd                	j	80005ee6 <sys_mkdir+0x38>

0000000080005ef6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005ef6:	7135                	addi	sp,sp,-160
    80005ef8:	ed06                	sd	ra,152(sp)
    80005efa:	e922                	sd	s0,144(sp)
    80005efc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005efe:	859fe0ef          	jal	80004756 <begin_op>
  argint(1, &major);
    80005f02:	f6c40593          	addi	a1,s0,-148
    80005f06:	4505                	li	a0,1
    80005f08:	b18fd0ef          	jal	80003220 <argint>
  argint(2, &minor);
    80005f0c:	f6840593          	addi	a1,s0,-152
    80005f10:	4509                	li	a0,2
    80005f12:	b0efd0ef          	jal	80003220 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f16:	08000613          	li	a2,128
    80005f1a:	f7040593          	addi	a1,s0,-144
    80005f1e:	4501                	li	a0,0
    80005f20:	b38fd0ef          	jal	80003258 <argstr>
    80005f24:	02054563          	bltz	a0,80005f4e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f28:	f6841683          	lh	a3,-152(s0)
    80005f2c:	f6c41603          	lh	a2,-148(s0)
    80005f30:	458d                	li	a1,3
    80005f32:	f7040513          	addi	a0,s0,-144
    80005f36:	cebff0ef          	jal	80005c20 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f3a:	c911                	beqz	a0,80005f4e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f3c:	81afe0ef          	jal	80003f56 <iunlockput>
  end_op();
    80005f40:	887fe0ef          	jal	800047c6 <end_op>
  return 0;
    80005f44:	4501                	li	a0,0
}
    80005f46:	60ea                	ld	ra,152(sp)
    80005f48:	644a                	ld	s0,144(sp)
    80005f4a:	610d                	addi	sp,sp,160
    80005f4c:	8082                	ret
    end_op();
    80005f4e:	879fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005f52:	557d                	li	a0,-1
    80005f54:	bfcd                	j	80005f46 <sys_mknod+0x50>

0000000080005f56 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005f56:	7135                	addi	sp,sp,-160
    80005f58:	ed06                	sd	ra,152(sp)
    80005f5a:	e922                	sd	s0,144(sp)
    80005f5c:	e14a                	sd	s2,128(sp)
    80005f5e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f60:	954fc0ef          	jal	800020b4 <myproc>
    80005f64:	892a                	mv	s2,a0
  
  begin_op();
    80005f66:	ff0fe0ef          	jal	80004756 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f6a:	08000613          	li	a2,128
    80005f6e:	f6040593          	addi	a1,s0,-160
    80005f72:	4501                	li	a0,0
    80005f74:	ae4fd0ef          	jal	80003258 <argstr>
    80005f78:	04054363          	bltz	a0,80005fbe <sys_chdir+0x68>
    80005f7c:	e526                	sd	s1,136(sp)
    80005f7e:	f6040513          	addi	a0,s0,-160
    80005f82:	df6fe0ef          	jal	80004578 <namei>
    80005f86:	84aa                	mv	s1,a0
    80005f88:	c915                	beqz	a0,80005fbc <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f8a:	dc1fd0ef          	jal	80003d4a <ilock>
  if(ip->type != T_DIR){
    80005f8e:	04449703          	lh	a4,68(s1)
    80005f92:	4785                	li	a5,1
    80005f94:	02f71963          	bne	a4,a5,80005fc6 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f98:	8526                	mv	a0,s1
    80005f9a:	e5ffd0ef          	jal	80003df8 <iunlock>
  iput(p->cwd);
    80005f9e:	15093503          	ld	a0,336(s2)
    80005fa2:	f2bfd0ef          	jal	80003ecc <iput>
  end_op();
    80005fa6:	821fe0ef          	jal	800047c6 <end_op>
  p->cwd = ip;
    80005faa:	14993823          	sd	s1,336(s2)
  return 0;
    80005fae:	4501                	li	a0,0
    80005fb0:	64aa                	ld	s1,136(sp)
}
    80005fb2:	60ea                	ld	ra,152(sp)
    80005fb4:	644a                	ld	s0,144(sp)
    80005fb6:	690a                	ld	s2,128(sp)
    80005fb8:	610d                	addi	sp,sp,160
    80005fba:	8082                	ret
    80005fbc:	64aa                	ld	s1,136(sp)
    end_op();
    80005fbe:	809fe0ef          	jal	800047c6 <end_op>
    return -1;
    80005fc2:	557d                	li	a0,-1
    80005fc4:	b7fd                	j	80005fb2 <sys_chdir+0x5c>
    iunlockput(ip);
    80005fc6:	8526                	mv	a0,s1
    80005fc8:	f8ffd0ef          	jal	80003f56 <iunlockput>
    end_op();
    80005fcc:	ffafe0ef          	jal	800047c6 <end_op>
    return -1;
    80005fd0:	557d                	li	a0,-1
    80005fd2:	64aa                	ld	s1,136(sp)
    80005fd4:	bff9                	j	80005fb2 <sys_chdir+0x5c>

0000000080005fd6 <sys_exec>:

uint64
sys_exec(void)
{
    80005fd6:	7105                	addi	sp,sp,-480
    80005fd8:	ef86                	sd	ra,472(sp)
    80005fda:	eba2                	sd	s0,464(sp)
    80005fdc:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005fde:	e2840593          	addi	a1,s0,-472
    80005fe2:	4505                	li	a0,1
    80005fe4:	a58fd0ef          	jal	8000323c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005fe8:	08000613          	li	a2,128
    80005fec:	f3040593          	addi	a1,s0,-208
    80005ff0:	4501                	li	a0,0
    80005ff2:	a66fd0ef          	jal	80003258 <argstr>
    80005ff6:	87aa                	mv	a5,a0
    return -1;
    80005ff8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005ffa:	0e07c063          	bltz	a5,800060da <sys_exec+0x104>
    80005ffe:	e7a6                	sd	s1,456(sp)
    80006000:	e3ca                	sd	s2,448(sp)
    80006002:	ff4e                	sd	s3,440(sp)
    80006004:	fb52                	sd	s4,432(sp)
    80006006:	f756                	sd	s5,424(sp)
    80006008:	f35a                	sd	s6,416(sp)
    8000600a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000600c:	e3040a13          	addi	s4,s0,-464
    80006010:	10000613          	li	a2,256
    80006014:	4581                	li	a1,0
    80006016:	8552                	mv	a0,s4
    80006018:	ce1fa0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000601c:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000601e:	89d2                	mv	s3,s4
    80006020:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006022:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006026:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80006028:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000602c:	00391513          	slli	a0,s2,0x3
    80006030:	85d6                	mv	a1,s5
    80006032:	e2843783          	ld	a5,-472(s0)
    80006036:	953e                	add	a0,a0,a5
    80006038:	95efd0ef          	jal	80003196 <fetchaddr>
    8000603c:	02054663          	bltz	a0,80006068 <sys_exec+0x92>
    if(uarg == 0){
    80006040:	e2043783          	ld	a5,-480(s0)
    80006044:	c7a1                	beqz	a5,8000608c <sys_exec+0xb6>
    argv[i] = kalloc();
    80006046:	afffa0ef          	jal	80000b44 <kalloc>
    8000604a:	85aa                	mv	a1,a0
    8000604c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006050:	cd01                	beqz	a0,80006068 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006052:	865a                	mv	a2,s6
    80006054:	e2043503          	ld	a0,-480(s0)
    80006058:	988fd0ef          	jal	800031e0 <fetchstr>
    8000605c:	00054663          	bltz	a0,80006068 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80006060:	0905                	addi	s2,s2,1
    80006062:	09a1                	addi	s3,s3,8
    80006064:	fd7914e3          	bne	s2,s7,8000602c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006068:	100a0a13          	addi	s4,s4,256
    8000606c:	6088                	ld	a0,0(s1)
    8000606e:	cd31                	beqz	a0,800060ca <sys_exec+0xf4>
    kfree(argv[i]);
    80006070:	9edfa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006074:	04a1                	addi	s1,s1,8
    80006076:	ff449be3          	bne	s1,s4,8000606c <sys_exec+0x96>
  return -1;
    8000607a:	557d                	li	a0,-1
    8000607c:	64be                	ld	s1,456(sp)
    8000607e:	691e                	ld	s2,448(sp)
    80006080:	79fa                	ld	s3,440(sp)
    80006082:	7a5a                	ld	s4,432(sp)
    80006084:	7aba                	ld	s5,424(sp)
    80006086:	7b1a                	ld	s6,416(sp)
    80006088:	6bfa                	ld	s7,408(sp)
    8000608a:	a881                	j	800060da <sys_exec+0x104>
      argv[i] = 0;
    8000608c:	0009079b          	sext.w	a5,s2
    80006090:	e3040593          	addi	a1,s0,-464
    80006094:	078e                	slli	a5,a5,0x3
    80006096:	97ae                	add	a5,a5,a1
    80006098:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    8000609c:	f3040513          	addi	a0,s0,-208
    800060a0:	aaeff0ef          	jal	8000534e <kexec>
    800060a4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060a6:	100a0a13          	addi	s4,s4,256
    800060aa:	6088                	ld	a0,0(s1)
    800060ac:	c511                	beqz	a0,800060b8 <sys_exec+0xe2>
    kfree(argv[i]);
    800060ae:	9affa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800060b2:	04a1                	addi	s1,s1,8
    800060b4:	ff449be3          	bne	s1,s4,800060aa <sys_exec+0xd4>
  return ret;
    800060b8:	854a                	mv	a0,s2
    800060ba:	64be                	ld	s1,456(sp)
    800060bc:	691e                	ld	s2,448(sp)
    800060be:	79fa                	ld	s3,440(sp)
    800060c0:	7a5a                	ld	s4,432(sp)
    800060c2:	7aba                	ld	s5,424(sp)
    800060c4:	7b1a                	ld	s6,416(sp)
    800060c6:	6bfa                	ld	s7,408(sp)
    800060c8:	a809                	j	800060da <sys_exec+0x104>
  return -1;
    800060ca:	557d                	li	a0,-1
    800060cc:	64be                	ld	s1,456(sp)
    800060ce:	691e                	ld	s2,448(sp)
    800060d0:	79fa                	ld	s3,440(sp)
    800060d2:	7a5a                	ld	s4,432(sp)
    800060d4:	7aba                	ld	s5,424(sp)
    800060d6:	7b1a                	ld	s6,416(sp)
    800060d8:	6bfa                	ld	s7,408(sp)
}
    800060da:	60fe                	ld	ra,472(sp)
    800060dc:	645e                	ld	s0,464(sp)
    800060de:	613d                	addi	sp,sp,480
    800060e0:	8082                	ret

00000000800060e2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800060e2:	7139                	addi	sp,sp,-64
    800060e4:	fc06                	sd	ra,56(sp)
    800060e6:	f822                	sd	s0,48(sp)
    800060e8:	f426                	sd	s1,40(sp)
    800060ea:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060ec:	fc9fb0ef          	jal	800020b4 <myproc>
    800060f0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800060f2:	fd840593          	addi	a1,s0,-40
    800060f6:	4501                	li	a0,0
    800060f8:	944fd0ef          	jal	8000323c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800060fc:	fc840593          	addi	a1,s0,-56
    80006100:	fd040513          	addi	a0,s0,-48
    80006104:	d93fe0ef          	jal	80004e96 <pipealloc>
    return -1;
    80006108:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000610a:	0a054763          	bltz	a0,800061b8 <sys_pipe+0xd6>
  fd0 = -1;
    8000610e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006112:	fd043503          	ld	a0,-48(s0)
    80006116:	ef2ff0ef          	jal	80005808 <fdalloc>
    8000611a:	fca42223          	sw	a0,-60(s0)
    8000611e:	08054463          	bltz	a0,800061a6 <sys_pipe+0xc4>
    80006122:	fc843503          	ld	a0,-56(s0)
    80006126:	ee2ff0ef          	jal	80005808 <fdalloc>
    8000612a:	fca42023          	sw	a0,-64(s0)
    8000612e:	06054263          	bltz	a0,80006192 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006132:	4691                	li	a3,4
    80006134:	fc440613          	addi	a2,s0,-60
    80006138:	fd843583          	ld	a1,-40(s0)
    8000613c:	68a8                	ld	a0,80(s1)
    8000613e:	959fb0ef          	jal	80001a96 <copyout>
    80006142:	00054e63          	bltz	a0,8000615e <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006146:	4691                	li	a3,4
    80006148:	fc040613          	addi	a2,s0,-64
    8000614c:	fd843583          	ld	a1,-40(s0)
    80006150:	95b6                	add	a1,a1,a3
    80006152:	68a8                	ld	a0,80(s1)
    80006154:	943fb0ef          	jal	80001a96 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006158:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000615a:	04055f63          	bgez	a0,800061b8 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    8000615e:	fc442783          	lw	a5,-60(s0)
    80006162:	078e                	slli	a5,a5,0x3
    80006164:	0d078793          	addi	a5,a5,208
    80006168:	97a6                	add	a5,a5,s1
    8000616a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000616e:	fc042783          	lw	a5,-64(s0)
    80006172:	078e                	slli	a5,a5,0x3
    80006174:	0d078793          	addi	a5,a5,208
    80006178:	97a6                	add	a5,a5,s1
    8000617a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000617e:	fd043503          	ld	a0,-48(s0)
    80006182:	9f9fe0ef          	jal	80004b7a <fileclose>
    fileclose(wf);
    80006186:	fc843503          	ld	a0,-56(s0)
    8000618a:	9f1fe0ef          	jal	80004b7a <fileclose>
    return -1;
    8000618e:	57fd                	li	a5,-1
    80006190:	a025                	j	800061b8 <sys_pipe+0xd6>
    if(fd0 >= 0)
    80006192:	fc442783          	lw	a5,-60(s0)
    80006196:	0007c863          	bltz	a5,800061a6 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    8000619a:	078e                	slli	a5,a5,0x3
    8000619c:	0d078793          	addi	a5,a5,208
    800061a0:	97a6                	add	a5,a5,s1
    800061a2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800061a6:	fd043503          	ld	a0,-48(s0)
    800061aa:	9d1fe0ef          	jal	80004b7a <fileclose>
    fileclose(wf);
    800061ae:	fc843503          	ld	a0,-56(s0)
    800061b2:	9c9fe0ef          	jal	80004b7a <fileclose>
    return -1;
    800061b6:	57fd                	li	a5,-1
}
    800061b8:	853e                	mv	a0,a5
    800061ba:	70e2                	ld	ra,56(sp)
    800061bc:	7442                	ld	s0,48(sp)
    800061be:	74a2                	ld	s1,40(sp)
    800061c0:	6121                	addi	sp,sp,64
    800061c2:	8082                	ret
	...

00000000800061d0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800061d0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800061d2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800061d4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800061d6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800061d8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800061da:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800061dc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800061de:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800061e0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800061e2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800061e4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800061e6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800061e8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800061ea:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800061ec:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800061ee:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800061f0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800061f2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800061f4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800061f6:	eaffc0ef          	jal	800030a4 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800061fa:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800061fc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800061fe:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80006200:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80006202:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80006204:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80006206:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80006208:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000620a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000620c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000620e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80006210:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80006212:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80006214:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80006216:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80006218:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000621a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000621c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000621e:	10200073          	sret
    80006222:	00000013          	nop
    80006226:	00000013          	nop
    8000622a:	00000013          	nop

000000008000622e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000622e:	1141                	addi	sp,sp,-16
    80006230:	e406                	sd	ra,8(sp)
    80006232:	e022                	sd	s0,0(sp)
    80006234:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006236:	0c000737          	lui	a4,0xc000
    8000623a:	4785                	li	a5,1
    8000623c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000623e:	c35c                	sw	a5,4(a4)
}
    80006240:	60a2                	ld	ra,8(sp)
    80006242:	6402                	ld	s0,0(sp)
    80006244:	0141                	addi	sp,sp,16
    80006246:	8082                	ret

0000000080006248 <plicinithart>:

void
plicinithart(void)
{
    80006248:	1141                	addi	sp,sp,-16
    8000624a:	e406                	sd	ra,8(sp)
    8000624c:	e022                	sd	s0,0(sp)
    8000624e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006250:	e31fb0ef          	jal	80002080 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006254:	0085171b          	slliw	a4,a0,0x8
    80006258:	0c0027b7          	lui	a5,0xc002
    8000625c:	97ba                	add	a5,a5,a4
    8000625e:	40200713          	li	a4,1026
    80006262:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006266:	00d5151b          	slliw	a0,a0,0xd
    8000626a:	0c2017b7          	lui	a5,0xc201
    8000626e:	97aa                	add	a5,a5,a0
    80006270:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006274:	60a2                	ld	ra,8(sp)
    80006276:	6402                	ld	s0,0(sp)
    80006278:	0141                	addi	sp,sp,16
    8000627a:	8082                	ret

000000008000627c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000627c:	1141                	addi	sp,sp,-16
    8000627e:	e406                	sd	ra,8(sp)
    80006280:	e022                	sd	s0,0(sp)
    80006282:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006284:	dfdfb0ef          	jal	80002080 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006288:	00d5151b          	slliw	a0,a0,0xd
    8000628c:	0c2017b7          	lui	a5,0xc201
    80006290:	97aa                	add	a5,a5,a0
  return irq;
}
    80006292:	43c8                	lw	a0,4(a5)
    80006294:	60a2                	ld	ra,8(sp)
    80006296:	6402                	ld	s0,0(sp)
    80006298:	0141                	addi	sp,sp,16
    8000629a:	8082                	ret

000000008000629c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000629c:	1101                	addi	sp,sp,-32
    8000629e:	ec06                	sd	ra,24(sp)
    800062a0:	e822                	sd	s0,16(sp)
    800062a2:	e426                	sd	s1,8(sp)
    800062a4:	1000                	addi	s0,sp,32
    800062a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062a8:	dd9fb0ef          	jal	80002080 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062ac:	00d5179b          	slliw	a5,a0,0xd
    800062b0:	0c201737          	lui	a4,0xc201
    800062b4:	97ba                	add	a5,a5,a4
    800062b6:	c3c4                	sw	s1,4(a5)
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	addi	sp,sp,32
    800062c0:	8082                	ret

00000000800062c2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800062c2:	1141                	addi	sp,sp,-16
    800062c4:	e406                	sd	ra,8(sp)
    800062c6:	e022                	sd	s0,0(sp)
    800062c8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800062ca:	479d                	li	a5,7
    800062cc:	04a7ca63          	blt	a5,a0,80006320 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800062d0:	02260797          	auipc	a5,0x2260
    800062d4:	74878793          	addi	a5,a5,1864 # 82266a18 <disk>
    800062d8:	97aa                	add	a5,a5,a0
    800062da:	0187c783          	lbu	a5,24(a5)
    800062de:	e7b9                	bnez	a5,8000632c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800062e0:	00451693          	slli	a3,a0,0x4
    800062e4:	02260797          	auipc	a5,0x2260
    800062e8:	73478793          	addi	a5,a5,1844 # 82266a18 <disk>
    800062ec:	6398                	ld	a4,0(a5)
    800062ee:	9736                	add	a4,a4,a3
    800062f0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800062f4:	6398                	ld	a4,0(a5)
    800062f6:	9736                	add	a4,a4,a3
    800062f8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800062fc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006300:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006304:	97aa                	add	a5,a5,a0
    80006306:	4705                	li	a4,1
    80006308:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000630c:	02260517          	auipc	a0,0x2260
    80006310:	72450513          	addi	a0,a0,1828 # 82266a30 <disk+0x18>
    80006314:	d0afc0ef          	jal	8000281e <wakeup>
}
    80006318:	60a2                	ld	ra,8(sp)
    8000631a:	6402                	ld	s0,0(sp)
    8000631c:	0141                	addi	sp,sp,16
    8000631e:	8082                	ret
    panic("free_desc 1");
    80006320:	00002517          	auipc	a0,0x2
    80006324:	62050513          	addi	a0,a0,1568 # 80008940 <etext+0x940>
    80006328:	cfcfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000632c:	00002517          	auipc	a0,0x2
    80006330:	62450513          	addi	a0,a0,1572 # 80008950 <etext+0x950>
    80006334:	cf0fa0ef          	jal	80000824 <panic>

0000000080006338 <virtio_disk_init>:
{
    80006338:	1101                	addi	sp,sp,-32
    8000633a:	ec06                	sd	ra,24(sp)
    8000633c:	e822                	sd	s0,16(sp)
    8000633e:	e426                	sd	s1,8(sp)
    80006340:	e04a                	sd	s2,0(sp)
    80006342:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006344:	00002597          	auipc	a1,0x2
    80006348:	61c58593          	addi	a1,a1,1564 # 80008960 <etext+0x960>
    8000634c:	02260517          	auipc	a0,0x2260
    80006350:	7f450513          	addi	a0,a0,2036 # 82266b40 <disk+0x128>
    80006354:	84bfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006358:	100017b7          	lui	a5,0x10001
    8000635c:	4398                	lw	a4,0(a5)
    8000635e:	2701                	sext.w	a4,a4
    80006360:	747277b7          	lui	a5,0x74727
    80006364:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006368:	14f71863          	bne	a4,a5,800064b8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000636c:	100017b7          	lui	a5,0x10001
    80006370:	43dc                	lw	a5,4(a5)
    80006372:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006374:	4709                	li	a4,2
    80006376:	14e79163          	bne	a5,a4,800064b8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000637a:	100017b7          	lui	a5,0x10001
    8000637e:	479c                	lw	a5,8(a5)
    80006380:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006382:	12e79b63          	bne	a5,a4,800064b8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006386:	100017b7          	lui	a5,0x10001
    8000638a:	47d8                	lw	a4,12(a5)
    8000638c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000638e:	554d47b7          	lui	a5,0x554d4
    80006392:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006396:	12f71163          	bne	a4,a5,800064b8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000639a:	100017b7          	lui	a5,0x10001
    8000639e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063a2:	4705                	li	a4,1
    800063a4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063a6:	470d                	li	a4,3
    800063a8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063aa:	10001737          	lui	a4,0x10001
    800063ae:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800063b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff45d97c07>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063b8:	8f75                	and	a4,a4,a3
    800063ba:	100016b7          	lui	a3,0x10001
    800063be:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063c0:	472d                	li	a4,11
    800063c2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063c4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800063c8:	439c                	lw	a5,0(a5)
    800063ca:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800063ce:	8ba1                	andi	a5,a5,8
    800063d0:	0e078a63          	beqz	a5,800064c4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063d4:	100017b7          	lui	a5,0x10001
    800063d8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800063dc:	43fc                	lw	a5,68(a5)
    800063de:	2781                	sext.w	a5,a5
    800063e0:	0e079863          	bnez	a5,800064d0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063e4:	100017b7          	lui	a5,0x10001
    800063e8:	5bdc                	lw	a5,52(a5)
    800063ea:	2781                	sext.w	a5,a5
  if(max == 0)
    800063ec:	0e078863          	beqz	a5,800064dc <virtio_disk_init+0x1a4>
  if(max < NUM)
    800063f0:	471d                	li	a4,7
    800063f2:	0ef77b63          	bgeu	a4,a5,800064e8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800063f6:	f4efa0ef          	jal	80000b44 <kalloc>
    800063fa:	02260497          	auipc	s1,0x2260
    800063fe:	61e48493          	addi	s1,s1,1566 # 82266a18 <disk>
    80006402:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006404:	f40fa0ef          	jal	80000b44 <kalloc>
    80006408:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000640a:	f3afa0ef          	jal	80000b44 <kalloc>
    8000640e:	87aa                	mv	a5,a0
    80006410:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006412:	6088                	ld	a0,0(s1)
    80006414:	0e050063          	beqz	a0,800064f4 <virtio_disk_init+0x1bc>
    80006418:	02260717          	auipc	a4,0x2260
    8000641c:	60873703          	ld	a4,1544(a4) # 82266a20 <disk+0x8>
    80006420:	cb71                	beqz	a4,800064f4 <virtio_disk_init+0x1bc>
    80006422:	cbe9                	beqz	a5,800064f4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80006424:	6605                	lui	a2,0x1
    80006426:	4581                	li	a1,0
    80006428:	8d1fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000642c:	02260497          	auipc	s1,0x2260
    80006430:	5ec48493          	addi	s1,s1,1516 # 82266a18 <disk>
    80006434:	6605                	lui	a2,0x1
    80006436:	4581                	li	a1,0
    80006438:	6488                	ld	a0,8(s1)
    8000643a:	8bffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000643e:	6605                	lui	a2,0x1
    80006440:	4581                	li	a1,0
    80006442:	6888                	ld	a0,16(s1)
    80006444:	8b5fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006448:	100017b7          	lui	a5,0x10001
    8000644c:	4721                	li	a4,8
    8000644e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006450:	4098                	lw	a4,0(s1)
    80006452:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006456:	40d8                	lw	a4,4(s1)
    80006458:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000645c:	649c                	ld	a5,8(s1)
    8000645e:	0007869b          	sext.w	a3,a5
    80006462:	10001737          	lui	a4,0x10001
    80006466:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000646a:	9781                	srai	a5,a5,0x20
    8000646c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006470:	689c                	ld	a5,16(s1)
    80006472:	0007869b          	sext.w	a3,a5
    80006476:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000647a:	9781                	srai	a5,a5,0x20
    8000647c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006480:	4785                	li	a5,1
    80006482:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006484:	00f48c23          	sb	a5,24(s1)
    80006488:	00f48ca3          	sb	a5,25(s1)
    8000648c:	00f48d23          	sb	a5,26(s1)
    80006490:	00f48da3          	sb	a5,27(s1)
    80006494:	00f48e23          	sb	a5,28(s1)
    80006498:	00f48ea3          	sb	a5,29(s1)
    8000649c:	00f48f23          	sb	a5,30(s1)
    800064a0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800064a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800064a8:	07272823          	sw	s2,112(a4)
}
    800064ac:	60e2                	ld	ra,24(sp)
    800064ae:	6442                	ld	s0,16(sp)
    800064b0:	64a2                	ld	s1,8(sp)
    800064b2:	6902                	ld	s2,0(sp)
    800064b4:	6105                	addi	sp,sp,32
    800064b6:	8082                	ret
    panic("could not find virtio disk");
    800064b8:	00002517          	auipc	a0,0x2
    800064bc:	4b850513          	addi	a0,a0,1208 # 80008970 <etext+0x970>
    800064c0:	b64fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	4cc50513          	addi	a0,a0,1228 # 80008990 <etext+0x990>
    800064cc:	b58fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    800064d0:	00002517          	auipc	a0,0x2
    800064d4:	4e050513          	addi	a0,a0,1248 # 800089b0 <etext+0x9b0>
    800064d8:	b4cfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    800064dc:	00002517          	auipc	a0,0x2
    800064e0:	4f450513          	addi	a0,a0,1268 # 800089d0 <etext+0x9d0>
    800064e4:	b40fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    800064e8:	00002517          	auipc	a0,0x2
    800064ec:	50850513          	addi	a0,a0,1288 # 800089f0 <etext+0x9f0>
    800064f0:	b34fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    800064f4:	00002517          	auipc	a0,0x2
    800064f8:	51c50513          	addi	a0,a0,1308 # 80008a10 <etext+0xa10>
    800064fc:	b28fa0ef          	jal	80000824 <panic>

0000000080006500 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006500:	711d                	addi	sp,sp,-96
    80006502:	ec86                	sd	ra,88(sp)
    80006504:	e8a2                	sd	s0,80(sp)
    80006506:	e4a6                	sd	s1,72(sp)
    80006508:	e0ca                	sd	s2,64(sp)
    8000650a:	fc4e                	sd	s3,56(sp)
    8000650c:	f852                	sd	s4,48(sp)
    8000650e:	f456                	sd	s5,40(sp)
    80006510:	f05a                	sd	s6,32(sp)
    80006512:	ec5e                	sd	s7,24(sp)
    80006514:	e862                	sd	s8,16(sp)
    80006516:	1080                	addi	s0,sp,96
    80006518:	89aa                	mv	s3,a0
    8000651a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000651c:	00c52b83          	lw	s7,12(a0)
    80006520:	001b9b9b          	slliw	s7,s7,0x1
    80006524:	1b82                	slli	s7,s7,0x20
    80006526:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000652a:	02260517          	auipc	a0,0x2260
    8000652e:	61650513          	addi	a0,a0,1558 # 82266b40 <disk+0x128>
    80006532:	ef6fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80006536:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006538:	02260a97          	auipc	s5,0x2260
    8000653c:	4e0a8a93          	addi	s5,s5,1248 # 82266a18 <disk>
  for(int i = 0; i < 3; i++){
    80006540:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006542:	5c7d                	li	s8,-1
    80006544:	a095                	j	800065a8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80006546:	00fa8733          	add	a4,s5,a5
    8000654a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000654e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006550:	0207c563          	bltz	a5,8000657a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80006554:	2905                	addiw	s2,s2,1
    80006556:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006558:	05490c63          	beq	s2,s4,800065b0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000655c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000655e:	02260717          	auipc	a4,0x2260
    80006562:	4ba70713          	addi	a4,a4,1210 # 82266a18 <disk>
    80006566:	4781                	li	a5,0
    if(disk.free[i]){
    80006568:	01874683          	lbu	a3,24(a4)
    8000656c:	fee9                	bnez	a3,80006546 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000656e:	2785                	addiw	a5,a5,1
    80006570:	0705                	addi	a4,a4,1
    80006572:	fe979be3          	bne	a5,s1,80006568 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80006576:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000657a:	01205d63          	blez	s2,80006594 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000657e:	fa042503          	lw	a0,-96(s0)
    80006582:	d41ff0ef          	jal	800062c2 <free_desc>
      for(int j = 0; j < i; j++)
    80006586:	4785                	li	a5,1
    80006588:	0127d663          	bge	a5,s2,80006594 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000658c:	fa442503          	lw	a0,-92(s0)
    80006590:	d33ff0ef          	jal	800062c2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006594:	02260597          	auipc	a1,0x2260
    80006598:	5ac58593          	addi	a1,a1,1452 # 82266b40 <disk+0x128>
    8000659c:	02260517          	auipc	a0,0x2260
    800065a0:	49450513          	addi	a0,a0,1172 # 82266a30 <disk+0x18>
    800065a4:	a2efc0ef          	jal	800027d2 <sleep>
  for(int i = 0; i < 3; i++){
    800065a8:	fa040613          	addi	a2,s0,-96
    800065ac:	4901                	li	s2,0
    800065ae:	b77d                	j	8000655c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065b0:	fa042503          	lw	a0,-96(s0)
    800065b4:	00451693          	slli	a3,a0,0x4

  if(write)
    800065b8:	02260797          	auipc	a5,0x2260
    800065bc:	46078793          	addi	a5,a5,1120 # 82266a18 <disk>
    800065c0:	00451713          	slli	a4,a0,0x4
    800065c4:	0a070713          	addi	a4,a4,160
    800065c8:	973e                	add	a4,a4,a5
    800065ca:	01603633          	snez	a2,s6
    800065ce:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800065d0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800065d4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800065d8:	6398                	ld	a4,0(a5)
    800065da:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065dc:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800065e0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065e2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800065e4:	6390                	ld	a2,0(a5)
    800065e6:	00d60833          	add	a6,a2,a3
    800065ea:	4741                	li	a4,16
    800065ec:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065f0:	4585                	li	a1,1
    800065f2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    800065f6:	fa442703          	lw	a4,-92(s0)
    800065fa:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800065fe:	0712                	slli	a4,a4,0x4
    80006600:	963a                	add	a2,a2,a4
    80006602:	05898813          	addi	a6,s3,88
    80006606:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000660a:	0007b883          	ld	a7,0(a5)
    8000660e:	9746                	add	a4,a4,a7
    80006610:	40000613          	li	a2,1024
    80006614:	c710                	sw	a2,8(a4)
  if(write)
    80006616:	001b3613          	seqz	a2,s6
    8000661a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000661e:	8e4d                	or	a2,a2,a1
    80006620:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006624:	fa842603          	lw	a2,-88(s0)
    80006628:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000662c:	00451813          	slli	a6,a0,0x4
    80006630:	02080813          	addi	a6,a6,32
    80006634:	983e                	add	a6,a6,a5
    80006636:	577d                	li	a4,-1
    80006638:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000663c:	0612                	slli	a2,a2,0x4
    8000663e:	98b2                	add	a7,a7,a2
    80006640:	03068713          	addi	a4,a3,48
    80006644:	973e                	add	a4,a4,a5
    80006646:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000664a:	6398                	ld	a4,0(a5)
    8000664c:	9732                	add	a4,a4,a2
    8000664e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006650:	4689                	li	a3,2
    80006652:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006656:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000665a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    8000665e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006662:	6794                	ld	a3,8(a5)
    80006664:	0026d703          	lhu	a4,2(a3)
    80006668:	8b1d                	andi	a4,a4,7
    8000666a:	0706                	slli	a4,a4,0x1
    8000666c:	96ba                	add	a3,a3,a4
    8000666e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006672:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006676:	6798                	ld	a4,8(a5)
    80006678:	00275783          	lhu	a5,2(a4)
    8000667c:	2785                	addiw	a5,a5,1
    8000667e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006682:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006686:	100017b7          	lui	a5,0x10001
    8000668a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000668e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006692:	02260917          	auipc	s2,0x2260
    80006696:	4ae90913          	addi	s2,s2,1198 # 82266b40 <disk+0x128>
  while(b->disk == 1) {
    8000669a:	84ae                	mv	s1,a1
    8000669c:	00b79a63          	bne	a5,a1,800066b0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800066a0:	85ca                	mv	a1,s2
    800066a2:	854e                	mv	a0,s3
    800066a4:	92efc0ef          	jal	800027d2 <sleep>
  while(b->disk == 1) {
    800066a8:	0049a783          	lw	a5,4(s3)
    800066ac:	fe978ae3          	beq	a5,s1,800066a0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800066b0:	fa042903          	lw	s2,-96(s0)
    800066b4:	00491713          	slli	a4,s2,0x4
    800066b8:	02070713          	addi	a4,a4,32
    800066bc:	02260797          	auipc	a5,0x2260
    800066c0:	35c78793          	addi	a5,a5,860 # 82266a18 <disk>
    800066c4:	97ba                	add	a5,a5,a4
    800066c6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800066ca:	02260997          	auipc	s3,0x2260
    800066ce:	34e98993          	addi	s3,s3,846 # 82266a18 <disk>
    800066d2:	00491713          	slli	a4,s2,0x4
    800066d6:	0009b783          	ld	a5,0(s3)
    800066da:	97ba                	add	a5,a5,a4
    800066dc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800066e0:	854a                	mv	a0,s2
    800066e2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800066e6:	bddff0ef          	jal	800062c2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800066ea:	8885                	andi	s1,s1,1
    800066ec:	f0fd                	bnez	s1,800066d2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800066ee:	02260517          	auipc	a0,0x2260
    800066f2:	45250513          	addi	a0,a0,1106 # 82266b40 <disk+0x128>
    800066f6:	dc6fa0ef          	jal	80000cbc <release>
}
    800066fa:	60e6                	ld	ra,88(sp)
    800066fc:	6446                	ld	s0,80(sp)
    800066fe:	64a6                	ld	s1,72(sp)
    80006700:	6906                	ld	s2,64(sp)
    80006702:	79e2                	ld	s3,56(sp)
    80006704:	7a42                	ld	s4,48(sp)
    80006706:	7aa2                	ld	s5,40(sp)
    80006708:	7b02                	ld	s6,32(sp)
    8000670a:	6be2                	ld	s7,24(sp)
    8000670c:	6c42                	ld	s8,16(sp)
    8000670e:	6125                	addi	sp,sp,96
    80006710:	8082                	ret

0000000080006712 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006712:	1101                	addi	sp,sp,-32
    80006714:	ec06                	sd	ra,24(sp)
    80006716:	e822                	sd	s0,16(sp)
    80006718:	e426                	sd	s1,8(sp)
    8000671a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000671c:	02260497          	auipc	s1,0x2260
    80006720:	2fc48493          	addi	s1,s1,764 # 82266a18 <disk>
    80006724:	02260517          	auipc	a0,0x2260
    80006728:	41c50513          	addi	a0,a0,1052 # 82266b40 <disk+0x128>
    8000672c:	cfcfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006730:	100017b7          	lui	a5,0x10001
    80006734:	53bc                	lw	a5,96(a5)
    80006736:	8b8d                	andi	a5,a5,3
    80006738:	10001737          	lui	a4,0x10001
    8000673c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000673e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006742:	689c                	ld	a5,16(s1)
    80006744:	0204d703          	lhu	a4,32(s1)
    80006748:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000674c:	04f70863          	beq	a4,a5,8000679c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006750:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006754:	6898                	ld	a4,16(s1)
    80006756:	0204d783          	lhu	a5,32(s1)
    8000675a:	8b9d                	andi	a5,a5,7
    8000675c:	078e                	slli	a5,a5,0x3
    8000675e:	97ba                	add	a5,a5,a4
    80006760:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006762:	00479713          	slli	a4,a5,0x4
    80006766:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000676a:	9726                	add	a4,a4,s1
    8000676c:	01074703          	lbu	a4,16(a4)
    80006770:	e329                	bnez	a4,800067b2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006772:	0792                	slli	a5,a5,0x4
    80006774:	02078793          	addi	a5,a5,32
    80006778:	97a6                	add	a5,a5,s1
    8000677a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000677c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006780:	89efc0ef          	jal	8000281e <wakeup>

    disk.used_idx += 1;
    80006784:	0204d783          	lhu	a5,32(s1)
    80006788:	2785                	addiw	a5,a5,1
    8000678a:	17c2                	slli	a5,a5,0x30
    8000678c:	93c1                	srli	a5,a5,0x30
    8000678e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006792:	6898                	ld	a4,16(s1)
    80006794:	00275703          	lhu	a4,2(a4)
    80006798:	faf71ce3          	bne	a4,a5,80006750 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000679c:	02260517          	auipc	a0,0x2260
    800067a0:	3a450513          	addi	a0,a0,932 # 82266b40 <disk+0x128>
    800067a4:	d18fa0ef          	jal	80000cbc <release>
}
    800067a8:	60e2                	ld	ra,24(sp)
    800067aa:	6442                	ld	s0,16(sp)
    800067ac:	64a2                	ld	s1,8(sp)
    800067ae:	6105                	addi	sp,sp,32
    800067b0:	8082                	ret
      panic("virtio_disk_intr status");
    800067b2:	00002517          	auipc	a0,0x2
    800067b6:	27650513          	addi	a0,a0,630 # 80008a28 <etext+0xa28>
    800067ba:	86afa0ef          	jal	80000824 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
