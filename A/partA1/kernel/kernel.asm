
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	54010113          	addi	sp,sp,1344 # 8000a540 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdabb7>
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
    8000011a:	3c4020ef          	jal	800024de <either_copyin>
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
    80000192:	00012517          	auipc	a0,0x12
    80000196:	3ae50513          	addi	a0,a0,942 # 80012540 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00012497          	auipc	s1,0x12
    800001a2:	3a248493          	addi	s1,s1,930 # 80012540 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00012917          	auipc	s2,0x12
    800001aa:	43290913          	addi	s2,s2,1074 # 800125d8 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	11f010ef          	jal	80001adc <myproc>
    800001c2:	1b4020ef          	jal	80002376 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	761010ef          	jal	8000212c <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00012717          	auipc	a4,0x12
    800001e2:	36270713          	addi	a4,a4,866 # 80012540 <cons>
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
    80000210:	284020ef          	jal	80002494 <either_copyout>
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
    80000228:	00012517          	auipc	a0,0x12
    8000022c:	31850513          	addi	a0,a0,792 # 80012540 <cons>
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
    8000024e:	00012717          	auipc	a4,0x12
    80000252:	38f72523          	sw	a5,906(a4) # 800125d8 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00012517          	auipc	a0,0x12
    80000268:	2dc50513          	addi	a0,a0,732 # 80012540 <cons>
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
    800002b8:	00012517          	auipc	a0,0x12
    800002bc:	28850513          	addi	a0,a0,648 # 80012540 <cons>
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
    800002da:	24e020ef          	jal	80002528 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00012517          	auipc	a0,0x12
    800002e2:	26250513          	addi	a0,a0,610 # 80012540 <cons>
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
    800002fc:	00012717          	auipc	a4,0x12
    80000300:	24470713          	addi	a4,a4,580 # 80012540 <cons>
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
    80000322:	00012717          	auipc	a4,0x12
    80000326:	21e70713          	addi	a4,a4,542 # 80012540 <cons>
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
    8000034c:	00012717          	auipc	a4,0x12
    80000350:	28c72703          	lw	a4,652(a4) # 800125d8 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00012717          	auipc	a4,0x12
    80000366:	1de70713          	addi	a4,a4,478 # 80012540 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00012497          	auipc	s1,0x12
    80000376:	1ce48493          	addi	s1,s1,462 # 80012540 <cons>
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
    800003b4:	00012717          	auipc	a4,0x12
    800003b8:	18c70713          	addi	a4,a4,396 # 80012540 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00012717          	auipc	a4,0x12
    800003ce:	20f72b23          	sw	a5,534(a4) # 800125e0 <cons+0xa0>
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
    800003e8:	00012797          	auipc	a5,0x12
    800003ec:	15878793          	addi	a5,a5,344 # 80012540 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00012797          	auipc	a5,0x12
    8000040e:	1cc7a923          	sw	a2,466(a5) # 800125dc <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00012517          	auipc	a0,0x12
    80000416:	1c650513          	addi	a0,a0,454 # 800125d8 <cons+0x98>
    8000041a:	55f010ef          	jal	80002178 <wakeup>
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
    80000428:	00007597          	auipc	a1,0x7
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80007000 <etext>
    80000430:	00012517          	auipc	a0,0x12
    80000434:	11050513          	addi	a0,a0,272 # 80012540 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00022797          	auipc	a5,0x22
    80000444:	67078793          	addi	a5,a5,1648 # 80022ab0 <devsw>
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
    8000047e:	00007817          	auipc	a6,0x7
    80000482:	47a80813          	addi	a6,a6,1146 # 800078f8 <digits>
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
    80000518:	0000a797          	auipc	a5,0xa
    8000051c:	ffc7a783          	lw	a5,-4(a5) # 8000a514 <panicking>
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
    8000055e:	00012517          	auipc	a0,0x12
    80000562:	08a50513          	addi	a0,a0,138 # 800125e8 <pr>
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
    800006d2:	00007c97          	auipc	s9,0x7
    800006d6:	226c8c93          	addi	s9,s9,550 # 800078f8 <digits>
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
    80000732:	00007a17          	auipc	s4,0x7
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80007008 <etext+0x8>
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
    8000075a:	0000a797          	auipc	a5,0xa
    8000075e:	dba7a783          	lw	a5,-582(a5) # 8000a514 <panicking>
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
    80000784:	00012517          	auipc	a0,0x12
    80000788:	e6450513          	addi	a0,a0,-412 # 800125e8 <pr>
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
    80000834:	0000a797          	auipc	a5,0xa
    80000838:	ce97a023          	sw	s1,-800(a5) # 8000a514 <panicking>
  printf("panic: ");
    8000083c:	00006517          	auipc	a0,0x6
    80000840:	7dc50513          	addi	a0,a0,2012 # 80007018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00006517          	auipc	a0,0x6
    8000084e:	7d650513          	addi	a0,a0,2006 # 80007020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	0000a797          	auipc	a5,0xa
    8000085a:	ca97ad23          	sw	s1,-838(a5) # 8000a510 <panicked>
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
    80000868:	00006597          	auipc	a1,0x6
    8000086c:	7c058593          	addi	a1,a1,1984 # 80007028 <etext+0x28>
    80000870:	00012517          	auipc	a0,0x12
    80000874:	d7850513          	addi	a0,a0,-648 # 800125e8 <pr>
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
    800008be:	00006597          	auipc	a1,0x6
    800008c2:	77258593          	addi	a1,a1,1906 # 80007030 <etext+0x30>
    800008c6:	00012517          	auipc	a0,0x12
    800008ca:	d3a50513          	addi	a0,a0,-710 # 80012600 <tx_lock>
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
    800008ea:	00012517          	auipc	a0,0x12
    800008ee:	d1650513          	addi	a0,a0,-746 # 80012600 <tx_lock>
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
    80000908:	0000a497          	auipc	s1,0xa
    8000090c:	c1448493          	addi	s1,s1,-1004 # 8000a51c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00012997          	auipc	s3,0x12
    80000914:	cf098993          	addi	s3,s3,-784 # 80012600 <tx_lock>
    80000918:	0000a917          	auipc	s2,0xa
    8000091c:	c0090913          	addi	s2,s2,-1024 # 8000a518 <tx_chan>
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
    8000092c:	001010ef          	jal	8000212c <sleep>
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
    80000956:	00012517          	auipc	a0,0x12
    8000095a:	caa50513          	addi	a0,a0,-854 # 80012600 <tx_lock>
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
    8000097a:	0000a797          	auipc	a5,0xa
    8000097e:	b9a7a783          	lw	a5,-1126(a5) # 8000a514 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	0000a797          	auipc	a5,0xa
    80000988:	b8c7a783          	lw	a5,-1140(a5) # 8000a510 <panicked>
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
    800009aa:	0000a797          	auipc	a5,0xa
    800009ae:	b6a7a783          	lw	a5,-1174(a5) # 8000a514 <panicking>
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
    80000a06:	00012517          	auipc	a0,0x12
    80000a0a:	bfa50513          	addi	a0,a0,-1030 # 80012600 <tx_lock>
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
    80000a20:	00012517          	auipc	a0,0x12
    80000a24:	be050513          	addi	a0,a0,-1056 # 80012600 <tx_lock>
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
    80000a3c:	0000a797          	auipc	a5,0xa
    80000a40:	ae07a023          	sw	zero,-1312(a5) # 8000a51c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	0000a517          	auipc	a0,0xa
    80000a48:	ad450513          	addi	a0,a0,-1324 # 8000a518 <tx_chan>
    80000a4c:	72c010ef          	jal	80002178 <wakeup>
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
    80000a68:	00023797          	auipc	a5,0x23
    80000a6c:	1e078793          	addi	a5,a5,480 # 80023c48 <end>
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
    80000a92:	00012917          	auipc	s2,0x12
    80000a96:	b8690913          	addi	s2,s2,-1146 # 80012618 <kmem>
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
    80000abc:	00006517          	auipc	a0,0x6
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80007038 <etext+0x38>
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
    80000b18:	00006597          	auipc	a1,0x6
    80000b1c:	52858593          	addi	a1,a1,1320 # 80007040 <etext+0x40>
    80000b20:	00012517          	auipc	a0,0x12
    80000b24:	af850513          	addi	a0,a0,-1288 # 80012618 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	00023517          	auipc	a0,0x23
    80000b34:	11850513          	addi	a0,a0,280 # 80023c48 <end>
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
    80000b4e:	00012517          	auipc	a0,0x12
    80000b52:	aca50513          	addi	a0,a0,-1334 # 80012618 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00012497          	auipc	s1,0x12
    80000b5e:	ad64b483          	ld	s1,-1322(s1) # 80012630 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00012717          	auipc	a4,0x12
    80000b6a:	acf73523          	sd	a5,-1334(a4) # 80012630 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00012517          	auipc	a0,0x12
    80000b72:	aaa50513          	addi	a0,a0,-1366 # 80012618 <kmem>
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
    80000b90:	00012517          	auipc	a0,0x12
    80000b94:	a8850513          	addi	a0,a0,-1400 # 80012618 <kmem>
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
    80000bce:	6ef000ef          	jal	80001abc <mycpu>
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
    80000bfe:	6bf000ef          	jal	80001abc <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	6b7000ef          	jal	80001abc <mycpu>
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
    80000c1a:	6a3000ef          	jal	80001abc <mycpu>
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
    80000c50:	66d000ef          	jal	80001abc <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00006517          	auipc	a0,0x6
    80000c64:	3e850513          	addi	a0,a0,1000 # 80007048 <etext+0x48>
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
    80000c74:	649000ef          	jal	80001abc <mycpu>
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
    80000ca4:	00006517          	auipc	a0,0x6
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80007050 <etext+0x50>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00006517          	auipc	a0,0x6
    80000cb4:	3b850513          	addi	a0,a0,952 # 80007068 <etext+0x68>
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
    80000cec:	00006517          	auipc	a0,0x6
    80000cf0:	38450513          	addi	a0,a0,900 # 80007070 <etext+0x70>
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
    80000eb6:	3f3000ef          	jal	80001aa8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	00009717          	auipc	a4,0x9
    80000ebe:	66670713          	addi	a4,a4,1638 # 8000a520 <started>
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
    80000ece:	3db000ef          	jal	80001aa8 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00006517          	auipc	a0,0x6
    80000ed8:	1bc50513          	addi	a0,a0,444 # 80007090 <etext+0x90>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	776010ef          	jal	8000265a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	0e1040ef          	jal	800057c8 <plicinithart>
  }

  scheduler();        
    80000eec:	0a6010ef          	jal	80001f92 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00006517          	auipc	a0,0x6
    80000efc:	54050513          	addi	a0,a0,1344 # 80007438 <etext+0x438>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00006517          	auipc	a0,0x6
    80000f08:	17450513          	addi	a0,a0,372 # 80007078 <etext+0x78>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00006517          	auipc	a0,0x6
    80000f14:	52850513          	addi	a0,a0,1320 # 80007438 <etext+0x438>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	4c2000ef          	jal	800013e2 <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	2d1000ef          	jal	800019f8 <procinit>
    trapinit();      // trap vectors
    80000f2c:	70a010ef          	jal	80002636 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	72a010ef          	jal	8000265a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	07b040ef          	jal	800057ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	091040ef          	jal	800057c8 <plicinithart>
    binit();         // buffer cache
    80000f3c:	707010ef          	jal	80002e42 <binit>
    iinit();         // inode table
    80000f40:	458020ef          	jal	80003398 <iinit>
    fileinit();      // file table
    80000f44:	384030ef          	jal	800042c8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	171040ef          	jal	800058b8 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	665000ef          	jal	80001db0 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	00009717          	auipc	a4,0x9
    80000f5a:	5cf72523          	sw	a5,1482(a4) # 8000a520 <started>
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
    80000f6c:	00009797          	auipc	a5,0x9
    80000f70:	5bc7b783          	ld	a5,1468(a5) # 8000a528 <kernel_pagetable>
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
    80000ff2:	00006517          	auipc	a0,0x6
    80000ff6:	0b650513          	addi	a0,a0,182 # 800070a8 <etext+0xa8>
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
    800010ca:	00006517          	auipc	a0,0x6
    800010ce:	fe650513          	addi	a0,a0,-26 # 800070b0 <etext+0xb0>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800010d6:	00006517          	auipc	a0,0x6
    800010da:	ffa50513          	addi	a0,a0,-6 # 800070d0 <etext+0xd0>
    800010de:	f46ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800010e2:	00006517          	auipc	a0,0x6
    800010e6:	00e50513          	addi	a0,a0,14 # 800070f0 <etext+0xf0>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800010ee:	00006517          	auipc	a0,0x6
    800010f2:	01250513          	addi	a0,a0,18 # 80007100 <etext+0x100>
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

0000000080001116 <handle_pgfault>:
{
    80001116:	7155                	addi	sp,sp,-208
    80001118:	e586                	sd	ra,200(sp)
    8000111a:	e1a2                	sd	s0,192(sp)
    8000111c:	f152                	sd	s4,160(sp)
    8000111e:	e162                	sd	s8,128(sp)
    80001120:	0980                	addi	s0,sp,208
    80001122:	8c2a                	mv	s8,a0
    80001124:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80001126:	1b7000ef          	jal	80001adc <myproc>
  if(va >= MAXVA)
    8000112a:	57fd                	li	a5,-1
    8000112c:	83e9                	srli	a5,a5,0x1a
    8000112e:	1b47e963          	bltu	a5,s4,800012e0 <handle_pgfault+0x1ca>
    80001132:	fd26                	sd	s1,184(sp)
    80001134:	f54e                	sd	s3,168(sp)
    80001136:	89aa                	mv	s3,a0
  va = PGROUNDDOWN(va);
    80001138:	77fd                	lui	a5,0xfffff
    8000113a:	00fa7a33          	and	s4,s4,a5
  readi(p->exec_ip, 0, (uint64)&elf, 0, sizeof(elf));
    8000113e:	04000713          	li	a4,64
    80001142:	4681                	li	a3,0
    80001144:	f7040613          	addi	a2,s0,-144
    80001148:	4581                	li	a1,0
    8000114a:	17053503          	ld	a0,368(a0)
    8000114e:	7a4020ef          	jal	800038f2 <readi>
  for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    80001152:	fa845783          	lhu	a5,-88(s0)
    80001156:	cbe9                	beqz	a5,80001228 <handle_pgfault+0x112>
    80001158:	f94a                	sd	s2,176(sp)
    8000115a:	ed56                	sd	s5,152(sp)
    8000115c:	e95a                	sd	s6,144(sp)
    8000115e:	e55e                	sd	s7,136(sp)
    80001160:	f9042683          	lw	a3,-112(s0)
    80001164:	4481                	li	s1,0
    readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    80001166:	f3840b93          	addi	s7,s0,-200
    8000116a:	03800b13          	li	s6,56
    if(ph.type == ELF_PROG_LOAD) {
    8000116e:	4a85                	li	s5,1
    80001170:	a801                	j	80001180 <handle_pgfault+0x6a>
  for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    80001172:	2485                	addiw	s1,s1,1
    80001174:	0389069b          	addiw	a3,s2,56
    80001178:	fa845783          	lhu	a5,-88(s0)
    8000117c:	0af4d263          	bge	s1,a5,80001220 <handle_pgfault+0x10a>
    readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    80001180:	8936                	mv	s2,a3
    80001182:	875a                	mv	a4,s6
    80001184:	865e                	mv	a2,s7
    80001186:	4581                	li	a1,0
    80001188:	1709b503          	ld	a0,368(s3)
    8000118c:	766020ef          	jal	800038f2 <readi>
    if(ph.type == ELF_PROG_LOAD) {
    80001190:	f3842783          	lw	a5,-200(s0)
    80001194:	fd579fe3          	bne	a5,s5,80001172 <handle_pgfault+0x5c>
      if(va >= ph.vaddr && va < ph.vaddr + ph.memsz) {
    80001198:	f4843783          	ld	a5,-184(s0)
    8000119c:	fcfa6be3          	bltu	s4,a5,80001172 <handle_pgfault+0x5c>
    800011a0:	f6043703          	ld	a4,-160(s0)
    800011a4:	97ba                	add	a5,a5,a4
    800011a6:	fcfa76e3          	bgeu	s4,a5,80001172 <handle_pgfault+0x5c>
    mem = kalloc();
    800011aa:	99bff0ef          	jal	80000b44 <kalloc>
    800011ae:	84aa                	mv	s1,a0
    if(mem == 0) { return -1; }
    800011b0:	14050663          	beqz	a0,800012fc <handle_pgfault+0x1e6>
    memset(mem, 0, PGSIZE);
    800011b4:	6605                	lui	a2,0x1
    800011b6:	4581                	li	a1,0
    800011b8:	8526                	mv	a0,s1
    800011ba:	b3fff0ef          	jal	80000cf8 <memset>
    uint file_offset = ph.off + (va - ph.vaddr);
    800011be:	000a069b          	sext.w	a3,s4
    800011c2:	f4842703          	lw	a4,-184(s0)
    uint file_size_to_read = ph.filesz - (va - ph.vaddr);
    800011c6:	f5843783          	ld	a5,-168(s0)
    800011ca:	9fb9                	addw	a5,a5,a4
    800011cc:	414787bb          	subw	a5,a5,s4
    800011d0:	893e                	mv	s2,a5
    if(file_size_to_read > PGSIZE) file_size_to_read = PGSIZE;
    800011d2:	6605                	lui	a2,0x1
    800011d4:	00f67363          	bgeu	a2,a5,800011da <handle_pgfault+0xc4>
    800011d8:	6905                	lui	s2,0x1
    800011da:	2901                	sext.w	s2,s2
    uint file_offset = ph.off + (va - ph.vaddr);
    800011dc:	f4043783          	ld	a5,-192(s0)
    800011e0:	9f99                	subw	a5,a5,a4
    if(readi(p->exec_ip, 0, (uint64)mem, file_offset, file_size_to_read) != file_size_to_read) {
    800011e2:	874a                	mv	a4,s2
    800011e4:	9ebd                	addw	a3,a3,a5
    800011e6:	8626                	mv	a2,s1
    800011e8:	4581                	li	a1,0
    800011ea:	1709b503          	ld	a0,368(s3)
    800011ee:	704020ef          	jal	800038f2 <readi>
    800011f2:	09251063          	bne	a0,s2,80001272 <handle_pgfault+0x15c>
    if(mappages(pagetable, va, PGSIZE, (uint64)mem, flags2perm(ph.flags) | PTE_U) != 0) {
    800011f6:	f3c42503          	lw	a0,-196(s0)
    800011fa:	033030ef          	jal	80004a2c <flags2perm>
    800011fe:	01056713          	ori	a4,a0,16
    80001202:	2701                	sext.w	a4,a4
    80001204:	86a6                	mv	a3,s1
    80001206:	6605                	lui	a2,0x1
    80001208:	85d2                	mv	a1,s4
    8000120a:	8562                	mv	a0,s8
    8000120c:	e55ff0ef          	jal	80001060 <mappages>
    80001210:	ed25                	bnez	a0,80001288 <handle_pgfault+0x172>
    80001212:	74ea                	ld	s1,184(sp)
    80001214:	794a                	ld	s2,176(sp)
    80001216:	79aa                	ld	s3,168(sp)
    80001218:	6aea                	ld	s5,152(sp)
    8000121a:	6b4a                	ld	s6,144(sp)
    8000121c:	6baa                	ld	s7,136(sp)
    8000121e:	a0a1                	j	80001266 <handle_pgfault+0x150>
    80001220:	794a                	ld	s2,176(sp)
    80001222:	6aea                	ld	s5,152(sp)
    80001224:	6b4a                	ld	s6,144(sp)
    80001226:	6baa                	ld	s7,136(sp)
  else if (va < p->sz) {
    80001228:	0489b783          	ld	a5,72(s3)
    8000122c:	06fa6963          	bltu	s4,a5,8000129e <handle_pgfault+0x188>
  else if(va >= p->trapframe->sp - PGSIZE && va < MAXVA) {
    80001230:	0589b783          	ld	a5,88(s3)
    80001234:	7b9c                	ld	a5,48(a5)
    80001236:	80078793          	addi	a5,a5,-2048 # ffffffffffffe800 <end+0xffffffff7ffdabb8>
    8000123a:	80078793          	addi	a5,a5,-2048
    8000123e:	0afa6763          	bltu	s4,a5,800012ec <handle_pgfault+0x1d6>
    mem = kalloc();
    80001242:	903ff0ef          	jal	80000b44 <kalloc>
    80001246:	84aa                	mv	s1,a0
    if(mem == 0) { return -1; }
    80001248:	c555                	beqz	a0,800012f4 <handle_pgfault+0x1de>
    memset(mem, 0, PGSIZE);
    8000124a:	6605                	lui	a2,0x1
    8000124c:	4581                	li	a1,0
    8000124e:	aabff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_U|PTE_R) != 0) {
    80001252:	4759                	li	a4,22
    80001254:	86a6                	mv	a3,s1
    80001256:	6605                	lui	a2,0x1
    80001258:	85d2                	mv	a1,s4
    8000125a:	8562                	mv	a0,s8
    8000125c:	e05ff0ef          	jal	80001060 <mappages>
    80001260:	e92d                	bnez	a0,800012d2 <handle_pgfault+0x1bc>
    80001262:	74ea                	ld	s1,184(sp)
    80001264:	79aa                	ld	s3,168(sp)
}
    80001266:	60ae                	ld	ra,200(sp)
    80001268:	640e                	ld	s0,192(sp)
    8000126a:	7a0a                	ld	s4,160(sp)
    8000126c:	6c0a                	ld	s8,128(sp)
    8000126e:	6169                	addi	sp,sp,208
    80001270:	8082                	ret
      kfree(mem); return -1;
    80001272:	8526                	mv	a0,s1
    80001274:	fe8ff0ef          	jal	80000a5c <kfree>
    80001278:	557d                	li	a0,-1
    8000127a:	74ea                	ld	s1,184(sp)
    8000127c:	794a                	ld	s2,176(sp)
    8000127e:	79aa                	ld	s3,168(sp)
    80001280:	6aea                	ld	s5,152(sp)
    80001282:	6b4a                	ld	s6,144(sp)
    80001284:	6baa                	ld	s7,136(sp)
    80001286:	b7c5                	j	80001266 <handle_pgfault+0x150>
      kfree(mem); return -1;
    80001288:	8526                	mv	a0,s1
    8000128a:	fd2ff0ef          	jal	80000a5c <kfree>
    8000128e:	557d                	li	a0,-1
    80001290:	74ea                	ld	s1,184(sp)
    80001292:	794a                	ld	s2,176(sp)
    80001294:	79aa                	ld	s3,168(sp)
    80001296:	6aea                	ld	s5,152(sp)
    80001298:	6b4a                	ld	s6,144(sp)
    8000129a:	6baa                	ld	s7,136(sp)
    8000129c:	b7e9                	j	80001266 <handle_pgfault+0x150>
    mem = kalloc();
    8000129e:	8a7ff0ef          	jal	80000b44 <kalloc>
    800012a2:	84aa                	mv	s1,a0
    if(mem == 0) { return -1; }
    800012a4:	c121                	beqz	a0,800012e4 <handle_pgfault+0x1ce>
    memset(mem, 0, PGSIZE);
    800012a6:	6605                	lui	a2,0x1
    800012a8:	4581                	li	a1,0
    800012aa:	a4fff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_U|PTE_R) != 0) {
    800012ae:	4759                	li	a4,22
    800012b0:	86a6                	mv	a3,s1
    800012b2:	6605                	lui	a2,0x1
    800012b4:	85d2                	mv	a1,s4
    800012b6:	8562                	mv	a0,s8
    800012b8:	da9ff0ef          	jal	80001060 <mappages>
    800012bc:	e501                	bnez	a0,800012c4 <handle_pgfault+0x1ae>
    800012be:	74ea                	ld	s1,184(sp)
    800012c0:	79aa                	ld	s3,168(sp)
    800012c2:	b755                	j	80001266 <handle_pgfault+0x150>
      kfree(mem); return -1;
    800012c4:	8526                	mv	a0,s1
    800012c6:	f96ff0ef          	jal	80000a5c <kfree>
    800012ca:	557d                	li	a0,-1
    800012cc:	74ea                	ld	s1,184(sp)
    800012ce:	79aa                	ld	s3,168(sp)
    800012d0:	bf59                	j	80001266 <handle_pgfault+0x150>
      kfree(mem); return -1;
    800012d2:	8526                	mv	a0,s1
    800012d4:	f88ff0ef          	jal	80000a5c <kfree>
    800012d8:	557d                	li	a0,-1
    800012da:	74ea                	ld	s1,184(sp)
    800012dc:	79aa                	ld	s3,168(sp)
    800012de:	b761                	j	80001266 <handle_pgfault+0x150>
    return -1;
    800012e0:	557d                	li	a0,-1
    800012e2:	b751                	j	80001266 <handle_pgfault+0x150>
    if(mem == 0) { return -1; }
    800012e4:	557d                	li	a0,-1
    800012e6:	74ea                	ld	s1,184(sp)
    800012e8:	79aa                	ld	s3,168(sp)
    800012ea:	bfb5                	j	80001266 <handle_pgfault+0x150>
    return -1;
    800012ec:	557d                	li	a0,-1
    800012ee:	74ea                	ld	s1,184(sp)
    800012f0:	79aa                	ld	s3,168(sp)
    800012f2:	bf95                	j	80001266 <handle_pgfault+0x150>
    if(mem == 0) { return -1; }
    800012f4:	557d                	li	a0,-1
    800012f6:	74ea                	ld	s1,184(sp)
    800012f8:	79aa                	ld	s3,168(sp)
    800012fa:	b7b5                	j	80001266 <handle_pgfault+0x150>
    if(mem == 0) { return -1; }
    800012fc:	557d                	li	a0,-1
    800012fe:	74ea                	ld	s1,184(sp)
    80001300:	794a                	ld	s2,176(sp)
    80001302:	79aa                	ld	s3,168(sp)
    80001304:	6aea                	ld	s5,152(sp)
    80001306:	6b4a                	ld	s6,144(sp)
    80001308:	6baa                	ld	s7,136(sp)
    8000130a:	bfb1                	j	80001266 <handle_pgfault+0x150>

000000008000130c <kvmmap>:
{
    8000130c:	1141                	addi	sp,sp,-16
    8000130e:	e406                	sd	ra,8(sp)
    80001310:	e022                	sd	s0,0(sp)
    80001312:	0800                	addi	s0,sp,16
    80001314:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001316:	86b2                	mv	a3,a2
    80001318:	863e                	mv	a2,a5
    8000131a:	d47ff0ef          	jal	80001060 <mappages>
    8000131e:	e509                	bnez	a0,80001328 <kvmmap+0x1c>
}
    80001320:	60a2                	ld	ra,8(sp)
    80001322:	6402                	ld	s0,0(sp)
    80001324:	0141                	addi	sp,sp,16
    80001326:	8082                	ret
    panic("kvmmap");
    80001328:	00006517          	auipc	a0,0x6
    8000132c:	de850513          	addi	a0,a0,-536 # 80007110 <etext+0x110>
    80001330:	cf4ff0ef          	jal	80000824 <panic>

0000000080001334 <kvmmake>:
{
    80001334:	1101                	addi	sp,sp,-32
    80001336:	ec06                	sd	ra,24(sp)
    80001338:	e822                	sd	s0,16(sp)
    8000133a:	e426                	sd	s1,8(sp)
    8000133c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000133e:	807ff0ef          	jal	80000b44 <kalloc>
    80001342:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001344:	6605                	lui	a2,0x1
    80001346:	4581                	li	a1,0
    80001348:	9b1ff0ef          	jal	80000cf8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000134c:	4719                	li	a4,6
    8000134e:	6685                	lui	a3,0x1
    80001350:	10000637          	lui	a2,0x10000
    80001354:	85b2                	mv	a1,a2
    80001356:	8526                	mv	a0,s1
    80001358:	fb5ff0ef          	jal	8000130c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000135c:	4719                	li	a4,6
    8000135e:	6685                	lui	a3,0x1
    80001360:	10001637          	lui	a2,0x10001
    80001364:	85b2                	mv	a1,a2
    80001366:	8526                	mv	a0,s1
    80001368:	fa5ff0ef          	jal	8000130c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000136c:	4719                	li	a4,6
    8000136e:	040006b7          	lui	a3,0x4000
    80001372:	0c000637          	lui	a2,0xc000
    80001376:	85b2                	mv	a1,a2
    80001378:	8526                	mv	a0,s1
    8000137a:	f93ff0ef          	jal	8000130c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000137e:	4729                	li	a4,10
    80001380:	80006697          	auipc	a3,0x80006
    80001384:	c8068693          	addi	a3,a3,-896 # 7000 <_entry-0x7fff9000>
    80001388:	4605                	li	a2,1
    8000138a:	067e                	slli	a2,a2,0x1f
    8000138c:	85b2                	mv	a1,a2
    8000138e:	8526                	mv	a0,s1
    80001390:	f7dff0ef          	jal	8000130c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001394:	4719                	li	a4,6
    80001396:	00006697          	auipc	a3,0x6
    8000139a:	c6a68693          	addi	a3,a3,-918 # 80007000 <etext>
    8000139e:	47c5                	li	a5,17
    800013a0:	07ee                	slli	a5,a5,0x1b
    800013a2:	40d786b3          	sub	a3,a5,a3
    800013a6:	00006617          	auipc	a2,0x6
    800013aa:	c5a60613          	addi	a2,a2,-934 # 80007000 <etext>
    800013ae:	85b2                	mv	a1,a2
    800013b0:	8526                	mv	a0,s1
    800013b2:	f5bff0ef          	jal	8000130c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013b6:	4729                	li	a4,10
    800013b8:	6685                	lui	a3,0x1
    800013ba:	00005617          	auipc	a2,0x5
    800013be:	c4660613          	addi	a2,a2,-954 # 80006000 <_trampoline>
    800013c2:	040005b7          	lui	a1,0x4000
    800013c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800013c8:	05b2                	slli	a1,a1,0xc
    800013ca:	8526                	mv	a0,s1
    800013cc:	f41ff0ef          	jal	8000130c <kvmmap>
  proc_mapstacks(kpgtbl);
    800013d0:	8526                	mv	a0,s1
    800013d2:	588000ef          	jal	8000195a <proc_mapstacks>
}
    800013d6:	8526                	mv	a0,s1
    800013d8:	60e2                	ld	ra,24(sp)
    800013da:	6442                	ld	s0,16(sp)
    800013dc:	64a2                	ld	s1,8(sp)
    800013de:	6105                	addi	sp,sp,32
    800013e0:	8082                	ret

00000000800013e2 <kvminit>:
{
    800013e2:	1141                	addi	sp,sp,-16
    800013e4:	e406                	sd	ra,8(sp)
    800013e6:	e022                	sd	s0,0(sp)
    800013e8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800013ea:	f4bff0ef          	jal	80001334 <kvmmake>
    800013ee:	00009797          	auipc	a5,0x9
    800013f2:	12a7bd23          	sd	a0,314(a5) # 8000a528 <kernel_pagetable>
}
    800013f6:	60a2                	ld	ra,8(sp)
    800013f8:	6402                	ld	s0,0(sp)
    800013fa:	0141                	addi	sp,sp,16
    800013fc:	8082                	ret

00000000800013fe <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013fe:	1101                	addi	sp,sp,-32
    80001400:	ec06                	sd	ra,24(sp)
    80001402:	e822                	sd	s0,16(sp)
    80001404:	e426                	sd	s1,8(sp)
    80001406:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001408:	f3cff0ef          	jal	80000b44 <kalloc>
    8000140c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000140e:	c509                	beqz	a0,80001418 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001410:	6605                	lui	a2,0x1
    80001412:	4581                	li	a1,0
    80001414:	8e5ff0ef          	jal	80000cf8 <memset>
  return pagetable;
}
    80001418:	8526                	mv	a0,s1
    8000141a:	60e2                	ld	ra,24(sp)
    8000141c:	6442                	ld	s0,16(sp)
    8000141e:	64a2                	ld	s1,8(sp)
    80001420:	6105                	addi	sp,sp,32
    80001422:	8082                	ret

0000000080001424 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001424:	7139                	addi	sp,sp,-64
    80001426:	fc06                	sd	ra,56(sp)
    80001428:	f822                	sd	s0,48(sp)
    8000142a:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000142c:	03459793          	slli	a5,a1,0x34
    80001430:	e38d                	bnez	a5,80001452 <uvmunmap+0x2e>
    80001432:	f04a                	sd	s2,32(sp)
    80001434:	ec4e                	sd	s3,24(sp)
    80001436:	e852                	sd	s4,16(sp)
    80001438:	e456                	sd	s5,8(sp)
    8000143a:	e05a                	sd	s6,0(sp)
    8000143c:	8a2a                	mv	s4,a0
    8000143e:	892e                	mv	s2,a1
    80001440:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001442:	0632                	slli	a2,a2,0xc
    80001444:	00b609b3          	add	s3,a2,a1
    80001448:	6b05                	lui	s6,0x1
    8000144a:	0535f963          	bgeu	a1,s3,8000149c <uvmunmap+0x78>
    8000144e:	f426                	sd	s1,40(sp)
    80001450:	a015                	j	80001474 <uvmunmap+0x50>
    80001452:	f426                	sd	s1,40(sp)
    80001454:	f04a                	sd	s2,32(sp)
    80001456:	ec4e                	sd	s3,24(sp)
    80001458:	e852                	sd	s4,16(sp)
    8000145a:	e456                	sd	s5,8(sp)
    8000145c:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000145e:	00006517          	auipc	a0,0x6
    80001462:	cba50513          	addi	a0,a0,-838 # 80007118 <etext+0x118>
    80001466:	bbeff0ef          	jal	80000824 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000146a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000146e:	995a                	add	s2,s2,s6
    80001470:	03397563          	bgeu	s2,s3,8000149a <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001474:	4601                	li	a2,0
    80001476:	85ca                	mv	a1,s2
    80001478:	8552                	mv	a0,s4
    8000147a:	b13ff0ef          	jal	80000f8c <walk>
    8000147e:	84aa                	mv	s1,a0
    80001480:	d57d                	beqz	a0,8000146e <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001482:	611c                	ld	a5,0(a0)
    80001484:	0017f713          	andi	a4,a5,1
    80001488:	d37d                	beqz	a4,8000146e <uvmunmap+0x4a>
    if(do_free){
    8000148a:	fe0a80e3          	beqz	s5,8000146a <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000148e:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80001490:	00c79513          	slli	a0,a5,0xc
    80001494:	dc8ff0ef          	jal	80000a5c <kfree>
    80001498:	bfc9                	j	8000146a <uvmunmap+0x46>
    8000149a:	74a2                	ld	s1,40(sp)
    8000149c:	7902                	ld	s2,32(sp)
    8000149e:	69e2                	ld	s3,24(sp)
    800014a0:	6a42                	ld	s4,16(sp)
    800014a2:	6aa2                	ld	s5,8(sp)
    800014a4:	6b02                	ld	s6,0(sp)
  }
}
    800014a6:	70e2                	ld	ra,56(sp)
    800014a8:	7442                	ld	s0,48(sp)
    800014aa:	6121                	addi	sp,sp,64
    800014ac:	8082                	ret

00000000800014ae <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014ae:	1101                	addi	sp,sp,-32
    800014b0:	ec06                	sd	ra,24(sp)
    800014b2:	e822                	sd	s0,16(sp)
    800014b4:	e426                	sd	s1,8(sp)
    800014b6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014b8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014ba:	00b67d63          	bgeu	a2,a1,800014d4 <uvmdealloc+0x26>
    800014be:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014c0:	6785                	lui	a5,0x1
    800014c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014c4:	00f60733          	add	a4,a2,a5
    800014c8:	76fd                	lui	a3,0xfffff
    800014ca:	8f75                	and	a4,a4,a3
    800014cc:	97ae                	add	a5,a5,a1
    800014ce:	8ff5                	and	a5,a5,a3
    800014d0:	00f76863          	bltu	a4,a5,800014e0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014d4:	8526                	mv	a0,s1
    800014d6:	60e2                	ld	ra,24(sp)
    800014d8:	6442                	ld	s0,16(sp)
    800014da:	64a2                	ld	s1,8(sp)
    800014dc:	6105                	addi	sp,sp,32
    800014de:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014e0:	8f99                	sub	a5,a5,a4
    800014e2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014e4:	4685                	li	a3,1
    800014e6:	0007861b          	sext.w	a2,a5
    800014ea:	85ba                	mv	a1,a4
    800014ec:	f39ff0ef          	jal	80001424 <uvmunmap>
    800014f0:	b7d5                	j	800014d4 <uvmdealloc+0x26>

00000000800014f2 <uvmalloc>:
  if(newsz < oldsz)
    800014f2:	0ab66163          	bltu	a2,a1,80001594 <uvmalloc+0xa2>
{
    800014f6:	715d                	addi	sp,sp,-80
    800014f8:	e486                	sd	ra,72(sp)
    800014fa:	e0a2                	sd	s0,64(sp)
    800014fc:	f84a                	sd	s2,48(sp)
    800014fe:	f052                	sd	s4,32(sp)
    80001500:	ec56                	sd	s5,24(sp)
    80001502:	e45e                	sd	s7,8(sp)
    80001504:	0880                	addi	s0,sp,80
    80001506:	8aaa                	mv	s5,a0
    80001508:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000150a:	6785                	lui	a5,0x1
    8000150c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000150e:	95be                	add	a1,a1,a5
    80001510:	77fd                	lui	a5,0xfffff
    80001512:	00f5f933          	and	s2,a1,a5
    80001516:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001518:	08c97063          	bgeu	s2,a2,80001598 <uvmalloc+0xa6>
    8000151c:	fc26                	sd	s1,56(sp)
    8000151e:	f44e                	sd	s3,40(sp)
    80001520:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    80001522:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001524:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001528:	e1cff0ef          	jal	80000b44 <kalloc>
    8000152c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000152e:	c50d                	beqz	a0,80001558 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    80001530:	864e                	mv	a2,s3
    80001532:	4581                	li	a1,0
    80001534:	fc4ff0ef          	jal	80000cf8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001538:	875a                	mv	a4,s6
    8000153a:	86a6                	mv	a3,s1
    8000153c:	864e                	mv	a2,s3
    8000153e:	85ca                	mv	a1,s2
    80001540:	8556                	mv	a0,s5
    80001542:	b1fff0ef          	jal	80001060 <mappages>
    80001546:	e915                	bnez	a0,8000157a <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001548:	994e                	add	s2,s2,s3
    8000154a:	fd496fe3          	bltu	s2,s4,80001528 <uvmalloc+0x36>
  return newsz;
    8000154e:	8552                	mv	a0,s4
    80001550:	74e2                	ld	s1,56(sp)
    80001552:	79a2                	ld	s3,40(sp)
    80001554:	6b42                	ld	s6,16(sp)
    80001556:	a811                	j	8000156a <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001558:	865e                	mv	a2,s7
    8000155a:	85ca                	mv	a1,s2
    8000155c:	8556                	mv	a0,s5
    8000155e:	f51ff0ef          	jal	800014ae <uvmdealloc>
      return 0;
    80001562:	4501                	li	a0,0
    80001564:	74e2                	ld	s1,56(sp)
    80001566:	79a2                	ld	s3,40(sp)
    80001568:	6b42                	ld	s6,16(sp)
}
    8000156a:	60a6                	ld	ra,72(sp)
    8000156c:	6406                	ld	s0,64(sp)
    8000156e:	7942                	ld	s2,48(sp)
    80001570:	7a02                	ld	s4,32(sp)
    80001572:	6ae2                	ld	s5,24(sp)
    80001574:	6ba2                	ld	s7,8(sp)
    80001576:	6161                	addi	sp,sp,80
    80001578:	8082                	ret
      kfree(mem);
    8000157a:	8526                	mv	a0,s1
    8000157c:	ce0ff0ef          	jal	80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001580:	865e                	mv	a2,s7
    80001582:	85ca                	mv	a1,s2
    80001584:	8556                	mv	a0,s5
    80001586:	f29ff0ef          	jal	800014ae <uvmdealloc>
      return 0;
    8000158a:	4501                	li	a0,0
    8000158c:	74e2                	ld	s1,56(sp)
    8000158e:	79a2                	ld	s3,40(sp)
    80001590:	6b42                	ld	s6,16(sp)
    80001592:	bfe1                	j	8000156a <uvmalloc+0x78>
    return oldsz;
    80001594:	852e                	mv	a0,a1
}
    80001596:	8082                	ret
  return newsz;
    80001598:	8532                	mv	a0,a2
    8000159a:	bfc1                	j	8000156a <uvmalloc+0x78>

000000008000159c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000159c:	7179                	addi	sp,sp,-48
    8000159e:	f406                	sd	ra,40(sp)
    800015a0:	f022                	sd	s0,32(sp)
    800015a2:	ec26                	sd	s1,24(sp)
    800015a4:	e84a                	sd	s2,16(sp)
    800015a6:	e44e                	sd	s3,8(sp)
    800015a8:	1800                	addi	s0,sp,48
    800015aa:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015ac:	84aa                	mv	s1,a0
    800015ae:	6905                	lui	s2,0x1
    800015b0:	992a                	add	s2,s2,a0
    800015b2:	a811                	j	800015c6 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800015b4:	00006517          	auipc	a0,0x6
    800015b8:	b7c50513          	addi	a0,a0,-1156 # 80007130 <etext+0x130>
    800015bc:	a68ff0ef          	jal	80000824 <panic>
  for(int i = 0; i < 512; i++){
    800015c0:	04a1                	addi	s1,s1,8
    800015c2:	03248163          	beq	s1,s2,800015e4 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800015c6:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015c8:	0017f713          	andi	a4,a5,1
    800015cc:	db75                	beqz	a4,800015c0 <freewalk+0x24>
    800015ce:	00e7f713          	andi	a4,a5,14
    800015d2:	f36d                	bnez	a4,800015b4 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800015d4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015d6:	00c79513          	slli	a0,a5,0xc
    800015da:	fc3ff0ef          	jal	8000159c <freewalk>
      pagetable[i] = 0;
    800015de:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015e2:	bff9                	j	800015c0 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800015e4:	854e                	mv	a0,s3
    800015e6:	c76ff0ef          	jal	80000a5c <kfree>
}
    800015ea:	70a2                	ld	ra,40(sp)
    800015ec:	7402                	ld	s0,32(sp)
    800015ee:	64e2                	ld	s1,24(sp)
    800015f0:	6942                	ld	s2,16(sp)
    800015f2:	69a2                	ld	s3,8(sp)
    800015f4:	6145                	addi	sp,sp,48
    800015f6:	8082                	ret

00000000800015f8 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015f8:	1101                	addi	sp,sp,-32
    800015fa:	ec06                	sd	ra,24(sp)
    800015fc:	e822                	sd	s0,16(sp)
    800015fe:	e426                	sd	s1,8(sp)
    80001600:	1000                	addi	s0,sp,32
    80001602:	84aa                	mv	s1,a0
  if(sz > 0)
    80001604:	e989                	bnez	a1,80001616 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001606:	8526                	mv	a0,s1
    80001608:	f95ff0ef          	jal	8000159c <freewalk>
}
    8000160c:	60e2                	ld	ra,24(sp)
    8000160e:	6442                	ld	s0,16(sp)
    80001610:	64a2                	ld	s1,8(sp)
    80001612:	6105                	addi	sp,sp,32
    80001614:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001616:	6785                	lui	a5,0x1
    80001618:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000161a:	95be                	add	a1,a1,a5
    8000161c:	4685                	li	a3,1
    8000161e:	00c5d613          	srli	a2,a1,0xc
    80001622:	4581                	li	a1,0
    80001624:	e01ff0ef          	jal	80001424 <uvmunmap>
    80001628:	bff9                	j	80001606 <uvmfree+0xe>

000000008000162a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000162a:	ca45                	beqz	a2,800016da <uvmcopy+0xb0>
{
    8000162c:	715d                	addi	sp,sp,-80
    8000162e:	e486                	sd	ra,72(sp)
    80001630:	e0a2                	sd	s0,64(sp)
    80001632:	fc26                	sd	s1,56(sp)
    80001634:	f84a                	sd	s2,48(sp)
    80001636:	f44e                	sd	s3,40(sp)
    80001638:	f052                	sd	s4,32(sp)
    8000163a:	ec56                	sd	s5,24(sp)
    8000163c:	e85a                	sd	s6,16(sp)
    8000163e:	e45e                	sd	s7,8(sp)
    80001640:	e062                	sd	s8,0(sp)
    80001642:	0880                	addi	s0,sp,80
    80001644:	8b2a                	mv	s6,a0
    80001646:	8bae                	mv	s7,a1
    80001648:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000164a:	4901                	li	s2,0
    }
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000164c:	6a05                	lui	s4,0x1
        pte_t *child_pte = walk(new,i,1);
    8000164e:	4c05                	li	s8,1
    80001650:	a03d                	j	8000167e <uvmcopy+0x54>
    if((mem = kalloc()) == 0)
    80001652:	cf2ff0ef          	jal	80000b44 <kalloc>
    80001656:	84aa                	mv	s1,a0
    80001658:	c939                	beqz	a0,800016ae <uvmcopy+0x84>
    pa = PTE2PA(*pte);
    8000165a:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    8000165e:	8652                	mv	a2,s4
    80001660:	05b2                	slli	a1,a1,0xc
    80001662:	ef6ff0ef          	jal	80000d58 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001666:	3ff9f713          	andi	a4,s3,1023
    8000166a:	86a6                	mv	a3,s1
    8000166c:	8652                	mv	a2,s4
    8000166e:	85ca                	mv	a1,s2
    80001670:	855e                	mv	a0,s7
    80001672:	9efff0ef          	jal	80001060 <mappages>
    80001676:	e90d                	bnez	a0,800016a8 <uvmcopy+0x7e>
  for(i = 0; i < sz; i += PGSIZE){
    80001678:	9952                	add	s2,s2,s4
    8000167a:	05597363          	bgeu	s2,s5,800016c0 <uvmcopy+0x96>
    if((pte = walk(old, i, 0)) == 0)
    8000167e:	4601                	li	a2,0
    80001680:	85ca                	mv	a1,s2
    80001682:	855a                	mv	a0,s6
    80001684:	909ff0ef          	jal	80000f8c <walk>
    80001688:	84aa                	mv	s1,a0
    8000168a:	d57d                	beqz	a0,80001678 <uvmcopy+0x4e>
    if((*pte & PTE_V) == 0){
    8000168c:	00053983          	ld	s3,0(a0)
    80001690:	0019f793          	andi	a5,s3,1
    80001694:	ffdd                	bnez	a5,80001652 <uvmcopy+0x28>
        pte_t *child_pte = walk(new,i,1);
    80001696:	8662                	mv	a2,s8
    80001698:	85ca                	mv	a1,s2
    8000169a:	855e                	mv	a0,s7
    8000169c:	8f1ff0ef          	jal	80000f8c <walk>
        if(child_pte == 0)
    800016a0:	c519                	beqz	a0,800016ae <uvmcopy+0x84>
        *child_pte = *pte;
    800016a2:	609c                	ld	a5,0(s1)
    800016a4:	e11c                	sd	a5,0(a0)
        continue;
    800016a6:	bfc9                	j	80001678 <uvmcopy+0x4e>
      kfree(mem);
    800016a8:	8526                	mv	a0,s1
    800016aa:	bb2ff0ef          	jal	80000a5c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016ae:	4685                	li	a3,1
    800016b0:	00c95613          	srli	a2,s2,0xc
    800016b4:	4581                	li	a1,0
    800016b6:	855e                	mv	a0,s7
    800016b8:	d6dff0ef          	jal	80001424 <uvmunmap>
  return -1;
    800016bc:	557d                	li	a0,-1
    800016be:	a011                	j	800016c2 <uvmcopy+0x98>
  return 0;
    800016c0:	4501                	li	a0,0
}
    800016c2:	60a6                	ld	ra,72(sp)
    800016c4:	6406                	ld	s0,64(sp)
    800016c6:	74e2                	ld	s1,56(sp)
    800016c8:	7942                	ld	s2,48(sp)
    800016ca:	79a2                	ld	s3,40(sp)
    800016cc:	7a02                	ld	s4,32(sp)
    800016ce:	6ae2                	ld	s5,24(sp)
    800016d0:	6b42                	ld	s6,16(sp)
    800016d2:	6ba2                	ld	s7,8(sp)
    800016d4:	6c02                	ld	s8,0(sp)
    800016d6:	6161                	addi	sp,sp,80
    800016d8:	8082                	ret
  return 0;
    800016da:	4501                	li	a0,0
}
    800016dc:	8082                	ret

00000000800016de <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016de:	1141                	addi	sp,sp,-16
    800016e0:	e406                	sd	ra,8(sp)
    800016e2:	e022                	sd	s0,0(sp)
    800016e4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016e6:	4601                	li	a2,0
    800016e8:	8a5ff0ef          	jal	80000f8c <walk>
  if(pte == 0)
    800016ec:	c901                	beqz	a0,800016fc <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016ee:	611c                	ld	a5,0(a0)
    800016f0:	9bbd                	andi	a5,a5,-17
    800016f2:	e11c                	sd	a5,0(a0)
}
    800016f4:	60a2                	ld	ra,8(sp)
    800016f6:	6402                	ld	s0,0(sp)
    800016f8:	0141                	addi	sp,sp,16
    800016fa:	8082                	ret
    panic("uvmclear");
    800016fc:	00006517          	auipc	a0,0x6
    80001700:	a4450513          	addi	a0,a0,-1468 # 80007140 <etext+0x140>
    80001704:	920ff0ef          	jal	80000824 <panic>

0000000080001708 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001708:	ced9                	beqz	a3,800017a6 <copyout+0x9e>
{
    8000170a:	711d                	addi	sp,sp,-96
    8000170c:	ec86                	sd	ra,88(sp)
    8000170e:	e8a2                	sd	s0,80(sp)
    80001710:	e4a6                	sd	s1,72(sp)
    80001712:	e0ca                	sd	s2,64(sp)
    80001714:	fc4e                	sd	s3,56(sp)
    80001716:	f852                	sd	s4,48(sp)
    80001718:	f456                	sd	s5,40(sp)
    8000171a:	f05a                	sd	s6,32(sp)
    8000171c:	ec5e                	sd	s7,24(sp)
    8000171e:	e862                	sd	s8,16(sp)
    80001720:	e466                	sd	s9,8(sp)
    80001722:	e06a                	sd	s10,0(sp)
    80001724:	1080                	addi	s0,sp,96
    80001726:	8b2a                	mv	s6,a0
    80001728:	8a2e                	mv	s4,a1
    8000172a:	8bb2                	mv	s7,a2
    8000172c:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000172e:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80001730:	5cfd                	li	s9,-1
    80001732:	01acdc93          	srli	s9,s9,0x1a
    pte = walk(pagetable, va0, 0);
    // forbid copyout over read-only user text pages.
    if((*pte & PTE_W) == 0)
        return -1;

    n = PGSIZE - (dstva - va0);
    80001736:	6c05                	lui	s8,0x1
    80001738:	a835                	j	80001774 <copyout+0x6c>
    pte = walk(pagetable, va0, 0);
    8000173a:	4601                	li	a2,0
    8000173c:	85a6                	mv	a1,s1
    8000173e:	855a                	mv	a0,s6
    80001740:	84dff0ef          	jal	80000f8c <walk>
    if((*pte & PTE_W) == 0)
    80001744:	611c                	ld	a5,0(a0)
    80001746:	8b91                	andi	a5,a5,4
    80001748:	c3d1                	beqz	a5,800017cc <copyout+0xc4>
    n = PGSIZE - (dstva - va0);
    8000174a:	41448933          	sub	s2,s1,s4
    8000174e:	9962                	add	s2,s2,s8
    if(n > len)
    80001750:	012af363          	bgeu	s5,s2,80001756 <copyout+0x4e>
    80001754:	8956                	mv	s2,s5
        n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001756:	409a0533          	sub	a0,s4,s1
    8000175a:	0009061b          	sext.w	a2,s2
    8000175e:	85de                	mv	a1,s7
    80001760:	954e                	add	a0,a0,s3
    80001762:	df6ff0ef          	jal	80000d58 <memmove>

    len -= n;
    80001766:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000176a:	9bca                	add	s7,s7,s2
    dstva = va0 + PGSIZE;
    8000176c:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80001770:	020a8963          	beqz	s5,800017a2 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80001774:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80001778:	029ce963          	bltu	s9,s1,800017aa <copyout+0xa2>
    pa0 = walkaddr(pagetable, va0);
    8000177c:	85a6                	mv	a1,s1
    8000177e:	855a                	mv	a0,s6
    80001780:	8a7ff0ef          	jal	80001026 <walkaddr>
    80001784:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80001786:	f955                	bnez	a0,8000173a <copyout+0x32>
        if(handle_pgfault(pagetable, va0) != 0) {
    80001788:	85a6                	mv	a1,s1
    8000178a:	855a                	mv	a0,s6
    8000178c:	98bff0ef          	jal	80001116 <handle_pgfault>
    80001790:	ed05                	bnez	a0,800017c8 <copyout+0xc0>
        pa0 = walkaddr(pagetable, va0); // Retry getting the address
    80001792:	85a6                	mv	a1,s1
    80001794:	855a                	mv	a0,s6
    80001796:	891ff0ef          	jal	80001026 <walkaddr>
    8000179a:	89aa                	mv	s3,a0
        if(pa0 == 0) 
    8000179c:	fd59                	bnez	a0,8000173a <copyout+0x32>
            return -1;
    8000179e:	557d                	li	a0,-1
    800017a0:	a031                	j	800017ac <copyout+0xa4>
  }
  return 0;
    800017a2:	4501                	li	a0,0
    800017a4:	a021                	j	800017ac <copyout+0xa4>
    800017a6:	4501                	li	a0,0
}
    800017a8:	8082                	ret
      return -1;
    800017aa:	557d                	li	a0,-1
}
    800017ac:	60e6                	ld	ra,88(sp)
    800017ae:	6446                	ld	s0,80(sp)
    800017b0:	64a6                	ld	s1,72(sp)
    800017b2:	6906                	ld	s2,64(sp)
    800017b4:	79e2                	ld	s3,56(sp)
    800017b6:	7a42                	ld	s4,48(sp)
    800017b8:	7aa2                	ld	s5,40(sp)
    800017ba:	7b02                	ld	s6,32(sp)
    800017bc:	6be2                	ld	s7,24(sp)
    800017be:	6c42                	ld	s8,16(sp)
    800017c0:	6ca2                	ld	s9,8(sp)
    800017c2:	6d02                	ld	s10,0(sp)
    800017c4:	6125                	addi	sp,sp,96
    800017c6:	8082                	ret
            return -1;
    800017c8:	557d                	li	a0,-1
    800017ca:	b7cd                	j	800017ac <copyout+0xa4>
        return -1;
    800017cc:	557d                	li	a0,-1
    800017ce:	bff9                	j	800017ac <copyout+0xa4>

00000000800017d0 <copyin>:
    int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while(len > 0){
    800017d0:	cac9                	beqz	a3,80001862 <copyin+0x92>
{
    800017d2:	715d                	addi	sp,sp,-80
    800017d4:	e486                	sd	ra,72(sp)
    800017d6:	e0a2                	sd	s0,64(sp)
    800017d8:	fc26                	sd	s1,56(sp)
    800017da:	f84a                	sd	s2,48(sp)
    800017dc:	f44e                	sd	s3,40(sp)
    800017de:	f052                	sd	s4,32(sp)
    800017e0:	ec56                	sd	s5,24(sp)
    800017e2:	e85a                	sd	s6,16(sp)
    800017e4:	e45e                	sd	s7,8(sp)
    800017e6:	e062                	sd	s8,0(sp)
    800017e8:	0880                	addi	s0,sp,80
    800017ea:	8b2a                	mv	s6,a0
    800017ec:	8aae                	mv	s5,a1
    800017ee:	8932                	mv	s2,a2
    800017f0:	8a36                	mv	s4,a3
        va0 = PGROUNDDOWN(srcva);
    800017f2:	7c7d                	lui	s8,0xfffff
            }
            pa0 = walkaddr(pagetable, va0); 
            if(pa0 == 0)
                return -1;
        }
        n = PGSIZE - (srcva - va0);
    800017f4:	6b85                	lui	s7,0x1
    800017f6:	a035                	j	80001822 <copyin+0x52>
    800017f8:	412984b3          	sub	s1,s3,s2
    800017fc:	94de                	add	s1,s1,s7
        if(n > len)
    800017fe:	009a7363          	bgeu	s4,s1,80001804 <copyin+0x34>
    80001802:	84d2                	mv	s1,s4
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001804:	413905b3          	sub	a1,s2,s3
    80001808:	0004861b          	sext.w	a2,s1
    8000180c:	95aa                	add	a1,a1,a0
    8000180e:	8556                	mv	a0,s5
    80001810:	d48ff0ef          	jal	80000d58 <memmove>

        len -= n;
    80001814:	409a0a33          	sub	s4,s4,s1
        dst += n;
    80001818:	9aa6                	add	s5,s5,s1
        srcva = va0 + PGSIZE;
    8000181a:	01798933          	add	s2,s3,s7
    while(len > 0){
    8000181e:	020a0563          	beqz	s4,80001848 <copyin+0x78>
        va0 = PGROUNDDOWN(srcva);
    80001822:	018979b3          	and	s3,s2,s8
        pa0 = walkaddr(pagetable, va0);
    80001826:	85ce                	mv	a1,s3
    80001828:	855a                	mv	a0,s6
    8000182a:	ffcff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0) {
    8000182e:	f569                	bnez	a0,800017f8 <copyin+0x28>
            if(handle_pgfault(pagetable, va0) != 0) {
    80001830:	85ce                	mv	a1,s3
    80001832:	855a                	mv	a0,s6
    80001834:	8e3ff0ef          	jal	80001116 <handle_pgfault>
    80001838:	e51d                	bnez	a0,80001866 <copyin+0x96>
            pa0 = walkaddr(pagetable, va0); 
    8000183a:	85ce                	mv	a1,s3
    8000183c:	855a                	mv	a0,s6
    8000183e:	fe8ff0ef          	jal	80001026 <walkaddr>
            if(pa0 == 0)
    80001842:	f95d                	bnez	a0,800017f8 <copyin+0x28>
                return -1;
    80001844:	557d                	li	a0,-1
    80001846:	a011                	j	8000184a <copyin+0x7a>
    }
    return 0;
    80001848:	4501                	li	a0,0
}
    8000184a:	60a6                	ld	ra,72(sp)
    8000184c:	6406                	ld	s0,64(sp)
    8000184e:	74e2                	ld	s1,56(sp)
    80001850:	7942                	ld	s2,48(sp)
    80001852:	79a2                	ld	s3,40(sp)
    80001854:	7a02                	ld	s4,32(sp)
    80001856:	6ae2                	ld	s5,24(sp)
    80001858:	6b42                	ld	s6,16(sp)
    8000185a:	6ba2                	ld	s7,8(sp)
    8000185c:	6c02                	ld	s8,0(sp)
    8000185e:	6161                	addi	sp,sp,80
    80001860:	8082                	ret
    return 0;
    80001862:	4501                	li	a0,0
}
    80001864:	8082                	ret
                return -1;
    80001866:	557d                	li	a0,-1
    80001868:	b7cd                	j	8000184a <copyin+0x7a>

000000008000186a <copyinstr>:
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;
  while(got_null == 0 && max > 0){
    8000186a:	c6e1                	beqz	a3,80001932 <copyinstr+0xc8>
{
    8000186c:	715d                	addi	sp,sp,-80
    8000186e:	e486                	sd	ra,72(sp)
    80001870:	e0a2                	sd	s0,64(sp)
    80001872:	fc26                	sd	s1,56(sp)
    80001874:	f84a                	sd	s2,48(sp)
    80001876:	f44e                	sd	s3,40(sp)
    80001878:	f052                	sd	s4,32(sp)
    8000187a:	ec56                	sd	s5,24(sp)
    8000187c:	e85a                	sd	s6,16(sp)
    8000187e:	e45e                	sd	s7,8(sp)
    80001880:	0880                	addi	s0,sp,80
    80001882:	8aaa                	mv	s5,a0
    80001884:	892e                	mv	s2,a1
    80001886:	8bb2                	mv	s7,a2
    80001888:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000188a:	7b7d                	lui	s6,0xfffff
        return -1;
      }
      pa0 = walkaddr(pagetable, va0); // Retry
      if(pa0 == 0) return -1;
    }
    n = PGSIZE - (srcva - va0);
    8000188c:	6a05                	lui	s4,0x1
    8000188e:	a889                	j	800018e0 <copyinstr+0x76>
      if(handle_pgfault(pagetable, va0) != 0) {
    80001890:	85a6                	mv	a1,s1
    80001892:	8556                	mv	a0,s5
    80001894:	883ff0ef          	jal	80001116 <handle_pgfault>
    80001898:	e559                	bnez	a0,80001926 <copyinstr+0xbc>
      pa0 = walkaddr(pagetable, va0); // Retry
    8000189a:	85a6                	mv	a1,s1
    8000189c:	8556                	mv	a0,s5
    8000189e:	f88ff0ef          	jal	80001026 <walkaddr>
      if(pa0 == 0) return -1;
    800018a2:	e531                	bnez	a0,800018ee <copyinstr+0x84>
    800018a4:	557d                	li	a0,-1
    800018a6:	a801                	j	800018b6 <copyinstr+0x4c>
    if(n > max)
      n = max;
    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800018a8:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800018ac:	4785                	li	a5,1
      p++;
      dst++;
    }
    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800018ae:	0017c793          	xori	a5,a5,1
    800018b2:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800018b6:	60a6                	ld	ra,72(sp)
    800018b8:	6406                	ld	s0,64(sp)
    800018ba:	74e2                	ld	s1,56(sp)
    800018bc:	7942                	ld	s2,48(sp)
    800018be:	79a2                	ld	s3,40(sp)
    800018c0:	7a02                	ld	s4,32(sp)
    800018c2:	6ae2                	ld	s5,24(sp)
    800018c4:	6b42                	ld	s6,16(sp)
    800018c6:	6ba2                	ld	s7,8(sp)
    800018c8:	6161                	addi	sp,sp,80
    800018ca:	8082                	ret
    800018cc:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800018d0:	974a                	add	a4,a4,s2
      --max;
    800018d2:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800018d6:	01448bb3          	add	s7,s1,s4
  while(got_null == 0 && max > 0){
    800018da:	04e58463          	beq	a1,a4,80001922 <copyinstr+0xb8>
{
    800018de:	893e                	mv	s2,a5
    va0 = PGROUNDDOWN(srcva);
    800018e0:	016bf4b3          	and	s1,s7,s6
    pa0 = walkaddr(pagetable, va0);
    800018e4:	85a6                	mv	a1,s1
    800018e6:	8556                	mv	a0,s5
    800018e8:	f3eff0ef          	jal	80001026 <walkaddr>
    if(pa0 == 0){
    800018ec:	d155                	beqz	a0,80001890 <copyinstr+0x26>
    n = PGSIZE - (srcva - va0);
    800018ee:	41748633          	sub	a2,s1,s7
    800018f2:	9652                	add	a2,a2,s4
    if(n > max)
    800018f4:	00c9f363          	bgeu	s3,a2,800018fa <copyinstr+0x90>
    800018f8:	864e                	mv	a2,s3
    while(n > 0){
    800018fa:	ca05                	beqz	a2,8000192a <copyinstr+0xc0>
    char *p = (char *) (pa0 + (srcva - va0));
    800018fc:	409b86b3          	sub	a3,s7,s1
    80001900:	96aa                	add	a3,a3,a0
    80001902:	87ca                	mv	a5,s2
      if(*p == '\0'){
    80001904:	412686b3          	sub	a3,a3,s2
    while(n > 0){
    80001908:	964a                	add	a2,a2,s2
    8000190a:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000190c:	00f68733          	add	a4,a3,a5
    80001910:	00074703          	lbu	a4,0(a4)
    80001914:	db51                	beqz	a4,800018a8 <copyinstr+0x3e>
        *dst = *p;
    80001916:	00e78023          	sb	a4,0(a5)
      dst++;
    8000191a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000191c:	fec797e3          	bne	a5,a2,8000190a <copyinstr+0xa0>
    80001920:	b775                	j	800018cc <copyinstr+0x62>
    80001922:	4781                	li	a5,0
    80001924:	b769                	j	800018ae <copyinstr+0x44>
        return -1;
    80001926:	557d                	li	a0,-1
    80001928:	b779                	j	800018b6 <copyinstr+0x4c>
    srcva = va0 + PGSIZE;
    8000192a:	6b85                	lui	s7,0x1
    8000192c:	9ba6                	add	s7,s7,s1
    8000192e:	87ca                	mv	a5,s2
    80001930:	b77d                	j	800018de <copyinstr+0x74>
  int got_null = 0;
    80001932:	4781                	li	a5,0
  if(got_null){
    80001934:	0017c793          	xori	a5,a5,1
    80001938:	40f0053b          	negw	a0,a5
}
    8000193c:	8082                	ret

000000008000193e <ismapped>:
// out of physical memory, and physical address if successful.


    int
ismapped(pagetable_t pagetable, uint64 va)
{
    8000193e:	1141                	addi	sp,sp,-16
    80001940:	e406                	sd	ra,8(sp)
    80001942:	e022                	sd	s0,0(sp)
    80001944:	0800                	addi	s0,sp,16
    pte_t *pte = walk(pagetable, va, 0);
    80001946:	4601                	li	a2,0
    80001948:	e44ff0ef          	jal	80000f8c <walk>
    if (pte == 0) {
    8000194c:	c119                	beqz	a0,80001952 <ismapped+0x14>
        return 0;
    }
    if (*pte & PTE_V){
    8000194e:	6108                	ld	a0,0(a0)
    80001950:	8905                	andi	a0,a0,1
        return 1;
    }
    return 0;
}
    80001952:	60a2                	ld	ra,8(sp)
    80001954:	6402                	ld	s0,0(sp)
    80001956:	0141                	addi	sp,sp,16
    80001958:	8082                	ret

000000008000195a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000195a:	715d                	addi	sp,sp,-80
    8000195c:	e486                	sd	ra,72(sp)
    8000195e:	e0a2                	sd	s0,64(sp)
    80001960:	fc26                	sd	s1,56(sp)
    80001962:	f84a                	sd	s2,48(sp)
    80001964:	f44e                	sd	s3,40(sp)
    80001966:	f052                	sd	s4,32(sp)
    80001968:	ec56                	sd	s5,24(sp)
    8000196a:	e85a                	sd	s6,16(sp)
    8000196c:	e45e                	sd	s7,8(sp)
    8000196e:	e062                	sd	s8,0(sp)
    80001970:	0880                	addi	s0,sp,80
    80001972:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001974:	00011497          	auipc	s1,0x11
    80001978:	0f448493          	addi	s1,s1,244 # 80012a68 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000197c:	8c26                	mv	s8,s1
    8000197e:	677d47b7          	lui	a5,0x677d4
    80001982:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80001986:	51b3c937          	lui	s2,0x51b3c
    8000198a:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    8000198e:	1902                	slli	s2,s2,0x20
    80001990:	993e                	add	s2,s2,a5
    80001992:	040009b7          	lui	s3,0x4000
    80001996:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001998:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000199a:	4b99                	li	s7,6
    8000199c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    8000199e:	00017a97          	auipc	s5,0x17
    800019a2:	ecaa8a93          	addi	s5,s5,-310 # 80018868 <tickslock>
    char *pa = kalloc();
    800019a6:	99eff0ef          	jal	80000b44 <kalloc>
    800019aa:	862a                	mv	a2,a0
    if(pa == 0)
    800019ac:	c121                	beqz	a0,800019ec <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    800019ae:	418485b3          	sub	a1,s1,s8
    800019b2:	858d                	srai	a1,a1,0x3
    800019b4:	032585b3          	mul	a1,a1,s2
    800019b8:	05b6                	slli	a1,a1,0xd
    800019ba:	6789                	lui	a5,0x2
    800019bc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019be:	875e                	mv	a4,s7
    800019c0:	86da                	mv	a3,s6
    800019c2:	40b985b3          	sub	a1,s3,a1
    800019c6:	8552                	mv	a0,s4
    800019c8:	945ff0ef          	jal	8000130c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019cc:	17848493          	addi	s1,s1,376
    800019d0:	fd549be3          	bne	s1,s5,800019a6 <proc_mapstacks+0x4c>
  }
}
    800019d4:	60a6                	ld	ra,72(sp)
    800019d6:	6406                	ld	s0,64(sp)
    800019d8:	74e2                	ld	s1,56(sp)
    800019da:	7942                	ld	s2,48(sp)
    800019dc:	79a2                	ld	s3,40(sp)
    800019de:	7a02                	ld	s4,32(sp)
    800019e0:	6ae2                	ld	s5,24(sp)
    800019e2:	6b42                	ld	s6,16(sp)
    800019e4:	6ba2                	ld	s7,8(sp)
    800019e6:	6c02                	ld	s8,0(sp)
    800019e8:	6161                	addi	sp,sp,80
    800019ea:	8082                	ret
      panic("kalloc");
    800019ec:	00005517          	auipc	a0,0x5
    800019f0:	76450513          	addi	a0,a0,1892 # 80007150 <etext+0x150>
    800019f4:	e31fe0ef          	jal	80000824 <panic>

00000000800019f8 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800019f8:	7139                	addi	sp,sp,-64
    800019fa:	fc06                	sd	ra,56(sp)
    800019fc:	f822                	sd	s0,48(sp)
    800019fe:	f426                	sd	s1,40(sp)
    80001a00:	f04a                	sd	s2,32(sp)
    80001a02:	ec4e                	sd	s3,24(sp)
    80001a04:	e852                	sd	s4,16(sp)
    80001a06:	e456                	sd	s5,8(sp)
    80001a08:	e05a                	sd	s6,0(sp)
    80001a0a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001a0c:	00005597          	auipc	a1,0x5
    80001a10:	74c58593          	addi	a1,a1,1868 # 80007158 <etext+0x158>
    80001a14:	00011517          	auipc	a0,0x11
    80001a18:	c2450513          	addi	a0,a0,-988 # 80012638 <pid_lock>
    80001a1c:	982ff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001a20:	00005597          	auipc	a1,0x5
    80001a24:	74058593          	addi	a1,a1,1856 # 80007160 <etext+0x160>
    80001a28:	00011517          	auipc	a0,0x11
    80001a2c:	c2850513          	addi	a0,a0,-984 # 80012650 <wait_lock>
    80001a30:	96eff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a34:	00011497          	auipc	s1,0x11
    80001a38:	03448493          	addi	s1,s1,52 # 80012a68 <proc>
      initlock(&p->lock, "proc");
    80001a3c:	00005b17          	auipc	s6,0x5
    80001a40:	734b0b13          	addi	s6,s6,1844 # 80007170 <etext+0x170>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001a44:	8aa6                	mv	s5,s1
    80001a46:	677d47b7          	lui	a5,0x677d4
    80001a4a:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80001a4e:	51b3c937          	lui	s2,0x51b3c
    80001a52:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80001a56:	1902                	slli	s2,s2,0x20
    80001a58:	993e                	add	s2,s2,a5
    80001a5a:	040009b7          	lui	s3,0x4000
    80001a5e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a60:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a62:	00017a17          	auipc	s4,0x17
    80001a66:	e06a0a13          	addi	s4,s4,-506 # 80018868 <tickslock>
      initlock(&p->lock, "proc");
    80001a6a:	85da                	mv	a1,s6
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	930ff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    80001a72:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001a76:	415487b3          	sub	a5,s1,s5
    80001a7a:	878d                	srai	a5,a5,0x3
    80001a7c:	032787b3          	mul	a5,a5,s2
    80001a80:	07b6                	slli	a5,a5,0xd
    80001a82:	6709                	lui	a4,0x2
    80001a84:	9fb9                	addw	a5,a5,a4
    80001a86:	40f987b3          	sub	a5,s3,a5
    80001a8a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a8c:	17848493          	addi	s1,s1,376
    80001a90:	fd449de3          	bne	s1,s4,80001a6a <procinit+0x72>
  }
}
    80001a94:	70e2                	ld	ra,56(sp)
    80001a96:	7442                	ld	s0,48(sp)
    80001a98:	74a2                	ld	s1,40(sp)
    80001a9a:	7902                	ld	s2,32(sp)
    80001a9c:	69e2                	ld	s3,24(sp)
    80001a9e:	6a42                	ld	s4,16(sp)
    80001aa0:	6aa2                	ld	s5,8(sp)
    80001aa2:	6b02                	ld	s6,0(sp)
    80001aa4:	6121                	addi	sp,sp,64
    80001aa6:	8082                	ret

0000000080001aa8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001aa8:	1141                	addi	sp,sp,-16
    80001aaa:	e406                	sd	ra,8(sp)
    80001aac:	e022                	sd	s0,0(sp)
    80001aae:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ab0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001ab2:	2501                	sext.w	a0,a0
    80001ab4:	60a2                	ld	ra,8(sp)
    80001ab6:	6402                	ld	s0,0(sp)
    80001ab8:	0141                	addi	sp,sp,16
    80001aba:	8082                	ret

0000000080001abc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001abc:	1141                	addi	sp,sp,-16
    80001abe:	e406                	sd	ra,8(sp)
    80001ac0:	e022                	sd	s0,0(sp)
    80001ac2:	0800                	addi	s0,sp,16
    80001ac4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001ac6:	2781                	sext.w	a5,a5
    80001ac8:	079e                	slli	a5,a5,0x7
  return c;
}
    80001aca:	00011517          	auipc	a0,0x11
    80001ace:	b9e50513          	addi	a0,a0,-1122 # 80012668 <cpus>
    80001ad2:	953e                	add	a0,a0,a5
    80001ad4:	60a2                	ld	ra,8(sp)
    80001ad6:	6402                	ld	s0,0(sp)
    80001ad8:	0141                	addi	sp,sp,16
    80001ada:	8082                	ret

0000000080001adc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001adc:	1101                	addi	sp,sp,-32
    80001ade:	ec06                	sd	ra,24(sp)
    80001ae0:	e822                	sd	s0,16(sp)
    80001ae2:	e426                	sd	s1,8(sp)
    80001ae4:	1000                	addi	s0,sp,32
  push_off();
    80001ae6:	8feff0ef          	jal	80000be4 <push_off>
    80001aea:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001aec:	2781                	sext.w	a5,a5
    80001aee:	079e                	slli	a5,a5,0x7
    80001af0:	00011717          	auipc	a4,0x11
    80001af4:	b4870713          	addi	a4,a4,-1208 # 80012638 <pid_lock>
    80001af8:	97ba                	add	a5,a5,a4
    80001afa:	7b9c                	ld	a5,48(a5)
    80001afc:	84be                	mv	s1,a5
  pop_off();
    80001afe:	96eff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001b02:	8526                	mv	a0,s1
    80001b04:	60e2                	ld	ra,24(sp)
    80001b06:	6442                	ld	s0,16(sp)
    80001b08:	64a2                	ld	s1,8(sp)
    80001b0a:	6105                	addi	sp,sp,32
    80001b0c:	8082                	ret

0000000080001b0e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001b0e:	7179                	addi	sp,sp,-48
    80001b10:	f406                	sd	ra,40(sp)
    80001b12:	f022                	sd	s0,32(sp)
    80001b14:	ec26                	sd	s1,24(sp)
    80001b16:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001b18:	fc5ff0ef          	jal	80001adc <myproc>
    80001b1c:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001b1e:	99eff0ef          	jal	80000cbc <release>

  if (first) {
    80001b22:	00009797          	auipc	a5,0x9
    80001b26:	9de7a783          	lw	a5,-1570(a5) # 8000a500 <first.1>
    80001b2a:	cf95                	beqz	a5,80001b66 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001b2c:	4505                	li	a0,1
    80001b2e:	527010ef          	jal	80003854 <fsinit>

    first = 0;
    80001b32:	00009797          	auipc	a5,0x9
    80001b36:	9c07a723          	sw	zero,-1586(a5) # 8000a500 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001b3a:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001b3e:	00005797          	auipc	a5,0x5
    80001b42:	63a78793          	addi	a5,a5,1594 # 80007178 <etext+0x178>
    80001b46:	fcf43823          	sd	a5,-48(s0)
    80001b4a:	fc043c23          	sd	zero,-40(s0)
    80001b4e:	fd040593          	addi	a1,s0,-48
    80001b52:	853e                	mv	a0,a5
    80001b54:	703020ef          	jal	80004a56 <kexec>
    80001b58:	6cbc                	ld	a5,88(s1)
    80001b5a:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001b5c:	6cbc                	ld	a5,88(s1)
    80001b5e:	7bb8                	ld	a4,112(a5)
    80001b60:	57fd                	li	a5,-1
    80001b62:	02f70d63          	beq	a4,a5,80001b9c <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001b66:	311000ef          	jal	80002676 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b6a:	68a8                	ld	a0,80(s1)
    80001b6c:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b6e:	04000737          	lui	a4,0x4000
    80001b72:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001b74:	0732                	slli	a4,a4,0xc
    80001b76:	00004797          	auipc	a5,0x4
    80001b7a:	52678793          	addi	a5,a5,1318 # 8000609c <userret>
    80001b7e:	00004697          	auipc	a3,0x4
    80001b82:	48268693          	addi	a3,a3,1154 # 80006000 <_trampoline>
    80001b86:	8f95                	sub	a5,a5,a3
    80001b88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b8a:	577d                	li	a4,-1
    80001b8c:	177e                	slli	a4,a4,0x3f
    80001b8e:	8d59                	or	a0,a0,a4
    80001b90:	9782                	jalr	a5
}
    80001b92:	70a2                	ld	ra,40(sp)
    80001b94:	7402                	ld	s0,32(sp)
    80001b96:	64e2                	ld	s1,24(sp)
    80001b98:	6145                	addi	sp,sp,48
    80001b9a:	8082                	ret
      panic("exec");
    80001b9c:	00005517          	auipc	a0,0x5
    80001ba0:	5e450513          	addi	a0,a0,1508 # 80007180 <etext+0x180>
    80001ba4:	c81fe0ef          	jal	80000824 <panic>

0000000080001ba8 <allocpid>:
{
    80001ba8:	1101                	addi	sp,sp,-32
    80001baa:	ec06                	sd	ra,24(sp)
    80001bac:	e822                	sd	s0,16(sp)
    80001bae:	e426                	sd	s1,8(sp)
    80001bb0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001bb2:	00011517          	auipc	a0,0x11
    80001bb6:	a8650513          	addi	a0,a0,-1402 # 80012638 <pid_lock>
    80001bba:	86eff0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001bbe:	00009797          	auipc	a5,0x9
    80001bc2:	94678793          	addi	a5,a5,-1722 # 8000a504 <nextpid>
    80001bc6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001bc8:	0014871b          	addiw	a4,s1,1
    80001bcc:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001bce:	00011517          	auipc	a0,0x11
    80001bd2:	a6a50513          	addi	a0,a0,-1430 # 80012638 <pid_lock>
    80001bd6:	8e6ff0ef          	jal	80000cbc <release>
}
    80001bda:	8526                	mv	a0,s1
    80001bdc:	60e2                	ld	ra,24(sp)
    80001bde:	6442                	ld	s0,16(sp)
    80001be0:	64a2                	ld	s1,8(sp)
    80001be2:	6105                	addi	sp,sp,32
    80001be4:	8082                	ret

0000000080001be6 <proc_pagetable>:
{
    80001be6:	1101                	addi	sp,sp,-32
    80001be8:	ec06                	sd	ra,24(sp)
    80001bea:	e822                	sd	s0,16(sp)
    80001bec:	e426                	sd	s1,8(sp)
    80001bee:	e04a                	sd	s2,0(sp)
    80001bf0:	1000                	addi	s0,sp,32
    80001bf2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001bf4:	80bff0ef          	jal	800013fe <uvmcreate>
    80001bf8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001bfa:	cd05                	beqz	a0,80001c32 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001bfc:	4729                	li	a4,10
    80001bfe:	00004697          	auipc	a3,0x4
    80001c02:	40268693          	addi	a3,a3,1026 # 80006000 <_trampoline>
    80001c06:	6605                	lui	a2,0x1
    80001c08:	040005b7          	lui	a1,0x4000
    80001c0c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c0e:	05b2                	slli	a1,a1,0xc
    80001c10:	c50ff0ef          	jal	80001060 <mappages>
    80001c14:	02054663          	bltz	a0,80001c40 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c18:	4719                	li	a4,6
    80001c1a:	05893683          	ld	a3,88(s2)
    80001c1e:	6605                	lui	a2,0x1
    80001c20:	020005b7          	lui	a1,0x2000
    80001c24:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c26:	05b6                	slli	a1,a1,0xd
    80001c28:	8526                	mv	a0,s1
    80001c2a:	c36ff0ef          	jal	80001060 <mappages>
    80001c2e:	00054f63          	bltz	a0,80001c4c <proc_pagetable+0x66>
}
    80001c32:	8526                	mv	a0,s1
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6902                	ld	s2,0(sp)
    80001c3c:	6105                	addi	sp,sp,32
    80001c3e:	8082                	ret
    uvmfree(pagetable, 0);
    80001c40:	4581                	li	a1,0
    80001c42:	8526                	mv	a0,s1
    80001c44:	9b5ff0ef          	jal	800015f8 <uvmfree>
    return 0;
    80001c48:	4481                	li	s1,0
    80001c4a:	b7e5                	j	80001c32 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c4c:	4681                	li	a3,0
    80001c4e:	4605                	li	a2,1
    80001c50:	040005b7          	lui	a1,0x4000
    80001c54:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c56:	05b2                	slli	a1,a1,0xc
    80001c58:	8526                	mv	a0,s1
    80001c5a:	fcaff0ef          	jal	80001424 <uvmunmap>
    uvmfree(pagetable, 0);
    80001c5e:	4581                	li	a1,0
    80001c60:	8526                	mv	a0,s1
    80001c62:	997ff0ef          	jal	800015f8 <uvmfree>
    return 0;
    80001c66:	4481                	li	s1,0
    80001c68:	b7e9                	j	80001c32 <proc_pagetable+0x4c>

0000000080001c6a <proc_freepagetable>:
{
    80001c6a:	1101                	addi	sp,sp,-32
    80001c6c:	ec06                	sd	ra,24(sp)
    80001c6e:	e822                	sd	s0,16(sp)
    80001c70:	e426                	sd	s1,8(sp)
    80001c72:	e04a                	sd	s2,0(sp)
    80001c74:	1000                	addi	s0,sp,32
    80001c76:	84aa                	mv	s1,a0
    80001c78:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c7a:	4681                	li	a3,0
    80001c7c:	4605                	li	a2,1
    80001c7e:	040005b7          	lui	a1,0x4000
    80001c82:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c84:	05b2                	slli	a1,a1,0xc
    80001c86:	f9eff0ef          	jal	80001424 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c8a:	4681                	li	a3,0
    80001c8c:	4605                	li	a2,1
    80001c8e:	020005b7          	lui	a1,0x2000
    80001c92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c94:	05b6                	slli	a1,a1,0xd
    80001c96:	8526                	mv	a0,s1
    80001c98:	f8cff0ef          	jal	80001424 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c9c:	85ca                	mv	a1,s2
    80001c9e:	8526                	mv	a0,s1
    80001ca0:	959ff0ef          	jal	800015f8 <uvmfree>
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	64a2                	ld	s1,8(sp)
    80001caa:	6902                	ld	s2,0(sp)
    80001cac:	6105                	addi	sp,sp,32
    80001cae:	8082                	ret

0000000080001cb0 <freeproc>:
{
    80001cb0:	1101                	addi	sp,sp,-32
    80001cb2:	ec06                	sd	ra,24(sp)
    80001cb4:	e822                	sd	s0,16(sp)
    80001cb6:	e426                	sd	s1,8(sp)
    80001cb8:	1000                	addi	s0,sp,32
    80001cba:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001cbc:	6d28                	ld	a0,88(a0)
    80001cbe:	c119                	beqz	a0,80001cc4 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001cc0:	d9dfe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001cc4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001cc8:	68a8                	ld	a0,80(s1)
    80001cca:	c501                	beqz	a0,80001cd2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001ccc:	64ac                	ld	a1,72(s1)
    80001cce:	f9dff0ef          	jal	80001c6a <proc_freepagetable>
  p->pagetable = 0;
    80001cd2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001cd6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001cda:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001cde:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ce2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ce6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001cea:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001cee:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001cf2:	0004ac23          	sw	zero,24(s1)
  if(p->exec_ip)
    80001cf6:	1704b503          	ld	a0,368(s1)
    80001cfa:	c119                	beqz	a0,80001d00 <freeproc+0x50>
      iput(p->exec_ip);
    80001cfc:	1e7010ef          	jal	800036e2 <iput>
}
    80001d00:	60e2                	ld	ra,24(sp)
    80001d02:	6442                	ld	s0,16(sp)
    80001d04:	64a2                	ld	s1,8(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret

0000000080001d0a <allocproc>:
{
    80001d0a:	1101                	addi	sp,sp,-32
    80001d0c:	ec06                	sd	ra,24(sp)
    80001d0e:	e822                	sd	s0,16(sp)
    80001d10:	e426                	sd	s1,8(sp)
    80001d12:	e04a                	sd	s2,0(sp)
    80001d14:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d16:	00011497          	auipc	s1,0x11
    80001d1a:	d5248493          	addi	s1,s1,-686 # 80012a68 <proc>
    80001d1e:	00017917          	auipc	s2,0x17
    80001d22:	b4a90913          	addi	s2,s2,-1206 # 80018868 <tickslock>
    acquire(&p->lock);
    80001d26:	8526                	mv	a0,s1
    80001d28:	f01fe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001d2c:	4c9c                	lw	a5,24(s1)
    80001d2e:	cb91                	beqz	a5,80001d42 <allocproc+0x38>
      release(&p->lock);
    80001d30:	8526                	mv	a0,s1
    80001d32:	f8bfe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d36:	17848493          	addi	s1,s1,376
    80001d3a:	ff2496e3          	bne	s1,s2,80001d26 <allocproc+0x1c>
  return 0;
    80001d3e:	4481                	li	s1,0
    80001d40:	a089                	j	80001d82 <allocproc+0x78>
  p->pid = allocpid();
    80001d42:	e67ff0ef          	jal	80001ba8 <allocpid>
    80001d46:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001d48:	4785                	li	a5,1
    80001d4a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001d4c:	df9fe0ef          	jal	80000b44 <kalloc>
    80001d50:	892a                	mv	s2,a0
    80001d52:	eca8                	sd	a0,88(s1)
    80001d54:	cd15                	beqz	a0,80001d90 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001d56:	8526                	mv	a0,s1
    80001d58:	e8fff0ef          	jal	80001be6 <proc_pagetable>
    80001d5c:	892a                	mv	s2,a0
    80001d5e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001d60:	c121                	beqz	a0,80001da0 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001d62:	07000613          	li	a2,112
    80001d66:	4581                	li	a1,0
    80001d68:	06048513          	addi	a0,s1,96
    80001d6c:	f8dfe0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001d70:	00000797          	auipc	a5,0x0
    80001d74:	d9e78793          	addi	a5,a5,-610 # 80001b0e <forkret>
    80001d78:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001d7a:	60bc                	ld	a5,64(s1)
    80001d7c:	6705                	lui	a4,0x1
    80001d7e:	97ba                	add	a5,a5,a4
    80001d80:	f4bc                	sd	a5,104(s1)
}
    80001d82:	8526                	mv	a0,s1
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6902                	ld	s2,0(sp)
    80001d8c:	6105                	addi	sp,sp,32
    80001d8e:	8082                	ret
    freeproc(p);
    80001d90:	8526                	mv	a0,s1
    80001d92:	f1fff0ef          	jal	80001cb0 <freeproc>
    release(&p->lock);
    80001d96:	8526                	mv	a0,s1
    80001d98:	f25fe0ef          	jal	80000cbc <release>
    return 0;
    80001d9c:	84ca                	mv	s1,s2
    80001d9e:	b7d5                	j	80001d82 <allocproc+0x78>
    freeproc(p);
    80001da0:	8526                	mv	a0,s1
    80001da2:	f0fff0ef          	jal	80001cb0 <freeproc>
    release(&p->lock);
    80001da6:	8526                	mv	a0,s1
    80001da8:	f15fe0ef          	jal	80000cbc <release>
    return 0;
    80001dac:	84ca                	mv	s1,s2
    80001dae:	bfd1                	j	80001d82 <allocproc+0x78>

0000000080001db0 <userinit>:
{
    80001db0:	1101                	addi	sp,sp,-32
    80001db2:	ec06                	sd	ra,24(sp)
    80001db4:	e822                	sd	s0,16(sp)
    80001db6:	e426                	sd	s1,8(sp)
    80001db8:	1000                	addi	s0,sp,32
  p = allocproc();
    80001dba:	f51ff0ef          	jal	80001d0a <allocproc>
    80001dbe:	84aa                	mv	s1,a0
  initproc = p;
    80001dc0:	00008797          	auipc	a5,0x8
    80001dc4:	76a7b823          	sd	a0,1904(a5) # 8000a530 <initproc>
  p->cwd = namei("/");
    80001dc8:	00005517          	auipc	a0,0x5
    80001dcc:	3c050513          	addi	a0,a0,960 # 80007188 <etext+0x188>
    80001dd0:	7bf010ef          	jal	80003d8e <namei>
    80001dd4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001dd8:	478d                	li	a5,3
    80001dda:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	edffe0ef          	jal	80000cbc <release>
}
    80001de2:	60e2                	ld	ra,24(sp)
    80001de4:	6442                	ld	s0,16(sp)
    80001de6:	64a2                	ld	s1,8(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret

0000000080001dec <growproc>:
{
    80001dec:	1101                	addi	sp,sp,-32
    80001dee:	ec06                	sd	ra,24(sp)
    80001df0:	e822                	sd	s0,16(sp)
    80001df2:	e426                	sd	s1,8(sp)
    80001df4:	e04a                	sd	s2,0(sp)
    80001df6:	1000                	addi	s0,sp,32
    80001df8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfa:	ce3ff0ef          	jal	80001adc <myproc>
    80001dfe:	892a                	mv	s2,a0
  sz = p->sz;
    80001e00:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001e02:	02905963          	blez	s1,80001e34 <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001e06:	00b48633          	add	a2,s1,a1
    80001e0a:	020007b7          	lui	a5,0x2000
    80001e0e:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001e10:	07b6                	slli	a5,a5,0xd
    80001e12:	02c7ea63          	bltu	a5,a2,80001e46 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001e16:	4691                	li	a3,4
    80001e18:	6928                	ld	a0,80(a0)
    80001e1a:	ed8ff0ef          	jal	800014f2 <uvmalloc>
    80001e1e:	85aa                	mv	a1,a0
    80001e20:	c50d                	beqz	a0,80001e4a <growproc+0x5e>
  p->sz = sz;
    80001e22:	04b93423          	sd	a1,72(s2)
  return 0;
    80001e26:	4501                	li	a0,0
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	64a2                	ld	s1,8(sp)
    80001e2e:	6902                	ld	s2,0(sp)
    80001e30:	6105                	addi	sp,sp,32
    80001e32:	8082                	ret
  } else if(n < 0){
    80001e34:	fe04d7e3          	bgez	s1,80001e22 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e38:	00b48633          	add	a2,s1,a1
    80001e3c:	6928                	ld	a0,80(a0)
    80001e3e:	e70ff0ef          	jal	800014ae <uvmdealloc>
    80001e42:	85aa                	mv	a1,a0
    80001e44:	bff9                	j	80001e22 <growproc+0x36>
      return -1;
    80001e46:	557d                	li	a0,-1
    80001e48:	b7c5                	j	80001e28 <growproc+0x3c>
      return -1;
    80001e4a:	557d                	li	a0,-1
    80001e4c:	bff1                	j	80001e28 <growproc+0x3c>

0000000080001e4e <kfork>:
{
    80001e4e:	7139                	addi	sp,sp,-64
    80001e50:	fc06                	sd	ra,56(sp)
    80001e52:	f822                	sd	s0,48(sp)
    80001e54:	f426                	sd	s1,40(sp)
    80001e56:	e456                	sd	s5,8(sp)
    80001e58:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e5a:	c83ff0ef          	jal	80001adc <myproc>
    80001e5e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e60:	eabff0ef          	jal	80001d0a <allocproc>
    80001e64:	12050563          	beqz	a0,80001f8e <kfork+0x140>
    80001e68:	e852                	sd	s4,16(sp)
    80001e6a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e6c:	048ab603          	ld	a2,72(s5)
    80001e70:	692c                	ld	a1,80(a0)
    80001e72:	050ab503          	ld	a0,80(s5)
    80001e76:	fb4ff0ef          	jal	8000162a <uvmcopy>
    80001e7a:	04054e63          	bltz	a0,80001ed6 <kfork+0x88>
    80001e7e:	f04a                	sd	s2,32(sp)
    80001e80:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001e82:	048ab783          	ld	a5,72(s5)
    80001e86:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e8a:	058ab683          	ld	a3,88(s5)
    80001e8e:	87b6                	mv	a5,a3
    80001e90:	058a3703          	ld	a4,88(s4)
    80001e94:	12068693          	addi	a3,a3,288
    80001e98:	6388                	ld	a0,0(a5)
    80001e9a:	678c                	ld	a1,8(a5)
    80001e9c:	6b90                	ld	a2,16(a5)
    80001e9e:	e308                	sd	a0,0(a4)
    80001ea0:	e70c                	sd	a1,8(a4)
    80001ea2:	eb10                	sd	a2,16(a4)
    80001ea4:	6f90                	ld	a2,24(a5)
    80001ea6:	ef10                	sd	a2,24(a4)
    80001ea8:	02078793          	addi	a5,a5,32
    80001eac:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001eb0:	fed794e3          	bne	a5,a3,80001e98 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001eb4:	058a3783          	ld	a5,88(s4)
    80001eb8:	0607b823          	sd	zero,112(a5)
  printf("FOR LOOP STARTED\n");
    80001ebc:	00005517          	auipc	a0,0x5
    80001ec0:	2d450513          	addi	a0,a0,724 # 80007190 <etext+0x190>
    80001ec4:	e36fe0ef          	jal	800004fa <printf>
  for(i = 0; i < NOFILE; i++)
    80001ec8:	0d0a8493          	addi	s1,s5,208
    80001ecc:	0d0a0913          	addi	s2,s4,208
    80001ed0:	150a8993          	addi	s3,s5,336
    80001ed4:	a831                	j	80001ef0 <kfork+0xa2>
    freeproc(np);
    80001ed6:	8552                	mv	a0,s4
    80001ed8:	dd9ff0ef          	jal	80001cb0 <freeproc>
    release(&np->lock);
    80001edc:	8552                	mv	a0,s4
    80001ede:	ddffe0ef          	jal	80000cbc <release>
    return -1;
    80001ee2:	54fd                	li	s1,-1
    80001ee4:	6a42                	ld	s4,16(sp)
    80001ee6:	a869                	j	80001f80 <kfork+0x132>
  for(i = 0; i < NOFILE; i++)
    80001ee8:	04a1                	addi	s1,s1,8
    80001eea:	0921                	addi	s2,s2,8
    80001eec:	01348963          	beq	s1,s3,80001efe <kfork+0xb0>
    if(p->ofile[i])
    80001ef0:	6088                	ld	a0,0(s1)
    80001ef2:	d97d                	beqz	a0,80001ee8 <kfork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ef4:	456020ef          	jal	8000434a <filedup>
    80001ef8:	00a93023          	sd	a0,0(s2)
    80001efc:	b7f5                	j	80001ee8 <kfork+0x9a>
  np->cwd = idup(p->cwd);
    80001efe:	150ab503          	ld	a0,336(s5)
    80001f02:	628010ef          	jal	8000352a <idup>
    80001f06:	14aa3823          	sd	a0,336(s4)
  printf("EXITING FROM THE LOOP\n");
    80001f0a:	00005517          	auipc	a0,0x5
    80001f0e:	29e50513          	addi	a0,a0,670 # 800071a8 <etext+0x1a8>
    80001f12:	de8fe0ef          	jal	800004fa <printf>
  if(p->exec_ip)
    80001f16:	170ab503          	ld	a0,368(s5)
    80001f1a:	c509                	beqz	a0,80001f24 <kfork+0xd6>
    np->exec_ip = idup(p->exec_ip);
    80001f1c:	60e010ef          	jal	8000352a <idup>
    80001f20:	16aa3823          	sd	a0,368(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f24:	4641                	li	a2,16
    80001f26:	158a8593          	addi	a1,s5,344
    80001f2a:	158a0513          	addi	a0,s4,344
    80001f2e:	f1ffe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80001f32:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001f36:	8552                	mv	a0,s4
    80001f38:	d85fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80001f3c:	00010517          	auipc	a0,0x10
    80001f40:	71450513          	addi	a0,a0,1812 # 80012650 <wait_lock>
    80001f44:	ce5fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80001f48:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001f4c:	00010517          	auipc	a0,0x10
    80001f50:	70450513          	addi	a0,a0,1796 # 80012650 <wait_lock>
    80001f54:	d69fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80001f58:	8552                	mv	a0,s4
    80001f5a:	ccffe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80001f5e:	478d                	li	a5,3
    80001f60:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001f64:	8552                	mv	a0,s4
    80001f66:	d57fe0ef          	jal	80000cbc <release>
  printf("[pid %d]KFORK RETURNING\n",p->pid);
    80001f6a:	030aa583          	lw	a1,48(s5)
    80001f6e:	00005517          	auipc	a0,0x5
    80001f72:	25250513          	addi	a0,a0,594 # 800071c0 <etext+0x1c0>
    80001f76:	d84fe0ef          	jal	800004fa <printf>
  return pid;
    80001f7a:	7902                	ld	s2,32(sp)
    80001f7c:	69e2                	ld	s3,24(sp)
    80001f7e:	6a42                	ld	s4,16(sp)
}
    80001f80:	8526                	mv	a0,s1
    80001f82:	70e2                	ld	ra,56(sp)
    80001f84:	7442                	ld	s0,48(sp)
    80001f86:	74a2                	ld	s1,40(sp)
    80001f88:	6aa2                	ld	s5,8(sp)
    80001f8a:	6121                	addi	sp,sp,64
    80001f8c:	8082                	ret
    return -1;
    80001f8e:	54fd                	li	s1,-1
    80001f90:	bfc5                	j	80001f80 <kfork+0x132>

0000000080001f92 <scheduler>:
{
    80001f92:	715d                	addi	sp,sp,-80
    80001f94:	e486                	sd	ra,72(sp)
    80001f96:	e0a2                	sd	s0,64(sp)
    80001f98:	fc26                	sd	s1,56(sp)
    80001f9a:	f84a                	sd	s2,48(sp)
    80001f9c:	f44e                	sd	s3,40(sp)
    80001f9e:	f052                	sd	s4,32(sp)
    80001fa0:	ec56                	sd	s5,24(sp)
    80001fa2:	e85a                	sd	s6,16(sp)
    80001fa4:	e45e                	sd	s7,8(sp)
    80001fa6:	e062                	sd	s8,0(sp)
    80001fa8:	0880                	addi	s0,sp,80
    80001faa:	8792                	mv	a5,tp
  int id = r_tp();
    80001fac:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001fae:	00779b13          	slli	s6,a5,0x7
    80001fb2:	00010717          	auipc	a4,0x10
    80001fb6:	68670713          	addi	a4,a4,1670 # 80012638 <pid_lock>
    80001fba:	975a                	add	a4,a4,s6
    80001fbc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001fc0:	00010717          	auipc	a4,0x10
    80001fc4:	6b070713          	addi	a4,a4,1712 # 80012670 <cpus+0x8>
    80001fc8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001fca:	4c11                	li	s8,4
        c->proc = p;
    80001fcc:	079e                	slli	a5,a5,0x7
    80001fce:	00010a17          	auipc	s4,0x10
    80001fd2:	66aa0a13          	addi	s4,s4,1642 # 80012638 <pid_lock>
    80001fd6:	9a3e                	add	s4,s4,a5
        found = 1;
    80001fd8:	4b85                	li	s7,1
    80001fda:	a83d                	j	80002018 <scheduler+0x86>
      release(&p->lock);
    80001fdc:	8526                	mv	a0,s1
    80001fde:	cdffe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fe2:	17848493          	addi	s1,s1,376
    80001fe6:	03248563          	beq	s1,s2,80002010 <scheduler+0x7e>
      acquire(&p->lock);
    80001fea:	8526                	mv	a0,s1
    80001fec:	c3dfe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    80001ff0:	4c9c                	lw	a5,24(s1)
    80001ff2:	ff3795e3          	bne	a5,s3,80001fdc <scheduler+0x4a>
        p->state = RUNNING;
    80001ff6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001ffa:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001ffe:	06048593          	addi	a1,s1,96
    80002002:	855a                	mv	a0,s6
    80002004:	5c8000ef          	jal	800025cc <swtch>
        c->proc = 0;
    80002008:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000200c:	8ade                	mv	s5,s7
    8000200e:	b7f9                	j	80001fdc <scheduler+0x4a>
    if(found == 0) {
    80002010:	000a9463          	bnez	s5,80002018 <scheduler+0x86>
      asm volatile("wfi");
    80002014:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002018:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000201c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002020:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002024:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002028:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000202a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000202e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002030:	00011497          	auipc	s1,0x11
    80002034:	a3848493          	addi	s1,s1,-1480 # 80012a68 <proc>
      if(p->state == RUNNABLE) {
    80002038:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000203a:	00017917          	auipc	s2,0x17
    8000203e:	82e90913          	addi	s2,s2,-2002 # 80018868 <tickslock>
    80002042:	b765                	j	80001fea <scheduler+0x58>

0000000080002044 <sched>:
{
    80002044:	7179                	addi	sp,sp,-48
    80002046:	f406                	sd	ra,40(sp)
    80002048:	f022                	sd	s0,32(sp)
    8000204a:	ec26                	sd	s1,24(sp)
    8000204c:	e84a                	sd	s2,16(sp)
    8000204e:	e44e                	sd	s3,8(sp)
    80002050:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002052:	a8bff0ef          	jal	80001adc <myproc>
    80002056:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002058:	b61fe0ef          	jal	80000bb8 <holding>
    8000205c:	c935                	beqz	a0,800020d0 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000205e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002060:	2781                	sext.w	a5,a5
    80002062:	079e                	slli	a5,a5,0x7
    80002064:	00010717          	auipc	a4,0x10
    80002068:	5d470713          	addi	a4,a4,1492 # 80012638 <pid_lock>
    8000206c:	97ba                	add	a5,a5,a4
    8000206e:	0a87a703          	lw	a4,168(a5)
    80002072:	4785                	li	a5,1
    80002074:	06f71463          	bne	a4,a5,800020dc <sched+0x98>
  if(p->state == RUNNING)
    80002078:	4c98                	lw	a4,24(s1)
    8000207a:	4791                	li	a5,4
    8000207c:	06f70663          	beq	a4,a5,800020e8 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002080:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002084:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002086:	e7bd                	bnez	a5,800020f4 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002088:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000208a:	00010917          	auipc	s2,0x10
    8000208e:	5ae90913          	addi	s2,s2,1454 # 80012638 <pid_lock>
    80002092:	2781                	sext.w	a5,a5
    80002094:	079e                	slli	a5,a5,0x7
    80002096:	97ca                	add	a5,a5,s2
    80002098:	0ac7a983          	lw	s3,172(a5)
    8000209c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000209e:	2781                	sext.w	a5,a5
    800020a0:	079e                	slli	a5,a5,0x7
    800020a2:	07a1                	addi	a5,a5,8
    800020a4:	00010597          	auipc	a1,0x10
    800020a8:	5c458593          	addi	a1,a1,1476 # 80012668 <cpus>
    800020ac:	95be                	add	a1,a1,a5
    800020ae:	06048513          	addi	a0,s1,96
    800020b2:	51a000ef          	jal	800025cc <swtch>
    800020b6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020b8:	2781                	sext.w	a5,a5
    800020ba:	079e                	slli	a5,a5,0x7
    800020bc:	993e                	add	s2,s2,a5
    800020be:	0b392623          	sw	s3,172(s2)
}
    800020c2:	70a2                	ld	ra,40(sp)
    800020c4:	7402                	ld	s0,32(sp)
    800020c6:	64e2                	ld	s1,24(sp)
    800020c8:	6942                	ld	s2,16(sp)
    800020ca:	69a2                	ld	s3,8(sp)
    800020cc:	6145                	addi	sp,sp,48
    800020ce:	8082                	ret
    panic("sched p->lock");
    800020d0:	00005517          	auipc	a0,0x5
    800020d4:	11050513          	addi	a0,a0,272 # 800071e0 <etext+0x1e0>
    800020d8:	f4cfe0ef          	jal	80000824 <panic>
    panic("sched locks");
    800020dc:	00005517          	auipc	a0,0x5
    800020e0:	11450513          	addi	a0,a0,276 # 800071f0 <etext+0x1f0>
    800020e4:	f40fe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    800020e8:	00005517          	auipc	a0,0x5
    800020ec:	11850513          	addi	a0,a0,280 # 80007200 <etext+0x200>
    800020f0:	f34fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    800020f4:	00005517          	auipc	a0,0x5
    800020f8:	11c50513          	addi	a0,a0,284 # 80007210 <etext+0x210>
    800020fc:	f28fe0ef          	jal	80000824 <panic>

0000000080002100 <yield>:
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	e426                	sd	s1,8(sp)
    80002108:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000210a:	9d3ff0ef          	jal	80001adc <myproc>
    8000210e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002110:	b19fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80002114:	478d                	li	a5,3
    80002116:	cc9c                	sw	a5,24(s1)
  sched();
    80002118:	f2dff0ef          	jal	80002044 <sched>
  release(&p->lock);
    8000211c:	8526                	mv	a0,s1
    8000211e:	b9ffe0ef          	jal	80000cbc <release>
}
    80002122:	60e2                	ld	ra,24(sp)
    80002124:	6442                	ld	s0,16(sp)
    80002126:	64a2                	ld	s1,8(sp)
    80002128:	6105                	addi	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000212c:	7179                	addi	sp,sp,-48
    8000212e:	f406                	sd	ra,40(sp)
    80002130:	f022                	sd	s0,32(sp)
    80002132:	ec26                	sd	s1,24(sp)
    80002134:	e84a                	sd	s2,16(sp)
    80002136:	e44e                	sd	s3,8(sp)
    80002138:	1800                	addi	s0,sp,48
    8000213a:	89aa                	mv	s3,a0
    8000213c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000213e:	99fff0ef          	jal	80001adc <myproc>
    80002142:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002144:	ae5fe0ef          	jal	80000c28 <acquire>
  release(lk);
    80002148:	854a                	mv	a0,s2
    8000214a:	b73fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    8000214e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002152:	4789                	li	a5,2
    80002154:	cc9c                	sw	a5,24(s1)

  sched();
    80002156:	eefff0ef          	jal	80002044 <sched>

  // Tidy up.
  p->chan = 0;
    8000215a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000215e:	8526                	mv	a0,s1
    80002160:	b5dfe0ef          	jal	80000cbc <release>
  acquire(lk);
    80002164:	854a                	mv	a0,s2
    80002166:	ac3fe0ef          	jal	80000c28 <acquire>
}
    8000216a:	70a2                	ld	ra,40(sp)
    8000216c:	7402                	ld	s0,32(sp)
    8000216e:	64e2                	ld	s1,24(sp)
    80002170:	6942                	ld	s2,16(sp)
    80002172:	69a2                	ld	s3,8(sp)
    80002174:	6145                	addi	sp,sp,48
    80002176:	8082                	ret

0000000080002178 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002178:	7139                	addi	sp,sp,-64
    8000217a:	fc06                	sd	ra,56(sp)
    8000217c:	f822                	sd	s0,48(sp)
    8000217e:	f426                	sd	s1,40(sp)
    80002180:	f04a                	sd	s2,32(sp)
    80002182:	ec4e                	sd	s3,24(sp)
    80002184:	e852                	sd	s4,16(sp)
    80002186:	e456                	sd	s5,8(sp)
    80002188:	0080                	addi	s0,sp,64
    8000218a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000218c:	00011497          	auipc	s1,0x11
    80002190:	8dc48493          	addi	s1,s1,-1828 # 80012a68 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002194:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002196:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002198:	00016917          	auipc	s2,0x16
    8000219c:	6d090913          	addi	s2,s2,1744 # 80018868 <tickslock>
    800021a0:	a801                	j	800021b0 <wakeup+0x38>
      }
      release(&p->lock);
    800021a2:	8526                	mv	a0,s1
    800021a4:	b19fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800021a8:	17848493          	addi	s1,s1,376
    800021ac:	03248263          	beq	s1,s2,800021d0 <wakeup+0x58>
    if(p != myproc()){
    800021b0:	92dff0ef          	jal	80001adc <myproc>
    800021b4:	fe950ae3          	beq	a0,s1,800021a8 <wakeup+0x30>
      acquire(&p->lock);
    800021b8:	8526                	mv	a0,s1
    800021ba:	a6ffe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800021be:	4c9c                	lw	a5,24(s1)
    800021c0:	ff3791e3          	bne	a5,s3,800021a2 <wakeup+0x2a>
    800021c4:	709c                	ld	a5,32(s1)
    800021c6:	fd479ee3          	bne	a5,s4,800021a2 <wakeup+0x2a>
        p->state = RUNNABLE;
    800021ca:	0154ac23          	sw	s5,24(s1)
    800021ce:	bfd1                	j	800021a2 <wakeup+0x2a>
    }
  }
}
    800021d0:	70e2                	ld	ra,56(sp)
    800021d2:	7442                	ld	s0,48(sp)
    800021d4:	74a2                	ld	s1,40(sp)
    800021d6:	7902                	ld	s2,32(sp)
    800021d8:	69e2                	ld	s3,24(sp)
    800021da:	6a42                	ld	s4,16(sp)
    800021dc:	6aa2                	ld	s5,8(sp)
    800021de:	6121                	addi	sp,sp,64
    800021e0:	8082                	ret

00000000800021e2 <reparent>:
{
    800021e2:	7179                	addi	sp,sp,-48
    800021e4:	f406                	sd	ra,40(sp)
    800021e6:	f022                	sd	s0,32(sp)
    800021e8:	ec26                	sd	s1,24(sp)
    800021ea:	e84a                	sd	s2,16(sp)
    800021ec:	e44e                	sd	s3,8(sp)
    800021ee:	e052                	sd	s4,0(sp)
    800021f0:	1800                	addi	s0,sp,48
    800021f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021f4:	00011497          	auipc	s1,0x11
    800021f8:	87448493          	addi	s1,s1,-1932 # 80012a68 <proc>
      pp->parent = initproc;
    800021fc:	00008a17          	auipc	s4,0x8
    80002200:	334a0a13          	addi	s4,s4,820 # 8000a530 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002204:	00016997          	auipc	s3,0x16
    80002208:	66498993          	addi	s3,s3,1636 # 80018868 <tickslock>
    8000220c:	a029                	j	80002216 <reparent+0x34>
    8000220e:	17848493          	addi	s1,s1,376
    80002212:	01348b63          	beq	s1,s3,80002228 <reparent+0x46>
    if(pp->parent == p){
    80002216:	7c9c                	ld	a5,56(s1)
    80002218:	ff279be3          	bne	a5,s2,8000220e <reparent+0x2c>
      pp->parent = initproc;
    8000221c:	000a3503          	ld	a0,0(s4)
    80002220:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002222:	f57ff0ef          	jal	80002178 <wakeup>
    80002226:	b7e5                	j	8000220e <reparent+0x2c>
}
    80002228:	70a2                	ld	ra,40(sp)
    8000222a:	7402                	ld	s0,32(sp)
    8000222c:	64e2                	ld	s1,24(sp)
    8000222e:	6942                	ld	s2,16(sp)
    80002230:	69a2                	ld	s3,8(sp)
    80002232:	6a02                	ld	s4,0(sp)
    80002234:	6145                	addi	sp,sp,48
    80002236:	8082                	ret

0000000080002238 <kexit>:
{
    80002238:	7179                	addi	sp,sp,-48
    8000223a:	f406                	sd	ra,40(sp)
    8000223c:	f022                	sd	s0,32(sp)
    8000223e:	ec26                	sd	s1,24(sp)
    80002240:	e84a                	sd	s2,16(sp)
    80002242:	e44e                	sd	s3,8(sp)
    80002244:	e052                	sd	s4,0(sp)
    80002246:	1800                	addi	s0,sp,48
    80002248:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000224a:	893ff0ef          	jal	80001adc <myproc>
    8000224e:	89aa                	mv	s3,a0
  printf("[pid %d] exiting\n",p->pid);
    80002250:	590c                	lw	a1,48(a0)
    80002252:	00005517          	auipc	a0,0x5
    80002256:	fd650513          	addi	a0,a0,-42 # 80007228 <etext+0x228>
    8000225a:	aa0fe0ef          	jal	800004fa <printf>
  if(p == initproc)
    8000225e:	00008797          	auipc	a5,0x8
    80002262:	2d27b783          	ld	a5,722(a5) # 8000a530 <initproc>
    80002266:	0d098493          	addi	s1,s3,208
    8000226a:	15098913          	addi	s2,s3,336
    8000226e:	01379b63          	bne	a5,s3,80002284 <kexit+0x4c>
    panic("init exiting");
    80002272:	00005517          	auipc	a0,0x5
    80002276:	fce50513          	addi	a0,a0,-50 # 80007240 <etext+0x240>
    8000227a:	daafe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000227e:	04a1                	addi	s1,s1,8
    80002280:	01248963          	beq	s1,s2,80002292 <kexit+0x5a>
    if(p->ofile[fd]){
    80002284:	6088                	ld	a0,0(s1)
    80002286:	dd65                	beqz	a0,8000227e <kexit+0x46>
      fileclose(f);
    80002288:	108020ef          	jal	80004390 <fileclose>
      p->ofile[fd] = 0;
    8000228c:	0004b023          	sd	zero,0(s1)
    80002290:	b7fd                	j	8000227e <kexit+0x46>
  begin_op();
    80002292:	4db010ef          	jal	80003f6c <begin_op>
  iput(p->cwd);
    80002296:	1509b503          	ld	a0,336(s3)
    8000229a:	448010ef          	jal	800036e2 <iput>
  end_op();
    8000229e:	53f010ef          	jal	80003fdc <end_op>
  p->cwd = 0;
    800022a2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800022a6:	00010517          	auipc	a0,0x10
    800022aa:	3aa50513          	addi	a0,a0,938 # 80012650 <wait_lock>
    800022ae:	97bfe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800022b2:	854e                	mv	a0,s3
    800022b4:	f2fff0ef          	jal	800021e2 <reparent>
  wakeup(p->parent);
    800022b8:	0389b503          	ld	a0,56(s3)
    800022bc:	ebdff0ef          	jal	80002178 <wakeup>
  acquire(&p->lock);
    800022c0:	854e                	mv	a0,s3
    800022c2:	967fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800022c6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800022ca:	4795                	li	a5,5
    800022cc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800022d0:	00010517          	auipc	a0,0x10
    800022d4:	38050513          	addi	a0,a0,896 # 80012650 <wait_lock>
    800022d8:	9e5fe0ef          	jal	80000cbc <release>
  sched();
    800022dc:	d69ff0ef          	jal	80002044 <sched>
  panic("zombie exit");
    800022e0:	00005517          	auipc	a0,0x5
    800022e4:	f7050513          	addi	a0,a0,-144 # 80007250 <etext+0x250>
    800022e8:	d3cfe0ef          	jal	80000824 <panic>

00000000800022ec <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800022ec:	7179                	addi	sp,sp,-48
    800022ee:	f406                	sd	ra,40(sp)
    800022f0:	f022                	sd	s0,32(sp)
    800022f2:	ec26                	sd	s1,24(sp)
    800022f4:	e84a                	sd	s2,16(sp)
    800022f6:	e44e                	sd	s3,8(sp)
    800022f8:	1800                	addi	s0,sp,48
    800022fa:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800022fc:	00010497          	auipc	s1,0x10
    80002300:	76c48493          	addi	s1,s1,1900 # 80012a68 <proc>
    80002304:	00016997          	auipc	s3,0x16
    80002308:	56498993          	addi	s3,s3,1380 # 80018868 <tickslock>
    acquire(&p->lock);
    8000230c:	8526                	mv	a0,s1
    8000230e:	91bfe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    80002312:	589c                	lw	a5,48(s1)
    80002314:	01278b63          	beq	a5,s2,8000232a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002318:	8526                	mv	a0,s1
    8000231a:	9a3fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000231e:	17848493          	addi	s1,s1,376
    80002322:	ff3495e3          	bne	s1,s3,8000230c <kkill+0x20>
  }
  return -1;
    80002326:	557d                	li	a0,-1
    80002328:	a819                	j	8000233e <kkill+0x52>
      p->killed = 1;
    8000232a:	4785                	li	a5,1
    8000232c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000232e:	4c98                	lw	a4,24(s1)
    80002330:	4789                	li	a5,2
    80002332:	00f70d63          	beq	a4,a5,8000234c <kkill+0x60>
      release(&p->lock);
    80002336:	8526                	mv	a0,s1
    80002338:	985fe0ef          	jal	80000cbc <release>
      return 0;
    8000233c:	4501                	li	a0,0
}
    8000233e:	70a2                	ld	ra,40(sp)
    80002340:	7402                	ld	s0,32(sp)
    80002342:	64e2                	ld	s1,24(sp)
    80002344:	6942                	ld	s2,16(sp)
    80002346:	69a2                	ld	s3,8(sp)
    80002348:	6145                	addi	sp,sp,48
    8000234a:	8082                	ret
        p->state = RUNNABLE;
    8000234c:	478d                	li	a5,3
    8000234e:	cc9c                	sw	a5,24(s1)
    80002350:	b7dd                	j	80002336 <kkill+0x4a>

0000000080002352 <setkilled>:

void
setkilled(struct proc *p)
{
    80002352:	1101                	addi	sp,sp,-32
    80002354:	ec06                	sd	ra,24(sp)
    80002356:	e822                	sd	s0,16(sp)
    80002358:	e426                	sd	s1,8(sp)
    8000235a:	1000                	addi	s0,sp,32
    8000235c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000235e:	8cbfe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    80002362:	4785                	li	a5,1
    80002364:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002366:	8526                	mv	a0,s1
    80002368:	955fe0ef          	jal	80000cbc <release>
}
    8000236c:	60e2                	ld	ra,24(sp)
    8000236e:	6442                	ld	s0,16(sp)
    80002370:	64a2                	ld	s1,8(sp)
    80002372:	6105                	addi	sp,sp,32
    80002374:	8082                	ret

0000000080002376 <killed>:

int
killed(struct proc *p)
{
    80002376:	1101                	addi	sp,sp,-32
    80002378:	ec06                	sd	ra,24(sp)
    8000237a:	e822                	sd	s0,16(sp)
    8000237c:	e426                	sd	s1,8(sp)
    8000237e:	e04a                	sd	s2,0(sp)
    80002380:	1000                	addi	s0,sp,32
    80002382:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002384:	8a5fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    80002388:	549c                	lw	a5,40(s1)
    8000238a:	893e                	mv	s2,a5
  release(&p->lock);
    8000238c:	8526                	mv	a0,s1
    8000238e:	92ffe0ef          	jal	80000cbc <release>
  return k;
}
    80002392:	854a                	mv	a0,s2
    80002394:	60e2                	ld	ra,24(sp)
    80002396:	6442                	ld	s0,16(sp)
    80002398:	64a2                	ld	s1,8(sp)
    8000239a:	6902                	ld	s2,0(sp)
    8000239c:	6105                	addi	sp,sp,32
    8000239e:	8082                	ret

00000000800023a0 <kwait>:
{
    800023a0:	715d                	addi	sp,sp,-80
    800023a2:	e486                	sd	ra,72(sp)
    800023a4:	e0a2                	sd	s0,64(sp)
    800023a6:	fc26                	sd	s1,56(sp)
    800023a8:	f84a                	sd	s2,48(sp)
    800023aa:	f44e                	sd	s3,40(sp)
    800023ac:	f052                	sd	s4,32(sp)
    800023ae:	ec56                	sd	s5,24(sp)
    800023b0:	e85a                	sd	s6,16(sp)
    800023b2:	e45e                	sd	s7,8(sp)
    800023b4:	0880                	addi	s0,sp,80
    800023b6:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800023b8:	f24ff0ef          	jal	80001adc <myproc>
    800023bc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800023be:	00010517          	auipc	a0,0x10
    800023c2:	29250513          	addi	a0,a0,658 # 80012650 <wait_lock>
    800023c6:	863fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800023ca:	4a15                	li	s4,5
        havekids = 1;
    800023cc:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023ce:	00016997          	auipc	s3,0x16
    800023d2:	49a98993          	addi	s3,s3,1178 # 80018868 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800023d6:	00010b17          	auipc	s6,0x10
    800023da:	27ab0b13          	addi	s6,s6,634 # 80012650 <wait_lock>
    800023de:	a869                	j	80002478 <kwait+0xd8>
          pid = pp->pid;
    800023e0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023e4:	000b8c63          	beqz	s7,800023fc <kwait+0x5c>
    800023e8:	4691                	li	a3,4
    800023ea:	02c48613          	addi	a2,s1,44
    800023ee:	85de                	mv	a1,s7
    800023f0:	05093503          	ld	a0,80(s2)
    800023f4:	b14ff0ef          	jal	80001708 <copyout>
    800023f8:	02054a63          	bltz	a0,8000242c <kwait+0x8c>
          freeproc(pp);
    800023fc:	8526                	mv	a0,s1
    800023fe:	8b3ff0ef          	jal	80001cb0 <freeproc>
          release(&pp->lock);
    80002402:	8526                	mv	a0,s1
    80002404:	8b9fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    80002408:	00010517          	auipc	a0,0x10
    8000240c:	24850513          	addi	a0,a0,584 # 80012650 <wait_lock>
    80002410:	8adfe0ef          	jal	80000cbc <release>
}
    80002414:	854e                	mv	a0,s3
    80002416:	60a6                	ld	ra,72(sp)
    80002418:	6406                	ld	s0,64(sp)
    8000241a:	74e2                	ld	s1,56(sp)
    8000241c:	7942                	ld	s2,48(sp)
    8000241e:	79a2                	ld	s3,40(sp)
    80002420:	7a02                	ld	s4,32(sp)
    80002422:	6ae2                	ld	s5,24(sp)
    80002424:	6b42                	ld	s6,16(sp)
    80002426:	6ba2                	ld	s7,8(sp)
    80002428:	6161                	addi	sp,sp,80
    8000242a:	8082                	ret
            release(&pp->lock);
    8000242c:	8526                	mv	a0,s1
    8000242e:	88ffe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002432:	00010517          	auipc	a0,0x10
    80002436:	21e50513          	addi	a0,a0,542 # 80012650 <wait_lock>
    8000243a:	883fe0ef          	jal	80000cbc <release>
            return -1;
    8000243e:	59fd                	li	s3,-1
    80002440:	bfd1                	j	80002414 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002442:	17848493          	addi	s1,s1,376
    80002446:	03348063          	beq	s1,s3,80002466 <kwait+0xc6>
      if(pp->parent == p){
    8000244a:	7c9c                	ld	a5,56(s1)
    8000244c:	ff279be3          	bne	a5,s2,80002442 <kwait+0xa2>
        acquire(&pp->lock);
    80002450:	8526                	mv	a0,s1
    80002452:	fd6fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    80002456:	4c9c                	lw	a5,24(s1)
    80002458:	f94784e3          	beq	a5,s4,800023e0 <kwait+0x40>
        release(&pp->lock);
    8000245c:	8526                	mv	a0,s1
    8000245e:	85ffe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002462:	8756                	mv	a4,s5
    80002464:	bff9                	j	80002442 <kwait+0xa2>
    if(!havekids || killed(p)){
    80002466:	cf19                	beqz	a4,80002484 <kwait+0xe4>
    80002468:	854a                	mv	a0,s2
    8000246a:	f0dff0ef          	jal	80002376 <killed>
    8000246e:	e919                	bnez	a0,80002484 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002470:	85da                	mv	a1,s6
    80002472:	854a                	mv	a0,s2
    80002474:	cb9ff0ef          	jal	8000212c <sleep>
    havekids = 0;
    80002478:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000247a:	00010497          	auipc	s1,0x10
    8000247e:	5ee48493          	addi	s1,s1,1518 # 80012a68 <proc>
    80002482:	b7e1                	j	8000244a <kwait+0xaa>
      release(&wait_lock);
    80002484:	00010517          	auipc	a0,0x10
    80002488:	1cc50513          	addi	a0,a0,460 # 80012650 <wait_lock>
    8000248c:	831fe0ef          	jal	80000cbc <release>
      return -1;
    80002490:	59fd                	li	s3,-1
    80002492:	b749                	j	80002414 <kwait+0x74>

0000000080002494 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002494:	7179                	addi	sp,sp,-48
    80002496:	f406                	sd	ra,40(sp)
    80002498:	f022                	sd	s0,32(sp)
    8000249a:	ec26                	sd	s1,24(sp)
    8000249c:	e84a                	sd	s2,16(sp)
    8000249e:	e44e                	sd	s3,8(sp)
    800024a0:	e052                	sd	s4,0(sp)
    800024a2:	1800                	addi	s0,sp,48
    800024a4:	84aa                	mv	s1,a0
    800024a6:	8a2e                	mv	s4,a1
    800024a8:	89b2                	mv	s3,a2
    800024aa:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800024ac:	e30ff0ef          	jal	80001adc <myproc>
  if(user_dst){
    800024b0:	cc99                	beqz	s1,800024ce <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800024b2:	86ca                	mv	a3,s2
    800024b4:	864e                	mv	a2,s3
    800024b6:	85d2                	mv	a1,s4
    800024b8:	6928                	ld	a0,80(a0)
    800024ba:	a4eff0ef          	jal	80001708 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024be:	70a2                	ld	ra,40(sp)
    800024c0:	7402                	ld	s0,32(sp)
    800024c2:	64e2                	ld	s1,24(sp)
    800024c4:	6942                	ld	s2,16(sp)
    800024c6:	69a2                	ld	s3,8(sp)
    800024c8:	6a02                	ld	s4,0(sp)
    800024ca:	6145                	addi	sp,sp,48
    800024cc:	8082                	ret
    memmove((char *)dst, src, len);
    800024ce:	0009061b          	sext.w	a2,s2
    800024d2:	85ce                	mv	a1,s3
    800024d4:	8552                	mv	a0,s4
    800024d6:	883fe0ef          	jal	80000d58 <memmove>
    return 0;
    800024da:	8526                	mv	a0,s1
    800024dc:	b7cd                	j	800024be <either_copyout+0x2a>

00000000800024de <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024de:	7179                	addi	sp,sp,-48
    800024e0:	f406                	sd	ra,40(sp)
    800024e2:	f022                	sd	s0,32(sp)
    800024e4:	ec26                	sd	s1,24(sp)
    800024e6:	e84a                	sd	s2,16(sp)
    800024e8:	e44e                	sd	s3,8(sp)
    800024ea:	e052                	sd	s4,0(sp)
    800024ec:	1800                	addi	s0,sp,48
    800024ee:	8a2a                	mv	s4,a0
    800024f0:	84ae                	mv	s1,a1
    800024f2:	89b2                	mv	s3,a2
    800024f4:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800024f6:	de6ff0ef          	jal	80001adc <myproc>
  if(user_src){
    800024fa:	cc99                	beqz	s1,80002518 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800024fc:	86ca                	mv	a3,s2
    800024fe:	864e                	mv	a2,s3
    80002500:	85d2                	mv	a1,s4
    80002502:	6928                	ld	a0,80(a0)
    80002504:	accff0ef          	jal	800017d0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002508:	70a2                	ld	ra,40(sp)
    8000250a:	7402                	ld	s0,32(sp)
    8000250c:	64e2                	ld	s1,24(sp)
    8000250e:	6942                	ld	s2,16(sp)
    80002510:	69a2                	ld	s3,8(sp)
    80002512:	6a02                	ld	s4,0(sp)
    80002514:	6145                	addi	sp,sp,48
    80002516:	8082                	ret
    memmove(dst, (char*)src, len);
    80002518:	0009061b          	sext.w	a2,s2
    8000251c:	85ce                	mv	a1,s3
    8000251e:	8552                	mv	a0,s4
    80002520:	839fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002524:	8526                	mv	a0,s1
    80002526:	b7cd                	j	80002508 <either_copyin+0x2a>

0000000080002528 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002528:	715d                	addi	sp,sp,-80
    8000252a:	e486                	sd	ra,72(sp)
    8000252c:	e0a2                	sd	s0,64(sp)
    8000252e:	fc26                	sd	s1,56(sp)
    80002530:	f84a                	sd	s2,48(sp)
    80002532:	f44e                	sd	s3,40(sp)
    80002534:	f052                	sd	s4,32(sp)
    80002536:	ec56                	sd	s5,24(sp)
    80002538:	e85a                	sd	s6,16(sp)
    8000253a:	e45e                	sd	s7,8(sp)
    8000253c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000253e:	00005517          	auipc	a0,0x5
    80002542:	efa50513          	addi	a0,a0,-262 # 80007438 <etext+0x438>
    80002546:	fb5fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000254a:	00010497          	auipc	s1,0x10
    8000254e:	67648493          	addi	s1,s1,1654 # 80012bc0 <proc+0x158>
    80002552:	00016917          	auipc	s2,0x16
    80002556:	46e90913          	addi	s2,s2,1134 # 800189c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000255a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000255c:	00005997          	auipc	s3,0x5
    80002560:	d0498993          	addi	s3,s3,-764 # 80007260 <etext+0x260>
    printf("%d %s %s", p->pid, state, p->name);
    80002564:	00005a97          	auipc	s5,0x5
    80002568:	d04a8a93          	addi	s5,s5,-764 # 80007268 <etext+0x268>
    printf("\n");
    8000256c:	00005a17          	auipc	s4,0x5
    80002570:	ecca0a13          	addi	s4,s4,-308 # 80007438 <etext+0x438>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002574:	00005b97          	auipc	s7,0x5
    80002578:	39cb8b93          	addi	s7,s7,924 # 80007910 <states.0>
    8000257c:	a829                	j	80002596 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000257e:	ed86a583          	lw	a1,-296(a3)
    80002582:	8556                	mv	a0,s5
    80002584:	f77fd0ef          	jal	800004fa <printf>
    printf("\n");
    80002588:	8552                	mv	a0,s4
    8000258a:	f71fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000258e:	17848493          	addi	s1,s1,376
    80002592:	03248263          	beq	s1,s2,800025b6 <procdump+0x8e>
    if(p->state == UNUSED)
    80002596:	86a6                	mv	a3,s1
    80002598:	ec04a783          	lw	a5,-320(s1)
    8000259c:	dbed                	beqz	a5,8000258e <procdump+0x66>
      state = "???";
    8000259e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025a0:	fcfb6fe3          	bltu	s6,a5,8000257e <procdump+0x56>
    800025a4:	02079713          	slli	a4,a5,0x20
    800025a8:	01d75793          	srli	a5,a4,0x1d
    800025ac:	97de                	add	a5,a5,s7
    800025ae:	6390                	ld	a2,0(a5)
    800025b0:	f679                	bnez	a2,8000257e <procdump+0x56>
      state = "???";
    800025b2:	864e                	mv	a2,s3
    800025b4:	b7e9                	j	8000257e <procdump+0x56>
  }
}
    800025b6:	60a6                	ld	ra,72(sp)
    800025b8:	6406                	ld	s0,64(sp)
    800025ba:	74e2                	ld	s1,56(sp)
    800025bc:	7942                	ld	s2,48(sp)
    800025be:	79a2                	ld	s3,40(sp)
    800025c0:	7a02                	ld	s4,32(sp)
    800025c2:	6ae2                	ld	s5,24(sp)
    800025c4:	6b42                	ld	s6,16(sp)
    800025c6:	6ba2                	ld	s7,8(sp)
    800025c8:	6161                	addi	sp,sp,80
    800025ca:	8082                	ret

00000000800025cc <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800025cc:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800025d0:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800025d4:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800025d6:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800025d8:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800025dc:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800025e0:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800025e4:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800025e8:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800025ec:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800025f0:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800025f4:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800025f8:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800025fc:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002600:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002604:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002608:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000260a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000260c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002610:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002614:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002618:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000261c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002620:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002624:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002628:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000262c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002630:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002634:	8082                	ret

0000000080002636 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002636:	1141                	addi	sp,sp,-16
    80002638:	e406                	sd	ra,8(sp)
    8000263a:	e022                	sd	s0,0(sp)
    8000263c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000263e:	00005597          	auipc	a1,0x5
    80002642:	c6a58593          	addi	a1,a1,-918 # 800072a8 <etext+0x2a8>
    80002646:	00016517          	auipc	a0,0x16
    8000264a:	22250513          	addi	a0,a0,546 # 80018868 <tickslock>
    8000264e:	d50fe0ef          	jal	80000b9e <initlock>
}
    80002652:	60a2                	ld	ra,8(sp)
    80002654:	6402                	ld	s0,0(sp)
    80002656:	0141                	addi	sp,sp,16
    80002658:	8082                	ret

000000008000265a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000265a:	1141                	addi	sp,sp,-16
    8000265c:	e406                	sd	ra,8(sp)
    8000265e:	e022                	sd	s0,0(sp)
    80002660:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002662:	00003797          	auipc	a5,0x3
    80002666:	0ee78793          	addi	a5,a5,238 # 80005750 <kernelvec>
    8000266a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000266e:	60a2                	ld	ra,8(sp)
    80002670:	6402                	ld	s0,0(sp)
    80002672:	0141                	addi	sp,sp,16
    80002674:	8082                	ret

0000000080002676 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
    void
prepare_return(void)
{
    80002676:	1141                	addi	sp,sp,-16
    80002678:	e406                	sd	ra,8(sp)
    8000267a:	e022                	sd	s0,0(sp)
    8000267c:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    8000267e:	c5eff0ef          	jal	80001adc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002682:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002686:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002688:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(). because a trap from kernel
    // code to usertrap would be a disaster, turn off interrupts.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000268c:	04000737          	lui	a4,0x4000
    80002690:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002692:	0732                	slli	a4,a4,0xc
    80002694:	00004797          	auipc	a5,0x4
    80002698:	96c78793          	addi	a5,a5,-1684 # 80006000 <_trampoline>
    8000269c:	00004697          	auipc	a3,0x4
    800026a0:	96468693          	addi	a3,a3,-1692 # 80006000 <_trampoline>
    800026a4:	8f95                	sub	a5,a5,a3
    800026a6:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026a8:	10579073          	csrw	stvec,a5
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026ac:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026ae:	18002773          	csrr	a4,satp
    800026b2:	e398                	sd	a4,0(a5)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026b4:	6d38                	ld	a4,88(a0)
    800026b6:	613c                	ld	a5,64(a0)
    800026b8:	6685                	lui	a3,0x1
    800026ba:	97b6                	add	a5,a5,a3
    800026bc:	e71c                	sd	a5,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    800026be:	6d3c                	ld	a5,88(a0)
    800026c0:	00000717          	auipc	a4,0x0
    800026c4:	0fc70713          	addi	a4,a4,252 # 800027bc <usertrap>
    800026c8:	eb98                	sd	a4,16(a5)
    p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026ca:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026cc:	8712                	mv	a4,tp
    800026ce:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d0:	100027f3          	csrr	a5,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026d4:	eff7f793          	andi	a5,a5,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026d8:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026dc:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    800026e0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026e2:	6f9c                	ld	a5,24(a5)
    800026e4:	14179073          	csrw	sepc,a5
}
    800026e8:	60a2                	ld	ra,8(sp)
    800026ea:	6402                	ld	s0,0(sp)
    800026ec:	0141                	addi	sp,sp,16
    800026ee:	8082                	ret

00000000800026f0 <clockintr>:
    w_sstatus(sstatus);
}

    void
clockintr()
{
    800026f0:	1141                	addi	sp,sp,-16
    800026f2:	e406                	sd	ra,8(sp)
    800026f4:	e022                	sd	s0,0(sp)
    800026f6:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    800026f8:	bb0ff0ef          	jal	80001aa8 <cpuid>
    800026fc:	cd11                	beqz	a0,80002718 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800026fe:	c01027f3          	rdtime	a5
    }

    // ask for the next timer interrupt. this also clears
    // the interrupt request. 1000000 is about a tenth
    // of a second.
    w_stimecmp(r_time() + 1000000);
    80002702:	000f4737          	lui	a4,0xf4
    80002706:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000270a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000270c:	14d79073          	csrw	stimecmp,a5
}
    80002710:	60a2                	ld	ra,8(sp)
    80002712:	6402                	ld	s0,0(sp)
    80002714:	0141                	addi	sp,sp,16
    80002716:	8082                	ret
        acquire(&tickslock);
    80002718:	00016517          	auipc	a0,0x16
    8000271c:	15050513          	addi	a0,a0,336 # 80018868 <tickslock>
    80002720:	d08fe0ef          	jal	80000c28 <acquire>
        ticks++;
    80002724:	00008717          	auipc	a4,0x8
    80002728:	e1470713          	addi	a4,a4,-492 # 8000a538 <ticks>
    8000272c:	431c                	lw	a5,0(a4)
    8000272e:	2785                	addiw	a5,a5,1
    80002730:	c31c                	sw	a5,0(a4)
        wakeup(&ticks);
    80002732:	853a                	mv	a0,a4
    80002734:	a45ff0ef          	jal	80002178 <wakeup>
        release(&tickslock);
    80002738:	00016517          	auipc	a0,0x16
    8000273c:	13050513          	addi	a0,a0,304 # 80018868 <tickslock>
    80002740:	d7cfe0ef          	jal	80000cbc <release>
    80002744:	bf6d                	j	800026fe <clockintr+0xe>

0000000080002746 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
    int
devintr()
{
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000274e:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if(scause == 0x8000000000000009L){
    80002752:	57fd                	li	a5,-1
    80002754:	17fe                	slli	a5,a5,0x3f
    80002756:	07a5                	addi	a5,a5,9
    80002758:	00f70c63          	beq	a4,a5,80002770 <devintr+0x2a>
        // now allowed to interrupt again.
        if(irq)
            plic_complete(irq);

        return 1;
    } else if(scause == 0x8000000000000005L){
    8000275c:	57fd                	li	a5,-1
    8000275e:	17fe                	slli	a5,a5,0x3f
    80002760:	0795                	addi	a5,a5,5
        // timer interrupt.
        clockintr();
        return 2;
    } else {
        return 0;
    80002762:	4501                	li	a0,0
    } else if(scause == 0x8000000000000005L){
    80002764:	04f70863          	beq	a4,a5,800027b4 <devintr+0x6e>
    }
}
    80002768:	60e2                	ld	ra,24(sp)
    8000276a:	6442                	ld	s0,16(sp)
    8000276c:	6105                	addi	sp,sp,32
    8000276e:	8082                	ret
    80002770:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002772:	08a030ef          	jal	800057fc <plic_claim>
    80002776:	872a                	mv	a4,a0
    80002778:	84aa                	mv	s1,a0
        if(irq == UART0_IRQ){
    8000277a:	47a9                	li	a5,10
    8000277c:	00f50963          	beq	a0,a5,8000278e <devintr+0x48>
        } else if(irq == VIRTIO0_IRQ){
    80002780:	4785                	li	a5,1
    80002782:	00f50963          	beq	a0,a5,80002794 <devintr+0x4e>
        return 1;
    80002786:	4505                	li	a0,1
        } else if(irq){
    80002788:	eb09                	bnez	a4,8000279a <devintr+0x54>
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	bff1                	j	80002768 <devintr+0x22>
            uartintr();
    8000278e:	a66fe0ef          	jal	800009f4 <uartintr>
        if(irq)
    80002792:	a819                	j	800027a8 <devintr+0x62>
            virtio_disk_intr();
    80002794:	4fe030ef          	jal	80005c92 <virtio_disk_intr>
        if(irq)
    80002798:	a801                	j	800027a8 <devintr+0x62>
            printf("unexpected interrupt irq=%d\n", irq);
    8000279a:	85ba                	mv	a1,a4
    8000279c:	00005517          	auipc	a0,0x5
    800027a0:	b1450513          	addi	a0,a0,-1260 # 800072b0 <etext+0x2b0>
    800027a4:	d57fd0ef          	jal	800004fa <printf>
            plic_complete(irq);
    800027a8:	8526                	mv	a0,s1
    800027aa:	072030ef          	jal	8000581c <plic_complete>
        return 1;
    800027ae:	4505                	li	a0,1
    800027b0:	64a2                	ld	s1,8(sp)
    800027b2:	bf5d                	j	80002768 <devintr+0x22>
        clockintr();
    800027b4:	f3dff0ef          	jal	800026f0 <clockintr>
        return 2;
    800027b8:	4509                	li	a0,2
    800027ba:	b77d                	j	80002768 <devintr+0x22>

00000000800027bc <usertrap>:
{
    800027bc:	7179                	addi	sp,sp,-48
    800027be:	f406                	sd	ra,40(sp)
    800027c0:	f022                	sd	s0,32(sp)
    800027c2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027c4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027c8:	1007f793          	andi	a5,a5,256
    800027cc:	0e079f63          	bnez	a5,800028ca <usertrap+0x10e>
    800027d0:	ec26                	sd	s1,24(sp)
    800027d2:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027d4:	00003797          	auipc	a5,0x3
    800027d8:	f7c78793          	addi	a5,a5,-132 # 80005750 <kernelvec>
    800027dc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027e0:	afcff0ef          	jal	80001adc <myproc>
    800027e4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800027e6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027e8:	14102773          	csrr	a4,sepc
    800027ec:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027ee:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800027f2:	47a1                	li	a5,8
    800027f4:	0ef70563          	beq	a4,a5,800028de <usertrap+0x122>
  } else if((which_dev = devintr()) != 0){
    800027f8:	f4fff0ef          	jal	80002746 <devintr>
    800027fc:	892a                	mv	s2,a0
    800027fe:	1c051d63          	bnez	a0,800029d8 <usertrap+0x21c>
    80002802:	14202773          	csrr	a4,scause
  } else if((r_scause()== 12 || r_scause() == 15 || r_scause() == 13)) {
    80002806:	47b1                	li	a5,12
    80002808:	00f70c63          	beq	a4,a5,80002820 <usertrap+0x64>
    8000280c:	14202773          	csrr	a4,scause
    80002810:	47bd                	li	a5,15
    80002812:	00f70763          	beq	a4,a5,80002820 <usertrap+0x64>
    80002816:	14202773          	csrr	a4,scause
    8000281a:	47b5                	li	a5,13
    8000281c:	18f71763          	bne	a4,a5,800029aa <usertrap+0x1ee>
    80002820:	e44e                	sd	s3,8(sp)
    80002822:	e052                	sd	s4,0(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002824:	14302773          	csrr	a4,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80002828:	77fd                	lui	a5,0xfffff
    8000282a:	8ff9                	and	a5,a5,a4
    8000282c:	89be                	mv	s3,a5
    struct proc *p = myproc();
    8000282e:	aaeff0ef          	jal	80001adc <myproc>
    80002832:	892a                	mv	s2,a0
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002834:	14202773          	csrr	a4,scause
    if (r_scause() == 12) { access_type = "exec"; }
    80002838:	47b1                	li	a5,12
    8000283a:	00005697          	auipc	a3,0x5
    8000283e:	94668693          	addi	a3,a3,-1722 # 80007180 <etext+0x180>
    80002842:	8a36                	mv	s4,a3
    80002844:	00f70c63          	beq	a4,a5,8000285c <usertrap+0xa0>
    80002848:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    8000284c:	47b5                	li	a5,13
    else { access_type = "write"; }
    8000284e:	00005697          	auipc	a3,0x5
    80002852:	a8268693          	addi	a3,a3,-1406 # 800072d0 <etext+0x2d0>
    80002856:	8a36                	mv	s4,a3
    else if (r_scause() == 13) { access_type = "read"; }
    80002858:	0cf70863          	beq	a4,a5,80002928 <usertrap+0x16c>
    if(handle_pgfault(p->pagetable, va) < 0) {
    8000285c:	85ce                	mv	a1,s3
    8000285e:	05093503          	ld	a0,80(s2)
    80002862:	8b5fe0ef          	jal	80001116 <handle_pgfault>
    80002866:	0c054763          	bltz	a0,80002934 <usertrap+0x178>
        if (va < p->heap_start) {
    8000286a:	16893783          	ld	a5,360(s2)
    8000286e:	0ef9e463          	bltu	s3,a5,80002956 <usertrap+0x19a>
        } else if (va < p->sz) {
    80002872:	04893783          	ld	a5,72(s2)
    80002876:	10f9f563          	bgeu	s3,a5,80002980 <usertrap+0x1c4>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000287a:	14302673          	csrr	a2,stval
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=heap\n", p->pid, r_stval(), access_type);
    8000287e:	86d2                	mv	a3,s4
    80002880:	03092583          	lw	a1,48(s2)
    80002884:	00005517          	auipc	a0,0x5
    80002888:	b0450513          	addi	a0,a0,-1276 # 80007388 <etext+0x388>
    8000288c:	c6ffd0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n",p->pid, va);
    80002890:	864e                	mv	a2,s3
    80002892:	03092583          	lw	a1,48(s2)
    80002896:	00005517          	auipc	a0,0x5
    8000289a:	b2a50513          	addi	a0,a0,-1238 # 800073c0 <etext+0x3c0>
    8000289e:	c5dfd0ef          	jal	800004fa <printf>
        printf("[pid %d] RESIDENT va=0x%lx seq=0\n",p->pid, va);
    800028a2:	864e                	mv	a2,s3
    800028a4:	03092583          	lw	a1,48(s2)
    800028a8:	00005517          	auipc	a0,0x5
    800028ac:	b7050513          	addi	a0,a0,-1168 # 80007418 <etext+0x418>
    800028b0:	c4bfd0ef          	jal	800004fa <printf>
  asm volatile("sfence.vma zero, zero");
    800028b4:	12000073          	sfence.vma
        printf("returning from pagefault");
    800028b8:	00005517          	auipc	a0,0x5
    800028bc:	b8850513          	addi	a0,a0,-1144 # 80007440 <etext+0x440>
    800028c0:	c3bfd0ef          	jal	800004fa <printf>
    800028c4:	69a2                	ld	s3,8(sp)
    800028c6:	6a02                	ld	s4,0(sp)
    800028c8:	a815                	j	800028fc <usertrap+0x140>
    800028ca:	ec26                	sd	s1,24(sp)
    800028cc:	e84a                	sd	s2,16(sp)
    800028ce:	e44e                	sd	s3,8(sp)
    800028d0:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    800028d2:	00005517          	auipc	a0,0x5
    800028d6:	a0650513          	addi	a0,a0,-1530 # 800072d8 <etext+0x2d8>
    800028da:	f4bfd0ef          	jal	80000824 <panic>
    if(killed(p))
    800028de:	a99ff0ef          	jal	80002376 <killed>
    800028e2:	ed1d                	bnez	a0,80002920 <usertrap+0x164>
    p->trapframe->epc += 4;
    800028e4:	6cb8                	ld	a4,88(s1)
    800028e6:	6f1c                	ld	a5,24(a4)
    800028e8:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ffdb3bc>
    800028ea:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028ec:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028f4:	10079073          	csrw	sstatus,a5
    syscall();
    800028f8:	2da000ef          	jal	80002bd2 <syscall>
  if(killed(p))
    800028fc:	8526                	mv	a0,s1
    800028fe:	a79ff0ef          	jal	80002376 <killed>
    80002902:	0e051063          	bnez	a0,800029e2 <usertrap+0x226>
  prepare_return();
    80002906:	d71ff0ef          	jal	80002676 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000290a:	68a8                	ld	a0,80(s1)
    8000290c:	8131                	srli	a0,a0,0xc
    8000290e:	57fd                	li	a5,-1
    80002910:	17fe                	slli	a5,a5,0x3f
    80002912:	8d5d                	or	a0,a0,a5
}
    80002914:	64e2                	ld	s1,24(sp)
    80002916:	6942                	ld	s2,16(sp)
    80002918:	70a2                	ld	ra,40(sp)
    8000291a:	7402                	ld	s0,32(sp)
    8000291c:	6145                	addi	sp,sp,48
    8000291e:	8082                	ret
      kexit(-1);
    80002920:	557d                	li	a0,-1
    80002922:	917ff0ef          	jal	80002238 <kexit>
    80002926:	bf7d                	j	800028e4 <usertrap+0x128>
    else if (r_scause() == 13) { access_type = "read"; }
    80002928:	00005797          	auipc	a5,0x5
    8000292c:	d7878793          	addi	a5,a5,-648 # 800076a0 <etext+0x6a0>
    80002930:	8a3e                	mv	s4,a5
    80002932:	b72d                	j	8000285c <usertrap+0xa0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002934:	14302673          	csrr	a2,stval
      printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, r_stval(), access_type);
    80002938:	86d2                	mv	a3,s4
    8000293a:	03092583          	lw	a1,48(s2)
    8000293e:	00005517          	auipc	a0,0x5
    80002942:	9ba50513          	addi	a0,a0,-1606 # 800072f8 <etext+0x2f8>
    80002946:	bb5fd0ef          	jal	800004fa <printf>
      setkilled(p);
    8000294a:	854a                	mv	a0,s2
    8000294c:	a07ff0ef          	jal	80002352 <setkilled>
    80002950:	69a2                	ld	s3,8(sp)
    80002952:	6a02                	ld	s4,0(sp)
    80002954:	b765                	j	800028fc <usertrap+0x140>
    80002956:	14302673          	csrr	a2,stval
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=exec\n", p->pid, r_stval(), access_type);
    8000295a:	86d2                	mv	a3,s4
    8000295c:	03092583          	lw	a1,48(s2)
    80002960:	00005517          	auipc	a0,0x5
    80002964:	9d050513          	addi	a0,a0,-1584 # 80007330 <etext+0x330>
    80002968:	b93fd0ef          	jal	800004fa <printf>
            printf("[pid %d] LOADEXEC va=0x%lx\n",p->pid, va);
    8000296c:	864e                	mv	a2,s3
    8000296e:	03092583          	lw	a1,48(s2)
    80002972:	00005517          	auipc	a0,0x5
    80002976:	9f650513          	addi	a0,a0,-1546 # 80007368 <etext+0x368>
    8000297a:	b81fd0ef          	jal	800004fa <printf>
    8000297e:	b715                	j	800028a2 <usertrap+0xe6>
    80002980:	14302673          	csrr	a2,stval
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=stack\n", p->pid, r_stval(), access_type);
    80002984:	86d2                	mv	a3,s4
    80002986:	03092583          	lw	a1,48(s2)
    8000298a:	00005517          	auipc	a0,0x5
    8000298e:	a5650513          	addi	a0,a0,-1450 # 800073e0 <etext+0x3e0>
    80002992:	b69fd0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n",p->pid, va);
    80002996:	864e                	mv	a2,s3
    80002998:	03092583          	lw	a1,48(s2)
    8000299c:	00005517          	auipc	a0,0x5
    800029a0:	a2450513          	addi	a0,a0,-1500 # 800073c0 <etext+0x3c0>
    800029a4:	b57fd0ef          	jal	800004fa <printf>
    800029a8:	bded                	j	800028a2 <usertrap+0xe6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029aa:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800029ae:	5890                	lw	a2,48(s1)
    800029b0:	00005517          	auipc	a0,0x5
    800029b4:	ab050513          	addi	a0,a0,-1360 # 80007460 <etext+0x460>
    800029b8:	b43fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029bc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029c0:	14302673          	csrr	a2,stval
      printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800029c4:	00005517          	auipc	a0,0x5
    800029c8:	acc50513          	addi	a0,a0,-1332 # 80007490 <etext+0x490>
    800029cc:	b2ffd0ef          	jal	800004fa <printf>
      setkilled(p);
    800029d0:	8526                	mv	a0,s1
    800029d2:	981ff0ef          	jal	80002352 <setkilled>
    800029d6:	b71d                	j	800028fc <usertrap+0x140>
  if(killed(p))
    800029d8:	8526                	mv	a0,s1
    800029da:	99dff0ef          	jal	80002376 <killed>
    800029de:	c511                	beqz	a0,800029ea <usertrap+0x22e>
    800029e0:	a011                	j	800029e4 <usertrap+0x228>
    800029e2:	4901                	li	s2,0
      kexit(-1);
    800029e4:	557d                	li	a0,-1
    800029e6:	853ff0ef          	jal	80002238 <kexit>
  if(which_dev == 2)
    800029ea:	4789                	li	a5,2
    800029ec:	f0f91de3          	bne	s2,a5,80002906 <usertrap+0x14a>
      yield();
    800029f0:	f10ff0ef          	jal	80002100 <yield>
    800029f4:	bf09                	j	80002906 <usertrap+0x14a>

00000000800029f6 <kerneltrap>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a04:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a08:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a0c:	142027f3          	csrr	a5,scause
    80002a10:	89be                	mv	s3,a5
    if((sstatus & SSTATUS_SPP) == 0)
    80002a12:	1004f793          	andi	a5,s1,256
    80002a16:	c795                	beqz	a5,80002a42 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a18:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a1c:	8b89                	andi	a5,a5,2
    if(intr_get() != 0)
    80002a1e:	eb85                	bnez	a5,80002a4e <kerneltrap+0x58>
    if((which_dev = devintr()) == 0){
    80002a20:	d27ff0ef          	jal	80002746 <devintr>
    80002a24:	c91d                	beqz	a0,80002a5a <kerneltrap+0x64>
    if(which_dev == 2 && myproc() != 0)
    80002a26:	4789                	li	a5,2
    80002a28:	04f50a63          	beq	a0,a5,80002a7c <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a2c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a30:	10049073          	csrw	sstatus,s1
}
    80002a34:	70a2                	ld	ra,40(sp)
    80002a36:	7402                	ld	s0,32(sp)
    80002a38:	64e2                	ld	s1,24(sp)
    80002a3a:	6942                	ld	s2,16(sp)
    80002a3c:	69a2                	ld	s3,8(sp)
    80002a3e:	6145                	addi	sp,sp,48
    80002a40:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002a42:	00005517          	auipc	a0,0x5
    80002a46:	a7650513          	addi	a0,a0,-1418 # 800074b8 <etext+0x4b8>
    80002a4a:	ddbfd0ef          	jal	80000824 <panic>
        panic("kerneltrap: interrupts enabled");
    80002a4e:	00005517          	auipc	a0,0x5
    80002a52:	a9250513          	addi	a0,a0,-1390 # 800074e0 <etext+0x4e0>
    80002a56:	dcffd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a5a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a5e:	143026f3          	csrr	a3,stval
        printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002a62:	85ce                	mv	a1,s3
    80002a64:	00005517          	auipc	a0,0x5
    80002a68:	a9c50513          	addi	a0,a0,-1380 # 80007500 <etext+0x500>
    80002a6c:	a8ffd0ef          	jal	800004fa <printf>
        panic("kerneltrap");
    80002a70:	00005517          	auipc	a0,0x5
    80002a74:	ab850513          	addi	a0,a0,-1352 # 80007528 <etext+0x528>
    80002a78:	dadfd0ef          	jal	80000824 <panic>
    if(which_dev == 2 && myproc() != 0)
    80002a7c:	860ff0ef          	jal	80001adc <myproc>
    80002a80:	d555                	beqz	a0,80002a2c <kerneltrap+0x36>
        yield();
    80002a82:	e7eff0ef          	jal	80002100 <yield>
    80002a86:	b75d                	j	80002a2c <kerneltrap+0x36>

0000000080002a88 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a88:	1101                	addi	sp,sp,-32
    80002a8a:	ec06                	sd	ra,24(sp)
    80002a8c:	e822                	sd	s0,16(sp)
    80002a8e:	e426                	sd	s1,8(sp)
    80002a90:	1000                	addi	s0,sp,32
    80002a92:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a94:	848ff0ef          	jal	80001adc <myproc>
  switch (n) {
    80002a98:	4795                	li	a5,5
    80002a9a:	0497e163          	bltu	a5,s1,80002adc <argraw+0x54>
    80002a9e:	048a                	slli	s1,s1,0x2
    80002aa0:	00005717          	auipc	a4,0x5
    80002aa4:	ea070713          	addi	a4,a4,-352 # 80007940 <states.0+0x30>
    80002aa8:	94ba                	add	s1,s1,a4
    80002aaa:	409c                	lw	a5,0(s1)
    80002aac:	97ba                	add	a5,a5,a4
    80002aae:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ab0:	6d3c                	ld	a5,88(a0)
    80002ab2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ab4:	60e2                	ld	ra,24(sp)
    80002ab6:	6442                	ld	s0,16(sp)
    80002ab8:	64a2                	ld	s1,8(sp)
    80002aba:	6105                	addi	sp,sp,32
    80002abc:	8082                	ret
    return p->trapframe->a1;
    80002abe:	6d3c                	ld	a5,88(a0)
    80002ac0:	7fa8                	ld	a0,120(a5)
    80002ac2:	bfcd                	j	80002ab4 <argraw+0x2c>
    return p->trapframe->a2;
    80002ac4:	6d3c                	ld	a5,88(a0)
    80002ac6:	63c8                	ld	a0,128(a5)
    80002ac8:	b7f5                	j	80002ab4 <argraw+0x2c>
    return p->trapframe->a3;
    80002aca:	6d3c                	ld	a5,88(a0)
    80002acc:	67c8                	ld	a0,136(a5)
    80002ace:	b7dd                	j	80002ab4 <argraw+0x2c>
    return p->trapframe->a4;
    80002ad0:	6d3c                	ld	a5,88(a0)
    80002ad2:	6bc8                	ld	a0,144(a5)
    80002ad4:	b7c5                	j	80002ab4 <argraw+0x2c>
    return p->trapframe->a5;
    80002ad6:	6d3c                	ld	a5,88(a0)
    80002ad8:	6fc8                	ld	a0,152(a5)
    80002ada:	bfe9                	j	80002ab4 <argraw+0x2c>
  panic("argraw");
    80002adc:	00005517          	auipc	a0,0x5
    80002ae0:	a5c50513          	addi	a0,a0,-1444 # 80007538 <etext+0x538>
    80002ae4:	d41fd0ef          	jal	80000824 <panic>

0000000080002ae8 <fetchaddr>:
{
    80002ae8:	1101                	addi	sp,sp,-32
    80002aea:	ec06                	sd	ra,24(sp)
    80002aec:	e822                	sd	s0,16(sp)
    80002aee:	e426                	sd	s1,8(sp)
    80002af0:	e04a                	sd	s2,0(sp)
    80002af2:	1000                	addi	s0,sp,32
    80002af4:	84aa                	mv	s1,a0
    80002af6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002af8:	fe5fe0ef          	jal	80001adc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002afc:	653c                	ld	a5,72(a0)
    80002afe:	02f4f663          	bgeu	s1,a5,80002b2a <fetchaddr+0x42>
    80002b02:	00848713          	addi	a4,s1,8
    80002b06:	02e7e463          	bltu	a5,a4,80002b2e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b0a:	46a1                	li	a3,8
    80002b0c:	8626                	mv	a2,s1
    80002b0e:	85ca                	mv	a1,s2
    80002b10:	6928                	ld	a0,80(a0)
    80002b12:	cbffe0ef          	jal	800017d0 <copyin>
    80002b16:	00a03533          	snez	a0,a0
    80002b1a:	40a0053b          	negw	a0,a0
}
    80002b1e:	60e2                	ld	ra,24(sp)
    80002b20:	6442                	ld	s0,16(sp)
    80002b22:	64a2                	ld	s1,8(sp)
    80002b24:	6902                	ld	s2,0(sp)
    80002b26:	6105                	addi	sp,sp,32
    80002b28:	8082                	ret
    return -1;
    80002b2a:	557d                	li	a0,-1
    80002b2c:	bfcd                	j	80002b1e <fetchaddr+0x36>
    80002b2e:	557d                	li	a0,-1
    80002b30:	b7fd                	j	80002b1e <fetchaddr+0x36>

0000000080002b32 <fetchstr>:
{
    80002b32:	7179                	addi	sp,sp,-48
    80002b34:	f406                	sd	ra,40(sp)
    80002b36:	f022                	sd	s0,32(sp)
    80002b38:	ec26                	sd	s1,24(sp)
    80002b3a:	e84a                	sd	s2,16(sp)
    80002b3c:	e44e                	sd	s3,8(sp)
    80002b3e:	1800                	addi	s0,sp,48
    80002b40:	89aa                	mv	s3,a0
    80002b42:	84ae                	mv	s1,a1
    80002b44:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002b46:	f97fe0ef          	jal	80001adc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b4a:	86ca                	mv	a3,s2
    80002b4c:	864e                	mv	a2,s3
    80002b4e:	85a6                	mv	a1,s1
    80002b50:	6928                	ld	a0,80(a0)
    80002b52:	d19fe0ef          	jal	8000186a <copyinstr>
    80002b56:	00054c63          	bltz	a0,80002b6e <fetchstr+0x3c>
  return strlen(buf);
    80002b5a:	8526                	mv	a0,s1
    80002b5c:	b26fe0ef          	jal	80000e82 <strlen>
}
    80002b60:	70a2                	ld	ra,40(sp)
    80002b62:	7402                	ld	s0,32(sp)
    80002b64:	64e2                	ld	s1,24(sp)
    80002b66:	6942                	ld	s2,16(sp)
    80002b68:	69a2                	ld	s3,8(sp)
    80002b6a:	6145                	addi	sp,sp,48
    80002b6c:	8082                	ret
    return -1;
    80002b6e:	557d                	li	a0,-1
    80002b70:	bfc5                	j	80002b60 <fetchstr+0x2e>

0000000080002b72 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b72:	1101                	addi	sp,sp,-32
    80002b74:	ec06                	sd	ra,24(sp)
    80002b76:	e822                	sd	s0,16(sp)
    80002b78:	e426                	sd	s1,8(sp)
    80002b7a:	1000                	addi	s0,sp,32
    80002b7c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b7e:	f0bff0ef          	jal	80002a88 <argraw>
    80002b82:	c088                	sw	a0,0(s1)
}
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	1000                	addi	s0,sp,32
    80002b98:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b9a:	eefff0ef          	jal	80002a88 <argraw>
    80002b9e:	e088                	sd	a0,0(s1)
}
    80002ba0:	60e2                	ld	ra,24(sp)
    80002ba2:	6442                	ld	s0,16(sp)
    80002ba4:	64a2                	ld	s1,8(sp)
    80002ba6:	6105                	addi	sp,sp,32
    80002ba8:	8082                	ret

0000000080002baa <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002baa:	1101                	addi	sp,sp,-32
    80002bac:	ec06                	sd	ra,24(sp)
    80002bae:	e822                	sd	s0,16(sp)
    80002bb0:	e426                	sd	s1,8(sp)
    80002bb2:	e04a                	sd	s2,0(sp)
    80002bb4:	1000                	addi	s0,sp,32
    80002bb6:	892e                	mv	s2,a1
    80002bb8:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002bba:	ecfff0ef          	jal	80002a88 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002bbe:	8626                	mv	a2,s1
    80002bc0:	85ca                	mv	a1,s2
    80002bc2:	f71ff0ef          	jal	80002b32 <fetchstr>
}
    80002bc6:	60e2                	ld	ra,24(sp)
    80002bc8:	6442                	ld	s0,16(sp)
    80002bca:	64a2                	ld	s1,8(sp)
    80002bcc:	6902                	ld	s2,0(sp)
    80002bce:	6105                	addi	sp,sp,32
    80002bd0:	8082                	ret

0000000080002bd2 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002bd2:	1101                	addi	sp,sp,-32
    80002bd4:	ec06                	sd	ra,24(sp)
    80002bd6:	e822                	sd	s0,16(sp)
    80002bd8:	e426                	sd	s1,8(sp)
    80002bda:	e04a                	sd	s2,0(sp)
    80002bdc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bde:	efffe0ef          	jal	80001adc <myproc>
    80002be2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002be4:	05853903          	ld	s2,88(a0)
    80002be8:	0a893783          	ld	a5,168(s2)
    80002bec:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bf0:	37fd                	addiw	a5,a5,-1
    80002bf2:	4751                	li	a4,20
    80002bf4:	00f76f63          	bltu	a4,a5,80002c12 <syscall+0x40>
    80002bf8:	00369713          	slli	a4,a3,0x3
    80002bfc:	00005797          	auipc	a5,0x5
    80002c00:	d5c78793          	addi	a5,a5,-676 # 80007958 <syscalls>
    80002c04:	97ba                	add	a5,a5,a4
    80002c06:	639c                	ld	a5,0(a5)
    80002c08:	c789                	beqz	a5,80002c12 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c0a:	9782                	jalr	a5
    80002c0c:	06a93823          	sd	a0,112(s2)
    80002c10:	a829                	j	80002c2a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c12:	15848613          	addi	a2,s1,344
    80002c16:	588c                	lw	a1,48(s1)
    80002c18:	00005517          	auipc	a0,0x5
    80002c1c:	92850513          	addi	a0,a0,-1752 # 80007540 <etext+0x540>
    80002c20:	8dbfd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c24:	6cbc                	ld	a5,88(s1)
    80002c26:	577d                	li	a4,-1
    80002c28:	fbb8                	sd	a4,112(a5)
  }
}
    80002c2a:	60e2                	ld	ra,24(sp)
    80002c2c:	6442                	ld	s0,16(sp)
    80002c2e:	64a2                	ld	s1,8(sp)
    80002c30:	6902                	ld	s2,0(sp)
    80002c32:	6105                	addi	sp,sp,32
    80002c34:	8082                	ret

0000000080002c36 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002c36:	1101                	addi	sp,sp,-32
    80002c38:	ec06                	sd	ra,24(sp)
    80002c3a:	e822                	sd	s0,16(sp)
    80002c3c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c3e:	fec40593          	addi	a1,s0,-20
    80002c42:	4501                	li	a0,0
    80002c44:	f2fff0ef          	jal	80002b72 <argint>
  kexit(n);
    80002c48:	fec42503          	lw	a0,-20(s0)
    80002c4c:	decff0ef          	jal	80002238 <kexit>
  return 0;  // not reached
}
    80002c50:	4501                	li	a0,0
    80002c52:	60e2                	ld	ra,24(sp)
    80002c54:	6442                	ld	s0,16(sp)
    80002c56:	6105                	addi	sp,sp,32
    80002c58:	8082                	ret

0000000080002c5a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c5a:	1141                	addi	sp,sp,-16
    80002c5c:	e406                	sd	ra,8(sp)
    80002c5e:	e022                	sd	s0,0(sp)
    80002c60:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c62:	e7bfe0ef          	jal	80001adc <myproc>
}
    80002c66:	5908                	lw	a0,48(a0)
    80002c68:	60a2                	ld	ra,8(sp)
    80002c6a:	6402                	ld	s0,0(sp)
    80002c6c:	0141                	addi	sp,sp,16
    80002c6e:	8082                	ret

0000000080002c70 <sys_fork>:

uint64
sys_fork(void)
{
    80002c70:	1141                	addi	sp,sp,-16
    80002c72:	e406                	sd	ra,8(sp)
    80002c74:	e022                	sd	s0,0(sp)
    80002c76:	0800                	addi	s0,sp,16
  return kfork();
    80002c78:	9d6ff0ef          	jal	80001e4e <kfork>
}
    80002c7c:	60a2                	ld	ra,8(sp)
    80002c7e:	6402                	ld	s0,0(sp)
    80002c80:	0141                	addi	sp,sp,16
    80002c82:	8082                	ret

0000000080002c84 <sys_wait>:

uint64
sys_wait(void)
{
    80002c84:	1101                	addi	sp,sp,-32
    80002c86:	ec06                	sd	ra,24(sp)
    80002c88:	e822                	sd	s0,16(sp)
    80002c8a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002c8c:	fe840593          	addi	a1,s0,-24
    80002c90:	4501                	li	a0,0
    80002c92:	efdff0ef          	jal	80002b8e <argaddr>
  return kwait(p);
    80002c96:	fe843503          	ld	a0,-24(s0)
    80002c9a:	f06ff0ef          	jal	800023a0 <kwait>
}
    80002c9e:	60e2                	ld	ra,24(sp)
    80002ca0:	6442                	ld	s0,16(sp)
    80002ca2:	6105                	addi	sp,sp,32
    80002ca4:	8082                	ret

0000000080002ca6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002ca6:	715d                	addi	sp,sp,-80
    80002ca8:	e486                	sd	ra,72(sp)
    80002caa:	e0a2                	sd	s0,64(sp)
    80002cac:	fc26                	sd	s1,56(sp)
    80002cae:	0880                	addi	s0,sp,80
  uint64 addr;
  int n;

  argint(0, &n);
    80002cb0:	fbc40593          	addi	a1,s0,-68
    80002cb4:	4501                	li	a0,0
    80002cb6:	ebdff0ef          	jal	80002b72 <argint>
  addr = myproc()->sz;
    80002cba:	e23fe0ef          	jal	80001adc <myproc>
    80002cbe:	6524                	ld	s1,72(a0)

  if (n > 0) {
    80002cc0:	fbc42783          	lw	a5,-68(s0)
    80002cc4:	02f05363          	blez	a5,80002cea <sys_sbrk+0x44>
    if(addr + n < addr || addr + n > TRAPFRAME) // Check for overflow or exceeding max address
    80002cc8:	97a6                	add	a5,a5,s1
    80002cca:	02000737          	lui	a4,0x2000
    80002cce:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002cd0:	0736                	slli	a4,a4,0xd
    80002cd2:	06f76663          	bltu	a4,a5,80002d3e <sys_sbrk+0x98>
    80002cd6:	0697e463          	bltu	a5,s1,80002d3e <sys_sbrk+0x98>
      return -1;
    myproc()->sz += n;
    80002cda:	e03fe0ef          	jal	80001adc <myproc>
    80002cde:	fbc42703          	lw	a4,-68(s0)
    80002ce2:	653c                	ld	a5,72(a0)
    80002ce4:	97ba                	add	a5,a5,a4
    80002ce6:	e53c                	sd	a5,72(a0)
    80002ce8:	a019                	j	80002cee <sys_sbrk+0x48>
  } else if (n < 0) {
    80002cea:	0007c863          	bltz	a5,80002cfa <sys_sbrk+0x54>
    return -1;
  }
  */

  return addr;
}
    80002cee:	8526                	mv	a0,s1
    80002cf0:	60a6                	ld	ra,72(sp)
    80002cf2:	6406                	ld	s0,64(sp)
    80002cf4:	74e2                	ld	s1,56(sp)
    80002cf6:	6161                	addi	sp,sp,80
    80002cf8:	8082                	ret
    80002cfa:	f84a                	sd	s2,48(sp)
    80002cfc:	f44e                	sd	s3,40(sp)
    80002cfe:	f052                	sd	s4,32(sp)
    80002d00:	ec56                	sd	s5,24(sp)
    myproc()->sz = uvmdealloc(myproc()->pagetable, myproc()->sz, myproc()->sz + n);
    80002d02:	ddbfe0ef          	jal	80001adc <myproc>
    80002d06:	05053903          	ld	s2,80(a0)
    80002d0a:	dd3fe0ef          	jal	80001adc <myproc>
    80002d0e:	04853983          	ld	s3,72(a0)
    80002d12:	dcbfe0ef          	jal	80001adc <myproc>
    80002d16:	fbc42783          	lw	a5,-68(s0)
    80002d1a:	6538                	ld	a4,72(a0)
    80002d1c:	00e78a33          	add	s4,a5,a4
    80002d20:	dbdfe0ef          	jal	80001adc <myproc>
    80002d24:	8aaa                	mv	s5,a0
    80002d26:	8652                	mv	a2,s4
    80002d28:	85ce                	mv	a1,s3
    80002d2a:	854a                	mv	a0,s2
    80002d2c:	f82fe0ef          	jal	800014ae <uvmdealloc>
    80002d30:	04aab423          	sd	a0,72(s5)
    80002d34:	7942                	ld	s2,48(sp)
    80002d36:	79a2                	ld	s3,40(sp)
    80002d38:	7a02                	ld	s4,32(sp)
    80002d3a:	6ae2                	ld	s5,24(sp)
    80002d3c:	bf4d                	j	80002cee <sys_sbrk+0x48>
      return -1;
    80002d3e:	54fd                	li	s1,-1
    80002d40:	b77d                	j	80002cee <sys_sbrk+0x48>

0000000080002d42 <sys_pause>:

uint64
sys_pause(void)
{
    80002d42:	7139                	addi	sp,sp,-64
    80002d44:	fc06                	sd	ra,56(sp)
    80002d46:	f822                	sd	s0,48(sp)
    80002d48:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d4a:	fcc40593          	addi	a1,s0,-52
    80002d4e:	4501                	li	a0,0
    80002d50:	e23ff0ef          	jal	80002b72 <argint>
  if(n < 0)
    80002d54:	fcc42783          	lw	a5,-52(s0)
    80002d58:	0607c863          	bltz	a5,80002dc8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002d5c:	00016517          	auipc	a0,0x16
    80002d60:	b0c50513          	addi	a0,a0,-1268 # 80018868 <tickslock>
    80002d64:	ec5fd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002d68:	fcc42783          	lw	a5,-52(s0)
    80002d6c:	c3b9                	beqz	a5,80002db2 <sys_pause+0x70>
    80002d6e:	f426                	sd	s1,40(sp)
    80002d70:	f04a                	sd	s2,32(sp)
    80002d72:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002d74:	00007997          	auipc	s3,0x7
    80002d78:	7c49a983          	lw	s3,1988(s3) # 8000a538 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d7c:	00016917          	auipc	s2,0x16
    80002d80:	aec90913          	addi	s2,s2,-1300 # 80018868 <tickslock>
    80002d84:	00007497          	auipc	s1,0x7
    80002d88:	7b448493          	addi	s1,s1,1972 # 8000a538 <ticks>
    if(killed(myproc())){
    80002d8c:	d51fe0ef          	jal	80001adc <myproc>
    80002d90:	de6ff0ef          	jal	80002376 <killed>
    80002d94:	ed0d                	bnez	a0,80002dce <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002d96:	85ca                	mv	a1,s2
    80002d98:	8526                	mv	a0,s1
    80002d9a:	b92ff0ef          	jal	8000212c <sleep>
  while(ticks - ticks0 < n){
    80002d9e:	409c                	lw	a5,0(s1)
    80002da0:	413787bb          	subw	a5,a5,s3
    80002da4:	fcc42703          	lw	a4,-52(s0)
    80002da8:	fee7e2e3          	bltu	a5,a4,80002d8c <sys_pause+0x4a>
    80002dac:	74a2                	ld	s1,40(sp)
    80002dae:	7902                	ld	s2,32(sp)
    80002db0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002db2:	00016517          	auipc	a0,0x16
    80002db6:	ab650513          	addi	a0,a0,-1354 # 80018868 <tickslock>
    80002dba:	f03fd0ef          	jal	80000cbc <release>
  return 0;
    80002dbe:	4501                	li	a0,0
}
    80002dc0:	70e2                	ld	ra,56(sp)
    80002dc2:	7442                	ld	s0,48(sp)
    80002dc4:	6121                	addi	sp,sp,64
    80002dc6:	8082                	ret
    n = 0;
    80002dc8:	fc042623          	sw	zero,-52(s0)
    80002dcc:	bf41                	j	80002d5c <sys_pause+0x1a>
      release(&tickslock);
    80002dce:	00016517          	auipc	a0,0x16
    80002dd2:	a9a50513          	addi	a0,a0,-1382 # 80018868 <tickslock>
    80002dd6:	ee7fd0ef          	jal	80000cbc <release>
      return -1;
    80002dda:	557d                	li	a0,-1
    80002ddc:	74a2                	ld	s1,40(sp)
    80002dde:	7902                	ld	s2,32(sp)
    80002de0:	69e2                	ld	s3,24(sp)
    80002de2:	bff9                	j	80002dc0 <sys_pause+0x7e>

0000000080002de4 <sys_kill>:

uint64
sys_kill(void)
{
    80002de4:	1101                	addi	sp,sp,-32
    80002de6:	ec06                	sd	ra,24(sp)
    80002de8:	e822                	sd	s0,16(sp)
    80002dea:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002dec:	fec40593          	addi	a1,s0,-20
    80002df0:	4501                	li	a0,0
    80002df2:	d81ff0ef          	jal	80002b72 <argint>
  return kkill(pid);
    80002df6:	fec42503          	lw	a0,-20(s0)
    80002dfa:	cf2ff0ef          	jal	800022ec <kkill>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	6105                	addi	sp,sp,32
    80002e04:	8082                	ret

0000000080002e06 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e10:	00016517          	auipc	a0,0x16
    80002e14:	a5850513          	addi	a0,a0,-1448 # 80018868 <tickslock>
    80002e18:	e11fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80002e1c:	00007797          	auipc	a5,0x7
    80002e20:	71c7a783          	lw	a5,1820(a5) # 8000a538 <ticks>
    80002e24:	84be                	mv	s1,a5
  release(&tickslock);
    80002e26:	00016517          	auipc	a0,0x16
    80002e2a:	a4250513          	addi	a0,a0,-1470 # 80018868 <tickslock>
    80002e2e:	e8ffd0ef          	jal	80000cbc <release>
  return xticks;
}
    80002e32:	02049513          	slli	a0,s1,0x20
    80002e36:	9101                	srli	a0,a0,0x20
    80002e38:	60e2                	ld	ra,24(sp)
    80002e3a:	6442                	ld	s0,16(sp)
    80002e3c:	64a2                	ld	s1,8(sp)
    80002e3e:	6105                	addi	sp,sp,32
    80002e40:	8082                	ret

0000000080002e42 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e42:	7179                	addi	sp,sp,-48
    80002e44:	f406                	sd	ra,40(sp)
    80002e46:	f022                	sd	s0,32(sp)
    80002e48:	ec26                	sd	s1,24(sp)
    80002e4a:	e84a                	sd	s2,16(sp)
    80002e4c:	e44e                	sd	s3,8(sp)
    80002e4e:	e052                	sd	s4,0(sp)
    80002e50:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e52:	00004597          	auipc	a1,0x4
    80002e56:	70e58593          	addi	a1,a1,1806 # 80007560 <etext+0x560>
    80002e5a:	00016517          	auipc	a0,0x16
    80002e5e:	a2650513          	addi	a0,a0,-1498 # 80018880 <bcache>
    80002e62:	d3dfd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e66:	0001e797          	auipc	a5,0x1e
    80002e6a:	a1a78793          	addi	a5,a5,-1510 # 80020880 <bcache+0x8000>
    80002e6e:	0001e717          	auipc	a4,0x1e
    80002e72:	c7a70713          	addi	a4,a4,-902 # 80020ae8 <bcache+0x8268>
    80002e76:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e7a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e7e:	00016497          	auipc	s1,0x16
    80002e82:	a1a48493          	addi	s1,s1,-1510 # 80018898 <bcache+0x18>
    b->next = bcache.head.next;
    80002e86:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e88:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e8a:	00004a17          	auipc	s4,0x4
    80002e8e:	6dea0a13          	addi	s4,s4,1758 # 80007568 <etext+0x568>
    b->next = bcache.head.next;
    80002e92:	2b893783          	ld	a5,696(s2)
    80002e96:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e98:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e9c:	85d2                	mv	a1,s4
    80002e9e:	01048513          	addi	a0,s1,16
    80002ea2:	328010ef          	jal	800041ca <initsleeplock>
    bcache.head.next->prev = b;
    80002ea6:	2b893783          	ld	a5,696(s2)
    80002eaa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002eac:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002eb0:	45848493          	addi	s1,s1,1112
    80002eb4:	fd349fe3          	bne	s1,s3,80002e92 <binit+0x50>
  }
}
    80002eb8:	70a2                	ld	ra,40(sp)
    80002eba:	7402                	ld	s0,32(sp)
    80002ebc:	64e2                	ld	s1,24(sp)
    80002ebe:	6942                	ld	s2,16(sp)
    80002ec0:	69a2                	ld	s3,8(sp)
    80002ec2:	6a02                	ld	s4,0(sp)
    80002ec4:	6145                	addi	sp,sp,48
    80002ec6:	8082                	ret

0000000080002ec8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002ec8:	7179                	addi	sp,sp,-48
    80002eca:	f406                	sd	ra,40(sp)
    80002ecc:	f022                	sd	s0,32(sp)
    80002ece:	ec26                	sd	s1,24(sp)
    80002ed0:	e84a                	sd	s2,16(sp)
    80002ed2:	e44e                	sd	s3,8(sp)
    80002ed4:	1800                	addi	s0,sp,48
    80002ed6:	892a                	mv	s2,a0
    80002ed8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002eda:	00016517          	auipc	a0,0x16
    80002ede:	9a650513          	addi	a0,a0,-1626 # 80018880 <bcache>
    80002ee2:	d47fd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ee6:	0001e497          	auipc	s1,0x1e
    80002eea:	c524b483          	ld	s1,-942(s1) # 80020b38 <bcache+0x82b8>
    80002eee:	0001e797          	auipc	a5,0x1e
    80002ef2:	bfa78793          	addi	a5,a5,-1030 # 80020ae8 <bcache+0x8268>
    80002ef6:	02f48b63          	beq	s1,a5,80002f2c <bread+0x64>
    80002efa:	873e                	mv	a4,a5
    80002efc:	a021                	j	80002f04 <bread+0x3c>
    80002efe:	68a4                	ld	s1,80(s1)
    80002f00:	02e48663          	beq	s1,a4,80002f2c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002f04:	449c                	lw	a5,8(s1)
    80002f06:	ff279ce3          	bne	a5,s2,80002efe <bread+0x36>
    80002f0a:	44dc                	lw	a5,12(s1)
    80002f0c:	ff3799e3          	bne	a5,s3,80002efe <bread+0x36>
      b->refcnt++;
    80002f10:	40bc                	lw	a5,64(s1)
    80002f12:	2785                	addiw	a5,a5,1
    80002f14:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f16:	00016517          	auipc	a0,0x16
    80002f1a:	96a50513          	addi	a0,a0,-1686 # 80018880 <bcache>
    80002f1e:	d9ffd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002f22:	01048513          	addi	a0,s1,16
    80002f26:	2da010ef          	jal	80004200 <acquiresleep>
      return b;
    80002f2a:	a889                	j	80002f7c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f2c:	0001e497          	auipc	s1,0x1e
    80002f30:	c044b483          	ld	s1,-1020(s1) # 80020b30 <bcache+0x82b0>
    80002f34:	0001e797          	auipc	a5,0x1e
    80002f38:	bb478793          	addi	a5,a5,-1100 # 80020ae8 <bcache+0x8268>
    80002f3c:	00f48863          	beq	s1,a5,80002f4c <bread+0x84>
    80002f40:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f42:	40bc                	lw	a5,64(s1)
    80002f44:	cb91                	beqz	a5,80002f58 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f46:	64a4                	ld	s1,72(s1)
    80002f48:	fee49de3          	bne	s1,a4,80002f42 <bread+0x7a>
  panic("bget: no buffers");
    80002f4c:	00004517          	auipc	a0,0x4
    80002f50:	62450513          	addi	a0,a0,1572 # 80007570 <etext+0x570>
    80002f54:	8d1fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80002f58:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f5c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f60:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f64:	4785                	li	a5,1
    80002f66:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f68:	00016517          	auipc	a0,0x16
    80002f6c:	91850513          	addi	a0,a0,-1768 # 80018880 <bcache>
    80002f70:	d4dfd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    80002f74:	01048513          	addi	a0,s1,16
    80002f78:	288010ef          	jal	80004200 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f7c:	409c                	lw	a5,0(s1)
    80002f7e:	cb89                	beqz	a5,80002f90 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f80:	8526                	mv	a0,s1
    80002f82:	70a2                	ld	ra,40(sp)
    80002f84:	7402                	ld	s0,32(sp)
    80002f86:	64e2                	ld	s1,24(sp)
    80002f88:	6942                	ld	s2,16(sp)
    80002f8a:	69a2                	ld	s3,8(sp)
    80002f8c:	6145                	addi	sp,sp,48
    80002f8e:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f90:	4581                	li	a1,0
    80002f92:	8526                	mv	a0,s1
    80002f94:	2ed020ef          	jal	80005a80 <virtio_disk_rw>
    b->valid = 1;
    80002f98:	4785                	li	a5,1
    80002f9a:	c09c                	sw	a5,0(s1)
  return b;
    80002f9c:	b7d5                	j	80002f80 <bread+0xb8>

0000000080002f9e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002f9e:	1101                	addi	sp,sp,-32
    80002fa0:	ec06                	sd	ra,24(sp)
    80002fa2:	e822                	sd	s0,16(sp)
    80002fa4:	e426                	sd	s1,8(sp)
    80002fa6:	1000                	addi	s0,sp,32
    80002fa8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002faa:	0541                	addi	a0,a0,16
    80002fac:	2d2010ef          	jal	8000427e <holdingsleep>
    80002fb0:	c911                	beqz	a0,80002fc4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fb2:	4585                	li	a1,1
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	2cb020ef          	jal	80005a80 <virtio_disk_rw>
}
    80002fba:	60e2                	ld	ra,24(sp)
    80002fbc:	6442                	ld	s0,16(sp)
    80002fbe:	64a2                	ld	s1,8(sp)
    80002fc0:	6105                	addi	sp,sp,32
    80002fc2:	8082                	ret
    panic("bwrite");
    80002fc4:	00004517          	auipc	a0,0x4
    80002fc8:	5c450513          	addi	a0,a0,1476 # 80007588 <etext+0x588>
    80002fcc:	859fd0ef          	jal	80000824 <panic>

0000000080002fd0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002fd0:	1101                	addi	sp,sp,-32
    80002fd2:	ec06                	sd	ra,24(sp)
    80002fd4:	e822                	sd	s0,16(sp)
    80002fd6:	e426                	sd	s1,8(sp)
    80002fd8:	e04a                	sd	s2,0(sp)
    80002fda:	1000                	addi	s0,sp,32
    80002fdc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fde:	01050913          	addi	s2,a0,16
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	29a010ef          	jal	8000427e <holdingsleep>
    80002fe8:	c125                	beqz	a0,80003048 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002fea:	854a                	mv	a0,s2
    80002fec:	25a010ef          	jal	80004246 <releasesleep>

  acquire(&bcache.lock);
    80002ff0:	00016517          	auipc	a0,0x16
    80002ff4:	89050513          	addi	a0,a0,-1904 # 80018880 <bcache>
    80002ff8:	c31fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80002ffc:	40bc                	lw	a5,64(s1)
    80002ffe:	37fd                	addiw	a5,a5,-1
    80003000:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003002:	e79d                	bnez	a5,80003030 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003004:	68b8                	ld	a4,80(s1)
    80003006:	64bc                	ld	a5,72(s1)
    80003008:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000300a:	68b8                	ld	a4,80(s1)
    8000300c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000300e:	0001e797          	auipc	a5,0x1e
    80003012:	87278793          	addi	a5,a5,-1934 # 80020880 <bcache+0x8000>
    80003016:	2b87b703          	ld	a4,696(a5)
    8000301a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000301c:	0001e717          	auipc	a4,0x1e
    80003020:	acc70713          	addi	a4,a4,-1332 # 80020ae8 <bcache+0x8268>
    80003024:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003026:	2b87b703          	ld	a4,696(a5)
    8000302a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000302c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003030:	00016517          	auipc	a0,0x16
    80003034:	85050513          	addi	a0,a0,-1968 # 80018880 <bcache>
    80003038:	c85fd0ef          	jal	80000cbc <release>
}
    8000303c:	60e2                	ld	ra,24(sp)
    8000303e:	6442                	ld	s0,16(sp)
    80003040:	64a2                	ld	s1,8(sp)
    80003042:	6902                	ld	s2,0(sp)
    80003044:	6105                	addi	sp,sp,32
    80003046:	8082                	ret
    panic("brelse");
    80003048:	00004517          	auipc	a0,0x4
    8000304c:	54850513          	addi	a0,a0,1352 # 80007590 <etext+0x590>
    80003050:	fd4fd0ef          	jal	80000824 <panic>

0000000080003054 <bpin>:

void
bpin(struct buf *b) {
    80003054:	1101                	addi	sp,sp,-32
    80003056:	ec06                	sd	ra,24(sp)
    80003058:	e822                	sd	s0,16(sp)
    8000305a:	e426                	sd	s1,8(sp)
    8000305c:	1000                	addi	s0,sp,32
    8000305e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003060:	00016517          	auipc	a0,0x16
    80003064:	82050513          	addi	a0,a0,-2016 # 80018880 <bcache>
    80003068:	bc1fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    8000306c:	40bc                	lw	a5,64(s1)
    8000306e:	2785                	addiw	a5,a5,1
    80003070:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003072:	00016517          	auipc	a0,0x16
    80003076:	80e50513          	addi	a0,a0,-2034 # 80018880 <bcache>
    8000307a:	c43fd0ef          	jal	80000cbc <release>
}
    8000307e:	60e2                	ld	ra,24(sp)
    80003080:	6442                	ld	s0,16(sp)
    80003082:	64a2                	ld	s1,8(sp)
    80003084:	6105                	addi	sp,sp,32
    80003086:	8082                	ret

0000000080003088 <bunpin>:

void
bunpin(struct buf *b) {
    80003088:	1101                	addi	sp,sp,-32
    8000308a:	ec06                	sd	ra,24(sp)
    8000308c:	e822                	sd	s0,16(sp)
    8000308e:	e426                	sd	s1,8(sp)
    80003090:	1000                	addi	s0,sp,32
    80003092:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003094:	00015517          	auipc	a0,0x15
    80003098:	7ec50513          	addi	a0,a0,2028 # 80018880 <bcache>
    8000309c:	b8dfd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    800030a0:	40bc                	lw	a5,64(s1)
    800030a2:	37fd                	addiw	a5,a5,-1
    800030a4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030a6:	00015517          	auipc	a0,0x15
    800030aa:	7da50513          	addi	a0,a0,2010 # 80018880 <bcache>
    800030ae:	c0ffd0ef          	jal	80000cbc <release>
}
    800030b2:	60e2                	ld	ra,24(sp)
    800030b4:	6442                	ld	s0,16(sp)
    800030b6:	64a2                	ld	s1,8(sp)
    800030b8:	6105                	addi	sp,sp,32
    800030ba:	8082                	ret

00000000800030bc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800030bc:	1101                	addi	sp,sp,-32
    800030be:	ec06                	sd	ra,24(sp)
    800030c0:	e822                	sd	s0,16(sp)
    800030c2:	e426                	sd	s1,8(sp)
    800030c4:	e04a                	sd	s2,0(sp)
    800030c6:	1000                	addi	s0,sp,32
    800030c8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800030ca:	00d5d79b          	srliw	a5,a1,0xd
    800030ce:	0001e597          	auipc	a1,0x1e
    800030d2:	e8e5a583          	lw	a1,-370(a1) # 80020f5c <sb+0x1c>
    800030d6:	9dbd                	addw	a1,a1,a5
    800030d8:	df1ff0ef          	jal	80002ec8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800030dc:	0074f713          	andi	a4,s1,7
    800030e0:	4785                	li	a5,1
    800030e2:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800030e6:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800030e8:	90d9                	srli	s1,s1,0x36
    800030ea:	00950733          	add	a4,a0,s1
    800030ee:	05874703          	lbu	a4,88(a4)
    800030f2:	00e7f6b3          	and	a3,a5,a4
    800030f6:	c29d                	beqz	a3,8000311c <bfree+0x60>
    800030f8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800030fa:	94aa                	add	s1,s1,a0
    800030fc:	fff7c793          	not	a5,a5
    80003100:	8f7d                	and	a4,a4,a5
    80003102:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003106:	000010ef          	jal	80004106 <log_write>
  brelse(bp);
    8000310a:	854a                	mv	a0,s2
    8000310c:	ec5ff0ef          	jal	80002fd0 <brelse>
}
    80003110:	60e2                	ld	ra,24(sp)
    80003112:	6442                	ld	s0,16(sp)
    80003114:	64a2                	ld	s1,8(sp)
    80003116:	6902                	ld	s2,0(sp)
    80003118:	6105                	addi	sp,sp,32
    8000311a:	8082                	ret
    panic("freeing free block");
    8000311c:	00004517          	auipc	a0,0x4
    80003120:	47c50513          	addi	a0,a0,1148 # 80007598 <etext+0x598>
    80003124:	f00fd0ef          	jal	80000824 <panic>

0000000080003128 <balloc>:
{
    80003128:	715d                	addi	sp,sp,-80
    8000312a:	e486                	sd	ra,72(sp)
    8000312c:	e0a2                	sd	s0,64(sp)
    8000312e:	fc26                	sd	s1,56(sp)
    80003130:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003132:	0001e797          	auipc	a5,0x1e
    80003136:	e127a783          	lw	a5,-494(a5) # 80020f44 <sb+0x4>
    8000313a:	0e078263          	beqz	a5,8000321e <balloc+0xf6>
    8000313e:	f84a                	sd	s2,48(sp)
    80003140:	f44e                	sd	s3,40(sp)
    80003142:	f052                	sd	s4,32(sp)
    80003144:	ec56                	sd	s5,24(sp)
    80003146:	e85a                	sd	s6,16(sp)
    80003148:	e45e                	sd	s7,8(sp)
    8000314a:	e062                	sd	s8,0(sp)
    8000314c:	8baa                	mv	s7,a0
    8000314e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003150:	0001eb17          	auipc	s6,0x1e
    80003154:	df0b0b13          	addi	s6,s6,-528 # 80020f40 <sb>
      m = 1 << (bi % 8);
    80003158:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000315a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000315c:	6c09                	lui	s8,0x2
    8000315e:	a09d                	j	800031c4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003160:	97ca                	add	a5,a5,s2
    80003162:	8e55                	or	a2,a2,a3
    80003164:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003168:	854a                	mv	a0,s2
    8000316a:	79d000ef          	jal	80004106 <log_write>
        brelse(bp);
    8000316e:	854a                	mv	a0,s2
    80003170:	e61ff0ef          	jal	80002fd0 <brelse>
  bp = bread(dev, bno);
    80003174:	85a6                	mv	a1,s1
    80003176:	855e                	mv	a0,s7
    80003178:	d51ff0ef          	jal	80002ec8 <bread>
    8000317c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000317e:	40000613          	li	a2,1024
    80003182:	4581                	li	a1,0
    80003184:	05850513          	addi	a0,a0,88
    80003188:	b71fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    8000318c:	854a                	mv	a0,s2
    8000318e:	779000ef          	jal	80004106 <log_write>
  brelse(bp);
    80003192:	854a                	mv	a0,s2
    80003194:	e3dff0ef          	jal	80002fd0 <brelse>
}
    80003198:	7942                	ld	s2,48(sp)
    8000319a:	79a2                	ld	s3,40(sp)
    8000319c:	7a02                	ld	s4,32(sp)
    8000319e:	6ae2                	ld	s5,24(sp)
    800031a0:	6b42                	ld	s6,16(sp)
    800031a2:	6ba2                	ld	s7,8(sp)
    800031a4:	6c02                	ld	s8,0(sp)
}
    800031a6:	8526                	mv	a0,s1
    800031a8:	60a6                	ld	ra,72(sp)
    800031aa:	6406                	ld	s0,64(sp)
    800031ac:	74e2                	ld	s1,56(sp)
    800031ae:	6161                	addi	sp,sp,80
    800031b0:	8082                	ret
    brelse(bp);
    800031b2:	854a                	mv	a0,s2
    800031b4:	e1dff0ef          	jal	80002fd0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031b8:	015c0abb          	addw	s5,s8,s5
    800031bc:	004b2783          	lw	a5,4(s6)
    800031c0:	04faf863          	bgeu	s5,a5,80003210 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800031c4:	40dad59b          	sraiw	a1,s5,0xd
    800031c8:	01cb2783          	lw	a5,28(s6)
    800031cc:	9dbd                	addw	a1,a1,a5
    800031ce:	855e                	mv	a0,s7
    800031d0:	cf9ff0ef          	jal	80002ec8 <bread>
    800031d4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031d6:	004b2503          	lw	a0,4(s6)
    800031da:	84d6                	mv	s1,s5
    800031dc:	4701                	li	a4,0
    800031de:	fca4fae3          	bgeu	s1,a0,800031b2 <balloc+0x8a>
      m = 1 << (bi % 8);
    800031e2:	00777693          	andi	a3,a4,7
    800031e6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800031ea:	41f7579b          	sraiw	a5,a4,0x1f
    800031ee:	01d7d79b          	srliw	a5,a5,0x1d
    800031f2:	9fb9                	addw	a5,a5,a4
    800031f4:	4037d79b          	sraiw	a5,a5,0x3
    800031f8:	00f90633          	add	a2,s2,a5
    800031fc:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003200:	00c6f5b3          	and	a1,a3,a2
    80003204:	ddb1                	beqz	a1,80003160 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003206:	2705                	addiw	a4,a4,1
    80003208:	2485                	addiw	s1,s1,1
    8000320a:	fd471ae3          	bne	a4,s4,800031de <balloc+0xb6>
    8000320e:	b755                	j	800031b2 <balloc+0x8a>
    80003210:	7942                	ld	s2,48(sp)
    80003212:	79a2                	ld	s3,40(sp)
    80003214:	7a02                	ld	s4,32(sp)
    80003216:	6ae2                	ld	s5,24(sp)
    80003218:	6b42                	ld	s6,16(sp)
    8000321a:	6ba2                	ld	s7,8(sp)
    8000321c:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000321e:	00004517          	auipc	a0,0x4
    80003222:	39250513          	addi	a0,a0,914 # 800075b0 <etext+0x5b0>
    80003226:	ad4fd0ef          	jal	800004fa <printf>
  return 0;
    8000322a:	4481                	li	s1,0
    8000322c:	bfad                	j	800031a6 <balloc+0x7e>

000000008000322e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000322e:	7179                	addi	sp,sp,-48
    80003230:	f406                	sd	ra,40(sp)
    80003232:	f022                	sd	s0,32(sp)
    80003234:	ec26                	sd	s1,24(sp)
    80003236:	e84a                	sd	s2,16(sp)
    80003238:	e44e                	sd	s3,8(sp)
    8000323a:	1800                	addi	s0,sp,48
    8000323c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000323e:	47ad                	li	a5,11
    80003240:	02b7e363          	bltu	a5,a1,80003266 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003244:	02059793          	slli	a5,a1,0x20
    80003248:	01e7d593          	srli	a1,a5,0x1e
    8000324c:	00b509b3          	add	s3,a0,a1
    80003250:	0509a483          	lw	s1,80(s3)
    80003254:	e0b5                	bnez	s1,800032b8 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003256:	4108                	lw	a0,0(a0)
    80003258:	ed1ff0ef          	jal	80003128 <balloc>
    8000325c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000325e:	cd29                	beqz	a0,800032b8 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003260:	04a9a823          	sw	a0,80(s3)
    80003264:	a891                	j	800032b8 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003266:	ff45879b          	addiw	a5,a1,-12
    8000326a:	873e                	mv	a4,a5
    8000326c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000326e:	0ff00793          	li	a5,255
    80003272:	06e7e763          	bltu	a5,a4,800032e0 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003276:	08052483          	lw	s1,128(a0)
    8000327a:	e891                	bnez	s1,8000328e <bmap+0x60>
      addr = balloc(ip->dev);
    8000327c:	4108                	lw	a0,0(a0)
    8000327e:	eabff0ef          	jal	80003128 <balloc>
    80003282:	84aa                	mv	s1,a0
      if(addr == 0)
    80003284:	c915                	beqz	a0,800032b8 <bmap+0x8a>
    80003286:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003288:	08a92023          	sw	a0,128(s2)
    8000328c:	a011                	j	80003290 <bmap+0x62>
    8000328e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003290:	85a6                	mv	a1,s1
    80003292:	00092503          	lw	a0,0(s2)
    80003296:	c33ff0ef          	jal	80002ec8 <bread>
    8000329a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000329c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800032a0:	02099713          	slli	a4,s3,0x20
    800032a4:	01e75593          	srli	a1,a4,0x1e
    800032a8:	97ae                	add	a5,a5,a1
    800032aa:	89be                	mv	s3,a5
    800032ac:	4384                	lw	s1,0(a5)
    800032ae:	cc89                	beqz	s1,800032c8 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800032b0:	8552                	mv	a0,s4
    800032b2:	d1fff0ef          	jal	80002fd0 <brelse>
    return addr;
    800032b6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800032b8:	8526                	mv	a0,s1
    800032ba:	70a2                	ld	ra,40(sp)
    800032bc:	7402                	ld	s0,32(sp)
    800032be:	64e2                	ld	s1,24(sp)
    800032c0:	6942                	ld	s2,16(sp)
    800032c2:	69a2                	ld	s3,8(sp)
    800032c4:	6145                	addi	sp,sp,48
    800032c6:	8082                	ret
      addr = balloc(ip->dev);
    800032c8:	00092503          	lw	a0,0(s2)
    800032cc:	e5dff0ef          	jal	80003128 <balloc>
    800032d0:	84aa                	mv	s1,a0
      if(addr){
    800032d2:	dd79                	beqz	a0,800032b0 <bmap+0x82>
        a[bn] = addr;
    800032d4:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800032d8:	8552                	mv	a0,s4
    800032da:	62d000ef          	jal	80004106 <log_write>
    800032de:	bfc9                	j	800032b0 <bmap+0x82>
    800032e0:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800032e2:	00004517          	auipc	a0,0x4
    800032e6:	2e650513          	addi	a0,a0,742 # 800075c8 <etext+0x5c8>
    800032ea:	d3afd0ef          	jal	80000824 <panic>

00000000800032ee <iget>:
{
    800032ee:	7179                	addi	sp,sp,-48
    800032f0:	f406                	sd	ra,40(sp)
    800032f2:	f022                	sd	s0,32(sp)
    800032f4:	ec26                	sd	s1,24(sp)
    800032f6:	e84a                	sd	s2,16(sp)
    800032f8:	e44e                	sd	s3,8(sp)
    800032fa:	e052                	sd	s4,0(sp)
    800032fc:	1800                	addi	s0,sp,48
    800032fe:	892a                	mv	s2,a0
    80003300:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003302:	0001e517          	auipc	a0,0x1e
    80003306:	c5e50513          	addi	a0,a0,-930 # 80020f60 <itable>
    8000330a:	91ffd0ef          	jal	80000c28 <acquire>
  empty = 0;
    8000330e:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003310:	0001e497          	auipc	s1,0x1e
    80003314:	c6848493          	addi	s1,s1,-920 # 80020f78 <itable+0x18>
    80003318:	0001f697          	auipc	a3,0x1f
    8000331c:	6f068693          	addi	a3,a3,1776 # 80022a08 <log>
    80003320:	a809                	j	80003332 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003322:	e781                	bnez	a5,8000332a <iget+0x3c>
    80003324:	00099363          	bnez	s3,8000332a <iget+0x3c>
      empty = ip;
    80003328:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000332a:	08848493          	addi	s1,s1,136
    8000332e:	02d48563          	beq	s1,a3,80003358 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003332:	449c                	lw	a5,8(s1)
    80003334:	fef057e3          	blez	a5,80003322 <iget+0x34>
    80003338:	4098                	lw	a4,0(s1)
    8000333a:	ff2718e3          	bne	a4,s2,8000332a <iget+0x3c>
    8000333e:	40d8                	lw	a4,4(s1)
    80003340:	ff4715e3          	bne	a4,s4,8000332a <iget+0x3c>
      ip->ref++;
    80003344:	2785                	addiw	a5,a5,1
    80003346:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003348:	0001e517          	auipc	a0,0x1e
    8000334c:	c1850513          	addi	a0,a0,-1000 # 80020f60 <itable>
    80003350:	96dfd0ef          	jal	80000cbc <release>
      return ip;
    80003354:	89a6                	mv	s3,s1
    80003356:	a015                	j	8000337a <iget+0x8c>
  if(empty == 0)
    80003358:	02098a63          	beqz	s3,8000338c <iget+0x9e>
  ip->dev = dev;
    8000335c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003360:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003364:	4785                	li	a5,1
    80003366:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000336a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000336e:	0001e517          	auipc	a0,0x1e
    80003372:	bf250513          	addi	a0,a0,-1038 # 80020f60 <itable>
    80003376:	947fd0ef          	jal	80000cbc <release>
}
    8000337a:	854e                	mv	a0,s3
    8000337c:	70a2                	ld	ra,40(sp)
    8000337e:	7402                	ld	s0,32(sp)
    80003380:	64e2                	ld	s1,24(sp)
    80003382:	6942                	ld	s2,16(sp)
    80003384:	69a2                	ld	s3,8(sp)
    80003386:	6a02                	ld	s4,0(sp)
    80003388:	6145                	addi	sp,sp,48
    8000338a:	8082                	ret
    panic("iget: no inodes");
    8000338c:	00004517          	auipc	a0,0x4
    80003390:	25450513          	addi	a0,a0,596 # 800075e0 <etext+0x5e0>
    80003394:	c90fd0ef          	jal	80000824 <panic>

0000000080003398 <iinit>:
{
    80003398:	7179                	addi	sp,sp,-48
    8000339a:	f406                	sd	ra,40(sp)
    8000339c:	f022                	sd	s0,32(sp)
    8000339e:	ec26                	sd	s1,24(sp)
    800033a0:	e84a                	sd	s2,16(sp)
    800033a2:	e44e                	sd	s3,8(sp)
    800033a4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800033a6:	00004597          	auipc	a1,0x4
    800033aa:	24a58593          	addi	a1,a1,586 # 800075f0 <etext+0x5f0>
    800033ae:	0001e517          	auipc	a0,0x1e
    800033b2:	bb250513          	addi	a0,a0,-1102 # 80020f60 <itable>
    800033b6:	fe8fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    800033ba:	0001e497          	auipc	s1,0x1e
    800033be:	bce48493          	addi	s1,s1,-1074 # 80020f88 <itable+0x28>
    800033c2:	0001f997          	auipc	s3,0x1f
    800033c6:	65698993          	addi	s3,s3,1622 # 80022a18 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800033ca:	00004917          	auipc	s2,0x4
    800033ce:	22e90913          	addi	s2,s2,558 # 800075f8 <etext+0x5f8>
    800033d2:	85ca                	mv	a1,s2
    800033d4:	8526                	mv	a0,s1
    800033d6:	5f5000ef          	jal	800041ca <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800033da:	08848493          	addi	s1,s1,136
    800033de:	ff349ae3          	bne	s1,s3,800033d2 <iinit+0x3a>
}
    800033e2:	70a2                	ld	ra,40(sp)
    800033e4:	7402                	ld	s0,32(sp)
    800033e6:	64e2                	ld	s1,24(sp)
    800033e8:	6942                	ld	s2,16(sp)
    800033ea:	69a2                	ld	s3,8(sp)
    800033ec:	6145                	addi	sp,sp,48
    800033ee:	8082                	ret

00000000800033f0 <ialloc>:
{
    800033f0:	7139                	addi	sp,sp,-64
    800033f2:	fc06                	sd	ra,56(sp)
    800033f4:	f822                	sd	s0,48(sp)
    800033f6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800033f8:	0001e717          	auipc	a4,0x1e
    800033fc:	b5472703          	lw	a4,-1196(a4) # 80020f4c <sb+0xc>
    80003400:	4785                	li	a5,1
    80003402:	06e7f063          	bgeu	a5,a4,80003462 <ialloc+0x72>
    80003406:	f426                	sd	s1,40(sp)
    80003408:	f04a                	sd	s2,32(sp)
    8000340a:	ec4e                	sd	s3,24(sp)
    8000340c:	e852                	sd	s4,16(sp)
    8000340e:	e456                	sd	s5,8(sp)
    80003410:	e05a                	sd	s6,0(sp)
    80003412:	8aaa                	mv	s5,a0
    80003414:	8b2e                	mv	s6,a1
    80003416:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003418:	0001ea17          	auipc	s4,0x1e
    8000341c:	b28a0a13          	addi	s4,s4,-1240 # 80020f40 <sb>
    80003420:	00495593          	srli	a1,s2,0x4
    80003424:	018a2783          	lw	a5,24(s4)
    80003428:	9dbd                	addw	a1,a1,a5
    8000342a:	8556                	mv	a0,s5
    8000342c:	a9dff0ef          	jal	80002ec8 <bread>
    80003430:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003432:	05850993          	addi	s3,a0,88
    80003436:	00f97793          	andi	a5,s2,15
    8000343a:	079a                	slli	a5,a5,0x6
    8000343c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000343e:	00099783          	lh	a5,0(s3)
    80003442:	cb9d                	beqz	a5,80003478 <ialloc+0x88>
    brelse(bp);
    80003444:	b8dff0ef          	jal	80002fd0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003448:	0905                	addi	s2,s2,1
    8000344a:	00ca2703          	lw	a4,12(s4)
    8000344e:	0009079b          	sext.w	a5,s2
    80003452:	fce7e7e3          	bltu	a5,a4,80003420 <ialloc+0x30>
    80003456:	74a2                	ld	s1,40(sp)
    80003458:	7902                	ld	s2,32(sp)
    8000345a:	69e2                	ld	s3,24(sp)
    8000345c:	6a42                	ld	s4,16(sp)
    8000345e:	6aa2                	ld	s5,8(sp)
    80003460:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003462:	00004517          	auipc	a0,0x4
    80003466:	19e50513          	addi	a0,a0,414 # 80007600 <etext+0x600>
    8000346a:	890fd0ef          	jal	800004fa <printf>
  return 0;
    8000346e:	4501                	li	a0,0
}
    80003470:	70e2                	ld	ra,56(sp)
    80003472:	7442                	ld	s0,48(sp)
    80003474:	6121                	addi	sp,sp,64
    80003476:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003478:	04000613          	li	a2,64
    8000347c:	4581                	li	a1,0
    8000347e:	854e                	mv	a0,s3
    80003480:	879fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003484:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003488:	8526                	mv	a0,s1
    8000348a:	47d000ef          	jal	80004106 <log_write>
      brelse(bp);
    8000348e:	8526                	mv	a0,s1
    80003490:	b41ff0ef          	jal	80002fd0 <brelse>
      return iget(dev, inum);
    80003494:	0009059b          	sext.w	a1,s2
    80003498:	8556                	mv	a0,s5
    8000349a:	e55ff0ef          	jal	800032ee <iget>
    8000349e:	74a2                	ld	s1,40(sp)
    800034a0:	7902                	ld	s2,32(sp)
    800034a2:	69e2                	ld	s3,24(sp)
    800034a4:	6a42                	ld	s4,16(sp)
    800034a6:	6aa2                	ld	s5,8(sp)
    800034a8:	6b02                	ld	s6,0(sp)
    800034aa:	b7d9                	j	80003470 <ialloc+0x80>

00000000800034ac <iupdate>:
{
    800034ac:	1101                	addi	sp,sp,-32
    800034ae:	ec06                	sd	ra,24(sp)
    800034b0:	e822                	sd	s0,16(sp)
    800034b2:	e426                	sd	s1,8(sp)
    800034b4:	e04a                	sd	s2,0(sp)
    800034b6:	1000                	addi	s0,sp,32
    800034b8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800034ba:	415c                	lw	a5,4(a0)
    800034bc:	0047d79b          	srliw	a5,a5,0x4
    800034c0:	0001e597          	auipc	a1,0x1e
    800034c4:	a985a583          	lw	a1,-1384(a1) # 80020f58 <sb+0x18>
    800034c8:	9dbd                	addw	a1,a1,a5
    800034ca:	4108                	lw	a0,0(a0)
    800034cc:	9fdff0ef          	jal	80002ec8 <bread>
    800034d0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800034d2:	05850793          	addi	a5,a0,88
    800034d6:	40d8                	lw	a4,4(s1)
    800034d8:	8b3d                	andi	a4,a4,15
    800034da:	071a                	slli	a4,a4,0x6
    800034dc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800034de:	04449703          	lh	a4,68(s1)
    800034e2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800034e6:	04649703          	lh	a4,70(s1)
    800034ea:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800034ee:	04849703          	lh	a4,72(s1)
    800034f2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800034f6:	04a49703          	lh	a4,74(s1)
    800034fa:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800034fe:	44f8                	lw	a4,76(s1)
    80003500:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003502:	03400613          	li	a2,52
    80003506:	05048593          	addi	a1,s1,80
    8000350a:	00c78513          	addi	a0,a5,12
    8000350e:	84bfd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003512:	854a                	mv	a0,s2
    80003514:	3f3000ef          	jal	80004106 <log_write>
  brelse(bp);
    80003518:	854a                	mv	a0,s2
    8000351a:	ab7ff0ef          	jal	80002fd0 <brelse>
}
    8000351e:	60e2                	ld	ra,24(sp)
    80003520:	6442                	ld	s0,16(sp)
    80003522:	64a2                	ld	s1,8(sp)
    80003524:	6902                	ld	s2,0(sp)
    80003526:	6105                	addi	sp,sp,32
    80003528:	8082                	ret

000000008000352a <idup>:
{
    8000352a:	1101                	addi	sp,sp,-32
    8000352c:	ec06                	sd	ra,24(sp)
    8000352e:	e822                	sd	s0,16(sp)
    80003530:	e426                	sd	s1,8(sp)
    80003532:	1000                	addi	s0,sp,32
    80003534:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003536:	0001e517          	auipc	a0,0x1e
    8000353a:	a2a50513          	addi	a0,a0,-1494 # 80020f60 <itable>
    8000353e:	eeafd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003542:	449c                	lw	a5,8(s1)
    80003544:	2785                	addiw	a5,a5,1
    80003546:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003548:	0001e517          	auipc	a0,0x1e
    8000354c:	a1850513          	addi	a0,a0,-1512 # 80020f60 <itable>
    80003550:	f6cfd0ef          	jal	80000cbc <release>
}
    80003554:	8526                	mv	a0,s1
    80003556:	60e2                	ld	ra,24(sp)
    80003558:	6442                	ld	s0,16(sp)
    8000355a:	64a2                	ld	s1,8(sp)
    8000355c:	6105                	addi	sp,sp,32
    8000355e:	8082                	ret

0000000080003560 <ilock>:
{
    80003560:	1101                	addi	sp,sp,-32
    80003562:	ec06                	sd	ra,24(sp)
    80003564:	e822                	sd	s0,16(sp)
    80003566:	e426                	sd	s1,8(sp)
    80003568:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000356a:	cd19                	beqz	a0,80003588 <ilock+0x28>
    8000356c:	84aa                	mv	s1,a0
    8000356e:	451c                	lw	a5,8(a0)
    80003570:	00f05c63          	blez	a5,80003588 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003574:	0541                	addi	a0,a0,16
    80003576:	48b000ef          	jal	80004200 <acquiresleep>
  if(ip->valid == 0){
    8000357a:	40bc                	lw	a5,64(s1)
    8000357c:	cf89                	beqz	a5,80003596 <ilock+0x36>
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	64a2                	ld	s1,8(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret
    80003588:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000358a:	00004517          	auipc	a0,0x4
    8000358e:	08e50513          	addi	a0,a0,142 # 80007618 <etext+0x618>
    80003592:	a92fd0ef          	jal	80000824 <panic>
    80003596:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003598:	40dc                	lw	a5,4(s1)
    8000359a:	0047d79b          	srliw	a5,a5,0x4
    8000359e:	0001e597          	auipc	a1,0x1e
    800035a2:	9ba5a583          	lw	a1,-1606(a1) # 80020f58 <sb+0x18>
    800035a6:	9dbd                	addw	a1,a1,a5
    800035a8:	4088                	lw	a0,0(s1)
    800035aa:	91fff0ef          	jal	80002ec8 <bread>
    800035ae:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800035b0:	05850593          	addi	a1,a0,88
    800035b4:	40dc                	lw	a5,4(s1)
    800035b6:	8bbd                	andi	a5,a5,15
    800035b8:	079a                	slli	a5,a5,0x6
    800035ba:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800035bc:	00059783          	lh	a5,0(a1)
    800035c0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800035c4:	00259783          	lh	a5,2(a1)
    800035c8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800035cc:	00459783          	lh	a5,4(a1)
    800035d0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800035d4:	00659783          	lh	a5,6(a1)
    800035d8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800035dc:	459c                	lw	a5,8(a1)
    800035de:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800035e0:	03400613          	li	a2,52
    800035e4:	05b1                	addi	a1,a1,12
    800035e6:	05048513          	addi	a0,s1,80
    800035ea:	f6efd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    800035ee:	854a                	mv	a0,s2
    800035f0:	9e1ff0ef          	jal	80002fd0 <brelse>
    ip->valid = 1;
    800035f4:	4785                	li	a5,1
    800035f6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800035f8:	04449783          	lh	a5,68(s1)
    800035fc:	c399                	beqz	a5,80003602 <ilock+0xa2>
    800035fe:	6902                	ld	s2,0(sp)
    80003600:	bfbd                	j	8000357e <ilock+0x1e>
      panic("ilock: no type");
    80003602:	00004517          	auipc	a0,0x4
    80003606:	01e50513          	addi	a0,a0,30 # 80007620 <etext+0x620>
    8000360a:	a1afd0ef          	jal	80000824 <panic>

000000008000360e <iunlock>:
{
    8000360e:	1101                	addi	sp,sp,-32
    80003610:	ec06                	sd	ra,24(sp)
    80003612:	e822                	sd	s0,16(sp)
    80003614:	e426                	sd	s1,8(sp)
    80003616:	e04a                	sd	s2,0(sp)
    80003618:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000361a:	c505                	beqz	a0,80003642 <iunlock+0x34>
    8000361c:	84aa                	mv	s1,a0
    8000361e:	01050913          	addi	s2,a0,16
    80003622:	854a                	mv	a0,s2
    80003624:	45b000ef          	jal	8000427e <holdingsleep>
    80003628:	cd09                	beqz	a0,80003642 <iunlock+0x34>
    8000362a:	449c                	lw	a5,8(s1)
    8000362c:	00f05b63          	blez	a5,80003642 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003630:	854a                	mv	a0,s2
    80003632:	415000ef          	jal	80004246 <releasesleep>
}
    80003636:	60e2                	ld	ra,24(sp)
    80003638:	6442                	ld	s0,16(sp)
    8000363a:	64a2                	ld	s1,8(sp)
    8000363c:	6902                	ld	s2,0(sp)
    8000363e:	6105                	addi	sp,sp,32
    80003640:	8082                	ret
    panic("iunlock");
    80003642:	00004517          	auipc	a0,0x4
    80003646:	fee50513          	addi	a0,a0,-18 # 80007630 <etext+0x630>
    8000364a:	9dafd0ef          	jal	80000824 <panic>

000000008000364e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000364e:	7179                	addi	sp,sp,-48
    80003650:	f406                	sd	ra,40(sp)
    80003652:	f022                	sd	s0,32(sp)
    80003654:	ec26                	sd	s1,24(sp)
    80003656:	e84a                	sd	s2,16(sp)
    80003658:	e44e                	sd	s3,8(sp)
    8000365a:	1800                	addi	s0,sp,48
    8000365c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000365e:	05050493          	addi	s1,a0,80
    80003662:	08050913          	addi	s2,a0,128
    80003666:	a021                	j	8000366e <itrunc+0x20>
    80003668:	0491                	addi	s1,s1,4
    8000366a:	01248b63          	beq	s1,s2,80003680 <itrunc+0x32>
    if(ip->addrs[i]){
    8000366e:	408c                	lw	a1,0(s1)
    80003670:	dde5                	beqz	a1,80003668 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003672:	0009a503          	lw	a0,0(s3)
    80003676:	a47ff0ef          	jal	800030bc <bfree>
      ip->addrs[i] = 0;
    8000367a:	0004a023          	sw	zero,0(s1)
    8000367e:	b7ed                	j	80003668 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003680:	0809a583          	lw	a1,128(s3)
    80003684:	ed89                	bnez	a1,8000369e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003686:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000368a:	854e                	mv	a0,s3
    8000368c:	e21ff0ef          	jal	800034ac <iupdate>
}
    80003690:	70a2                	ld	ra,40(sp)
    80003692:	7402                	ld	s0,32(sp)
    80003694:	64e2                	ld	s1,24(sp)
    80003696:	6942                	ld	s2,16(sp)
    80003698:	69a2                	ld	s3,8(sp)
    8000369a:	6145                	addi	sp,sp,48
    8000369c:	8082                	ret
    8000369e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800036a0:	0009a503          	lw	a0,0(s3)
    800036a4:	825ff0ef          	jal	80002ec8 <bread>
    800036a8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800036aa:	05850493          	addi	s1,a0,88
    800036ae:	45850913          	addi	s2,a0,1112
    800036b2:	a021                	j	800036ba <itrunc+0x6c>
    800036b4:	0491                	addi	s1,s1,4
    800036b6:	01248963          	beq	s1,s2,800036c8 <itrunc+0x7a>
      if(a[j])
    800036ba:	408c                	lw	a1,0(s1)
    800036bc:	dde5                	beqz	a1,800036b4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800036be:	0009a503          	lw	a0,0(s3)
    800036c2:	9fbff0ef          	jal	800030bc <bfree>
    800036c6:	b7fd                	j	800036b4 <itrunc+0x66>
    brelse(bp);
    800036c8:	8552                	mv	a0,s4
    800036ca:	907ff0ef          	jal	80002fd0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800036ce:	0809a583          	lw	a1,128(s3)
    800036d2:	0009a503          	lw	a0,0(s3)
    800036d6:	9e7ff0ef          	jal	800030bc <bfree>
    ip->addrs[NDIRECT] = 0;
    800036da:	0809a023          	sw	zero,128(s3)
    800036de:	6a02                	ld	s4,0(sp)
    800036e0:	b75d                	j	80003686 <itrunc+0x38>

00000000800036e2 <iput>:
{
    800036e2:	1101                	addi	sp,sp,-32
    800036e4:	ec06                	sd	ra,24(sp)
    800036e6:	e822                	sd	s0,16(sp)
    800036e8:	e426                	sd	s1,8(sp)
    800036ea:	1000                	addi	s0,sp,32
    800036ec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036ee:	0001e517          	auipc	a0,0x1e
    800036f2:	87250513          	addi	a0,a0,-1934 # 80020f60 <itable>
    800036f6:	d32fd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800036fa:	4498                	lw	a4,8(s1)
    800036fc:	4785                	li	a5,1
    800036fe:	02f70063          	beq	a4,a5,8000371e <iput+0x3c>
  ip->ref--;
    80003702:	449c                	lw	a5,8(s1)
    80003704:	37fd                	addiw	a5,a5,-1
    80003706:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003708:	0001e517          	auipc	a0,0x1e
    8000370c:	85850513          	addi	a0,a0,-1960 # 80020f60 <itable>
    80003710:	dacfd0ef          	jal	80000cbc <release>
}
    80003714:	60e2                	ld	ra,24(sp)
    80003716:	6442                	ld	s0,16(sp)
    80003718:	64a2                	ld	s1,8(sp)
    8000371a:	6105                	addi	sp,sp,32
    8000371c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000371e:	40bc                	lw	a5,64(s1)
    80003720:	d3ed                	beqz	a5,80003702 <iput+0x20>
    80003722:	04a49783          	lh	a5,74(s1)
    80003726:	fff1                	bnez	a5,80003702 <iput+0x20>
    80003728:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000372a:	01048793          	addi	a5,s1,16
    8000372e:	893e                	mv	s2,a5
    80003730:	853e                	mv	a0,a5
    80003732:	2cf000ef          	jal	80004200 <acquiresleep>
    release(&itable.lock);
    80003736:	0001e517          	auipc	a0,0x1e
    8000373a:	82a50513          	addi	a0,a0,-2006 # 80020f60 <itable>
    8000373e:	d7efd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003742:	8526                	mv	a0,s1
    80003744:	f0bff0ef          	jal	8000364e <itrunc>
    ip->type = 0;
    80003748:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000374c:	8526                	mv	a0,s1
    8000374e:	d5fff0ef          	jal	800034ac <iupdate>
    ip->valid = 0;
    80003752:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003756:	854a                	mv	a0,s2
    80003758:	2ef000ef          	jal	80004246 <releasesleep>
    acquire(&itable.lock);
    8000375c:	0001e517          	auipc	a0,0x1e
    80003760:	80450513          	addi	a0,a0,-2044 # 80020f60 <itable>
    80003764:	cc4fd0ef          	jal	80000c28 <acquire>
    80003768:	6902                	ld	s2,0(sp)
    8000376a:	bf61                	j	80003702 <iput+0x20>

000000008000376c <iunlockput>:
{
    8000376c:	1101                	addi	sp,sp,-32
    8000376e:	ec06                	sd	ra,24(sp)
    80003770:	e822                	sd	s0,16(sp)
    80003772:	e426                	sd	s1,8(sp)
    80003774:	1000                	addi	s0,sp,32
    80003776:	84aa                	mv	s1,a0
  iunlock(ip);
    80003778:	e97ff0ef          	jal	8000360e <iunlock>
  iput(ip);
    8000377c:	8526                	mv	a0,s1
    8000377e:	f65ff0ef          	jal	800036e2 <iput>
}
    80003782:	60e2                	ld	ra,24(sp)
    80003784:	6442                	ld	s0,16(sp)
    80003786:	64a2                	ld	s1,8(sp)
    80003788:	6105                	addi	sp,sp,32
    8000378a:	8082                	ret

000000008000378c <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000378c:	0001d717          	auipc	a4,0x1d
    80003790:	7c072703          	lw	a4,1984(a4) # 80020f4c <sb+0xc>
    80003794:	4785                	li	a5,1
    80003796:	0ae7fe63          	bgeu	a5,a4,80003852 <ireclaim+0xc6>
{
    8000379a:	7139                	addi	sp,sp,-64
    8000379c:	fc06                	sd	ra,56(sp)
    8000379e:	f822                	sd	s0,48(sp)
    800037a0:	f426                	sd	s1,40(sp)
    800037a2:	f04a                	sd	s2,32(sp)
    800037a4:	ec4e                	sd	s3,24(sp)
    800037a6:	e852                	sd	s4,16(sp)
    800037a8:	e456                	sd	s5,8(sp)
    800037aa:	e05a                	sd	s6,0(sp)
    800037ac:	0080                	addi	s0,sp,64
    800037ae:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800037b0:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800037b2:	0001da17          	auipc	s4,0x1d
    800037b6:	78ea0a13          	addi	s4,s4,1934 # 80020f40 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800037ba:	00004b17          	auipc	s6,0x4
    800037be:	e7eb0b13          	addi	s6,s6,-386 # 80007638 <etext+0x638>
    800037c2:	a099                	j	80003808 <ireclaim+0x7c>
    800037c4:	85ce                	mv	a1,s3
    800037c6:	855a                	mv	a0,s6
    800037c8:	d33fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    800037cc:	85ce                	mv	a1,s3
    800037ce:	8556                	mv	a0,s5
    800037d0:	b1fff0ef          	jal	800032ee <iget>
    800037d4:	89aa                	mv	s3,a0
    brelse(bp);
    800037d6:	854a                	mv	a0,s2
    800037d8:	ff8ff0ef          	jal	80002fd0 <brelse>
    if (ip) {
    800037dc:	00098f63          	beqz	s3,800037fa <ireclaim+0x6e>
      begin_op();
    800037e0:	78c000ef          	jal	80003f6c <begin_op>
      ilock(ip);
    800037e4:	854e                	mv	a0,s3
    800037e6:	d7bff0ef          	jal	80003560 <ilock>
      iunlock(ip);
    800037ea:	854e                	mv	a0,s3
    800037ec:	e23ff0ef          	jal	8000360e <iunlock>
      iput(ip);
    800037f0:	854e                	mv	a0,s3
    800037f2:	ef1ff0ef          	jal	800036e2 <iput>
      end_op();
    800037f6:	7e6000ef          	jal	80003fdc <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800037fa:	0485                	addi	s1,s1,1
    800037fc:	00ca2703          	lw	a4,12(s4)
    80003800:	0004879b          	sext.w	a5,s1
    80003804:	02e7fd63          	bgeu	a5,a4,8000383e <ireclaim+0xb2>
    80003808:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000380c:	0044d593          	srli	a1,s1,0x4
    80003810:	018a2783          	lw	a5,24(s4)
    80003814:	9dbd                	addw	a1,a1,a5
    80003816:	8556                	mv	a0,s5
    80003818:	eb0ff0ef          	jal	80002ec8 <bread>
    8000381c:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000381e:	05850793          	addi	a5,a0,88
    80003822:	00f9f713          	andi	a4,s3,15
    80003826:	071a                	slli	a4,a4,0x6
    80003828:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    8000382a:	00079703          	lh	a4,0(a5)
    8000382e:	c701                	beqz	a4,80003836 <ireclaim+0xaa>
    80003830:	00679783          	lh	a5,6(a5)
    80003834:	dbc1                	beqz	a5,800037c4 <ireclaim+0x38>
    brelse(bp);
    80003836:	854a                	mv	a0,s2
    80003838:	f98ff0ef          	jal	80002fd0 <brelse>
    if (ip) {
    8000383c:	bf7d                	j	800037fa <ireclaim+0x6e>
}
    8000383e:	70e2                	ld	ra,56(sp)
    80003840:	7442                	ld	s0,48(sp)
    80003842:	74a2                	ld	s1,40(sp)
    80003844:	7902                	ld	s2,32(sp)
    80003846:	69e2                	ld	s3,24(sp)
    80003848:	6a42                	ld	s4,16(sp)
    8000384a:	6aa2                	ld	s5,8(sp)
    8000384c:	6b02                	ld	s6,0(sp)
    8000384e:	6121                	addi	sp,sp,64
    80003850:	8082                	ret
    80003852:	8082                	ret

0000000080003854 <fsinit>:
fsinit(int dev) {
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	addi	s0,sp,32
    80003860:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003862:	4585                	li	a1,1
    80003864:	e64ff0ef          	jal	80002ec8 <bread>
    80003868:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000386a:	02000613          	li	a2,32
    8000386e:	05850593          	addi	a1,a0,88
    80003872:	0001d517          	auipc	a0,0x1d
    80003876:	6ce50513          	addi	a0,a0,1742 # 80020f40 <sb>
    8000387a:	cdefd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    8000387e:	8526                	mv	a0,s1
    80003880:	f50ff0ef          	jal	80002fd0 <brelse>
  if(sb.magic != FSMAGIC)
    80003884:	0001d717          	auipc	a4,0x1d
    80003888:	6bc72703          	lw	a4,1724(a4) # 80020f40 <sb>
    8000388c:	102037b7          	lui	a5,0x10203
    80003890:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003894:	02f71263          	bne	a4,a5,800038b8 <fsinit+0x64>
  initlog(dev, &sb);
    80003898:	0001d597          	auipc	a1,0x1d
    8000389c:	6a858593          	addi	a1,a1,1704 # 80020f40 <sb>
    800038a0:	854a                	mv	a0,s2
    800038a2:	648000ef          	jal	80003eea <initlog>
  ireclaim(dev);
    800038a6:	854a                	mv	a0,s2
    800038a8:	ee5ff0ef          	jal	8000378c <ireclaim>
}
    800038ac:	60e2                	ld	ra,24(sp)
    800038ae:	6442                	ld	s0,16(sp)
    800038b0:	64a2                	ld	s1,8(sp)
    800038b2:	6902                	ld	s2,0(sp)
    800038b4:	6105                	addi	sp,sp,32
    800038b6:	8082                	ret
    panic("invalid file system");
    800038b8:	00004517          	auipc	a0,0x4
    800038bc:	da050513          	addi	a0,a0,-608 # 80007658 <etext+0x658>
    800038c0:	f65fc0ef          	jal	80000824 <panic>

00000000800038c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800038c4:	1141                	addi	sp,sp,-16
    800038c6:	e406                	sd	ra,8(sp)
    800038c8:	e022                	sd	s0,0(sp)
    800038ca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800038cc:	411c                	lw	a5,0(a0)
    800038ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800038d0:	415c                	lw	a5,4(a0)
    800038d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800038d4:	04451783          	lh	a5,68(a0)
    800038d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800038dc:	04a51783          	lh	a5,74(a0)
    800038e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800038e4:	04c56783          	lwu	a5,76(a0)
    800038e8:	e99c                	sd	a5,16(a1)
}
    800038ea:	60a2                	ld	ra,8(sp)
    800038ec:	6402                	ld	s0,0(sp)
    800038ee:	0141                	addi	sp,sp,16
    800038f0:	8082                	ret

00000000800038f2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038f2:	457c                	lw	a5,76(a0)
    800038f4:	0ed7e663          	bltu	a5,a3,800039e0 <readi+0xee>
{
    800038f8:	7159                	addi	sp,sp,-112
    800038fa:	f486                	sd	ra,104(sp)
    800038fc:	f0a2                	sd	s0,96(sp)
    800038fe:	eca6                	sd	s1,88(sp)
    80003900:	e0d2                	sd	s4,64(sp)
    80003902:	fc56                	sd	s5,56(sp)
    80003904:	f85a                	sd	s6,48(sp)
    80003906:	f45e                	sd	s7,40(sp)
    80003908:	1880                	addi	s0,sp,112
    8000390a:	8b2a                	mv	s6,a0
    8000390c:	8bae                	mv	s7,a1
    8000390e:	8a32                	mv	s4,a2
    80003910:	84b6                	mv	s1,a3
    80003912:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003914:	9f35                	addw	a4,a4,a3
    return 0;
    80003916:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003918:	0ad76b63          	bltu	a4,a3,800039ce <readi+0xdc>
    8000391c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000391e:	00e7f463          	bgeu	a5,a4,80003926 <readi+0x34>
    n = ip->size - off;
    80003922:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003926:	080a8b63          	beqz	s5,800039bc <readi+0xca>
    8000392a:	e8ca                	sd	s2,80(sp)
    8000392c:	f062                	sd	s8,32(sp)
    8000392e:	ec66                	sd	s9,24(sp)
    80003930:	e86a                	sd	s10,16(sp)
    80003932:	e46e                	sd	s11,8(sp)
    80003934:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003936:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000393a:	5c7d                	li	s8,-1
    8000393c:	a80d                	j	8000396e <readi+0x7c>
    8000393e:	020d1d93          	slli	s11,s10,0x20
    80003942:	020ddd93          	srli	s11,s11,0x20
    80003946:	05890613          	addi	a2,s2,88
    8000394a:	86ee                	mv	a3,s11
    8000394c:	963e                	add	a2,a2,a5
    8000394e:	85d2                	mv	a1,s4
    80003950:	855e                	mv	a0,s7
    80003952:	b43fe0ef          	jal	80002494 <either_copyout>
    80003956:	05850363          	beq	a0,s8,8000399c <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000395a:	854a                	mv	a0,s2
    8000395c:	e74ff0ef          	jal	80002fd0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003960:	013d09bb          	addw	s3,s10,s3
    80003964:	009d04bb          	addw	s1,s10,s1
    80003968:	9a6e                	add	s4,s4,s11
    8000396a:	0559f363          	bgeu	s3,s5,800039b0 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    8000396e:	00a4d59b          	srliw	a1,s1,0xa
    80003972:	855a                	mv	a0,s6
    80003974:	8bbff0ef          	jal	8000322e <bmap>
    80003978:	85aa                	mv	a1,a0
    if(addr == 0)
    8000397a:	c139                	beqz	a0,800039c0 <readi+0xce>
    bp = bread(ip->dev, addr);
    8000397c:	000b2503          	lw	a0,0(s6)
    80003980:	d48ff0ef          	jal	80002ec8 <bread>
    80003984:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003986:	3ff4f793          	andi	a5,s1,1023
    8000398a:	40fc873b          	subw	a4,s9,a5
    8000398e:	413a86bb          	subw	a3,s5,s3
    80003992:	8d3a                	mv	s10,a4
    80003994:	fae6f5e3          	bgeu	a3,a4,8000393e <readi+0x4c>
    80003998:	8d36                	mv	s10,a3
    8000399a:	b755                	j	8000393e <readi+0x4c>
      brelse(bp);
    8000399c:	854a                	mv	a0,s2
    8000399e:	e32ff0ef          	jal	80002fd0 <brelse>
      tot = -1;
    800039a2:	59fd                	li	s3,-1
      break;
    800039a4:	6946                	ld	s2,80(sp)
    800039a6:	7c02                	ld	s8,32(sp)
    800039a8:	6ce2                	ld	s9,24(sp)
    800039aa:	6d42                	ld	s10,16(sp)
    800039ac:	6da2                	ld	s11,8(sp)
    800039ae:	a831                	j	800039ca <readi+0xd8>
    800039b0:	6946                	ld	s2,80(sp)
    800039b2:	7c02                	ld	s8,32(sp)
    800039b4:	6ce2                	ld	s9,24(sp)
    800039b6:	6d42                	ld	s10,16(sp)
    800039b8:	6da2                	ld	s11,8(sp)
    800039ba:	a801                	j	800039ca <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039bc:	89d6                	mv	s3,s5
    800039be:	a031                	j	800039ca <readi+0xd8>
    800039c0:	6946                	ld	s2,80(sp)
    800039c2:	7c02                	ld	s8,32(sp)
    800039c4:	6ce2                	ld	s9,24(sp)
    800039c6:	6d42                	ld	s10,16(sp)
    800039c8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800039ca:	854e                	mv	a0,s3
    800039cc:	69a6                	ld	s3,72(sp)
}
    800039ce:	70a6                	ld	ra,104(sp)
    800039d0:	7406                	ld	s0,96(sp)
    800039d2:	64e6                	ld	s1,88(sp)
    800039d4:	6a06                	ld	s4,64(sp)
    800039d6:	7ae2                	ld	s5,56(sp)
    800039d8:	7b42                	ld	s6,48(sp)
    800039da:	7ba2                	ld	s7,40(sp)
    800039dc:	6165                	addi	sp,sp,112
    800039de:	8082                	ret
    return 0;
    800039e0:	4501                	li	a0,0
}
    800039e2:	8082                	ret

00000000800039e4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039e4:	457c                	lw	a5,76(a0)
    800039e6:	0ed7eb63          	bltu	a5,a3,80003adc <writei+0xf8>
{
    800039ea:	7159                	addi	sp,sp,-112
    800039ec:	f486                	sd	ra,104(sp)
    800039ee:	f0a2                	sd	s0,96(sp)
    800039f0:	e8ca                	sd	s2,80(sp)
    800039f2:	e0d2                	sd	s4,64(sp)
    800039f4:	fc56                	sd	s5,56(sp)
    800039f6:	f85a                	sd	s6,48(sp)
    800039f8:	f45e                	sd	s7,40(sp)
    800039fa:	1880                	addi	s0,sp,112
    800039fc:	8aaa                	mv	s5,a0
    800039fe:	8bae                	mv	s7,a1
    80003a00:	8a32                	mv	s4,a2
    80003a02:	8936                	mv	s2,a3
    80003a04:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a06:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003a0a:	00043737          	lui	a4,0x43
    80003a0e:	0cf76963          	bltu	a4,a5,80003ae0 <writei+0xfc>
    80003a12:	0cd7e763          	bltu	a5,a3,80003ae0 <writei+0xfc>
    80003a16:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a18:	0a0b0a63          	beqz	s6,80003acc <writei+0xe8>
    80003a1c:	eca6                	sd	s1,88(sp)
    80003a1e:	f062                	sd	s8,32(sp)
    80003a20:	ec66                	sd	s9,24(sp)
    80003a22:	e86a                	sd	s10,16(sp)
    80003a24:	e46e                	sd	s11,8(sp)
    80003a26:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a28:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003a2c:	5c7d                	li	s8,-1
    80003a2e:	a825                	j	80003a66 <writei+0x82>
    80003a30:	020d1d93          	slli	s11,s10,0x20
    80003a34:	020ddd93          	srli	s11,s11,0x20
    80003a38:	05848513          	addi	a0,s1,88
    80003a3c:	86ee                	mv	a3,s11
    80003a3e:	8652                	mv	a2,s4
    80003a40:	85de                	mv	a1,s7
    80003a42:	953e                	add	a0,a0,a5
    80003a44:	a9bfe0ef          	jal	800024de <either_copyin>
    80003a48:	05850663          	beq	a0,s8,80003a94 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	6b8000ef          	jal	80004106 <log_write>
    brelse(bp);
    80003a52:	8526                	mv	a0,s1
    80003a54:	d7cff0ef          	jal	80002fd0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a58:	013d09bb          	addw	s3,s10,s3
    80003a5c:	012d093b          	addw	s2,s10,s2
    80003a60:	9a6e                	add	s4,s4,s11
    80003a62:	0369fc63          	bgeu	s3,s6,80003a9a <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003a66:	00a9559b          	srliw	a1,s2,0xa
    80003a6a:	8556                	mv	a0,s5
    80003a6c:	fc2ff0ef          	jal	8000322e <bmap>
    80003a70:	85aa                	mv	a1,a0
    if(addr == 0)
    80003a72:	c505                	beqz	a0,80003a9a <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003a74:	000aa503          	lw	a0,0(s5)
    80003a78:	c50ff0ef          	jal	80002ec8 <bread>
    80003a7c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a7e:	3ff97793          	andi	a5,s2,1023
    80003a82:	40fc873b          	subw	a4,s9,a5
    80003a86:	413b06bb          	subw	a3,s6,s3
    80003a8a:	8d3a                	mv	s10,a4
    80003a8c:	fae6f2e3          	bgeu	a3,a4,80003a30 <writei+0x4c>
    80003a90:	8d36                	mv	s10,a3
    80003a92:	bf79                	j	80003a30 <writei+0x4c>
      brelse(bp);
    80003a94:	8526                	mv	a0,s1
    80003a96:	d3aff0ef          	jal	80002fd0 <brelse>
  }

  if(off > ip->size)
    80003a9a:	04caa783          	lw	a5,76(s5)
    80003a9e:	0327f963          	bgeu	a5,s2,80003ad0 <writei+0xec>
    ip->size = off;
    80003aa2:	052aa623          	sw	s2,76(s5)
    80003aa6:	64e6                	ld	s1,88(sp)
    80003aa8:	7c02                	ld	s8,32(sp)
    80003aaa:	6ce2                	ld	s9,24(sp)
    80003aac:	6d42                	ld	s10,16(sp)
    80003aae:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003ab0:	8556                	mv	a0,s5
    80003ab2:	9fbff0ef          	jal	800034ac <iupdate>

  return tot;
    80003ab6:	854e                	mv	a0,s3
    80003ab8:	69a6                	ld	s3,72(sp)
}
    80003aba:	70a6                	ld	ra,104(sp)
    80003abc:	7406                	ld	s0,96(sp)
    80003abe:	6946                	ld	s2,80(sp)
    80003ac0:	6a06                	ld	s4,64(sp)
    80003ac2:	7ae2                	ld	s5,56(sp)
    80003ac4:	7b42                	ld	s6,48(sp)
    80003ac6:	7ba2                	ld	s7,40(sp)
    80003ac8:	6165                	addi	sp,sp,112
    80003aca:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003acc:	89da                	mv	s3,s6
    80003ace:	b7cd                	j	80003ab0 <writei+0xcc>
    80003ad0:	64e6                	ld	s1,88(sp)
    80003ad2:	7c02                	ld	s8,32(sp)
    80003ad4:	6ce2                	ld	s9,24(sp)
    80003ad6:	6d42                	ld	s10,16(sp)
    80003ad8:	6da2                	ld	s11,8(sp)
    80003ada:	bfd9                	j	80003ab0 <writei+0xcc>
    return -1;
    80003adc:	557d                	li	a0,-1
}
    80003ade:	8082                	ret
    return -1;
    80003ae0:	557d                	li	a0,-1
    80003ae2:	bfe1                	j	80003aba <writei+0xd6>

0000000080003ae4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ae4:	1141                	addi	sp,sp,-16
    80003ae6:	e406                	sd	ra,8(sp)
    80003ae8:	e022                	sd	s0,0(sp)
    80003aea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003aec:	4639                	li	a2,14
    80003aee:	adefd0ef          	jal	80000dcc <strncmp>
}
    80003af2:	60a2                	ld	ra,8(sp)
    80003af4:	6402                	ld	s0,0(sp)
    80003af6:	0141                	addi	sp,sp,16
    80003af8:	8082                	ret

0000000080003afa <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003afa:	711d                	addi	sp,sp,-96
    80003afc:	ec86                	sd	ra,88(sp)
    80003afe:	e8a2                	sd	s0,80(sp)
    80003b00:	e4a6                	sd	s1,72(sp)
    80003b02:	e0ca                	sd	s2,64(sp)
    80003b04:	fc4e                	sd	s3,56(sp)
    80003b06:	f852                	sd	s4,48(sp)
    80003b08:	f456                	sd	s5,40(sp)
    80003b0a:	f05a                	sd	s6,32(sp)
    80003b0c:	ec5e                	sd	s7,24(sp)
    80003b0e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003b10:	04451703          	lh	a4,68(a0)
    80003b14:	4785                	li	a5,1
    80003b16:	00f71f63          	bne	a4,a5,80003b34 <dirlookup+0x3a>
    80003b1a:	892a                	mv	s2,a0
    80003b1c:	8aae                	mv	s5,a1
    80003b1e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b20:	457c                	lw	a5,76(a0)
    80003b22:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b24:	fa040a13          	addi	s4,s0,-96
    80003b28:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003b2a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003b2e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b30:	e39d                	bnez	a5,80003b56 <dirlookup+0x5c>
    80003b32:	a8b9                	j	80003b90 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003b34:	00004517          	auipc	a0,0x4
    80003b38:	b3c50513          	addi	a0,a0,-1220 # 80007670 <etext+0x670>
    80003b3c:	ce9fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80003b40:	00004517          	auipc	a0,0x4
    80003b44:	b4850513          	addi	a0,a0,-1208 # 80007688 <etext+0x688>
    80003b48:	cddfc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b4c:	24c1                	addiw	s1,s1,16
    80003b4e:	04c92783          	lw	a5,76(s2)
    80003b52:	02f4fe63          	bgeu	s1,a5,80003b8e <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b56:	874e                	mv	a4,s3
    80003b58:	86a6                	mv	a3,s1
    80003b5a:	8652                	mv	a2,s4
    80003b5c:	4581                	li	a1,0
    80003b5e:	854a                	mv	a0,s2
    80003b60:	d93ff0ef          	jal	800038f2 <readi>
    80003b64:	fd351ee3          	bne	a0,s3,80003b40 <dirlookup+0x46>
    if(de.inum == 0)
    80003b68:	fa045783          	lhu	a5,-96(s0)
    80003b6c:	d3e5                	beqz	a5,80003b4c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003b6e:	85da                	mv	a1,s6
    80003b70:	8556                	mv	a0,s5
    80003b72:	f73ff0ef          	jal	80003ae4 <namecmp>
    80003b76:	f979                	bnez	a0,80003b4c <dirlookup+0x52>
      if(poff)
    80003b78:	000b8463          	beqz	s7,80003b80 <dirlookup+0x86>
        *poff = off;
    80003b7c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003b80:	fa045583          	lhu	a1,-96(s0)
    80003b84:	00092503          	lw	a0,0(s2)
    80003b88:	f66ff0ef          	jal	800032ee <iget>
    80003b8c:	a011                	j	80003b90 <dirlookup+0x96>
  return 0;
    80003b8e:	4501                	li	a0,0
}
    80003b90:	60e6                	ld	ra,88(sp)
    80003b92:	6446                	ld	s0,80(sp)
    80003b94:	64a6                	ld	s1,72(sp)
    80003b96:	6906                	ld	s2,64(sp)
    80003b98:	79e2                	ld	s3,56(sp)
    80003b9a:	7a42                	ld	s4,48(sp)
    80003b9c:	7aa2                	ld	s5,40(sp)
    80003b9e:	7b02                	ld	s6,32(sp)
    80003ba0:	6be2                	ld	s7,24(sp)
    80003ba2:	6125                	addi	sp,sp,96
    80003ba4:	8082                	ret

0000000080003ba6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003ba6:	711d                	addi	sp,sp,-96
    80003ba8:	ec86                	sd	ra,88(sp)
    80003baa:	e8a2                	sd	s0,80(sp)
    80003bac:	e4a6                	sd	s1,72(sp)
    80003bae:	e0ca                	sd	s2,64(sp)
    80003bb0:	fc4e                	sd	s3,56(sp)
    80003bb2:	f852                	sd	s4,48(sp)
    80003bb4:	f456                	sd	s5,40(sp)
    80003bb6:	f05a                	sd	s6,32(sp)
    80003bb8:	ec5e                	sd	s7,24(sp)
    80003bba:	e862                	sd	s8,16(sp)
    80003bbc:	e466                	sd	s9,8(sp)
    80003bbe:	e06a                	sd	s10,0(sp)
    80003bc0:	1080                	addi	s0,sp,96
    80003bc2:	84aa                	mv	s1,a0
    80003bc4:	8b2e                	mv	s6,a1
    80003bc6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003bc8:	00054703          	lbu	a4,0(a0)
    80003bcc:	02f00793          	li	a5,47
    80003bd0:	00f70f63          	beq	a4,a5,80003bee <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bd4:	f09fd0ef          	jal	80001adc <myproc>
    80003bd8:	15053503          	ld	a0,336(a0)
    80003bdc:	94fff0ef          	jal	8000352a <idup>
    80003be0:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003be2:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003be6:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003be8:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003bea:	4b85                	li	s7,1
    80003bec:	a879                	j	80003c8a <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003bee:	4585                	li	a1,1
    80003bf0:	852e                	mv	a0,a1
    80003bf2:	efcff0ef          	jal	800032ee <iget>
    80003bf6:	8a2a                	mv	s4,a0
    80003bf8:	b7ed                	j	80003be2 <namex+0x3c>
      iunlockput(ip);
    80003bfa:	8552                	mv	a0,s4
    80003bfc:	b71ff0ef          	jal	8000376c <iunlockput>
      return 0;
    80003c00:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003c02:	8552                	mv	a0,s4
    80003c04:	60e6                	ld	ra,88(sp)
    80003c06:	6446                	ld	s0,80(sp)
    80003c08:	64a6                	ld	s1,72(sp)
    80003c0a:	6906                	ld	s2,64(sp)
    80003c0c:	79e2                	ld	s3,56(sp)
    80003c0e:	7a42                	ld	s4,48(sp)
    80003c10:	7aa2                	ld	s5,40(sp)
    80003c12:	7b02                	ld	s6,32(sp)
    80003c14:	6be2                	ld	s7,24(sp)
    80003c16:	6c42                	ld	s8,16(sp)
    80003c18:	6ca2                	ld	s9,8(sp)
    80003c1a:	6d02                	ld	s10,0(sp)
    80003c1c:	6125                	addi	sp,sp,96
    80003c1e:	8082                	ret
      iunlock(ip);
    80003c20:	8552                	mv	a0,s4
    80003c22:	9edff0ef          	jal	8000360e <iunlock>
      return ip;
    80003c26:	bff1                	j	80003c02 <namex+0x5c>
      iunlockput(ip);
    80003c28:	8552                	mv	a0,s4
    80003c2a:	b43ff0ef          	jal	8000376c <iunlockput>
      return 0;
    80003c2e:	8a4a                	mv	s4,s2
    80003c30:	bfc9                	j	80003c02 <namex+0x5c>
  len = path - s;
    80003c32:	40990633          	sub	a2,s2,s1
    80003c36:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003c3a:	09ac5463          	bge	s8,s10,80003cc2 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003c3e:	8666                	mv	a2,s9
    80003c40:	85a6                	mv	a1,s1
    80003c42:	8556                	mv	a0,s5
    80003c44:	914fd0ef          	jal	80000d58 <memmove>
    80003c48:	84ca                	mv	s1,s2
  while(*path == '/')
    80003c4a:	0004c783          	lbu	a5,0(s1)
    80003c4e:	01379763          	bne	a5,s3,80003c5c <namex+0xb6>
    path++;
    80003c52:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c54:	0004c783          	lbu	a5,0(s1)
    80003c58:	ff378de3          	beq	a5,s3,80003c52 <namex+0xac>
    ilock(ip);
    80003c5c:	8552                	mv	a0,s4
    80003c5e:	903ff0ef          	jal	80003560 <ilock>
    if(ip->type != T_DIR){
    80003c62:	044a1783          	lh	a5,68(s4)
    80003c66:	f9779ae3          	bne	a5,s7,80003bfa <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003c6a:	000b0563          	beqz	s6,80003c74 <namex+0xce>
    80003c6e:	0004c783          	lbu	a5,0(s1)
    80003c72:	d7dd                	beqz	a5,80003c20 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c74:	4601                	li	a2,0
    80003c76:	85d6                	mv	a1,s5
    80003c78:	8552                	mv	a0,s4
    80003c7a:	e81ff0ef          	jal	80003afa <dirlookup>
    80003c7e:	892a                	mv	s2,a0
    80003c80:	d545                	beqz	a0,80003c28 <namex+0x82>
    iunlockput(ip);
    80003c82:	8552                	mv	a0,s4
    80003c84:	ae9ff0ef          	jal	8000376c <iunlockput>
    ip = next;
    80003c88:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003c8a:	0004c783          	lbu	a5,0(s1)
    80003c8e:	01379763          	bne	a5,s3,80003c9c <namex+0xf6>
    path++;
    80003c92:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c94:	0004c783          	lbu	a5,0(s1)
    80003c98:	ff378de3          	beq	a5,s3,80003c92 <namex+0xec>
  if(*path == 0)
    80003c9c:	cf8d                	beqz	a5,80003cd6 <namex+0x130>
  while(*path != '/' && *path != 0)
    80003c9e:	0004c783          	lbu	a5,0(s1)
    80003ca2:	fd178713          	addi	a4,a5,-47
    80003ca6:	cb19                	beqz	a4,80003cbc <namex+0x116>
    80003ca8:	cb91                	beqz	a5,80003cbc <namex+0x116>
    80003caa:	8926                	mv	s2,s1
    path++;
    80003cac:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003cae:	00094783          	lbu	a5,0(s2)
    80003cb2:	fd178713          	addi	a4,a5,-47
    80003cb6:	df35                	beqz	a4,80003c32 <namex+0x8c>
    80003cb8:	fbf5                	bnez	a5,80003cac <namex+0x106>
    80003cba:	bfa5                	j	80003c32 <namex+0x8c>
    80003cbc:	8926                	mv	s2,s1
  len = path - s;
    80003cbe:	4d01                	li	s10,0
    80003cc0:	4601                	li	a2,0
    memmove(name, s, len);
    80003cc2:	2601                	sext.w	a2,a2
    80003cc4:	85a6                	mv	a1,s1
    80003cc6:	8556                	mv	a0,s5
    80003cc8:	890fd0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80003ccc:	9d56                	add	s10,s10,s5
    80003cce:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdb3b8>
    80003cd2:	84ca                	mv	s1,s2
    80003cd4:	bf9d                	j	80003c4a <namex+0xa4>
  if(nameiparent){
    80003cd6:	f20b06e3          	beqz	s6,80003c02 <namex+0x5c>
    iput(ip);
    80003cda:	8552                	mv	a0,s4
    80003cdc:	a07ff0ef          	jal	800036e2 <iput>
    return 0;
    80003ce0:	4a01                	li	s4,0
    80003ce2:	b705                	j	80003c02 <namex+0x5c>

0000000080003ce4 <dirlink>:
{
    80003ce4:	715d                	addi	sp,sp,-80
    80003ce6:	e486                	sd	ra,72(sp)
    80003ce8:	e0a2                	sd	s0,64(sp)
    80003cea:	f84a                	sd	s2,48(sp)
    80003cec:	ec56                	sd	s5,24(sp)
    80003cee:	e85a                	sd	s6,16(sp)
    80003cf0:	0880                	addi	s0,sp,80
    80003cf2:	892a                	mv	s2,a0
    80003cf4:	8aae                	mv	s5,a1
    80003cf6:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003cf8:	4601                	li	a2,0
    80003cfa:	e01ff0ef          	jal	80003afa <dirlookup>
    80003cfe:	ed1d                	bnez	a0,80003d3c <dirlink+0x58>
    80003d00:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d02:	04c92483          	lw	s1,76(s2)
    80003d06:	c4b9                	beqz	s1,80003d54 <dirlink+0x70>
    80003d08:	f44e                	sd	s3,40(sp)
    80003d0a:	f052                	sd	s4,32(sp)
    80003d0c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d0e:	fb040a13          	addi	s4,s0,-80
    80003d12:	49c1                	li	s3,16
    80003d14:	874e                	mv	a4,s3
    80003d16:	86a6                	mv	a3,s1
    80003d18:	8652                	mv	a2,s4
    80003d1a:	4581                	li	a1,0
    80003d1c:	854a                	mv	a0,s2
    80003d1e:	bd5ff0ef          	jal	800038f2 <readi>
    80003d22:	03351163          	bne	a0,s3,80003d44 <dirlink+0x60>
    if(de.inum == 0)
    80003d26:	fb045783          	lhu	a5,-80(s0)
    80003d2a:	c39d                	beqz	a5,80003d50 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d2c:	24c1                	addiw	s1,s1,16
    80003d2e:	04c92783          	lw	a5,76(s2)
    80003d32:	fef4e1e3          	bltu	s1,a5,80003d14 <dirlink+0x30>
    80003d36:	79a2                	ld	s3,40(sp)
    80003d38:	7a02                	ld	s4,32(sp)
    80003d3a:	a829                	j	80003d54 <dirlink+0x70>
    iput(ip);
    80003d3c:	9a7ff0ef          	jal	800036e2 <iput>
    return -1;
    80003d40:	557d                	li	a0,-1
    80003d42:	a83d                	j	80003d80 <dirlink+0x9c>
      panic("dirlink read");
    80003d44:	00004517          	auipc	a0,0x4
    80003d48:	95450513          	addi	a0,a0,-1708 # 80007698 <etext+0x698>
    80003d4c:	ad9fc0ef          	jal	80000824 <panic>
    80003d50:	79a2                	ld	s3,40(sp)
    80003d52:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003d54:	4639                	li	a2,14
    80003d56:	85d6                	mv	a1,s5
    80003d58:	fb240513          	addi	a0,s0,-78
    80003d5c:	8aafd0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80003d60:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d64:	4741                	li	a4,16
    80003d66:	86a6                	mv	a3,s1
    80003d68:	fb040613          	addi	a2,s0,-80
    80003d6c:	4581                	li	a1,0
    80003d6e:	854a                	mv	a0,s2
    80003d70:	c75ff0ef          	jal	800039e4 <writei>
    80003d74:	1541                	addi	a0,a0,-16
    80003d76:	00a03533          	snez	a0,a0
    80003d7a:	40a0053b          	negw	a0,a0
    80003d7e:	74e2                	ld	s1,56(sp)
}
    80003d80:	60a6                	ld	ra,72(sp)
    80003d82:	6406                	ld	s0,64(sp)
    80003d84:	7942                	ld	s2,48(sp)
    80003d86:	6ae2                	ld	s5,24(sp)
    80003d88:	6b42                	ld	s6,16(sp)
    80003d8a:	6161                	addi	sp,sp,80
    80003d8c:	8082                	ret

0000000080003d8e <namei>:

struct inode*
namei(char *path)
{
    80003d8e:	1101                	addi	sp,sp,-32
    80003d90:	ec06                	sd	ra,24(sp)
    80003d92:	e822                	sd	s0,16(sp)
    80003d94:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003d96:	fe040613          	addi	a2,s0,-32
    80003d9a:	4581                	li	a1,0
    80003d9c:	e0bff0ef          	jal	80003ba6 <namex>
}
    80003da0:	60e2                	ld	ra,24(sp)
    80003da2:	6442                	ld	s0,16(sp)
    80003da4:	6105                	addi	sp,sp,32
    80003da6:	8082                	ret

0000000080003da8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003da8:	1141                	addi	sp,sp,-16
    80003daa:	e406                	sd	ra,8(sp)
    80003dac:	e022                	sd	s0,0(sp)
    80003dae:	0800                	addi	s0,sp,16
    80003db0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003db2:	4585                	li	a1,1
    80003db4:	df3ff0ef          	jal	80003ba6 <namex>
}
    80003db8:	60a2                	ld	ra,8(sp)
    80003dba:	6402                	ld	s0,0(sp)
    80003dbc:	0141                	addi	sp,sp,16
    80003dbe:	8082                	ret

0000000080003dc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003dc0:	1101                	addi	sp,sp,-32
    80003dc2:	ec06                	sd	ra,24(sp)
    80003dc4:	e822                	sd	s0,16(sp)
    80003dc6:	e426                	sd	s1,8(sp)
    80003dc8:	e04a                	sd	s2,0(sp)
    80003dca:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003dcc:	0001f917          	auipc	s2,0x1f
    80003dd0:	c3c90913          	addi	s2,s2,-964 # 80022a08 <log>
    80003dd4:	01892583          	lw	a1,24(s2)
    80003dd8:	02492503          	lw	a0,36(s2)
    80003ddc:	8ecff0ef          	jal	80002ec8 <bread>
    80003de0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003de2:	02892603          	lw	a2,40(s2)
    80003de6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003de8:	00c05f63          	blez	a2,80003e06 <write_head+0x46>
    80003dec:	0001f717          	auipc	a4,0x1f
    80003df0:	c4870713          	addi	a4,a4,-952 # 80022a34 <log+0x2c>
    80003df4:	87aa                	mv	a5,a0
    80003df6:	060a                	slli	a2,a2,0x2
    80003df8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003dfa:	4314                	lw	a3,0(a4)
    80003dfc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003dfe:	0711                	addi	a4,a4,4
    80003e00:	0791                	addi	a5,a5,4
    80003e02:	fec79ce3          	bne	a5,a2,80003dfa <write_head+0x3a>
  }
  bwrite(buf);
    80003e06:	8526                	mv	a0,s1
    80003e08:	996ff0ef          	jal	80002f9e <bwrite>
  brelse(buf);
    80003e0c:	8526                	mv	a0,s1
    80003e0e:	9c2ff0ef          	jal	80002fd0 <brelse>
}
    80003e12:	60e2                	ld	ra,24(sp)
    80003e14:	6442                	ld	s0,16(sp)
    80003e16:	64a2                	ld	s1,8(sp)
    80003e18:	6902                	ld	s2,0(sp)
    80003e1a:	6105                	addi	sp,sp,32
    80003e1c:	8082                	ret

0000000080003e1e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e1e:	0001f797          	auipc	a5,0x1f
    80003e22:	c127a783          	lw	a5,-1006(a5) # 80022a30 <log+0x28>
    80003e26:	0cf05163          	blez	a5,80003ee8 <install_trans+0xca>
{
    80003e2a:	715d                	addi	sp,sp,-80
    80003e2c:	e486                	sd	ra,72(sp)
    80003e2e:	e0a2                	sd	s0,64(sp)
    80003e30:	fc26                	sd	s1,56(sp)
    80003e32:	f84a                	sd	s2,48(sp)
    80003e34:	f44e                	sd	s3,40(sp)
    80003e36:	f052                	sd	s4,32(sp)
    80003e38:	ec56                	sd	s5,24(sp)
    80003e3a:	e85a                	sd	s6,16(sp)
    80003e3c:	e45e                	sd	s7,8(sp)
    80003e3e:	e062                	sd	s8,0(sp)
    80003e40:	0880                	addi	s0,sp,80
    80003e42:	8b2a                	mv	s6,a0
    80003e44:	0001fa97          	auipc	s5,0x1f
    80003e48:	bf0a8a93          	addi	s5,s5,-1040 # 80022a34 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e4c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003e4e:	00004c17          	auipc	s8,0x4
    80003e52:	85ac0c13          	addi	s8,s8,-1958 # 800076a8 <etext+0x6a8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e56:	0001fa17          	auipc	s4,0x1f
    80003e5a:	bb2a0a13          	addi	s4,s4,-1102 # 80022a08 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003e5e:	40000b93          	li	s7,1024
    80003e62:	a025                	j	80003e8a <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003e64:	000aa603          	lw	a2,0(s5)
    80003e68:	85ce                	mv	a1,s3
    80003e6a:	8562                	mv	a0,s8
    80003e6c:	e8efc0ef          	jal	800004fa <printf>
    80003e70:	a839                	j	80003e8e <install_trans+0x70>
    brelse(lbuf);
    80003e72:	854a                	mv	a0,s2
    80003e74:	95cff0ef          	jal	80002fd0 <brelse>
    brelse(dbuf);
    80003e78:	8526                	mv	a0,s1
    80003e7a:	956ff0ef          	jal	80002fd0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e7e:	2985                	addiw	s3,s3,1
    80003e80:	0a91                	addi	s5,s5,4
    80003e82:	028a2783          	lw	a5,40(s4)
    80003e86:	04f9d563          	bge	s3,a5,80003ed0 <install_trans+0xb2>
    if(recovering) {
    80003e8a:	fc0b1de3          	bnez	s6,80003e64 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e8e:	018a2583          	lw	a1,24(s4)
    80003e92:	013585bb          	addw	a1,a1,s3
    80003e96:	2585                	addiw	a1,a1,1
    80003e98:	024a2503          	lw	a0,36(s4)
    80003e9c:	82cff0ef          	jal	80002ec8 <bread>
    80003ea0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003ea2:	000aa583          	lw	a1,0(s5)
    80003ea6:	024a2503          	lw	a0,36(s4)
    80003eaa:	81eff0ef          	jal	80002ec8 <bread>
    80003eae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003eb0:	865e                	mv	a2,s7
    80003eb2:	05890593          	addi	a1,s2,88
    80003eb6:	05850513          	addi	a0,a0,88
    80003eba:	e9ffc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	8deff0ef          	jal	80002f9e <bwrite>
    if(recovering == 0)
    80003ec4:	fa0b17e3          	bnez	s6,80003e72 <install_trans+0x54>
      bunpin(dbuf);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	9beff0ef          	jal	80003088 <bunpin>
    80003ece:	b755                	j	80003e72 <install_trans+0x54>
}
    80003ed0:	60a6                	ld	ra,72(sp)
    80003ed2:	6406                	ld	s0,64(sp)
    80003ed4:	74e2                	ld	s1,56(sp)
    80003ed6:	7942                	ld	s2,48(sp)
    80003ed8:	79a2                	ld	s3,40(sp)
    80003eda:	7a02                	ld	s4,32(sp)
    80003edc:	6ae2                	ld	s5,24(sp)
    80003ede:	6b42                	ld	s6,16(sp)
    80003ee0:	6ba2                	ld	s7,8(sp)
    80003ee2:	6c02                	ld	s8,0(sp)
    80003ee4:	6161                	addi	sp,sp,80
    80003ee6:	8082                	ret
    80003ee8:	8082                	ret

0000000080003eea <initlog>:
{
    80003eea:	7179                	addi	sp,sp,-48
    80003eec:	f406                	sd	ra,40(sp)
    80003eee:	f022                	sd	s0,32(sp)
    80003ef0:	ec26                	sd	s1,24(sp)
    80003ef2:	e84a                	sd	s2,16(sp)
    80003ef4:	e44e                	sd	s3,8(sp)
    80003ef6:	1800                	addi	s0,sp,48
    80003ef8:	84aa                	mv	s1,a0
    80003efa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003efc:	0001f917          	auipc	s2,0x1f
    80003f00:	b0c90913          	addi	s2,s2,-1268 # 80022a08 <log>
    80003f04:	00003597          	auipc	a1,0x3
    80003f08:	7c458593          	addi	a1,a1,1988 # 800076c8 <etext+0x6c8>
    80003f0c:	854a                	mv	a0,s2
    80003f0e:	c91fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    80003f12:	0149a583          	lw	a1,20(s3)
    80003f16:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003f1a:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003f1e:	8526                	mv	a0,s1
    80003f20:	fa9fe0ef          	jal	80002ec8 <bread>
  log.lh.n = lh->n;
    80003f24:	4d30                	lw	a2,88(a0)
    80003f26:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003f2a:	00c05f63          	blez	a2,80003f48 <initlog+0x5e>
    80003f2e:	87aa                	mv	a5,a0
    80003f30:	0001f717          	auipc	a4,0x1f
    80003f34:	b0470713          	addi	a4,a4,-1276 # 80022a34 <log+0x2c>
    80003f38:	060a                	slli	a2,a2,0x2
    80003f3a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003f3c:	4ff4                	lw	a3,92(a5)
    80003f3e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f40:	0791                	addi	a5,a5,4
    80003f42:	0711                	addi	a4,a4,4
    80003f44:	fec79ce3          	bne	a5,a2,80003f3c <initlog+0x52>
  brelse(buf);
    80003f48:	888ff0ef          	jal	80002fd0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003f4c:	4505                	li	a0,1
    80003f4e:	ed1ff0ef          	jal	80003e1e <install_trans>
  log.lh.n = 0;
    80003f52:	0001f797          	auipc	a5,0x1f
    80003f56:	ac07af23          	sw	zero,-1314(a5) # 80022a30 <log+0x28>
  write_head(); // clear the log
    80003f5a:	e67ff0ef          	jal	80003dc0 <write_head>
}
    80003f5e:	70a2                	ld	ra,40(sp)
    80003f60:	7402                	ld	s0,32(sp)
    80003f62:	64e2                	ld	s1,24(sp)
    80003f64:	6942                	ld	s2,16(sp)
    80003f66:	69a2                	ld	s3,8(sp)
    80003f68:	6145                	addi	sp,sp,48
    80003f6a:	8082                	ret

0000000080003f6c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003f6c:	1101                	addi	sp,sp,-32
    80003f6e:	ec06                	sd	ra,24(sp)
    80003f70:	e822                	sd	s0,16(sp)
    80003f72:	e426                	sd	s1,8(sp)
    80003f74:	e04a                	sd	s2,0(sp)
    80003f76:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003f78:	0001f517          	auipc	a0,0x1f
    80003f7c:	a9050513          	addi	a0,a0,-1392 # 80022a08 <log>
    80003f80:	ca9fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80003f84:	0001f497          	auipc	s1,0x1f
    80003f88:	a8448493          	addi	s1,s1,-1404 # 80022a08 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003f8c:	4979                	li	s2,30
    80003f8e:	a029                	j	80003f98 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003f90:	85a6                	mv	a1,s1
    80003f92:	8526                	mv	a0,s1
    80003f94:	998fe0ef          	jal	8000212c <sleep>
    if(log.committing){
    80003f98:	509c                	lw	a5,32(s1)
    80003f9a:	fbfd                	bnez	a5,80003f90 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003f9c:	4cd8                	lw	a4,28(s1)
    80003f9e:	2705                	addiw	a4,a4,1
    80003fa0:	0027179b          	slliw	a5,a4,0x2
    80003fa4:	9fb9                	addw	a5,a5,a4
    80003fa6:	0017979b          	slliw	a5,a5,0x1
    80003faa:	5494                	lw	a3,40(s1)
    80003fac:	9fb5                	addw	a5,a5,a3
    80003fae:	00f95763          	bge	s2,a5,80003fbc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003fb2:	85a6                	mv	a1,s1
    80003fb4:	8526                	mv	a0,s1
    80003fb6:	976fe0ef          	jal	8000212c <sleep>
    80003fba:	bff9                	j	80003f98 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003fbc:	0001f797          	auipc	a5,0x1f
    80003fc0:	a6e7a423          	sw	a4,-1432(a5) # 80022a24 <log+0x1c>
      release(&log.lock);
    80003fc4:	0001f517          	auipc	a0,0x1f
    80003fc8:	a4450513          	addi	a0,a0,-1468 # 80022a08 <log>
    80003fcc:	cf1fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    80003fd0:	60e2                	ld	ra,24(sp)
    80003fd2:	6442                	ld	s0,16(sp)
    80003fd4:	64a2                	ld	s1,8(sp)
    80003fd6:	6902                	ld	s2,0(sp)
    80003fd8:	6105                	addi	sp,sp,32
    80003fda:	8082                	ret

0000000080003fdc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003fdc:	7139                	addi	sp,sp,-64
    80003fde:	fc06                	sd	ra,56(sp)
    80003fe0:	f822                	sd	s0,48(sp)
    80003fe2:	f426                	sd	s1,40(sp)
    80003fe4:	f04a                	sd	s2,32(sp)
    80003fe6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003fe8:	0001f497          	auipc	s1,0x1f
    80003fec:	a2048493          	addi	s1,s1,-1504 # 80022a08 <log>
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	c37fc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80003ff6:	4cdc                	lw	a5,28(s1)
    80003ff8:	37fd                	addiw	a5,a5,-1
    80003ffa:	893e                	mv	s2,a5
    80003ffc:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003ffe:	509c                	lw	a5,32(s1)
    80004000:	e7b1                	bnez	a5,8000404c <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80004002:	04091e63          	bnez	s2,8000405e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80004006:	0001f497          	auipc	s1,0x1f
    8000400a:	a0248493          	addi	s1,s1,-1534 # 80022a08 <log>
    8000400e:	4785                	li	a5,1
    80004010:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004012:	8526                	mv	a0,s1
    80004014:	ca9fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004018:	549c                	lw	a5,40(s1)
    8000401a:	06f04463          	bgtz	a5,80004082 <end_op+0xa6>
    acquire(&log.lock);
    8000401e:	0001f517          	auipc	a0,0x1f
    80004022:	9ea50513          	addi	a0,a0,-1558 # 80022a08 <log>
    80004026:	c03fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    8000402a:	0001f797          	auipc	a5,0x1f
    8000402e:	9e07af23          	sw	zero,-1538(a5) # 80022a28 <log+0x20>
    wakeup(&log);
    80004032:	0001f517          	auipc	a0,0x1f
    80004036:	9d650513          	addi	a0,a0,-1578 # 80022a08 <log>
    8000403a:	93efe0ef          	jal	80002178 <wakeup>
    release(&log.lock);
    8000403e:	0001f517          	auipc	a0,0x1f
    80004042:	9ca50513          	addi	a0,a0,-1590 # 80022a08 <log>
    80004046:	c77fc0ef          	jal	80000cbc <release>
}
    8000404a:	a035                	j	80004076 <end_op+0x9a>
    8000404c:	ec4e                	sd	s3,24(sp)
    8000404e:	e852                	sd	s4,16(sp)
    80004050:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004052:	00003517          	auipc	a0,0x3
    80004056:	67e50513          	addi	a0,a0,1662 # 800076d0 <etext+0x6d0>
    8000405a:	fcafc0ef          	jal	80000824 <panic>
    wakeup(&log);
    8000405e:	0001f517          	auipc	a0,0x1f
    80004062:	9aa50513          	addi	a0,a0,-1622 # 80022a08 <log>
    80004066:	912fe0ef          	jal	80002178 <wakeup>
  release(&log.lock);
    8000406a:	0001f517          	auipc	a0,0x1f
    8000406e:	99e50513          	addi	a0,a0,-1634 # 80022a08 <log>
    80004072:	c4bfc0ef          	jal	80000cbc <release>
}
    80004076:	70e2                	ld	ra,56(sp)
    80004078:	7442                	ld	s0,48(sp)
    8000407a:	74a2                	ld	s1,40(sp)
    8000407c:	7902                	ld	s2,32(sp)
    8000407e:	6121                	addi	sp,sp,64
    80004080:	8082                	ret
    80004082:	ec4e                	sd	s3,24(sp)
    80004084:	e852                	sd	s4,16(sp)
    80004086:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004088:	0001fa97          	auipc	s5,0x1f
    8000408c:	9aca8a93          	addi	s5,s5,-1620 # 80022a34 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004090:	0001fa17          	auipc	s4,0x1f
    80004094:	978a0a13          	addi	s4,s4,-1672 # 80022a08 <log>
    80004098:	018a2583          	lw	a1,24(s4)
    8000409c:	012585bb          	addw	a1,a1,s2
    800040a0:	2585                	addiw	a1,a1,1
    800040a2:	024a2503          	lw	a0,36(s4)
    800040a6:	e23fe0ef          	jal	80002ec8 <bread>
    800040aa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800040ac:	000aa583          	lw	a1,0(s5)
    800040b0:	024a2503          	lw	a0,36(s4)
    800040b4:	e15fe0ef          	jal	80002ec8 <bread>
    800040b8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800040ba:	40000613          	li	a2,1024
    800040be:	05850593          	addi	a1,a0,88
    800040c2:	05848513          	addi	a0,s1,88
    800040c6:	c93fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    800040ca:	8526                	mv	a0,s1
    800040cc:	ed3fe0ef          	jal	80002f9e <bwrite>
    brelse(from);
    800040d0:	854e                	mv	a0,s3
    800040d2:	efffe0ef          	jal	80002fd0 <brelse>
    brelse(to);
    800040d6:	8526                	mv	a0,s1
    800040d8:	ef9fe0ef          	jal	80002fd0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040dc:	2905                	addiw	s2,s2,1
    800040de:	0a91                	addi	s5,s5,4
    800040e0:	028a2783          	lw	a5,40(s4)
    800040e4:	faf94ae3          	blt	s2,a5,80004098 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800040e8:	cd9ff0ef          	jal	80003dc0 <write_head>
    install_trans(0); // Now install writes to home locations
    800040ec:	4501                	li	a0,0
    800040ee:	d31ff0ef          	jal	80003e1e <install_trans>
    log.lh.n = 0;
    800040f2:	0001f797          	auipc	a5,0x1f
    800040f6:	9207af23          	sw	zero,-1730(a5) # 80022a30 <log+0x28>
    write_head();    // Erase the transaction from the log
    800040fa:	cc7ff0ef          	jal	80003dc0 <write_head>
    800040fe:	69e2                	ld	s3,24(sp)
    80004100:	6a42                	ld	s4,16(sp)
    80004102:	6aa2                	ld	s5,8(sp)
    80004104:	bf29                	j	8000401e <end_op+0x42>

0000000080004106 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004106:	1101                	addi	sp,sp,-32
    80004108:	ec06                	sd	ra,24(sp)
    8000410a:	e822                	sd	s0,16(sp)
    8000410c:	e426                	sd	s1,8(sp)
    8000410e:	1000                	addi	s0,sp,32
    80004110:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004112:	0001f517          	auipc	a0,0x1f
    80004116:	8f650513          	addi	a0,a0,-1802 # 80022a08 <log>
    8000411a:	b0ffc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000411e:	0001f617          	auipc	a2,0x1f
    80004122:	91262603          	lw	a2,-1774(a2) # 80022a30 <log+0x28>
    80004126:	47f5                	li	a5,29
    80004128:	04c7cd63          	blt	a5,a2,80004182 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000412c:	0001f797          	auipc	a5,0x1f
    80004130:	8f87a783          	lw	a5,-1800(a5) # 80022a24 <log+0x1c>
    80004134:	04f05d63          	blez	a5,8000418e <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004138:	4781                	li	a5,0
    8000413a:	06c05063          	blez	a2,8000419a <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000413e:	44cc                	lw	a1,12(s1)
    80004140:	0001f717          	auipc	a4,0x1f
    80004144:	8f470713          	addi	a4,a4,-1804 # 80022a34 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004148:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000414a:	4314                	lw	a3,0(a4)
    8000414c:	04b68763          	beq	a3,a1,8000419a <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80004150:	2785                	addiw	a5,a5,1
    80004152:	0711                	addi	a4,a4,4
    80004154:	fef61be3          	bne	a2,a5,8000414a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004158:	060a                	slli	a2,a2,0x2
    8000415a:	02060613          	addi	a2,a2,32
    8000415e:	0001f797          	auipc	a5,0x1f
    80004162:	8aa78793          	addi	a5,a5,-1878 # 80022a08 <log>
    80004166:	97b2                	add	a5,a5,a2
    80004168:	44d8                	lw	a4,12(s1)
    8000416a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000416c:	8526                	mv	a0,s1
    8000416e:	ee7fe0ef          	jal	80003054 <bpin>
    log.lh.n++;
    80004172:	0001f717          	auipc	a4,0x1f
    80004176:	89670713          	addi	a4,a4,-1898 # 80022a08 <log>
    8000417a:	571c                	lw	a5,40(a4)
    8000417c:	2785                	addiw	a5,a5,1
    8000417e:	d71c                	sw	a5,40(a4)
    80004180:	a815                	j	800041b4 <log_write+0xae>
    panic("too big a transaction");
    80004182:	00003517          	auipc	a0,0x3
    80004186:	55e50513          	addi	a0,a0,1374 # 800076e0 <etext+0x6e0>
    8000418a:	e9afc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    8000418e:	00003517          	auipc	a0,0x3
    80004192:	56a50513          	addi	a0,a0,1386 # 800076f8 <etext+0x6f8>
    80004196:	e8efc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    8000419a:	00279693          	slli	a3,a5,0x2
    8000419e:	02068693          	addi	a3,a3,32
    800041a2:	0001f717          	auipc	a4,0x1f
    800041a6:	86670713          	addi	a4,a4,-1946 # 80022a08 <log>
    800041aa:	9736                	add	a4,a4,a3
    800041ac:	44d4                	lw	a3,12(s1)
    800041ae:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800041b0:	faf60ee3          	beq	a2,a5,8000416c <log_write+0x66>
  }
  release(&log.lock);
    800041b4:	0001f517          	auipc	a0,0x1f
    800041b8:	85450513          	addi	a0,a0,-1964 # 80022a08 <log>
    800041bc:	b01fc0ef          	jal	80000cbc <release>
}
    800041c0:	60e2                	ld	ra,24(sp)
    800041c2:	6442                	ld	s0,16(sp)
    800041c4:	64a2                	ld	s1,8(sp)
    800041c6:	6105                	addi	sp,sp,32
    800041c8:	8082                	ret

00000000800041ca <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800041ca:	1101                	addi	sp,sp,-32
    800041cc:	ec06                	sd	ra,24(sp)
    800041ce:	e822                	sd	s0,16(sp)
    800041d0:	e426                	sd	s1,8(sp)
    800041d2:	e04a                	sd	s2,0(sp)
    800041d4:	1000                	addi	s0,sp,32
    800041d6:	84aa                	mv	s1,a0
    800041d8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800041da:	00003597          	auipc	a1,0x3
    800041de:	53e58593          	addi	a1,a1,1342 # 80007718 <etext+0x718>
    800041e2:	0521                	addi	a0,a0,8
    800041e4:	9bbfc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    800041e8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800041ec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800041f0:	0204a423          	sw	zero,40(s1)
}
    800041f4:	60e2                	ld	ra,24(sp)
    800041f6:	6442                	ld	s0,16(sp)
    800041f8:	64a2                	ld	s1,8(sp)
    800041fa:	6902                	ld	s2,0(sp)
    800041fc:	6105                	addi	sp,sp,32
    800041fe:	8082                	ret

0000000080004200 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004200:	1101                	addi	sp,sp,-32
    80004202:	ec06                	sd	ra,24(sp)
    80004204:	e822                	sd	s0,16(sp)
    80004206:	e426                	sd	s1,8(sp)
    80004208:	e04a                	sd	s2,0(sp)
    8000420a:	1000                	addi	s0,sp,32
    8000420c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000420e:	00850913          	addi	s2,a0,8
    80004212:	854a                	mv	a0,s2
    80004214:	a15fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004218:	409c                	lw	a5,0(s1)
    8000421a:	c799                	beqz	a5,80004228 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000421c:	85ca                	mv	a1,s2
    8000421e:	8526                	mv	a0,s1
    80004220:	f0dfd0ef          	jal	8000212c <sleep>
  while (lk->locked) {
    80004224:	409c                	lw	a5,0(s1)
    80004226:	fbfd                	bnez	a5,8000421c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004228:	4785                	li	a5,1
    8000422a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000422c:	8b1fd0ef          	jal	80001adc <myproc>
    80004230:	591c                	lw	a5,48(a0)
    80004232:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004234:	854a                	mv	a0,s2
    80004236:	a87fc0ef          	jal	80000cbc <release>
}
    8000423a:	60e2                	ld	ra,24(sp)
    8000423c:	6442                	ld	s0,16(sp)
    8000423e:	64a2                	ld	s1,8(sp)
    80004240:	6902                	ld	s2,0(sp)
    80004242:	6105                	addi	sp,sp,32
    80004244:	8082                	ret

0000000080004246 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004246:	1101                	addi	sp,sp,-32
    80004248:	ec06                	sd	ra,24(sp)
    8000424a:	e822                	sd	s0,16(sp)
    8000424c:	e426                	sd	s1,8(sp)
    8000424e:	e04a                	sd	s2,0(sp)
    80004250:	1000                	addi	s0,sp,32
    80004252:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004254:	00850913          	addi	s2,a0,8
    80004258:	854a                	mv	a0,s2
    8000425a:	9cffc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    8000425e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004262:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004266:	8526                	mv	a0,s1
    80004268:	f11fd0ef          	jal	80002178 <wakeup>
  release(&lk->lk);
    8000426c:	854a                	mv	a0,s2
    8000426e:	a4ffc0ef          	jal	80000cbc <release>
}
    80004272:	60e2                	ld	ra,24(sp)
    80004274:	6442                	ld	s0,16(sp)
    80004276:	64a2                	ld	s1,8(sp)
    80004278:	6902                	ld	s2,0(sp)
    8000427a:	6105                	addi	sp,sp,32
    8000427c:	8082                	ret

000000008000427e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000427e:	7179                	addi	sp,sp,-48
    80004280:	f406                	sd	ra,40(sp)
    80004282:	f022                	sd	s0,32(sp)
    80004284:	ec26                	sd	s1,24(sp)
    80004286:	e84a                	sd	s2,16(sp)
    80004288:	1800                	addi	s0,sp,48
    8000428a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000428c:	00850913          	addi	s2,a0,8
    80004290:	854a                	mv	a0,s2
    80004292:	997fc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004296:	409c                	lw	a5,0(s1)
    80004298:	ef81                	bnez	a5,800042b0 <holdingsleep+0x32>
    8000429a:	4481                	li	s1,0
  release(&lk->lk);
    8000429c:	854a                	mv	a0,s2
    8000429e:	a1ffc0ef          	jal	80000cbc <release>
  return r;
}
    800042a2:	8526                	mv	a0,s1
    800042a4:	70a2                	ld	ra,40(sp)
    800042a6:	7402                	ld	s0,32(sp)
    800042a8:	64e2                	ld	s1,24(sp)
    800042aa:	6942                	ld	s2,16(sp)
    800042ac:	6145                	addi	sp,sp,48
    800042ae:	8082                	ret
    800042b0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800042b2:	0284a983          	lw	s3,40(s1)
    800042b6:	827fd0ef          	jal	80001adc <myproc>
    800042ba:	5904                	lw	s1,48(a0)
    800042bc:	413484b3          	sub	s1,s1,s3
    800042c0:	0014b493          	seqz	s1,s1
    800042c4:	69a2                	ld	s3,8(sp)
    800042c6:	bfd9                	j	8000429c <holdingsleep+0x1e>

00000000800042c8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800042c8:	1141                	addi	sp,sp,-16
    800042ca:	e406                	sd	ra,8(sp)
    800042cc:	e022                	sd	s0,0(sp)
    800042ce:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800042d0:	00003597          	auipc	a1,0x3
    800042d4:	45858593          	addi	a1,a1,1112 # 80007728 <etext+0x728>
    800042d8:	0001f517          	auipc	a0,0x1f
    800042dc:	87850513          	addi	a0,a0,-1928 # 80022b50 <ftable>
    800042e0:	8bffc0ef          	jal	80000b9e <initlock>
}
    800042e4:	60a2                	ld	ra,8(sp)
    800042e6:	6402                	ld	s0,0(sp)
    800042e8:	0141                	addi	sp,sp,16
    800042ea:	8082                	ret

00000000800042ec <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800042ec:	1101                	addi	sp,sp,-32
    800042ee:	ec06                	sd	ra,24(sp)
    800042f0:	e822                	sd	s0,16(sp)
    800042f2:	e426                	sd	s1,8(sp)
    800042f4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800042f6:	0001f517          	auipc	a0,0x1f
    800042fa:	85a50513          	addi	a0,a0,-1958 # 80022b50 <ftable>
    800042fe:	92bfc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004302:	0001f497          	auipc	s1,0x1f
    80004306:	86648493          	addi	s1,s1,-1946 # 80022b68 <ftable+0x18>
    8000430a:	0001f717          	auipc	a4,0x1f
    8000430e:	7fe70713          	addi	a4,a4,2046 # 80023b08 <disk>
    if(f->ref == 0){
    80004312:	40dc                	lw	a5,4(s1)
    80004314:	cf89                	beqz	a5,8000432e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004316:	02848493          	addi	s1,s1,40
    8000431a:	fee49ce3          	bne	s1,a4,80004312 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000431e:	0001f517          	auipc	a0,0x1f
    80004322:	83250513          	addi	a0,a0,-1998 # 80022b50 <ftable>
    80004326:	997fc0ef          	jal	80000cbc <release>
  return 0;
    8000432a:	4481                	li	s1,0
    8000432c:	a809                	j	8000433e <filealloc+0x52>
      f->ref = 1;
    8000432e:	4785                	li	a5,1
    80004330:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004332:	0001f517          	auipc	a0,0x1f
    80004336:	81e50513          	addi	a0,a0,-2018 # 80022b50 <ftable>
    8000433a:	983fc0ef          	jal	80000cbc <release>
}
    8000433e:	8526                	mv	a0,s1
    80004340:	60e2                	ld	ra,24(sp)
    80004342:	6442                	ld	s0,16(sp)
    80004344:	64a2                	ld	s1,8(sp)
    80004346:	6105                	addi	sp,sp,32
    80004348:	8082                	ret

000000008000434a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000434a:	1101                	addi	sp,sp,-32
    8000434c:	ec06                	sd	ra,24(sp)
    8000434e:	e822                	sd	s0,16(sp)
    80004350:	e426                	sd	s1,8(sp)
    80004352:	1000                	addi	s0,sp,32
    80004354:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004356:	0001e517          	auipc	a0,0x1e
    8000435a:	7fa50513          	addi	a0,a0,2042 # 80022b50 <ftable>
    8000435e:	8cbfc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004362:	40dc                	lw	a5,4(s1)
    80004364:	02f05063          	blez	a5,80004384 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004368:	2785                	addiw	a5,a5,1
    8000436a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000436c:	0001e517          	auipc	a0,0x1e
    80004370:	7e450513          	addi	a0,a0,2020 # 80022b50 <ftable>
    80004374:	949fc0ef          	jal	80000cbc <release>
  return f;
}
    80004378:	8526                	mv	a0,s1
    8000437a:	60e2                	ld	ra,24(sp)
    8000437c:	6442                	ld	s0,16(sp)
    8000437e:	64a2                	ld	s1,8(sp)
    80004380:	6105                	addi	sp,sp,32
    80004382:	8082                	ret
    panic("filedup");
    80004384:	00003517          	auipc	a0,0x3
    80004388:	3ac50513          	addi	a0,a0,940 # 80007730 <etext+0x730>
    8000438c:	c98fc0ef          	jal	80000824 <panic>

0000000080004390 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004390:	7139                	addi	sp,sp,-64
    80004392:	fc06                	sd	ra,56(sp)
    80004394:	f822                	sd	s0,48(sp)
    80004396:	f426                	sd	s1,40(sp)
    80004398:	0080                	addi	s0,sp,64
    8000439a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000439c:	0001e517          	auipc	a0,0x1e
    800043a0:	7b450513          	addi	a0,a0,1972 # 80022b50 <ftable>
    800043a4:	885fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    800043a8:	40dc                	lw	a5,4(s1)
    800043aa:	04f05a63          	blez	a5,800043fe <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800043ae:	37fd                	addiw	a5,a5,-1
    800043b0:	c0dc                	sw	a5,4(s1)
    800043b2:	06f04063          	bgtz	a5,80004412 <fileclose+0x82>
    800043b6:	f04a                	sd	s2,32(sp)
    800043b8:	ec4e                	sd	s3,24(sp)
    800043ba:	e852                	sd	s4,16(sp)
    800043bc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800043be:	0004a903          	lw	s2,0(s1)
    800043c2:	0094c783          	lbu	a5,9(s1)
    800043c6:	89be                	mv	s3,a5
    800043c8:	689c                	ld	a5,16(s1)
    800043ca:	8a3e                	mv	s4,a5
    800043cc:	6c9c                	ld	a5,24(s1)
    800043ce:	8abe                	mv	s5,a5
  f->ref = 0;
    800043d0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800043d4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800043d8:	0001e517          	auipc	a0,0x1e
    800043dc:	77850513          	addi	a0,a0,1912 # 80022b50 <ftable>
    800043e0:	8ddfc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    800043e4:	4785                	li	a5,1
    800043e6:	04f90163          	beq	s2,a5,80004428 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800043ea:	ffe9079b          	addiw	a5,s2,-2
    800043ee:	4705                	li	a4,1
    800043f0:	04f77563          	bgeu	a4,a5,8000443a <fileclose+0xaa>
    800043f4:	7902                	ld	s2,32(sp)
    800043f6:	69e2                	ld	s3,24(sp)
    800043f8:	6a42                	ld	s4,16(sp)
    800043fa:	6aa2                	ld	s5,8(sp)
    800043fc:	a00d                	j	8000441e <fileclose+0x8e>
    800043fe:	f04a                	sd	s2,32(sp)
    80004400:	ec4e                	sd	s3,24(sp)
    80004402:	e852                	sd	s4,16(sp)
    80004404:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004406:	00003517          	auipc	a0,0x3
    8000440a:	33250513          	addi	a0,a0,818 # 80007738 <etext+0x738>
    8000440e:	c16fc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004412:	0001e517          	auipc	a0,0x1e
    80004416:	73e50513          	addi	a0,a0,1854 # 80022b50 <ftable>
    8000441a:	8a3fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000441e:	70e2                	ld	ra,56(sp)
    80004420:	7442                	ld	s0,48(sp)
    80004422:	74a2                	ld	s1,40(sp)
    80004424:	6121                	addi	sp,sp,64
    80004426:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004428:	85ce                	mv	a1,s3
    8000442a:	8552                	mv	a0,s4
    8000442c:	348000ef          	jal	80004774 <pipeclose>
    80004430:	7902                	ld	s2,32(sp)
    80004432:	69e2                	ld	s3,24(sp)
    80004434:	6a42                	ld	s4,16(sp)
    80004436:	6aa2                	ld	s5,8(sp)
    80004438:	b7dd                	j	8000441e <fileclose+0x8e>
    begin_op();
    8000443a:	b33ff0ef          	jal	80003f6c <begin_op>
    iput(ff.ip);
    8000443e:	8556                	mv	a0,s5
    80004440:	aa2ff0ef          	jal	800036e2 <iput>
    end_op();
    80004444:	b99ff0ef          	jal	80003fdc <end_op>
    80004448:	7902                	ld	s2,32(sp)
    8000444a:	69e2                	ld	s3,24(sp)
    8000444c:	6a42                	ld	s4,16(sp)
    8000444e:	6aa2                	ld	s5,8(sp)
    80004450:	b7f9                	j	8000441e <fileclose+0x8e>

0000000080004452 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004452:	715d                	addi	sp,sp,-80
    80004454:	e486                	sd	ra,72(sp)
    80004456:	e0a2                	sd	s0,64(sp)
    80004458:	fc26                	sd	s1,56(sp)
    8000445a:	f052                	sd	s4,32(sp)
    8000445c:	0880                	addi	s0,sp,80
    8000445e:	84aa                	mv	s1,a0
    80004460:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004462:	e7afd0ef          	jal	80001adc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004466:	409c                	lw	a5,0(s1)
    80004468:	37f9                	addiw	a5,a5,-2
    8000446a:	4705                	li	a4,1
    8000446c:	04f76263          	bltu	a4,a5,800044b0 <filestat+0x5e>
    80004470:	f84a                	sd	s2,48(sp)
    80004472:	f44e                	sd	s3,40(sp)
    80004474:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004476:	6c88                	ld	a0,24(s1)
    80004478:	8e8ff0ef          	jal	80003560 <ilock>
    stati(f->ip, &st);
    8000447c:	fb840913          	addi	s2,s0,-72
    80004480:	85ca                	mv	a1,s2
    80004482:	6c88                	ld	a0,24(s1)
    80004484:	c40ff0ef          	jal	800038c4 <stati>
    iunlock(f->ip);
    80004488:	6c88                	ld	a0,24(s1)
    8000448a:	984ff0ef          	jal	8000360e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000448e:	46e1                	li	a3,24
    80004490:	864a                	mv	a2,s2
    80004492:	85d2                	mv	a1,s4
    80004494:	0509b503          	ld	a0,80(s3)
    80004498:	a70fd0ef          	jal	80001708 <copyout>
    8000449c:	41f5551b          	sraiw	a0,a0,0x1f
    800044a0:	7942                	ld	s2,48(sp)
    800044a2:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800044a4:	60a6                	ld	ra,72(sp)
    800044a6:	6406                	ld	s0,64(sp)
    800044a8:	74e2                	ld	s1,56(sp)
    800044aa:	7a02                	ld	s4,32(sp)
    800044ac:	6161                	addi	sp,sp,80
    800044ae:	8082                	ret
  return -1;
    800044b0:	557d                	li	a0,-1
    800044b2:	bfcd                	j	800044a4 <filestat+0x52>

00000000800044b4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800044b4:	7179                	addi	sp,sp,-48
    800044b6:	f406                	sd	ra,40(sp)
    800044b8:	f022                	sd	s0,32(sp)
    800044ba:	e84a                	sd	s2,16(sp)
    800044bc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800044be:	00854783          	lbu	a5,8(a0)
    800044c2:	cfd1                	beqz	a5,8000455e <fileread+0xaa>
    800044c4:	ec26                	sd	s1,24(sp)
    800044c6:	e44e                	sd	s3,8(sp)
    800044c8:	84aa                	mv	s1,a0
    800044ca:	892e                	mv	s2,a1
    800044cc:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800044ce:	411c                	lw	a5,0(a0)
    800044d0:	4705                	li	a4,1
    800044d2:	04e78363          	beq	a5,a4,80004518 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044d6:	470d                	li	a4,3
    800044d8:	04e78763          	beq	a5,a4,80004526 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800044dc:	4709                	li	a4,2
    800044de:	06e79a63          	bne	a5,a4,80004552 <fileread+0x9e>
    ilock(f->ip);
    800044e2:	6d08                	ld	a0,24(a0)
    800044e4:	87cff0ef          	jal	80003560 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800044e8:	874e                	mv	a4,s3
    800044ea:	5094                	lw	a3,32(s1)
    800044ec:	864a                	mv	a2,s2
    800044ee:	4585                	li	a1,1
    800044f0:	6c88                	ld	a0,24(s1)
    800044f2:	c00ff0ef          	jal	800038f2 <readi>
    800044f6:	892a                	mv	s2,a0
    800044f8:	00a05563          	blez	a0,80004502 <fileread+0x4e>
      f->off += r;
    800044fc:	509c                	lw	a5,32(s1)
    800044fe:	9fa9                	addw	a5,a5,a0
    80004500:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004502:	6c88                	ld	a0,24(s1)
    80004504:	90aff0ef          	jal	8000360e <iunlock>
    80004508:	64e2                	ld	s1,24(sp)
    8000450a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000450c:	854a                	mv	a0,s2
    8000450e:	70a2                	ld	ra,40(sp)
    80004510:	7402                	ld	s0,32(sp)
    80004512:	6942                	ld	s2,16(sp)
    80004514:	6145                	addi	sp,sp,48
    80004516:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004518:	6908                	ld	a0,16(a0)
    8000451a:	3b0000ef          	jal	800048ca <piperead>
    8000451e:	892a                	mv	s2,a0
    80004520:	64e2                	ld	s1,24(sp)
    80004522:	69a2                	ld	s3,8(sp)
    80004524:	b7e5                	j	8000450c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004526:	02451783          	lh	a5,36(a0)
    8000452a:	03079693          	slli	a3,a5,0x30
    8000452e:	92c1                	srli	a3,a3,0x30
    80004530:	4725                	li	a4,9
    80004532:	02d76963          	bltu	a4,a3,80004564 <fileread+0xb0>
    80004536:	0792                	slli	a5,a5,0x4
    80004538:	0001e717          	auipc	a4,0x1e
    8000453c:	57870713          	addi	a4,a4,1400 # 80022ab0 <devsw>
    80004540:	97ba                	add	a5,a5,a4
    80004542:	639c                	ld	a5,0(a5)
    80004544:	c78d                	beqz	a5,8000456e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004546:	4505                	li	a0,1
    80004548:	9782                	jalr	a5
    8000454a:	892a                	mv	s2,a0
    8000454c:	64e2                	ld	s1,24(sp)
    8000454e:	69a2                	ld	s3,8(sp)
    80004550:	bf75                	j	8000450c <fileread+0x58>
    panic("fileread");
    80004552:	00003517          	auipc	a0,0x3
    80004556:	1f650513          	addi	a0,a0,502 # 80007748 <etext+0x748>
    8000455a:	acafc0ef          	jal	80000824 <panic>
    return -1;
    8000455e:	57fd                	li	a5,-1
    80004560:	893e                	mv	s2,a5
    80004562:	b76d                	j	8000450c <fileread+0x58>
      return -1;
    80004564:	57fd                	li	a5,-1
    80004566:	893e                	mv	s2,a5
    80004568:	64e2                	ld	s1,24(sp)
    8000456a:	69a2                	ld	s3,8(sp)
    8000456c:	b745                	j	8000450c <fileread+0x58>
    8000456e:	57fd                	li	a5,-1
    80004570:	893e                	mv	s2,a5
    80004572:	64e2                	ld	s1,24(sp)
    80004574:	69a2                	ld	s3,8(sp)
    80004576:	bf59                	j	8000450c <fileread+0x58>

0000000080004578 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004578:	00954783          	lbu	a5,9(a0)
    8000457c:	10078f63          	beqz	a5,8000469a <filewrite+0x122>
{
    80004580:	711d                	addi	sp,sp,-96
    80004582:	ec86                	sd	ra,88(sp)
    80004584:	e8a2                	sd	s0,80(sp)
    80004586:	e0ca                	sd	s2,64(sp)
    80004588:	f456                	sd	s5,40(sp)
    8000458a:	f05a                	sd	s6,32(sp)
    8000458c:	1080                	addi	s0,sp,96
    8000458e:	892a                	mv	s2,a0
    80004590:	8b2e                	mv	s6,a1
    80004592:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004594:	411c                	lw	a5,0(a0)
    80004596:	4705                	li	a4,1
    80004598:	02e78a63          	beq	a5,a4,800045cc <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000459c:	470d                	li	a4,3
    8000459e:	02e78b63          	beq	a5,a4,800045d4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800045a2:	4709                	li	a4,2
    800045a4:	0ce79f63          	bne	a5,a4,80004682 <filewrite+0x10a>
    800045a8:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800045aa:	0ac05a63          	blez	a2,8000465e <filewrite+0xe6>
    800045ae:	e4a6                	sd	s1,72(sp)
    800045b0:	fc4e                	sd	s3,56(sp)
    800045b2:	ec5e                	sd	s7,24(sp)
    800045b4:	e862                	sd	s8,16(sp)
    800045b6:	e466                	sd	s9,8(sp)
    int i = 0;
    800045b8:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800045ba:	6b85                	lui	s7,0x1
    800045bc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800045c0:	6785                	lui	a5,0x1
    800045c2:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800045c6:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800045c8:	4c05                	li	s8,1
    800045ca:	a8ad                	j	80004644 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800045cc:	6908                	ld	a0,16(a0)
    800045ce:	204000ef          	jal	800047d2 <pipewrite>
    800045d2:	a04d                	j	80004674 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800045d4:	02451783          	lh	a5,36(a0)
    800045d8:	03079693          	slli	a3,a5,0x30
    800045dc:	92c1                	srli	a3,a3,0x30
    800045de:	4725                	li	a4,9
    800045e0:	0ad76f63          	bltu	a4,a3,8000469e <filewrite+0x126>
    800045e4:	0792                	slli	a5,a5,0x4
    800045e6:	0001e717          	auipc	a4,0x1e
    800045ea:	4ca70713          	addi	a4,a4,1226 # 80022ab0 <devsw>
    800045ee:	97ba                	add	a5,a5,a4
    800045f0:	679c                	ld	a5,8(a5)
    800045f2:	cbc5                	beqz	a5,800046a2 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800045f4:	4505                	li	a0,1
    800045f6:	9782                	jalr	a5
    800045f8:	a8b5                	j	80004674 <filewrite+0xfc>
      if(n1 > max)
    800045fa:	2981                	sext.w	s3,s3
      begin_op();
    800045fc:	971ff0ef          	jal	80003f6c <begin_op>
      ilock(f->ip);
    80004600:	01893503          	ld	a0,24(s2)
    80004604:	f5dfe0ef          	jal	80003560 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004608:	874e                	mv	a4,s3
    8000460a:	02092683          	lw	a3,32(s2)
    8000460e:	016a0633          	add	a2,s4,s6
    80004612:	85e2                	mv	a1,s8
    80004614:	01893503          	ld	a0,24(s2)
    80004618:	bccff0ef          	jal	800039e4 <writei>
    8000461c:	84aa                	mv	s1,a0
    8000461e:	00a05763          	blez	a0,8000462c <filewrite+0xb4>
        f->off += r;
    80004622:	02092783          	lw	a5,32(s2)
    80004626:	9fa9                	addw	a5,a5,a0
    80004628:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000462c:	01893503          	ld	a0,24(s2)
    80004630:	fdffe0ef          	jal	8000360e <iunlock>
      end_op();
    80004634:	9a9ff0ef          	jal	80003fdc <end_op>

      if(r != n1){
    80004638:	02999563          	bne	s3,s1,80004662 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000463c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004640:	015a5963          	bge	s4,s5,80004652 <filewrite+0xda>
      int n1 = n - i;
    80004644:	414a87bb          	subw	a5,s5,s4
    80004648:	89be                	mv	s3,a5
      if(n1 > max)
    8000464a:	fafbd8e3          	bge	s7,a5,800045fa <filewrite+0x82>
    8000464e:	89e6                	mv	s3,s9
    80004650:	b76d                	j	800045fa <filewrite+0x82>
    80004652:	64a6                	ld	s1,72(sp)
    80004654:	79e2                	ld	s3,56(sp)
    80004656:	6be2                	ld	s7,24(sp)
    80004658:	6c42                	ld	s8,16(sp)
    8000465a:	6ca2                	ld	s9,8(sp)
    8000465c:	a801                	j	8000466c <filewrite+0xf4>
    int i = 0;
    8000465e:	4a01                	li	s4,0
    80004660:	a031                	j	8000466c <filewrite+0xf4>
    80004662:	64a6                	ld	s1,72(sp)
    80004664:	79e2                	ld	s3,56(sp)
    80004666:	6be2                	ld	s7,24(sp)
    80004668:	6c42                	ld	s8,16(sp)
    8000466a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000466c:	034a9d63          	bne	s5,s4,800046a6 <filewrite+0x12e>
    80004670:	8556                	mv	a0,s5
    80004672:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004674:	60e6                	ld	ra,88(sp)
    80004676:	6446                	ld	s0,80(sp)
    80004678:	6906                	ld	s2,64(sp)
    8000467a:	7aa2                	ld	s5,40(sp)
    8000467c:	7b02                	ld	s6,32(sp)
    8000467e:	6125                	addi	sp,sp,96
    80004680:	8082                	ret
    80004682:	e4a6                	sd	s1,72(sp)
    80004684:	fc4e                	sd	s3,56(sp)
    80004686:	f852                	sd	s4,48(sp)
    80004688:	ec5e                	sd	s7,24(sp)
    8000468a:	e862                	sd	s8,16(sp)
    8000468c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000468e:	00003517          	auipc	a0,0x3
    80004692:	0ca50513          	addi	a0,a0,202 # 80007758 <etext+0x758>
    80004696:	98efc0ef          	jal	80000824 <panic>
    return -1;
    8000469a:	557d                	li	a0,-1
}
    8000469c:	8082                	ret
      return -1;
    8000469e:	557d                	li	a0,-1
    800046a0:	bfd1                	j	80004674 <filewrite+0xfc>
    800046a2:	557d                	li	a0,-1
    800046a4:	bfc1                	j	80004674 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800046a6:	557d                	li	a0,-1
    800046a8:	7a42                	ld	s4,48(sp)
    800046aa:	b7e9                	j	80004674 <filewrite+0xfc>

00000000800046ac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800046ac:	7179                	addi	sp,sp,-48
    800046ae:	f406                	sd	ra,40(sp)
    800046b0:	f022                	sd	s0,32(sp)
    800046b2:	ec26                	sd	s1,24(sp)
    800046b4:	e052                	sd	s4,0(sp)
    800046b6:	1800                	addi	s0,sp,48
    800046b8:	84aa                	mv	s1,a0
    800046ba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800046bc:	0005b023          	sd	zero,0(a1)
    800046c0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800046c4:	c29ff0ef          	jal	800042ec <filealloc>
    800046c8:	e088                	sd	a0,0(s1)
    800046ca:	c549                	beqz	a0,80004754 <pipealloc+0xa8>
    800046cc:	c21ff0ef          	jal	800042ec <filealloc>
    800046d0:	00aa3023          	sd	a0,0(s4)
    800046d4:	cd25                	beqz	a0,8000474c <pipealloc+0xa0>
    800046d6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800046d8:	c6cfc0ef          	jal	80000b44 <kalloc>
    800046dc:	892a                	mv	s2,a0
    800046de:	c12d                	beqz	a0,80004740 <pipealloc+0x94>
    800046e0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800046e2:	4985                	li	s3,1
    800046e4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800046e8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800046ec:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800046f0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800046f4:	00003597          	auipc	a1,0x3
    800046f8:	07458593          	addi	a1,a1,116 # 80007768 <etext+0x768>
    800046fc:	ca2fc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004700:	609c                	ld	a5,0(s1)
    80004702:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004706:	609c                	ld	a5,0(s1)
    80004708:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000470c:	609c                	ld	a5,0(s1)
    8000470e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004712:	609c                	ld	a5,0(s1)
    80004714:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004718:	000a3783          	ld	a5,0(s4)
    8000471c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004720:	000a3783          	ld	a5,0(s4)
    80004724:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004728:	000a3783          	ld	a5,0(s4)
    8000472c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004730:	000a3783          	ld	a5,0(s4)
    80004734:	0127b823          	sd	s2,16(a5)
  return 0;
    80004738:	4501                	li	a0,0
    8000473a:	6942                	ld	s2,16(sp)
    8000473c:	69a2                	ld	s3,8(sp)
    8000473e:	a01d                	j	80004764 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004740:	6088                	ld	a0,0(s1)
    80004742:	c119                	beqz	a0,80004748 <pipealloc+0x9c>
    80004744:	6942                	ld	s2,16(sp)
    80004746:	a029                	j	80004750 <pipealloc+0xa4>
    80004748:	6942                	ld	s2,16(sp)
    8000474a:	a029                	j	80004754 <pipealloc+0xa8>
    8000474c:	6088                	ld	a0,0(s1)
    8000474e:	c10d                	beqz	a0,80004770 <pipealloc+0xc4>
    fileclose(*f0);
    80004750:	c41ff0ef          	jal	80004390 <fileclose>
  if(*f1)
    80004754:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004758:	557d                	li	a0,-1
  if(*f1)
    8000475a:	c789                	beqz	a5,80004764 <pipealloc+0xb8>
    fileclose(*f1);
    8000475c:	853e                	mv	a0,a5
    8000475e:	c33ff0ef          	jal	80004390 <fileclose>
  return -1;
    80004762:	557d                	li	a0,-1
}
    80004764:	70a2                	ld	ra,40(sp)
    80004766:	7402                	ld	s0,32(sp)
    80004768:	64e2                	ld	s1,24(sp)
    8000476a:	6a02                	ld	s4,0(sp)
    8000476c:	6145                	addi	sp,sp,48
    8000476e:	8082                	ret
  return -1;
    80004770:	557d                	li	a0,-1
    80004772:	bfcd                	j	80004764 <pipealloc+0xb8>

0000000080004774 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004774:	1101                	addi	sp,sp,-32
    80004776:	ec06                	sd	ra,24(sp)
    80004778:	e822                	sd	s0,16(sp)
    8000477a:	e426                	sd	s1,8(sp)
    8000477c:	e04a                	sd	s2,0(sp)
    8000477e:	1000                	addi	s0,sp,32
    80004780:	84aa                	mv	s1,a0
    80004782:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004784:	ca4fc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004788:	02090763          	beqz	s2,800047b6 <pipeclose+0x42>
    pi->writeopen = 0;
    8000478c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004790:	21848513          	addi	a0,s1,536
    80004794:	9e5fd0ef          	jal	80002178 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004798:	2204a783          	lw	a5,544(s1)
    8000479c:	e781                	bnez	a5,800047a4 <pipeclose+0x30>
    8000479e:	2244a783          	lw	a5,548(s1)
    800047a2:	c38d                	beqz	a5,800047c4 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800047a4:	8526                	mv	a0,s1
    800047a6:	d16fc0ef          	jal	80000cbc <release>
}
    800047aa:	60e2                	ld	ra,24(sp)
    800047ac:	6442                	ld	s0,16(sp)
    800047ae:	64a2                	ld	s1,8(sp)
    800047b0:	6902                	ld	s2,0(sp)
    800047b2:	6105                	addi	sp,sp,32
    800047b4:	8082                	ret
    pi->readopen = 0;
    800047b6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800047ba:	21c48513          	addi	a0,s1,540
    800047be:	9bbfd0ef          	jal	80002178 <wakeup>
    800047c2:	bfd9                	j	80004798 <pipeclose+0x24>
    release(&pi->lock);
    800047c4:	8526                	mv	a0,s1
    800047c6:	cf6fc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    800047ca:	8526                	mv	a0,s1
    800047cc:	a90fc0ef          	jal	80000a5c <kfree>
    800047d0:	bfe9                	j	800047aa <pipeclose+0x36>

00000000800047d2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800047d2:	7159                	addi	sp,sp,-112
    800047d4:	f486                	sd	ra,104(sp)
    800047d6:	f0a2                	sd	s0,96(sp)
    800047d8:	eca6                	sd	s1,88(sp)
    800047da:	e8ca                	sd	s2,80(sp)
    800047dc:	e4ce                	sd	s3,72(sp)
    800047de:	e0d2                	sd	s4,64(sp)
    800047e0:	fc56                	sd	s5,56(sp)
    800047e2:	1880                	addi	s0,sp,112
    800047e4:	84aa                	mv	s1,a0
    800047e6:	8aae                	mv	s5,a1
    800047e8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800047ea:	af2fd0ef          	jal	80001adc <myproc>
    800047ee:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800047f0:	8526                	mv	a0,s1
    800047f2:	c36fc0ef          	jal	80000c28 <acquire>
  while(i < n){
    800047f6:	0d405263          	blez	s4,800048ba <pipewrite+0xe8>
    800047fa:	f85a                	sd	s6,48(sp)
    800047fc:	f45e                	sd	s7,40(sp)
    800047fe:	f062                	sd	s8,32(sp)
    80004800:	ec66                	sd	s9,24(sp)
    80004802:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004804:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004806:	f9f40c13          	addi	s8,s0,-97
    8000480a:	4b85                	li	s7,1
    8000480c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000480e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004812:	21c48c93          	addi	s9,s1,540
    80004816:	a82d                	j	80004850 <pipewrite+0x7e>
      release(&pi->lock);
    80004818:	8526                	mv	a0,s1
    8000481a:	ca2fc0ef          	jal	80000cbc <release>
      return -1;
    8000481e:	597d                	li	s2,-1
    80004820:	7b42                	ld	s6,48(sp)
    80004822:	7ba2                	ld	s7,40(sp)
    80004824:	7c02                	ld	s8,32(sp)
    80004826:	6ce2                	ld	s9,24(sp)
    80004828:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000482a:	854a                	mv	a0,s2
    8000482c:	70a6                	ld	ra,104(sp)
    8000482e:	7406                	ld	s0,96(sp)
    80004830:	64e6                	ld	s1,88(sp)
    80004832:	6946                	ld	s2,80(sp)
    80004834:	69a6                	ld	s3,72(sp)
    80004836:	6a06                	ld	s4,64(sp)
    80004838:	7ae2                	ld	s5,56(sp)
    8000483a:	6165                	addi	sp,sp,112
    8000483c:	8082                	ret
      wakeup(&pi->nread);
    8000483e:	856a                	mv	a0,s10
    80004840:	939fd0ef          	jal	80002178 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004844:	85a6                	mv	a1,s1
    80004846:	8566                	mv	a0,s9
    80004848:	8e5fd0ef          	jal	8000212c <sleep>
  while(i < n){
    8000484c:	05495a63          	bge	s2,s4,800048a0 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004850:	2204a783          	lw	a5,544(s1)
    80004854:	d3f1                	beqz	a5,80004818 <pipewrite+0x46>
    80004856:	854e                	mv	a0,s3
    80004858:	b1ffd0ef          	jal	80002376 <killed>
    8000485c:	fd55                	bnez	a0,80004818 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000485e:	2184a783          	lw	a5,536(s1)
    80004862:	21c4a703          	lw	a4,540(s1)
    80004866:	2007879b          	addiw	a5,a5,512
    8000486a:	fcf70ae3          	beq	a4,a5,8000483e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000486e:	86de                	mv	a3,s7
    80004870:	01590633          	add	a2,s2,s5
    80004874:	85e2                	mv	a1,s8
    80004876:	0509b503          	ld	a0,80(s3)
    8000487a:	f57fc0ef          	jal	800017d0 <copyin>
    8000487e:	05650063          	beq	a0,s6,800048be <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004882:	21c4a783          	lw	a5,540(s1)
    80004886:	0017871b          	addiw	a4,a5,1
    8000488a:	20e4ae23          	sw	a4,540(s1)
    8000488e:	1ff7f793          	andi	a5,a5,511
    80004892:	97a6                	add	a5,a5,s1
    80004894:	f9f44703          	lbu	a4,-97(s0)
    80004898:	00e78c23          	sb	a4,24(a5)
      i++;
    8000489c:	2905                	addiw	s2,s2,1
    8000489e:	b77d                	j	8000484c <pipewrite+0x7a>
    800048a0:	7b42                	ld	s6,48(sp)
    800048a2:	7ba2                	ld	s7,40(sp)
    800048a4:	7c02                	ld	s8,32(sp)
    800048a6:	6ce2                	ld	s9,24(sp)
    800048a8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800048aa:	21848513          	addi	a0,s1,536
    800048ae:	8cbfd0ef          	jal	80002178 <wakeup>
  release(&pi->lock);
    800048b2:	8526                	mv	a0,s1
    800048b4:	c08fc0ef          	jal	80000cbc <release>
  return i;
    800048b8:	bf8d                	j	8000482a <pipewrite+0x58>
  int i = 0;
    800048ba:	4901                	li	s2,0
    800048bc:	b7fd                	j	800048aa <pipewrite+0xd8>
    800048be:	7b42                	ld	s6,48(sp)
    800048c0:	7ba2                	ld	s7,40(sp)
    800048c2:	7c02                	ld	s8,32(sp)
    800048c4:	6ce2                	ld	s9,24(sp)
    800048c6:	6d42                	ld	s10,16(sp)
    800048c8:	b7cd                	j	800048aa <pipewrite+0xd8>

00000000800048ca <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800048ca:	711d                	addi	sp,sp,-96
    800048cc:	ec86                	sd	ra,88(sp)
    800048ce:	e8a2                	sd	s0,80(sp)
    800048d0:	e4a6                	sd	s1,72(sp)
    800048d2:	e0ca                	sd	s2,64(sp)
    800048d4:	fc4e                	sd	s3,56(sp)
    800048d6:	f852                	sd	s4,48(sp)
    800048d8:	f456                	sd	s5,40(sp)
    800048da:	1080                	addi	s0,sp,96
    800048dc:	84aa                	mv	s1,a0
    800048de:	892e                	mv	s2,a1
    800048e0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800048e2:	9fafd0ef          	jal	80001adc <myproc>
    800048e6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800048e8:	8526                	mv	a0,s1
    800048ea:	b3efc0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800048ee:	2184a703          	lw	a4,536(s1)
    800048f2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800048f6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800048fa:	02f71763          	bne	a4,a5,80004928 <piperead+0x5e>
    800048fe:	2244a783          	lw	a5,548(s1)
    80004902:	cf85                	beqz	a5,8000493a <piperead+0x70>
    if(killed(pr)){
    80004904:	8552                	mv	a0,s4
    80004906:	a71fd0ef          	jal	80002376 <killed>
    8000490a:	e11d                	bnez	a0,80004930 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000490c:	85a6                	mv	a1,s1
    8000490e:	854e                	mv	a0,s3
    80004910:	81dfd0ef          	jal	8000212c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004914:	2184a703          	lw	a4,536(s1)
    80004918:	21c4a783          	lw	a5,540(s1)
    8000491c:	fef701e3          	beq	a4,a5,800048fe <piperead+0x34>
    80004920:	f05a                	sd	s6,32(sp)
    80004922:	ec5e                	sd	s7,24(sp)
    80004924:	e862                	sd	s8,16(sp)
    80004926:	a829                	j	80004940 <piperead+0x76>
    80004928:	f05a                	sd	s6,32(sp)
    8000492a:	ec5e                	sd	s7,24(sp)
    8000492c:	e862                	sd	s8,16(sp)
    8000492e:	a809                	j	80004940 <piperead+0x76>
      release(&pi->lock);
    80004930:	8526                	mv	a0,s1
    80004932:	b8afc0ef          	jal	80000cbc <release>
      return -1;
    80004936:	59fd                	li	s3,-1
    80004938:	a0a5                	j	800049a0 <piperead+0xd6>
    8000493a:	f05a                	sd	s6,32(sp)
    8000493c:	ec5e                	sd	s7,24(sp)
    8000493e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004940:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004942:	faf40c13          	addi	s8,s0,-81
    80004946:	4b85                	li	s7,1
    80004948:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000494a:	05505163          	blez	s5,8000498c <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    8000494e:	2184a783          	lw	a5,536(s1)
    80004952:	21c4a703          	lw	a4,540(s1)
    80004956:	02f70b63          	beq	a4,a5,8000498c <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    8000495a:	1ff7f793          	andi	a5,a5,511
    8000495e:	97a6                	add	a5,a5,s1
    80004960:	0187c783          	lbu	a5,24(a5)
    80004964:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004968:	86de                	mv	a3,s7
    8000496a:	8662                	mv	a2,s8
    8000496c:	85ca                	mv	a1,s2
    8000496e:	050a3503          	ld	a0,80(s4)
    80004972:	d97fc0ef          	jal	80001708 <copyout>
    80004976:	03650f63          	beq	a0,s6,800049b4 <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000497a:	2184a783          	lw	a5,536(s1)
    8000497e:	2785                	addiw	a5,a5,1
    80004980:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004984:	2985                	addiw	s3,s3,1
    80004986:	0905                	addi	s2,s2,1
    80004988:	fd3a93e3          	bne	s5,s3,8000494e <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000498c:	21c48513          	addi	a0,s1,540
    80004990:	fe8fd0ef          	jal	80002178 <wakeup>
  release(&pi->lock);
    80004994:	8526                	mv	a0,s1
    80004996:	b26fc0ef          	jal	80000cbc <release>
    8000499a:	7b02                	ld	s6,32(sp)
    8000499c:	6be2                	ld	s7,24(sp)
    8000499e:	6c42                	ld	s8,16(sp)
  return i;
}
    800049a0:	854e                	mv	a0,s3
    800049a2:	60e6                	ld	ra,88(sp)
    800049a4:	6446                	ld	s0,80(sp)
    800049a6:	64a6                	ld	s1,72(sp)
    800049a8:	6906                	ld	s2,64(sp)
    800049aa:	79e2                	ld	s3,56(sp)
    800049ac:	7a42                	ld	s4,48(sp)
    800049ae:	7aa2                	ld	s5,40(sp)
    800049b0:	6125                	addi	sp,sp,96
    800049b2:	8082                	ret
      if(i == 0)
    800049b4:	fc099ce3          	bnez	s3,8000498c <piperead+0xc2>
        i = -1;
    800049b8:	89aa                	mv	s3,a0
    800049ba:	bfc9                	j	8000498c <piperead+0xc2>

00000000800049bc <ulazymalloc>:

//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
uint64 a;

  if(va_end < va_start)
    800049bc:	04b66a63          	bltu	a2,a1,80004a10 <ulazymalloc+0x54>
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
    800049c0:	7139                	addi	sp,sp,-64
    800049c2:	fc06                	sd	ra,56(sp)
    800049c4:	f822                	sd	s0,48(sp)
    800049c6:	f426                	sd	s1,40(sp)
    800049c8:	f04a                	sd	s2,32(sp)
    800049ca:	e852                	sd	s4,16(sp)
    800049cc:	0080                	addi	s0,sp,64
    800049ce:	8a2a                	mv	s4,a0
    800049d0:	8932                	mv	s2,a2
    return va_start;

  va_start = PGROUNDUP(va_start);
    800049d2:	6785                	lui	a5,0x1
    800049d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800049d6:	95be                	add	a1,a1,a5
    800049d8:	77fd                	lui	a5,0xfffff
    800049da:	00f5f4b3          	and	s1,a1,a5
  for(a = va_start; a < va_end; a += PGSIZE){
    800049de:	02c4fb63          	bgeu	s1,a2,80004a14 <ulazymalloc+0x58>
    800049e2:	ec4e                	sd	s3,24(sp)
    800049e4:	e456                	sd	s5,8(sp)
    800049e6:	e05a                	sd	s6,0(sp)
    pte_t *pte = walk(pagetable, a, 1);
    800049e8:	4a85                	li	s5,1
      // In case of failure, we don't have a simple way to deallocate just this segment,
      // so we let kexec handle the full cleanup.
      return 0;
    }
    // Mark as User-accessible with given permissions, but NOT valid (PTE_V=0).
    *pte = PTE_U | xperm;
    800049ea:	0106e993          	ori	s3,a3,16
  for(a = va_start; a < va_end; a += PGSIZE){
    800049ee:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable, a, 1);
    800049f0:	8656                	mv	a2,s5
    800049f2:	85a6                	mv	a1,s1
    800049f4:	8552                	mv	a0,s4
    800049f6:	d96fc0ef          	jal	80000f8c <walk>
    if(pte == 0){
    800049fa:	cd19                	beqz	a0,80004a18 <ulazymalloc+0x5c>
    *pte = PTE_U | xperm;
    800049fc:	01353023          	sd	s3,0(a0)
  for(a = va_start; a < va_end; a += PGSIZE){
    80004a00:	94da                	add	s1,s1,s6
    80004a02:	ff24e7e3          	bltu	s1,s2,800049f0 <ulazymalloc+0x34>
  }
  return va_end;
    80004a06:	854a                	mv	a0,s2
    80004a08:	69e2                	ld	s3,24(sp)
    80004a0a:	6aa2                	ld	s5,8(sp)
    80004a0c:	6b02                	ld	s6,0(sp)
    80004a0e:	a801                	j	80004a1e <ulazymalloc+0x62>
    return va_start;
    80004a10:	852e                	mv	a0,a1
    }
    80004a12:	8082                	ret
  return va_end;
    80004a14:	8532                	mv	a0,a2
    80004a16:	a021                	j	80004a1e <ulazymalloc+0x62>
    80004a18:	69e2                	ld	s3,24(sp)
    80004a1a:	6aa2                	ld	s5,8(sp)
    80004a1c:	6b02                	ld	s6,0(sp)
    }
    80004a1e:	70e2                	ld	ra,56(sp)
    80004a20:	7442                	ld	s0,48(sp)
    80004a22:	74a2                	ld	s1,40(sp)
    80004a24:	7902                	ld	s2,32(sp)
    80004a26:	6a42                	ld	s4,16(sp)
    80004a28:	6121                	addi	sp,sp,64
    80004a2a:	8082                	ret

0000000080004a2c <flags2perm>:
// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004a2c:	1141                	addi	sp,sp,-16
    80004a2e:	e406                	sd	ra,8(sp)
    80004a30:	e022                	sd	s0,0(sp)
    80004a32:	0800                	addi	s0,sp,16
    80004a34:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004a36:	0035151b          	slliw	a0,a0,0x3
    80004a3a:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004a3c:	0027f713          	andi	a4,a5,2
    80004a40:	c319                	beqz	a4,80004a46 <flags2perm+0x1a>
      perm |= PTE_W;
    80004a42:	00456513          	ori	a0,a0,4
    if(flags & ELF_PROG_FLAG_READ)
    80004a46:	8b91                	andi	a5,a5,4
    80004a48:	c399                	beqz	a5,80004a4e <flags2perm+0x22>
      perm |= PTE_R;
    80004a4a:	00256513          	ori	a0,a0,2
    return perm;
}
    80004a4e:	60a2                	ld	ra,8(sp)
    80004a50:	6402                	ld	s0,0(sp)
    80004a52:	0141                	addi	sp,sp,16
    80004a54:	8082                	ret

0000000080004a56 <kexec>:
//
// In kernel/exec.c, replace the existing kexec function

int
kexec(char *path, char **argv)
{
    80004a56:	7101                	addi	sp,sp,-512
    80004a58:	ff86                	sd	ra,504(sp)
    80004a5a:	fba2                	sd	s0,496(sp)
    80004a5c:	f7a6                	sd	s1,488(sp)
    80004a5e:	f3ca                	sd	s2,480(sp)
    80004a60:	fb62                	sd	s8,432(sp)
    80004a62:	f36a                	sd	s10,416(sp)
    80004a64:	0400                	addi	s0,sp,512
    80004a66:	84aa                	mv	s1,a0
    80004a68:	8d2a                	mv	s10,a0
    80004a6a:	8c2e                	mv	s8,a1
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004a6c:	870fd0ef          	jal	80001adc <myproc>
    80004a70:	892a                	mv	s2,a0


  begin_op();
    80004a72:	cfaff0ef          	jal	80003f6c <begin_op>

  if((ip = namei(path)) == 0){
    80004a76:	8526                	mv	a0,s1
    80004a78:	b16ff0ef          	jal	80003d8e <namei>
    80004a7c:	cd29                	beqz	a0,80004ad6 <kexec+0x80>
    80004a7e:	84aa                	mv	s1,a0
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
    80004a80:	ae1fe0ef          	jal	80003560 <ilock>
  p->exec_ip = idup(ip);
    80004a84:	8526                	mv	a0,s1
    80004a86:	aa5fe0ef          	jal	8000352a <idup>
    80004a8a:	16a93823          	sd	a0,368(s2)


  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004a8e:	04000713          	li	a4,64
    80004a92:	4681                	li	a3,0
    80004a94:	e5040613          	addi	a2,s0,-432
    80004a98:	4581                	li	a1,0
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	e57fe0ef          	jal	800038f2 <readi>
    80004aa0:	04000793          	li	a5,64
    80004aa4:	00f51a63          	bne	a0,a5,80004ab8 <kexec+0x62>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004aa8:	e5042703          	lw	a4,-432(s0)
    80004aac:	464c47b7          	lui	a5,0x464c4
    80004ab0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004ab4:	02f70b63          	beq	a4,a5,80004aea <kexec+0x94>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	cb3fe0ef          	jal	8000376c <iunlockput>
    end_op();
    80004abe:	d1eff0ef          	jal	80003fdc <end_op>
  }
  return -1;
    80004ac2:	557d                	li	a0,-1
}
    80004ac4:	70fe                	ld	ra,504(sp)
    80004ac6:	745e                	ld	s0,496(sp)
    80004ac8:	74be                	ld	s1,488(sp)
    80004aca:	791e                	ld	s2,480(sp)
    80004acc:	7c5a                	ld	s8,432(sp)
    80004ace:	7d1a                	ld	s10,416(sp)
    80004ad0:	20010113          	addi	sp,sp,512
    80004ad4:	8082                	ret
    end_op();
    80004ad6:	d06ff0ef          	jal	80003fdc <end_op>
    printf("exec checkpoint FAIL: namei failed\n");
    80004ada:	00003517          	auipc	a0,0x3
    80004ade:	c9650513          	addi	a0,a0,-874 # 80007770 <etext+0x770>
    80004ae2:	a19fb0ef          	jal	800004fa <printf>
    return -1;
    80004ae6:	557d                	li	a0,-1
    80004ae8:	bff1                	j	80004ac4 <kexec+0x6e>
    80004aea:	f766                	sd	s9,424(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004aec:	854a                	mv	a0,s2
    80004aee:	8f8fd0ef          	jal	80001be6 <proc_pagetable>
    80004af2:	8caa                	mv	s9,a0
    80004af4:	22050163          	beqz	a0,80004d16 <kexec+0x2c0>
    80004af8:	efce                	sd	s3,472(sp)
    80004afa:	ebd2                	sd	s4,464(sp)
    80004afc:	e7d6                	sd	s5,456(sp)
    80004afe:	e3da                	sd	s6,448(sp)
    80004b00:	ff5e                	sd	s7,440(sp)
    80004b02:	ef6e                	sd	s11,408(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b04:	e8845783          	lhu	a5,-376(s0)
    80004b08:	c7c9                	beqz	a5,80004b92 <kexec+0x13c>
    80004b0a:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b0e:	4b81                	li	s7,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b10:	4981                	li	s3,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b12:	03800a93          	li	s5,56
    if(ph.vaddr % PGSIZE != 0)
    80004b16:	6785                	lui	a5,0x1
    80004b18:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004b1a:	8dbe                	mv	s11,a5
    80004b1c:	a801                	j	80004b2c <kexec+0xd6>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b1e:	2985                	addiw	s3,s3,1
    80004b20:	038b069b          	addiw	a3,s6,56 # 1038 <_entry-0x7fffefc8>
    80004b24:	e8845783          	lhu	a5,-376(s0)
    80004b28:	06f9d663          	bge	s3,a5,80004b94 <kexec+0x13e>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004b2c:	8b36                	mv	s6,a3
    80004b2e:	8756                	mv	a4,s5
    80004b30:	e1840613          	addi	a2,s0,-488
    80004b34:	4581                	li	a1,0
    80004b36:	8526                	mv	a0,s1
    80004b38:	dbbfe0ef          	jal	800038f2 <readi>
    80004b3c:	1d551f63          	bne	a0,s5,80004d1a <kexec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004b40:	e1842783          	lw	a5,-488(s0)
    80004b44:	4705                	li	a4,1
    80004b46:	fce79ce3          	bne	a5,a4,80004b1e <kexec+0xc8>
    if(ph.memsz < ph.filesz)
    80004b4a:	e4043903          	ld	s2,-448(s0)
    80004b4e:	e3843783          	ld	a5,-456(s0)
    80004b52:	1cf96463          	bltu	s2,a5,80004d1a <kexec+0x2c4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004b56:	e2843a03          	ld	s4,-472(s0)
    80004b5a:	9952                	add	s2,s2,s4
    80004b5c:	1b496f63          	bltu	s2,s4,80004d1a <kexec+0x2c4>
    if(ph.vaddr % PGSIZE != 0)
    80004b60:	01ba77b3          	and	a5,s4,s11
    80004b64:	1a079b63          	bnez	a5,80004d1a <kexec+0x2c4>
    if((ulazymalloc(pagetable, ph.vaddr, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004b68:	e1c42503          	lw	a0,-484(s0)
    80004b6c:	ec1ff0ef          	jal	80004a2c <flags2perm>
    80004b70:	86aa                	mv	a3,a0
    80004b72:	864a                	mv	a2,s2
    80004b74:	85d2                	mv	a1,s4
    80004b76:	8566                	mv	a0,s9
    80004b78:	e45ff0ef          	jal	800049bc <ulazymalloc>
    80004b7c:	18050f63          	beqz	a0,80004d1a <kexec+0x2c4>
    if(ph.vaddr + ph.memsz > sz)
    80004b80:	e2843783          	ld	a5,-472(s0)
    80004b84:	e4043703          	ld	a4,-448(s0)
    80004b88:	97ba                	add	a5,a5,a4
    80004b8a:	f8fbfae3          	bgeu	s7,a5,80004b1e <kexec+0xc8>
    80004b8e:	8bbe                	mv	s7,a5
    80004b90:	b779                	j	80004b1e <kexec+0xc8>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b92:	4b81                	li	s7,0
  iunlockput(ip);
    80004b94:	8526                	mv	a0,s1
    80004b96:	bd7fe0ef          	jal	8000376c <iunlockput>
  end_op();
    80004b9a:	c42ff0ef          	jal	80003fdc <end_op>
  p = myproc();
    80004b9e:	f3ffc0ef          	jal	80001adc <myproc>
    80004ba2:	e0a43423          	sd	a0,-504(s0)
  uint64 oldsz = p->sz;
    80004ba6:	6538                	ld	a4,72(a0)
    80004ba8:	e0e43023          	sd	a4,-512(s0)
  p->heap_start = sz;
    80004bac:	17753423          	sd	s7,360(a0)
  sz = PGROUNDUP(sz);
    80004bb0:	6985                	lui	s3,0x1
    80004bb2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004bb4:	99de                	add	s3,s3,s7
    80004bb6:	77fd                	lui	a5,0xfffff
    80004bb8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004bbc:	4691                	li	a3,4
    80004bbe:	6609                	lui	a2,0x2
    80004bc0:	964e                	add	a2,a2,s3
    80004bc2:	85ce                	mv	a1,s3
    80004bc4:	8566                	mv	a0,s9
    80004bc6:	92dfc0ef          	jal	800014f2 <uvmalloc>
    80004bca:	892a                	mv	s2,a0
    80004bcc:	8daa                	mv	s11,a0
    80004bce:	ed11                	bnez	a0,80004bea <kexec+0x194>
    proc_freepagetable(pagetable, sz);
    80004bd0:	85ce                	mv	a1,s3
    80004bd2:	8566                	mv	a0,s9
    80004bd4:	896fd0ef          	jal	80001c6a <proc_freepagetable>
  return -1;
    80004bd8:	557d                	li	a0,-1
    80004bda:	69fe                	ld	s3,472(sp)
    80004bdc:	6a5e                	ld	s4,464(sp)
    80004bde:	6abe                	ld	s5,456(sp)
    80004be0:	6b1e                	ld	s6,448(sp)
    80004be2:	7bfa                	ld	s7,440(sp)
    80004be4:	7cba                	ld	s9,424(sp)
    80004be6:	6dfa                	ld	s11,408(sp)
    80004be8:	bdf1                	j	80004ac4 <kexec+0x6e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004bea:	75f9                	lui	a1,0xffffe
    80004bec:	95aa                	add	a1,a1,a0
    80004bee:	8566                	mv	a0,s9
    80004bf0:	aeffc0ef          	jal	800016de <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004bf4:	80090a93          	addi	s5,s2,-2048
    80004bf8:	800a8a93          	addi	s5,s5,-2048
  for(argc = 0; argv[argc]; argc++) {
    80004bfc:	000c3503          	ld	a0,0(s8)
    80004c00:	4481                	li	s1,0
    ustack[argc] = sp;
    80004c02:	e9040b13          	addi	s6,s0,-368
    if(argc >= MAXARG)
    80004c06:	02000a13          	li	s4,32
  for(argc = 0; argv[argc]; argc++) {
    80004c0a:	c929                	beqz	a0,80004c5c <kexec+0x206>
    sp -= strlen(argv[argc]) + 1;
    80004c0c:	a76fc0ef          	jal	80000e82 <strlen>
    80004c10:	2505                	addiw	a0,a0,1
    80004c12:	40a90533          	sub	a0,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004c16:	ff057913          	andi	s2,a0,-16
    if(sp < stackbase)
    80004c1a:	11596c63          	bltu	s2,s5,80004d32 <kexec+0x2dc>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004c1e:	8be2                	mv	s7,s8
    80004c20:	000c3983          	ld	s3,0(s8)
    80004c24:	854e                	mv	a0,s3
    80004c26:	a5cfc0ef          	jal	80000e82 <strlen>
    80004c2a:	0015069b          	addiw	a3,a0,1
    80004c2e:	864e                	mv	a2,s3
    80004c30:	85ca                	mv	a1,s2
    80004c32:	8566                	mv	a0,s9
    80004c34:	ad5fc0ef          	jal	80001708 <copyout>
    80004c38:	0e054f63          	bltz	a0,80004d36 <kexec+0x2e0>
    ustack[argc] = sp;
    80004c3c:	00349793          	slli	a5,s1,0x3
    80004c40:	97da                	add	a5,a5,s6
    80004c42:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb3b8>
  for(argc = 0; argv[argc]; argc++) {
    80004c46:	0485                	addi	s1,s1,1
    80004c48:	008c0793          	addi	a5,s8,8
    80004c4c:	8c3e                	mv	s8,a5
    80004c4e:	008bb503          	ld	a0,8(s7)
    80004c52:	c509                	beqz	a0,80004c5c <kexec+0x206>
    if(argc >= MAXARG)
    80004c54:	fb449ce3          	bne	s1,s4,80004c0c <kexec+0x1b6>
  sz = sz1;
    80004c58:	89ee                	mv	s3,s11
    80004c5a:	bf9d                	j	80004bd0 <kexec+0x17a>
  ustack[argc] = 0;
    80004c5c:	00349793          	slli	a5,s1,0x3
    80004c60:	fc078793          	addi	a5,a5,-64
    80004c64:	fd040713          	addi	a4,s0,-48
    80004c68:	97ba                	add	a5,a5,a4
    80004c6a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004c6e:	00349693          	slli	a3,s1,0x3
    80004c72:	06a1                	addi	a3,a3,8
    80004c74:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004c78:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004c7c:	89ee                	mv	s3,s11
  if(sp < stackbase)
    80004c7e:	f55969e3          	bltu	s2,s5,80004bd0 <kexec+0x17a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004c82:	e9040613          	addi	a2,s0,-368
    80004c86:	85ca                	mv	a1,s2
    80004c88:	8566                	mv	a0,s9
    80004c8a:	a7ffc0ef          	jal	80001708 <copyout>
    80004c8e:	f40541e3          	bltz	a0,80004bd0 <kexec+0x17a>
  p->trapframe->a1 = sp;
    80004c92:	e0843783          	ld	a5,-504(s0)
    80004c96:	6fbc                	ld	a5,88(a5)
    80004c98:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004c9c:	000d4703          	lbu	a4,0(s10)
    80004ca0:	cf11                	beqz	a4,80004cbc <kexec+0x266>
    80004ca2:	001d0793          	addi	a5,s10,1
    if(*s == '/')
    80004ca6:	02f00693          	li	a3,47
    80004caa:	a029                	j	80004cb4 <kexec+0x25e>
  for(last=s=path; *s; s++)
    80004cac:	0785                	addi	a5,a5,1
    80004cae:	fff7c703          	lbu	a4,-1(a5)
    80004cb2:	c709                	beqz	a4,80004cbc <kexec+0x266>
    if(*s == '/')
    80004cb4:	fed71ce3          	bne	a4,a3,80004cac <kexec+0x256>
      last = s+1;
    80004cb8:	8d3e                	mv	s10,a5
    80004cba:	bfcd                	j	80004cac <kexec+0x256>
  safestrcpy(p->name, last, sizeof(p->name));
    80004cbc:	4641                	li	a2,16
    80004cbe:	85ea                	mv	a1,s10
    80004cc0:	e0843983          	ld	s3,-504(s0)
    80004cc4:	15898513          	addi	a0,s3,344
    80004cc8:	984fc0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80004ccc:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004cd0:	0599b823          	sd	s9,80(s3)
  p->sz = sz;
    80004cd4:	05b9b423          	sd	s11,72(s3)
  p->trapframe->epc = elf.entry;
    80004cd8:	0589b783          	ld	a5,88(s3)
    80004cdc:	e6843703          	ld	a4,-408(s0)
    80004ce0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;
    80004ce2:	0589b783          	ld	a5,88(s3)
    80004ce6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004cea:	e0043583          	ld	a1,-512(s0)
    80004cee:	f7dfc0ef          	jal	80001c6a <proc_freepagetable>
  printf("pid %d SUCCESS\n",p->pid);
    80004cf2:	0309a583          	lw	a1,48(s3)
    80004cf6:	00003517          	auipc	a0,0x3
    80004cfa:	aa250513          	addi	a0,a0,-1374 # 80007798 <etext+0x798>
    80004cfe:	ffcfb0ef          	jal	800004fa <printf>
  return argc;
    80004d02:	0004851b          	sext.w	a0,s1
    80004d06:	69fe                	ld	s3,472(sp)
    80004d08:	6a5e                	ld	s4,464(sp)
    80004d0a:	6abe                	ld	s5,456(sp)
    80004d0c:	6b1e                	ld	s6,448(sp)
    80004d0e:	7bfa                	ld	s7,440(sp)
    80004d10:	7cba                	ld	s9,424(sp)
    80004d12:	6dfa                	ld	s11,408(sp)
    80004d14:	bb45                	j	80004ac4 <kexec+0x6e>
    80004d16:	7cba                	ld	s9,424(sp)
    80004d18:	b345                	j	80004ab8 <kexec+0x62>
    proc_freepagetable(pagetable, sz);
    80004d1a:	85de                	mv	a1,s7
    80004d1c:	8566                	mv	a0,s9
    80004d1e:	f4dfc0ef          	jal	80001c6a <proc_freepagetable>
  if(ip){
    80004d22:	69fe                	ld	s3,472(sp)
    80004d24:	6a5e                	ld	s4,464(sp)
    80004d26:	6abe                	ld	s5,456(sp)
    80004d28:	6b1e                	ld	s6,448(sp)
    80004d2a:	7bfa                	ld	s7,440(sp)
    80004d2c:	7cba                	ld	s9,424(sp)
    80004d2e:	6dfa                	ld	s11,408(sp)
    80004d30:	b361                	j	80004ab8 <kexec+0x62>
  sz = sz1;
    80004d32:	89ee                	mv	s3,s11
    80004d34:	bd71                	j	80004bd0 <kexec+0x17a>
    80004d36:	89ee                	mv	s3,s11
    80004d38:	bd61                	j	80004bd0 <kexec+0x17a>

0000000080004d3a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004d3a:	7179                	addi	sp,sp,-48
    80004d3c:	f406                	sd	ra,40(sp)
    80004d3e:	f022                	sd	s0,32(sp)
    80004d40:	ec26                	sd	s1,24(sp)
    80004d42:	e84a                	sd	s2,16(sp)
    80004d44:	1800                	addi	s0,sp,48
    80004d46:	892e                	mv	s2,a1
    80004d48:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004d4a:	fdc40593          	addi	a1,s0,-36
    80004d4e:	e25fd0ef          	jal	80002b72 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004d52:	fdc42703          	lw	a4,-36(s0)
    80004d56:	47bd                	li	a5,15
    80004d58:	02e7ea63          	bltu	a5,a4,80004d8c <argfd+0x52>
    80004d5c:	d81fc0ef          	jal	80001adc <myproc>
    80004d60:	fdc42703          	lw	a4,-36(s0)
    80004d64:	00371793          	slli	a5,a4,0x3
    80004d68:	0d078793          	addi	a5,a5,208
    80004d6c:	953e                	add	a0,a0,a5
    80004d6e:	611c                	ld	a5,0(a0)
    80004d70:	c385                	beqz	a5,80004d90 <argfd+0x56>
    return -1;
  if(pfd)
    80004d72:	00090463          	beqz	s2,80004d7a <argfd+0x40>
    *pfd = fd;
    80004d76:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004d7a:	4501                	li	a0,0
  if(pf)
    80004d7c:	c091                	beqz	s1,80004d80 <argfd+0x46>
    *pf = f;
    80004d7e:	e09c                	sd	a5,0(s1)
}
    80004d80:	70a2                	ld	ra,40(sp)
    80004d82:	7402                	ld	s0,32(sp)
    80004d84:	64e2                	ld	s1,24(sp)
    80004d86:	6942                	ld	s2,16(sp)
    80004d88:	6145                	addi	sp,sp,48
    80004d8a:	8082                	ret
    return -1;
    80004d8c:	557d                	li	a0,-1
    80004d8e:	bfcd                	j	80004d80 <argfd+0x46>
    80004d90:	557d                	li	a0,-1
    80004d92:	b7fd                	j	80004d80 <argfd+0x46>

0000000080004d94 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004d94:	1101                	addi	sp,sp,-32
    80004d96:	ec06                	sd	ra,24(sp)
    80004d98:	e822                	sd	s0,16(sp)
    80004d9a:	e426                	sd	s1,8(sp)
    80004d9c:	1000                	addi	s0,sp,32
    80004d9e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004da0:	d3dfc0ef          	jal	80001adc <myproc>
    80004da4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004da6:	0d050793          	addi	a5,a0,208
    80004daa:	4501                	li	a0,0
    80004dac:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004dae:	6398                	ld	a4,0(a5)
    80004db0:	cb19                	beqz	a4,80004dc6 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004db2:	2505                	addiw	a0,a0,1
    80004db4:	07a1                	addi	a5,a5,8
    80004db6:	fed51ce3          	bne	a0,a3,80004dae <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004dba:	557d                	li	a0,-1
}
    80004dbc:	60e2                	ld	ra,24(sp)
    80004dbe:	6442                	ld	s0,16(sp)
    80004dc0:	64a2                	ld	s1,8(sp)
    80004dc2:	6105                	addi	sp,sp,32
    80004dc4:	8082                	ret
      p->ofile[fd] = f;
    80004dc6:	00351793          	slli	a5,a0,0x3
    80004dca:	0d078793          	addi	a5,a5,208
    80004dce:	963e                	add	a2,a2,a5
    80004dd0:	e204                	sd	s1,0(a2)
      return fd;
    80004dd2:	b7ed                	j	80004dbc <fdalloc+0x28>

0000000080004dd4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004dd4:	715d                	addi	sp,sp,-80
    80004dd6:	e486                	sd	ra,72(sp)
    80004dd8:	e0a2                	sd	s0,64(sp)
    80004dda:	fc26                	sd	s1,56(sp)
    80004ddc:	f84a                	sd	s2,48(sp)
    80004dde:	f44e                	sd	s3,40(sp)
    80004de0:	f052                	sd	s4,32(sp)
    80004de2:	ec56                	sd	s5,24(sp)
    80004de4:	e85a                	sd	s6,16(sp)
    80004de6:	0880                	addi	s0,sp,80
    80004de8:	892e                	mv	s2,a1
    80004dea:	8a2e                	mv	s4,a1
    80004dec:	8ab2                	mv	s5,a2
    80004dee:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004df0:	fb040593          	addi	a1,s0,-80
    80004df4:	fb5fe0ef          	jal	80003da8 <nameiparent>
    80004df8:	84aa                	mv	s1,a0
    80004dfa:	10050763          	beqz	a0,80004f08 <create+0x134>
    return 0;

  ilock(dp);
    80004dfe:	f62fe0ef          	jal	80003560 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004e02:	4601                	li	a2,0
    80004e04:	fb040593          	addi	a1,s0,-80
    80004e08:	8526                	mv	a0,s1
    80004e0a:	cf1fe0ef          	jal	80003afa <dirlookup>
    80004e0e:	89aa                	mv	s3,a0
    80004e10:	c131                	beqz	a0,80004e54 <create+0x80>
    iunlockput(dp);
    80004e12:	8526                	mv	a0,s1
    80004e14:	959fe0ef          	jal	8000376c <iunlockput>
    ilock(ip);
    80004e18:	854e                	mv	a0,s3
    80004e1a:	f46fe0ef          	jal	80003560 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004e1e:	4789                	li	a5,2
    80004e20:	02f91563          	bne	s2,a5,80004e4a <create+0x76>
    80004e24:	0449d783          	lhu	a5,68(s3)
    80004e28:	37f9                	addiw	a5,a5,-2
    80004e2a:	17c2                	slli	a5,a5,0x30
    80004e2c:	93c1                	srli	a5,a5,0x30
    80004e2e:	4705                	li	a4,1
    80004e30:	00f76d63          	bltu	a4,a5,80004e4a <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004e34:	854e                	mv	a0,s3
    80004e36:	60a6                	ld	ra,72(sp)
    80004e38:	6406                	ld	s0,64(sp)
    80004e3a:	74e2                	ld	s1,56(sp)
    80004e3c:	7942                	ld	s2,48(sp)
    80004e3e:	79a2                	ld	s3,40(sp)
    80004e40:	7a02                	ld	s4,32(sp)
    80004e42:	6ae2                	ld	s5,24(sp)
    80004e44:	6b42                	ld	s6,16(sp)
    80004e46:	6161                	addi	sp,sp,80
    80004e48:	8082                	ret
    iunlockput(ip);
    80004e4a:	854e                	mv	a0,s3
    80004e4c:	921fe0ef          	jal	8000376c <iunlockput>
    return 0;
    80004e50:	4981                	li	s3,0
    80004e52:	b7cd                	j	80004e34 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004e54:	85ca                	mv	a1,s2
    80004e56:	4088                	lw	a0,0(s1)
    80004e58:	d98fe0ef          	jal	800033f0 <ialloc>
    80004e5c:	892a                	mv	s2,a0
    80004e5e:	cd15                	beqz	a0,80004e9a <create+0xc6>
  ilock(ip);
    80004e60:	f00fe0ef          	jal	80003560 <ilock>
  ip->major = major;
    80004e64:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004e68:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004e6c:	4785                	li	a5,1
    80004e6e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004e72:	854a                	mv	a0,s2
    80004e74:	e38fe0ef          	jal	800034ac <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004e78:	4705                	li	a4,1
    80004e7a:	02ea0463          	beq	s4,a4,80004ea2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004e7e:	00492603          	lw	a2,4(s2)
    80004e82:	fb040593          	addi	a1,s0,-80
    80004e86:	8526                	mv	a0,s1
    80004e88:	e5dfe0ef          	jal	80003ce4 <dirlink>
    80004e8c:	06054263          	bltz	a0,80004ef0 <create+0x11c>
  iunlockput(dp);
    80004e90:	8526                	mv	a0,s1
    80004e92:	8dbfe0ef          	jal	8000376c <iunlockput>
  return ip;
    80004e96:	89ca                	mv	s3,s2
    80004e98:	bf71                	j	80004e34 <create+0x60>
    iunlockput(dp);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	8d1fe0ef          	jal	8000376c <iunlockput>
    return 0;
    80004ea0:	bf51                	j	80004e34 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004ea2:	00492603          	lw	a2,4(s2)
    80004ea6:	00003597          	auipc	a1,0x3
    80004eaa:	90258593          	addi	a1,a1,-1790 # 800077a8 <etext+0x7a8>
    80004eae:	854a                	mv	a0,s2
    80004eb0:	e35fe0ef          	jal	80003ce4 <dirlink>
    80004eb4:	02054e63          	bltz	a0,80004ef0 <create+0x11c>
    80004eb8:	40d0                	lw	a2,4(s1)
    80004eba:	00003597          	auipc	a1,0x3
    80004ebe:	8f658593          	addi	a1,a1,-1802 # 800077b0 <etext+0x7b0>
    80004ec2:	854a                	mv	a0,s2
    80004ec4:	e21fe0ef          	jal	80003ce4 <dirlink>
    80004ec8:	02054463          	bltz	a0,80004ef0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ecc:	00492603          	lw	a2,4(s2)
    80004ed0:	fb040593          	addi	a1,s0,-80
    80004ed4:	8526                	mv	a0,s1
    80004ed6:	e0ffe0ef          	jal	80003ce4 <dirlink>
    80004eda:	00054b63          	bltz	a0,80004ef0 <create+0x11c>
    dp->nlink++;  // for ".."
    80004ede:	04a4d783          	lhu	a5,74(s1)
    80004ee2:	2785                	addiw	a5,a5,1
    80004ee4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ee8:	8526                	mv	a0,s1
    80004eea:	dc2fe0ef          	jal	800034ac <iupdate>
    80004eee:	b74d                	j	80004e90 <create+0xbc>
  ip->nlink = 0;
    80004ef0:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004ef4:	854a                	mv	a0,s2
    80004ef6:	db6fe0ef          	jal	800034ac <iupdate>
  iunlockput(ip);
    80004efa:	854a                	mv	a0,s2
    80004efc:	871fe0ef          	jal	8000376c <iunlockput>
  iunlockput(dp);
    80004f00:	8526                	mv	a0,s1
    80004f02:	86bfe0ef          	jal	8000376c <iunlockput>
  return 0;
    80004f06:	b73d                	j	80004e34 <create+0x60>
    return 0;
    80004f08:	89aa                	mv	s3,a0
    80004f0a:	b72d                	j	80004e34 <create+0x60>

0000000080004f0c <sys_dup>:
{
    80004f0c:	7179                	addi	sp,sp,-48
    80004f0e:	f406                	sd	ra,40(sp)
    80004f10:	f022                	sd	s0,32(sp)
    80004f12:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004f14:	fd840613          	addi	a2,s0,-40
    80004f18:	4581                	li	a1,0
    80004f1a:	4501                	li	a0,0
    80004f1c:	e1fff0ef          	jal	80004d3a <argfd>
    return -1;
    80004f20:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004f22:	02054363          	bltz	a0,80004f48 <sys_dup+0x3c>
    80004f26:	ec26                	sd	s1,24(sp)
    80004f28:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004f2a:	fd843483          	ld	s1,-40(s0)
    80004f2e:	8526                	mv	a0,s1
    80004f30:	e65ff0ef          	jal	80004d94 <fdalloc>
    80004f34:	892a                	mv	s2,a0
    return -1;
    80004f36:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004f38:	00054d63          	bltz	a0,80004f52 <sys_dup+0x46>
  filedup(f);
    80004f3c:	8526                	mv	a0,s1
    80004f3e:	c0cff0ef          	jal	8000434a <filedup>
  return fd;
    80004f42:	87ca                	mv	a5,s2
    80004f44:	64e2                	ld	s1,24(sp)
    80004f46:	6942                	ld	s2,16(sp)
}
    80004f48:	853e                	mv	a0,a5
    80004f4a:	70a2                	ld	ra,40(sp)
    80004f4c:	7402                	ld	s0,32(sp)
    80004f4e:	6145                	addi	sp,sp,48
    80004f50:	8082                	ret
    80004f52:	64e2                	ld	s1,24(sp)
    80004f54:	6942                	ld	s2,16(sp)
    80004f56:	bfcd                	j	80004f48 <sys_dup+0x3c>

0000000080004f58 <sys_read>:
{
    80004f58:	7179                	addi	sp,sp,-48
    80004f5a:	f406                	sd	ra,40(sp)
    80004f5c:	f022                	sd	s0,32(sp)
    80004f5e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f60:	fd840593          	addi	a1,s0,-40
    80004f64:	4505                	li	a0,1
    80004f66:	c29fd0ef          	jal	80002b8e <argaddr>
  argint(2, &n);
    80004f6a:	fe440593          	addi	a1,s0,-28
    80004f6e:	4509                	li	a0,2
    80004f70:	c03fd0ef          	jal	80002b72 <argint>
  if(argfd(0, 0, &f) < 0)
    80004f74:	fe840613          	addi	a2,s0,-24
    80004f78:	4581                	li	a1,0
    80004f7a:	4501                	li	a0,0
    80004f7c:	dbfff0ef          	jal	80004d3a <argfd>
    80004f80:	87aa                	mv	a5,a0
    return -1;
    80004f82:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f84:	0007ca63          	bltz	a5,80004f98 <sys_read+0x40>
  return fileread(f, p, n);
    80004f88:	fe442603          	lw	a2,-28(s0)
    80004f8c:	fd843583          	ld	a1,-40(s0)
    80004f90:	fe843503          	ld	a0,-24(s0)
    80004f94:	d20ff0ef          	jal	800044b4 <fileread>
}
    80004f98:	70a2                	ld	ra,40(sp)
    80004f9a:	7402                	ld	s0,32(sp)
    80004f9c:	6145                	addi	sp,sp,48
    80004f9e:	8082                	ret

0000000080004fa0 <sys_write>:
{
    80004fa0:	7179                	addi	sp,sp,-48
    80004fa2:	f406                	sd	ra,40(sp)
    80004fa4:	f022                	sd	s0,32(sp)
    80004fa6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004fa8:	fd840593          	addi	a1,s0,-40
    80004fac:	4505                	li	a0,1
    80004fae:	be1fd0ef          	jal	80002b8e <argaddr>
  argint(2, &n);
    80004fb2:	fe440593          	addi	a1,s0,-28
    80004fb6:	4509                	li	a0,2
    80004fb8:	bbbfd0ef          	jal	80002b72 <argint>
  if(argfd(0, 0, &f) < 0)
    80004fbc:	fe840613          	addi	a2,s0,-24
    80004fc0:	4581                	li	a1,0
    80004fc2:	4501                	li	a0,0
    80004fc4:	d77ff0ef          	jal	80004d3a <argfd>
    80004fc8:	87aa                	mv	a5,a0
    return -1;
    80004fca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004fcc:	0007ca63          	bltz	a5,80004fe0 <sys_write+0x40>
  return filewrite(f, p, n);
    80004fd0:	fe442603          	lw	a2,-28(s0)
    80004fd4:	fd843583          	ld	a1,-40(s0)
    80004fd8:	fe843503          	ld	a0,-24(s0)
    80004fdc:	d9cff0ef          	jal	80004578 <filewrite>
}
    80004fe0:	70a2                	ld	ra,40(sp)
    80004fe2:	7402                	ld	s0,32(sp)
    80004fe4:	6145                	addi	sp,sp,48
    80004fe6:	8082                	ret

0000000080004fe8 <sys_close>:
{
    80004fe8:	1101                	addi	sp,sp,-32
    80004fea:	ec06                	sd	ra,24(sp)
    80004fec:	e822                	sd	s0,16(sp)
    80004fee:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004ff0:	fe040613          	addi	a2,s0,-32
    80004ff4:	fec40593          	addi	a1,s0,-20
    80004ff8:	4501                	li	a0,0
    80004ffa:	d41ff0ef          	jal	80004d3a <argfd>
    return -1;
    80004ffe:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005000:	02054163          	bltz	a0,80005022 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005004:	ad9fc0ef          	jal	80001adc <myproc>
    80005008:	fec42783          	lw	a5,-20(s0)
    8000500c:	078e                	slli	a5,a5,0x3
    8000500e:	0d078793          	addi	a5,a5,208
    80005012:	953e                	add	a0,a0,a5
    80005014:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005018:	fe043503          	ld	a0,-32(s0)
    8000501c:	b74ff0ef          	jal	80004390 <fileclose>
  return 0;
    80005020:	4781                	li	a5,0
}
    80005022:	853e                	mv	a0,a5
    80005024:	60e2                	ld	ra,24(sp)
    80005026:	6442                	ld	s0,16(sp)
    80005028:	6105                	addi	sp,sp,32
    8000502a:	8082                	ret

000000008000502c <sys_fstat>:
{
    8000502c:	1101                	addi	sp,sp,-32
    8000502e:	ec06                	sd	ra,24(sp)
    80005030:	e822                	sd	s0,16(sp)
    80005032:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005034:	fe040593          	addi	a1,s0,-32
    80005038:	4505                	li	a0,1
    8000503a:	b55fd0ef          	jal	80002b8e <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000503e:	fe840613          	addi	a2,s0,-24
    80005042:	4581                	li	a1,0
    80005044:	4501                	li	a0,0
    80005046:	cf5ff0ef          	jal	80004d3a <argfd>
    8000504a:	87aa                	mv	a5,a0
    return -1;
    8000504c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000504e:	0007c863          	bltz	a5,8000505e <sys_fstat+0x32>
  return filestat(f, st);
    80005052:	fe043583          	ld	a1,-32(s0)
    80005056:	fe843503          	ld	a0,-24(s0)
    8000505a:	bf8ff0ef          	jal	80004452 <filestat>
}
    8000505e:	60e2                	ld	ra,24(sp)
    80005060:	6442                	ld	s0,16(sp)
    80005062:	6105                	addi	sp,sp,32
    80005064:	8082                	ret

0000000080005066 <sys_link>:
{
    80005066:	7169                	addi	sp,sp,-304
    80005068:	f606                	sd	ra,296(sp)
    8000506a:	f222                	sd	s0,288(sp)
    8000506c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000506e:	08000613          	li	a2,128
    80005072:	ed040593          	addi	a1,s0,-304
    80005076:	4501                	li	a0,0
    80005078:	b33fd0ef          	jal	80002baa <argstr>
    return -1;
    8000507c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000507e:	0c054e63          	bltz	a0,8000515a <sys_link+0xf4>
    80005082:	08000613          	li	a2,128
    80005086:	f5040593          	addi	a1,s0,-176
    8000508a:	4505                	li	a0,1
    8000508c:	b1ffd0ef          	jal	80002baa <argstr>
    return -1;
    80005090:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005092:	0c054463          	bltz	a0,8000515a <sys_link+0xf4>
    80005096:	ee26                	sd	s1,280(sp)
  begin_op();
    80005098:	ed5fe0ef          	jal	80003f6c <begin_op>
  if((ip = namei(old)) == 0){
    8000509c:	ed040513          	addi	a0,s0,-304
    800050a0:	ceffe0ef          	jal	80003d8e <namei>
    800050a4:	84aa                	mv	s1,a0
    800050a6:	c53d                	beqz	a0,80005114 <sys_link+0xae>
  ilock(ip);
    800050a8:	cb8fe0ef          	jal	80003560 <ilock>
  if(ip->type == T_DIR){
    800050ac:	04449703          	lh	a4,68(s1)
    800050b0:	4785                	li	a5,1
    800050b2:	06f70663          	beq	a4,a5,8000511e <sys_link+0xb8>
    800050b6:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800050b8:	04a4d783          	lhu	a5,74(s1)
    800050bc:	2785                	addiw	a5,a5,1
    800050be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800050c2:	8526                	mv	a0,s1
    800050c4:	be8fe0ef          	jal	800034ac <iupdate>
  iunlock(ip);
    800050c8:	8526                	mv	a0,s1
    800050ca:	d44fe0ef          	jal	8000360e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800050ce:	fd040593          	addi	a1,s0,-48
    800050d2:	f5040513          	addi	a0,s0,-176
    800050d6:	cd3fe0ef          	jal	80003da8 <nameiparent>
    800050da:	892a                	mv	s2,a0
    800050dc:	cd21                	beqz	a0,80005134 <sys_link+0xce>
  ilock(dp);
    800050de:	c82fe0ef          	jal	80003560 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800050e2:	854a                	mv	a0,s2
    800050e4:	00092703          	lw	a4,0(s2)
    800050e8:	409c                	lw	a5,0(s1)
    800050ea:	04f71263          	bne	a4,a5,8000512e <sys_link+0xc8>
    800050ee:	40d0                	lw	a2,4(s1)
    800050f0:	fd040593          	addi	a1,s0,-48
    800050f4:	bf1fe0ef          	jal	80003ce4 <dirlink>
    800050f8:	02054b63          	bltz	a0,8000512e <sys_link+0xc8>
  iunlockput(dp);
    800050fc:	854a                	mv	a0,s2
    800050fe:	e6efe0ef          	jal	8000376c <iunlockput>
  iput(ip);
    80005102:	8526                	mv	a0,s1
    80005104:	ddefe0ef          	jal	800036e2 <iput>
  end_op();
    80005108:	ed5fe0ef          	jal	80003fdc <end_op>
  return 0;
    8000510c:	4781                	li	a5,0
    8000510e:	64f2                	ld	s1,280(sp)
    80005110:	6952                	ld	s2,272(sp)
    80005112:	a0a1                	j	8000515a <sys_link+0xf4>
    end_op();
    80005114:	ec9fe0ef          	jal	80003fdc <end_op>
    return -1;
    80005118:	57fd                	li	a5,-1
    8000511a:	64f2                	ld	s1,280(sp)
    8000511c:	a83d                	j	8000515a <sys_link+0xf4>
    iunlockput(ip);
    8000511e:	8526                	mv	a0,s1
    80005120:	e4cfe0ef          	jal	8000376c <iunlockput>
    end_op();
    80005124:	eb9fe0ef          	jal	80003fdc <end_op>
    return -1;
    80005128:	57fd                	li	a5,-1
    8000512a:	64f2                	ld	s1,280(sp)
    8000512c:	a03d                	j	8000515a <sys_link+0xf4>
    iunlockput(dp);
    8000512e:	854a                	mv	a0,s2
    80005130:	e3cfe0ef          	jal	8000376c <iunlockput>
  ilock(ip);
    80005134:	8526                	mv	a0,s1
    80005136:	c2afe0ef          	jal	80003560 <ilock>
  ip->nlink--;
    8000513a:	04a4d783          	lhu	a5,74(s1)
    8000513e:	37fd                	addiw	a5,a5,-1
    80005140:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005144:	8526                	mv	a0,s1
    80005146:	b66fe0ef          	jal	800034ac <iupdate>
  iunlockput(ip);
    8000514a:	8526                	mv	a0,s1
    8000514c:	e20fe0ef          	jal	8000376c <iunlockput>
  end_op();
    80005150:	e8dfe0ef          	jal	80003fdc <end_op>
  return -1;
    80005154:	57fd                	li	a5,-1
    80005156:	64f2                	ld	s1,280(sp)
    80005158:	6952                	ld	s2,272(sp)
}
    8000515a:	853e                	mv	a0,a5
    8000515c:	70b2                	ld	ra,296(sp)
    8000515e:	7412                	ld	s0,288(sp)
    80005160:	6155                	addi	sp,sp,304
    80005162:	8082                	ret

0000000080005164 <sys_unlink>:
{
    80005164:	7151                	addi	sp,sp,-240
    80005166:	f586                	sd	ra,232(sp)
    80005168:	f1a2                	sd	s0,224(sp)
    8000516a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000516c:	08000613          	li	a2,128
    80005170:	f3040593          	addi	a1,s0,-208
    80005174:	4501                	li	a0,0
    80005176:	a35fd0ef          	jal	80002baa <argstr>
    8000517a:	14054d63          	bltz	a0,800052d4 <sys_unlink+0x170>
    8000517e:	eda6                	sd	s1,216(sp)
  begin_op();
    80005180:	dedfe0ef          	jal	80003f6c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005184:	fb040593          	addi	a1,s0,-80
    80005188:	f3040513          	addi	a0,s0,-208
    8000518c:	c1dfe0ef          	jal	80003da8 <nameiparent>
    80005190:	84aa                	mv	s1,a0
    80005192:	c955                	beqz	a0,80005246 <sys_unlink+0xe2>
  ilock(dp);
    80005194:	bccfe0ef          	jal	80003560 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005198:	00002597          	auipc	a1,0x2
    8000519c:	61058593          	addi	a1,a1,1552 # 800077a8 <etext+0x7a8>
    800051a0:	fb040513          	addi	a0,s0,-80
    800051a4:	941fe0ef          	jal	80003ae4 <namecmp>
    800051a8:	10050b63          	beqz	a0,800052be <sys_unlink+0x15a>
    800051ac:	00002597          	auipc	a1,0x2
    800051b0:	60458593          	addi	a1,a1,1540 # 800077b0 <etext+0x7b0>
    800051b4:	fb040513          	addi	a0,s0,-80
    800051b8:	92dfe0ef          	jal	80003ae4 <namecmp>
    800051bc:	10050163          	beqz	a0,800052be <sys_unlink+0x15a>
    800051c0:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800051c2:	f2c40613          	addi	a2,s0,-212
    800051c6:	fb040593          	addi	a1,s0,-80
    800051ca:	8526                	mv	a0,s1
    800051cc:	92ffe0ef          	jal	80003afa <dirlookup>
    800051d0:	892a                	mv	s2,a0
    800051d2:	0e050563          	beqz	a0,800052bc <sys_unlink+0x158>
    800051d6:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800051d8:	b88fe0ef          	jal	80003560 <ilock>
  if(ip->nlink < 1)
    800051dc:	04a91783          	lh	a5,74(s2)
    800051e0:	06f05863          	blez	a5,80005250 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800051e4:	04491703          	lh	a4,68(s2)
    800051e8:	4785                	li	a5,1
    800051ea:	06f70963          	beq	a4,a5,8000525c <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800051ee:	fc040993          	addi	s3,s0,-64
    800051f2:	4641                	li	a2,16
    800051f4:	4581                	li	a1,0
    800051f6:	854e                	mv	a0,s3
    800051f8:	b01fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800051fc:	4741                	li	a4,16
    800051fe:	f2c42683          	lw	a3,-212(s0)
    80005202:	864e                	mv	a2,s3
    80005204:	4581                	li	a1,0
    80005206:	8526                	mv	a0,s1
    80005208:	fdcfe0ef          	jal	800039e4 <writei>
    8000520c:	47c1                	li	a5,16
    8000520e:	08f51863          	bne	a0,a5,8000529e <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80005212:	04491703          	lh	a4,68(s2)
    80005216:	4785                	li	a5,1
    80005218:	08f70963          	beq	a4,a5,800052aa <sys_unlink+0x146>
  iunlockput(dp);
    8000521c:	8526                	mv	a0,s1
    8000521e:	d4efe0ef          	jal	8000376c <iunlockput>
  ip->nlink--;
    80005222:	04a95783          	lhu	a5,74(s2)
    80005226:	37fd                	addiw	a5,a5,-1
    80005228:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000522c:	854a                	mv	a0,s2
    8000522e:	a7efe0ef          	jal	800034ac <iupdate>
  iunlockput(ip);
    80005232:	854a                	mv	a0,s2
    80005234:	d38fe0ef          	jal	8000376c <iunlockput>
  end_op();
    80005238:	da5fe0ef          	jal	80003fdc <end_op>
  return 0;
    8000523c:	4501                	li	a0,0
    8000523e:	64ee                	ld	s1,216(sp)
    80005240:	694e                	ld	s2,208(sp)
    80005242:	69ae                	ld	s3,200(sp)
    80005244:	a061                	j	800052cc <sys_unlink+0x168>
    end_op();
    80005246:	d97fe0ef          	jal	80003fdc <end_op>
    return -1;
    8000524a:	557d                	li	a0,-1
    8000524c:	64ee                	ld	s1,216(sp)
    8000524e:	a8bd                	j	800052cc <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80005250:	00002517          	auipc	a0,0x2
    80005254:	56850513          	addi	a0,a0,1384 # 800077b8 <etext+0x7b8>
    80005258:	dccfb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000525c:	04c92703          	lw	a4,76(s2)
    80005260:	02000793          	li	a5,32
    80005264:	f8e7f5e3          	bgeu	a5,a4,800051ee <sys_unlink+0x8a>
    80005268:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000526a:	4741                	li	a4,16
    8000526c:	86ce                	mv	a3,s3
    8000526e:	f1840613          	addi	a2,s0,-232
    80005272:	4581                	li	a1,0
    80005274:	854a                	mv	a0,s2
    80005276:	e7cfe0ef          	jal	800038f2 <readi>
    8000527a:	47c1                	li	a5,16
    8000527c:	00f51b63          	bne	a0,a5,80005292 <sys_unlink+0x12e>
    if(de.inum != 0)
    80005280:	f1845783          	lhu	a5,-232(s0)
    80005284:	ebb1                	bnez	a5,800052d8 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005286:	29c1                	addiw	s3,s3,16
    80005288:	04c92783          	lw	a5,76(s2)
    8000528c:	fcf9efe3          	bltu	s3,a5,8000526a <sys_unlink+0x106>
    80005290:	bfb9                	j	800051ee <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005292:	00002517          	auipc	a0,0x2
    80005296:	53e50513          	addi	a0,a0,1342 # 800077d0 <etext+0x7d0>
    8000529a:	d8afb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    8000529e:	00002517          	auipc	a0,0x2
    800052a2:	54a50513          	addi	a0,a0,1354 # 800077e8 <etext+0x7e8>
    800052a6:	d7efb0ef          	jal	80000824 <panic>
    dp->nlink--;
    800052aa:	04a4d783          	lhu	a5,74(s1)
    800052ae:	37fd                	addiw	a5,a5,-1
    800052b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052b4:	8526                	mv	a0,s1
    800052b6:	9f6fe0ef          	jal	800034ac <iupdate>
    800052ba:	b78d                	j	8000521c <sys_unlink+0xb8>
    800052bc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800052be:	8526                	mv	a0,s1
    800052c0:	cacfe0ef          	jal	8000376c <iunlockput>
  end_op();
    800052c4:	d19fe0ef          	jal	80003fdc <end_op>
  return -1;
    800052c8:	557d                	li	a0,-1
    800052ca:	64ee                	ld	s1,216(sp)
}
    800052cc:	70ae                	ld	ra,232(sp)
    800052ce:	740e                	ld	s0,224(sp)
    800052d0:	616d                	addi	sp,sp,240
    800052d2:	8082                	ret
    return -1;
    800052d4:	557d                	li	a0,-1
    800052d6:	bfdd                	j	800052cc <sys_unlink+0x168>
    iunlockput(ip);
    800052d8:	854a                	mv	a0,s2
    800052da:	c92fe0ef          	jal	8000376c <iunlockput>
    goto bad;
    800052de:	694e                	ld	s2,208(sp)
    800052e0:	69ae                	ld	s3,200(sp)
    800052e2:	bff1                	j	800052be <sys_unlink+0x15a>

00000000800052e4 <sys_open>:

uint64
sys_open(void)
{
    800052e4:	7131                	addi	sp,sp,-192
    800052e6:	fd06                	sd	ra,184(sp)
    800052e8:	f922                	sd	s0,176(sp)
    800052ea:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800052ec:	f4c40593          	addi	a1,s0,-180
    800052f0:	4505                	li	a0,1
    800052f2:	881fd0ef          	jal	80002b72 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800052f6:	08000613          	li	a2,128
    800052fa:	f5040593          	addi	a1,s0,-176
    800052fe:	4501                	li	a0,0
    80005300:	8abfd0ef          	jal	80002baa <argstr>
    80005304:	87aa                	mv	a5,a0
    return -1;
    80005306:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005308:	0a07c363          	bltz	a5,800053ae <sys_open+0xca>
    8000530c:	f526                	sd	s1,168(sp)

  begin_op();
    8000530e:	c5ffe0ef          	jal	80003f6c <begin_op>

  if(omode & O_CREATE){
    80005312:	f4c42783          	lw	a5,-180(s0)
    80005316:	2007f793          	andi	a5,a5,512
    8000531a:	c3dd                	beqz	a5,800053c0 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000531c:	4681                	li	a3,0
    8000531e:	4601                	li	a2,0
    80005320:	4589                	li	a1,2
    80005322:	f5040513          	addi	a0,s0,-176
    80005326:	aafff0ef          	jal	80004dd4 <create>
    8000532a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000532c:	c549                	beqz	a0,800053b6 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000532e:	04449703          	lh	a4,68(s1)
    80005332:	478d                	li	a5,3
    80005334:	00f71763          	bne	a4,a5,80005342 <sys_open+0x5e>
    80005338:	0464d703          	lhu	a4,70(s1)
    8000533c:	47a5                	li	a5,9
    8000533e:	0ae7ee63          	bltu	a5,a4,800053fa <sys_open+0x116>
    80005342:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005344:	fa9fe0ef          	jal	800042ec <filealloc>
    80005348:	892a                	mv	s2,a0
    8000534a:	c561                	beqz	a0,80005412 <sys_open+0x12e>
    8000534c:	ed4e                	sd	s3,152(sp)
    8000534e:	a47ff0ef          	jal	80004d94 <fdalloc>
    80005352:	89aa                	mv	s3,a0
    80005354:	0a054b63          	bltz	a0,8000540a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005358:	04449703          	lh	a4,68(s1)
    8000535c:	478d                	li	a5,3
    8000535e:	0cf70363          	beq	a4,a5,80005424 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005362:	4789                	li	a5,2
    80005364:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005368:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000536c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005370:	f4c42783          	lw	a5,-180(s0)
    80005374:	0017f713          	andi	a4,a5,1
    80005378:	00174713          	xori	a4,a4,1
    8000537c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005380:	0037f713          	andi	a4,a5,3
    80005384:	00e03733          	snez	a4,a4
    80005388:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000538c:	4007f793          	andi	a5,a5,1024
    80005390:	c791                	beqz	a5,8000539c <sys_open+0xb8>
    80005392:	04449703          	lh	a4,68(s1)
    80005396:	4789                	li	a5,2
    80005398:	08f70d63          	beq	a4,a5,80005432 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000539c:	8526                	mv	a0,s1
    8000539e:	a70fe0ef          	jal	8000360e <iunlock>
  end_op();
    800053a2:	c3bfe0ef          	jal	80003fdc <end_op>

  return fd;
    800053a6:	854e                	mv	a0,s3
    800053a8:	74aa                	ld	s1,168(sp)
    800053aa:	790a                	ld	s2,160(sp)
    800053ac:	69ea                	ld	s3,152(sp)
}
    800053ae:	70ea                	ld	ra,184(sp)
    800053b0:	744a                	ld	s0,176(sp)
    800053b2:	6129                	addi	sp,sp,192
    800053b4:	8082                	ret
      end_op();
    800053b6:	c27fe0ef          	jal	80003fdc <end_op>
      return -1;
    800053ba:	557d                	li	a0,-1
    800053bc:	74aa                	ld	s1,168(sp)
    800053be:	bfc5                	j	800053ae <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800053c0:	f5040513          	addi	a0,s0,-176
    800053c4:	9cbfe0ef          	jal	80003d8e <namei>
    800053c8:	84aa                	mv	s1,a0
    800053ca:	c11d                	beqz	a0,800053f0 <sys_open+0x10c>
    ilock(ip);
    800053cc:	994fe0ef          	jal	80003560 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800053d0:	04449703          	lh	a4,68(s1)
    800053d4:	4785                	li	a5,1
    800053d6:	f4f71ce3          	bne	a4,a5,8000532e <sys_open+0x4a>
    800053da:	f4c42783          	lw	a5,-180(s0)
    800053de:	d3b5                	beqz	a5,80005342 <sys_open+0x5e>
      iunlockput(ip);
    800053e0:	8526                	mv	a0,s1
    800053e2:	b8afe0ef          	jal	8000376c <iunlockput>
      end_op();
    800053e6:	bf7fe0ef          	jal	80003fdc <end_op>
      return -1;
    800053ea:	557d                	li	a0,-1
    800053ec:	74aa                	ld	s1,168(sp)
    800053ee:	b7c1                	j	800053ae <sys_open+0xca>
      end_op();
    800053f0:	bedfe0ef          	jal	80003fdc <end_op>
      return -1;
    800053f4:	557d                	li	a0,-1
    800053f6:	74aa                	ld	s1,168(sp)
    800053f8:	bf5d                	j	800053ae <sys_open+0xca>
    iunlockput(ip);
    800053fa:	8526                	mv	a0,s1
    800053fc:	b70fe0ef          	jal	8000376c <iunlockput>
    end_op();
    80005400:	bddfe0ef          	jal	80003fdc <end_op>
    return -1;
    80005404:	557d                	li	a0,-1
    80005406:	74aa                	ld	s1,168(sp)
    80005408:	b75d                	j	800053ae <sys_open+0xca>
      fileclose(f);
    8000540a:	854a                	mv	a0,s2
    8000540c:	f85fe0ef          	jal	80004390 <fileclose>
    80005410:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005412:	8526                	mv	a0,s1
    80005414:	b58fe0ef          	jal	8000376c <iunlockput>
    end_op();
    80005418:	bc5fe0ef          	jal	80003fdc <end_op>
    return -1;
    8000541c:	557d                	li	a0,-1
    8000541e:	74aa                	ld	s1,168(sp)
    80005420:	790a                	ld	s2,160(sp)
    80005422:	b771                	j	800053ae <sys_open+0xca>
    f->type = FD_DEVICE;
    80005424:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005428:	04649783          	lh	a5,70(s1)
    8000542c:	02f91223          	sh	a5,36(s2)
    80005430:	bf35                	j	8000536c <sys_open+0x88>
    itrunc(ip);
    80005432:	8526                	mv	a0,s1
    80005434:	a1afe0ef          	jal	8000364e <itrunc>
    80005438:	b795                	j	8000539c <sys_open+0xb8>

000000008000543a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000543a:	7175                	addi	sp,sp,-144
    8000543c:	e506                	sd	ra,136(sp)
    8000543e:	e122                	sd	s0,128(sp)
    80005440:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005442:	b2bfe0ef          	jal	80003f6c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005446:	08000613          	li	a2,128
    8000544a:	f7040593          	addi	a1,s0,-144
    8000544e:	4501                	li	a0,0
    80005450:	f5afd0ef          	jal	80002baa <argstr>
    80005454:	02054363          	bltz	a0,8000547a <sys_mkdir+0x40>
    80005458:	4681                	li	a3,0
    8000545a:	4601                	li	a2,0
    8000545c:	4585                	li	a1,1
    8000545e:	f7040513          	addi	a0,s0,-144
    80005462:	973ff0ef          	jal	80004dd4 <create>
    80005466:	c911                	beqz	a0,8000547a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005468:	b04fe0ef          	jal	8000376c <iunlockput>
  end_op();
    8000546c:	b71fe0ef          	jal	80003fdc <end_op>
  return 0;
    80005470:	4501                	li	a0,0
}
    80005472:	60aa                	ld	ra,136(sp)
    80005474:	640a                	ld	s0,128(sp)
    80005476:	6149                	addi	sp,sp,144
    80005478:	8082                	ret
    end_op();
    8000547a:	b63fe0ef          	jal	80003fdc <end_op>
    return -1;
    8000547e:	557d                	li	a0,-1
    80005480:	bfcd                	j	80005472 <sys_mkdir+0x38>

0000000080005482 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005482:	7135                	addi	sp,sp,-160
    80005484:	ed06                	sd	ra,152(sp)
    80005486:	e922                	sd	s0,144(sp)
    80005488:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000548a:	ae3fe0ef          	jal	80003f6c <begin_op>
  argint(1, &major);
    8000548e:	f6c40593          	addi	a1,s0,-148
    80005492:	4505                	li	a0,1
    80005494:	edefd0ef          	jal	80002b72 <argint>
  argint(2, &minor);
    80005498:	f6840593          	addi	a1,s0,-152
    8000549c:	4509                	li	a0,2
    8000549e:	ed4fd0ef          	jal	80002b72 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800054a2:	08000613          	li	a2,128
    800054a6:	f7040593          	addi	a1,s0,-144
    800054aa:	4501                	li	a0,0
    800054ac:	efefd0ef          	jal	80002baa <argstr>
    800054b0:	02054563          	bltz	a0,800054da <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800054b4:	f6841683          	lh	a3,-152(s0)
    800054b8:	f6c41603          	lh	a2,-148(s0)
    800054bc:	458d                	li	a1,3
    800054be:	f7040513          	addi	a0,s0,-144
    800054c2:	913ff0ef          	jal	80004dd4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800054c6:	c911                	beqz	a0,800054da <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800054c8:	aa4fe0ef          	jal	8000376c <iunlockput>
  end_op();
    800054cc:	b11fe0ef          	jal	80003fdc <end_op>
  return 0;
    800054d0:	4501                	li	a0,0
}
    800054d2:	60ea                	ld	ra,152(sp)
    800054d4:	644a                	ld	s0,144(sp)
    800054d6:	610d                	addi	sp,sp,160
    800054d8:	8082                	ret
    end_op();
    800054da:	b03fe0ef          	jal	80003fdc <end_op>
    return -1;
    800054de:	557d                	li	a0,-1
    800054e0:	bfcd                	j	800054d2 <sys_mknod+0x50>

00000000800054e2 <sys_chdir>:

uint64
sys_chdir(void)
{
    800054e2:	7135                	addi	sp,sp,-160
    800054e4:	ed06                	sd	ra,152(sp)
    800054e6:	e922                	sd	s0,144(sp)
    800054e8:	e14a                	sd	s2,128(sp)
    800054ea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800054ec:	df0fc0ef          	jal	80001adc <myproc>
    800054f0:	892a                	mv	s2,a0
  
  begin_op();
    800054f2:	a7bfe0ef          	jal	80003f6c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800054f6:	08000613          	li	a2,128
    800054fa:	f6040593          	addi	a1,s0,-160
    800054fe:	4501                	li	a0,0
    80005500:	eaafd0ef          	jal	80002baa <argstr>
    80005504:	04054363          	bltz	a0,8000554a <sys_chdir+0x68>
    80005508:	e526                	sd	s1,136(sp)
    8000550a:	f6040513          	addi	a0,s0,-160
    8000550e:	881fe0ef          	jal	80003d8e <namei>
    80005512:	84aa                	mv	s1,a0
    80005514:	c915                	beqz	a0,80005548 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005516:	84afe0ef          	jal	80003560 <ilock>
  if(ip->type != T_DIR){
    8000551a:	04449703          	lh	a4,68(s1)
    8000551e:	4785                	li	a5,1
    80005520:	02f71963          	bne	a4,a5,80005552 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005524:	8526                	mv	a0,s1
    80005526:	8e8fe0ef          	jal	8000360e <iunlock>
  iput(p->cwd);
    8000552a:	15093503          	ld	a0,336(s2)
    8000552e:	9b4fe0ef          	jal	800036e2 <iput>
  end_op();
    80005532:	aabfe0ef          	jal	80003fdc <end_op>
  p->cwd = ip;
    80005536:	14993823          	sd	s1,336(s2)
  return 0;
    8000553a:	4501                	li	a0,0
    8000553c:	64aa                	ld	s1,136(sp)
}
    8000553e:	60ea                	ld	ra,152(sp)
    80005540:	644a                	ld	s0,144(sp)
    80005542:	690a                	ld	s2,128(sp)
    80005544:	610d                	addi	sp,sp,160
    80005546:	8082                	ret
    80005548:	64aa                	ld	s1,136(sp)
    end_op();
    8000554a:	a93fe0ef          	jal	80003fdc <end_op>
    return -1;
    8000554e:	557d                	li	a0,-1
    80005550:	b7fd                	j	8000553e <sys_chdir+0x5c>
    iunlockput(ip);
    80005552:	8526                	mv	a0,s1
    80005554:	a18fe0ef          	jal	8000376c <iunlockput>
    end_op();
    80005558:	a85fe0ef          	jal	80003fdc <end_op>
    return -1;
    8000555c:	557d                	li	a0,-1
    8000555e:	64aa                	ld	s1,136(sp)
    80005560:	bff9                	j	8000553e <sys_chdir+0x5c>

0000000080005562 <sys_exec>:

uint64
sys_exec(void)
{
    80005562:	7105                	addi	sp,sp,-480
    80005564:	ef86                	sd	ra,472(sp)
    80005566:	eba2                	sd	s0,464(sp)
    80005568:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000556a:	e2840593          	addi	a1,s0,-472
    8000556e:	4505                	li	a0,1
    80005570:	e1efd0ef          	jal	80002b8e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005574:	08000613          	li	a2,128
    80005578:	f3040593          	addi	a1,s0,-208
    8000557c:	4501                	li	a0,0
    8000557e:	e2cfd0ef          	jal	80002baa <argstr>
    80005582:	87aa                	mv	a5,a0
    return -1;
    80005584:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005586:	0e07c063          	bltz	a5,80005666 <sys_exec+0x104>
    8000558a:	e7a6                	sd	s1,456(sp)
    8000558c:	e3ca                	sd	s2,448(sp)
    8000558e:	ff4e                	sd	s3,440(sp)
    80005590:	fb52                	sd	s4,432(sp)
    80005592:	f756                	sd	s5,424(sp)
    80005594:	f35a                	sd	s6,416(sp)
    80005596:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005598:	e3040a13          	addi	s4,s0,-464
    8000559c:	10000613          	li	a2,256
    800055a0:	4581                	li	a1,0
    800055a2:	8552                	mv	a0,s4
    800055a4:	f54fb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800055a8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800055aa:	89d2                	mv	s3,s4
    800055ac:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800055ae:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800055b2:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800055b4:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800055b8:	00391513          	slli	a0,s2,0x3
    800055bc:	85d6                	mv	a1,s5
    800055be:	e2843783          	ld	a5,-472(s0)
    800055c2:	953e                	add	a0,a0,a5
    800055c4:	d24fd0ef          	jal	80002ae8 <fetchaddr>
    800055c8:	02054663          	bltz	a0,800055f4 <sys_exec+0x92>
    if(uarg == 0){
    800055cc:	e2043783          	ld	a5,-480(s0)
    800055d0:	c7a1                	beqz	a5,80005618 <sys_exec+0xb6>
    argv[i] = kalloc();
    800055d2:	d72fb0ef          	jal	80000b44 <kalloc>
    800055d6:	85aa                	mv	a1,a0
    800055d8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800055dc:	cd01                	beqz	a0,800055f4 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800055de:	865a                	mv	a2,s6
    800055e0:	e2043503          	ld	a0,-480(s0)
    800055e4:	d4efd0ef          	jal	80002b32 <fetchstr>
    800055e8:	00054663          	bltz	a0,800055f4 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800055ec:	0905                	addi	s2,s2,1
    800055ee:	09a1                	addi	s3,s3,8
    800055f0:	fd7914e3          	bne	s2,s7,800055b8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800055f4:	100a0a13          	addi	s4,s4,256
    800055f8:	6088                	ld	a0,0(s1)
    800055fa:	cd31                	beqz	a0,80005656 <sys_exec+0xf4>
    kfree(argv[i]);
    800055fc:	c60fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005600:	04a1                	addi	s1,s1,8
    80005602:	ff449be3          	bne	s1,s4,800055f8 <sys_exec+0x96>
  return -1;
    80005606:	557d                	li	a0,-1
    80005608:	64be                	ld	s1,456(sp)
    8000560a:	691e                	ld	s2,448(sp)
    8000560c:	79fa                	ld	s3,440(sp)
    8000560e:	7a5a                	ld	s4,432(sp)
    80005610:	7aba                	ld	s5,424(sp)
    80005612:	7b1a                	ld	s6,416(sp)
    80005614:	6bfa                	ld	s7,408(sp)
    80005616:	a881                	j	80005666 <sys_exec+0x104>
      argv[i] = 0;
    80005618:	0009079b          	sext.w	a5,s2
    8000561c:	e3040593          	addi	a1,s0,-464
    80005620:	078e                	slli	a5,a5,0x3
    80005622:	97ae                	add	a5,a5,a1
    80005624:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005628:	f3040513          	addi	a0,s0,-208
    8000562c:	c2aff0ef          	jal	80004a56 <kexec>
    80005630:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005632:	100a0a13          	addi	s4,s4,256
    80005636:	6088                	ld	a0,0(s1)
    80005638:	c511                	beqz	a0,80005644 <sys_exec+0xe2>
    kfree(argv[i]);
    8000563a:	c22fb0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000563e:	04a1                	addi	s1,s1,8
    80005640:	ff449be3          	bne	s1,s4,80005636 <sys_exec+0xd4>
  return ret;
    80005644:	854a                	mv	a0,s2
    80005646:	64be                	ld	s1,456(sp)
    80005648:	691e                	ld	s2,448(sp)
    8000564a:	79fa                	ld	s3,440(sp)
    8000564c:	7a5a                	ld	s4,432(sp)
    8000564e:	7aba                	ld	s5,424(sp)
    80005650:	7b1a                	ld	s6,416(sp)
    80005652:	6bfa                	ld	s7,408(sp)
    80005654:	a809                	j	80005666 <sys_exec+0x104>
  return -1;
    80005656:	557d                	li	a0,-1
    80005658:	64be                	ld	s1,456(sp)
    8000565a:	691e                	ld	s2,448(sp)
    8000565c:	79fa                	ld	s3,440(sp)
    8000565e:	7a5a                	ld	s4,432(sp)
    80005660:	7aba                	ld	s5,424(sp)
    80005662:	7b1a                	ld	s6,416(sp)
    80005664:	6bfa                	ld	s7,408(sp)
}
    80005666:	60fe                	ld	ra,472(sp)
    80005668:	645e                	ld	s0,464(sp)
    8000566a:	613d                	addi	sp,sp,480
    8000566c:	8082                	ret

000000008000566e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000566e:	7139                	addi	sp,sp,-64
    80005670:	fc06                	sd	ra,56(sp)
    80005672:	f822                	sd	s0,48(sp)
    80005674:	f426                	sd	s1,40(sp)
    80005676:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005678:	c64fc0ef          	jal	80001adc <myproc>
    8000567c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000567e:	fd840593          	addi	a1,s0,-40
    80005682:	4501                	li	a0,0
    80005684:	d0afd0ef          	jal	80002b8e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005688:	fc840593          	addi	a1,s0,-56
    8000568c:	fd040513          	addi	a0,s0,-48
    80005690:	81cff0ef          	jal	800046ac <pipealloc>
    return -1;
    80005694:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005696:	0a054763          	bltz	a0,80005744 <sys_pipe+0xd6>
  fd0 = -1;
    8000569a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000569e:	fd043503          	ld	a0,-48(s0)
    800056a2:	ef2ff0ef          	jal	80004d94 <fdalloc>
    800056a6:	fca42223          	sw	a0,-60(s0)
    800056aa:	08054463          	bltz	a0,80005732 <sys_pipe+0xc4>
    800056ae:	fc843503          	ld	a0,-56(s0)
    800056b2:	ee2ff0ef          	jal	80004d94 <fdalloc>
    800056b6:	fca42023          	sw	a0,-64(s0)
    800056ba:	06054263          	bltz	a0,8000571e <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800056be:	4691                	li	a3,4
    800056c0:	fc440613          	addi	a2,s0,-60
    800056c4:	fd843583          	ld	a1,-40(s0)
    800056c8:	68a8                	ld	a0,80(s1)
    800056ca:	83efc0ef          	jal	80001708 <copyout>
    800056ce:	00054e63          	bltz	a0,800056ea <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800056d2:	4691                	li	a3,4
    800056d4:	fc040613          	addi	a2,s0,-64
    800056d8:	fd843583          	ld	a1,-40(s0)
    800056dc:	95b6                	add	a1,a1,a3
    800056de:	68a8                	ld	a0,80(s1)
    800056e0:	828fc0ef          	jal	80001708 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800056e4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800056e6:	04055f63          	bgez	a0,80005744 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800056ea:	fc442783          	lw	a5,-60(s0)
    800056ee:	078e                	slli	a5,a5,0x3
    800056f0:	0d078793          	addi	a5,a5,208
    800056f4:	97a6                	add	a5,a5,s1
    800056f6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800056fa:	fc042783          	lw	a5,-64(s0)
    800056fe:	078e                	slli	a5,a5,0x3
    80005700:	0d078793          	addi	a5,a5,208
    80005704:	97a6                	add	a5,a5,s1
    80005706:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000570a:	fd043503          	ld	a0,-48(s0)
    8000570e:	c83fe0ef          	jal	80004390 <fileclose>
    fileclose(wf);
    80005712:	fc843503          	ld	a0,-56(s0)
    80005716:	c7bfe0ef          	jal	80004390 <fileclose>
    return -1;
    8000571a:	57fd                	li	a5,-1
    8000571c:	a025                	j	80005744 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000571e:	fc442783          	lw	a5,-60(s0)
    80005722:	0007c863          	bltz	a5,80005732 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005726:	078e                	slli	a5,a5,0x3
    80005728:	0d078793          	addi	a5,a5,208
    8000572c:	97a6                	add	a5,a5,s1
    8000572e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005732:	fd043503          	ld	a0,-48(s0)
    80005736:	c5bfe0ef          	jal	80004390 <fileclose>
    fileclose(wf);
    8000573a:	fc843503          	ld	a0,-56(s0)
    8000573e:	c53fe0ef          	jal	80004390 <fileclose>
    return -1;
    80005742:	57fd                	li	a5,-1
}
    80005744:	853e                	mv	a0,a5
    80005746:	70e2                	ld	ra,56(sp)
    80005748:	7442                	ld	s0,48(sp)
    8000574a:	74a2                	ld	s1,40(sp)
    8000574c:	6121                	addi	sp,sp,64
    8000574e:	8082                	ret

0000000080005750 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005750:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005752:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005754:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005756:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005758:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000575a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000575c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000575e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005760:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005762:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005764:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005766:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005768:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000576a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000576c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000576e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005770:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005772:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005774:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005776:	a80fd0ef          	jal	800029f6 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000577a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000577c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000577e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005780:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005782:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005784:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005786:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005788:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000578a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000578c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000578e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005790:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005792:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005794:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005796:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005798:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000579a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000579c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000579e:	10200073          	sret
    800057a2:	00000013          	nop
    800057a6:	00000013          	nop
    800057aa:	00000013          	nop

00000000800057ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800057ae:	1141                	addi	sp,sp,-16
    800057b0:	e406                	sd	ra,8(sp)
    800057b2:	e022                	sd	s0,0(sp)
    800057b4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800057b6:	0c000737          	lui	a4,0xc000
    800057ba:	4785                	li	a5,1
    800057bc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800057be:	c35c                	sw	a5,4(a4)
}
    800057c0:	60a2                	ld	ra,8(sp)
    800057c2:	6402                	ld	s0,0(sp)
    800057c4:	0141                	addi	sp,sp,16
    800057c6:	8082                	ret

00000000800057c8 <plicinithart>:

void
plicinithart(void)
{
    800057c8:	1141                	addi	sp,sp,-16
    800057ca:	e406                	sd	ra,8(sp)
    800057cc:	e022                	sd	s0,0(sp)
    800057ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057d0:	ad8fc0ef          	jal	80001aa8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800057d4:	0085171b          	slliw	a4,a0,0x8
    800057d8:	0c0027b7          	lui	a5,0xc002
    800057dc:	97ba                	add	a5,a5,a4
    800057de:	40200713          	li	a4,1026
    800057e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800057e6:	00d5151b          	slliw	a0,a0,0xd
    800057ea:	0c2017b7          	lui	a5,0xc201
    800057ee:	97aa                	add	a5,a5,a0
    800057f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800057f4:	60a2                	ld	ra,8(sp)
    800057f6:	6402                	ld	s0,0(sp)
    800057f8:	0141                	addi	sp,sp,16
    800057fa:	8082                	ret

00000000800057fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800057fc:	1141                	addi	sp,sp,-16
    800057fe:	e406                	sd	ra,8(sp)
    80005800:	e022                	sd	s0,0(sp)
    80005802:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005804:	aa4fc0ef          	jal	80001aa8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005808:	00d5151b          	slliw	a0,a0,0xd
    8000580c:	0c2017b7          	lui	a5,0xc201
    80005810:	97aa                	add	a5,a5,a0
  return irq;
}
    80005812:	43c8                	lw	a0,4(a5)
    80005814:	60a2                	ld	ra,8(sp)
    80005816:	6402                	ld	s0,0(sp)
    80005818:	0141                	addi	sp,sp,16
    8000581a:	8082                	ret

000000008000581c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000581c:	1101                	addi	sp,sp,-32
    8000581e:	ec06                	sd	ra,24(sp)
    80005820:	e822                	sd	s0,16(sp)
    80005822:	e426                	sd	s1,8(sp)
    80005824:	1000                	addi	s0,sp,32
    80005826:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005828:	a80fc0ef          	jal	80001aa8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000582c:	00d5179b          	slliw	a5,a0,0xd
    80005830:	0c201737          	lui	a4,0xc201
    80005834:	97ba                	add	a5,a5,a4
    80005836:	c3c4                	sw	s1,4(a5)
}
    80005838:	60e2                	ld	ra,24(sp)
    8000583a:	6442                	ld	s0,16(sp)
    8000583c:	64a2                	ld	s1,8(sp)
    8000583e:	6105                	addi	sp,sp,32
    80005840:	8082                	ret

0000000080005842 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005842:	1141                	addi	sp,sp,-16
    80005844:	e406                	sd	ra,8(sp)
    80005846:	e022                	sd	s0,0(sp)
    80005848:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000584a:	479d                	li	a5,7
    8000584c:	04a7ca63          	blt	a5,a0,800058a0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005850:	0001e797          	auipc	a5,0x1e
    80005854:	2b878793          	addi	a5,a5,696 # 80023b08 <disk>
    80005858:	97aa                	add	a5,a5,a0
    8000585a:	0187c783          	lbu	a5,24(a5)
    8000585e:	e7b9                	bnez	a5,800058ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005860:	00451693          	slli	a3,a0,0x4
    80005864:	0001e797          	auipc	a5,0x1e
    80005868:	2a478793          	addi	a5,a5,676 # 80023b08 <disk>
    8000586c:	6398                	ld	a4,0(a5)
    8000586e:	9736                	add	a4,a4,a3
    80005870:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005874:	6398                	ld	a4,0(a5)
    80005876:	9736                	add	a4,a4,a3
    80005878:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000587c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005880:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005884:	97aa                	add	a5,a5,a0
    80005886:	4705                	li	a4,1
    80005888:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000588c:	0001e517          	auipc	a0,0x1e
    80005890:	29450513          	addi	a0,a0,660 # 80023b20 <disk+0x18>
    80005894:	8e5fc0ef          	jal	80002178 <wakeup>
}
    80005898:	60a2                	ld	ra,8(sp)
    8000589a:	6402                	ld	s0,0(sp)
    8000589c:	0141                	addi	sp,sp,16
    8000589e:	8082                	ret
    panic("free_desc 1");
    800058a0:	00002517          	auipc	a0,0x2
    800058a4:	f5850513          	addi	a0,a0,-168 # 800077f8 <etext+0x7f8>
    800058a8:	f7dfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    800058ac:	00002517          	auipc	a0,0x2
    800058b0:	f5c50513          	addi	a0,a0,-164 # 80007808 <etext+0x808>
    800058b4:	f71fa0ef          	jal	80000824 <panic>

00000000800058b8 <virtio_disk_init>:
{
    800058b8:	1101                	addi	sp,sp,-32
    800058ba:	ec06                	sd	ra,24(sp)
    800058bc:	e822                	sd	s0,16(sp)
    800058be:	e426                	sd	s1,8(sp)
    800058c0:	e04a                	sd	s2,0(sp)
    800058c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800058c4:	00002597          	auipc	a1,0x2
    800058c8:	f5458593          	addi	a1,a1,-172 # 80007818 <etext+0x818>
    800058cc:	0001e517          	auipc	a0,0x1e
    800058d0:	36450513          	addi	a0,a0,868 # 80023c30 <disk+0x128>
    800058d4:	acafb0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058d8:	100017b7          	lui	a5,0x10001
    800058dc:	4398                	lw	a4,0(a5)
    800058de:	2701                	sext.w	a4,a4
    800058e0:	747277b7          	lui	a5,0x74727
    800058e4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800058e8:	14f71863          	bne	a4,a5,80005a38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058ec:	100017b7          	lui	a5,0x10001
    800058f0:	43dc                	lw	a5,4(a5)
    800058f2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058f4:	4709                	li	a4,2
    800058f6:	14e79163          	bne	a5,a4,80005a38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058fa:	100017b7          	lui	a5,0x10001
    800058fe:	479c                	lw	a5,8(a5)
    80005900:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005902:	12e79b63          	bne	a5,a4,80005a38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005906:	100017b7          	lui	a5,0x10001
    8000590a:	47d8                	lw	a4,12(a5)
    8000590c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000590e:	554d47b7          	lui	a5,0x554d4
    80005912:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005916:	12f71163          	bne	a4,a5,80005a38 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000591a:	100017b7          	lui	a5,0x10001
    8000591e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005922:	4705                	li	a4,1
    80005924:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005926:	470d                	li	a4,3
    80005928:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000592a:	10001737          	lui	a4,0x10001
    8000592e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005930:	c7ffe6b7          	lui	a3,0xc7ffe
    80005934:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdab17>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005938:	8f75                	and	a4,a4,a3
    8000593a:	100016b7          	lui	a3,0x10001
    8000593e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005940:	472d                	li	a4,11
    80005942:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005944:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005948:	439c                	lw	a5,0(a5)
    8000594a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000594e:	8ba1                	andi	a5,a5,8
    80005950:	0e078a63          	beqz	a5,80005a44 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005954:	100017b7          	lui	a5,0x10001
    80005958:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000595c:	43fc                	lw	a5,68(a5)
    8000595e:	2781                	sext.w	a5,a5
    80005960:	0e079863          	bnez	a5,80005a50 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005964:	100017b7          	lui	a5,0x10001
    80005968:	5bdc                	lw	a5,52(a5)
    8000596a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000596c:	0e078863          	beqz	a5,80005a5c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005970:	471d                	li	a4,7
    80005972:	0ef77b63          	bgeu	a4,a5,80005a68 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005976:	9cefb0ef          	jal	80000b44 <kalloc>
    8000597a:	0001e497          	auipc	s1,0x1e
    8000597e:	18e48493          	addi	s1,s1,398 # 80023b08 <disk>
    80005982:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005984:	9c0fb0ef          	jal	80000b44 <kalloc>
    80005988:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000598a:	9bafb0ef          	jal	80000b44 <kalloc>
    8000598e:	87aa                	mv	a5,a0
    80005990:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005992:	6088                	ld	a0,0(s1)
    80005994:	0e050063          	beqz	a0,80005a74 <virtio_disk_init+0x1bc>
    80005998:	0001e717          	auipc	a4,0x1e
    8000599c:	17873703          	ld	a4,376(a4) # 80023b10 <disk+0x8>
    800059a0:	cb71                	beqz	a4,80005a74 <virtio_disk_init+0x1bc>
    800059a2:	cbe9                	beqz	a5,80005a74 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800059a4:	6605                	lui	a2,0x1
    800059a6:	4581                	li	a1,0
    800059a8:	b50fb0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800059ac:	0001e497          	auipc	s1,0x1e
    800059b0:	15c48493          	addi	s1,s1,348 # 80023b08 <disk>
    800059b4:	6605                	lui	a2,0x1
    800059b6:	4581                	li	a1,0
    800059b8:	6488                	ld	a0,8(s1)
    800059ba:	b3efb0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    800059be:	6605                	lui	a2,0x1
    800059c0:	4581                	li	a1,0
    800059c2:	6888                	ld	a0,16(s1)
    800059c4:	b34fb0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800059c8:	100017b7          	lui	a5,0x10001
    800059cc:	4721                	li	a4,8
    800059ce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800059d0:	4098                	lw	a4,0(s1)
    800059d2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800059d6:	40d8                	lw	a4,4(s1)
    800059d8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800059dc:	649c                	ld	a5,8(s1)
    800059de:	0007869b          	sext.w	a3,a5
    800059e2:	10001737          	lui	a4,0x10001
    800059e6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800059ea:	9781                	srai	a5,a5,0x20
    800059ec:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800059f0:	689c                	ld	a5,16(s1)
    800059f2:	0007869b          	sext.w	a3,a5
    800059f6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800059fa:	9781                	srai	a5,a5,0x20
    800059fc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005a00:	4785                	li	a5,1
    80005a02:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005a04:	00f48c23          	sb	a5,24(s1)
    80005a08:	00f48ca3          	sb	a5,25(s1)
    80005a0c:	00f48d23          	sb	a5,26(s1)
    80005a10:	00f48da3          	sb	a5,27(s1)
    80005a14:	00f48e23          	sb	a5,28(s1)
    80005a18:	00f48ea3          	sb	a5,29(s1)
    80005a1c:	00f48f23          	sb	a5,30(s1)
    80005a20:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a24:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a28:	07272823          	sw	s2,112(a4)
}
    80005a2c:	60e2                	ld	ra,24(sp)
    80005a2e:	6442                	ld	s0,16(sp)
    80005a30:	64a2                	ld	s1,8(sp)
    80005a32:	6902                	ld	s2,0(sp)
    80005a34:	6105                	addi	sp,sp,32
    80005a36:	8082                	ret
    panic("could not find virtio disk");
    80005a38:	00002517          	auipc	a0,0x2
    80005a3c:	df050513          	addi	a0,a0,-528 # 80007828 <etext+0x828>
    80005a40:	de5fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a44:	00002517          	auipc	a0,0x2
    80005a48:	e0450513          	addi	a0,a0,-508 # 80007848 <etext+0x848>
    80005a4c:	dd9fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005a50:	00002517          	auipc	a0,0x2
    80005a54:	e1850513          	addi	a0,a0,-488 # 80007868 <etext+0x868>
    80005a58:	dcdfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    80005a5c:	00002517          	auipc	a0,0x2
    80005a60:	e2c50513          	addi	a0,a0,-468 # 80007888 <etext+0x888>
    80005a64:	dc1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005a68:	00002517          	auipc	a0,0x2
    80005a6c:	e4050513          	addi	a0,a0,-448 # 800078a8 <etext+0x8a8>
    80005a70:	db5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005a74:	00002517          	auipc	a0,0x2
    80005a78:	e5450513          	addi	a0,a0,-428 # 800078c8 <etext+0x8c8>
    80005a7c:	da9fa0ef          	jal	80000824 <panic>

0000000080005a80 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005a80:	711d                	addi	sp,sp,-96
    80005a82:	ec86                	sd	ra,88(sp)
    80005a84:	e8a2                	sd	s0,80(sp)
    80005a86:	e4a6                	sd	s1,72(sp)
    80005a88:	e0ca                	sd	s2,64(sp)
    80005a8a:	fc4e                	sd	s3,56(sp)
    80005a8c:	f852                	sd	s4,48(sp)
    80005a8e:	f456                	sd	s5,40(sp)
    80005a90:	f05a                	sd	s6,32(sp)
    80005a92:	ec5e                	sd	s7,24(sp)
    80005a94:	e862                	sd	s8,16(sp)
    80005a96:	1080                	addi	s0,sp,96
    80005a98:	89aa                	mv	s3,a0
    80005a9a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005a9c:	00c52b83          	lw	s7,12(a0)
    80005aa0:	001b9b9b          	slliw	s7,s7,0x1
    80005aa4:	1b82                	slli	s7,s7,0x20
    80005aa6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005aaa:	0001e517          	auipc	a0,0x1e
    80005aae:	18650513          	addi	a0,a0,390 # 80023c30 <disk+0x128>
    80005ab2:	976fb0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005ab6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005ab8:	0001ea97          	auipc	s5,0x1e
    80005abc:	050a8a93          	addi	s5,s5,80 # 80023b08 <disk>
  for(int i = 0; i < 3; i++){
    80005ac0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005ac2:	5c7d                	li	s8,-1
    80005ac4:	a095                	j	80005b28 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005ac6:	00fa8733          	add	a4,s5,a5
    80005aca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005ace:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005ad0:	0207c563          	bltz	a5,80005afa <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005ad4:	2905                	addiw	s2,s2,1
    80005ad6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005ad8:	05490c63          	beq	s2,s4,80005b30 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005adc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005ade:	0001e717          	auipc	a4,0x1e
    80005ae2:	02a70713          	addi	a4,a4,42 # 80023b08 <disk>
    80005ae6:	4781                	li	a5,0
    if(disk.free[i]){
    80005ae8:	01874683          	lbu	a3,24(a4)
    80005aec:	fee9                	bnez	a3,80005ac6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005aee:	2785                	addiw	a5,a5,1
    80005af0:	0705                	addi	a4,a4,1
    80005af2:	fe979be3          	bne	a5,s1,80005ae8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005af6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005afa:	01205d63          	blez	s2,80005b14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005afe:	fa042503          	lw	a0,-96(s0)
    80005b02:	d41ff0ef          	jal	80005842 <free_desc>
      for(int j = 0; j < i; j++)
    80005b06:	4785                	li	a5,1
    80005b08:	0127d663          	bge	a5,s2,80005b14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005b0c:	fa442503          	lw	a0,-92(s0)
    80005b10:	d33ff0ef          	jal	80005842 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005b14:	0001e597          	auipc	a1,0x1e
    80005b18:	11c58593          	addi	a1,a1,284 # 80023c30 <disk+0x128>
    80005b1c:	0001e517          	auipc	a0,0x1e
    80005b20:	00450513          	addi	a0,a0,4 # 80023b20 <disk+0x18>
    80005b24:	e08fc0ef          	jal	8000212c <sleep>
  for(int i = 0; i < 3; i++){
    80005b28:	fa040613          	addi	a2,s0,-96
    80005b2c:	4901                	li	s2,0
    80005b2e:	b77d                	j	80005adc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b30:	fa042503          	lw	a0,-96(s0)
    80005b34:	00451693          	slli	a3,a0,0x4

  if(write)
    80005b38:	0001e797          	auipc	a5,0x1e
    80005b3c:	fd078793          	addi	a5,a5,-48 # 80023b08 <disk>
    80005b40:	00451713          	slli	a4,a0,0x4
    80005b44:	0a070713          	addi	a4,a4,160
    80005b48:	973e                	add	a4,a4,a5
    80005b4a:	01603633          	snez	a2,s6
    80005b4e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b50:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005b54:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b58:	6398                	ld	a4,0(a5)
    80005b5a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b5c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005b60:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b62:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b64:	6390                	ld	a2,0(a5)
    80005b66:	00d60833          	add	a6,a2,a3
    80005b6a:	4741                	li	a4,16
    80005b6c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005b70:	4585                	li	a1,1
    80005b72:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005b76:	fa442703          	lw	a4,-92(s0)
    80005b7a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b7e:	0712                	slli	a4,a4,0x4
    80005b80:	963a                	add	a2,a2,a4
    80005b82:	05898813          	addi	a6,s3,88
    80005b86:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b8a:	0007b883          	ld	a7,0(a5)
    80005b8e:	9746                	add	a4,a4,a7
    80005b90:	40000613          	li	a2,1024
    80005b94:	c710                	sw	a2,8(a4)
  if(write)
    80005b96:	001b3613          	seqz	a2,s6
    80005b9a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005b9e:	8e4d                	or	a2,a2,a1
    80005ba0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005ba4:	fa842603          	lw	a2,-88(s0)
    80005ba8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005bac:	00451813          	slli	a6,a0,0x4
    80005bb0:	02080813          	addi	a6,a6,32
    80005bb4:	983e                	add	a6,a6,a5
    80005bb6:	577d                	li	a4,-1
    80005bb8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005bbc:	0612                	slli	a2,a2,0x4
    80005bbe:	98b2                	add	a7,a7,a2
    80005bc0:	03068713          	addi	a4,a3,48
    80005bc4:	973e                	add	a4,a4,a5
    80005bc6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005bca:	6398                	ld	a4,0(a5)
    80005bcc:	9732                	add	a4,a4,a2
    80005bce:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005bd0:	4689                	li	a3,2
    80005bd2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005bd6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005bda:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005bde:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005be2:	6794                	ld	a3,8(a5)
    80005be4:	0026d703          	lhu	a4,2(a3)
    80005be8:	8b1d                	andi	a4,a4,7
    80005bea:	0706                	slli	a4,a4,0x1
    80005bec:	96ba                	add	a3,a3,a4
    80005bee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005bf2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005bf6:	6798                	ld	a4,8(a5)
    80005bf8:	00275783          	lhu	a5,2(a4)
    80005bfc:	2785                	addiw	a5,a5,1
    80005bfe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005c02:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c06:	100017b7          	lui	a5,0x10001
    80005c0a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005c0e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005c12:	0001e917          	auipc	s2,0x1e
    80005c16:	01e90913          	addi	s2,s2,30 # 80023c30 <disk+0x128>
  while(b->disk == 1) {
    80005c1a:	84ae                	mv	s1,a1
    80005c1c:	00b79a63          	bne	a5,a1,80005c30 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005c20:	85ca                	mv	a1,s2
    80005c22:	854e                	mv	a0,s3
    80005c24:	d08fc0ef          	jal	8000212c <sleep>
  while(b->disk == 1) {
    80005c28:	0049a783          	lw	a5,4(s3)
    80005c2c:	fe978ae3          	beq	a5,s1,80005c20 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005c30:	fa042903          	lw	s2,-96(s0)
    80005c34:	00491713          	slli	a4,s2,0x4
    80005c38:	02070713          	addi	a4,a4,32
    80005c3c:	0001e797          	auipc	a5,0x1e
    80005c40:	ecc78793          	addi	a5,a5,-308 # 80023b08 <disk>
    80005c44:	97ba                	add	a5,a5,a4
    80005c46:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c4a:	0001e997          	auipc	s3,0x1e
    80005c4e:	ebe98993          	addi	s3,s3,-322 # 80023b08 <disk>
    80005c52:	00491713          	slli	a4,s2,0x4
    80005c56:	0009b783          	ld	a5,0(s3)
    80005c5a:	97ba                	add	a5,a5,a4
    80005c5c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c60:	854a                	mv	a0,s2
    80005c62:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c66:	bddff0ef          	jal	80005842 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c6a:	8885                	andi	s1,s1,1
    80005c6c:	f0fd                	bnez	s1,80005c52 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c6e:	0001e517          	auipc	a0,0x1e
    80005c72:	fc250513          	addi	a0,a0,-62 # 80023c30 <disk+0x128>
    80005c76:	846fb0ef          	jal	80000cbc <release>
}
    80005c7a:	60e6                	ld	ra,88(sp)
    80005c7c:	6446                	ld	s0,80(sp)
    80005c7e:	64a6                	ld	s1,72(sp)
    80005c80:	6906                	ld	s2,64(sp)
    80005c82:	79e2                	ld	s3,56(sp)
    80005c84:	7a42                	ld	s4,48(sp)
    80005c86:	7aa2                	ld	s5,40(sp)
    80005c88:	7b02                	ld	s6,32(sp)
    80005c8a:	6be2                	ld	s7,24(sp)
    80005c8c:	6c42                	ld	s8,16(sp)
    80005c8e:	6125                	addi	sp,sp,96
    80005c90:	8082                	ret

0000000080005c92 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005c92:	1101                	addi	sp,sp,-32
    80005c94:	ec06                	sd	ra,24(sp)
    80005c96:	e822                	sd	s0,16(sp)
    80005c98:	e426                	sd	s1,8(sp)
    80005c9a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005c9c:	0001e497          	auipc	s1,0x1e
    80005ca0:	e6c48493          	addi	s1,s1,-404 # 80023b08 <disk>
    80005ca4:	0001e517          	auipc	a0,0x1e
    80005ca8:	f8c50513          	addi	a0,a0,-116 # 80023c30 <disk+0x128>
    80005cac:	f7dfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cb0:	100017b7          	lui	a5,0x10001
    80005cb4:	53bc                	lw	a5,96(a5)
    80005cb6:	8b8d                	andi	a5,a5,3
    80005cb8:	10001737          	lui	a4,0x10001
    80005cbc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005cbe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cc2:	689c                	ld	a5,16(s1)
    80005cc4:	0204d703          	lhu	a4,32(s1)
    80005cc8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ccc:	04f70863          	beq	a4,a5,80005d1c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005cd0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005cd4:	6898                	ld	a4,16(s1)
    80005cd6:	0204d783          	lhu	a5,32(s1)
    80005cda:	8b9d                	andi	a5,a5,7
    80005cdc:	078e                	slli	a5,a5,0x3
    80005cde:	97ba                	add	a5,a5,a4
    80005ce0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005ce2:	00479713          	slli	a4,a5,0x4
    80005ce6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005cea:	9726                	add	a4,a4,s1
    80005cec:	01074703          	lbu	a4,16(a4)
    80005cf0:	e329                	bnez	a4,80005d32 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005cf2:	0792                	slli	a5,a5,0x4
    80005cf4:	02078793          	addi	a5,a5,32
    80005cf8:	97a6                	add	a5,a5,s1
    80005cfa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005cfc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d00:	c78fc0ef          	jal	80002178 <wakeup>

    disk.used_idx += 1;
    80005d04:	0204d783          	lhu	a5,32(s1)
    80005d08:	2785                	addiw	a5,a5,1
    80005d0a:	17c2                	slli	a5,a5,0x30
    80005d0c:	93c1                	srli	a5,a5,0x30
    80005d0e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d12:	6898                	ld	a4,16(s1)
    80005d14:	00275703          	lhu	a4,2(a4)
    80005d18:	faf71ce3          	bne	a4,a5,80005cd0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005d1c:	0001e517          	auipc	a0,0x1e
    80005d20:	f1450513          	addi	a0,a0,-236 # 80023c30 <disk+0x128>
    80005d24:	f99fa0ef          	jal	80000cbc <release>
}
    80005d28:	60e2                	ld	ra,24(sp)
    80005d2a:	6442                	ld	s0,16(sp)
    80005d2c:	64a2                	ld	s1,8(sp)
    80005d2e:	6105                	addi	sp,sp,32
    80005d30:	8082                	ret
      panic("virtio_disk_intr status");
    80005d32:	00002517          	auipc	a0,0x2
    80005d36:	bae50513          	addi	a0,a0,-1106 # 800078e0 <etext+0x8e0>
    80005d3a:	aebfa0ef          	jal	80000824 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
