
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	63010113          	addi	sp,sp,1584 # 8000b630 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffb3cc7>
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
    8000011a:	686020ef          	jal	800027a0 <either_copyin>
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
    80000196:	49e50513          	addi	a0,a0,1182 # 80013630 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00013497          	auipc	s1,0x13
    800001a2:	49248493          	addi	s1,s1,1170 # 80013630 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00013917          	auipc	s2,0x13
    800001aa:	52290913          	addi	s2,s2,1314 # 800136c8 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	1dd010ef          	jal	80001b9a <myproc>
    800001c2:	474020ef          	jal	80002636 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	07c020ef          	jal	80002248 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00013717          	auipc	a4,0x13
    800001e2:	45270713          	addi	a4,a4,1106 # 80013630 <cons>
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
    80000210:	546020ef          	jal	80002756 <either_copyout>
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
    8000022c:	40850513          	addi	a0,a0,1032 # 80013630 <cons>
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
    80000252:	46f72d23          	sw	a5,1146(a4) # 800136c8 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00013517          	auipc	a0,0x13
    80000268:	3cc50513          	addi	a0,a0,972 # 80013630 <cons>
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
    800002bc:	37850513          	addi	a0,a0,888 # 80013630 <cons>
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
    800002da:	510020ef          	jal	800027ea <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00013517          	auipc	a0,0x13
    800002e2:	35250513          	addi	a0,a0,850 # 80013630 <cons>
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
    80000300:	33470713          	addi	a4,a4,820 # 80013630 <cons>
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
    80000326:	30e70713          	addi	a4,a4,782 # 80013630 <cons>
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
    80000350:	37c72703          	lw	a4,892(a4) # 800136c8 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00013717          	auipc	a4,0x13
    80000366:	2ce70713          	addi	a4,a4,718 # 80013630 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00013497          	auipc	s1,0x13
    80000376:	2be48493          	addi	s1,s1,702 # 80013630 <cons>
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
    800003b8:	27c70713          	addi	a4,a4,636 # 80013630 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00013717          	auipc	a4,0x13
    800003ce:	30f72323          	sw	a5,774(a4) # 800136d0 <cons+0xa0>
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
    800003ec:	24878793          	addi	a5,a5,584 # 80013630 <cons>
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
    8000040e:	2cc7a123          	sw	a2,706(a5) # 800136cc <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00013517          	auipc	a0,0x13
    80000416:	2b650513          	addi	a0,a0,694 # 800136c8 <cons+0x98>
    8000041a:	67b010ef          	jal	80002294 <wakeup>
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
    80000434:	20050513          	addi	a0,a0,512 # 80013630 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00049797          	auipc	a5,0x49
    80000444:	56078793          	addi	a5,a5,1376 # 800499a0 <devsw>
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
    80000482:	4fa80813          	addi	a6,a6,1274 # 80008978 <digits>
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
    8000051c:	0ec7a783          	lw	a5,236(a5) # 8000b604 <panicking>
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
    80000562:	17a50513          	addi	a0,a0,378 # 800136d8 <pr>
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
    800006d6:	2a6c8c93          	addi	s9,s9,678 # 80008978 <digits>
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
    8000075e:	eaa7a783          	lw	a5,-342(a5) # 8000b604 <panicking>
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
    80000788:	f5450513          	addi	a0,a0,-172 # 800136d8 <pr>
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
    80000838:	dc97a823          	sw	s1,-560(a5) # 8000b604 <panicking>
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
    8000085a:	da97a523          	sw	s1,-598(a5) # 8000b600 <panicked>
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
    80000874:	e6850513          	addi	a0,a0,-408 # 800136d8 <pr>
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
    800008ca:	e2a50513          	addi	a0,a0,-470 # 800136f0 <tx_lock>
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
    800008ee:	e0650513          	addi	a0,a0,-506 # 800136f0 <tx_lock>
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
    8000090c:	d0448493          	addi	s1,s1,-764 # 8000b60c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00013997          	auipc	s3,0x13
    80000914:	de098993          	addi	s3,s3,-544 # 800136f0 <tx_lock>
    80000918:	0000b917          	auipc	s2,0xb
    8000091c:	cf090913          	addi	s2,s2,-784 # 8000b608 <tx_chan>
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
    8000092c:	11d010ef          	jal	80002248 <sleep>
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
    8000095a:	d9a50513          	addi	a0,a0,-614 # 800136f0 <tx_lock>
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
    8000097e:	c8a7a783          	lw	a5,-886(a5) # 8000b604 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	0000b797          	auipc	a5,0xb
    80000988:	c7c7a783          	lw	a5,-900(a5) # 8000b600 <panicked>
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
    800009ae:	c5a7a783          	lw	a5,-934(a5) # 8000b604 <panicking>
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
    80000a0a:	cea50513          	addi	a0,a0,-790 # 800136f0 <tx_lock>
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
    80000a24:	cd050513          	addi	a0,a0,-816 # 800136f0 <tx_lock>
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
    80000a40:	bc07a823          	sw	zero,-1072(a5) # 8000b60c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	0000b517          	auipc	a0,0xb
    80000a48:	bc450513          	addi	a0,a0,-1084 # 8000b608 <tx_chan>
    80000a4c:	049010ef          	jal	80002294 <wakeup>
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
    80000a68:	0004a797          	auipc	a5,0x4a
    80000a6c:	0d078793          	addi	a5,a5,208 # 8004ab38 <end>
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
    80000a96:	c7690913          	addi	s2,s2,-906 # 80013708 <kmem>
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
    80000b24:	be850513          	addi	a0,a0,-1048 # 80013708 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	0004a517          	auipc	a0,0x4a
    80000b34:	00850513          	addi	a0,a0,8 # 8004ab38 <end>
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
    80000b52:	bba50513          	addi	a0,a0,-1094 # 80013708 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00013497          	auipc	s1,0x13
    80000b5e:	bc64b483          	ld	s1,-1082(s1) # 80013720 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00013717          	auipc	a4,0x13
    80000b6a:	baf73d23          	sd	a5,-1094(a4) # 80013720 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00013517          	auipc	a0,0x13
    80000b72:	b9a50513          	addi	a0,a0,-1126 # 80013708 <kmem>
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
    80000b94:	b7850513          	addi	a0,a0,-1160 # 80013708 <kmem>
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
    80000bce:	7ad000ef          	jal	80001b7a <mycpu>
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
    80000bfe:	77d000ef          	jal	80001b7a <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	775000ef          	jal	80001b7a <mycpu>
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
    80000c1a:	761000ef          	jal	80001b7a <mycpu>
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
    80000c50:	72b000ef          	jal	80001b7a <mycpu>
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
    80000c74:	707000ef          	jal	80001b7a <mycpu>
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
    80000eb6:	4b1000ef          	jal	80001b66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	0000a717          	auipc	a4,0xa
    80000ebe:	75670713          	addi	a4,a4,1878 # 8000b610 <started>
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
    80000ece:	499000ef          	jal	80001b66 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1c450513          	addi	a0,a0,452 # 80008098 <etext+0x98>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	241010ef          	jal	80002924 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	5b1040ef          	jal	80005c98 <plicinithart>
  }

  scheduler();        
    80000eec:	1be010ef          	jal	800020aa <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	18050513          	addi	a0,a0,384 # 80008078 <etext+0x78>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	17c50513          	addi	a0,a0,380 # 80008080 <etext+0x80>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	16850513          	addi	a0,a0,360 # 80008078 <etext+0x78>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	56e000ef          	jal	8000148e <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	385000ef          	jal	80001aac <procinit>
    trapinit();      // trap vectors
    80000f2c:	1d5010ef          	jal	80002900 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	1f5010ef          	jal	80002924 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	54b040ef          	jal	80005c7e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	561040ef          	jal	80005c98 <plicinithart>
    binit();         // buffer cache
    80000f3c:	1fe020ef          	jal	8000313a <binit>
    iinit();         // inode table
    80000f40:	750020ef          	jal	80003690 <iinit>
    fileinit();      // file table
    80000f44:	67c030ef          	jal	800045c0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	641040ef          	jal	80005d88 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	79b000ef          	jal	80001ee6 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	0000a717          	auipc	a4,0xa
    80000f5a:	6af72d23          	sw	a5,1722(a4) # 8000b610 <started>
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
    80000f6c:	0000a797          	auipc	a5,0xa
    80000f70:	6ac7b783          	ld	a5,1708(a5) # 8000b618 <kernel_pagetable>
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
    80000ff6:	0be50513          	addi	a0,a0,190 # 800080b0 <etext+0xb0>
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
    800010ce:	fee50513          	addi	a0,a0,-18 # 800080b8 <etext+0xb8>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
        panic("mappages: size not aligned");
    800010d6:	00007517          	auipc	a0,0x7
    800010da:	00250513          	addi	a0,a0,2 # 800080d8 <etext+0xd8>
    800010de:	f46ff0ef          	jal	80000824 <panic>
        panic("mappages: size");
    800010e2:	00007517          	auipc	a0,0x7
    800010e6:	01650513          	addi	a0,a0,22 # 800080f8 <etext+0xf8>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
            panic("mappages: remap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	01a50513          	addi	a0,a0,26 # 80008108 <etext+0x108>
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
    80001116:	715d                	addi	sp,sp,-80
    80001118:	e486                	sd	ra,72(sp)
    8000111a:	e0a2                	sd	s0,64(sp)
    8000111c:	fc26                	sd	s1,56(sp)
    8000111e:	f84a                	sd	s2,48(sp)
    80001120:	e45e                	sd	s7,8(sp)
    80001122:	0880                	addi	s0,sp,80
    80001124:	892a                	mv	s2,a0
    80001126:	8baa                	mv	s7,a0
    80001128:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    8000112a:	271000ef          	jal	80001b9a <myproc>
  if(va >= MAXVA)
    8000112e:	57fd                	li	a5,-1
    80001130:	83e9                	srli	a5,a5,0x1a
    80001132:	2697e163          	bltu	a5,s1,80001394 <handle_pgfault+0x27e>
    80001136:	f44e                	sd	s3,40(sp)
    80001138:	f052                	sd	s4,32(sp)
    8000113a:	89aa                	mv	s3,a0
  va = PGROUNDDOWN(va);
    8000113c:	77fd                	lui	a5,0xfffff
    8000113e:	8cfd                	and	s1,s1,a5
  pte = walk(pagetable, va, 0);
    80001140:	4601                	li	a2,0
    80001142:	85a6                	mv	a1,s1
    80001144:	854a                	mv	a0,s2
    80001146:	e47ff0ef          	jal	80000f8c <walk>
    8000114a:	892a                	mv	s2,a0
  if(pte != 0 && (*pte & PTE_SWAPPED)) {
    8000114c:	c511                	beqz	a0,80001158 <handle_pgfault+0x42>
    8000114e:	00053a03          	ld	s4,0(a0)
    80001152:	100a7793          	andi	a5,s4,256
    80001156:	e3b5                	bnez	a5,800011ba <handle_pgfault+0xa4>
  mem = kalloc();
    80001158:	9edff0ef          	jal	80000b44 <kalloc>
    8000115c:	8a2a                	mv	s4,a0
  if(mem == 0) {
    8000115e:	10050863          	beqz	a0,8000126e <handle_pgfault+0x158>
  int is_heap = (va >= p->heap_start && va < p->sz);
    80001162:	1689b783          	ld	a5,360(s3)
    80001166:	22f4e963          	bltu	s1,a5,80001398 <handle_pgfault+0x282>
    8000116a:	0489b783          	ld	a5,72(s3)
    8000116e:	00f4b7b3          	sltu	a5,s1,a5
  int is_stack = (va >= p->trapframe->sp - PGSIZE && va < p->sz); 
    80001172:	0589b703          	ld	a4,88(s3)
    80001176:	7b18                	ld	a4,48(a4)
    80001178:	80070713          	addi	a4,a4,-2048
    8000117c:	80070713          	addi	a4,a4,-2048
    80001180:	22e4f763          	bgeu	s1,a4,800013ae <handle_pgfault+0x298>
    80001184:	4701                	li	a4,0
  else if (is_heap || is_stack) {
    80001186:	8fd9                	or	a5,a5,a4
    80001188:	1e078f63          	beqz	a5,80001386 <handle_pgfault+0x270>
      memset(mem, 0, PGSIZE);
    8000118c:	6605                	lui	a2,0x1
    8000118e:	4581                	li	a1,0
    80001190:	8552                	mv	a0,s4
    80001192:	b67ff0ef          	jal	80000cf8 <memset>
      if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_W|PTE_U|PTE_R) != 0) {
    80001196:	4759                	li	a4,22
    80001198:	86d2                	mv	a3,s4
    8000119a:	6605                	lui	a2,0x1
    8000119c:	85a6                	mv	a1,s1
    8000119e:	855e                	mv	a0,s7
    800011a0:	ec1ff0ef          	jal	80001060 <mappages>
    800011a4:	1c051a63          	bnez	a0,80001378 <handle_pgfault+0x262>
    800011a8:	79a2                	ld	s3,40(sp)
    800011aa:	7a02                	ld	s4,32(sp)
}
    800011ac:	60a6                	ld	ra,72(sp)
    800011ae:	6406                	ld	s0,64(sp)
    800011b0:	74e2                	ld	s1,56(sp)
    800011b2:	7942                	ld	s2,48(sp)
    800011b4:	6ba2                	ld	s7,8(sp)
    800011b6:	6161                	addi	sp,sp,80
    800011b8:	8082                	ret
    800011ba:	ec56                	sd	s5,24(sp)
    printf("[pid %d] Need to get the data from the swap space\n",p->pid);
    800011bc:	0309a583          	lw	a1,48(s3)
    800011c0:	00007517          	auipc	a0,0x7
    800011c4:	f5850513          	addi	a0,a0,-168 # 80008118 <etext+0x118>
    800011c8:	b32ff0ef          	jal	800004fa <printf>
    mem = kalloc();
    800011cc:	979ff0ef          	jal	80000b44 <kalloc>
    800011d0:	8aaa                	mv	s5,a0
    if(mem == 0) {
    800011d2:	c135                	beqz	a0,80001236 <handle_pgfault+0x120>
    int swap_slot = (*pte >> 10); // Extract swap slot from PTE
    800011d4:	00aa5a13          	srli	s4,s4,0xa
    800011d8:	2a01                	sext.w	s4,s4
    ilock(p->swap_file);
    800011da:	3609b503          	ld	a0,864(s3)
    800011de:	67a020ef          	jal	80003858 <ilock>
    if(readi(p->swap_file, 0, (uint64)mem, swap_slot * PGSIZE, PGSIZE) != PGSIZE) {
    800011e2:	6705                	lui	a4,0x1
    800011e4:	00ca169b          	slliw	a3,s4,0xc
    800011e8:	8656                	mv	a2,s5
    800011ea:	4581                	li	a1,0
    800011ec:	3609b503          	ld	a0,864(s3)
    800011f0:	1fb020ef          	jal	80003bea <readi>
    800011f4:	6785                	lui	a5,0x1
    800011f6:	04f51863          	bne	a0,a5,80001246 <handle_pgfault+0x130>
    iunlock(p->swap_file);
    800011fa:	3609b503          	ld	a0,864(s3)
    800011fe:	708020ef          	jal	80003906 <iunlock>
    if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_FLAGS(*pte) | PTE_V) != 0) {
    80001202:	00093703          	ld	a4,0(s2)
    80001206:	3fe77713          	andi	a4,a4,1022
    8000120a:	00176713          	ori	a4,a4,1
    8000120e:	86d6                	mv	a3,s5
    80001210:	6605                	lui	a2,0x1
    80001212:	85a6                	mv	a1,s1
    80001214:	855e                	mv	a0,s7
    80001216:	e4bff0ef          	jal	80001060 <mappages>
    8000121a:	e131                	bnez	a0,8000125e <handle_pgfault+0x148>
    *pte &= ~PTE_SWAPPED;
    8000121c:	00093783          	ld	a5,0(s2)
    80001220:	eff7f793          	andi	a5,a5,-257
    80001224:	00f93023          	sd	a5,0(s2)
    p->swap_slots[swap_slot] = 0;
    80001228:	9a4e                	add	s4,s4,s3
    8000122a:	360a0423          	sb	zero,872(s4)
    return 0; // Swap-in successful
    8000122e:	79a2                	ld	s3,40(sp)
    80001230:	7a02                	ld	s4,32(sp)
    80001232:	6ae2                	ld	s5,24(sp)
    80001234:	bfa5                	j	800011ac <handle_pgfault+0x96>
    80001236:	e85a                	sd	s6,16(sp)
    80001238:	e062                	sd	s8,0(sp)
      panic("1\n");
    8000123a:	00007517          	auipc	a0,0x7
    8000123e:	f1650513          	addi	a0,a0,-234 # 80008150 <etext+0x150>
    80001242:	de2ff0ef          	jal	80000824 <panic>
      iunlock(p->swap_file);
    80001246:	3609b503          	ld	a0,864(s3)
    8000124a:	6bc020ef          	jal	80003906 <iunlock>
      kfree(mem);
    8000124e:	8556                	mv	a0,s5
    80001250:	80dff0ef          	jal	80000a5c <kfree>
      return -1;
    80001254:	557d                	li	a0,-1
    80001256:	79a2                	ld	s3,40(sp)
    80001258:	7a02                	ld	s4,32(sp)
    8000125a:	6ae2                	ld	s5,24(sp)
    8000125c:	bf81                	j	800011ac <handle_pgfault+0x96>
      kfree(mem);
    8000125e:	8556                	mv	a0,s5
    80001260:	ffcff0ef          	jal	80000a5c <kfree>
      return -1;
    80001264:	557d                	li	a0,-1
    80001266:	79a2                	ld	s3,40(sp)
    80001268:	7a02                	ld	s4,32(sp)
    8000126a:	6ae2                	ld	s5,24(sp)
    8000126c:	b781                	j	800011ac <handle_pgfault+0x96>
    8000126e:	ec56                	sd	s5,24(sp)
    80001270:	e85a                	sd	s6,16(sp)
    80001272:	e062                	sd	s8,0(sp)
    panic("[pid ] MEMFULL\n");
    80001274:	00007517          	auipc	a0,0x7
    80001278:	ee450513          	addi	a0,a0,-284 # 80008158 <etext+0x158>
    8000127c:	da8ff0ef          	jal	80000824 <panic>
      for(int i = 0; i < p->num_phdrs; i++) {
    80001280:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80001282:	03878793          	addi	a5,a5,56 # 1038 <_entry-0x7fffefc8>
    80001286:	04d70963          	beq	a4,a3,800012d8 <handle_pgfault+0x1c2>
          ph = p->phdrs[i]; 
    8000128a:	0007b903          	ld	s2,0(a5)
          if(va >= ph.vaddr && va < ph.vaddr + ph.memsz) {
    8000128e:	ff24e9e3          	bltu	s1,s2,80001280 <handle_pgfault+0x16a>
    80001292:	6f8c                	ld	a1,24(a5)
    80001294:	95ca                	add	a1,a1,s2
    80001296:	feb4f5e3          	bgeu	s1,a1,80001280 <handle_pgfault+0x16a>
          ph = p->phdrs[i]; 
    8000129a:	00371793          	slli	a5,a4,0x3
    8000129e:	40e786b3          	sub	a3,a5,a4
    800012a2:	068e                	slli	a3,a3,0x3
    800012a4:	96ce                	add	a3,a3,s3
    800012a6:	7746a603          	lw	a2,1908(a3)
    800012aa:	8c32                	mv	s8,a2
    800012ac:	7786bb03          	ld	s6,1912(a3)
    800012b0:	7906ba83          	ld	s5,1936(a3)
      memset(mem, 0, PGSIZE);
    800012b4:	6605                	lui	a2,0x1
    800012b6:	4581                	li	a1,0
    800012b8:	8552                	mv	a0,s4
    800012ba:	a3fff0ef          	jal	80000cf8 <memset>
      uint file_offset = ph.off + (va - ph.vaddr);
    800012be:	0004869b          	sext.w	a3,s1
    800012c2:	0009071b          	sext.w	a4,s2
    800012c6:	412b07bb          	subw	a5,s6,s2
    800012ca:	9fa5                	addw	a5,a5,s1
    800012cc:	8b3e                	mv	s6,a5
      uint to_read = (ph.vaddr + ph.filesz > va) ? ph.filesz - (va - ph.vaddr) : 0;
    800012ce:	9956                	add	s2,s2,s5
    800012d0:	0124ee63          	bltu	s1,s2,800012ec <handle_pgfault+0x1d6>
    800012d4:	4901                	li	s2,0
    800012d6:	a025                	j	800012fe <handle_pgfault+0x1e8>
    800012d8:	6ae2                	ld	s5,24(sp)
    800012da:	6b42                	ld	s6,16(sp)
    800012dc:	6c02                	ld	s8,0(sp)
      if(!found) { kfree(mem); return -1; } // Should not happen if heap_start is correct
    800012de:	8552                	mv	a0,s4
    800012e0:	f7cff0ef          	jal	80000a5c <kfree>
    800012e4:	557d                	li	a0,-1
    800012e6:	79a2                	ld	s3,40(sp)
    800012e8:	7a02                	ld	s4,32(sp)
    800012ea:	b5c9                	j	800011ac <handle_pgfault+0x96>
      uint to_read = (ph.vaddr + ph.filesz > va) ? ph.filesz - (va - ph.vaddr) : 0;
    800012ec:	9f15                	subw	a4,a4,a3
    800012ee:	0157073b          	addw	a4,a4,s5
    800012f2:	893a                	mv	s2,a4
      if(to_read > PGSIZE) to_read = PGSIZE;
    800012f4:	6785                	lui	a5,0x1
    800012f6:	00e7f363          	bgeu	a5,a4,800012fc <handle_pgfault+0x1e6>
    800012fa:	6905                	lui	s2,0x1
    800012fc:	2901                	sext.w	s2,s2
      ilock(p->exec_ip);
    800012fe:	1709b503          	ld	a0,368(s3)
    80001302:	556020ef          	jal	80003858 <ilock>
      if(readi(p->exec_ip, 0, (uint64)mem, file_offset, to_read) != to_read) {
    80001306:	874a                	mv	a4,s2
    80001308:	86da                	mv	a3,s6
    8000130a:	8652                	mv	a2,s4
    8000130c:	4581                	li	a1,0
    8000130e:	1709b503          	ld	a0,368(s3)
    80001312:	0d9020ef          	jal	80003bea <readi>
    80001316:	02a91963          	bne	s2,a0,80001348 <handle_pgfault+0x232>
      iunlock(p->exec_ip);
    8000131a:	1709b503          	ld	a0,368(s3)
    8000131e:	5e8020ef          	jal	80003906 <iunlock>
      if(mappages(pagetable, va, PGSIZE, (uint64)mem, flags2perm(ph.flags) | PTE_U) != 0) {
    80001322:	8562                	mv	a0,s8
    80001324:	201030ef          	jal	80004d24 <flags2perm>
    80001328:	01056713          	ori	a4,a0,16
    8000132c:	2701                	sext.w	a4,a4
    8000132e:	86d2                	mv	a3,s4
    80001330:	6605                	lui	a2,0x1
    80001332:	85a6                	mv	a1,s1
    80001334:	855e                	mv	a0,s7
    80001336:	d2bff0ef          	jal	80001060 <mappages>
    8000133a:	e50d                	bnez	a0,80001364 <handle_pgfault+0x24e>
    8000133c:	79a2                	ld	s3,40(sp)
    8000133e:	7a02                	ld	s4,32(sp)
    80001340:	6ae2                	ld	s5,24(sp)
    80001342:	6b42                	ld	s6,16(sp)
    80001344:	6c02                	ld	s8,0(sp)
    80001346:	b59d                	j	800011ac <handle_pgfault+0x96>
          iunlock(p->exec_ip);
    80001348:	1709b503          	ld	a0,368(s3)
    8000134c:	5ba020ef          	jal	80003906 <iunlock>
          kfree(mem); 
    80001350:	8552                	mv	a0,s4
    80001352:	f0aff0ef          	jal	80000a5c <kfree>
          return -1;
    80001356:	557d                	li	a0,-1
    80001358:	79a2                	ld	s3,40(sp)
    8000135a:	7a02                	ld	s4,32(sp)
    8000135c:	6ae2                	ld	s5,24(sp)
    8000135e:	6b42                	ld	s6,16(sp)
    80001360:	6c02                	ld	s8,0(sp)
    80001362:	b5a9                	j	800011ac <handle_pgfault+0x96>
          kfree(mem); 
    80001364:	8552                	mv	a0,s4
    80001366:	ef6ff0ef          	jal	80000a5c <kfree>
          return -1;
    8000136a:	557d                	li	a0,-1
    8000136c:	79a2                	ld	s3,40(sp)
    8000136e:	7a02                	ld	s4,32(sp)
    80001370:	6ae2                	ld	s5,24(sp)
    80001372:	6b42                	ld	s6,16(sp)
    80001374:	6c02                	ld	s8,0(sp)
    80001376:	bd1d                	j	800011ac <handle_pgfault+0x96>
          kfree(mem); 
    80001378:	8552                	mv	a0,s4
    8000137a:	ee2ff0ef          	jal	80000a5c <kfree>
          return -1;
    8000137e:	557d                	li	a0,-1
    80001380:	79a2                	ld	s3,40(sp)
    80001382:	7a02                	ld	s4,32(sp)
    80001384:	b525                	j	800011ac <handle_pgfault+0x96>
      kfree(mem);
    80001386:	8552                	mv	a0,s4
    80001388:	ed4ff0ef          	jal	80000a5c <kfree>
      return -1;
    8000138c:	557d                	li	a0,-1
    8000138e:	79a2                	ld	s3,40(sp)
    80001390:	7a02                	ld	s4,32(sp)
    80001392:	bd29                	j	800011ac <handle_pgfault+0x96>
    return -1;
    80001394:	557d                	li	a0,-1
    80001396:	bd19                	j	800011ac <handle_pgfault+0x96>
      for(int i = 0; i < p->num_phdrs; i++) {
    80001398:	7689a683          	lw	a3,1896(s3)
    8000139c:	78098793          	addi	a5,s3,1920
    800013a0:	4701                	li	a4,0
    800013a2:	f2d05ee3          	blez	a3,800012de <handle_pgfault+0x1c8>
    800013a6:	ec56                	sd	s5,24(sp)
    800013a8:	e85a                	sd	s6,16(sp)
    800013aa:	e062                	sd	s8,0(sp)
    800013ac:	bdf9                	j	8000128a <handle_pgfault+0x174>
  int is_stack = (va >= p->trapframe->sp - PGSIZE && va < p->sz); 
    800013ae:	0489b703          	ld	a4,72(s3)
    800013b2:	00e4b733          	sltu	a4,s1,a4
    800013b6:	bbc1                	j	80001186 <handle_pgfault+0x70>

00000000800013b8 <kvmmap>:
{
    800013b8:	1141                	addi	sp,sp,-16
    800013ba:	e406                	sd	ra,8(sp)
    800013bc:	e022                	sd	s0,0(sp)
    800013be:	0800                	addi	s0,sp,16
    800013c0:	87b6                	mv	a5,a3
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800013c2:	86b2                	mv	a3,a2
    800013c4:	863e                	mv	a2,a5
    800013c6:	c9bff0ef          	jal	80001060 <mappages>
    800013ca:	e509                	bnez	a0,800013d4 <kvmmap+0x1c>
}
    800013cc:	60a2                	ld	ra,8(sp)
    800013ce:	6402                	ld	s0,0(sp)
    800013d0:	0141                	addi	sp,sp,16
    800013d2:	8082                	ret
        panic("kvmmap");
    800013d4:	00007517          	auipc	a0,0x7
    800013d8:	d9450513          	addi	a0,a0,-620 # 80008168 <etext+0x168>
    800013dc:	c48ff0ef          	jal	80000824 <panic>

00000000800013e0 <kvmmake>:
{
    800013e0:	1101                	addi	sp,sp,-32
    800013e2:	ec06                	sd	ra,24(sp)
    800013e4:	e822                	sd	s0,16(sp)
    800013e6:	e426                	sd	s1,8(sp)
    800013e8:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t) kalloc();
    800013ea:	f5aff0ef          	jal	80000b44 <kalloc>
    800013ee:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    800013f0:	6605                	lui	a2,0x1
    800013f2:	4581                	li	a1,0
    800013f4:	905ff0ef          	jal	80000cf8 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800013f8:	4719                	li	a4,6
    800013fa:	6685                	lui	a3,0x1
    800013fc:	10000637          	lui	a2,0x10000
    80001400:	85b2                	mv	a1,a2
    80001402:	8526                	mv	a0,s1
    80001404:	fb5ff0ef          	jal	800013b8 <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001408:	4719                	li	a4,6
    8000140a:	6685                	lui	a3,0x1
    8000140c:	10001637          	lui	a2,0x10001
    80001410:	85b2                	mv	a1,a2
    80001412:	8526                	mv	a0,s1
    80001414:	fa5ff0ef          	jal	800013b8 <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001418:	4719                	li	a4,6
    8000141a:	040006b7          	lui	a3,0x4000
    8000141e:	0c000637          	lui	a2,0xc000
    80001422:	85b2                	mv	a1,a2
    80001424:	8526                	mv	a0,s1
    80001426:	f93ff0ef          	jal	800013b8 <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000142a:	4729                	li	a4,10
    8000142c:	80007697          	auipc	a3,0x80007
    80001430:	bd468693          	addi	a3,a3,-1068 # 8000 <_entry-0x7fff8000>
    80001434:	4605                	li	a2,1
    80001436:	067e                	slli	a2,a2,0x1f
    80001438:	85b2                	mv	a1,a2
    8000143a:	8526                	mv	a0,s1
    8000143c:	f7dff0ef          	jal	800013b8 <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001440:	4719                	li	a4,6
    80001442:	00007697          	auipc	a3,0x7
    80001446:	bbe68693          	addi	a3,a3,-1090 # 80008000 <etext>
    8000144a:	47c5                	li	a5,17
    8000144c:	07ee                	slli	a5,a5,0x1b
    8000144e:	40d786b3          	sub	a3,a5,a3
    80001452:	00007617          	auipc	a2,0x7
    80001456:	bae60613          	addi	a2,a2,-1106 # 80008000 <etext>
    8000145a:	85b2                	mv	a1,a2
    8000145c:	8526                	mv	a0,s1
    8000145e:	f5bff0ef          	jal	800013b8 <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001462:	4729                	li	a4,10
    80001464:	6685                	lui	a3,0x1
    80001466:	00006617          	auipc	a2,0x6
    8000146a:	b9a60613          	addi	a2,a2,-1126 # 80007000 <_trampoline>
    8000146e:	040005b7          	lui	a1,0x4000
    80001472:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001474:	05b2                	slli	a1,a1,0xc
    80001476:	8526                	mv	a0,s1
    80001478:	f41ff0ef          	jal	800013b8 <kvmmap>
    proc_mapstacks(kpgtbl);
    8000147c:	8526                	mv	a0,s1
    8000147e:	588000ef          	jal	80001a06 <proc_mapstacks>
}
    80001482:	8526                	mv	a0,s1
    80001484:	60e2                	ld	ra,24(sp)
    80001486:	6442                	ld	s0,16(sp)
    80001488:	64a2                	ld	s1,8(sp)
    8000148a:	6105                	addi	sp,sp,32
    8000148c:	8082                	ret

000000008000148e <kvminit>:
{
    8000148e:	1141                	addi	sp,sp,-16
    80001490:	e406                	sd	ra,8(sp)
    80001492:	e022                	sd	s0,0(sp)
    80001494:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    80001496:	f4bff0ef          	jal	800013e0 <kvmmake>
    8000149a:	0000a797          	auipc	a5,0xa
    8000149e:	16a7bf23          	sd	a0,382(a5) # 8000b618 <kernel_pagetable>
}
    800014a2:	60a2                	ld	ra,8(sp)
    800014a4:	6402                	ld	s0,0(sp)
    800014a6:	0141                	addi	sp,sp,16
    800014a8:	8082                	ret

00000000800014aa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
    pagetable_t
uvmcreate()
{
    800014aa:	1101                	addi	sp,sp,-32
    800014ac:	ec06                	sd	ra,24(sp)
    800014ae:	e822                	sd	s0,16(sp)
    800014b0:	e426                	sd	s1,8(sp)
    800014b2:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    800014b4:	e90ff0ef          	jal	80000b44 <kalloc>
    800014b8:	84aa                	mv	s1,a0
    if(pagetable == 0)
    800014ba:	c509                	beqz	a0,800014c4 <uvmcreate+0x1a>
        return 0;
    memset(pagetable, 0, PGSIZE);
    800014bc:	6605                	lui	a2,0x1
    800014be:	4581                	li	a1,0
    800014c0:	839ff0ef          	jal	80000cf8 <memset>
    return pagetable;
}
    800014c4:	8526                	mv	a0,s1
    800014c6:	60e2                	ld	ra,24(sp)
    800014c8:	6442                	ld	s0,16(sp)
    800014ca:	64a2                	ld	s1,8(sp)
    800014cc:	6105                	addi	sp,sp,32
    800014ce:	8082                	ret

00000000800014d0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
    void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800014d0:	7139                	addi	sp,sp,-64
    800014d2:	fc06                	sd	ra,56(sp)
    800014d4:	f822                	sd	s0,48(sp)
    800014d6:	0080                	addi	s0,sp,64
    uint64 a;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    800014d8:	03459793          	slli	a5,a1,0x34
    800014dc:	e38d                	bnez	a5,800014fe <uvmunmap+0x2e>
    800014de:	f04a                	sd	s2,32(sp)
    800014e0:	ec4e                	sd	s3,24(sp)
    800014e2:	e852                	sd	s4,16(sp)
    800014e4:	e456                	sd	s5,8(sp)
    800014e6:	e05a                	sd	s6,0(sp)
    800014e8:	8a2a                	mv	s4,a0
    800014ea:	892e                	mv	s2,a1
    800014ec:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014ee:	0632                	slli	a2,a2,0xc
    800014f0:	00b609b3          	add	s3,a2,a1
    800014f4:	6b05                	lui	s6,0x1
    800014f6:	0535f963          	bgeu	a1,s3,80001548 <uvmunmap+0x78>
    800014fa:	f426                	sd	s1,40(sp)
    800014fc:	a015                	j	80001520 <uvmunmap+0x50>
    800014fe:	f426                	sd	s1,40(sp)
    80001500:	f04a                	sd	s2,32(sp)
    80001502:	ec4e                	sd	s3,24(sp)
    80001504:	e852                	sd	s4,16(sp)
    80001506:	e456                	sd	s5,8(sp)
    80001508:	e05a                	sd	s6,0(sp)
        panic("uvmunmap: not aligned");
    8000150a:	00007517          	auipc	a0,0x7
    8000150e:	c6650513          	addi	a0,a0,-922 # 80008170 <etext+0x170>
    80001512:	b12ff0ef          	jal	80000824 <panic>
            continue;
        if(do_free){
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        *pte = 0;
    80001516:	0004b023          	sd	zero,0(s1)
    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000151a:	995a                	add	s2,s2,s6
    8000151c:	03397563          	bgeu	s2,s3,80001546 <uvmunmap+0x76>
        if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001520:	4601                	li	a2,0
    80001522:	85ca                	mv	a1,s2
    80001524:	8552                	mv	a0,s4
    80001526:	a67ff0ef          	jal	80000f8c <walk>
    8000152a:	84aa                	mv	s1,a0
    8000152c:	d57d                	beqz	a0,8000151a <uvmunmap+0x4a>
        if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000152e:	611c                	ld	a5,0(a0)
    80001530:	0017f713          	andi	a4,a5,1
    80001534:	d37d                	beqz	a4,8000151a <uvmunmap+0x4a>
        if(do_free){
    80001536:	fe0a80e3          	beqz	s5,80001516 <uvmunmap+0x46>
            uint64 pa = PTE2PA(*pte);
    8000153a:	83a9                	srli	a5,a5,0xa
            kfree((void*)pa);
    8000153c:	00c79513          	slli	a0,a5,0xc
    80001540:	d1cff0ef          	jal	80000a5c <kfree>
    80001544:	bfc9                	j	80001516 <uvmunmap+0x46>
    80001546:	74a2                	ld	s1,40(sp)
    80001548:	7902                	ld	s2,32(sp)
    8000154a:	69e2                	ld	s3,24(sp)
    8000154c:	6a42                	ld	s4,16(sp)
    8000154e:	6aa2                	ld	s5,8(sp)
    80001550:	6b02                	ld	s6,0(sp)
    }
}
    80001552:	70e2                	ld	ra,56(sp)
    80001554:	7442                	ld	s0,48(sp)
    80001556:	6121                	addi	sp,sp,64
    80001558:	8082                	ret

000000008000155a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000155a:	1101                	addi	sp,sp,-32
    8000155c:	ec06                	sd	ra,24(sp)
    8000155e:	e822                	sd	s0,16(sp)
    80001560:	e426                	sd	s1,8(sp)
    80001562:	1000                	addi	s0,sp,32
    if(newsz >= oldsz)
        return oldsz;
    80001564:	84ae                	mv	s1,a1
    if(newsz >= oldsz)
    80001566:	00b67d63          	bgeu	a2,a1,80001580 <uvmdealloc+0x26>
    8000156a:	84b2                	mv	s1,a2

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000156c:	6785                	lui	a5,0x1
    8000156e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001570:	00f60733          	add	a4,a2,a5
    80001574:	76fd                	lui	a3,0xfffff
    80001576:	8f75                	and	a4,a4,a3
    80001578:	97ae                	add	a5,a5,a1
    8000157a:	8ff5                	and	a5,a5,a3
    8000157c:	00f76863          	bltu	a4,a5,8000158c <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    80001580:	8526                	mv	a0,s1
    80001582:	60e2                	ld	ra,24(sp)
    80001584:	6442                	ld	s0,16(sp)
    80001586:	64a2                	ld	s1,8(sp)
    80001588:	6105                	addi	sp,sp,32
    8000158a:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000158c:	8f99                	sub	a5,a5,a4
    8000158e:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001590:	4685                	li	a3,1
    80001592:	0007861b          	sext.w	a2,a5
    80001596:	85ba                	mv	a1,a4
    80001598:	f39ff0ef          	jal	800014d0 <uvmunmap>
    8000159c:	b7d5                	j	80001580 <uvmdealloc+0x26>

000000008000159e <uvmalloc>:
    if(newsz < oldsz)
    8000159e:	0ab66163          	bltu	a2,a1,80001640 <uvmalloc+0xa2>
{
    800015a2:	715d                	addi	sp,sp,-80
    800015a4:	e486                	sd	ra,72(sp)
    800015a6:	e0a2                	sd	s0,64(sp)
    800015a8:	f84a                	sd	s2,48(sp)
    800015aa:	f052                	sd	s4,32(sp)
    800015ac:	ec56                	sd	s5,24(sp)
    800015ae:	e45e                	sd	s7,8(sp)
    800015b0:	0880                	addi	s0,sp,80
    800015b2:	8aaa                	mv	s5,a0
    800015b4:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800015b6:	6785                	lui	a5,0x1
    800015b8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ba:	95be                	add	a1,a1,a5
    800015bc:	77fd                	lui	a5,0xfffff
    800015be:	00f5f933          	and	s2,a1,a5
    800015c2:	8bca                	mv	s7,s2
    for(a = oldsz; a < newsz; a += PGSIZE){
    800015c4:	08c97063          	bgeu	s2,a2,80001644 <uvmalloc+0xa6>
    800015c8:	fc26                	sd	s1,56(sp)
    800015ca:	f44e                	sd	s3,40(sp)
    800015cc:	e85a                	sd	s6,16(sp)
        memset(mem, 0, PGSIZE);
    800015ce:	6985                	lui	s3,0x1
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015d0:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800015d4:	d70ff0ef          	jal	80000b44 <kalloc>
    800015d8:	84aa                	mv	s1,a0
        if(mem == 0){
    800015da:	c50d                	beqz	a0,80001604 <uvmalloc+0x66>
        memset(mem, 0, PGSIZE);
    800015dc:	864e                	mv	a2,s3
    800015de:	4581                	li	a1,0
    800015e0:	f18ff0ef          	jal	80000cf8 <memset>
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800015e4:	875a                	mv	a4,s6
    800015e6:	86a6                	mv	a3,s1
    800015e8:	864e                	mv	a2,s3
    800015ea:	85ca                	mv	a1,s2
    800015ec:	8556                	mv	a0,s5
    800015ee:	a73ff0ef          	jal	80001060 <mappages>
    800015f2:	e915                	bnez	a0,80001626 <uvmalloc+0x88>
    for(a = oldsz; a < newsz; a += PGSIZE){
    800015f4:	994e                	add	s2,s2,s3
    800015f6:	fd496fe3          	bltu	s2,s4,800015d4 <uvmalloc+0x36>
    return newsz;
    800015fa:	8552                	mv	a0,s4
    800015fc:	74e2                	ld	s1,56(sp)
    800015fe:	79a2                	ld	s3,40(sp)
    80001600:	6b42                	ld	s6,16(sp)
    80001602:	a811                	j	80001616 <uvmalloc+0x78>
            uvmdealloc(pagetable, a, oldsz);
    80001604:	865e                	mv	a2,s7
    80001606:	85ca                	mv	a1,s2
    80001608:	8556                	mv	a0,s5
    8000160a:	f51ff0ef          	jal	8000155a <uvmdealloc>
            return 0;
    8000160e:	4501                	li	a0,0
    80001610:	74e2                	ld	s1,56(sp)
    80001612:	79a2                	ld	s3,40(sp)
    80001614:	6b42                	ld	s6,16(sp)
}
    80001616:	60a6                	ld	ra,72(sp)
    80001618:	6406                	ld	s0,64(sp)
    8000161a:	7942                	ld	s2,48(sp)
    8000161c:	7a02                	ld	s4,32(sp)
    8000161e:	6ae2                	ld	s5,24(sp)
    80001620:	6ba2                	ld	s7,8(sp)
    80001622:	6161                	addi	sp,sp,80
    80001624:	8082                	ret
            kfree(mem);
    80001626:	8526                	mv	a0,s1
    80001628:	c34ff0ef          	jal	80000a5c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    8000162c:	865e                	mv	a2,s7
    8000162e:	85ca                	mv	a1,s2
    80001630:	8556                	mv	a0,s5
    80001632:	f29ff0ef          	jal	8000155a <uvmdealloc>
            return 0;
    80001636:	4501                	li	a0,0
    80001638:	74e2                	ld	s1,56(sp)
    8000163a:	79a2                	ld	s3,40(sp)
    8000163c:	6b42                	ld	s6,16(sp)
    8000163e:	bfe1                	j	80001616 <uvmalloc+0x78>
        return oldsz;
    80001640:	852e                	mv	a0,a1
}
    80001642:	8082                	ret
    return newsz;
    80001644:	8532                	mv	a0,a2
    80001646:	bfc1                	j	80001616 <uvmalloc+0x78>

0000000080001648 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
    void
freewalk(pagetable_t pagetable)
{
    80001648:	7179                	addi	sp,sp,-48
    8000164a:	f406                	sd	ra,40(sp)
    8000164c:	f022                	sd	s0,32(sp)
    8000164e:	ec26                	sd	s1,24(sp)
    80001650:	e84a                	sd	s2,16(sp)
    80001652:	e44e                	sd	s3,8(sp)
    80001654:	1800                	addi	s0,sp,48
    80001656:	89aa                	mv	s3,a0
    // there are 2^9 = 512 PTEs in a page table.
    for(int i = 0; i < 512; i++){
    80001658:	84aa                	mv	s1,a0
    8000165a:	6905                	lui	s2,0x1
    8000165c:	992a                	add	s2,s2,a0
    8000165e:	a811                	j	80001672 <freewalk+0x2a>
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
            freewalk((pagetable_t)child);
            pagetable[i] = 0;
        } else if(pte & PTE_V){
            panic("freewalk: leaf");
    80001660:	00007517          	auipc	a0,0x7
    80001664:	b2850513          	addi	a0,a0,-1240 # 80008188 <etext+0x188>
    80001668:	9bcff0ef          	jal	80000824 <panic>
    for(int i = 0; i < 512; i++){
    8000166c:	04a1                	addi	s1,s1,8
    8000166e:	03248163          	beq	s1,s2,80001690 <freewalk+0x48>
        pte_t pte = pagetable[i];
    80001672:	609c                	ld	a5,0(s1)
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001674:	0017f713          	andi	a4,a5,1
    80001678:	db75                	beqz	a4,8000166c <freewalk+0x24>
    8000167a:	00e7f713          	andi	a4,a5,14
    8000167e:	f36d                	bnez	a4,80001660 <freewalk+0x18>
            uint64 child = PTE2PA(pte);
    80001680:	83a9                	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    80001682:	00c79513          	slli	a0,a5,0xc
    80001686:	fc3ff0ef          	jal	80001648 <freewalk>
            pagetable[i] = 0;
    8000168a:	0004b023          	sd	zero,0(s1)
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000168e:	bff9                	j	8000166c <freewalk+0x24>
        }
    }
    kfree((void*)pagetable);
    80001690:	854e                	mv	a0,s3
    80001692:	bcaff0ef          	jal	80000a5c <kfree>
}
    80001696:	70a2                	ld	ra,40(sp)
    80001698:	7402                	ld	s0,32(sp)
    8000169a:	64e2                	ld	s1,24(sp)
    8000169c:	6942                	ld	s2,16(sp)
    8000169e:	69a2                	ld	s3,8(sp)
    800016a0:	6145                	addi	sp,sp,48
    800016a2:	8082                	ret

00000000800016a4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
    void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800016a4:	1101                	addi	sp,sp,-32
    800016a6:	ec06                	sd	ra,24(sp)
    800016a8:	e822                	sd	s0,16(sp)
    800016aa:	e426                	sd	s1,8(sp)
    800016ac:	1000                	addi	s0,sp,32
    800016ae:	84aa                	mv	s1,a0
    if(sz > 0)
    800016b0:	e989                	bnez	a1,800016c2 <uvmfree+0x1e>
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    freewalk(pagetable);
    800016b2:	8526                	mv	a0,s1
    800016b4:	f95ff0ef          	jal	80001648 <freewalk>
}
    800016b8:	60e2                	ld	ra,24(sp)
    800016ba:	6442                	ld	s0,16(sp)
    800016bc:	64a2                	ld	s1,8(sp)
    800016be:	6105                	addi	sp,sp,32
    800016c0:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800016c2:	6785                	lui	a5,0x1
    800016c4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800016c6:	95be                	add	a1,a1,a5
    800016c8:	4685                	li	a3,1
    800016ca:	00c5d613          	srli	a2,a1,0xc
    800016ce:	4581                	li	a1,0
    800016d0:	e01ff0ef          	jal	800014d0 <uvmunmap>
    800016d4:	bff9                	j	800016b2 <uvmfree+0xe>

00000000800016d6 <uvmcopy>:
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for(i = 0; i < sz; i += PGSIZE){
    800016d6:	ca45                	beqz	a2,80001786 <uvmcopy+0xb0>
{
    800016d8:	715d                	addi	sp,sp,-80
    800016da:	e486                	sd	ra,72(sp)
    800016dc:	e0a2                	sd	s0,64(sp)
    800016de:	fc26                	sd	s1,56(sp)
    800016e0:	f84a                	sd	s2,48(sp)
    800016e2:	f44e                	sd	s3,40(sp)
    800016e4:	f052                	sd	s4,32(sp)
    800016e6:	ec56                	sd	s5,24(sp)
    800016e8:	e85a                	sd	s6,16(sp)
    800016ea:	e45e                	sd	s7,8(sp)
    800016ec:	e062                	sd	s8,0(sp)
    800016ee:	0880                	addi	s0,sp,80
    800016f0:	8b2a                	mv	s6,a0
    800016f2:	8bae                	mv	s7,a1
    800016f4:	8ab2                	mv	s5,a2
    for(i = 0; i < sz; i += PGSIZE){
    800016f6:	4901                	li	s2,0
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto err;
        memmove(mem, (char*)pa, PGSIZE);
    800016f8:	6a05                	lui	s4,0x1
            pte_t *child_pte = walk(new,i,1);
    800016fa:	4c05                	li	s8,1
    800016fc:	a03d                	j	8000172a <uvmcopy+0x54>
        if((mem = kalloc()) == 0)
    800016fe:	c46ff0ef          	jal	80000b44 <kalloc>
    80001702:	84aa                	mv	s1,a0
    80001704:	c939                	beqz	a0,8000175a <uvmcopy+0x84>
        pa = PTE2PA(*pte);
    80001706:	00a9d593          	srli	a1,s3,0xa
        memmove(mem, (char*)pa, PGSIZE);
    8000170a:	8652                	mv	a2,s4
    8000170c:	05b2                	slli	a1,a1,0xc
    8000170e:	e4aff0ef          	jal	80000d58 <memmove>
        if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001712:	3ff9f713          	andi	a4,s3,1023
    80001716:	86a6                	mv	a3,s1
    80001718:	8652                	mv	a2,s4
    8000171a:	85ca                	mv	a1,s2
    8000171c:	855e                	mv	a0,s7
    8000171e:	943ff0ef          	jal	80001060 <mappages>
    80001722:	e90d                	bnez	a0,80001754 <uvmcopy+0x7e>
    for(i = 0; i < sz; i += PGSIZE){
    80001724:	9952                	add	s2,s2,s4
    80001726:	05597363          	bgeu	s2,s5,8000176c <uvmcopy+0x96>
        if((pte = walk(old, i, 0)) == 0)
    8000172a:	4601                	li	a2,0
    8000172c:	85ca                	mv	a1,s2
    8000172e:	855a                	mv	a0,s6
    80001730:	85dff0ef          	jal	80000f8c <walk>
    80001734:	84aa                	mv	s1,a0
    80001736:	d57d                	beqz	a0,80001724 <uvmcopy+0x4e>
        if((*pte & PTE_V) == 0){
    80001738:	00053983          	ld	s3,0(a0)
    8000173c:	0019f793          	andi	a5,s3,1
    80001740:	ffdd                	bnez	a5,800016fe <uvmcopy+0x28>
            pte_t *child_pte = walk(new,i,1);
    80001742:	8662                	mv	a2,s8
    80001744:	85ca                	mv	a1,s2
    80001746:	855e                	mv	a0,s7
    80001748:	845ff0ef          	jal	80000f8c <walk>
            if(child_pte == 0)
    8000174c:	c519                	beqz	a0,8000175a <uvmcopy+0x84>
            *child_pte = *pte;
    8000174e:	609c                	ld	a5,0(s1)
    80001750:	e11c                	sd	a5,0(a0)
            continue;
    80001752:	bfc9                	j	80001724 <uvmcopy+0x4e>
            kfree(mem);
    80001754:	8526                	mv	a0,s1
    80001756:	b06ff0ef          	jal	80000a5c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    8000175a:	4685                	li	a3,1
    8000175c:	00c95613          	srli	a2,s2,0xc
    80001760:	4581                	li	a1,0
    80001762:	855e                	mv	a0,s7
    80001764:	d6dff0ef          	jal	800014d0 <uvmunmap>
    return -1;
    80001768:	557d                	li	a0,-1
    8000176a:	a011                	j	8000176e <uvmcopy+0x98>
    return 0;
    8000176c:	4501                	li	a0,0
}
    8000176e:	60a6                	ld	ra,72(sp)
    80001770:	6406                	ld	s0,64(sp)
    80001772:	74e2                	ld	s1,56(sp)
    80001774:	7942                	ld	s2,48(sp)
    80001776:	79a2                	ld	s3,40(sp)
    80001778:	7a02                	ld	s4,32(sp)
    8000177a:	6ae2                	ld	s5,24(sp)
    8000177c:	6b42                	ld	s6,16(sp)
    8000177e:	6ba2                	ld	s7,8(sp)
    80001780:	6c02                	ld	s8,0(sp)
    80001782:	6161                	addi	sp,sp,80
    80001784:	8082                	ret
    return 0;
    80001786:	4501                	li	a0,0
}
    80001788:	8082                	ret

000000008000178a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
    void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000178a:	1141                	addi	sp,sp,-16
    8000178c:	e406                	sd	ra,8(sp)
    8000178e:	e022                	sd	s0,0(sp)
    80001790:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80001792:	4601                	li	a2,0
    80001794:	ff8ff0ef          	jal	80000f8c <walk>
    if(pte == 0)
    80001798:	c901                	beqz	a0,800017a8 <uvmclear+0x1e>
        panic("uvmclear");
    *pte &= ~PTE_U;
    8000179a:	611c                	ld	a5,0(a0)
    8000179c:	9bbd                	andi	a5,a5,-17
    8000179e:	e11c                	sd	a5,0(a0)
}
    800017a0:	60a2                	ld	ra,8(sp)
    800017a2:	6402                	ld	s0,0(sp)
    800017a4:	0141                	addi	sp,sp,16
    800017a6:	8082                	ret
        panic("uvmclear");
    800017a8:	00007517          	auipc	a0,0x7
    800017ac:	9f050513          	addi	a0,a0,-1552 # 80008198 <etext+0x198>
    800017b0:	874ff0ef          	jal	80000824 <panic>

00000000800017b4 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;
    pte_t *pte;

    while(len > 0){
    800017b4:	ced9                	beqz	a3,80001852 <copyout+0x9e>
{
    800017b6:	711d                	addi	sp,sp,-96
    800017b8:	ec86                	sd	ra,88(sp)
    800017ba:	e8a2                	sd	s0,80(sp)
    800017bc:	e4a6                	sd	s1,72(sp)
    800017be:	e0ca                	sd	s2,64(sp)
    800017c0:	fc4e                	sd	s3,56(sp)
    800017c2:	f852                	sd	s4,48(sp)
    800017c4:	f456                	sd	s5,40(sp)
    800017c6:	f05a                	sd	s6,32(sp)
    800017c8:	ec5e                	sd	s7,24(sp)
    800017ca:	e862                	sd	s8,16(sp)
    800017cc:	e466                	sd	s9,8(sp)
    800017ce:	e06a                	sd	s10,0(sp)
    800017d0:	1080                	addi	s0,sp,96
    800017d2:	8b2a                	mv	s6,a0
    800017d4:	8a2e                	mv	s4,a1
    800017d6:	8bb2                	mv	s7,a2
    800017d8:	8ab6                	mv	s5,a3
        va0 = PGROUNDDOWN(dstva);
    800017da:	7d7d                	lui	s10,0xfffff
        if(va0 >= MAXVA)
    800017dc:	5cfd                	li	s9,-1
    800017de:	01acdc93          	srli	s9,s9,0x1a
        pte = walk(pagetable, va0, 0);
        // forbid copyout over read-only user text pages.
        if((*pte & PTE_W) == 0)
            return -1;

        n = PGSIZE - (dstva - va0);
    800017e2:	6c05                	lui	s8,0x1
    800017e4:	a835                	j	80001820 <copyout+0x6c>
        pte = walk(pagetable, va0, 0);
    800017e6:	4601                	li	a2,0
    800017e8:	85a6                	mv	a1,s1
    800017ea:	855a                	mv	a0,s6
    800017ec:	fa0ff0ef          	jal	80000f8c <walk>
        if((*pte & PTE_W) == 0)
    800017f0:	611c                	ld	a5,0(a0)
    800017f2:	8b91                	andi	a5,a5,4
    800017f4:	c3d1                	beqz	a5,80001878 <copyout+0xc4>
        n = PGSIZE - (dstva - va0);
    800017f6:	41448933          	sub	s2,s1,s4
    800017fa:	9962                	add	s2,s2,s8
        if(n > len)
    800017fc:	012af363          	bgeu	s5,s2,80001802 <copyout+0x4e>
    80001800:	8956                	mv	s2,s5
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001802:	409a0533          	sub	a0,s4,s1
    80001806:	0009061b          	sext.w	a2,s2
    8000180a:	85de                	mv	a1,s7
    8000180c:	954e                	add	a0,a0,s3
    8000180e:	d4aff0ef          	jal	80000d58 <memmove>

        len -= n;
    80001812:	412a8ab3          	sub	s5,s5,s2
        src += n;
    80001816:	9bca                	add	s7,s7,s2
        dstva = va0 + PGSIZE;
    80001818:	01848a33          	add	s4,s1,s8
    while(len > 0){
    8000181c:	020a8963          	beqz	s5,8000184e <copyout+0x9a>
        va0 = PGROUNDDOWN(dstva);
    80001820:	01aa74b3          	and	s1,s4,s10
        if(va0 >= MAXVA)
    80001824:	029ce963          	bltu	s9,s1,80001856 <copyout+0xa2>
        pa0 = walkaddr(pagetable, va0);
    80001828:	85a6                	mv	a1,s1
    8000182a:	855a                	mv	a0,s6
    8000182c:	ffaff0ef          	jal	80001026 <walkaddr>
    80001830:	89aa                	mv	s3,a0
        if(pa0 == 0) {
    80001832:	f955                	bnez	a0,800017e6 <copyout+0x32>
            if(handle_pgfault(pagetable, va0) != 0) {
    80001834:	85a6                	mv	a1,s1
    80001836:	855a                	mv	a0,s6
    80001838:	8dfff0ef          	jal	80001116 <handle_pgfault>
    8000183c:	ed05                	bnez	a0,80001874 <copyout+0xc0>
            pa0 = walkaddr(pagetable, va0); // Retry getting the address
    8000183e:	85a6                	mv	a1,s1
    80001840:	855a                	mv	a0,s6
    80001842:	fe4ff0ef          	jal	80001026 <walkaddr>
    80001846:	89aa                	mv	s3,a0
            if(pa0 == 0) 
    80001848:	fd59                	bnez	a0,800017e6 <copyout+0x32>
                return -1;
    8000184a:	557d                	li	a0,-1
    8000184c:	a031                	j	80001858 <copyout+0xa4>
    }
    return 0;
    8000184e:	4501                	li	a0,0
    80001850:	a021                	j	80001858 <copyout+0xa4>
    80001852:	4501                	li	a0,0
}
    80001854:	8082                	ret
            return -1;
    80001856:	557d                	li	a0,-1
}
    80001858:	60e6                	ld	ra,88(sp)
    8000185a:	6446                	ld	s0,80(sp)
    8000185c:	64a6                	ld	s1,72(sp)
    8000185e:	6906                	ld	s2,64(sp)
    80001860:	79e2                	ld	s3,56(sp)
    80001862:	7a42                	ld	s4,48(sp)
    80001864:	7aa2                	ld	s5,40(sp)
    80001866:	7b02                	ld	s6,32(sp)
    80001868:	6be2                	ld	s7,24(sp)
    8000186a:	6c42                	ld	s8,16(sp)
    8000186c:	6ca2                	ld	s9,8(sp)
    8000186e:	6d02                	ld	s10,0(sp)
    80001870:	6125                	addi	sp,sp,96
    80001872:	8082                	ret
                return -1;
    80001874:	557d                	li	a0,-1
    80001876:	b7cd                	j	80001858 <copyout+0xa4>
            return -1;
    80001878:	557d                	li	a0,-1
    8000187a:	bff9                	j	80001858 <copyout+0xa4>

000000008000187c <copyin>:
    int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while(len > 0){
    8000187c:	cac9                	beqz	a3,8000190e <copyin+0x92>
{
    8000187e:	715d                	addi	sp,sp,-80
    80001880:	e486                	sd	ra,72(sp)
    80001882:	e0a2                	sd	s0,64(sp)
    80001884:	fc26                	sd	s1,56(sp)
    80001886:	f84a                	sd	s2,48(sp)
    80001888:	f44e                	sd	s3,40(sp)
    8000188a:	f052                	sd	s4,32(sp)
    8000188c:	ec56                	sd	s5,24(sp)
    8000188e:	e85a                	sd	s6,16(sp)
    80001890:	e45e                	sd	s7,8(sp)
    80001892:	e062                	sd	s8,0(sp)
    80001894:	0880                	addi	s0,sp,80
    80001896:	8b2a                	mv	s6,a0
    80001898:	8aae                	mv	s5,a1
    8000189a:	8932                	mv	s2,a2
    8000189c:	8a36                	mv	s4,a3
        va0 = PGROUNDDOWN(srcva);
    8000189e:	7c7d                	lui	s8,0xfffff
            }
            pa0 = walkaddr(pagetable, va0); 
            if(pa0 == 0)
                return -1;
        }
        n = PGSIZE - (srcva - va0);
    800018a0:	6b85                	lui	s7,0x1
    800018a2:	a035                	j	800018ce <copyin+0x52>
    800018a4:	412984b3          	sub	s1,s3,s2
    800018a8:	94de                	add	s1,s1,s7
        if(n > len)
    800018aa:	009a7363          	bgeu	s4,s1,800018b0 <copyin+0x34>
    800018ae:	84d2                	mv	s1,s4
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800018b0:	413905b3          	sub	a1,s2,s3
    800018b4:	0004861b          	sext.w	a2,s1
    800018b8:	95aa                	add	a1,a1,a0
    800018ba:	8556                	mv	a0,s5
    800018bc:	c9cff0ef          	jal	80000d58 <memmove>

        len -= n;
    800018c0:	409a0a33          	sub	s4,s4,s1
        dst += n;
    800018c4:	9aa6                	add	s5,s5,s1
        srcva = va0 + PGSIZE;
    800018c6:	01798933          	add	s2,s3,s7
    while(len > 0){
    800018ca:	020a0563          	beqz	s4,800018f4 <copyin+0x78>
        va0 = PGROUNDDOWN(srcva);
    800018ce:	018979b3          	and	s3,s2,s8
        pa0 = walkaddr(pagetable, va0);
    800018d2:	85ce                	mv	a1,s3
    800018d4:	855a                	mv	a0,s6
    800018d6:	f50ff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0) {
    800018da:	f569                	bnez	a0,800018a4 <copyin+0x28>
            if(handle_pgfault(pagetable, va0) != 0) {
    800018dc:	85ce                	mv	a1,s3
    800018de:	855a                	mv	a0,s6
    800018e0:	837ff0ef          	jal	80001116 <handle_pgfault>
    800018e4:	e51d                	bnez	a0,80001912 <copyin+0x96>
            pa0 = walkaddr(pagetable, va0); 
    800018e6:	85ce                	mv	a1,s3
    800018e8:	855a                	mv	a0,s6
    800018ea:	f3cff0ef          	jal	80001026 <walkaddr>
            if(pa0 == 0)
    800018ee:	f95d                	bnez	a0,800018a4 <copyin+0x28>
                return -1;
    800018f0:	557d                	li	a0,-1
    800018f2:	a011                	j	800018f6 <copyin+0x7a>
    }
    return 0;
    800018f4:	4501                	li	a0,0
}
    800018f6:	60a6                	ld	ra,72(sp)
    800018f8:	6406                	ld	s0,64(sp)
    800018fa:	74e2                	ld	s1,56(sp)
    800018fc:	7942                	ld	s2,48(sp)
    800018fe:	79a2                	ld	s3,40(sp)
    80001900:	7a02                	ld	s4,32(sp)
    80001902:	6ae2                	ld	s5,24(sp)
    80001904:	6b42                	ld	s6,16(sp)
    80001906:	6ba2                	ld	s7,8(sp)
    80001908:	6c02                	ld	s8,0(sp)
    8000190a:	6161                	addi	sp,sp,80
    8000190c:	8082                	ret
    return 0;
    8000190e:	4501                	li	a0,0
}
    80001910:	8082                	ret
                return -1;
    80001912:	557d                	li	a0,-1
    80001914:	b7cd                	j	800018f6 <copyin+0x7a>

0000000080001916 <copyinstr>:
    int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;
    while(got_null == 0 && max > 0){
    80001916:	c6e1                	beqz	a3,800019de <copyinstr+0xc8>
{
    80001918:	715d                	addi	sp,sp,-80
    8000191a:	e486                	sd	ra,72(sp)
    8000191c:	e0a2                	sd	s0,64(sp)
    8000191e:	fc26                	sd	s1,56(sp)
    80001920:	f84a                	sd	s2,48(sp)
    80001922:	f44e                	sd	s3,40(sp)
    80001924:	f052                	sd	s4,32(sp)
    80001926:	ec56                	sd	s5,24(sp)
    80001928:	e85a                	sd	s6,16(sp)
    8000192a:	e45e                	sd	s7,8(sp)
    8000192c:	0880                	addi	s0,sp,80
    8000192e:	8aaa                	mv	s5,a0
    80001930:	892e                	mv	s2,a1
    80001932:	8bb2                	mv	s7,a2
    80001934:	89b6                	mv	s3,a3
        va0 = PGROUNDDOWN(srcva);
    80001936:	7b7d                	lui	s6,0xfffff
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); // Retry
            if(pa0 == 0) return -1;
        }
        n = PGSIZE - (srcva - va0);
    80001938:	6a05                	lui	s4,0x1
    8000193a:	a889                	j	8000198c <copyinstr+0x76>
            if(handle_pgfault(pagetable, va0) != 0) {
    8000193c:	85a6                	mv	a1,s1
    8000193e:	8556                	mv	a0,s5
    80001940:	fd6ff0ef          	jal	80001116 <handle_pgfault>
    80001944:	e559                	bnez	a0,800019d2 <copyinstr+0xbc>
            pa0 = walkaddr(pagetable, va0); // Retry
    80001946:	85a6                	mv	a1,s1
    80001948:	8556                	mv	a0,s5
    8000194a:	edcff0ef          	jal	80001026 <walkaddr>
            if(pa0 == 0) return -1;
    8000194e:	e531                	bnez	a0,8000199a <copyinstr+0x84>
    80001950:	557d                	li	a0,-1
    80001952:	a801                	j	80001962 <copyinstr+0x4c>
        if(n > max)
            n = max;
        char *p = (char *) (pa0 + (srcva - va0));
        while(n > 0){
            if(*p == '\0'){
                *dst = '\0';
    80001954:	00078023          	sb	zero,0(a5)
                got_null = 1;
    80001958:	4785                	li	a5,1
            p++;
            dst++;
        }
        srcva = va0 + PGSIZE;
    }
    if(got_null){
    8000195a:	0017c793          	xori	a5,a5,1
    8000195e:	40f0053b          	negw	a0,a5
        return 0;
    } else {
        return -1;
    }
}
    80001962:	60a6                	ld	ra,72(sp)
    80001964:	6406                	ld	s0,64(sp)
    80001966:	74e2                	ld	s1,56(sp)
    80001968:	7942                	ld	s2,48(sp)
    8000196a:	79a2                	ld	s3,40(sp)
    8000196c:	7a02                	ld	s4,32(sp)
    8000196e:	6ae2                	ld	s5,24(sp)
    80001970:	6b42                	ld	s6,16(sp)
    80001972:	6ba2                	ld	s7,8(sp)
    80001974:	6161                	addi	sp,sp,80
    80001976:	8082                	ret
    80001978:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    8000197c:	974a                	add	a4,a4,s2
            --max;
    8000197e:	40b709b3          	sub	s3,a4,a1
        srcva = va0 + PGSIZE;
    80001982:	01448bb3          	add	s7,s1,s4
    while(got_null == 0 && max > 0){
    80001986:	04e58463          	beq	a1,a4,800019ce <copyinstr+0xb8>
{
    8000198a:	893e                	mv	s2,a5
        va0 = PGROUNDDOWN(srcva);
    8000198c:	016bf4b3          	and	s1,s7,s6
        pa0 = walkaddr(pagetable, va0);
    80001990:	85a6                	mv	a1,s1
    80001992:	8556                	mv	a0,s5
    80001994:	e92ff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0){
    80001998:	d155                	beqz	a0,8000193c <copyinstr+0x26>
        n = PGSIZE - (srcva - va0);
    8000199a:	41748633          	sub	a2,s1,s7
    8000199e:	9652                	add	a2,a2,s4
        if(n > max)
    800019a0:	00c9f363          	bgeu	s3,a2,800019a6 <copyinstr+0x90>
    800019a4:	864e                	mv	a2,s3
        while(n > 0){
    800019a6:	ca05                	beqz	a2,800019d6 <copyinstr+0xc0>
        char *p = (char *) (pa0 + (srcva - va0));
    800019a8:	409b86b3          	sub	a3,s7,s1
    800019ac:	96aa                	add	a3,a3,a0
    800019ae:	87ca                	mv	a5,s2
            if(*p == '\0'){
    800019b0:	412686b3          	sub	a3,a3,s2
        while(n > 0){
    800019b4:	964a                	add	a2,a2,s2
    800019b6:	85be                	mv	a1,a5
            if(*p == '\0'){
    800019b8:	00f68733          	add	a4,a3,a5
    800019bc:	00074703          	lbu	a4,0(a4)
    800019c0:	db51                	beqz	a4,80001954 <copyinstr+0x3e>
                *dst = *p;
    800019c2:	00e78023          	sb	a4,0(a5)
            dst++;
    800019c6:	0785                	addi	a5,a5,1
        while(n > 0){
    800019c8:	fec797e3          	bne	a5,a2,800019b6 <copyinstr+0xa0>
    800019cc:	b775                	j	80001978 <copyinstr+0x62>
    800019ce:	4781                	li	a5,0
    800019d0:	b769                	j	8000195a <copyinstr+0x44>
                return -1;
    800019d2:	557d                	li	a0,-1
    800019d4:	b779                	j	80001962 <copyinstr+0x4c>
        srcva = va0 + PGSIZE;
    800019d6:	6b85                	lui	s7,0x1
    800019d8:	9ba6                	add	s7,s7,s1
    800019da:	87ca                	mv	a5,s2
    800019dc:	b77d                	j	8000198a <copyinstr+0x74>
    int got_null = 0;
    800019de:	4781                	li	a5,0
    if(got_null){
    800019e0:	0017c793          	xori	a5,a5,1
    800019e4:	40f0053b          	negw	a0,a5
}
    800019e8:	8082                	ret

00000000800019ea <ismapped>:
// out of physical memory, and physical address if successful.


    int
ismapped(pagetable_t pagetable, uint64 va)
{
    800019ea:	1141                	addi	sp,sp,-16
    800019ec:	e406                	sd	ra,8(sp)
    800019ee:	e022                	sd	s0,0(sp)
    800019f0:	0800                	addi	s0,sp,16
    pte_t *pte = walk(pagetable, va, 0);
    800019f2:	4601                	li	a2,0
    800019f4:	d98ff0ef          	jal	80000f8c <walk>
    if (pte == 0) {
    800019f8:	c119                	beqz	a0,800019fe <ismapped+0x14>
        return 0;
    }
    if (*pte & PTE_V){
    800019fa:	6108                	ld	a0,0(a0)
    800019fc:	8905                	andi	a0,a0,1
        return 1;
    }
    return 0;
}
    800019fe:	60a2                	ld	ra,8(sp)
    80001a00:	6402                	ld	s0,0(sp)
    80001a02:	0141                	addi	sp,sp,16
    80001a04:	8082                	ret

0000000080001a06 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001a06:	711d                	addi	sp,sp,-96
    80001a08:	ec86                	sd	ra,88(sp)
    80001a0a:	e8a2                	sd	s0,80(sp)
    80001a0c:	e4a6                	sd	s1,72(sp)
    80001a0e:	e0ca                	sd	s2,64(sp)
    80001a10:	fc4e                	sd	s3,56(sp)
    80001a12:	f852                	sd	s4,48(sp)
    80001a14:	f456                	sd	s5,40(sp)
    80001a16:	f05a                	sd	s6,32(sp)
    80001a18:	ec5e                	sd	s7,24(sp)
    80001a1a:	e862                	sd	s8,16(sp)
    80001a1c:	e466                	sd	s9,8(sp)
    80001a1e:	1080                	addi	s0,sp,96
    80001a20:	8aaa                	mv	s5,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a22:	00012497          	auipc	s1,0x12
    80001a26:	13648493          	addi	s1,s1,310 # 80013b58 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001a2a:	8ca6                	mv	s9,s1
    80001a2c:	1bcb57b7          	lui	a5,0x1bcb5
    80001a30:	64f78793          	addi	a5,a5,1615 # 1bcb564f <_entry-0x6434a9b1>
    80001a34:	77f45937          	lui	s2,0x77f45
    80001a38:	0906                	slli	s2,s2,0x1
    80001a3a:	82390913          	addi	s2,s2,-2013 # 77f44823 <_entry-0x80bb7dd>
    80001a3e:	1902                	slli	s2,s2,0x20
    80001a40:	993e                	add	s2,s2,a5
    80001a42:	040009b7          	lui	s3,0x4000
    80001a46:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a48:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a4a:	4c19                	li	s8,6
    80001a4c:	6b85                	lui	s7,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a4e:	af0b8a13          	addi	s4,s7,-1296 # af0 <_entry-0x7ffff510>
    80001a52:	0003eb17          	auipc	s6,0x3e
    80001a56:	d06b0b13          	addi	s6,s6,-762 # 8003f758 <tickslock>
    char *pa = kalloc();
    80001a5a:	8eaff0ef          	jal	80000b44 <kalloc>
    80001a5e:	862a                	mv	a2,a0
    if(pa == 0)
    80001a60:	c121                	beqz	a0,80001aa0 <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80001a62:	419485b3          	sub	a1,s1,s9
    80001a66:	8591                	srai	a1,a1,0x4
    80001a68:	032585b3          	mul	a1,a1,s2
    80001a6c:	05b6                	slli	a1,a1,0xd
    80001a6e:	6789                	lui	a5,0x2
    80001a70:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001a72:	8762                	mv	a4,s8
    80001a74:	86de                	mv	a3,s7
    80001a76:	40b985b3          	sub	a1,s3,a1
    80001a7a:	8556                	mv	a0,s5
    80001a7c:	93dff0ef          	jal	800013b8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a80:	94d2                	add	s1,s1,s4
    80001a82:	fd649ce3          	bne	s1,s6,80001a5a <proc_mapstacks+0x54>
  }
}
    80001a86:	60e6                	ld	ra,88(sp)
    80001a88:	6446                	ld	s0,80(sp)
    80001a8a:	64a6                	ld	s1,72(sp)
    80001a8c:	6906                	ld	s2,64(sp)
    80001a8e:	79e2                	ld	s3,56(sp)
    80001a90:	7a42                	ld	s4,48(sp)
    80001a92:	7aa2                	ld	s5,40(sp)
    80001a94:	7b02                	ld	s6,32(sp)
    80001a96:	6be2                	ld	s7,24(sp)
    80001a98:	6c42                	ld	s8,16(sp)
    80001a9a:	6ca2                	ld	s9,8(sp)
    80001a9c:	6125                	addi	sp,sp,96
    80001a9e:	8082                	ret
      panic("kalloc");
    80001aa0:	00006517          	auipc	a0,0x6
    80001aa4:	70850513          	addi	a0,a0,1800 # 800081a8 <etext+0x1a8>
    80001aa8:	d7dfe0ef          	jal	80000824 <panic>

0000000080001aac <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001aac:	715d                	addi	sp,sp,-80
    80001aae:	e486                	sd	ra,72(sp)
    80001ab0:	e0a2                	sd	s0,64(sp)
    80001ab2:	fc26                	sd	s1,56(sp)
    80001ab4:	f84a                	sd	s2,48(sp)
    80001ab6:	f44e                	sd	s3,40(sp)
    80001ab8:	f052                	sd	s4,32(sp)
    80001aba:	ec56                	sd	s5,24(sp)
    80001abc:	e85a                	sd	s6,16(sp)
    80001abe:	e45e                	sd	s7,8(sp)
    80001ac0:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001ac2:	00006597          	auipc	a1,0x6
    80001ac6:	6ee58593          	addi	a1,a1,1774 # 800081b0 <etext+0x1b0>
    80001aca:	00012517          	auipc	a0,0x12
    80001ace:	c5e50513          	addi	a0,a0,-930 # 80013728 <pid_lock>
    80001ad2:	8ccff0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001ad6:	00006597          	auipc	a1,0x6
    80001ada:	6e258593          	addi	a1,a1,1762 # 800081b8 <etext+0x1b8>
    80001ade:	00012517          	auipc	a0,0x12
    80001ae2:	c6250513          	addi	a0,a0,-926 # 80013740 <wait_lock>
    80001ae6:	8b8ff0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001aea:	00012497          	auipc	s1,0x12
    80001aee:	06e48493          	addi	s1,s1,110 # 80013b58 <proc>
      initlock(&p->lock, "proc");
    80001af2:	00006b97          	auipc	s7,0x6
    80001af6:	6d6b8b93          	addi	s7,s7,1750 # 800081c8 <etext+0x1c8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001afa:	8b26                	mv	s6,s1
    80001afc:	1bcb57b7          	lui	a5,0x1bcb5
    80001b00:	64f78793          	addi	a5,a5,1615 # 1bcb564f <_entry-0x6434a9b1>
    80001b04:	77f45937          	lui	s2,0x77f45
    80001b08:	0906                	slli	s2,s2,0x1
    80001b0a:	82390913          	addi	s2,s2,-2013 # 77f44823 <_entry-0x80bb7dd>
    80001b0e:	1902                	slli	s2,s2,0x20
    80001b10:	993e                	add	s2,s2,a5
    80001b12:	040009b7          	lui	s3,0x4000
    80001b16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b18:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b1a:	6a05                	lui	s4,0x1
    80001b1c:	af0a0a13          	addi	s4,s4,-1296 # af0 <_entry-0x7ffff510>
    80001b20:	0003ea97          	auipc	s5,0x3e
    80001b24:	c38a8a93          	addi	s5,s5,-968 # 8003f758 <tickslock>
      initlock(&p->lock, "proc");
    80001b28:	85de                	mv	a1,s7
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	872ff0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    80001b30:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001b34:	416487b3          	sub	a5,s1,s6
    80001b38:	8791                	srai	a5,a5,0x4
    80001b3a:	032787b3          	mul	a5,a5,s2
    80001b3e:	07b6                	slli	a5,a5,0xd
    80001b40:	6709                	lui	a4,0x2
    80001b42:	9fb9                	addw	a5,a5,a4
    80001b44:	40f987b3          	sub	a5,s3,a5
    80001b48:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b4a:	94d2                	add	s1,s1,s4
    80001b4c:	fd549ee3          	bne	s1,s5,80001b28 <procinit+0x7c>
  }
}
    80001b50:	60a6                	ld	ra,72(sp)
    80001b52:	6406                	ld	s0,64(sp)
    80001b54:	74e2                	ld	s1,56(sp)
    80001b56:	7942                	ld	s2,48(sp)
    80001b58:	79a2                	ld	s3,40(sp)
    80001b5a:	7a02                	ld	s4,32(sp)
    80001b5c:	6ae2                	ld	s5,24(sp)
    80001b5e:	6b42                	ld	s6,16(sp)
    80001b60:	6ba2                	ld	s7,8(sp)
    80001b62:	6161                	addi	sp,sp,80
    80001b64:	8082                	ret

0000000080001b66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001b66:	1141                	addi	sp,sp,-16
    80001b68:	e406                	sd	ra,8(sp)
    80001b6a:	e022                	sd	s0,0(sp)
    80001b6c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001b70:	2501                	sext.w	a0,a0
    80001b72:	60a2                	ld	ra,8(sp)
    80001b74:	6402                	ld	s0,0(sp)
    80001b76:	0141                	addi	sp,sp,16
    80001b78:	8082                	ret

0000000080001b7a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001b7a:	1141                	addi	sp,sp,-16
    80001b7c:	e406                	sd	ra,8(sp)
    80001b7e:	e022                	sd	s0,0(sp)
    80001b80:	0800                	addi	s0,sp,16
    80001b82:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001b84:	2781                	sext.w	a5,a5
    80001b86:	079e                	slli	a5,a5,0x7
  return c;
}
    80001b88:	00012517          	auipc	a0,0x12
    80001b8c:	bd050513          	addi	a0,a0,-1072 # 80013758 <cpus>
    80001b90:	953e                	add	a0,a0,a5
    80001b92:	60a2                	ld	ra,8(sp)
    80001b94:	6402                	ld	s0,0(sp)
    80001b96:	0141                	addi	sp,sp,16
    80001b98:	8082                	ret

0000000080001b9a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001b9a:	1101                	addi	sp,sp,-32
    80001b9c:	ec06                	sd	ra,24(sp)
    80001b9e:	e822                	sd	s0,16(sp)
    80001ba0:	e426                	sd	s1,8(sp)
    80001ba2:	1000                	addi	s0,sp,32
  push_off();
    80001ba4:	840ff0ef          	jal	80000be4 <push_off>
    80001ba8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001baa:	2781                	sext.w	a5,a5
    80001bac:	079e                	slli	a5,a5,0x7
    80001bae:	00012717          	auipc	a4,0x12
    80001bb2:	b7a70713          	addi	a4,a4,-1158 # 80013728 <pid_lock>
    80001bb6:	97ba                	add	a5,a5,a4
    80001bb8:	7b9c                	ld	a5,48(a5)
    80001bba:	84be                	mv	s1,a5
  pop_off();
    80001bbc:	8b0ff0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	60e2                	ld	ra,24(sp)
    80001bc4:	6442                	ld	s0,16(sp)
    80001bc6:	64a2                	ld	s1,8(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret

0000000080001bcc <find_fifo_victim>:
find_fifo_victim(void){
    80001bcc:	1141                	addi	sp,sp,-16
    80001bce:	e406                	sd	ra,8(sp)
    80001bd0:	e022                	sd	s0,0(sp)
    80001bd2:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001bd4:	fc7ff0ef          	jal	80001b9a <myproc>
    if(p->resident_page_count == 0){
    80001bd8:	17852583          	lw	a1,376(a0)
    80001bdc:	02b05563          	blez	a1,80001c06 <find_fifo_victim+0x3a>
    80001be0:	2c050793          	addi	a5,a0,704
    for(int i = 0; i < p->resident_page_count ; i++){
    80001be4:	4701                	li	a4,0
    int oldest_seq = 0x7FFFFFFF;
    80001be6:	80000637          	lui	a2,0x80000
    80001bea:	fff64613          	not	a2,a2
    int victim_index = -1;
    80001bee:	557d                	li	a0,-1
    80001bf0:	a029                	j	80001bfa <find_fifo_victim+0x2e>
    for(int i = 0; i < p->resident_page_count ; i++){
    80001bf2:	2705                	addiw	a4,a4,1
    80001bf4:	0791                	addi	a5,a5,4
    80001bf6:	00e58963          	beq	a1,a4,80001c08 <find_fifo_victim+0x3c>
        if(p->fifo_seq[i] < oldest_seq){
    80001bfa:	4394                	lw	a3,0(a5)
    80001bfc:	fec6dbe3          	bge	a3,a2,80001bf2 <find_fifo_victim+0x26>
            oldest_seq = p->fifo_seq[i];
    80001c00:	8636                	mv	a2,a3
            victim_index = i;
    80001c02:	853a                	mv	a0,a4
    80001c04:	b7fd                	j	80001bf2 <find_fifo_victim+0x26>
        return -1; // this moslty wont happen 
    80001c06:	557d                	li	a0,-1
}
    80001c08:	60a2                	ld	ra,8(sp)
    80001c0a:	6402                	ld	s0,0(sp)
    80001c0c:	0141                	addi	sp,sp,16
    80001c0e:	8082                	ret

0000000080001c10 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
    void
forkret(void)
{
    80001c10:	7179                	addi	sp,sp,-48
    80001c12:	f406                	sd	ra,40(sp)
    80001c14:	f022                	sd	s0,32(sp)
    80001c16:	ec26                	sd	s1,24(sp)
    80001c18:	1800                	addi	s0,sp,48
    extern char userret[];
    static int first = 1;
    struct proc *p = myproc();
    80001c1a:	f81ff0ef          	jal	80001b9a <myproc>
    80001c1e:	84aa                	mv	s1,a0

    // Still holding p->lock from scheduler.
    release(&p->lock);
    80001c20:	89cff0ef          	jal	80000cbc <release>

    if (first) {
    80001c24:	0000a797          	auipc	a5,0xa
    80001c28:	9cc7a783          	lw	a5,-1588(a5) # 8000b5f0 <first.1>
    80001c2c:	cf95                	beqz	a5,80001c68 <forkret+0x58>
        // File system initialization must be run in the context of a
        // regular process (e.g., because it calls sleep), and thus cannot
        // be run from main().
        fsinit(ROOTDEV);
    80001c2e:	4505                	li	a0,1
    80001c30:	71d010ef          	jal	80003b4c <fsinit>

        first = 0;
    80001c34:	0000a797          	auipc	a5,0xa
    80001c38:	9a07ae23          	sw	zero,-1604(a5) # 8000b5f0 <first.1>
        // ensure other cores see first=0.
        __sync_synchronize();
    80001c3c:	0330000f          	fence	rw,rw

        // We can invoke kexec() now that file system is initialized.
        // Put the return value (argc) of kexec into a0.
        p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001c40:	00006797          	auipc	a5,0x6
    80001c44:	59078793          	addi	a5,a5,1424 # 800081d0 <etext+0x1d0>
    80001c48:	fcf43823          	sd	a5,-48(s0)
    80001c4c:	fc043c23          	sd	zero,-40(s0)
    80001c50:	fd040593          	addi	a1,s0,-48
    80001c54:	853e                	mv	a0,a5
    80001c56:	0f8030ef          	jal	80004d4e <kexec>
    80001c5a:	6cbc                	ld	a5,88(s1)
    80001c5c:	fba8                	sd	a0,112(a5)
        if (p->trapframe->a0 == -1) {
    80001c5e:	6cbc                	ld	a5,88(s1)
    80001c60:	7bb8                	ld	a4,112(a5)
    80001c62:	57fd                	li	a5,-1
    80001c64:	02f70d63          	beq	a4,a5,80001c9e <forkret+0x8e>
            panic("exec");
        }
    }

    // return to user space, mimicing usertrap()'s return.
    prepare_return();
    80001c68:	4d9000ef          	jal	80002940 <prepare_return>
    uint64 satp = MAKE_SATP(p->pagetable);
    80001c6c:	68a8                	ld	a0,80(s1)
    80001c6e:	8131                	srli	a0,a0,0xc
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c70:	04000737          	lui	a4,0x4000
    80001c74:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001c76:	0732                	slli	a4,a4,0xc
    80001c78:	00005797          	auipc	a5,0x5
    80001c7c:	42478793          	addi	a5,a5,1060 # 8000709c <userret>
    80001c80:	00005697          	auipc	a3,0x5
    80001c84:	38068693          	addi	a3,a3,896 # 80007000 <_trampoline>
    80001c88:	8f95                	sub	a5,a5,a3
    80001c8a:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001c8c:	577d                	li	a4,-1
    80001c8e:	177e                	slli	a4,a4,0x3f
    80001c90:	8d59                	or	a0,a0,a4
    80001c92:	9782                	jalr	a5
}
    80001c94:	70a2                	ld	ra,40(sp)
    80001c96:	7402                	ld	s0,32(sp)
    80001c98:	64e2                	ld	s1,24(sp)
    80001c9a:	6145                	addi	sp,sp,48
    80001c9c:	8082                	ret
            panic("exec");
    80001c9e:	00006517          	auipc	a0,0x6
    80001ca2:	53a50513          	addi	a0,a0,1338 # 800081d8 <etext+0x1d8>
    80001ca6:	b7ffe0ef          	jal	80000824 <panic>

0000000080001caa <allocpid>:
{
    80001caa:	1101                	addi	sp,sp,-32
    80001cac:	ec06                	sd	ra,24(sp)
    80001cae:	e822                	sd	s0,16(sp)
    80001cb0:	e426                	sd	s1,8(sp)
    80001cb2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001cb4:	00012517          	auipc	a0,0x12
    80001cb8:	a7450513          	addi	a0,a0,-1420 # 80013728 <pid_lock>
    80001cbc:	f6dfe0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80001cc0:	0000a797          	auipc	a5,0xa
    80001cc4:	93478793          	addi	a5,a5,-1740 # 8000b5f4 <nextpid>
    80001cc8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001cca:	0014871b          	addiw	a4,s1,1
    80001cce:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001cd0:	00012517          	auipc	a0,0x12
    80001cd4:	a5850513          	addi	a0,a0,-1448 # 80013728 <pid_lock>
    80001cd8:	fe5fe0ef          	jal	80000cbc <release>
}
    80001cdc:	8526                	mv	a0,s1
    80001cde:	60e2                	ld	ra,24(sp)
    80001ce0:	6442                	ld	s0,16(sp)
    80001ce2:	64a2                	ld	s1,8(sp)
    80001ce4:	6105                	addi	sp,sp,32
    80001ce6:	8082                	ret

0000000080001ce8 <proc_pagetable>:
{
    80001ce8:	1101                	addi	sp,sp,-32
    80001cea:	ec06                	sd	ra,24(sp)
    80001cec:	e822                	sd	s0,16(sp)
    80001cee:	e426                	sd	s1,8(sp)
    80001cf0:	e04a                	sd	s2,0(sp)
    80001cf2:	1000                	addi	s0,sp,32
    80001cf4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cf6:	fb4ff0ef          	jal	800014aa <uvmcreate>
    80001cfa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001cfc:	cd05                	beqz	a0,80001d34 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001cfe:	4729                	li	a4,10
    80001d00:	00005697          	auipc	a3,0x5
    80001d04:	30068693          	addi	a3,a3,768 # 80007000 <_trampoline>
    80001d08:	6605                	lui	a2,0x1
    80001d0a:	040005b7          	lui	a1,0x4000
    80001d0e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d10:	05b2                	slli	a1,a1,0xc
    80001d12:	b4eff0ef          	jal	80001060 <mappages>
    80001d16:	02054663          	bltz	a0,80001d42 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d1a:	4719                	li	a4,6
    80001d1c:	05893683          	ld	a3,88(s2)
    80001d20:	6605                	lui	a2,0x1
    80001d22:	020005b7          	lui	a1,0x2000
    80001d26:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d28:	05b6                	slli	a1,a1,0xd
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	b34ff0ef          	jal	80001060 <mappages>
    80001d30:	00054f63          	bltz	a0,80001d4e <proc_pagetable+0x66>
}
    80001d34:	8526                	mv	a0,s1
    80001d36:	60e2                	ld	ra,24(sp)
    80001d38:	6442                	ld	s0,16(sp)
    80001d3a:	64a2                	ld	s1,8(sp)
    80001d3c:	6902                	ld	s2,0(sp)
    80001d3e:	6105                	addi	sp,sp,32
    80001d40:	8082                	ret
    uvmfree(pagetable, 0);
    80001d42:	4581                	li	a1,0
    80001d44:	8526                	mv	a0,s1
    80001d46:	95fff0ef          	jal	800016a4 <uvmfree>
    return 0;
    80001d4a:	4481                	li	s1,0
    80001d4c:	b7e5                	j	80001d34 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d4e:	4681                	li	a3,0
    80001d50:	4605                	li	a2,1
    80001d52:	040005b7          	lui	a1,0x4000
    80001d56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d58:	05b2                	slli	a1,a1,0xc
    80001d5a:	8526                	mv	a0,s1
    80001d5c:	f74ff0ef          	jal	800014d0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001d60:	4581                	li	a1,0
    80001d62:	8526                	mv	a0,s1
    80001d64:	941ff0ef          	jal	800016a4 <uvmfree>
    return 0;
    80001d68:	4481                	li	s1,0
    80001d6a:	b7e9                	j	80001d34 <proc_pagetable+0x4c>

0000000080001d6c <proc_freepagetable>:
{
    80001d6c:	1101                	addi	sp,sp,-32
    80001d6e:	ec06                	sd	ra,24(sp)
    80001d70:	e822                	sd	s0,16(sp)
    80001d72:	e426                	sd	s1,8(sp)
    80001d74:	e04a                	sd	s2,0(sp)
    80001d76:	1000                	addi	s0,sp,32
    80001d78:	84aa                	mv	s1,a0
    80001d7a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d7c:	4681                	li	a3,0
    80001d7e:	4605                	li	a2,1
    80001d80:	040005b7          	lui	a1,0x4000
    80001d84:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d86:	05b2                	slli	a1,a1,0xc
    80001d88:	f48ff0ef          	jal	800014d0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d8c:	4681                	li	a3,0
    80001d8e:	4605                	li	a2,1
    80001d90:	020005b7          	lui	a1,0x2000
    80001d94:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d96:	05b6                	slli	a1,a1,0xd
    80001d98:	8526                	mv	a0,s1
    80001d9a:	f36ff0ef          	jal	800014d0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001d9e:	85ca                	mv	a1,s2
    80001da0:	8526                	mv	a0,s1
    80001da2:	903ff0ef          	jal	800016a4 <uvmfree>
}
    80001da6:	60e2                	ld	ra,24(sp)
    80001da8:	6442                	ld	s0,16(sp)
    80001daa:	64a2                	ld	s1,8(sp)
    80001dac:	6902                	ld	s2,0(sp)
    80001dae:	6105                	addi	sp,sp,32
    80001db0:	8082                	ret

0000000080001db2 <freeproc>:
{
    80001db2:	1101                	addi	sp,sp,-32
    80001db4:	ec06                	sd	ra,24(sp)
    80001db6:	e822                	sd	s0,16(sp)
    80001db8:	e426                	sd	s1,8(sp)
    80001dba:	1000                	addi	s0,sp,32
    80001dbc:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001dbe:	6d28                	ld	a0,88(a0)
    80001dc0:	c119                	beqz	a0,80001dc6 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001dc2:	c9bfe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80001dc6:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001dca:	68a8                	ld	a0,80(s1)
    80001dcc:	c501                	beqz	a0,80001dd4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001dce:	64ac                	ld	a1,72(s1)
    80001dd0:	f9dff0ef          	jal	80001d6c <proc_freepagetable>
  p->pagetable = 0;
    80001dd4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001dd8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ddc:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001de0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001de4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001de8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001dec:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001df0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001df4:	0004ac23          	sw	zero,24(s1)
  if(p->exec_ip)
    80001df8:	1704b503          	ld	a0,368(s1)
    80001dfc:	c119                	beqz	a0,80001e02 <freeproc+0x50>
      iput(p->exec_ip);
    80001dfe:	3dd010ef          	jal	800039da <iput>
  if(p->swap_file){
    80001e02:	3604b503          	ld	a0,864(s1)
    80001e06:	c119                	beqz	a0,80001e0c <freeproc+0x5a>
    iput(p->swap_file);
    80001e08:	3d3010ef          	jal	800039da <iput>
}
    80001e0c:	60e2                	ld	ra,24(sp)
    80001e0e:	6442                	ld	s0,16(sp)
    80001e10:	64a2                	ld	s1,8(sp)
    80001e12:	6105                	addi	sp,sp,32
    80001e14:	8082                	ret

0000000080001e16 <allocproc>:
{
    80001e16:	7179                	addi	sp,sp,-48
    80001e18:	f406                	sd	ra,40(sp)
    80001e1a:	f022                	sd	s0,32(sp)
    80001e1c:	ec26                	sd	s1,24(sp)
    80001e1e:	e84a                	sd	s2,16(sp)
    80001e20:	e44e                	sd	s3,8(sp)
    80001e22:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e24:	00012497          	auipc	s1,0x12
    80001e28:	d3448493          	addi	s1,s1,-716 # 80013b58 <proc>
    80001e2c:	6905                	lui	s2,0x1
    80001e2e:	af090913          	addi	s2,s2,-1296 # af0 <_entry-0x7ffff510>
    80001e32:	0003e997          	auipc	s3,0x3e
    80001e36:	92698993          	addi	s3,s3,-1754 # 8003f758 <tickslock>
    acquire(&p->lock);
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	dedfe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80001e40:	4c9c                	lw	a5,24(s1)
    80001e42:	cb89                	beqz	a5,80001e54 <allocproc+0x3e>
      release(&p->lock);
    80001e44:	8526                	mv	a0,s1
    80001e46:	e77fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e4a:	94ca                	add	s1,s1,s2
    80001e4c:	ff3497e3          	bne	s1,s3,80001e3a <allocproc+0x24>
  return 0;
    80001e50:	4481                	li	s1,0
    80001e52:	a095                	j	80001eb6 <allocproc+0xa0>
  p->pid = allocpid();
    80001e54:	e57ff0ef          	jal	80001caa <allocpid>
    80001e58:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e5a:	4785                	li	a5,1
    80001e5c:	cc9c                	sw	a5,24(s1)
    p->num_phdrs = 0;
    80001e5e:	7604a423          	sw	zero,1896(s1)
  p->resident_page_count = 0;
    80001e62:	1604ac23          	sw	zero,376(s1)
  p->next_fifo_seq = 0;
    80001e66:	1604ae23          	sw	zero,380(s1)
  p->swap_file = 0;
    80001e6a:	3604b023          	sd	zero,864(s1)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    80001e6e:	36848793          	addi	a5,s1,872
    80001e72:	76848713          	addi	a4,s1,1896
      p->swap_slots[i] = 0;
    80001e76:	00078023          	sb	zero,0(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    80001e7a:	0785                	addi	a5,a5,1
    80001e7c:	fee79de3          	bne	a5,a4,80001e76 <allocproc+0x60>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001e80:	cc5fe0ef          	jal	80000b44 <kalloc>
    80001e84:	892a                	mv	s2,a0
    80001e86:	eca8                	sd	a0,88(s1)
    80001e88:	cd1d                	beqz	a0,80001ec6 <allocproc+0xb0>
  p->pagetable = proc_pagetable(p);
    80001e8a:	8526                	mv	a0,s1
    80001e8c:	e5dff0ef          	jal	80001ce8 <proc_pagetable>
    80001e90:	892a                	mv	s2,a0
    80001e92:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001e94:	c129                	beqz	a0,80001ed6 <allocproc+0xc0>
  memset(&p->context, 0, sizeof(p->context));
    80001e96:	07000613          	li	a2,112
    80001e9a:	4581                	li	a1,0
    80001e9c:	06048513          	addi	a0,s1,96
    80001ea0:	e59fe0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80001ea4:	00000797          	auipc	a5,0x0
    80001ea8:	d6c78793          	addi	a5,a5,-660 # 80001c10 <forkret>
    80001eac:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001eae:	60bc                	ld	a5,64(s1)
    80001eb0:	6705                	lui	a4,0x1
    80001eb2:	97ba                	add	a5,a5,a4
    80001eb4:	f4bc                	sd	a5,104(s1)
}
    80001eb6:	8526                	mv	a0,s1
    80001eb8:	70a2                	ld	ra,40(sp)
    80001eba:	7402                	ld	s0,32(sp)
    80001ebc:	64e2                	ld	s1,24(sp)
    80001ebe:	6942                	ld	s2,16(sp)
    80001ec0:	69a2                	ld	s3,8(sp)
    80001ec2:	6145                	addi	sp,sp,48
    80001ec4:	8082                	ret
    freeproc(p);
    80001ec6:	8526                	mv	a0,s1
    80001ec8:	eebff0ef          	jal	80001db2 <freeproc>
    release(&p->lock);
    80001ecc:	8526                	mv	a0,s1
    80001ece:	deffe0ef          	jal	80000cbc <release>
    return 0;
    80001ed2:	84ca                	mv	s1,s2
    80001ed4:	b7cd                	j	80001eb6 <allocproc+0xa0>
    freeproc(p);
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	edbff0ef          	jal	80001db2 <freeproc>
    release(&p->lock);
    80001edc:	8526                	mv	a0,s1
    80001ede:	ddffe0ef          	jal	80000cbc <release>
    return 0;
    80001ee2:	84ca                	mv	s1,s2
    80001ee4:	bfc9                	j	80001eb6 <allocproc+0xa0>

0000000080001ee6 <userinit>:
{
    80001ee6:	1101                	addi	sp,sp,-32
    80001ee8:	ec06                	sd	ra,24(sp)
    80001eea:	e822                	sd	s0,16(sp)
    80001eec:	e426                	sd	s1,8(sp)
    80001eee:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ef0:	f27ff0ef          	jal	80001e16 <allocproc>
    80001ef4:	84aa                	mv	s1,a0
  initproc = p;
    80001ef6:	00009797          	auipc	a5,0x9
    80001efa:	72a7b523          	sd	a0,1834(a5) # 8000b620 <initproc>
  p->cwd = namei("/");
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	2e250513          	addi	a0,a0,738 # 800081e0 <etext+0x1e0>
    80001f06:	180020ef          	jal	80004086 <namei>
    80001f0a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001f0e:	478d                	li	a5,3
    80001f10:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001f12:	8526                	mv	a0,s1
    80001f14:	da9fe0ef          	jal	80000cbc <release>
}
    80001f18:	60e2                	ld	ra,24(sp)
    80001f1a:	6442                	ld	s0,16(sp)
    80001f1c:	64a2                	ld	s1,8(sp)
    80001f1e:	6105                	addi	sp,sp,32
    80001f20:	8082                	ret

0000000080001f22 <growproc>:
{
    80001f22:	1101                	addi	sp,sp,-32
    80001f24:	ec06                	sd	ra,24(sp)
    80001f26:	e822                	sd	s0,16(sp)
    80001f28:	e426                	sd	s1,8(sp)
    80001f2a:	e04a                	sd	s2,0(sp)
    80001f2c:	1000                	addi	s0,sp,32
    80001f2e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f30:	c6bff0ef          	jal	80001b9a <myproc>
    80001f34:	892a                	mv	s2,a0
  sz = p->sz;
    80001f36:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001f38:	02905963          	blez	s1,80001f6a <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80001f3c:	00b48633          	add	a2,s1,a1
    80001f40:	020007b7          	lui	a5,0x2000
    80001f44:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001f46:	07b6                	slli	a5,a5,0xd
    80001f48:	02c7ea63          	bltu	a5,a2,80001f7c <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001f4c:	4691                	li	a3,4
    80001f4e:	6928                	ld	a0,80(a0)
    80001f50:	e4eff0ef          	jal	8000159e <uvmalloc>
    80001f54:	85aa                	mv	a1,a0
    80001f56:	c50d                	beqz	a0,80001f80 <growproc+0x5e>
  p->sz = sz;
    80001f58:	04b93423          	sd	a1,72(s2)
  return 0;
    80001f5c:	4501                	li	a0,0
}
    80001f5e:	60e2                	ld	ra,24(sp)
    80001f60:	6442                	ld	s0,16(sp)
    80001f62:	64a2                	ld	s1,8(sp)
    80001f64:	6902                	ld	s2,0(sp)
    80001f66:	6105                	addi	sp,sp,32
    80001f68:	8082                	ret
  } else if(n < 0){
    80001f6a:	fe04d7e3          	bgez	s1,80001f58 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f6e:	00b48633          	add	a2,s1,a1
    80001f72:	6928                	ld	a0,80(a0)
    80001f74:	de6ff0ef          	jal	8000155a <uvmdealloc>
    80001f78:	85aa                	mv	a1,a0
    80001f7a:	bff9                	j	80001f58 <growproc+0x36>
      return -1;
    80001f7c:	557d                	li	a0,-1
    80001f7e:	b7c5                	j	80001f5e <growproc+0x3c>
      return -1;
    80001f80:	557d                	li	a0,-1
    80001f82:	bff1                	j	80001f5e <growproc+0x3c>

0000000080001f84 <kfork>:
{
    80001f84:	7139                	addi	sp,sp,-64
    80001f86:	fc06                	sd	ra,56(sp)
    80001f88:	f822                	sd	s0,48(sp)
    80001f8a:	f426                	sd	s1,40(sp)
    80001f8c:	e456                	sd	s5,8(sp)
    80001f8e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001f90:	c0bff0ef          	jal	80001b9a <myproc>
    80001f94:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001f96:	e81ff0ef          	jal	80001e16 <allocproc>
    80001f9a:	c135                	beqz	a0,80001ffe <kfork+0x7a>
    80001f9c:	e852                	sd	s4,16(sp)
    80001f9e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001fa0:	048ab603          	ld	a2,72(s5)
    80001fa4:	692c                	ld	a1,80(a0)
    80001fa6:	050ab503          	ld	a0,80(s5)
    80001faa:	f2cff0ef          	jal	800016d6 <uvmcopy>
    80001fae:	06054063          	bltz	a0,8000200e <kfork+0x8a>
    80001fb2:	f04a                	sd	s2,32(sp)
    80001fb4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001fb6:	048ab783          	ld	a5,72(s5)
    80001fba:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001fbe:	058ab683          	ld	a3,88(s5)
    80001fc2:	87b6                	mv	a5,a3
    80001fc4:	058a3703          	ld	a4,88(s4)
    80001fc8:	12068693          	addi	a3,a3,288
    80001fcc:	6388                	ld	a0,0(a5)
    80001fce:	678c                	ld	a1,8(a5)
    80001fd0:	6b90                	ld	a2,16(a5)
    80001fd2:	e308                	sd	a0,0(a4)
    80001fd4:	e70c                	sd	a1,8(a4)
    80001fd6:	eb10                	sd	a2,16(a4)
    80001fd8:	6f90                	ld	a2,24(a5)
    80001fda:	ef10                	sd	a2,24(a4)
    80001fdc:	02078793          	addi	a5,a5,32
    80001fe0:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001fe4:	fed794e3          	bne	a5,a3,80001fcc <kfork+0x48>
  np->trapframe->a0 = 0;
    80001fe8:	058a3783          	ld	a5,88(s4)
    80001fec:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001ff0:	0d0a8493          	addi	s1,s5,208
    80001ff4:	0d0a0913          	addi	s2,s4,208
    80001ff8:	150a8993          	addi	s3,s5,336
    80001ffc:	a815                	j	80002030 <kfork+0xac>
    printf("Error in allocing proc\n");
    80001ffe:	00006517          	auipc	a0,0x6
    80002002:	1ea50513          	addi	a0,a0,490 # 800081e8 <etext+0x1e8>
    80002006:	cf4fe0ef          	jal	800004fa <printf>
    return -1;
    8000200a:	54fd                	li	s1,-1
    8000200c:	a841                	j	8000209c <kfork+0x118>
    freeproc(np);
    8000200e:	8552                	mv	a0,s4
    80002010:	da3ff0ef          	jal	80001db2 <freeproc>
    release(&np->lock);
    80002014:	8552                	mv	a0,s4
    80002016:	ca7fe0ef          	jal	80000cbc <release>
    return -1;
    8000201a:	54fd                	li	s1,-1
    8000201c:	6a42                	ld	s4,16(sp)
    8000201e:	a8bd                	j	8000209c <kfork+0x118>
      np->ofile[i] = filedup(p->ofile[i]);
    80002020:	622020ef          	jal	80004642 <filedup>
    80002024:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    80002028:	04a1                	addi	s1,s1,8
    8000202a:	0921                	addi	s2,s2,8
    8000202c:	01348563          	beq	s1,s3,80002036 <kfork+0xb2>
    if(p->ofile[i])
    80002030:	6088                	ld	a0,0(s1)
    80002032:	f57d                	bnez	a0,80002020 <kfork+0x9c>
    80002034:	bfd5                	j	80002028 <kfork+0xa4>
  np->cwd = idup(p->cwd);
    80002036:	150ab503          	ld	a0,336(s5)
    8000203a:	7e8010ef          	jal	80003822 <idup>
    8000203e:	14aa3823          	sd	a0,336(s4)
  if(p->exec_ip)
    80002042:	170ab503          	ld	a0,368(s5)
    80002046:	c509                	beqz	a0,80002050 <kfork+0xcc>
    np->exec_ip = idup(p->exec_ip);
    80002048:	7da010ef          	jal	80003822 <idup>
    8000204c:	16aa3823          	sd	a0,368(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002050:	4641                	li	a2,16
    80002052:	158a8593          	addi	a1,s5,344
    80002056:	158a0513          	addi	a0,s4,344
    8000205a:	df3fe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    8000205e:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80002062:	8552                	mv	a0,s4
    80002064:	c59fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    80002068:	00011517          	auipc	a0,0x11
    8000206c:	6d850513          	addi	a0,a0,1752 # 80013740 <wait_lock>
    80002070:	bb9fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80002074:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002078:	00011517          	auipc	a0,0x11
    8000207c:	6c850513          	addi	a0,a0,1736 # 80013740 <wait_lock>
    80002080:	c3dfe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80002084:	8552                	mv	a0,s4
    80002086:	ba3fe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    8000208a:	478d                	li	a5,3
    8000208c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002090:	8552                	mv	a0,s4
    80002092:	c2bfe0ef          	jal	80000cbc <release>
    80002096:	7902                	ld	s2,32(sp)
    80002098:	69e2                	ld	s3,24(sp)
    8000209a:	6a42                	ld	s4,16(sp)
}
    8000209c:	8526                	mv	a0,s1
    8000209e:	70e2                	ld	ra,56(sp)
    800020a0:	7442                	ld	s0,48(sp)
    800020a2:	74a2                	ld	s1,40(sp)
    800020a4:	6aa2                	ld	s5,8(sp)
    800020a6:	6121                	addi	sp,sp,64
    800020a8:	8082                	ret

00000000800020aa <scheduler>:
{
    800020aa:	715d                	addi	sp,sp,-80
    800020ac:	e486                	sd	ra,72(sp)
    800020ae:	e0a2                	sd	s0,64(sp)
    800020b0:	fc26                	sd	s1,56(sp)
    800020b2:	f84a                	sd	s2,48(sp)
    800020b4:	f44e                	sd	s3,40(sp)
    800020b6:	f052                	sd	s4,32(sp)
    800020b8:	ec56                	sd	s5,24(sp)
    800020ba:	e85a                	sd	s6,16(sp)
    800020bc:	e45e                	sd	s7,8(sp)
    800020be:	e062                	sd	s8,0(sp)
    800020c0:	0880                	addi	s0,sp,80
    800020c2:	8792                	mv	a5,tp
  int id = r_tp();
    800020c4:	2781                	sext.w	a5,a5
    c->proc = 0;
    800020c6:	00779b13          	slli	s6,a5,0x7
    800020ca:	00011717          	auipc	a4,0x11
    800020ce:	65e70713          	addi	a4,a4,1630 # 80013728 <pid_lock>
    800020d2:	975a                	add	a4,a4,s6
    800020d4:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    800020d8:	00011717          	auipc	a4,0x11
    800020dc:	68870713          	addi	a4,a4,1672 # 80013760 <cpus+0x8>
    800020e0:	9b3a                	add	s6,s6,a4
                p->state = RUNNING;
    800020e2:	4c11                	li	s8,4
                c->proc = p;
    800020e4:	079e                	slli	a5,a5,0x7
    800020e6:	00011a17          	auipc	s4,0x11
    800020ea:	642a0a13          	addi	s4,s4,1602 # 80013728 <pid_lock>
    800020ee:	9a3e                	add	s4,s4,a5
                found = 1;
    800020f0:	4b85                	li	s7,1
    800020f2:	a091                	j	80002136 <scheduler+0x8c>
            release(&p->lock);
    800020f4:	8526                	mv	a0,s1
    800020f6:	bc7fe0ef          	jal	80000cbc <release>
        for(p = proc; p < &proc[NPROC]; p++) {
    800020fa:	94ca                	add	s1,s1,s2
    800020fc:	0003d797          	auipc	a5,0x3d
    80002100:	65c78793          	addi	a5,a5,1628 # 8003f758 <tickslock>
    80002104:	02f48563          	beq	s1,a5,8000212e <scheduler+0x84>
            acquire(&p->lock);
    80002108:	8526                	mv	a0,s1
    8000210a:	b1ffe0ef          	jal	80000c28 <acquire>
            if(p->state == RUNNABLE) {
    8000210e:	4c9c                	lw	a5,24(s1)
    80002110:	ff3792e3          	bne	a5,s3,800020f4 <scheduler+0x4a>
                p->state = RUNNING;
    80002114:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    80002118:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    8000211c:	06048593          	addi	a1,s1,96
    80002120:	855a                	mv	a0,s6
    80002122:	774000ef          	jal	80002896 <swtch>
                c->proc = 0;
    80002126:	020a3823          	sd	zero,48(s4)
                found = 1;
    8000212a:	8ade                	mv	s5,s7
    8000212c:	b7e1                	j	800020f4 <scheduler+0x4a>
        if(found == 0) {
    8000212e:	000a9463          	bnez	s5,80002136 <scheduler+0x8c>
            asm volatile("wfi");
    80002132:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002136:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000213a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000213e:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002142:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002146:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002148:	10079073          	csrw	sstatus,a5
        int found = 0;
    8000214c:	4a81                	li	s5,0
        for(p = proc; p < &proc[NPROC]; p++) {
    8000214e:	00012497          	auipc	s1,0x12
    80002152:	a0a48493          	addi	s1,s1,-1526 # 80013b58 <proc>
            if(p->state == RUNNABLE) {
    80002156:	498d                	li	s3,3
        for(p = proc; p < &proc[NPROC]; p++) {
    80002158:	6905                	lui	s2,0x1
    8000215a:	af090913          	addi	s2,s2,-1296 # af0 <_entry-0x7ffff510>
    8000215e:	b76d                	j	80002108 <scheduler+0x5e>

0000000080002160 <sched>:
{
    80002160:	7179                	addi	sp,sp,-48
    80002162:	f406                	sd	ra,40(sp)
    80002164:	f022                	sd	s0,32(sp)
    80002166:	ec26                	sd	s1,24(sp)
    80002168:	e84a                	sd	s2,16(sp)
    8000216a:	e44e                	sd	s3,8(sp)
    8000216c:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8000216e:	a2dff0ef          	jal	80001b9a <myproc>
    80002172:	84aa                	mv	s1,a0
    if(!holding(&p->lock))
    80002174:	a45fe0ef          	jal	80000bb8 <holding>
    80002178:	c935                	beqz	a0,800021ec <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000217a:	8792                	mv	a5,tp
    if(mycpu()->noff != 1)
    8000217c:	2781                	sext.w	a5,a5
    8000217e:	079e                	slli	a5,a5,0x7
    80002180:	00011717          	auipc	a4,0x11
    80002184:	5a870713          	addi	a4,a4,1448 # 80013728 <pid_lock>
    80002188:	97ba                	add	a5,a5,a4
    8000218a:	0a87a703          	lw	a4,168(a5)
    8000218e:	4785                	li	a5,1
    80002190:	06f71463          	bne	a4,a5,800021f8 <sched+0x98>
    if(p->state == RUNNING)
    80002194:	4c98                	lw	a4,24(s1)
    80002196:	4791                	li	a5,4
    80002198:	06f70663          	beq	a4,a5,80002204 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000219c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800021a0:	8b89                	andi	a5,a5,2
    if(intr_get())
    800021a2:	e7bd                	bnez	a5,80002210 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800021a4:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    800021a6:	00011917          	auipc	s2,0x11
    800021aa:	58290913          	addi	s2,s2,1410 # 80013728 <pid_lock>
    800021ae:	2781                	sext.w	a5,a5
    800021b0:	079e                	slli	a5,a5,0x7
    800021b2:	97ca                	add	a5,a5,s2
    800021b4:	0ac7a983          	lw	s3,172(a5)
    800021b8:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    800021ba:	2781                	sext.w	a5,a5
    800021bc:	079e                	slli	a5,a5,0x7
    800021be:	07a1                	addi	a5,a5,8
    800021c0:	00011597          	auipc	a1,0x11
    800021c4:	59858593          	addi	a1,a1,1432 # 80013758 <cpus>
    800021c8:	95be                	add	a1,a1,a5
    800021ca:	06048513          	addi	a0,s1,96
    800021ce:	6c8000ef          	jal	80002896 <swtch>
    800021d2:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800021d4:	2781                	sext.w	a5,a5
    800021d6:	079e                	slli	a5,a5,0x7
    800021d8:	993e                	add	s2,s2,a5
    800021da:	0b392623          	sw	s3,172(s2)
}
    800021de:	70a2                	ld	ra,40(sp)
    800021e0:	7402                	ld	s0,32(sp)
    800021e2:	64e2                	ld	s1,24(sp)
    800021e4:	6942                	ld	s2,16(sp)
    800021e6:	69a2                	ld	s3,8(sp)
    800021e8:	6145                	addi	sp,sp,48
    800021ea:	8082                	ret
        panic("sched p->lock");
    800021ec:	00006517          	auipc	a0,0x6
    800021f0:	01450513          	addi	a0,a0,20 # 80008200 <etext+0x200>
    800021f4:	e30fe0ef          	jal	80000824 <panic>
        panic("sched locks");
    800021f8:	00006517          	auipc	a0,0x6
    800021fc:	01850513          	addi	a0,a0,24 # 80008210 <etext+0x210>
    80002200:	e24fe0ef          	jal	80000824 <panic>
        panic("sched RUNNING");
    80002204:	00006517          	auipc	a0,0x6
    80002208:	01c50513          	addi	a0,a0,28 # 80008220 <etext+0x220>
    8000220c:	e18fe0ef          	jal	80000824 <panic>
        panic("sched interruptible");
    80002210:	00006517          	auipc	a0,0x6
    80002214:	02050513          	addi	a0,a0,32 # 80008230 <etext+0x230>
    80002218:	e0cfe0ef          	jal	80000824 <panic>

000000008000221c <yield>:
{
    8000221c:	1101                	addi	sp,sp,-32
    8000221e:	ec06                	sd	ra,24(sp)
    80002220:	e822                	sd	s0,16(sp)
    80002222:	e426                	sd	s1,8(sp)
    80002224:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80002226:	975ff0ef          	jal	80001b9a <myproc>
    8000222a:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000222c:	9fdfe0ef          	jal	80000c28 <acquire>
    p->state = RUNNABLE;
    80002230:	478d                	li	a5,3
    80002232:	cc9c                	sw	a5,24(s1)
    sched();
    80002234:	f2dff0ef          	jal	80002160 <sched>
    release(&p->lock);
    80002238:	8526                	mv	a0,s1
    8000223a:	a83fe0ef          	jal	80000cbc <release>
}
    8000223e:	60e2                	ld	ra,24(sp)
    80002240:	6442                	ld	s0,16(sp)
    80002242:	64a2                	ld	s1,8(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
    void
sleep(void *chan, struct spinlock *lk)
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	1800                	addi	s0,sp,48
    80002256:	89aa                	mv	s3,a0
    80002258:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000225a:	941ff0ef          	jal	80001b9a <myproc>
    8000225e:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock);  //DOC: sleeplock1
    80002260:	9c9fe0ef          	jal	80000c28 <acquire>
    release(lk);
    80002264:	854a                	mv	a0,s2
    80002266:	a57fe0ef          	jal	80000cbc <release>

    // Go to sleep.
    p->chan = chan;
    8000226a:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000226e:	4789                	li	a5,2
    80002270:	cc9c                	sw	a5,24(s1)

    sched();
    80002272:	eefff0ef          	jal	80002160 <sched>

    // Tidy up.
    p->chan = 0;
    80002276:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000227a:	8526                	mv	a0,s1
    8000227c:	a41fe0ef          	jal	80000cbc <release>
    acquire(lk);
    80002280:	854a                	mv	a0,s2
    80002282:	9a7fe0ef          	jal	80000c28 <acquire>
}
    80002286:	70a2                	ld	ra,40(sp)
    80002288:	7402                	ld	s0,32(sp)
    8000228a:	64e2                	ld	s1,24(sp)
    8000228c:	6942                	ld	s2,16(sp)
    8000228e:	69a2                	ld	s3,8(sp)
    80002290:	6145                	addi	sp,sp,48
    80002292:	8082                	ret

0000000080002294 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
    void
wakeup(void *chan)
{
    80002294:	7139                	addi	sp,sp,-64
    80002296:	fc06                	sd	ra,56(sp)
    80002298:	f822                	sd	s0,48(sp)
    8000229a:	f426                	sd	s1,40(sp)
    8000229c:	f04a                	sd	s2,32(sp)
    8000229e:	ec4e                	sd	s3,24(sp)
    800022a0:	e852                	sd	s4,16(sp)
    800022a2:	e456                	sd	s5,8(sp)
    800022a4:	e05a                	sd	s6,0(sp)
    800022a6:	0080                	addi	s0,sp,64
    800022a8:	8aaa                	mv	s5,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++) {
    800022aa:	00012497          	auipc	s1,0x12
    800022ae:	8ae48493          	addi	s1,s1,-1874 # 80013b58 <proc>
        if(p != myproc()){
            acquire(&p->lock);
            if(p->state == SLEEPING && p->chan == chan) {
    800022b2:	4a09                	li	s4,2
                p->state = RUNNABLE;
    800022b4:	4b0d                	li	s6,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800022b6:	6905                	lui	s2,0x1
    800022b8:	af090913          	addi	s2,s2,-1296 # af0 <_entry-0x7ffff510>
    800022bc:	0003d997          	auipc	s3,0x3d
    800022c0:	49c98993          	addi	s3,s3,1180 # 8003f758 <tickslock>
    800022c4:	a039                	j	800022d2 <wakeup+0x3e>
            }
            release(&p->lock);
    800022c6:	8526                	mv	a0,s1
    800022c8:	9f5fe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800022cc:	94ca                	add	s1,s1,s2
    800022ce:	03348263          	beq	s1,s3,800022f2 <wakeup+0x5e>
        if(p != myproc()){
    800022d2:	8c9ff0ef          	jal	80001b9a <myproc>
    800022d6:	fe950be3          	beq	a0,s1,800022cc <wakeup+0x38>
            acquire(&p->lock);
    800022da:	8526                	mv	a0,s1
    800022dc:	94dfe0ef          	jal	80000c28 <acquire>
            if(p->state == SLEEPING && p->chan == chan) {
    800022e0:	4c9c                	lw	a5,24(s1)
    800022e2:	ff4792e3          	bne	a5,s4,800022c6 <wakeup+0x32>
    800022e6:	709c                	ld	a5,32(s1)
    800022e8:	fd579fe3          	bne	a5,s5,800022c6 <wakeup+0x32>
                p->state = RUNNABLE;
    800022ec:	0164ac23          	sw	s6,24(s1)
    800022f0:	bfd9                	j	800022c6 <wakeup+0x32>
        }
    }
}
    800022f2:	70e2                	ld	ra,56(sp)
    800022f4:	7442                	ld	s0,48(sp)
    800022f6:	74a2                	ld	s1,40(sp)
    800022f8:	7902                	ld	s2,32(sp)
    800022fa:	69e2                	ld	s3,24(sp)
    800022fc:	6a42                	ld	s4,16(sp)
    800022fe:	6aa2                	ld	s5,8(sp)
    80002300:	6b02                	ld	s6,0(sp)
    80002302:	6121                	addi	sp,sp,64
    80002304:	8082                	ret

0000000080002306 <reparent>:
{
    80002306:	7139                	addi	sp,sp,-64
    80002308:	fc06                	sd	ra,56(sp)
    8000230a:	f822                	sd	s0,48(sp)
    8000230c:	f426                	sd	s1,40(sp)
    8000230e:	f04a                	sd	s2,32(sp)
    80002310:	ec4e                	sd	s3,24(sp)
    80002312:	e852                	sd	s4,16(sp)
    80002314:	e456                	sd	s5,8(sp)
    80002316:	0080                	addi	s0,sp,64
    80002318:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000231a:	00012497          	auipc	s1,0x12
    8000231e:	83e48493          	addi	s1,s1,-1986 # 80013b58 <proc>
      pp->parent = initproc;
    80002322:	00009a97          	auipc	s5,0x9
    80002326:	2fea8a93          	addi	s5,s5,766 # 8000b620 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000232a:	6905                	lui	s2,0x1
    8000232c:	af090913          	addi	s2,s2,-1296 # af0 <_entry-0x7ffff510>
    80002330:	0003da17          	auipc	s4,0x3d
    80002334:	428a0a13          	addi	s4,s4,1064 # 8003f758 <tickslock>
    80002338:	a021                	j	80002340 <reparent+0x3a>
    8000233a:	94ca                	add	s1,s1,s2
    8000233c:	01448b63          	beq	s1,s4,80002352 <reparent+0x4c>
    if(pp->parent == p){
    80002340:	7c9c                	ld	a5,56(s1)
    80002342:	ff379ce3          	bne	a5,s3,8000233a <reparent+0x34>
      pp->parent = initproc;
    80002346:	000ab503          	ld	a0,0(s5)
    8000234a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000234c:	f49ff0ef          	jal	80002294 <wakeup>
    80002350:	b7ed                	j	8000233a <reparent+0x34>
}
    80002352:	70e2                	ld	ra,56(sp)
    80002354:	7442                	ld	s0,48(sp)
    80002356:	74a2                	ld	s1,40(sp)
    80002358:	7902                	ld	s2,32(sp)
    8000235a:	69e2                	ld	s3,24(sp)
    8000235c:	6a42                	ld	s4,16(sp)
    8000235e:	6aa2                	ld	s5,8(sp)
    80002360:	6121                	addi	sp,sp,64
    80002362:	8082                	ret

0000000080002364 <kexit>:
{
    80002364:	7175                	addi	sp,sp,-144
    80002366:	e506                	sd	ra,136(sp)
    80002368:	e122                	sd	s0,128(sp)
    8000236a:	fca6                	sd	s1,120(sp)
    8000236c:	f8ca                	sd	s2,112(sp)
    8000236e:	f4ce                	sd	s3,104(sp)
    80002370:	f0d2                	sd	s4,96(sp)
    80002372:	0900                	addi	s0,sp,144
    80002374:	89aa                	mv	s3,a0
  struct proc *p = myproc();
    80002376:	825ff0ef          	jal	80001b9a <myproc>
    8000237a:	892a                	mv	s2,a0
  printf("[pid %d] is exiting\n",p->pid);
    8000237c:	590c                	lw	a1,48(a0)
    8000237e:	00006517          	auipc	a0,0x6
    80002382:	eca50513          	addi	a0,a0,-310 # 80008248 <etext+0x248>
    80002386:	974fe0ef          	jal	800004fa <printf>
  if(p == initproc)
    8000238a:	00009797          	auipc	a5,0x9
    8000238e:	2967b783          	ld	a5,662(a5) # 8000b620 <initproc>
    80002392:	0d090493          	addi	s1,s2,208
    80002396:	15090a13          	addi	s4,s2,336
    8000239a:	01279b63          	bne	a5,s2,800023b0 <kexit+0x4c>
    panic("init exiting");
    8000239e:	00006517          	auipc	a0,0x6
    800023a2:	ec250513          	addi	a0,a0,-318 # 80008260 <etext+0x260>
    800023a6:	c7efe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800023aa:	04a1                	addi	s1,s1,8
    800023ac:	01448963          	beq	s1,s4,800023be <kexit+0x5a>
    if(p->ofile[fd]){
    800023b0:	6088                	ld	a0,0(s1)
    800023b2:	dd65                	beqz	a0,800023aa <kexit+0x46>
      fileclose(f);
    800023b4:	2d4020ef          	jal	80004688 <fileclose>
      p->ofile[fd] = 0;
    800023b8:	0004b023          	sd	zero,0(s1)
    800023bc:	b7fd                	j	800023aa <kexit+0x46>
  if(p->swap_file) {
    800023be:	36093783          	ld	a5,864(s2)
    800023c2:	10078d63          	beqz	a5,800024dc <kexit+0x178>
    char path[32] = "/pgswp";
    800023c6:	00006797          	auipc	a5,0x6
    800023ca:	5ca78793          	addi	a5,a5,1482 # 80008990 <digits+0x18>
    800023ce:	4398                	lw	a4,0(a5)
    800023d0:	fae42823          	sw	a4,-80(s0)
    800023d4:	0047d703          	lhu	a4,4(a5)
    800023d8:	fae41a23          	sh	a4,-76(s0)
    800023dc:	0067c783          	lbu	a5,6(a5)
    800023e0:	faf40b23          	sb	a5,-74(s0)
    800023e4:	4665                	li	a2,25
    800023e6:	4581                	li	a1,0
    800023e8:	fb740513          	addi	a0,s0,-73
    800023ec:	90dfe0ef          	jal	80000cf8 <memset>
    itoa(p->pid, pid_str);
    800023f0:	03092683          	lw	a3,48(s2)
  if (n == 0) {
    800023f4:	cad5                	beqz	a3,800024a8 <kexit+0x144>
  while(n > 0){
    800023f6:	f8040613          	addi	a2,s0,-128
    800023fa:	85b2                	mv	a1,a2
    buf[i++] = (n % 10) + '0';
    800023fc:	66666837          	lui	a6,0x66666
    80002400:	66780813          	addi	a6,a6,1639 # 66666667 <_entry-0x19999999>
  while(n > 0){
    80002404:	48a5                	li	a7,9
    80002406:	18d05c63          	blez	a3,8000259e <kexit+0x23a>
    buf[i++] = (n % 10) + '0';
    8000240a:	03068733          	mul	a4,a3,a6
    8000240e:	9709                	srai	a4,a4,0x22
    80002410:	41f6d79b          	sraiw	a5,a3,0x1f
    80002414:	9f1d                	subw	a4,a4,a5
    80002416:	0027179b          	slliw	a5,a4,0x2
    8000241a:	9fb9                	addw	a5,a5,a4
    8000241c:	0017979b          	slliw	a5,a5,0x1
    80002420:	40f687bb          	subw	a5,a3,a5
    80002424:	0307879b          	addiw	a5,a5,48
    80002428:	00f58023          	sb	a5,0(a1)
    n /= 10;
    8000242c:	8536                	mv	a0,a3
    8000242e:	86ba                	mv	a3,a4
  while(n > 0){
    80002430:	87ae                	mv	a5,a1
    80002432:	0585                	addi	a1,a1,1
    80002434:	fca8cbe3          	blt	a7,a0,8000240a <kexit+0xa6>
    buf[i++] = (n % 10) + '0';
    80002438:	9f91                	subw	a5,a5,a2
    8000243a:	2785                	addiw	a5,a5,1
  buf[i] = '\0';
    8000243c:	fd078713          	addi	a4,a5,-48
    80002440:	9722                	add	a4,a4,s0
    80002442:	fa070823          	sb	zero,-80(a4)
  for(int j = 0; j < i/2; j++){
    80002446:	4509                	li	a0,2
    80002448:	02a7c53b          	divw	a0,a5,a0
    8000244c:	4705                	li	a4,1
    8000244e:	02f75163          	bge	a4,a5,80002470 <kexit+0x10c>
    80002452:	97b2                	add	a5,a5,a2
    80002454:	4701                	li	a4,0
    char t = buf[j];
    80002456:	00064683          	lbu	a3,0(a2) # 1000 <_entry-0x7ffff000>
    buf[j] = buf[i-j-1];
    8000245a:	fff7c583          	lbu	a1,-1(a5)
    8000245e:	00b60023          	sb	a1,0(a2)
    buf[i-j-1] = t;
    80002462:	fed78fa3          	sb	a3,-1(a5)
  for(int j = 0; j < i/2; j++){
    80002466:	2705                	addiw	a4,a4,1
    80002468:	0605                	addi	a2,a2,1
    8000246a:	17fd                	addi	a5,a5,-1
    8000246c:	fea745e3          	blt	a4,a0,80002456 <kexit+0xf2>
    char *ptr = path + strlen(path);
    80002470:	fb040493          	addi	s1,s0,-80
    80002474:	8526                	mv	a0,s1
    80002476:	a0dfe0ef          	jal	80000e82 <strlen>
    8000247a:	00a487b3          	add	a5,s1,a0
    while(*s) *ptr++ = *s++;
    8000247e:	f8044703          	lbu	a4,-128(s0)
    80002482:	cb11                	beqz	a4,80002496 <kexit+0x132>
    char *s = pid_str;
    80002484:	f8040693          	addi	a3,s0,-128
    while(*s) *ptr++ = *s++;
    80002488:	0685                	addi	a3,a3,1
    8000248a:	0785                	addi	a5,a5,1
    8000248c:	fee78fa3          	sb	a4,-1(a5)
    80002490:	0006c703          	lbu	a4,0(a3)
    80002494:	fb75                	bnez	a4,80002488 <kexit+0x124>
    *ptr = '\0';
    80002496:	00078023          	sb	zero,0(a5)
    for(int i=0; i<MAX_SWAP_PAGES; i++){ if(p->swap_slots[i] == 1) freed_slots++; }
    8000249a:	36890793          	addi	a5,s2,872
    8000249e:	76890613          	addi	a2,s2,1896
    int freed_slots = 0;
    800024a2:	4481                	li	s1,0
    for(int i=0; i<MAX_SWAP_PAGES; i++){ if(p->swap_slots[i] == 1) freed_slots++; }
    800024a4:	4685                	li	a3,1
    800024a6:	a819                	j	800024bc <kexit+0x158>
    buf[i++] = '0';
    800024a8:	03000793          	li	a5,48
    800024ac:	f8f40023          	sb	a5,-128(s0)
    buf[i] = '\0';
    800024b0:	f80400a3          	sb	zero,-127(s0)
    return;
    800024b4:	bf75                	j	80002470 <kexit+0x10c>
    for(int i=0; i<MAX_SWAP_PAGES; i++){ if(p->swap_slots[i] == 1) freed_slots++; }
    800024b6:	0785                	addi	a5,a5,1
    800024b8:	00f60863          	beq	a2,a5,800024c8 <kexit+0x164>
    800024bc:	0007c703          	lbu	a4,0(a5)
    800024c0:	fed71be3          	bne	a4,a3,800024b6 <kexit+0x152>
    800024c4:	2485                	addiw	s1,s1,1
    800024c6:	bfc5                	j	800024b6 <kexit+0x152>
    printf("[pid %d] SWAPCLEANUP freed_slots=%d\n", p->pid, freed_slots);
    800024c8:	8626                	mv	a2,s1
    800024ca:	03092583          	lw	a1,48(s2)
    800024ce:	00006517          	auipc	a0,0x6
    800024d2:	da250513          	addi	a0,a0,-606 # 80008270 <etext+0x270>
    800024d6:	824fe0ef          	jal	800004fa <printf>
    if(freed_slots){
    800024da:	ecb1                	bnez	s1,80002536 <kexit+0x1d2>
  begin_op();
    800024dc:	589010ef          	jal	80004264 <begin_op>
  iput(p->cwd);
    800024e0:	15093503          	ld	a0,336(s2)
    800024e4:	4f6010ef          	jal	800039da <iput>
  end_op();
    800024e8:	5ed010ef          	jal	800042d4 <end_op>
  p->cwd = 0;
    800024ec:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800024f0:	00011517          	auipc	a0,0x11
    800024f4:	25050513          	addi	a0,a0,592 # 80013740 <wait_lock>
    800024f8:	f30fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800024fc:	854a                	mv	a0,s2
    800024fe:	e09ff0ef          	jal	80002306 <reparent>
  wakeup(p->parent);
    80002502:	03893503          	ld	a0,56(s2)
    80002506:	d8fff0ef          	jal	80002294 <wakeup>
  acquire(&p->lock);
    8000250a:	854a                	mv	a0,s2
    8000250c:	f1cfe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    80002510:	03392623          	sw	s3,44(s2)
  p->state = ZOMBIE;
    80002514:	4795                	li	a5,5
    80002516:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    8000251a:	00011517          	auipc	a0,0x11
    8000251e:	22650513          	addi	a0,a0,550 # 80013740 <wait_lock>
    80002522:	f9afe0ef          	jal	80000cbc <release>
  sched();
    80002526:	c3bff0ef          	jal	80002160 <sched>
  panic("zombie exit");
    8000252a:	00006517          	auipc	a0,0x6
    8000252e:	d6e50513          	addi	a0,a0,-658 # 80008298 <etext+0x298>
    80002532:	af2fe0ef          	jal	80000824 <panic>
        begin_op();
    80002536:	52f010ef          	jal	80004264 <begin_op>
        struct inode *dp = nameiparent(path, filename);
    8000253a:	f9040593          	addi	a1,s0,-112
    8000253e:	fb040513          	addi	a0,s0,-80
    80002542:	35f010ef          	jal	800040a0 <nameiparent>
    80002546:	84aa                	mv	s1,a0
        if(dp){
    80002548:	c921                	beqz	a0,80002598 <kexit+0x234>
            ilock(dp);
    8000254a:	30e010ef          	jal	80003858 <ilock>
            struct inode* ip = dirlookup(dp, filename, &off);
    8000254e:	f7c40613          	addi	a2,s0,-132
    80002552:	f9040593          	addi	a1,s0,-112
    80002556:	8526                	mv	a0,s1
    80002558:	09b010ef          	jal	80003df2 <dirlookup>
    8000255c:	8a2a                	mv	s4,a0
            if(ip){
    8000255e:	c915                	beqz	a0,80002592 <kexit+0x22e>
                ilock(ip);
    80002560:	2f8010ef          	jal	80003858 <ilock>
                memset(&de, 0, sizeof(de));
    80002564:	4641                	li	a2,16
    80002566:	4581                	li	a1,0
    80002568:	fa040513          	addi	a0,s0,-96
    8000256c:	f8cfe0ef          	jal	80000cf8 <memset>
                writei(dp, 0, (uint64)&de, off, sizeof(de)); // Erase directory entry
    80002570:	4741                	li	a4,16
    80002572:	f7c42683          	lw	a3,-132(s0)
    80002576:	fa040613          	addi	a2,s0,-96
    8000257a:	4581                	li	a1,0
    8000257c:	8526                	mv	a0,s1
    8000257e:	75e010ef          	jal	80003cdc <writei>
                ip->nlink = 0; // Mark inode to be freed by iput
    80002582:	040a1523          	sh	zero,74(s4)
                iupdate(ip);
    80002586:	8552                	mv	a0,s4
    80002588:	21c010ef          	jal	800037a4 <iupdate>
                iunlockput(ip);
    8000258c:	8552                	mv	a0,s4
    8000258e:	4d6010ef          	jal	80003a64 <iunlockput>
            iunlockput(dp);
    80002592:	8526                	mv	a0,s1
    80002594:	4d0010ef          	jal	80003a64 <iunlockput>
        end_op();
    80002598:	53d010ef          	jal	800042d4 <end_op>
    8000259c:	b781                	j	800024dc <kexit+0x178>
  buf[i] = '\0';
    8000259e:	f8040023          	sb	zero,-128(s0)
  for(int j = 0; j < i/2; j++){
    800025a2:	b5f9                	j	80002470 <kexit+0x10c>

00000000800025a4 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
    int
kkill(int pid)
{
    800025a4:	7179                	addi	sp,sp,-48
    800025a6:	f406                	sd	ra,40(sp)
    800025a8:	f022                	sd	s0,32(sp)
    800025aa:	ec26                	sd	s1,24(sp)
    800025ac:	e84a                	sd	s2,16(sp)
    800025ae:	e44e                	sd	s3,8(sp)
    800025b0:	e052                	sd	s4,0(sp)
    800025b2:	1800                	addi	s0,sp,48
    800025b4:	892a                	mv	s2,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++){
    800025b6:	00011497          	auipc	s1,0x11
    800025ba:	5a248493          	addi	s1,s1,1442 # 80013b58 <proc>
    800025be:	6985                	lui	s3,0x1
    800025c0:	af098993          	addi	s3,s3,-1296 # af0 <_entry-0x7ffff510>
    800025c4:	0003da17          	auipc	s4,0x3d
    800025c8:	194a0a13          	addi	s4,s4,404 # 8003f758 <tickslock>
        acquire(&p->lock);
    800025cc:	8526                	mv	a0,s1
    800025ce:	e5afe0ef          	jal	80000c28 <acquire>
        if(p->pid == pid){
    800025d2:	589c                	lw	a5,48(s1)
    800025d4:	01278a63          	beq	a5,s2,800025e8 <kkill+0x44>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800025d8:	8526                	mv	a0,s1
    800025da:	ee2fe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++){
    800025de:	94ce                	add	s1,s1,s3
    800025e0:	ff4496e3          	bne	s1,s4,800025cc <kkill+0x28>
    }
    return -1;
    800025e4:	557d                	li	a0,-1
    800025e6:	a819                	j	800025fc <kkill+0x58>
            p->killed = 1;
    800025e8:	4785                	li	a5,1
    800025ea:	d49c                	sw	a5,40(s1)
            if(p->state == SLEEPING){
    800025ec:	4c98                	lw	a4,24(s1)
    800025ee:	4789                	li	a5,2
    800025f0:	00f70e63          	beq	a4,a5,8000260c <kkill+0x68>
            release(&p->lock);
    800025f4:	8526                	mv	a0,s1
    800025f6:	ec6fe0ef          	jal	80000cbc <release>
            return 0;
    800025fa:	4501                	li	a0,0
}
    800025fc:	70a2                	ld	ra,40(sp)
    800025fe:	7402                	ld	s0,32(sp)
    80002600:	64e2                	ld	s1,24(sp)
    80002602:	6942                	ld	s2,16(sp)
    80002604:	69a2                	ld	s3,8(sp)
    80002606:	6a02                	ld	s4,0(sp)
    80002608:	6145                	addi	sp,sp,48
    8000260a:	8082                	ret
                p->state = RUNNABLE;
    8000260c:	478d                	li	a5,3
    8000260e:	cc9c                	sw	a5,24(s1)
    80002610:	b7d5                	j	800025f4 <kkill+0x50>

0000000080002612 <setkilled>:

    void
setkilled(struct proc *p)
{
    80002612:	1101                	addi	sp,sp,-32
    80002614:	ec06                	sd	ra,24(sp)
    80002616:	e822                	sd	s0,16(sp)
    80002618:	e426                	sd	s1,8(sp)
    8000261a:	1000                	addi	s0,sp,32
    8000261c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000261e:	e0afe0ef          	jal	80000c28 <acquire>
    p->killed = 1;
    80002622:	4785                	li	a5,1
    80002624:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002626:	8526                	mv	a0,s1
    80002628:	e94fe0ef          	jal	80000cbc <release>
}
    8000262c:	60e2                	ld	ra,24(sp)
    8000262e:	6442                	ld	s0,16(sp)
    80002630:	64a2                	ld	s1,8(sp)
    80002632:	6105                	addi	sp,sp,32
    80002634:	8082                	ret

0000000080002636 <killed>:

    int
killed(struct proc *p)
{
    80002636:	1101                	addi	sp,sp,-32
    80002638:	ec06                	sd	ra,24(sp)
    8000263a:	e822                	sd	s0,16(sp)
    8000263c:	e426                	sd	s1,8(sp)
    8000263e:	e04a                	sd	s2,0(sp)
    80002640:	1000                	addi	s0,sp,32
    80002642:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002644:	de4fe0ef          	jal	80000c28 <acquire>
    k = p->killed;
    80002648:	549c                	lw	a5,40(s1)
    8000264a:	893e                	mv	s2,a5
    release(&p->lock);
    8000264c:	8526                	mv	a0,s1
    8000264e:	e6efe0ef          	jal	80000cbc <release>
    return k;
}
    80002652:	854a                	mv	a0,s2
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6902                	ld	s2,0(sp)
    8000265c:	6105                	addi	sp,sp,32
    8000265e:	8082                	ret

0000000080002660 <kwait>:
{
    80002660:	715d                	addi	sp,sp,-80
    80002662:	e486                	sd	ra,72(sp)
    80002664:	e0a2                	sd	s0,64(sp)
    80002666:	fc26                	sd	s1,56(sp)
    80002668:	f84a                	sd	s2,48(sp)
    8000266a:	f44e                	sd	s3,40(sp)
    8000266c:	f052                	sd	s4,32(sp)
    8000266e:	ec56                	sd	s5,24(sp)
    80002670:	e85a                	sd	s6,16(sp)
    80002672:	e45e                	sd	s7,8(sp)
    80002674:	0880                	addi	s0,sp,80
    80002676:	8baa                	mv	s7,a0
    struct proc *p = myproc();
    80002678:	d22ff0ef          	jal	80001b9a <myproc>
    8000267c:	892a                	mv	s2,a0
    acquire(&wait_lock);
    8000267e:	00011517          	auipc	a0,0x11
    80002682:	0c250513          	addi	a0,a0,194 # 80013740 <wait_lock>
    80002686:	da2fe0ef          	jal	80000c28 <acquire>
                if(pp->state == ZOMBIE){
    8000268a:	4a95                	li	s5,5
                havekids = 1;
    8000268c:	4b05                	li	s6,1
        for(pp = proc; pp < &proc[NPROC]; pp++){
    8000268e:	6985                	lui	s3,0x1
    80002690:	af098993          	addi	s3,s3,-1296 # af0 <_entry-0x7ffff510>
    80002694:	0003da17          	auipc	s4,0x3d
    80002698:	0c4a0a13          	addi	s4,s4,196 # 8003f758 <tickslock>
    8000269c:	a879                	j	8000273a <kwait+0xda>
                    pid = pp->pid;
    8000269e:	0304a983          	lw	s3,48(s1)
                    if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800026a2:	000b8c63          	beqz	s7,800026ba <kwait+0x5a>
    800026a6:	4691                	li	a3,4
    800026a8:	02c48613          	addi	a2,s1,44
    800026ac:	85de                	mv	a1,s7
    800026ae:	05093503          	ld	a0,80(s2)
    800026b2:	902ff0ef          	jal	800017b4 <copyout>
    800026b6:	02054a63          	bltz	a0,800026ea <kwait+0x8a>
                    freeproc(pp);
    800026ba:	8526                	mv	a0,s1
    800026bc:	ef6ff0ef          	jal	80001db2 <freeproc>
                    release(&pp->lock);
    800026c0:	8526                	mv	a0,s1
    800026c2:	dfafe0ef          	jal	80000cbc <release>
                    release(&wait_lock);
    800026c6:	00011517          	auipc	a0,0x11
    800026ca:	07a50513          	addi	a0,a0,122 # 80013740 <wait_lock>
    800026ce:	deefe0ef          	jal	80000cbc <release>
}
    800026d2:	854e                	mv	a0,s3
    800026d4:	60a6                	ld	ra,72(sp)
    800026d6:	6406                	ld	s0,64(sp)
    800026d8:	74e2                	ld	s1,56(sp)
    800026da:	7942                	ld	s2,48(sp)
    800026dc:	79a2                	ld	s3,40(sp)
    800026de:	7a02                	ld	s4,32(sp)
    800026e0:	6ae2                	ld	s5,24(sp)
    800026e2:	6b42                	ld	s6,16(sp)
    800026e4:	6ba2                	ld	s7,8(sp)
    800026e6:	6161                	addi	sp,sp,80
    800026e8:	8082                	ret
                        release(&pp->lock);
    800026ea:	8526                	mv	a0,s1
    800026ec:	dd0fe0ef          	jal	80000cbc <release>
                        release(&wait_lock);
    800026f0:	00011517          	auipc	a0,0x11
    800026f4:	05050513          	addi	a0,a0,80 # 80013740 <wait_lock>
    800026f8:	dc4fe0ef          	jal	80000cbc <release>
                        return -1;
    800026fc:	59fd                	li	s3,-1
    800026fe:	bfd1                	j	800026d2 <kwait+0x72>
        for(pp = proc; pp < &proc[NPROC]; pp++){
    80002700:	94ce                	add	s1,s1,s3
    80002702:	03448063          	beq	s1,s4,80002722 <kwait+0xc2>
            if(pp->parent == p){
    80002706:	7c9c                	ld	a5,56(s1)
    80002708:	ff279ce3          	bne	a5,s2,80002700 <kwait+0xa0>
                acquire(&pp->lock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	d1afe0ef          	jal	80000c28 <acquire>
                if(pp->state == ZOMBIE){
    80002712:	4c9c                	lw	a5,24(s1)
    80002714:	f95785e3          	beq	a5,s5,8000269e <kwait+0x3e>
                release(&pp->lock);
    80002718:	8526                	mv	a0,s1
    8000271a:	da2fe0ef          	jal	80000cbc <release>
                havekids = 1;
    8000271e:	875a                	mv	a4,s6
    80002720:	b7c5                	j	80002700 <kwait+0xa0>
        if(!havekids || killed(p)){
    80002722:	c315                	beqz	a4,80002746 <kwait+0xe6>
    80002724:	854a                	mv	a0,s2
    80002726:	f11ff0ef          	jal	80002636 <killed>
    8000272a:	ed11                	bnez	a0,80002746 <kwait+0xe6>
        sleep(p, &wait_lock);  //DOC: wait-sleep
    8000272c:	00011597          	auipc	a1,0x11
    80002730:	01458593          	addi	a1,a1,20 # 80013740 <wait_lock>
    80002734:	854a                	mv	a0,s2
    80002736:	b13ff0ef          	jal	80002248 <sleep>
        havekids = 0;
    8000273a:	4701                	li	a4,0
        for(pp = proc; pp < &proc[NPROC]; pp++){
    8000273c:	00011497          	auipc	s1,0x11
    80002740:	41c48493          	addi	s1,s1,1052 # 80013b58 <proc>
    80002744:	b7c9                	j	80002706 <kwait+0xa6>
            release(&wait_lock);
    80002746:	00011517          	auipc	a0,0x11
    8000274a:	ffa50513          	addi	a0,a0,-6 # 80013740 <wait_lock>
    8000274e:	d6efe0ef          	jal	80000cbc <release>
            return -1;
    80002752:	59fd                	li	s3,-1
    80002754:	bfbd                	j	800026d2 <kwait+0x72>

0000000080002756 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
    int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002756:	7179                	addi	sp,sp,-48
    80002758:	f406                	sd	ra,40(sp)
    8000275a:	f022                	sd	s0,32(sp)
    8000275c:	ec26                	sd	s1,24(sp)
    8000275e:	e84a                	sd	s2,16(sp)
    80002760:	e44e                	sd	s3,8(sp)
    80002762:	e052                	sd	s4,0(sp)
    80002764:	1800                	addi	s0,sp,48
    80002766:	84aa                	mv	s1,a0
    80002768:	8a2e                	mv	s4,a1
    8000276a:	89b2                	mv	s3,a2
    8000276c:	8936                	mv	s2,a3
    struct proc *p = myproc();
    8000276e:	c2cff0ef          	jal	80001b9a <myproc>
    if(user_dst){
    80002772:	cc99                	beqz	s1,80002790 <either_copyout+0x3a>
        return copyout(p->pagetable, dst, src, len);
    80002774:	86ca                	mv	a3,s2
    80002776:	864e                	mv	a2,s3
    80002778:	85d2                	mv	a1,s4
    8000277a:	6928                	ld	a0,80(a0)
    8000277c:	838ff0ef          	jal	800017b4 <copyout>
    } else {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002780:	70a2                	ld	ra,40(sp)
    80002782:	7402                	ld	s0,32(sp)
    80002784:	64e2                	ld	s1,24(sp)
    80002786:	6942                	ld	s2,16(sp)
    80002788:	69a2                	ld	s3,8(sp)
    8000278a:	6a02                	ld	s4,0(sp)
    8000278c:	6145                	addi	sp,sp,48
    8000278e:	8082                	ret
        memmove((char *)dst, src, len);
    80002790:	0009061b          	sext.w	a2,s2
    80002794:	85ce                	mv	a1,s3
    80002796:	8552                	mv	a0,s4
    80002798:	dc0fe0ef          	jal	80000d58 <memmove>
        return 0;
    8000279c:	8526                	mv	a0,s1
    8000279e:	b7cd                	j	80002780 <either_copyout+0x2a>

00000000800027a0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
    int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800027a0:	7179                	addi	sp,sp,-48
    800027a2:	f406                	sd	ra,40(sp)
    800027a4:	f022                	sd	s0,32(sp)
    800027a6:	ec26                	sd	s1,24(sp)
    800027a8:	e84a                	sd	s2,16(sp)
    800027aa:	e44e                	sd	s3,8(sp)
    800027ac:	e052                	sd	s4,0(sp)
    800027ae:	1800                	addi	s0,sp,48
    800027b0:	8a2a                	mv	s4,a0
    800027b2:	84ae                	mv	s1,a1
    800027b4:	89b2                	mv	s3,a2
    800027b6:	8936                	mv	s2,a3
    struct proc *p = myproc();
    800027b8:	be2ff0ef          	jal	80001b9a <myproc>
    if(user_src){
    800027bc:	cc99                	beqz	s1,800027da <either_copyin+0x3a>
        return copyin(p->pagetable, dst, src, len);
    800027be:	86ca                	mv	a3,s2
    800027c0:	864e                	mv	a2,s3
    800027c2:	85d2                	mv	a1,s4
    800027c4:	6928                	ld	a0,80(a0)
    800027c6:	8b6ff0ef          	jal	8000187c <copyin>
    } else {
        memmove(dst, (char*)src, len);
        return 0;
    }
}
    800027ca:	70a2                	ld	ra,40(sp)
    800027cc:	7402                	ld	s0,32(sp)
    800027ce:	64e2                	ld	s1,24(sp)
    800027d0:	6942                	ld	s2,16(sp)
    800027d2:	69a2                	ld	s3,8(sp)
    800027d4:	6a02                	ld	s4,0(sp)
    800027d6:	6145                	addi	sp,sp,48
    800027d8:	8082                	ret
        memmove(dst, (char*)src, len);
    800027da:	0009061b          	sext.w	a2,s2
    800027de:	85ce                	mv	a1,s3
    800027e0:	8552                	mv	a0,s4
    800027e2:	d76fe0ef          	jal	80000d58 <memmove>
        return 0;
    800027e6:	8526                	mv	a0,s1
    800027e8:	b7cd                	j	800027ca <either_copyin+0x2a>

00000000800027ea <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
    void
procdump(void)
{
    800027ea:	715d                	addi	sp,sp,-80
    800027ec:	e486                	sd	ra,72(sp)
    800027ee:	e0a2                	sd	s0,64(sp)
    800027f0:	fc26                	sd	s1,56(sp)
    800027f2:	f84a                	sd	s2,48(sp)
    800027f4:	f44e                	sd	s3,40(sp)
    800027f6:	f052                	sd	s4,32(sp)
    800027f8:	ec56                	sd	s5,24(sp)
    800027fa:	e85a                	sd	s6,16(sp)
    800027fc:	e45e                	sd	s7,8(sp)
    800027fe:	e062                	sd	s8,0(sp)
    80002800:	0880                	addi	s0,sp,80
        [ZOMBIE]    "zombie"
    };
    struct proc *p;
    char *state;

    printf("\n");
    80002802:	00006517          	auipc	a0,0x6
    80002806:	87650513          	addi	a0,a0,-1930 # 80008078 <etext+0x78>
    8000280a:	cf1fd0ef          	jal	800004fa <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    8000280e:	00011497          	auipc	s1,0x11
    80002812:	4a248493          	addi	s1,s1,1186 # 80013cb0 <proc+0x158>
    80002816:	0003d997          	auipc	s3,0x3d
    8000281a:	09a98993          	addi	s3,s3,154 # 8003f8b0 <bcache+0x140>
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000281e:	4b95                	li	s7,5
            state = states[p->state];
        else
            state = "???";
    80002820:	00006a17          	auipc	s4,0x6
    80002824:	a88a0a13          	addi	s4,s4,-1400 # 800082a8 <etext+0x2a8>
        printf("%d %s %s", p->pid, state, p->name);
    80002828:	00006b17          	auipc	s6,0x6
    8000282c:	a88b0b13          	addi	s6,s6,-1400 # 800082b0 <etext+0x2b0>
        printf("\n");
    80002830:	00006a97          	auipc	s5,0x6
    80002834:	848a8a93          	addi	s5,s5,-1976 # 80008078 <etext+0x78>
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002838:	00006c17          	auipc	s8,0x6
    8000283c:	158c0c13          	addi	s8,s8,344 # 80008990 <digits+0x18>
    for(p = proc; p < &proc[NPROC]; p++){
    80002840:	6905                	lui	s2,0x1
    80002842:	af090913          	addi	s2,s2,-1296 # af0 <_entry-0x7ffff510>
    80002846:	a821                	j	8000285e <procdump+0x74>
        printf("%d %s %s", p->pid, state, p->name);
    80002848:	ed86a583          	lw	a1,-296(a3)
    8000284c:	855a                	mv	a0,s6
    8000284e:	cadfd0ef          	jal	800004fa <printf>
        printf("\n");
    80002852:	8556                	mv	a0,s5
    80002854:	ca7fd0ef          	jal	800004fa <printf>
    for(p = proc; p < &proc[NPROC]; p++){
    80002858:	94ca                	add	s1,s1,s2
    8000285a:	03348263          	beq	s1,s3,8000287e <procdump+0x94>
        if(p->state == UNUSED)
    8000285e:	86a6                	mv	a3,s1
    80002860:	ec04a783          	lw	a5,-320(s1)
    80002864:	dbf5                	beqz	a5,80002858 <procdump+0x6e>
            state = "???";
    80002866:	8652                	mv	a2,s4
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002868:	fefbe0e3          	bltu	s7,a5,80002848 <procdump+0x5e>
    8000286c:	02079713          	slli	a4,a5,0x20
    80002870:	01d75793          	srli	a5,a4,0x1d
    80002874:	97e2                	add	a5,a5,s8
    80002876:	7390                	ld	a2,32(a5)
    80002878:	fa61                	bnez	a2,80002848 <procdump+0x5e>
            state = "???";
    8000287a:	8652                	mv	a2,s4
    8000287c:	b7f1                	j	80002848 <procdump+0x5e>
    }
}
    8000287e:	60a6                	ld	ra,72(sp)
    80002880:	6406                	ld	s0,64(sp)
    80002882:	74e2                	ld	s1,56(sp)
    80002884:	7942                	ld	s2,48(sp)
    80002886:	79a2                	ld	s3,40(sp)
    80002888:	7a02                	ld	s4,32(sp)
    8000288a:	6ae2                	ld	s5,24(sp)
    8000288c:	6b42                	ld	s6,16(sp)
    8000288e:	6ba2                	ld	s7,8(sp)
    80002890:	6c02                	ld	s8,0(sp)
    80002892:	6161                	addi	sp,sp,80
    80002894:	8082                	ret

0000000080002896 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002896:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000289a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000289e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800028a0:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800028a2:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800028a6:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800028aa:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800028ae:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800028b2:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800028b6:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800028ba:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800028be:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800028c2:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800028c6:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800028ca:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800028ce:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800028d2:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800028d4:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800028d6:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800028da:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800028de:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800028e2:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800028e6:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800028ea:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800028ee:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800028f2:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800028f6:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800028fa:	0685bd83          	ld	s11,104(a1)
        
        ret
    800028fe:	8082                	ret

0000000080002900 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002900:	1141                	addi	sp,sp,-16
    80002902:	e406                	sd	ra,8(sp)
    80002904:	e022                	sd	s0,0(sp)
    80002906:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002908:	00006597          	auipc	a1,0x6
    8000290c:	9e858593          	addi	a1,a1,-1560 # 800082f0 <etext+0x2f0>
    80002910:	0003d517          	auipc	a0,0x3d
    80002914:	e4850513          	addi	a0,a0,-440 # 8003f758 <tickslock>
    80002918:	a86fe0ef          	jal	80000b9e <initlock>
}
    8000291c:	60a2                	ld	ra,8(sp)
    8000291e:	6402                	ld	s0,0(sp)
    80002920:	0141                	addi	sp,sp,16
    80002922:	8082                	ret

0000000080002924 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002924:	1141                	addi	sp,sp,-16
    80002926:	e406                	sd	ra,8(sp)
    80002928:	e022                	sd	s0,0(sp)
    8000292a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000292c:	00003797          	auipc	a5,0x3
    80002930:	2f478793          	addi	a5,a5,756 # 80005c20 <kernelvec>
    80002934:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002938:	60a2                	ld	ra,8(sp)
    8000293a:	6402                	ld	s0,0(sp)
    8000293c:	0141                	addi	sp,sp,16
    8000293e:	8082                	ret

0000000080002940 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
    void
prepare_return(void)
{
    80002940:	1141                	addi	sp,sp,-16
    80002942:	e406                	sd	ra,8(sp)
    80002944:	e022                	sd	s0,0(sp)
    80002946:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002948:	a52ff0ef          	jal	80001b9a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000294c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002950:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002952:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(). because a trap from kernel
    // code to usertrap would be a disaster, turn off interrupts.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002956:	04000737          	lui	a4,0x4000
    8000295a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000295c:	0732                	slli	a4,a4,0xc
    8000295e:	00004797          	auipc	a5,0x4
    80002962:	6a278793          	addi	a5,a5,1698 # 80007000 <_trampoline>
    80002966:	00004697          	auipc	a3,0x4
    8000296a:	69a68693          	addi	a3,a3,1690 # 80007000 <_trampoline>
    8000296e:	8f95                	sub	a5,a5,a3
    80002970:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002972:	10579073          	csrw	stvec,a5
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002976:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002978:	18002773          	csrr	a4,satp
    8000297c:	e398                	sd	a4,0(a5)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000297e:	6d38                	ld	a4,88(a0)
    80002980:	613c                	ld	a5,64(a0)
    80002982:	6685                	lui	a3,0x1
    80002984:	97b6                	add	a5,a5,a3
    80002986:	e71c                	sd	a5,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002988:	6d3c                	ld	a5,88(a0)
    8000298a:	00000717          	auipc	a4,0x0
    8000298e:	0fc70713          	addi	a4,a4,252 # 80002a86 <usertrap>
    80002992:	eb98                	sd	a4,16(a5)
    p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002994:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002996:	8712                	mv	a4,tp
    80002998:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000299a:	100027f3          	csrr	a5,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000299e:	eff7f793          	andi	a5,a5,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    800029a2:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029a6:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    800029aa:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800029ac:	6f9c                	ld	a5,24(a5)
    800029ae:	14179073          	csrw	sepc,a5
}
    800029b2:	60a2                	ld	ra,8(sp)
    800029b4:	6402                	ld	s0,0(sp)
    800029b6:	0141                	addi	sp,sp,16
    800029b8:	8082                	ret

00000000800029ba <clockintr>:
    w_sstatus(sstatus);
}

    void
clockintr()
{
    800029ba:	1141                	addi	sp,sp,-16
    800029bc:	e406                	sd	ra,8(sp)
    800029be:	e022                	sd	s0,0(sp)
    800029c0:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    800029c2:	9a4ff0ef          	jal	80001b66 <cpuid>
    800029c6:	cd11                	beqz	a0,800029e2 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800029c8:	c01027f3          	rdtime	a5
    }

    // ask for the next timer interrupt. this also clears
    // the interrupt request. 1000000 is about a tenth
    // of a second.
    w_stimecmp(r_time() + 1000000);
    800029cc:	000f4737          	lui	a4,0xf4
    800029d0:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800029d4:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800029d6:	14d79073          	csrw	stimecmp,a5
}
    800029da:	60a2                	ld	ra,8(sp)
    800029dc:	6402                	ld	s0,0(sp)
    800029de:	0141                	addi	sp,sp,16
    800029e0:	8082                	ret
        acquire(&tickslock);
    800029e2:	0003d517          	auipc	a0,0x3d
    800029e6:	d7650513          	addi	a0,a0,-650 # 8003f758 <tickslock>
    800029ea:	a3efe0ef          	jal	80000c28 <acquire>
        ticks++;
    800029ee:	00009717          	auipc	a4,0x9
    800029f2:	c3a70713          	addi	a4,a4,-966 # 8000b628 <ticks>
    800029f6:	431c                	lw	a5,0(a4)
    800029f8:	2785                	addiw	a5,a5,1
    800029fa:	c31c                	sw	a5,0(a4)
        wakeup(&ticks);
    800029fc:	853a                	mv	a0,a4
    800029fe:	897ff0ef          	jal	80002294 <wakeup>
        release(&tickslock);
    80002a02:	0003d517          	auipc	a0,0x3d
    80002a06:	d5650513          	addi	a0,a0,-682 # 8003f758 <tickslock>
    80002a0a:	ab2fe0ef          	jal	80000cbc <release>
    80002a0e:	bf6d                	j	800029c8 <clockintr+0xe>

0000000080002a10 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
    int
devintr()
{
    80002a10:	1101                	addi	sp,sp,-32
    80002a12:	ec06                	sd	ra,24(sp)
    80002a14:	e822                	sd	s0,16(sp)
    80002a16:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a18:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if(scause == 0x8000000000000009L){
    80002a1c:	57fd                	li	a5,-1
    80002a1e:	17fe                	slli	a5,a5,0x3f
    80002a20:	07a5                	addi	a5,a5,9
    80002a22:	00f70c63          	beq	a4,a5,80002a3a <devintr+0x2a>
        // now allowed to interrupt again.
        if(irq)
            plic_complete(irq);

        return 1;
    } else if(scause == 0x8000000000000005L){
    80002a26:	57fd                	li	a5,-1
    80002a28:	17fe                	slli	a5,a5,0x3f
    80002a2a:	0795                	addi	a5,a5,5
        // timer interrupt.
        clockintr();
        return 2;
    } else {
        return 0;
    80002a2c:	4501                	li	a0,0
    } else if(scause == 0x8000000000000005L){
    80002a2e:	04f70863          	beq	a4,a5,80002a7e <devintr+0x6e>
    }
}
    80002a32:	60e2                	ld	ra,24(sp)
    80002a34:	6442                	ld	s0,16(sp)
    80002a36:	6105                	addi	sp,sp,32
    80002a38:	8082                	ret
    80002a3a:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002a3c:	290030ef          	jal	80005ccc <plic_claim>
    80002a40:	872a                	mv	a4,a0
    80002a42:	84aa                	mv	s1,a0
        if(irq == UART0_IRQ){
    80002a44:	47a9                	li	a5,10
    80002a46:	00f50963          	beq	a0,a5,80002a58 <devintr+0x48>
        } else if(irq == VIRTIO0_IRQ){
    80002a4a:	4785                	li	a5,1
    80002a4c:	00f50963          	beq	a0,a5,80002a5e <devintr+0x4e>
        return 1;
    80002a50:	4505                	li	a0,1
        } else if(irq){
    80002a52:	eb09                	bnez	a4,80002a64 <devintr+0x54>
    80002a54:	64a2                	ld	s1,8(sp)
    80002a56:	bff1                	j	80002a32 <devintr+0x22>
            uartintr();
    80002a58:	f9dfd0ef          	jal	800009f4 <uartintr>
        if(irq)
    80002a5c:	a819                	j	80002a72 <devintr+0x62>
            virtio_disk_intr();
    80002a5e:	704030ef          	jal	80006162 <virtio_disk_intr>
        if(irq)
    80002a62:	a801                	j	80002a72 <devintr+0x62>
            printf("unexpected interrupt irq=%d\n", irq);
    80002a64:	85ba                	mv	a1,a4
    80002a66:	00006517          	auipc	a0,0x6
    80002a6a:	89250513          	addi	a0,a0,-1902 # 800082f8 <etext+0x2f8>
    80002a6e:	a8dfd0ef          	jal	800004fa <printf>
            plic_complete(irq);
    80002a72:	8526                	mv	a0,s1
    80002a74:	278030ef          	jal	80005cec <plic_complete>
        return 1;
    80002a78:	4505                	li	a0,1
    80002a7a:	64a2                	ld	s1,8(sp)
    80002a7c:	bf5d                	j	80002a32 <devintr+0x22>
        clockintr();
    80002a7e:	f3dff0ef          	jal	800029ba <clockintr>
        return 2;
    80002a82:	4509                	li	a0,2
    80002a84:	b77d                	j	80002a32 <devintr+0x22>

0000000080002a86 <usertrap>:
{
    80002a86:	7179                	addi	sp,sp,-48
    80002a88:	f406                	sd	ra,40(sp)
    80002a8a:	f022                	sd	s0,32(sp)
    80002a8c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a8e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002a92:	1007f793          	andi	a5,a5,256
    80002a96:	0e079563          	bnez	a5,80002b80 <usertrap+0xfa>
    80002a9a:	ec26                	sd	s1,24(sp)
    80002a9c:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a9e:	00003797          	auipc	a5,0x3
    80002aa2:	18278793          	addi	a5,a5,386 # 80005c20 <kernelvec>
    80002aa6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002aaa:	8f0ff0ef          	jal	80001b9a <myproc>
    80002aae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002ab0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ab2:	14102773          	csrr	a4,sepc
    80002ab6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ab8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002abc:	47a1                	li	a5,8
    80002abe:	0cf70b63          	beq	a4,a5,80002b94 <usertrap+0x10e>
  } else if((which_dev = devintr()) != 0){
    80002ac2:	f4fff0ef          	jal	80002a10 <devintr>
    80002ac6:	892a                	mv	s2,a0
    80002ac8:	20051463          	bnez	a0,80002cd0 <usertrap+0x24a>
    80002acc:	14202773          	csrr	a4,scause
  } else if((r_scause()== 12 || r_scause() == 15 || r_scause() == 13)) {
    80002ad0:	47b1                	li	a5,12
    80002ad2:	00f70c63          	beq	a4,a5,80002aea <usertrap+0x64>
    80002ad6:	14202773          	csrr	a4,scause
    80002ada:	47bd                	li	a5,15
    80002adc:	00f70763          	beq	a4,a5,80002aea <usertrap+0x64>
    80002ae0:	14202773          	csrr	a4,scause
    80002ae4:	47b5                	li	a5,13
    80002ae6:	1af71e63          	bne	a4,a5,80002ca2 <usertrap+0x21c>
    80002aea:	e44e                	sd	s3,8(sp)
    80002aec:	e052                	sd	s4,0(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002aee:	14302773          	csrr	a4,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80002af2:	77fd                	lui	a5,0xfffff
    80002af4:	8ff9                	and	a5,a5,a4
    80002af6:	89be                	mv	s3,a5
    struct proc *p = myproc();
    80002af8:	8a2ff0ef          	jal	80001b9a <myproc>
    80002afc:	892a                	mv	s2,a0
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002afe:	14202773          	csrr	a4,scause
    if (r_scause() == 12) { access_type = "exec"; }
    80002b02:	47b1                	li	a5,12
    80002b04:	00005697          	auipc	a3,0x5
    80002b08:	6d468693          	addi	a3,a3,1748 # 800081d8 <etext+0x1d8>
    80002b0c:	8a36                	mv	s4,a3
    80002b0e:	00f70c63          	beq	a4,a5,80002b26 <usertrap+0xa0>
    80002b12:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80002b16:	47b5                	li	a5,13
    else { access_type = "write"; }
    80002b18:	00006697          	auipc	a3,0x6
    80002b1c:	80068693          	addi	a3,a3,-2048 # 80008318 <etext+0x318>
    80002b20:	8a36                	mv	s4,a3
    else if (r_scause() == 13) { access_type = "read"; }
    80002b22:	0af70e63          	beq	a4,a5,80002bde <usertrap+0x158>
    if(handle_pgfault(p->pagetable, va) < 0) {
    80002b26:	85ce                	mv	a1,s3
    80002b28:	05093503          	ld	a0,80(s2)
    80002b2c:	deafe0ef          	jal	80001116 <handle_pgfault>
    80002b30:	0a054d63          	bltz	a0,80002bea <usertrap+0x164>
        if (va < p->heap_start) {
    80002b34:	16893783          	ld	a5,360(s2)
    80002b38:	0cf9ea63          	bltu	s3,a5,80002c0c <usertrap+0x186>
        } else if (va < p->sz) {
    80002b3c:	04893783          	ld	a5,72(s2)
    80002b40:	0ef9fa63          	bgeu	s3,a5,80002c34 <usertrap+0x1ae>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=heap\n", p->pid, va, access_type);
    80002b44:	86d2                	mv	a3,s4
    80002b46:	864e                	mv	a2,s3
    80002b48:	03092583          	lw	a1,48(s2)
    80002b4c:	00006517          	auipc	a0,0x6
    80002b50:	88450513          	addi	a0,a0,-1916 # 800083d0 <etext+0x3d0>
    80002b54:	9a7fd0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n",p->pid, va);
    80002b58:	864e                	mv	a2,s3
    80002b5a:	03092583          	lw	a1,48(s2)
    80002b5e:	00006517          	auipc	a0,0x6
    80002b62:	8aa50513          	addi	a0,a0,-1878 # 80008408 <etext+0x408>
    80002b66:	995fd0ef          	jal	800004fa <printf>
        if(p->resident_page_count < MAX_RESIDENT_PAGES){
    80002b6a:	17892703          	lw	a4,376(s2)
    80002b6e:	02700793          	li	a5,39
    80002b72:	0ee7d563          	bge	a5,a4,80002c5c <usertrap+0x1d6>
  asm volatile("sfence.vma zero, zero");
    80002b76:	12000073          	sfence.vma
}
    80002b7a:	69a2                	ld	s3,8(sp)
    80002b7c:	6a02                	ld	s4,0(sp)
    80002b7e:	a815                	j	80002bb2 <usertrap+0x12c>
    80002b80:	ec26                	sd	s1,24(sp)
    80002b82:	e84a                	sd	s2,16(sp)
    80002b84:	e44e                	sd	s3,8(sp)
    80002b86:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    80002b88:	00005517          	auipc	a0,0x5
    80002b8c:	79850513          	addi	a0,a0,1944 # 80008320 <etext+0x320>
    80002b90:	c95fd0ef          	jal	80000824 <panic>
    if(killed(p))
    80002b94:	aa3ff0ef          	jal	80002636 <killed>
    80002b98:	ed1d                	bnez	a0,80002bd6 <usertrap+0x150>
    p->trapframe->epc += 4;
    80002b9a:	6cb8                	ld	a4,88(s1)
    80002b9c:	6f1c                	ld	a5,24(a4)
    80002b9e:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7ffb44cc>
    80002ba0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ba2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002ba6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002baa:	10079073          	csrw	sstatus,a5
    syscall();
    80002bae:	31c000ef          	jal	80002eca <syscall>
  if(killed(p))
    80002bb2:	8526                	mv	a0,s1
    80002bb4:	a83ff0ef          	jal	80002636 <killed>
    80002bb8:	12051163          	bnez	a0,80002cda <usertrap+0x254>
  prepare_return();
    80002bbc:	d85ff0ef          	jal	80002940 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002bc0:	68a8                	ld	a0,80(s1)
    80002bc2:	8131                	srli	a0,a0,0xc
    80002bc4:	57fd                	li	a5,-1
    80002bc6:	17fe                	slli	a5,a5,0x3f
    80002bc8:	8d5d                	or	a0,a0,a5
}
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	70a2                	ld	ra,40(sp)
    80002bd0:	7402                	ld	s0,32(sp)
    80002bd2:	6145                	addi	sp,sp,48
    80002bd4:	8082                	ret
      kexit(-1);
    80002bd6:	557d                	li	a0,-1
    80002bd8:	f8cff0ef          	jal	80002364 <kexit>
    80002bdc:	bf7d                	j	80002b9a <usertrap+0x114>
    else if (r_scause() == 13) { access_type = "read"; }
    80002bde:	00006797          	auipc	a5,0x6
    80002be2:	aea78793          	addi	a5,a5,-1302 # 800086c8 <etext+0x6c8>
    80002be6:	8a3e                	mv	s4,a5
    80002be8:	bf3d                	j	80002b26 <usertrap+0xa0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002bea:	14302673          	csrr	a2,stval
      printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, r_stval(), access_type);
    80002bee:	86d2                	mv	a3,s4
    80002bf0:	03092583          	lw	a1,48(s2)
    80002bf4:	00005517          	auipc	a0,0x5
    80002bf8:	74c50513          	addi	a0,a0,1868 # 80008340 <etext+0x340>
    80002bfc:	8fffd0ef          	jal	800004fa <printf>
      setkilled(p);
    80002c00:	854a                	mv	a0,s2
    80002c02:	a11ff0ef          	jal	80002612 <setkilled>
    80002c06:	69a2                	ld	s3,8(sp)
    80002c08:	6a02                	ld	s4,0(sp)
    80002c0a:	b765                	j	80002bb2 <usertrap+0x12c>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=exec\n", p->pid, va, access_type);
    80002c0c:	86d2                	mv	a3,s4
    80002c0e:	864e                	mv	a2,s3
    80002c10:	03092583          	lw	a1,48(s2)
    80002c14:	00005517          	auipc	a0,0x5
    80002c18:	76450513          	addi	a0,a0,1892 # 80008378 <etext+0x378>
    80002c1c:	8dffd0ef          	jal	800004fa <printf>
            printf("[pid %d] LOADEXEC va=0x%lx\n",p->pid, va);
    80002c20:	864e                	mv	a2,s3
    80002c22:	03092583          	lw	a1,48(s2)
    80002c26:	00005517          	auipc	a0,0x5
    80002c2a:	78a50513          	addi	a0,a0,1930 # 800083b0 <etext+0x3b0>
    80002c2e:	8cdfd0ef          	jal	800004fa <printf>
    80002c32:	bf25                	j	80002b6a <usertrap+0xe4>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=stack\n", p->pid, va, access_type);
    80002c34:	86d2                	mv	a3,s4
    80002c36:	864e                	mv	a2,s3
    80002c38:	03092583          	lw	a1,48(s2)
    80002c3c:	00005517          	auipc	a0,0x5
    80002c40:	7ec50513          	addi	a0,a0,2028 # 80008428 <etext+0x428>
    80002c44:	8b7fd0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n",p->pid, va);
    80002c48:	864e                	mv	a2,s3
    80002c4a:	03092583          	lw	a1,48(s2)
    80002c4e:	00005517          	auipc	a0,0x5
    80002c52:	7ba50513          	addi	a0,a0,1978 # 80008408 <etext+0x408>
    80002c56:	8a5fd0ef          	jal	800004fa <printf>
    80002c5a:	bf01                	j	80002b6a <usertrap+0xe4>
            printf("[pid %d] RESIDENT va=0x%lx seq=%d\n",p->pid, va,p->next_fifo_seq);
    80002c5c:	17c92683          	lw	a3,380(s2)
    80002c60:	864e                	mv	a2,s3
    80002c62:	03092583          	lw	a1,48(s2)
    80002c66:	00005517          	auipc	a0,0x5
    80002c6a:	7fa50513          	addi	a0,a0,2042 # 80008460 <etext+0x460>
    80002c6e:	88dfd0ef          	jal	800004fa <printf>
            int index = p->resident_page_count;
    80002c72:	17892783          	lw	a5,376(s2)
            p->resident_pages[index] = va;
    80002c76:	00379713          	slli	a4,a5,0x3
    80002c7a:	18070713          	addi	a4,a4,384
    80002c7e:	974a                	add	a4,a4,s2
    80002c80:	01373023          	sd	s3,0(a4)
            p->fifo_seq[index] = p->next_fifo_seq;
    80002c84:	17c92703          	lw	a4,380(s2)
    80002c88:	00279693          	slli	a3,a5,0x2
    80002c8c:	2c068693          	addi	a3,a3,704
    80002c90:	96ca                	add	a3,a3,s2
    80002c92:	c298                	sw	a4,0(a3)
            p->resident_page_count++;
    80002c94:	2785                	addiw	a5,a5,1
    80002c96:	16f92c23          	sw	a5,376(s2)
            p->next_fifo_seq++;
    80002c9a:	2705                	addiw	a4,a4,1
    80002c9c:	16e92e23          	sw	a4,380(s2)
    80002ca0:	bdd9                	j	80002b76 <usertrap+0xf0>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ca2:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002ca6:	5890                	lw	a2,48(s1)
    80002ca8:	00005517          	auipc	a0,0x5
    80002cac:	7e050513          	addi	a0,a0,2016 # 80008488 <etext+0x488>
    80002cb0:	84bfd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cb4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002cb8:	14302673          	csrr	a2,stval
      printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002cbc:	00005517          	auipc	a0,0x5
    80002cc0:	7fc50513          	addi	a0,a0,2044 # 800084b8 <etext+0x4b8>
    80002cc4:	837fd0ef          	jal	800004fa <printf>
      setkilled(p);
    80002cc8:	8526                	mv	a0,s1
    80002cca:	949ff0ef          	jal	80002612 <setkilled>
    80002cce:	b5d5                	j	80002bb2 <usertrap+0x12c>
  if(killed(p))
    80002cd0:	8526                	mv	a0,s1
    80002cd2:	965ff0ef          	jal	80002636 <killed>
    80002cd6:	c511                	beqz	a0,80002ce2 <usertrap+0x25c>
    80002cd8:	a011                	j	80002cdc <usertrap+0x256>
    80002cda:	4901                	li	s2,0
      kexit(-1);
    80002cdc:	557d                	li	a0,-1
    80002cde:	e86ff0ef          	jal	80002364 <kexit>
  if(which_dev == 2)
    80002ce2:	4789                	li	a5,2
    80002ce4:	ecf91ce3          	bne	s2,a5,80002bbc <usertrap+0x136>
      yield();
    80002ce8:	d34ff0ef          	jal	8000221c <yield>
    80002cec:	bdc1                	j	80002bbc <usertrap+0x136>

0000000080002cee <kerneltrap>:
{
    80002cee:	7179                	addi	sp,sp,-48
    80002cf0:	f406                	sd	ra,40(sp)
    80002cf2:	f022                	sd	s0,32(sp)
    80002cf4:	ec26                	sd	s1,24(sp)
    80002cf6:	e84a                	sd	s2,16(sp)
    80002cf8:	e44e                	sd	s3,8(sp)
    80002cfa:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002cfc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d00:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d04:	142027f3          	csrr	a5,scause
    80002d08:	89be                	mv	s3,a5
    if((sstatus & SSTATUS_SPP) == 0)
    80002d0a:	1004f793          	andi	a5,s1,256
    80002d0e:	c795                	beqz	a5,80002d3a <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d14:	8b89                	andi	a5,a5,2
    if(intr_get() != 0)
    80002d16:	eb85                	bnez	a5,80002d46 <kerneltrap+0x58>
    if((which_dev = devintr()) == 0){
    80002d18:	cf9ff0ef          	jal	80002a10 <devintr>
    80002d1c:	c91d                	beqz	a0,80002d52 <kerneltrap+0x64>
    if(which_dev == 2 && myproc() != 0)
    80002d1e:	4789                	li	a5,2
    80002d20:	04f50a63          	beq	a0,a5,80002d74 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d24:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d28:	10049073          	csrw	sstatus,s1
}
    80002d2c:	70a2                	ld	ra,40(sp)
    80002d2e:	7402                	ld	s0,32(sp)
    80002d30:	64e2                	ld	s1,24(sp)
    80002d32:	6942                	ld	s2,16(sp)
    80002d34:	69a2                	ld	s3,8(sp)
    80002d36:	6145                	addi	sp,sp,48
    80002d38:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002d3a:	00005517          	auipc	a0,0x5
    80002d3e:	7a650513          	addi	a0,a0,1958 # 800084e0 <etext+0x4e0>
    80002d42:	ae3fd0ef          	jal	80000824 <panic>
        panic("kerneltrap: interrupts enabled");
    80002d46:	00005517          	auipc	a0,0x5
    80002d4a:	7c250513          	addi	a0,a0,1986 # 80008508 <etext+0x508>
    80002d4e:	ad7fd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d52:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d56:	143026f3          	csrr	a3,stval
        printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002d5a:	85ce                	mv	a1,s3
    80002d5c:	00005517          	auipc	a0,0x5
    80002d60:	7cc50513          	addi	a0,a0,1996 # 80008528 <etext+0x528>
    80002d64:	f96fd0ef          	jal	800004fa <printf>
        panic("kerneltrap");
    80002d68:	00005517          	auipc	a0,0x5
    80002d6c:	7e850513          	addi	a0,a0,2024 # 80008550 <etext+0x550>
    80002d70:	ab5fd0ef          	jal	80000824 <panic>
    if(which_dev == 2 && myproc() != 0)
    80002d74:	e27fe0ef          	jal	80001b9a <myproc>
    80002d78:	d555                	beqz	a0,80002d24 <kerneltrap+0x36>
        yield();
    80002d7a:	ca2ff0ef          	jal	8000221c <yield>
    80002d7e:	b75d                	j	80002d24 <kerneltrap+0x36>

0000000080002d80 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002d80:	1101                	addi	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	1000                	addi	s0,sp,32
    80002d8a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002d8c:	e0ffe0ef          	jal	80001b9a <myproc>
  switch (n) {
    80002d90:	4795                	li	a5,5
    80002d92:	0497e163          	bltu	a5,s1,80002dd4 <argraw+0x54>
    80002d96:	048a                	slli	s1,s1,0x2
    80002d98:	00006717          	auipc	a4,0x6
    80002d9c:	c4870713          	addi	a4,a4,-952 # 800089e0 <states.0+0x30>
    80002da0:	94ba                	add	s1,s1,a4
    80002da2:	409c                	lw	a5,0(s1)
    80002da4:	97ba                	add	a5,a5,a4
    80002da6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002da8:	6d3c                	ld	a5,88(a0)
    80002daa:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002dac:	60e2                	ld	ra,24(sp)
    80002dae:	6442                	ld	s0,16(sp)
    80002db0:	64a2                	ld	s1,8(sp)
    80002db2:	6105                	addi	sp,sp,32
    80002db4:	8082                	ret
    return p->trapframe->a1;
    80002db6:	6d3c                	ld	a5,88(a0)
    80002db8:	7fa8                	ld	a0,120(a5)
    80002dba:	bfcd                	j	80002dac <argraw+0x2c>
    return p->trapframe->a2;
    80002dbc:	6d3c                	ld	a5,88(a0)
    80002dbe:	63c8                	ld	a0,128(a5)
    80002dc0:	b7f5                	j	80002dac <argraw+0x2c>
    return p->trapframe->a3;
    80002dc2:	6d3c                	ld	a5,88(a0)
    80002dc4:	67c8                	ld	a0,136(a5)
    80002dc6:	b7dd                	j	80002dac <argraw+0x2c>
    return p->trapframe->a4;
    80002dc8:	6d3c                	ld	a5,88(a0)
    80002dca:	6bc8                	ld	a0,144(a5)
    80002dcc:	b7c5                	j	80002dac <argraw+0x2c>
    return p->trapframe->a5;
    80002dce:	6d3c                	ld	a5,88(a0)
    80002dd0:	6fc8                	ld	a0,152(a5)
    80002dd2:	bfe9                	j	80002dac <argraw+0x2c>
  panic("argraw");
    80002dd4:	00005517          	auipc	a0,0x5
    80002dd8:	78c50513          	addi	a0,a0,1932 # 80008560 <etext+0x560>
    80002ddc:	a49fd0ef          	jal	80000824 <panic>

0000000080002de0 <fetchaddr>:
{
    80002de0:	1101                	addi	sp,sp,-32
    80002de2:	ec06                	sd	ra,24(sp)
    80002de4:	e822                	sd	s0,16(sp)
    80002de6:	e426                	sd	s1,8(sp)
    80002de8:	e04a                	sd	s2,0(sp)
    80002dea:	1000                	addi	s0,sp,32
    80002dec:	84aa                	mv	s1,a0
    80002dee:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002df0:	dabfe0ef          	jal	80001b9a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002df4:	653c                	ld	a5,72(a0)
    80002df6:	02f4f663          	bgeu	s1,a5,80002e22 <fetchaddr+0x42>
    80002dfa:	00848713          	addi	a4,s1,8
    80002dfe:	02e7e463          	bltu	a5,a4,80002e26 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e02:	46a1                	li	a3,8
    80002e04:	8626                	mv	a2,s1
    80002e06:	85ca                	mv	a1,s2
    80002e08:	6928                	ld	a0,80(a0)
    80002e0a:	a73fe0ef          	jal	8000187c <copyin>
    80002e0e:	00a03533          	snez	a0,a0
    80002e12:	40a0053b          	negw	a0,a0
}
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6902                	ld	s2,0(sp)
    80002e1e:	6105                	addi	sp,sp,32
    80002e20:	8082                	ret
    return -1;
    80002e22:	557d                	li	a0,-1
    80002e24:	bfcd                	j	80002e16 <fetchaddr+0x36>
    80002e26:	557d                	li	a0,-1
    80002e28:	b7fd                	j	80002e16 <fetchaddr+0x36>

0000000080002e2a <fetchstr>:
{
    80002e2a:	7179                	addi	sp,sp,-48
    80002e2c:	f406                	sd	ra,40(sp)
    80002e2e:	f022                	sd	s0,32(sp)
    80002e30:	ec26                	sd	s1,24(sp)
    80002e32:	e84a                	sd	s2,16(sp)
    80002e34:	e44e                	sd	s3,8(sp)
    80002e36:	1800                	addi	s0,sp,48
    80002e38:	89aa                	mv	s3,a0
    80002e3a:	84ae                	mv	s1,a1
    80002e3c:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002e3e:	d5dfe0ef          	jal	80001b9a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002e42:	86ca                	mv	a3,s2
    80002e44:	864e                	mv	a2,s3
    80002e46:	85a6                	mv	a1,s1
    80002e48:	6928                	ld	a0,80(a0)
    80002e4a:	acdfe0ef          	jal	80001916 <copyinstr>
    80002e4e:	00054c63          	bltz	a0,80002e66 <fetchstr+0x3c>
  return strlen(buf);
    80002e52:	8526                	mv	a0,s1
    80002e54:	82efe0ef          	jal	80000e82 <strlen>
}
    80002e58:	70a2                	ld	ra,40(sp)
    80002e5a:	7402                	ld	s0,32(sp)
    80002e5c:	64e2                	ld	s1,24(sp)
    80002e5e:	6942                	ld	s2,16(sp)
    80002e60:	69a2                	ld	s3,8(sp)
    80002e62:	6145                	addi	sp,sp,48
    80002e64:	8082                	ret
    return -1;
    80002e66:	557d                	li	a0,-1
    80002e68:	bfc5                	j	80002e58 <fetchstr+0x2e>

0000000080002e6a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002e6a:	1101                	addi	sp,sp,-32
    80002e6c:	ec06                	sd	ra,24(sp)
    80002e6e:	e822                	sd	s0,16(sp)
    80002e70:	e426                	sd	s1,8(sp)
    80002e72:	1000                	addi	s0,sp,32
    80002e74:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e76:	f0bff0ef          	jal	80002d80 <argraw>
    80002e7a:	c088                	sw	a0,0(s1)
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret

0000000080002e86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002e86:	1101                	addi	sp,sp,-32
    80002e88:	ec06                	sd	ra,24(sp)
    80002e8a:	e822                	sd	s0,16(sp)
    80002e8c:	e426                	sd	s1,8(sp)
    80002e8e:	1000                	addi	s0,sp,32
    80002e90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002e92:	eefff0ef          	jal	80002d80 <argraw>
    80002e96:	e088                	sd	a0,0(s1)
}
    80002e98:	60e2                	ld	ra,24(sp)
    80002e9a:	6442                	ld	s0,16(sp)
    80002e9c:	64a2                	ld	s1,8(sp)
    80002e9e:	6105                	addi	sp,sp,32
    80002ea0:	8082                	ret

0000000080002ea2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ea2:	1101                	addi	sp,sp,-32
    80002ea4:	ec06                	sd	ra,24(sp)
    80002ea6:	e822                	sd	s0,16(sp)
    80002ea8:	e426                	sd	s1,8(sp)
    80002eaa:	e04a                	sd	s2,0(sp)
    80002eac:	1000                	addi	s0,sp,32
    80002eae:	892e                	mv	s2,a1
    80002eb0:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002eb2:	ecfff0ef          	jal	80002d80 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002eb6:	8626                	mv	a2,s1
    80002eb8:	85ca                	mv	a1,s2
    80002eba:	f71ff0ef          	jal	80002e2a <fetchstr>
}
    80002ebe:	60e2                	ld	ra,24(sp)
    80002ec0:	6442                	ld	s0,16(sp)
    80002ec2:	64a2                	ld	s1,8(sp)
    80002ec4:	6902                	ld	s2,0(sp)
    80002ec6:	6105                	addi	sp,sp,32
    80002ec8:	8082                	ret

0000000080002eca <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	e426                	sd	s1,8(sp)
    80002ed2:	e04a                	sd	s2,0(sp)
    80002ed4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002ed6:	cc5fe0ef          	jal	80001b9a <myproc>
    80002eda:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002edc:	05853903          	ld	s2,88(a0)
    80002ee0:	0a893783          	ld	a5,168(s2)
    80002ee4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ee8:	37fd                	addiw	a5,a5,-1
    80002eea:	4751                	li	a4,20
    80002eec:	00f76f63          	bltu	a4,a5,80002f0a <syscall+0x40>
    80002ef0:	00369713          	slli	a4,a3,0x3
    80002ef4:	00006797          	auipc	a5,0x6
    80002ef8:	b0478793          	addi	a5,a5,-1276 # 800089f8 <syscalls>
    80002efc:	97ba                	add	a5,a5,a4
    80002efe:	639c                	ld	a5,0(a5)
    80002f00:	c789                	beqz	a5,80002f0a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002f02:	9782                	jalr	a5
    80002f04:	06a93823          	sd	a0,112(s2)
    80002f08:	a829                	j	80002f22 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f0a:	15848613          	addi	a2,s1,344
    80002f0e:	588c                	lw	a1,48(s1)
    80002f10:	00005517          	auipc	a0,0x5
    80002f14:	65850513          	addi	a0,a0,1624 # 80008568 <etext+0x568>
    80002f18:	de2fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002f1c:	6cbc                	ld	a5,88(s1)
    80002f1e:	577d                	li	a4,-1
    80002f20:	fbb8                	sd	a4,112(a5)
  }
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	6902                	ld	s2,0(sp)
    80002f2a:	6105                	addi	sp,sp,32
    80002f2c:	8082                	ret

0000000080002f2e <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002f2e:	1101                	addi	sp,sp,-32
    80002f30:	ec06                	sd	ra,24(sp)
    80002f32:	e822                	sd	s0,16(sp)
    80002f34:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002f36:	fec40593          	addi	a1,s0,-20
    80002f3a:	4501                	li	a0,0
    80002f3c:	f2fff0ef          	jal	80002e6a <argint>
  kexit(n);
    80002f40:	fec42503          	lw	a0,-20(s0)
    80002f44:	c20ff0ef          	jal	80002364 <kexit>
  return 0;  // not reached
}
    80002f48:	4501                	li	a0,0
    80002f4a:	60e2                	ld	ra,24(sp)
    80002f4c:	6442                	ld	s0,16(sp)
    80002f4e:	6105                	addi	sp,sp,32
    80002f50:	8082                	ret

0000000080002f52 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002f52:	1141                	addi	sp,sp,-16
    80002f54:	e406                	sd	ra,8(sp)
    80002f56:	e022                	sd	s0,0(sp)
    80002f58:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002f5a:	c41fe0ef          	jal	80001b9a <myproc>
}
    80002f5e:	5908                	lw	a0,48(a0)
    80002f60:	60a2                	ld	ra,8(sp)
    80002f62:	6402                	ld	s0,0(sp)
    80002f64:	0141                	addi	sp,sp,16
    80002f66:	8082                	ret

0000000080002f68 <sys_fork>:

uint64
sys_fork(void)
{
    80002f68:	1141                	addi	sp,sp,-16
    80002f6a:	e406                	sd	ra,8(sp)
    80002f6c:	e022                	sd	s0,0(sp)
    80002f6e:	0800                	addi	s0,sp,16
  return kfork();
    80002f70:	814ff0ef          	jal	80001f84 <kfork>
}
    80002f74:	60a2                	ld	ra,8(sp)
    80002f76:	6402                	ld	s0,0(sp)
    80002f78:	0141                	addi	sp,sp,16
    80002f7a:	8082                	ret

0000000080002f7c <sys_wait>:

uint64
sys_wait(void)
{
    80002f7c:	1101                	addi	sp,sp,-32
    80002f7e:	ec06                	sd	ra,24(sp)
    80002f80:	e822                	sd	s0,16(sp)
    80002f82:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002f84:	fe840593          	addi	a1,s0,-24
    80002f88:	4501                	li	a0,0
    80002f8a:	efdff0ef          	jal	80002e86 <argaddr>
  return kwait(p);
    80002f8e:	fe843503          	ld	a0,-24(s0)
    80002f92:	eceff0ef          	jal	80002660 <kwait>
}
    80002f96:	60e2                	ld	ra,24(sp)
    80002f98:	6442                	ld	s0,16(sp)
    80002f9a:	6105                	addi	sp,sp,32
    80002f9c:	8082                	ret

0000000080002f9e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002f9e:	715d                	addi	sp,sp,-80
    80002fa0:	e486                	sd	ra,72(sp)
    80002fa2:	e0a2                	sd	s0,64(sp)
    80002fa4:	fc26                	sd	s1,56(sp)
    80002fa6:	0880                	addi	s0,sp,80
  uint64 addr;
  int n;

  argint(0, &n);
    80002fa8:	fbc40593          	addi	a1,s0,-68
    80002fac:	4501                	li	a0,0
    80002fae:	ebdff0ef          	jal	80002e6a <argint>
  addr = myproc()->sz;
    80002fb2:	be9fe0ef          	jal	80001b9a <myproc>
    80002fb6:	6524                	ld	s1,72(a0)

  if (n > 0) {
    80002fb8:	fbc42783          	lw	a5,-68(s0)
    80002fbc:	02f05363          	blez	a5,80002fe2 <sys_sbrk+0x44>
    if(addr + n < addr || addr + n > TRAPFRAME) // Check for overflow or exceeding max address
    80002fc0:	97a6                	add	a5,a5,s1
    80002fc2:	02000737          	lui	a4,0x2000
    80002fc6:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80002fc8:	0736                	slli	a4,a4,0xd
    80002fca:	06f76663          	bltu	a4,a5,80003036 <sys_sbrk+0x98>
    80002fce:	0697e463          	bltu	a5,s1,80003036 <sys_sbrk+0x98>
      return -1;
    myproc()->sz += n;
    80002fd2:	bc9fe0ef          	jal	80001b9a <myproc>
    80002fd6:	fbc42703          	lw	a4,-68(s0)
    80002fda:	653c                	ld	a5,72(a0)
    80002fdc:	97ba                	add	a5,a5,a4
    80002fde:	e53c                	sd	a5,72(a0)
    80002fe0:	a019                	j	80002fe6 <sys_sbrk+0x48>
  } else if (n < 0) {
    80002fe2:	0007c863          	bltz	a5,80002ff2 <sys_sbrk+0x54>
    return -1;
  }
  */

  return addr;
}
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	60a6                	ld	ra,72(sp)
    80002fea:	6406                	ld	s0,64(sp)
    80002fec:	74e2                	ld	s1,56(sp)
    80002fee:	6161                	addi	sp,sp,80
    80002ff0:	8082                	ret
    80002ff2:	f84a                	sd	s2,48(sp)
    80002ff4:	f44e                	sd	s3,40(sp)
    80002ff6:	f052                	sd	s4,32(sp)
    80002ff8:	ec56                	sd	s5,24(sp)
    myproc()->sz = uvmdealloc(myproc()->pagetable, myproc()->sz, myproc()->sz + n);
    80002ffa:	ba1fe0ef          	jal	80001b9a <myproc>
    80002ffe:	05053903          	ld	s2,80(a0)
    80003002:	b99fe0ef          	jal	80001b9a <myproc>
    80003006:	04853983          	ld	s3,72(a0)
    8000300a:	b91fe0ef          	jal	80001b9a <myproc>
    8000300e:	fbc42783          	lw	a5,-68(s0)
    80003012:	6538                	ld	a4,72(a0)
    80003014:	00e78a33          	add	s4,a5,a4
    80003018:	b83fe0ef          	jal	80001b9a <myproc>
    8000301c:	8aaa                	mv	s5,a0
    8000301e:	8652                	mv	a2,s4
    80003020:	85ce                	mv	a1,s3
    80003022:	854a                	mv	a0,s2
    80003024:	d36fe0ef          	jal	8000155a <uvmdealloc>
    80003028:	04aab423          	sd	a0,72(s5)
    8000302c:	7942                	ld	s2,48(sp)
    8000302e:	79a2                	ld	s3,40(sp)
    80003030:	7a02                	ld	s4,32(sp)
    80003032:	6ae2                	ld	s5,24(sp)
    80003034:	bf4d                	j	80002fe6 <sys_sbrk+0x48>
      return -1;
    80003036:	54fd                	li	s1,-1
    80003038:	b77d                	j	80002fe6 <sys_sbrk+0x48>

000000008000303a <sys_pause>:

uint64
sys_pause(void)
{
    8000303a:	7139                	addi	sp,sp,-64
    8000303c:	fc06                	sd	ra,56(sp)
    8000303e:	f822                	sd	s0,48(sp)
    80003040:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003042:	fcc40593          	addi	a1,s0,-52
    80003046:	4501                	li	a0,0
    80003048:	e23ff0ef          	jal	80002e6a <argint>
  if(n < 0)
    8000304c:	fcc42783          	lw	a5,-52(s0)
    80003050:	0607c863          	bltz	a5,800030c0 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80003054:	0003c517          	auipc	a0,0x3c
    80003058:	70450513          	addi	a0,a0,1796 # 8003f758 <tickslock>
    8000305c:	bcdfd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80003060:	fcc42783          	lw	a5,-52(s0)
    80003064:	c3b9                	beqz	a5,800030aa <sys_pause+0x70>
    80003066:	f426                	sd	s1,40(sp)
    80003068:	f04a                	sd	s2,32(sp)
    8000306a:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    8000306c:	00008997          	auipc	s3,0x8
    80003070:	5bc9a983          	lw	s3,1468(s3) # 8000b628 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003074:	0003c917          	auipc	s2,0x3c
    80003078:	6e490913          	addi	s2,s2,1764 # 8003f758 <tickslock>
    8000307c:	00008497          	auipc	s1,0x8
    80003080:	5ac48493          	addi	s1,s1,1452 # 8000b628 <ticks>
    if(killed(myproc())){
    80003084:	b17fe0ef          	jal	80001b9a <myproc>
    80003088:	daeff0ef          	jal	80002636 <killed>
    8000308c:	ed0d                	bnez	a0,800030c6 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    8000308e:	85ca                	mv	a1,s2
    80003090:	8526                	mv	a0,s1
    80003092:	9b6ff0ef          	jal	80002248 <sleep>
  while(ticks - ticks0 < n){
    80003096:	409c                	lw	a5,0(s1)
    80003098:	413787bb          	subw	a5,a5,s3
    8000309c:	fcc42703          	lw	a4,-52(s0)
    800030a0:	fee7e2e3          	bltu	a5,a4,80003084 <sys_pause+0x4a>
    800030a4:	74a2                	ld	s1,40(sp)
    800030a6:	7902                	ld	s2,32(sp)
    800030a8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800030aa:	0003c517          	auipc	a0,0x3c
    800030ae:	6ae50513          	addi	a0,a0,1710 # 8003f758 <tickslock>
    800030b2:	c0bfd0ef          	jal	80000cbc <release>
  return 0;
    800030b6:	4501                	li	a0,0
}
    800030b8:	70e2                	ld	ra,56(sp)
    800030ba:	7442                	ld	s0,48(sp)
    800030bc:	6121                	addi	sp,sp,64
    800030be:	8082                	ret
    n = 0;
    800030c0:	fc042623          	sw	zero,-52(s0)
    800030c4:	bf41                	j	80003054 <sys_pause+0x1a>
      release(&tickslock);
    800030c6:	0003c517          	auipc	a0,0x3c
    800030ca:	69250513          	addi	a0,a0,1682 # 8003f758 <tickslock>
    800030ce:	beffd0ef          	jal	80000cbc <release>
      return -1;
    800030d2:	557d                	li	a0,-1
    800030d4:	74a2                	ld	s1,40(sp)
    800030d6:	7902                	ld	s2,32(sp)
    800030d8:	69e2                	ld	s3,24(sp)
    800030da:	bff9                	j	800030b8 <sys_pause+0x7e>

00000000800030dc <sys_kill>:

uint64
sys_kill(void)
{
    800030dc:	1101                	addi	sp,sp,-32
    800030de:	ec06                	sd	ra,24(sp)
    800030e0:	e822                	sd	s0,16(sp)
    800030e2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800030e4:	fec40593          	addi	a1,s0,-20
    800030e8:	4501                	li	a0,0
    800030ea:	d81ff0ef          	jal	80002e6a <argint>
  return kkill(pid);
    800030ee:	fec42503          	lw	a0,-20(s0)
    800030f2:	cb2ff0ef          	jal	800025a4 <kkill>
}
    800030f6:	60e2                	ld	ra,24(sp)
    800030f8:	6442                	ld	s0,16(sp)
    800030fa:	6105                	addi	sp,sp,32
    800030fc:	8082                	ret

00000000800030fe <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800030fe:	1101                	addi	sp,sp,-32
    80003100:	ec06                	sd	ra,24(sp)
    80003102:	e822                	sd	s0,16(sp)
    80003104:	e426                	sd	s1,8(sp)
    80003106:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003108:	0003c517          	auipc	a0,0x3c
    8000310c:	65050513          	addi	a0,a0,1616 # 8003f758 <tickslock>
    80003110:	b19fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80003114:	00008797          	auipc	a5,0x8
    80003118:	5147a783          	lw	a5,1300(a5) # 8000b628 <ticks>
    8000311c:	84be                	mv	s1,a5
  release(&tickslock);
    8000311e:	0003c517          	auipc	a0,0x3c
    80003122:	63a50513          	addi	a0,a0,1594 # 8003f758 <tickslock>
    80003126:	b97fd0ef          	jal	80000cbc <release>
  return xticks;
}
    8000312a:	02049513          	slli	a0,s1,0x20
    8000312e:	9101                	srli	a0,a0,0x20
    80003130:	60e2                	ld	ra,24(sp)
    80003132:	6442                	ld	s0,16(sp)
    80003134:	64a2                	ld	s1,8(sp)
    80003136:	6105                	addi	sp,sp,32
    80003138:	8082                	ret

000000008000313a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000313a:	7179                	addi	sp,sp,-48
    8000313c:	f406                	sd	ra,40(sp)
    8000313e:	f022                	sd	s0,32(sp)
    80003140:	ec26                	sd	s1,24(sp)
    80003142:	e84a                	sd	s2,16(sp)
    80003144:	e44e                	sd	s3,8(sp)
    80003146:	e052                	sd	s4,0(sp)
    80003148:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000314a:	00005597          	auipc	a1,0x5
    8000314e:	43e58593          	addi	a1,a1,1086 # 80008588 <etext+0x588>
    80003152:	0003c517          	auipc	a0,0x3c
    80003156:	61e50513          	addi	a0,a0,1566 # 8003f770 <bcache>
    8000315a:	a45fd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000315e:	00044797          	auipc	a5,0x44
    80003162:	61278793          	addi	a5,a5,1554 # 80047770 <bcache+0x8000>
    80003166:	00045717          	auipc	a4,0x45
    8000316a:	87270713          	addi	a4,a4,-1934 # 800479d8 <bcache+0x8268>
    8000316e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003172:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003176:	0003c497          	auipc	s1,0x3c
    8000317a:	61248493          	addi	s1,s1,1554 # 8003f788 <bcache+0x18>
    b->next = bcache.head.next;
    8000317e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003180:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003182:	00005a17          	auipc	s4,0x5
    80003186:	40ea0a13          	addi	s4,s4,1038 # 80008590 <etext+0x590>
    b->next = bcache.head.next;
    8000318a:	2b893783          	ld	a5,696(s2)
    8000318e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003190:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003194:	85d2                	mv	a1,s4
    80003196:	01048513          	addi	a0,s1,16
    8000319a:	328010ef          	jal	800044c2 <initsleeplock>
    bcache.head.next->prev = b;
    8000319e:	2b893783          	ld	a5,696(s2)
    800031a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800031a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800031a8:	45848493          	addi	s1,s1,1112
    800031ac:	fd349fe3          	bne	s1,s3,8000318a <binit+0x50>
  }
}
    800031b0:	70a2                	ld	ra,40(sp)
    800031b2:	7402                	ld	s0,32(sp)
    800031b4:	64e2                	ld	s1,24(sp)
    800031b6:	6942                	ld	s2,16(sp)
    800031b8:	69a2                	ld	s3,8(sp)
    800031ba:	6a02                	ld	s4,0(sp)
    800031bc:	6145                	addi	sp,sp,48
    800031be:	8082                	ret

00000000800031c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800031c0:	7179                	addi	sp,sp,-48
    800031c2:	f406                	sd	ra,40(sp)
    800031c4:	f022                	sd	s0,32(sp)
    800031c6:	ec26                	sd	s1,24(sp)
    800031c8:	e84a                	sd	s2,16(sp)
    800031ca:	e44e                	sd	s3,8(sp)
    800031cc:	1800                	addi	s0,sp,48
    800031ce:	892a                	mv	s2,a0
    800031d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800031d2:	0003c517          	auipc	a0,0x3c
    800031d6:	59e50513          	addi	a0,a0,1438 # 8003f770 <bcache>
    800031da:	a4ffd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800031de:	00045497          	auipc	s1,0x45
    800031e2:	84a4b483          	ld	s1,-1974(s1) # 80047a28 <bcache+0x82b8>
    800031e6:	00044797          	auipc	a5,0x44
    800031ea:	7f278793          	addi	a5,a5,2034 # 800479d8 <bcache+0x8268>
    800031ee:	02f48b63          	beq	s1,a5,80003224 <bread+0x64>
    800031f2:	873e                	mv	a4,a5
    800031f4:	a021                	j	800031fc <bread+0x3c>
    800031f6:	68a4                	ld	s1,80(s1)
    800031f8:	02e48663          	beq	s1,a4,80003224 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800031fc:	449c                	lw	a5,8(s1)
    800031fe:	ff279ce3          	bne	a5,s2,800031f6 <bread+0x36>
    80003202:	44dc                	lw	a5,12(s1)
    80003204:	ff3799e3          	bne	a5,s3,800031f6 <bread+0x36>
      b->refcnt++;
    80003208:	40bc                	lw	a5,64(s1)
    8000320a:	2785                	addiw	a5,a5,1
    8000320c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000320e:	0003c517          	auipc	a0,0x3c
    80003212:	56250513          	addi	a0,a0,1378 # 8003f770 <bcache>
    80003216:	aa7fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    8000321a:	01048513          	addi	a0,s1,16
    8000321e:	2da010ef          	jal	800044f8 <acquiresleep>
      return b;
    80003222:	a889                	j	80003274 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003224:	00044497          	auipc	s1,0x44
    80003228:	7fc4b483          	ld	s1,2044(s1) # 80047a20 <bcache+0x82b0>
    8000322c:	00044797          	auipc	a5,0x44
    80003230:	7ac78793          	addi	a5,a5,1964 # 800479d8 <bcache+0x8268>
    80003234:	00f48863          	beq	s1,a5,80003244 <bread+0x84>
    80003238:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000323a:	40bc                	lw	a5,64(s1)
    8000323c:	cb91                	beqz	a5,80003250 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000323e:	64a4                	ld	s1,72(s1)
    80003240:	fee49de3          	bne	s1,a4,8000323a <bread+0x7a>
  panic("bget: no buffers");
    80003244:	00005517          	auipc	a0,0x5
    80003248:	35450513          	addi	a0,a0,852 # 80008598 <etext+0x598>
    8000324c:	dd8fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80003250:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003254:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003258:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000325c:	4785                	li	a5,1
    8000325e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003260:	0003c517          	auipc	a0,0x3c
    80003264:	51050513          	addi	a0,a0,1296 # 8003f770 <bcache>
    80003268:	a55fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    8000326c:	01048513          	addi	a0,s1,16
    80003270:	288010ef          	jal	800044f8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003274:	409c                	lw	a5,0(s1)
    80003276:	cb89                	beqz	a5,80003288 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003278:	8526                	mv	a0,s1
    8000327a:	70a2                	ld	ra,40(sp)
    8000327c:	7402                	ld	s0,32(sp)
    8000327e:	64e2                	ld	s1,24(sp)
    80003280:	6942                	ld	s2,16(sp)
    80003282:	69a2                	ld	s3,8(sp)
    80003284:	6145                	addi	sp,sp,48
    80003286:	8082                	ret
    virtio_disk_rw(b, 0);
    80003288:	4581                	li	a1,0
    8000328a:	8526                	mv	a0,s1
    8000328c:	4c5020ef          	jal	80005f50 <virtio_disk_rw>
    b->valid = 1;
    80003290:	4785                	li	a5,1
    80003292:	c09c                	sw	a5,0(s1)
  return b;
    80003294:	b7d5                	j	80003278 <bread+0xb8>

0000000080003296 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003296:	1101                	addi	sp,sp,-32
    80003298:	ec06                	sd	ra,24(sp)
    8000329a:	e822                	sd	s0,16(sp)
    8000329c:	e426                	sd	s1,8(sp)
    8000329e:	1000                	addi	s0,sp,32
    800032a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800032a2:	0541                	addi	a0,a0,16
    800032a4:	2d2010ef          	jal	80004576 <holdingsleep>
    800032a8:	c911                	beqz	a0,800032bc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800032aa:	4585                	li	a1,1
    800032ac:	8526                	mv	a0,s1
    800032ae:	4a3020ef          	jal	80005f50 <virtio_disk_rw>
}
    800032b2:	60e2                	ld	ra,24(sp)
    800032b4:	6442                	ld	s0,16(sp)
    800032b6:	64a2                	ld	s1,8(sp)
    800032b8:	6105                	addi	sp,sp,32
    800032ba:	8082                	ret
    panic("bwrite");
    800032bc:	00005517          	auipc	a0,0x5
    800032c0:	2f450513          	addi	a0,a0,756 # 800085b0 <etext+0x5b0>
    800032c4:	d60fd0ef          	jal	80000824 <panic>

00000000800032c8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
    800032d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800032d6:	01050913          	addi	s2,a0,16
    800032da:	854a                	mv	a0,s2
    800032dc:	29a010ef          	jal	80004576 <holdingsleep>
    800032e0:	c125                	beqz	a0,80003340 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800032e2:	854a                	mv	a0,s2
    800032e4:	25a010ef          	jal	8000453e <releasesleep>

  acquire(&bcache.lock);
    800032e8:	0003c517          	auipc	a0,0x3c
    800032ec:	48850513          	addi	a0,a0,1160 # 8003f770 <bcache>
    800032f0:	939fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    800032f4:	40bc                	lw	a5,64(s1)
    800032f6:	37fd                	addiw	a5,a5,-1
    800032f8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800032fa:	e79d                	bnez	a5,80003328 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800032fc:	68b8                	ld	a4,80(s1)
    800032fe:	64bc                	ld	a5,72(s1)
    80003300:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003302:	68b8                	ld	a4,80(s1)
    80003304:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003306:	00044797          	auipc	a5,0x44
    8000330a:	46a78793          	addi	a5,a5,1130 # 80047770 <bcache+0x8000>
    8000330e:	2b87b703          	ld	a4,696(a5)
    80003312:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003314:	00044717          	auipc	a4,0x44
    80003318:	6c470713          	addi	a4,a4,1732 # 800479d8 <bcache+0x8268>
    8000331c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000331e:	2b87b703          	ld	a4,696(a5)
    80003322:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003324:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003328:	0003c517          	auipc	a0,0x3c
    8000332c:	44850513          	addi	a0,a0,1096 # 8003f770 <bcache>
    80003330:	98dfd0ef          	jal	80000cbc <release>
}
    80003334:	60e2                	ld	ra,24(sp)
    80003336:	6442                	ld	s0,16(sp)
    80003338:	64a2                	ld	s1,8(sp)
    8000333a:	6902                	ld	s2,0(sp)
    8000333c:	6105                	addi	sp,sp,32
    8000333e:	8082                	ret
    panic("brelse");
    80003340:	00005517          	auipc	a0,0x5
    80003344:	27850513          	addi	a0,a0,632 # 800085b8 <etext+0x5b8>
    80003348:	cdcfd0ef          	jal	80000824 <panic>

000000008000334c <bpin>:

void
bpin(struct buf *b) {
    8000334c:	1101                	addi	sp,sp,-32
    8000334e:	ec06                	sd	ra,24(sp)
    80003350:	e822                	sd	s0,16(sp)
    80003352:	e426                	sd	s1,8(sp)
    80003354:	1000                	addi	s0,sp,32
    80003356:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003358:	0003c517          	auipc	a0,0x3c
    8000335c:	41850513          	addi	a0,a0,1048 # 8003f770 <bcache>
    80003360:	8c9fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    80003364:	40bc                	lw	a5,64(s1)
    80003366:	2785                	addiw	a5,a5,1
    80003368:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000336a:	0003c517          	auipc	a0,0x3c
    8000336e:	40650513          	addi	a0,a0,1030 # 8003f770 <bcache>
    80003372:	94bfd0ef          	jal	80000cbc <release>
}
    80003376:	60e2                	ld	ra,24(sp)
    80003378:	6442                	ld	s0,16(sp)
    8000337a:	64a2                	ld	s1,8(sp)
    8000337c:	6105                	addi	sp,sp,32
    8000337e:	8082                	ret

0000000080003380 <bunpin>:

void
bunpin(struct buf *b) {
    80003380:	1101                	addi	sp,sp,-32
    80003382:	ec06                	sd	ra,24(sp)
    80003384:	e822                	sd	s0,16(sp)
    80003386:	e426                	sd	s1,8(sp)
    80003388:	1000                	addi	s0,sp,32
    8000338a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000338c:	0003c517          	auipc	a0,0x3c
    80003390:	3e450513          	addi	a0,a0,996 # 8003f770 <bcache>
    80003394:	895fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80003398:	40bc                	lw	a5,64(s1)
    8000339a:	37fd                	addiw	a5,a5,-1
    8000339c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000339e:	0003c517          	auipc	a0,0x3c
    800033a2:	3d250513          	addi	a0,a0,978 # 8003f770 <bcache>
    800033a6:	917fd0ef          	jal	80000cbc <release>
}
    800033aa:	60e2                	ld	ra,24(sp)
    800033ac:	6442                	ld	s0,16(sp)
    800033ae:	64a2                	ld	s1,8(sp)
    800033b0:	6105                	addi	sp,sp,32
    800033b2:	8082                	ret

00000000800033b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800033b4:	1101                	addi	sp,sp,-32
    800033b6:	ec06                	sd	ra,24(sp)
    800033b8:	e822                	sd	s0,16(sp)
    800033ba:	e426                	sd	s1,8(sp)
    800033bc:	e04a                	sd	s2,0(sp)
    800033be:	1000                	addi	s0,sp,32
    800033c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800033c2:	00d5d79b          	srliw	a5,a1,0xd
    800033c6:	00045597          	auipc	a1,0x45
    800033ca:	a865a583          	lw	a1,-1402(a1) # 80047e4c <sb+0x1c>
    800033ce:	9dbd                	addw	a1,a1,a5
    800033d0:	df1ff0ef          	jal	800031c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800033d4:	0074f713          	andi	a4,s1,7
    800033d8:	4785                	li	a5,1
    800033da:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800033de:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800033e0:	90d9                	srli	s1,s1,0x36
    800033e2:	00950733          	add	a4,a0,s1
    800033e6:	05874703          	lbu	a4,88(a4)
    800033ea:	00e7f6b3          	and	a3,a5,a4
    800033ee:	c29d                	beqz	a3,80003414 <bfree+0x60>
    800033f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800033f2:	94aa                	add	s1,s1,a0
    800033f4:	fff7c793          	not	a5,a5
    800033f8:	8f7d                	and	a4,a4,a5
    800033fa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800033fe:	000010ef          	jal	800043fe <log_write>
  brelse(bp);
    80003402:	854a                	mv	a0,s2
    80003404:	ec5ff0ef          	jal	800032c8 <brelse>
}
    80003408:	60e2                	ld	ra,24(sp)
    8000340a:	6442                	ld	s0,16(sp)
    8000340c:	64a2                	ld	s1,8(sp)
    8000340e:	6902                	ld	s2,0(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret
    panic("freeing free block");
    80003414:	00005517          	auipc	a0,0x5
    80003418:	1ac50513          	addi	a0,a0,428 # 800085c0 <etext+0x5c0>
    8000341c:	c08fd0ef          	jal	80000824 <panic>

0000000080003420 <balloc>:
{
    80003420:	715d                	addi	sp,sp,-80
    80003422:	e486                	sd	ra,72(sp)
    80003424:	e0a2                	sd	s0,64(sp)
    80003426:	fc26                	sd	s1,56(sp)
    80003428:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000342a:	00045797          	auipc	a5,0x45
    8000342e:	a0a7a783          	lw	a5,-1526(a5) # 80047e34 <sb+0x4>
    80003432:	0e078263          	beqz	a5,80003516 <balloc+0xf6>
    80003436:	f84a                	sd	s2,48(sp)
    80003438:	f44e                	sd	s3,40(sp)
    8000343a:	f052                	sd	s4,32(sp)
    8000343c:	ec56                	sd	s5,24(sp)
    8000343e:	e85a                	sd	s6,16(sp)
    80003440:	e45e                	sd	s7,8(sp)
    80003442:	e062                	sd	s8,0(sp)
    80003444:	8baa                	mv	s7,a0
    80003446:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003448:	00045b17          	auipc	s6,0x45
    8000344c:	9e8b0b13          	addi	s6,s6,-1560 # 80047e30 <sb>
      m = 1 << (bi % 8);
    80003450:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003452:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003454:	6c09                	lui	s8,0x2
    80003456:	a09d                	j	800034bc <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003458:	97ca                	add	a5,a5,s2
    8000345a:	8e55                	or	a2,a2,a3
    8000345c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003460:	854a                	mv	a0,s2
    80003462:	79d000ef          	jal	800043fe <log_write>
        brelse(bp);
    80003466:	854a                	mv	a0,s2
    80003468:	e61ff0ef          	jal	800032c8 <brelse>
  bp = bread(dev, bno);
    8000346c:	85a6                	mv	a1,s1
    8000346e:	855e                	mv	a0,s7
    80003470:	d51ff0ef          	jal	800031c0 <bread>
    80003474:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003476:	40000613          	li	a2,1024
    8000347a:	4581                	li	a1,0
    8000347c:	05850513          	addi	a0,a0,88
    80003480:	879fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80003484:	854a                	mv	a0,s2
    80003486:	779000ef          	jal	800043fe <log_write>
  brelse(bp);
    8000348a:	854a                	mv	a0,s2
    8000348c:	e3dff0ef          	jal	800032c8 <brelse>
}
    80003490:	7942                	ld	s2,48(sp)
    80003492:	79a2                	ld	s3,40(sp)
    80003494:	7a02                	ld	s4,32(sp)
    80003496:	6ae2                	ld	s5,24(sp)
    80003498:	6b42                	ld	s6,16(sp)
    8000349a:	6ba2                	ld	s7,8(sp)
    8000349c:	6c02                	ld	s8,0(sp)
}
    8000349e:	8526                	mv	a0,s1
    800034a0:	60a6                	ld	ra,72(sp)
    800034a2:	6406                	ld	s0,64(sp)
    800034a4:	74e2                	ld	s1,56(sp)
    800034a6:	6161                	addi	sp,sp,80
    800034a8:	8082                	ret
    brelse(bp);
    800034aa:	854a                	mv	a0,s2
    800034ac:	e1dff0ef          	jal	800032c8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800034b0:	015c0abb          	addw	s5,s8,s5
    800034b4:	004b2783          	lw	a5,4(s6)
    800034b8:	04faf863          	bgeu	s5,a5,80003508 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800034bc:	40dad59b          	sraiw	a1,s5,0xd
    800034c0:	01cb2783          	lw	a5,28(s6)
    800034c4:	9dbd                	addw	a1,a1,a5
    800034c6:	855e                	mv	a0,s7
    800034c8:	cf9ff0ef          	jal	800031c0 <bread>
    800034cc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034ce:	004b2503          	lw	a0,4(s6)
    800034d2:	84d6                	mv	s1,s5
    800034d4:	4701                	li	a4,0
    800034d6:	fca4fae3          	bgeu	s1,a0,800034aa <balloc+0x8a>
      m = 1 << (bi % 8);
    800034da:	00777693          	andi	a3,a4,7
    800034de:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800034e2:	41f7579b          	sraiw	a5,a4,0x1f
    800034e6:	01d7d79b          	srliw	a5,a5,0x1d
    800034ea:	9fb9                	addw	a5,a5,a4
    800034ec:	4037d79b          	sraiw	a5,a5,0x3
    800034f0:	00f90633          	add	a2,s2,a5
    800034f4:	05864603          	lbu	a2,88(a2)
    800034f8:	00c6f5b3          	and	a1,a3,a2
    800034fc:	ddb1                	beqz	a1,80003458 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800034fe:	2705                	addiw	a4,a4,1
    80003500:	2485                	addiw	s1,s1,1
    80003502:	fd471ae3          	bne	a4,s4,800034d6 <balloc+0xb6>
    80003506:	b755                	j	800034aa <balloc+0x8a>
    80003508:	7942                	ld	s2,48(sp)
    8000350a:	79a2                	ld	s3,40(sp)
    8000350c:	7a02                	ld	s4,32(sp)
    8000350e:	6ae2                	ld	s5,24(sp)
    80003510:	6b42                	ld	s6,16(sp)
    80003512:	6ba2                	ld	s7,8(sp)
    80003514:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003516:	00005517          	auipc	a0,0x5
    8000351a:	0c250513          	addi	a0,a0,194 # 800085d8 <etext+0x5d8>
    8000351e:	fddfc0ef          	jal	800004fa <printf>
  return 0;
    80003522:	4481                	li	s1,0
    80003524:	bfad                	j	8000349e <balloc+0x7e>

0000000080003526 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003526:	7179                	addi	sp,sp,-48
    80003528:	f406                	sd	ra,40(sp)
    8000352a:	f022                	sd	s0,32(sp)
    8000352c:	ec26                	sd	s1,24(sp)
    8000352e:	e84a                	sd	s2,16(sp)
    80003530:	e44e                	sd	s3,8(sp)
    80003532:	1800                	addi	s0,sp,48
    80003534:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003536:	47ad                	li	a5,11
    80003538:	02b7e363          	bltu	a5,a1,8000355e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000353c:	02059793          	slli	a5,a1,0x20
    80003540:	01e7d593          	srli	a1,a5,0x1e
    80003544:	00b509b3          	add	s3,a0,a1
    80003548:	0509a483          	lw	s1,80(s3)
    8000354c:	e0b5                	bnez	s1,800035b0 <bmap+0x8a>
      addr = balloc(ip->dev);
    8000354e:	4108                	lw	a0,0(a0)
    80003550:	ed1ff0ef          	jal	80003420 <balloc>
    80003554:	84aa                	mv	s1,a0
      if(addr == 0)
    80003556:	cd29                	beqz	a0,800035b0 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003558:	04a9a823          	sw	a0,80(s3)
    8000355c:	a891                	j	800035b0 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000355e:	ff45879b          	addiw	a5,a1,-12
    80003562:	873e                	mv	a4,a5
    80003564:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003566:	0ff00793          	li	a5,255
    8000356a:	06e7e763          	bltu	a5,a4,800035d8 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000356e:	08052483          	lw	s1,128(a0)
    80003572:	e891                	bnez	s1,80003586 <bmap+0x60>
      addr = balloc(ip->dev);
    80003574:	4108                	lw	a0,0(a0)
    80003576:	eabff0ef          	jal	80003420 <balloc>
    8000357a:	84aa                	mv	s1,a0
      if(addr == 0)
    8000357c:	c915                	beqz	a0,800035b0 <bmap+0x8a>
    8000357e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003580:	08a92023          	sw	a0,128(s2)
    80003584:	a011                	j	80003588 <bmap+0x62>
    80003586:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003588:	85a6                	mv	a1,s1
    8000358a:	00092503          	lw	a0,0(s2)
    8000358e:	c33ff0ef          	jal	800031c0 <bread>
    80003592:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003594:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003598:	02099713          	slli	a4,s3,0x20
    8000359c:	01e75593          	srli	a1,a4,0x1e
    800035a0:	97ae                	add	a5,a5,a1
    800035a2:	89be                	mv	s3,a5
    800035a4:	4384                	lw	s1,0(a5)
    800035a6:	cc89                	beqz	s1,800035c0 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800035a8:	8552                	mv	a0,s4
    800035aa:	d1fff0ef          	jal	800032c8 <brelse>
    return addr;
    800035ae:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800035b0:	8526                	mv	a0,s1
    800035b2:	70a2                	ld	ra,40(sp)
    800035b4:	7402                	ld	s0,32(sp)
    800035b6:	64e2                	ld	s1,24(sp)
    800035b8:	6942                	ld	s2,16(sp)
    800035ba:	69a2                	ld	s3,8(sp)
    800035bc:	6145                	addi	sp,sp,48
    800035be:	8082                	ret
      addr = balloc(ip->dev);
    800035c0:	00092503          	lw	a0,0(s2)
    800035c4:	e5dff0ef          	jal	80003420 <balloc>
    800035c8:	84aa                	mv	s1,a0
      if(addr){
    800035ca:	dd79                	beqz	a0,800035a8 <bmap+0x82>
        a[bn] = addr;
    800035cc:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800035d0:	8552                	mv	a0,s4
    800035d2:	62d000ef          	jal	800043fe <log_write>
    800035d6:	bfc9                	j	800035a8 <bmap+0x82>
    800035d8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800035da:	00005517          	auipc	a0,0x5
    800035de:	01650513          	addi	a0,a0,22 # 800085f0 <etext+0x5f0>
    800035e2:	a42fd0ef          	jal	80000824 <panic>

00000000800035e6 <iget>:
{
    800035e6:	7179                	addi	sp,sp,-48
    800035e8:	f406                	sd	ra,40(sp)
    800035ea:	f022                	sd	s0,32(sp)
    800035ec:	ec26                	sd	s1,24(sp)
    800035ee:	e84a                	sd	s2,16(sp)
    800035f0:	e44e                	sd	s3,8(sp)
    800035f2:	e052                	sd	s4,0(sp)
    800035f4:	1800                	addi	s0,sp,48
    800035f6:	892a                	mv	s2,a0
    800035f8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800035fa:	00045517          	auipc	a0,0x45
    800035fe:	85650513          	addi	a0,a0,-1962 # 80047e50 <itable>
    80003602:	e26fd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80003606:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003608:	00045497          	auipc	s1,0x45
    8000360c:	86048493          	addi	s1,s1,-1952 # 80047e68 <itable+0x18>
    80003610:	00046697          	auipc	a3,0x46
    80003614:	2e868693          	addi	a3,a3,744 # 800498f8 <log>
    80003618:	a809                	j	8000362a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000361a:	e781                	bnez	a5,80003622 <iget+0x3c>
    8000361c:	00099363          	bnez	s3,80003622 <iget+0x3c>
      empty = ip;
    80003620:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003622:	08848493          	addi	s1,s1,136
    80003626:	02d48563          	beq	s1,a3,80003650 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000362a:	449c                	lw	a5,8(s1)
    8000362c:	fef057e3          	blez	a5,8000361a <iget+0x34>
    80003630:	4098                	lw	a4,0(s1)
    80003632:	ff2718e3          	bne	a4,s2,80003622 <iget+0x3c>
    80003636:	40d8                	lw	a4,4(s1)
    80003638:	ff4715e3          	bne	a4,s4,80003622 <iget+0x3c>
      ip->ref++;
    8000363c:	2785                	addiw	a5,a5,1
    8000363e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003640:	00045517          	auipc	a0,0x45
    80003644:	81050513          	addi	a0,a0,-2032 # 80047e50 <itable>
    80003648:	e74fd0ef          	jal	80000cbc <release>
      return ip;
    8000364c:	89a6                	mv	s3,s1
    8000364e:	a015                	j	80003672 <iget+0x8c>
  if(empty == 0)
    80003650:	02098a63          	beqz	s3,80003684 <iget+0x9e>
  ip->dev = dev;
    80003654:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003658:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000365c:	4785                	li	a5,1
    8000365e:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003662:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003666:	00044517          	auipc	a0,0x44
    8000366a:	7ea50513          	addi	a0,a0,2026 # 80047e50 <itable>
    8000366e:	e4efd0ef          	jal	80000cbc <release>
}
    80003672:	854e                	mv	a0,s3
    80003674:	70a2                	ld	ra,40(sp)
    80003676:	7402                	ld	s0,32(sp)
    80003678:	64e2                	ld	s1,24(sp)
    8000367a:	6942                	ld	s2,16(sp)
    8000367c:	69a2                	ld	s3,8(sp)
    8000367e:	6a02                	ld	s4,0(sp)
    80003680:	6145                	addi	sp,sp,48
    80003682:	8082                	ret
    panic("iget: no inodes");
    80003684:	00005517          	auipc	a0,0x5
    80003688:	f8450513          	addi	a0,a0,-124 # 80008608 <etext+0x608>
    8000368c:	998fd0ef          	jal	80000824 <panic>

0000000080003690 <iinit>:
{
    80003690:	7179                	addi	sp,sp,-48
    80003692:	f406                	sd	ra,40(sp)
    80003694:	f022                	sd	s0,32(sp)
    80003696:	ec26                	sd	s1,24(sp)
    80003698:	e84a                	sd	s2,16(sp)
    8000369a:	e44e                	sd	s3,8(sp)
    8000369c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000369e:	00005597          	auipc	a1,0x5
    800036a2:	f7a58593          	addi	a1,a1,-134 # 80008618 <etext+0x618>
    800036a6:	00044517          	auipc	a0,0x44
    800036aa:	7aa50513          	addi	a0,a0,1962 # 80047e50 <itable>
    800036ae:	cf0fd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    800036b2:	00044497          	auipc	s1,0x44
    800036b6:	7c648493          	addi	s1,s1,1990 # 80047e78 <itable+0x28>
    800036ba:	00046997          	auipc	s3,0x46
    800036be:	24e98993          	addi	s3,s3,590 # 80049908 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800036c2:	00005917          	auipc	s2,0x5
    800036c6:	f5e90913          	addi	s2,s2,-162 # 80008620 <etext+0x620>
    800036ca:	85ca                	mv	a1,s2
    800036cc:	8526                	mv	a0,s1
    800036ce:	5f5000ef          	jal	800044c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036d2:	08848493          	addi	s1,s1,136
    800036d6:	ff349ae3          	bne	s1,s3,800036ca <iinit+0x3a>
}
    800036da:	70a2                	ld	ra,40(sp)
    800036dc:	7402                	ld	s0,32(sp)
    800036de:	64e2                	ld	s1,24(sp)
    800036e0:	6942                	ld	s2,16(sp)
    800036e2:	69a2                	ld	s3,8(sp)
    800036e4:	6145                	addi	sp,sp,48
    800036e6:	8082                	ret

00000000800036e8 <ialloc>:
{
    800036e8:	7139                	addi	sp,sp,-64
    800036ea:	fc06                	sd	ra,56(sp)
    800036ec:	f822                	sd	s0,48(sp)
    800036ee:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800036f0:	00044717          	auipc	a4,0x44
    800036f4:	74c72703          	lw	a4,1868(a4) # 80047e3c <sb+0xc>
    800036f8:	4785                	li	a5,1
    800036fa:	06e7f063          	bgeu	a5,a4,8000375a <ialloc+0x72>
    800036fe:	f426                	sd	s1,40(sp)
    80003700:	f04a                	sd	s2,32(sp)
    80003702:	ec4e                	sd	s3,24(sp)
    80003704:	e852                	sd	s4,16(sp)
    80003706:	e456                	sd	s5,8(sp)
    80003708:	e05a                	sd	s6,0(sp)
    8000370a:	8aaa                	mv	s5,a0
    8000370c:	8b2e                	mv	s6,a1
    8000370e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003710:	00044a17          	auipc	s4,0x44
    80003714:	720a0a13          	addi	s4,s4,1824 # 80047e30 <sb>
    80003718:	00495593          	srli	a1,s2,0x4
    8000371c:	018a2783          	lw	a5,24(s4)
    80003720:	9dbd                	addw	a1,a1,a5
    80003722:	8556                	mv	a0,s5
    80003724:	a9dff0ef          	jal	800031c0 <bread>
    80003728:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000372a:	05850993          	addi	s3,a0,88
    8000372e:	00f97793          	andi	a5,s2,15
    80003732:	079a                	slli	a5,a5,0x6
    80003734:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003736:	00099783          	lh	a5,0(s3)
    8000373a:	cb9d                	beqz	a5,80003770 <ialloc+0x88>
    brelse(bp);
    8000373c:	b8dff0ef          	jal	800032c8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003740:	0905                	addi	s2,s2,1
    80003742:	00ca2703          	lw	a4,12(s4)
    80003746:	0009079b          	sext.w	a5,s2
    8000374a:	fce7e7e3          	bltu	a5,a4,80003718 <ialloc+0x30>
    8000374e:	74a2                	ld	s1,40(sp)
    80003750:	7902                	ld	s2,32(sp)
    80003752:	69e2                	ld	s3,24(sp)
    80003754:	6a42                	ld	s4,16(sp)
    80003756:	6aa2                	ld	s5,8(sp)
    80003758:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000375a:	00005517          	auipc	a0,0x5
    8000375e:	ece50513          	addi	a0,a0,-306 # 80008628 <etext+0x628>
    80003762:	d99fc0ef          	jal	800004fa <printf>
  return 0;
    80003766:	4501                	li	a0,0
}
    80003768:	70e2                	ld	ra,56(sp)
    8000376a:	7442                	ld	s0,48(sp)
    8000376c:	6121                	addi	sp,sp,64
    8000376e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003770:	04000613          	li	a2,64
    80003774:	4581                	li	a1,0
    80003776:	854e                	mv	a0,s3
    80003778:	d80fd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    8000377c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003780:	8526                	mv	a0,s1
    80003782:	47d000ef          	jal	800043fe <log_write>
      brelse(bp);
    80003786:	8526                	mv	a0,s1
    80003788:	b41ff0ef          	jal	800032c8 <brelse>
      return iget(dev, inum);
    8000378c:	0009059b          	sext.w	a1,s2
    80003790:	8556                	mv	a0,s5
    80003792:	e55ff0ef          	jal	800035e6 <iget>
    80003796:	74a2                	ld	s1,40(sp)
    80003798:	7902                	ld	s2,32(sp)
    8000379a:	69e2                	ld	s3,24(sp)
    8000379c:	6a42                	ld	s4,16(sp)
    8000379e:	6aa2                	ld	s5,8(sp)
    800037a0:	6b02                	ld	s6,0(sp)
    800037a2:	b7d9                	j	80003768 <ialloc+0x80>

00000000800037a4 <iupdate>:
{
    800037a4:	1101                	addi	sp,sp,-32
    800037a6:	ec06                	sd	ra,24(sp)
    800037a8:	e822                	sd	s0,16(sp)
    800037aa:	e426                	sd	s1,8(sp)
    800037ac:	e04a                	sd	s2,0(sp)
    800037ae:	1000                	addi	s0,sp,32
    800037b0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037b2:	415c                	lw	a5,4(a0)
    800037b4:	0047d79b          	srliw	a5,a5,0x4
    800037b8:	00044597          	auipc	a1,0x44
    800037bc:	6905a583          	lw	a1,1680(a1) # 80047e48 <sb+0x18>
    800037c0:	9dbd                	addw	a1,a1,a5
    800037c2:	4108                	lw	a0,0(a0)
    800037c4:	9fdff0ef          	jal	800031c0 <bread>
    800037c8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037ca:	05850793          	addi	a5,a0,88
    800037ce:	40d8                	lw	a4,4(s1)
    800037d0:	8b3d                	andi	a4,a4,15
    800037d2:	071a                	slli	a4,a4,0x6
    800037d4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800037d6:	04449703          	lh	a4,68(s1)
    800037da:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800037de:	04649703          	lh	a4,70(s1)
    800037e2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800037e6:	04849703          	lh	a4,72(s1)
    800037ea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800037ee:	04a49703          	lh	a4,74(s1)
    800037f2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800037f6:	44f8                	lw	a4,76(s1)
    800037f8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800037fa:	03400613          	li	a2,52
    800037fe:	05048593          	addi	a1,s1,80
    80003802:	00c78513          	addi	a0,a5,12
    80003806:	d52fd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    8000380a:	854a                	mv	a0,s2
    8000380c:	3f3000ef          	jal	800043fe <log_write>
  brelse(bp);
    80003810:	854a                	mv	a0,s2
    80003812:	ab7ff0ef          	jal	800032c8 <brelse>
}
    80003816:	60e2                	ld	ra,24(sp)
    80003818:	6442                	ld	s0,16(sp)
    8000381a:	64a2                	ld	s1,8(sp)
    8000381c:	6902                	ld	s2,0(sp)
    8000381e:	6105                	addi	sp,sp,32
    80003820:	8082                	ret

0000000080003822 <idup>:
{
    80003822:	1101                	addi	sp,sp,-32
    80003824:	ec06                	sd	ra,24(sp)
    80003826:	e822                	sd	s0,16(sp)
    80003828:	e426                	sd	s1,8(sp)
    8000382a:	1000                	addi	s0,sp,32
    8000382c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000382e:	00044517          	auipc	a0,0x44
    80003832:	62250513          	addi	a0,a0,1570 # 80047e50 <itable>
    80003836:	bf2fd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    8000383a:	449c                	lw	a5,8(s1)
    8000383c:	2785                	addiw	a5,a5,1
    8000383e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003840:	00044517          	auipc	a0,0x44
    80003844:	61050513          	addi	a0,a0,1552 # 80047e50 <itable>
    80003848:	c74fd0ef          	jal	80000cbc <release>
}
    8000384c:	8526                	mv	a0,s1
    8000384e:	60e2                	ld	ra,24(sp)
    80003850:	6442                	ld	s0,16(sp)
    80003852:	64a2                	ld	s1,8(sp)
    80003854:	6105                	addi	sp,sp,32
    80003856:	8082                	ret

0000000080003858 <ilock>:
{
    80003858:	1101                	addi	sp,sp,-32
    8000385a:	ec06                	sd	ra,24(sp)
    8000385c:	e822                	sd	s0,16(sp)
    8000385e:	e426                	sd	s1,8(sp)
    80003860:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003862:	cd19                	beqz	a0,80003880 <ilock+0x28>
    80003864:	84aa                	mv	s1,a0
    80003866:	451c                	lw	a5,8(a0)
    80003868:	00f05c63          	blez	a5,80003880 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000386c:	0541                	addi	a0,a0,16
    8000386e:	48b000ef          	jal	800044f8 <acquiresleep>
  if(ip->valid == 0){
    80003872:	40bc                	lw	a5,64(s1)
    80003874:	cf89                	beqz	a5,8000388e <ilock+0x36>
}
    80003876:	60e2                	ld	ra,24(sp)
    80003878:	6442                	ld	s0,16(sp)
    8000387a:	64a2                	ld	s1,8(sp)
    8000387c:	6105                	addi	sp,sp,32
    8000387e:	8082                	ret
    80003880:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003882:	00005517          	auipc	a0,0x5
    80003886:	dbe50513          	addi	a0,a0,-578 # 80008640 <etext+0x640>
    8000388a:	f9bfc0ef          	jal	80000824 <panic>
    8000388e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003890:	40dc                	lw	a5,4(s1)
    80003892:	0047d79b          	srliw	a5,a5,0x4
    80003896:	00044597          	auipc	a1,0x44
    8000389a:	5b25a583          	lw	a1,1458(a1) # 80047e48 <sb+0x18>
    8000389e:	9dbd                	addw	a1,a1,a5
    800038a0:	4088                	lw	a0,0(s1)
    800038a2:	91fff0ef          	jal	800031c0 <bread>
    800038a6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038a8:	05850593          	addi	a1,a0,88
    800038ac:	40dc                	lw	a5,4(s1)
    800038ae:	8bbd                	andi	a5,a5,15
    800038b0:	079a                	slli	a5,a5,0x6
    800038b2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800038b4:	00059783          	lh	a5,0(a1)
    800038b8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800038bc:	00259783          	lh	a5,2(a1)
    800038c0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800038c4:	00459783          	lh	a5,4(a1)
    800038c8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800038cc:	00659783          	lh	a5,6(a1)
    800038d0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800038d4:	459c                	lw	a5,8(a1)
    800038d6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800038d8:	03400613          	li	a2,52
    800038dc:	05b1                	addi	a1,a1,12
    800038de:	05048513          	addi	a0,s1,80
    800038e2:	c76fd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    800038e6:	854a                	mv	a0,s2
    800038e8:	9e1ff0ef          	jal	800032c8 <brelse>
    ip->valid = 1;
    800038ec:	4785                	li	a5,1
    800038ee:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800038f0:	04449783          	lh	a5,68(s1)
    800038f4:	c399                	beqz	a5,800038fa <ilock+0xa2>
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	bfbd                	j	80003876 <ilock+0x1e>
      panic("ilock: no type");
    800038fa:	00005517          	auipc	a0,0x5
    800038fe:	d4e50513          	addi	a0,a0,-690 # 80008648 <etext+0x648>
    80003902:	f23fc0ef          	jal	80000824 <panic>

0000000080003906 <iunlock>:
{
    80003906:	1101                	addi	sp,sp,-32
    80003908:	ec06                	sd	ra,24(sp)
    8000390a:	e822                	sd	s0,16(sp)
    8000390c:	e426                	sd	s1,8(sp)
    8000390e:	e04a                	sd	s2,0(sp)
    80003910:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003912:	c505                	beqz	a0,8000393a <iunlock+0x34>
    80003914:	84aa                	mv	s1,a0
    80003916:	01050913          	addi	s2,a0,16
    8000391a:	854a                	mv	a0,s2
    8000391c:	45b000ef          	jal	80004576 <holdingsleep>
    80003920:	cd09                	beqz	a0,8000393a <iunlock+0x34>
    80003922:	449c                	lw	a5,8(s1)
    80003924:	00f05b63          	blez	a5,8000393a <iunlock+0x34>
  releasesleep(&ip->lock);
    80003928:	854a                	mv	a0,s2
    8000392a:	415000ef          	jal	8000453e <releasesleep>
}
    8000392e:	60e2                	ld	ra,24(sp)
    80003930:	6442                	ld	s0,16(sp)
    80003932:	64a2                	ld	s1,8(sp)
    80003934:	6902                	ld	s2,0(sp)
    80003936:	6105                	addi	sp,sp,32
    80003938:	8082                	ret
    panic("iunlock");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	d1e50513          	addi	a0,a0,-738 # 80008658 <etext+0x658>
    80003942:	ee3fc0ef          	jal	80000824 <panic>

0000000080003946 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003946:	7179                	addi	sp,sp,-48
    80003948:	f406                	sd	ra,40(sp)
    8000394a:	f022                	sd	s0,32(sp)
    8000394c:	ec26                	sd	s1,24(sp)
    8000394e:	e84a                	sd	s2,16(sp)
    80003950:	e44e                	sd	s3,8(sp)
    80003952:	1800                	addi	s0,sp,48
    80003954:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003956:	05050493          	addi	s1,a0,80
    8000395a:	08050913          	addi	s2,a0,128
    8000395e:	a021                	j	80003966 <itrunc+0x20>
    80003960:	0491                	addi	s1,s1,4
    80003962:	01248b63          	beq	s1,s2,80003978 <itrunc+0x32>
    if(ip->addrs[i]){
    80003966:	408c                	lw	a1,0(s1)
    80003968:	dde5                	beqz	a1,80003960 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000396a:	0009a503          	lw	a0,0(s3)
    8000396e:	a47ff0ef          	jal	800033b4 <bfree>
      ip->addrs[i] = 0;
    80003972:	0004a023          	sw	zero,0(s1)
    80003976:	b7ed                	j	80003960 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003978:	0809a583          	lw	a1,128(s3)
    8000397c:	ed89                	bnez	a1,80003996 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000397e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003982:	854e                	mv	a0,s3
    80003984:	e21ff0ef          	jal	800037a4 <iupdate>
}
    80003988:	70a2                	ld	ra,40(sp)
    8000398a:	7402                	ld	s0,32(sp)
    8000398c:	64e2                	ld	s1,24(sp)
    8000398e:	6942                	ld	s2,16(sp)
    80003990:	69a2                	ld	s3,8(sp)
    80003992:	6145                	addi	sp,sp,48
    80003994:	8082                	ret
    80003996:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003998:	0009a503          	lw	a0,0(s3)
    8000399c:	825ff0ef          	jal	800031c0 <bread>
    800039a0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800039a2:	05850493          	addi	s1,a0,88
    800039a6:	45850913          	addi	s2,a0,1112
    800039aa:	a021                	j	800039b2 <itrunc+0x6c>
    800039ac:	0491                	addi	s1,s1,4
    800039ae:	01248963          	beq	s1,s2,800039c0 <itrunc+0x7a>
      if(a[j])
    800039b2:	408c                	lw	a1,0(s1)
    800039b4:	dde5                	beqz	a1,800039ac <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800039b6:	0009a503          	lw	a0,0(s3)
    800039ba:	9fbff0ef          	jal	800033b4 <bfree>
    800039be:	b7fd                	j	800039ac <itrunc+0x66>
    brelse(bp);
    800039c0:	8552                	mv	a0,s4
    800039c2:	907ff0ef          	jal	800032c8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800039c6:	0809a583          	lw	a1,128(s3)
    800039ca:	0009a503          	lw	a0,0(s3)
    800039ce:	9e7ff0ef          	jal	800033b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    800039d2:	0809a023          	sw	zero,128(s3)
    800039d6:	6a02                	ld	s4,0(sp)
    800039d8:	b75d                	j	8000397e <itrunc+0x38>

00000000800039da <iput>:
{
    800039da:	1101                	addi	sp,sp,-32
    800039dc:	ec06                	sd	ra,24(sp)
    800039de:	e822                	sd	s0,16(sp)
    800039e0:	e426                	sd	s1,8(sp)
    800039e2:	1000                	addi	s0,sp,32
    800039e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800039e6:	00044517          	auipc	a0,0x44
    800039ea:	46a50513          	addi	a0,a0,1130 # 80047e50 <itable>
    800039ee:	a3afd0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039f2:	4498                	lw	a4,8(s1)
    800039f4:	4785                	li	a5,1
    800039f6:	02f70063          	beq	a4,a5,80003a16 <iput+0x3c>
  ip->ref--;
    800039fa:	449c                	lw	a5,8(s1)
    800039fc:	37fd                	addiw	a5,a5,-1
    800039fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a00:	00044517          	auipc	a0,0x44
    80003a04:	45050513          	addi	a0,a0,1104 # 80047e50 <itable>
    80003a08:	ab4fd0ef          	jal	80000cbc <release>
}
    80003a0c:	60e2                	ld	ra,24(sp)
    80003a0e:	6442                	ld	s0,16(sp)
    80003a10:	64a2                	ld	s1,8(sp)
    80003a12:	6105                	addi	sp,sp,32
    80003a14:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a16:	40bc                	lw	a5,64(s1)
    80003a18:	d3ed                	beqz	a5,800039fa <iput+0x20>
    80003a1a:	04a49783          	lh	a5,74(s1)
    80003a1e:	fff1                	bnez	a5,800039fa <iput+0x20>
    80003a20:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003a22:	01048793          	addi	a5,s1,16
    80003a26:	893e                	mv	s2,a5
    80003a28:	853e                	mv	a0,a5
    80003a2a:	2cf000ef          	jal	800044f8 <acquiresleep>
    release(&itable.lock);
    80003a2e:	00044517          	auipc	a0,0x44
    80003a32:	42250513          	addi	a0,a0,1058 # 80047e50 <itable>
    80003a36:	a86fd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	f0bff0ef          	jal	80003946 <itrunc>
    ip->type = 0;
    80003a40:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a44:	8526                	mv	a0,s1
    80003a46:	d5fff0ef          	jal	800037a4 <iupdate>
    ip->valid = 0;
    80003a4a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a4e:	854a                	mv	a0,s2
    80003a50:	2ef000ef          	jal	8000453e <releasesleep>
    acquire(&itable.lock);
    80003a54:	00044517          	auipc	a0,0x44
    80003a58:	3fc50513          	addi	a0,a0,1020 # 80047e50 <itable>
    80003a5c:	9ccfd0ef          	jal	80000c28 <acquire>
    80003a60:	6902                	ld	s2,0(sp)
    80003a62:	bf61                	j	800039fa <iput+0x20>

0000000080003a64 <iunlockput>:
{
    80003a64:	1101                	addi	sp,sp,-32
    80003a66:	ec06                	sd	ra,24(sp)
    80003a68:	e822                	sd	s0,16(sp)
    80003a6a:	e426                	sd	s1,8(sp)
    80003a6c:	1000                	addi	s0,sp,32
    80003a6e:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a70:	e97ff0ef          	jal	80003906 <iunlock>
  iput(ip);
    80003a74:	8526                	mv	a0,s1
    80003a76:	f65ff0ef          	jal	800039da <iput>
}
    80003a7a:	60e2                	ld	ra,24(sp)
    80003a7c:	6442                	ld	s0,16(sp)
    80003a7e:	64a2                	ld	s1,8(sp)
    80003a80:	6105                	addi	sp,sp,32
    80003a82:	8082                	ret

0000000080003a84 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003a84:	00044717          	auipc	a4,0x44
    80003a88:	3b872703          	lw	a4,952(a4) # 80047e3c <sb+0xc>
    80003a8c:	4785                	li	a5,1
    80003a8e:	0ae7fe63          	bgeu	a5,a4,80003b4a <ireclaim+0xc6>
{
    80003a92:	7139                	addi	sp,sp,-64
    80003a94:	fc06                	sd	ra,56(sp)
    80003a96:	f822                	sd	s0,48(sp)
    80003a98:	f426                	sd	s1,40(sp)
    80003a9a:	f04a                	sd	s2,32(sp)
    80003a9c:	ec4e                	sd	s3,24(sp)
    80003a9e:	e852                	sd	s4,16(sp)
    80003aa0:	e456                	sd	s5,8(sp)
    80003aa2:	e05a                	sd	s6,0(sp)
    80003aa4:	0080                	addi	s0,sp,64
    80003aa6:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003aa8:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003aaa:	00044a17          	auipc	s4,0x44
    80003aae:	386a0a13          	addi	s4,s4,902 # 80047e30 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003ab2:	00005b17          	auipc	s6,0x5
    80003ab6:	baeb0b13          	addi	s6,s6,-1106 # 80008660 <etext+0x660>
    80003aba:	a099                	j	80003b00 <ireclaim+0x7c>
    80003abc:	85ce                	mv	a1,s3
    80003abe:	855a                	mv	a0,s6
    80003ac0:	a3bfc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003ac4:	85ce                	mv	a1,s3
    80003ac6:	8556                	mv	a0,s5
    80003ac8:	b1fff0ef          	jal	800035e6 <iget>
    80003acc:	89aa                	mv	s3,a0
    brelse(bp);
    80003ace:	854a                	mv	a0,s2
    80003ad0:	ff8ff0ef          	jal	800032c8 <brelse>
    if (ip) {
    80003ad4:	00098f63          	beqz	s3,80003af2 <ireclaim+0x6e>
      begin_op();
    80003ad8:	78c000ef          	jal	80004264 <begin_op>
      ilock(ip);
    80003adc:	854e                	mv	a0,s3
    80003ade:	d7bff0ef          	jal	80003858 <ilock>
      iunlock(ip);
    80003ae2:	854e                	mv	a0,s3
    80003ae4:	e23ff0ef          	jal	80003906 <iunlock>
      iput(ip);
    80003ae8:	854e                	mv	a0,s3
    80003aea:	ef1ff0ef          	jal	800039da <iput>
      end_op();
    80003aee:	7e6000ef          	jal	800042d4 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003af2:	0485                	addi	s1,s1,1
    80003af4:	00ca2703          	lw	a4,12(s4)
    80003af8:	0004879b          	sext.w	a5,s1
    80003afc:	02e7fd63          	bgeu	a5,a4,80003b36 <ireclaim+0xb2>
    80003b00:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003b04:	0044d593          	srli	a1,s1,0x4
    80003b08:	018a2783          	lw	a5,24(s4)
    80003b0c:	9dbd                	addw	a1,a1,a5
    80003b0e:	8556                	mv	a0,s5
    80003b10:	eb0ff0ef          	jal	800031c0 <bread>
    80003b14:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003b16:	05850793          	addi	a5,a0,88
    80003b1a:	00f9f713          	andi	a4,s3,15
    80003b1e:	071a                	slli	a4,a4,0x6
    80003b20:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003b22:	00079703          	lh	a4,0(a5)
    80003b26:	c701                	beqz	a4,80003b2e <ireclaim+0xaa>
    80003b28:	00679783          	lh	a5,6(a5)
    80003b2c:	dbc1                	beqz	a5,80003abc <ireclaim+0x38>
    brelse(bp);
    80003b2e:	854a                	mv	a0,s2
    80003b30:	f98ff0ef          	jal	800032c8 <brelse>
    if (ip) {
    80003b34:	bf7d                	j	80003af2 <ireclaim+0x6e>
}
    80003b36:	70e2                	ld	ra,56(sp)
    80003b38:	7442                	ld	s0,48(sp)
    80003b3a:	74a2                	ld	s1,40(sp)
    80003b3c:	7902                	ld	s2,32(sp)
    80003b3e:	69e2                	ld	s3,24(sp)
    80003b40:	6a42                	ld	s4,16(sp)
    80003b42:	6aa2                	ld	s5,8(sp)
    80003b44:	6b02                	ld	s6,0(sp)
    80003b46:	6121                	addi	sp,sp,64
    80003b48:	8082                	ret
    80003b4a:	8082                	ret

0000000080003b4c <fsinit>:
fsinit(int dev) {
    80003b4c:	1101                	addi	sp,sp,-32
    80003b4e:	ec06                	sd	ra,24(sp)
    80003b50:	e822                	sd	s0,16(sp)
    80003b52:	e426                	sd	s1,8(sp)
    80003b54:	e04a                	sd	s2,0(sp)
    80003b56:	1000                	addi	s0,sp,32
    80003b58:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003b5a:	4585                	li	a1,1
    80003b5c:	e64ff0ef          	jal	800031c0 <bread>
    80003b60:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003b62:	02000613          	li	a2,32
    80003b66:	05850593          	addi	a1,a0,88
    80003b6a:	00044517          	auipc	a0,0x44
    80003b6e:	2c650513          	addi	a0,a0,710 # 80047e30 <sb>
    80003b72:	9e6fd0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80003b76:	8526                	mv	a0,s1
    80003b78:	f50ff0ef          	jal	800032c8 <brelse>
  if(sb.magic != FSMAGIC)
    80003b7c:	00044717          	auipc	a4,0x44
    80003b80:	2b472703          	lw	a4,692(a4) # 80047e30 <sb>
    80003b84:	102037b7          	lui	a5,0x10203
    80003b88:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b8c:	02f71263          	bne	a4,a5,80003bb0 <fsinit+0x64>
  initlog(dev, &sb);
    80003b90:	00044597          	auipc	a1,0x44
    80003b94:	2a058593          	addi	a1,a1,672 # 80047e30 <sb>
    80003b98:	854a                	mv	a0,s2
    80003b9a:	648000ef          	jal	800041e2 <initlog>
  ireclaim(dev);
    80003b9e:	854a                	mv	a0,s2
    80003ba0:	ee5ff0ef          	jal	80003a84 <ireclaim>
}
    80003ba4:	60e2                	ld	ra,24(sp)
    80003ba6:	6442                	ld	s0,16(sp)
    80003ba8:	64a2                	ld	s1,8(sp)
    80003baa:	6902                	ld	s2,0(sp)
    80003bac:	6105                	addi	sp,sp,32
    80003bae:	8082                	ret
    panic("invalid file system");
    80003bb0:	00005517          	auipc	a0,0x5
    80003bb4:	ad050513          	addi	a0,a0,-1328 # 80008680 <etext+0x680>
    80003bb8:	c6dfc0ef          	jal	80000824 <panic>

0000000080003bbc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003bbc:	1141                	addi	sp,sp,-16
    80003bbe:	e406                	sd	ra,8(sp)
    80003bc0:	e022                	sd	s0,0(sp)
    80003bc2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003bc4:	411c                	lw	a5,0(a0)
    80003bc6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003bc8:	415c                	lw	a5,4(a0)
    80003bca:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003bcc:	04451783          	lh	a5,68(a0)
    80003bd0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003bd4:	04a51783          	lh	a5,74(a0)
    80003bd8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003bdc:	04c56783          	lwu	a5,76(a0)
    80003be0:	e99c                	sd	a5,16(a1)
}
    80003be2:	60a2                	ld	ra,8(sp)
    80003be4:	6402                	ld	s0,0(sp)
    80003be6:	0141                	addi	sp,sp,16
    80003be8:	8082                	ret

0000000080003bea <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003bea:	457c                	lw	a5,76(a0)
    80003bec:	0ed7e663          	bltu	a5,a3,80003cd8 <readi+0xee>
{
    80003bf0:	7159                	addi	sp,sp,-112
    80003bf2:	f486                	sd	ra,104(sp)
    80003bf4:	f0a2                	sd	s0,96(sp)
    80003bf6:	eca6                	sd	s1,88(sp)
    80003bf8:	e0d2                	sd	s4,64(sp)
    80003bfa:	fc56                	sd	s5,56(sp)
    80003bfc:	f85a                	sd	s6,48(sp)
    80003bfe:	f45e                	sd	s7,40(sp)
    80003c00:	1880                	addi	s0,sp,112
    80003c02:	8b2a                	mv	s6,a0
    80003c04:	8bae                	mv	s7,a1
    80003c06:	8a32                	mv	s4,a2
    80003c08:	84b6                	mv	s1,a3
    80003c0a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003c0c:	9f35                	addw	a4,a4,a3
    return 0;
    80003c0e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003c10:	0ad76b63          	bltu	a4,a3,80003cc6 <readi+0xdc>
    80003c14:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003c16:	00e7f463          	bgeu	a5,a4,80003c1e <readi+0x34>
    n = ip->size - off;
    80003c1a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c1e:	080a8b63          	beqz	s5,80003cb4 <readi+0xca>
    80003c22:	e8ca                	sd	s2,80(sp)
    80003c24:	f062                	sd	s8,32(sp)
    80003c26:	ec66                	sd	s9,24(sp)
    80003c28:	e86a                	sd	s10,16(sp)
    80003c2a:	e46e                	sd	s11,8(sp)
    80003c2c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c2e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003c32:	5c7d                	li	s8,-1
    80003c34:	a80d                	j	80003c66 <readi+0x7c>
    80003c36:	020d1d93          	slli	s11,s10,0x20
    80003c3a:	020ddd93          	srli	s11,s11,0x20
    80003c3e:	05890613          	addi	a2,s2,88
    80003c42:	86ee                	mv	a3,s11
    80003c44:	963e                	add	a2,a2,a5
    80003c46:	85d2                	mv	a1,s4
    80003c48:	855e                	mv	a0,s7
    80003c4a:	b0dfe0ef          	jal	80002756 <either_copyout>
    80003c4e:	05850363          	beq	a0,s8,80003c94 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003c52:	854a                	mv	a0,s2
    80003c54:	e74ff0ef          	jal	800032c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003c58:	013d09bb          	addw	s3,s10,s3
    80003c5c:	009d04bb          	addw	s1,s10,s1
    80003c60:	9a6e                	add	s4,s4,s11
    80003c62:	0559f363          	bgeu	s3,s5,80003ca8 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003c66:	00a4d59b          	srliw	a1,s1,0xa
    80003c6a:	855a                	mv	a0,s6
    80003c6c:	8bbff0ef          	jal	80003526 <bmap>
    80003c70:	85aa                	mv	a1,a0
    if(addr == 0)
    80003c72:	c139                	beqz	a0,80003cb8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003c74:	000b2503          	lw	a0,0(s6)
    80003c78:	d48ff0ef          	jal	800031c0 <bread>
    80003c7c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c7e:	3ff4f793          	andi	a5,s1,1023
    80003c82:	40fc873b          	subw	a4,s9,a5
    80003c86:	413a86bb          	subw	a3,s5,s3
    80003c8a:	8d3a                	mv	s10,a4
    80003c8c:	fae6f5e3          	bgeu	a3,a4,80003c36 <readi+0x4c>
    80003c90:	8d36                	mv	s10,a3
    80003c92:	b755                	j	80003c36 <readi+0x4c>
      brelse(bp);
    80003c94:	854a                	mv	a0,s2
    80003c96:	e32ff0ef          	jal	800032c8 <brelse>
      tot = -1;
    80003c9a:	59fd                	li	s3,-1
      break;
    80003c9c:	6946                	ld	s2,80(sp)
    80003c9e:	7c02                	ld	s8,32(sp)
    80003ca0:	6ce2                	ld	s9,24(sp)
    80003ca2:	6d42                	ld	s10,16(sp)
    80003ca4:	6da2                	ld	s11,8(sp)
    80003ca6:	a831                	j	80003cc2 <readi+0xd8>
    80003ca8:	6946                	ld	s2,80(sp)
    80003caa:	7c02                	ld	s8,32(sp)
    80003cac:	6ce2                	ld	s9,24(sp)
    80003cae:	6d42                	ld	s10,16(sp)
    80003cb0:	6da2                	ld	s11,8(sp)
    80003cb2:	a801                	j	80003cc2 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003cb4:	89d6                	mv	s3,s5
    80003cb6:	a031                	j	80003cc2 <readi+0xd8>
    80003cb8:	6946                	ld	s2,80(sp)
    80003cba:	7c02                	ld	s8,32(sp)
    80003cbc:	6ce2                	ld	s9,24(sp)
    80003cbe:	6d42                	ld	s10,16(sp)
    80003cc0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003cc2:	854e                	mv	a0,s3
    80003cc4:	69a6                	ld	s3,72(sp)
}
    80003cc6:	70a6                	ld	ra,104(sp)
    80003cc8:	7406                	ld	s0,96(sp)
    80003cca:	64e6                	ld	s1,88(sp)
    80003ccc:	6a06                	ld	s4,64(sp)
    80003cce:	7ae2                	ld	s5,56(sp)
    80003cd0:	7b42                	ld	s6,48(sp)
    80003cd2:	7ba2                	ld	s7,40(sp)
    80003cd4:	6165                	addi	sp,sp,112
    80003cd6:	8082                	ret
    return 0;
    80003cd8:	4501                	li	a0,0
}
    80003cda:	8082                	ret

0000000080003cdc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003cdc:	457c                	lw	a5,76(a0)
    80003cde:	0ed7eb63          	bltu	a5,a3,80003dd4 <writei+0xf8>
{
    80003ce2:	7159                	addi	sp,sp,-112
    80003ce4:	f486                	sd	ra,104(sp)
    80003ce6:	f0a2                	sd	s0,96(sp)
    80003ce8:	e8ca                	sd	s2,80(sp)
    80003cea:	e0d2                	sd	s4,64(sp)
    80003cec:	fc56                	sd	s5,56(sp)
    80003cee:	f85a                	sd	s6,48(sp)
    80003cf0:	f45e                	sd	s7,40(sp)
    80003cf2:	1880                	addi	s0,sp,112
    80003cf4:	8aaa                	mv	s5,a0
    80003cf6:	8bae                	mv	s7,a1
    80003cf8:	8a32                	mv	s4,a2
    80003cfa:	8936                	mv	s2,a3
    80003cfc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003cfe:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003d02:	00043737          	lui	a4,0x43
    80003d06:	0cf76963          	bltu	a4,a5,80003dd8 <writei+0xfc>
    80003d0a:	0cd7e763          	bltu	a5,a3,80003dd8 <writei+0xfc>
    80003d0e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d10:	0a0b0a63          	beqz	s6,80003dc4 <writei+0xe8>
    80003d14:	eca6                	sd	s1,88(sp)
    80003d16:	f062                	sd	s8,32(sp)
    80003d18:	ec66                	sd	s9,24(sp)
    80003d1a:	e86a                	sd	s10,16(sp)
    80003d1c:	e46e                	sd	s11,8(sp)
    80003d1e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d20:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003d24:	5c7d                	li	s8,-1
    80003d26:	a825                	j	80003d5e <writei+0x82>
    80003d28:	020d1d93          	slli	s11,s10,0x20
    80003d2c:	020ddd93          	srli	s11,s11,0x20
    80003d30:	05848513          	addi	a0,s1,88
    80003d34:	86ee                	mv	a3,s11
    80003d36:	8652                	mv	a2,s4
    80003d38:	85de                	mv	a1,s7
    80003d3a:	953e                	add	a0,a0,a5
    80003d3c:	a65fe0ef          	jal	800027a0 <either_copyin>
    80003d40:	05850663          	beq	a0,s8,80003d8c <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003d44:	8526                	mv	a0,s1
    80003d46:	6b8000ef          	jal	800043fe <log_write>
    brelse(bp);
    80003d4a:	8526                	mv	a0,s1
    80003d4c:	d7cff0ef          	jal	800032c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d50:	013d09bb          	addw	s3,s10,s3
    80003d54:	012d093b          	addw	s2,s10,s2
    80003d58:	9a6e                	add	s4,s4,s11
    80003d5a:	0369fc63          	bgeu	s3,s6,80003d92 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003d5e:	00a9559b          	srliw	a1,s2,0xa
    80003d62:	8556                	mv	a0,s5
    80003d64:	fc2ff0ef          	jal	80003526 <bmap>
    80003d68:	85aa                	mv	a1,a0
    if(addr == 0)
    80003d6a:	c505                	beqz	a0,80003d92 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003d6c:	000aa503          	lw	a0,0(s5)
    80003d70:	c50ff0ef          	jal	800031c0 <bread>
    80003d74:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003d76:	3ff97793          	andi	a5,s2,1023
    80003d7a:	40fc873b          	subw	a4,s9,a5
    80003d7e:	413b06bb          	subw	a3,s6,s3
    80003d82:	8d3a                	mv	s10,a4
    80003d84:	fae6f2e3          	bgeu	a3,a4,80003d28 <writei+0x4c>
    80003d88:	8d36                	mv	s10,a3
    80003d8a:	bf79                	j	80003d28 <writei+0x4c>
      brelse(bp);
    80003d8c:	8526                	mv	a0,s1
    80003d8e:	d3aff0ef          	jal	800032c8 <brelse>
  }

  if(off > ip->size)
    80003d92:	04caa783          	lw	a5,76(s5)
    80003d96:	0327f963          	bgeu	a5,s2,80003dc8 <writei+0xec>
    ip->size = off;
    80003d9a:	052aa623          	sw	s2,76(s5)
    80003d9e:	64e6                	ld	s1,88(sp)
    80003da0:	7c02                	ld	s8,32(sp)
    80003da2:	6ce2                	ld	s9,24(sp)
    80003da4:	6d42                	ld	s10,16(sp)
    80003da6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003da8:	8556                	mv	a0,s5
    80003daa:	9fbff0ef          	jal	800037a4 <iupdate>

  return tot;
    80003dae:	854e                	mv	a0,s3
    80003db0:	69a6                	ld	s3,72(sp)
}
    80003db2:	70a6                	ld	ra,104(sp)
    80003db4:	7406                	ld	s0,96(sp)
    80003db6:	6946                	ld	s2,80(sp)
    80003db8:	6a06                	ld	s4,64(sp)
    80003dba:	7ae2                	ld	s5,56(sp)
    80003dbc:	7b42                	ld	s6,48(sp)
    80003dbe:	7ba2                	ld	s7,40(sp)
    80003dc0:	6165                	addi	sp,sp,112
    80003dc2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003dc4:	89da                	mv	s3,s6
    80003dc6:	b7cd                	j	80003da8 <writei+0xcc>
    80003dc8:	64e6                	ld	s1,88(sp)
    80003dca:	7c02                	ld	s8,32(sp)
    80003dcc:	6ce2                	ld	s9,24(sp)
    80003dce:	6d42                	ld	s10,16(sp)
    80003dd0:	6da2                	ld	s11,8(sp)
    80003dd2:	bfd9                	j	80003da8 <writei+0xcc>
    return -1;
    80003dd4:	557d                	li	a0,-1
}
    80003dd6:	8082                	ret
    return -1;
    80003dd8:	557d                	li	a0,-1
    80003dda:	bfe1                	j	80003db2 <writei+0xd6>

0000000080003ddc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ddc:	1141                	addi	sp,sp,-16
    80003dde:	e406                	sd	ra,8(sp)
    80003de0:	e022                	sd	s0,0(sp)
    80003de2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003de4:	4639                	li	a2,14
    80003de6:	fe7fc0ef          	jal	80000dcc <strncmp>
}
    80003dea:	60a2                	ld	ra,8(sp)
    80003dec:	6402                	ld	s0,0(sp)
    80003dee:	0141                	addi	sp,sp,16
    80003df0:	8082                	ret

0000000080003df2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003df2:	711d                	addi	sp,sp,-96
    80003df4:	ec86                	sd	ra,88(sp)
    80003df6:	e8a2                	sd	s0,80(sp)
    80003df8:	e4a6                	sd	s1,72(sp)
    80003dfa:	e0ca                	sd	s2,64(sp)
    80003dfc:	fc4e                	sd	s3,56(sp)
    80003dfe:	f852                	sd	s4,48(sp)
    80003e00:	f456                	sd	s5,40(sp)
    80003e02:	f05a                	sd	s6,32(sp)
    80003e04:	ec5e                	sd	s7,24(sp)
    80003e06:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003e08:	04451703          	lh	a4,68(a0)
    80003e0c:	4785                	li	a5,1
    80003e0e:	00f71f63          	bne	a4,a5,80003e2c <dirlookup+0x3a>
    80003e12:	892a                	mv	s2,a0
    80003e14:	8aae                	mv	s5,a1
    80003e16:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e18:	457c                	lw	a5,76(a0)
    80003e1a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e1c:	fa040a13          	addi	s4,s0,-96
    80003e20:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003e22:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003e26:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e28:	e39d                	bnez	a5,80003e4e <dirlookup+0x5c>
    80003e2a:	a8b9                	j	80003e88 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003e2c:	00005517          	auipc	a0,0x5
    80003e30:	86c50513          	addi	a0,a0,-1940 # 80008698 <etext+0x698>
    80003e34:	9f1fc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    80003e38:	00005517          	auipc	a0,0x5
    80003e3c:	87850513          	addi	a0,a0,-1928 # 800086b0 <etext+0x6b0>
    80003e40:	9e5fc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e44:	24c1                	addiw	s1,s1,16
    80003e46:	04c92783          	lw	a5,76(s2)
    80003e4a:	02f4fe63          	bgeu	s1,a5,80003e86 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e4e:	874e                	mv	a4,s3
    80003e50:	86a6                	mv	a3,s1
    80003e52:	8652                	mv	a2,s4
    80003e54:	4581                	li	a1,0
    80003e56:	854a                	mv	a0,s2
    80003e58:	d93ff0ef          	jal	80003bea <readi>
    80003e5c:	fd351ee3          	bne	a0,s3,80003e38 <dirlookup+0x46>
    if(de.inum == 0)
    80003e60:	fa045783          	lhu	a5,-96(s0)
    80003e64:	d3e5                	beqz	a5,80003e44 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003e66:	85da                	mv	a1,s6
    80003e68:	8556                	mv	a0,s5
    80003e6a:	f73ff0ef          	jal	80003ddc <namecmp>
    80003e6e:	f979                	bnez	a0,80003e44 <dirlookup+0x52>
      if(poff)
    80003e70:	000b8463          	beqz	s7,80003e78 <dirlookup+0x86>
        *poff = off;
    80003e74:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003e78:	fa045583          	lhu	a1,-96(s0)
    80003e7c:	00092503          	lw	a0,0(s2)
    80003e80:	f66ff0ef          	jal	800035e6 <iget>
    80003e84:	a011                	j	80003e88 <dirlookup+0x96>
  return 0;
    80003e86:	4501                	li	a0,0
}
    80003e88:	60e6                	ld	ra,88(sp)
    80003e8a:	6446                	ld	s0,80(sp)
    80003e8c:	64a6                	ld	s1,72(sp)
    80003e8e:	6906                	ld	s2,64(sp)
    80003e90:	79e2                	ld	s3,56(sp)
    80003e92:	7a42                	ld	s4,48(sp)
    80003e94:	7aa2                	ld	s5,40(sp)
    80003e96:	7b02                	ld	s6,32(sp)
    80003e98:	6be2                	ld	s7,24(sp)
    80003e9a:	6125                	addi	sp,sp,96
    80003e9c:	8082                	ret

0000000080003e9e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003e9e:	711d                	addi	sp,sp,-96
    80003ea0:	ec86                	sd	ra,88(sp)
    80003ea2:	e8a2                	sd	s0,80(sp)
    80003ea4:	e4a6                	sd	s1,72(sp)
    80003ea6:	e0ca                	sd	s2,64(sp)
    80003ea8:	fc4e                	sd	s3,56(sp)
    80003eaa:	f852                	sd	s4,48(sp)
    80003eac:	f456                	sd	s5,40(sp)
    80003eae:	f05a                	sd	s6,32(sp)
    80003eb0:	ec5e                	sd	s7,24(sp)
    80003eb2:	e862                	sd	s8,16(sp)
    80003eb4:	e466                	sd	s9,8(sp)
    80003eb6:	e06a                	sd	s10,0(sp)
    80003eb8:	1080                	addi	s0,sp,96
    80003eba:	84aa                	mv	s1,a0
    80003ebc:	8b2e                	mv	s6,a1
    80003ebe:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003ec0:	00054703          	lbu	a4,0(a0)
    80003ec4:	02f00793          	li	a5,47
    80003ec8:	00f70f63          	beq	a4,a5,80003ee6 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003ecc:	ccffd0ef          	jal	80001b9a <myproc>
    80003ed0:	15053503          	ld	a0,336(a0)
    80003ed4:	94fff0ef          	jal	80003822 <idup>
    80003ed8:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003eda:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003ede:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003ee0:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003ee2:	4b85                	li	s7,1
    80003ee4:	a879                	j	80003f82 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003ee6:	4585                	li	a1,1
    80003ee8:	852e                	mv	a0,a1
    80003eea:	efcff0ef          	jal	800035e6 <iget>
    80003eee:	8a2a                	mv	s4,a0
    80003ef0:	b7ed                	j	80003eda <namex+0x3c>
      iunlockput(ip);
    80003ef2:	8552                	mv	a0,s4
    80003ef4:	b71ff0ef          	jal	80003a64 <iunlockput>
      return 0;
    80003ef8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003efa:	8552                	mv	a0,s4
    80003efc:	60e6                	ld	ra,88(sp)
    80003efe:	6446                	ld	s0,80(sp)
    80003f00:	64a6                	ld	s1,72(sp)
    80003f02:	6906                	ld	s2,64(sp)
    80003f04:	79e2                	ld	s3,56(sp)
    80003f06:	7a42                	ld	s4,48(sp)
    80003f08:	7aa2                	ld	s5,40(sp)
    80003f0a:	7b02                	ld	s6,32(sp)
    80003f0c:	6be2                	ld	s7,24(sp)
    80003f0e:	6c42                	ld	s8,16(sp)
    80003f10:	6ca2                	ld	s9,8(sp)
    80003f12:	6d02                	ld	s10,0(sp)
    80003f14:	6125                	addi	sp,sp,96
    80003f16:	8082                	ret
      iunlock(ip);
    80003f18:	8552                	mv	a0,s4
    80003f1a:	9edff0ef          	jal	80003906 <iunlock>
      return ip;
    80003f1e:	bff1                	j	80003efa <namex+0x5c>
      iunlockput(ip);
    80003f20:	8552                	mv	a0,s4
    80003f22:	b43ff0ef          	jal	80003a64 <iunlockput>
      return 0;
    80003f26:	8a4a                	mv	s4,s2
    80003f28:	bfc9                	j	80003efa <namex+0x5c>
  len = path - s;
    80003f2a:	40990633          	sub	a2,s2,s1
    80003f2e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003f32:	09ac5463          	bge	s8,s10,80003fba <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003f36:	8666                	mv	a2,s9
    80003f38:	85a6                	mv	a1,s1
    80003f3a:	8556                	mv	a0,s5
    80003f3c:	e1dfc0ef          	jal	80000d58 <memmove>
    80003f40:	84ca                	mv	s1,s2
  while(*path == '/')
    80003f42:	0004c783          	lbu	a5,0(s1)
    80003f46:	01379763          	bne	a5,s3,80003f54 <namex+0xb6>
    path++;
    80003f4a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f4c:	0004c783          	lbu	a5,0(s1)
    80003f50:	ff378de3          	beq	a5,s3,80003f4a <namex+0xac>
    ilock(ip);
    80003f54:	8552                	mv	a0,s4
    80003f56:	903ff0ef          	jal	80003858 <ilock>
    if(ip->type != T_DIR){
    80003f5a:	044a1783          	lh	a5,68(s4)
    80003f5e:	f9779ae3          	bne	a5,s7,80003ef2 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003f62:	000b0563          	beqz	s6,80003f6c <namex+0xce>
    80003f66:	0004c783          	lbu	a5,0(s1)
    80003f6a:	d7dd                	beqz	a5,80003f18 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003f6c:	4601                	li	a2,0
    80003f6e:	85d6                	mv	a1,s5
    80003f70:	8552                	mv	a0,s4
    80003f72:	e81ff0ef          	jal	80003df2 <dirlookup>
    80003f76:	892a                	mv	s2,a0
    80003f78:	d545                	beqz	a0,80003f20 <namex+0x82>
    iunlockput(ip);
    80003f7a:	8552                	mv	a0,s4
    80003f7c:	ae9ff0ef          	jal	80003a64 <iunlockput>
    ip = next;
    80003f80:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003f82:	0004c783          	lbu	a5,0(s1)
    80003f86:	01379763          	bne	a5,s3,80003f94 <namex+0xf6>
    path++;
    80003f8a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003f8c:	0004c783          	lbu	a5,0(s1)
    80003f90:	ff378de3          	beq	a5,s3,80003f8a <namex+0xec>
  if(*path == 0)
    80003f94:	cf8d                	beqz	a5,80003fce <namex+0x130>
  while(*path != '/' && *path != 0)
    80003f96:	0004c783          	lbu	a5,0(s1)
    80003f9a:	fd178713          	addi	a4,a5,-47
    80003f9e:	cb19                	beqz	a4,80003fb4 <namex+0x116>
    80003fa0:	cb91                	beqz	a5,80003fb4 <namex+0x116>
    80003fa2:	8926                	mv	s2,s1
    path++;
    80003fa4:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003fa6:	00094783          	lbu	a5,0(s2)
    80003faa:	fd178713          	addi	a4,a5,-47
    80003fae:	df35                	beqz	a4,80003f2a <namex+0x8c>
    80003fb0:	fbf5                	bnez	a5,80003fa4 <namex+0x106>
    80003fb2:	bfa5                	j	80003f2a <namex+0x8c>
    80003fb4:	8926                	mv	s2,s1
  len = path - s;
    80003fb6:	4d01                	li	s10,0
    80003fb8:	4601                	li	a2,0
    memmove(name, s, len);
    80003fba:	2601                	sext.w	a2,a2
    80003fbc:	85a6                	mv	a1,s1
    80003fbe:	8556                	mv	a0,s5
    80003fc0:	d99fc0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80003fc4:	9d56                	add	s10,s10,s5
    80003fc6:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffb44c8>
    80003fca:	84ca                	mv	s1,s2
    80003fcc:	bf9d                	j	80003f42 <namex+0xa4>
  if(nameiparent){
    80003fce:	f20b06e3          	beqz	s6,80003efa <namex+0x5c>
    iput(ip);
    80003fd2:	8552                	mv	a0,s4
    80003fd4:	a07ff0ef          	jal	800039da <iput>
    return 0;
    80003fd8:	4a01                	li	s4,0
    80003fda:	b705                	j	80003efa <namex+0x5c>

0000000080003fdc <dirlink>:
{
    80003fdc:	715d                	addi	sp,sp,-80
    80003fde:	e486                	sd	ra,72(sp)
    80003fe0:	e0a2                	sd	s0,64(sp)
    80003fe2:	f84a                	sd	s2,48(sp)
    80003fe4:	ec56                	sd	s5,24(sp)
    80003fe6:	e85a                	sd	s6,16(sp)
    80003fe8:	0880                	addi	s0,sp,80
    80003fea:	892a                	mv	s2,a0
    80003fec:	8aae                	mv	s5,a1
    80003fee:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ff0:	4601                	li	a2,0
    80003ff2:	e01ff0ef          	jal	80003df2 <dirlookup>
    80003ff6:	ed1d                	bnez	a0,80004034 <dirlink+0x58>
    80003ff8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ffa:	04c92483          	lw	s1,76(s2)
    80003ffe:	c4b9                	beqz	s1,8000404c <dirlink+0x70>
    80004000:	f44e                	sd	s3,40(sp)
    80004002:	f052                	sd	s4,32(sp)
    80004004:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004006:	fb040a13          	addi	s4,s0,-80
    8000400a:	49c1                	li	s3,16
    8000400c:	874e                	mv	a4,s3
    8000400e:	86a6                	mv	a3,s1
    80004010:	8652                	mv	a2,s4
    80004012:	4581                	li	a1,0
    80004014:	854a                	mv	a0,s2
    80004016:	bd5ff0ef          	jal	80003bea <readi>
    8000401a:	03351163          	bne	a0,s3,8000403c <dirlink+0x60>
    if(de.inum == 0)
    8000401e:	fb045783          	lhu	a5,-80(s0)
    80004022:	c39d                	beqz	a5,80004048 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004024:	24c1                	addiw	s1,s1,16
    80004026:	04c92783          	lw	a5,76(s2)
    8000402a:	fef4e1e3          	bltu	s1,a5,8000400c <dirlink+0x30>
    8000402e:	79a2                	ld	s3,40(sp)
    80004030:	7a02                	ld	s4,32(sp)
    80004032:	a829                	j	8000404c <dirlink+0x70>
    iput(ip);
    80004034:	9a7ff0ef          	jal	800039da <iput>
    return -1;
    80004038:	557d                	li	a0,-1
    8000403a:	a83d                	j	80004078 <dirlink+0x9c>
      panic("dirlink read");
    8000403c:	00004517          	auipc	a0,0x4
    80004040:	68450513          	addi	a0,a0,1668 # 800086c0 <etext+0x6c0>
    80004044:	fe0fc0ef          	jal	80000824 <panic>
    80004048:	79a2                	ld	s3,40(sp)
    8000404a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000404c:	4639                	li	a2,14
    8000404e:	85d6                	mv	a1,s5
    80004050:	fb240513          	addi	a0,s0,-78
    80004054:	db3fc0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    80004058:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000405c:	4741                	li	a4,16
    8000405e:	86a6                	mv	a3,s1
    80004060:	fb040613          	addi	a2,s0,-80
    80004064:	4581                	li	a1,0
    80004066:	854a                	mv	a0,s2
    80004068:	c75ff0ef          	jal	80003cdc <writei>
    8000406c:	1541                	addi	a0,a0,-16
    8000406e:	00a03533          	snez	a0,a0
    80004072:	40a0053b          	negw	a0,a0
    80004076:	74e2                	ld	s1,56(sp)
}
    80004078:	60a6                	ld	ra,72(sp)
    8000407a:	6406                	ld	s0,64(sp)
    8000407c:	7942                	ld	s2,48(sp)
    8000407e:	6ae2                	ld	s5,24(sp)
    80004080:	6b42                	ld	s6,16(sp)
    80004082:	6161                	addi	sp,sp,80
    80004084:	8082                	ret

0000000080004086 <namei>:

struct inode*
namei(char *path)
{
    80004086:	1101                	addi	sp,sp,-32
    80004088:	ec06                	sd	ra,24(sp)
    8000408a:	e822                	sd	s0,16(sp)
    8000408c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000408e:	fe040613          	addi	a2,s0,-32
    80004092:	4581                	li	a1,0
    80004094:	e0bff0ef          	jal	80003e9e <namex>
}
    80004098:	60e2                	ld	ra,24(sp)
    8000409a:	6442                	ld	s0,16(sp)
    8000409c:	6105                	addi	sp,sp,32
    8000409e:	8082                	ret

00000000800040a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800040a0:	1141                	addi	sp,sp,-16
    800040a2:	e406                	sd	ra,8(sp)
    800040a4:	e022                	sd	s0,0(sp)
    800040a6:	0800                	addi	s0,sp,16
    800040a8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800040aa:	4585                	li	a1,1
    800040ac:	df3ff0ef          	jal	80003e9e <namex>
}
    800040b0:	60a2                	ld	ra,8(sp)
    800040b2:	6402                	ld	s0,0(sp)
    800040b4:	0141                	addi	sp,sp,16
    800040b6:	8082                	ret

00000000800040b8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800040b8:	1101                	addi	sp,sp,-32
    800040ba:	ec06                	sd	ra,24(sp)
    800040bc:	e822                	sd	s0,16(sp)
    800040be:	e426                	sd	s1,8(sp)
    800040c0:	e04a                	sd	s2,0(sp)
    800040c2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800040c4:	00046917          	auipc	s2,0x46
    800040c8:	83490913          	addi	s2,s2,-1996 # 800498f8 <log>
    800040cc:	01892583          	lw	a1,24(s2)
    800040d0:	02492503          	lw	a0,36(s2)
    800040d4:	8ecff0ef          	jal	800031c0 <bread>
    800040d8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800040da:	02892603          	lw	a2,40(s2)
    800040de:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800040e0:	00c05f63          	blez	a2,800040fe <write_head+0x46>
    800040e4:	00046717          	auipc	a4,0x46
    800040e8:	84070713          	addi	a4,a4,-1984 # 80049924 <log+0x2c>
    800040ec:	87aa                	mv	a5,a0
    800040ee:	060a                	slli	a2,a2,0x2
    800040f0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800040f2:	4314                	lw	a3,0(a4)
    800040f4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800040f6:	0711                	addi	a4,a4,4
    800040f8:	0791                	addi	a5,a5,4
    800040fa:	fec79ce3          	bne	a5,a2,800040f2 <write_head+0x3a>
  }
  bwrite(buf);
    800040fe:	8526                	mv	a0,s1
    80004100:	996ff0ef          	jal	80003296 <bwrite>
  brelse(buf);
    80004104:	8526                	mv	a0,s1
    80004106:	9c2ff0ef          	jal	800032c8 <brelse>
}
    8000410a:	60e2                	ld	ra,24(sp)
    8000410c:	6442                	ld	s0,16(sp)
    8000410e:	64a2                	ld	s1,8(sp)
    80004110:	6902                	ld	s2,0(sp)
    80004112:	6105                	addi	sp,sp,32
    80004114:	8082                	ret

0000000080004116 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004116:	00046797          	auipc	a5,0x46
    8000411a:	80a7a783          	lw	a5,-2038(a5) # 80049920 <log+0x28>
    8000411e:	0cf05163          	blez	a5,800041e0 <install_trans+0xca>
{
    80004122:	715d                	addi	sp,sp,-80
    80004124:	e486                	sd	ra,72(sp)
    80004126:	e0a2                	sd	s0,64(sp)
    80004128:	fc26                	sd	s1,56(sp)
    8000412a:	f84a                	sd	s2,48(sp)
    8000412c:	f44e                	sd	s3,40(sp)
    8000412e:	f052                	sd	s4,32(sp)
    80004130:	ec56                	sd	s5,24(sp)
    80004132:	e85a                	sd	s6,16(sp)
    80004134:	e45e                	sd	s7,8(sp)
    80004136:	e062                	sd	s8,0(sp)
    80004138:	0880                	addi	s0,sp,80
    8000413a:	8b2a                	mv	s6,a0
    8000413c:	00045a97          	auipc	s5,0x45
    80004140:	7e8a8a93          	addi	s5,s5,2024 # 80049924 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004144:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004146:	00004c17          	auipc	s8,0x4
    8000414a:	58ac0c13          	addi	s8,s8,1418 # 800086d0 <etext+0x6d0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000414e:	00045a17          	auipc	s4,0x45
    80004152:	7aaa0a13          	addi	s4,s4,1962 # 800498f8 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004156:	40000b93          	li	s7,1024
    8000415a:	a025                	j	80004182 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000415c:	000aa603          	lw	a2,0(s5)
    80004160:	85ce                	mv	a1,s3
    80004162:	8562                	mv	a0,s8
    80004164:	b96fc0ef          	jal	800004fa <printf>
    80004168:	a839                	j	80004186 <install_trans+0x70>
    brelse(lbuf);
    8000416a:	854a                	mv	a0,s2
    8000416c:	95cff0ef          	jal	800032c8 <brelse>
    brelse(dbuf);
    80004170:	8526                	mv	a0,s1
    80004172:	956ff0ef          	jal	800032c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004176:	2985                	addiw	s3,s3,1
    80004178:	0a91                	addi	s5,s5,4
    8000417a:	028a2783          	lw	a5,40(s4)
    8000417e:	04f9d563          	bge	s3,a5,800041c8 <install_trans+0xb2>
    if(recovering) {
    80004182:	fc0b1de3          	bnez	s6,8000415c <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004186:	018a2583          	lw	a1,24(s4)
    8000418a:	013585bb          	addw	a1,a1,s3
    8000418e:	2585                	addiw	a1,a1,1
    80004190:	024a2503          	lw	a0,36(s4)
    80004194:	82cff0ef          	jal	800031c0 <bread>
    80004198:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000419a:	000aa583          	lw	a1,0(s5)
    8000419e:	024a2503          	lw	a0,36(s4)
    800041a2:	81eff0ef          	jal	800031c0 <bread>
    800041a6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800041a8:	865e                	mv	a2,s7
    800041aa:	05890593          	addi	a1,s2,88
    800041ae:	05850513          	addi	a0,a0,88
    800041b2:	ba7fc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    800041b6:	8526                	mv	a0,s1
    800041b8:	8deff0ef          	jal	80003296 <bwrite>
    if(recovering == 0)
    800041bc:	fa0b17e3          	bnez	s6,8000416a <install_trans+0x54>
      bunpin(dbuf);
    800041c0:	8526                	mv	a0,s1
    800041c2:	9beff0ef          	jal	80003380 <bunpin>
    800041c6:	b755                	j	8000416a <install_trans+0x54>
}
    800041c8:	60a6                	ld	ra,72(sp)
    800041ca:	6406                	ld	s0,64(sp)
    800041cc:	74e2                	ld	s1,56(sp)
    800041ce:	7942                	ld	s2,48(sp)
    800041d0:	79a2                	ld	s3,40(sp)
    800041d2:	7a02                	ld	s4,32(sp)
    800041d4:	6ae2                	ld	s5,24(sp)
    800041d6:	6b42                	ld	s6,16(sp)
    800041d8:	6ba2                	ld	s7,8(sp)
    800041da:	6c02                	ld	s8,0(sp)
    800041dc:	6161                	addi	sp,sp,80
    800041de:	8082                	ret
    800041e0:	8082                	ret

00000000800041e2 <initlog>:
{
    800041e2:	7179                	addi	sp,sp,-48
    800041e4:	f406                	sd	ra,40(sp)
    800041e6:	f022                	sd	s0,32(sp)
    800041e8:	ec26                	sd	s1,24(sp)
    800041ea:	e84a                	sd	s2,16(sp)
    800041ec:	e44e                	sd	s3,8(sp)
    800041ee:	1800                	addi	s0,sp,48
    800041f0:	84aa                	mv	s1,a0
    800041f2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800041f4:	00045917          	auipc	s2,0x45
    800041f8:	70490913          	addi	s2,s2,1796 # 800498f8 <log>
    800041fc:	00004597          	auipc	a1,0x4
    80004200:	4f458593          	addi	a1,a1,1268 # 800086f0 <etext+0x6f0>
    80004204:	854a                	mv	a0,s2
    80004206:	999fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    8000420a:	0149a583          	lw	a1,20(s3)
    8000420e:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80004212:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80004216:	8526                	mv	a0,s1
    80004218:	fa9fe0ef          	jal	800031c0 <bread>
  log.lh.n = lh->n;
    8000421c:	4d30                	lw	a2,88(a0)
    8000421e:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80004222:	00c05f63          	blez	a2,80004240 <initlog+0x5e>
    80004226:	87aa                	mv	a5,a0
    80004228:	00045717          	auipc	a4,0x45
    8000422c:	6fc70713          	addi	a4,a4,1788 # 80049924 <log+0x2c>
    80004230:	060a                	slli	a2,a2,0x2
    80004232:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004234:	4ff4                	lw	a3,92(a5)
    80004236:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004238:	0791                	addi	a5,a5,4
    8000423a:	0711                	addi	a4,a4,4
    8000423c:	fec79ce3          	bne	a5,a2,80004234 <initlog+0x52>
  brelse(buf);
    80004240:	888ff0ef          	jal	800032c8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004244:	4505                	li	a0,1
    80004246:	ed1ff0ef          	jal	80004116 <install_trans>
  log.lh.n = 0;
    8000424a:	00045797          	auipc	a5,0x45
    8000424e:	6c07ab23          	sw	zero,1750(a5) # 80049920 <log+0x28>
  write_head(); // clear the log
    80004252:	e67ff0ef          	jal	800040b8 <write_head>
}
    80004256:	70a2                	ld	ra,40(sp)
    80004258:	7402                	ld	s0,32(sp)
    8000425a:	64e2                	ld	s1,24(sp)
    8000425c:	6942                	ld	s2,16(sp)
    8000425e:	69a2                	ld	s3,8(sp)
    80004260:	6145                	addi	sp,sp,48
    80004262:	8082                	ret

0000000080004264 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004264:	1101                	addi	sp,sp,-32
    80004266:	ec06                	sd	ra,24(sp)
    80004268:	e822                	sd	s0,16(sp)
    8000426a:	e426                	sd	s1,8(sp)
    8000426c:	e04a                	sd	s2,0(sp)
    8000426e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004270:	00045517          	auipc	a0,0x45
    80004274:	68850513          	addi	a0,a0,1672 # 800498f8 <log>
    80004278:	9b1fc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    8000427c:	00045497          	auipc	s1,0x45
    80004280:	67c48493          	addi	s1,s1,1660 # 800498f8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004284:	4979                	li	s2,30
    80004286:	a029                	j	80004290 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80004288:	85a6                	mv	a1,s1
    8000428a:	8526                	mv	a0,s1
    8000428c:	fbdfd0ef          	jal	80002248 <sleep>
    if(log.committing){
    80004290:	509c                	lw	a5,32(s1)
    80004292:	fbfd                	bnez	a5,80004288 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004294:	4cd8                	lw	a4,28(s1)
    80004296:	2705                	addiw	a4,a4,1
    80004298:	0027179b          	slliw	a5,a4,0x2
    8000429c:	9fb9                	addw	a5,a5,a4
    8000429e:	0017979b          	slliw	a5,a5,0x1
    800042a2:	5494                	lw	a3,40(s1)
    800042a4:	9fb5                	addw	a5,a5,a3
    800042a6:	00f95763          	bge	s2,a5,800042b4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800042aa:	85a6                	mv	a1,s1
    800042ac:	8526                	mv	a0,s1
    800042ae:	f9bfd0ef          	jal	80002248 <sleep>
    800042b2:	bff9                	j	80004290 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800042b4:	00045797          	auipc	a5,0x45
    800042b8:	66e7a023          	sw	a4,1632(a5) # 80049914 <log+0x1c>
      release(&log.lock);
    800042bc:	00045517          	auipc	a0,0x45
    800042c0:	63c50513          	addi	a0,a0,1596 # 800498f8 <log>
    800042c4:	9f9fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    800042c8:	60e2                	ld	ra,24(sp)
    800042ca:	6442                	ld	s0,16(sp)
    800042cc:	64a2                	ld	s1,8(sp)
    800042ce:	6902                	ld	s2,0(sp)
    800042d0:	6105                	addi	sp,sp,32
    800042d2:	8082                	ret

00000000800042d4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800042d4:	7139                	addi	sp,sp,-64
    800042d6:	fc06                	sd	ra,56(sp)
    800042d8:	f822                	sd	s0,48(sp)
    800042da:	f426                	sd	s1,40(sp)
    800042dc:	f04a                	sd	s2,32(sp)
    800042de:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800042e0:	00045497          	auipc	s1,0x45
    800042e4:	61848493          	addi	s1,s1,1560 # 800498f8 <log>
    800042e8:	8526                	mv	a0,s1
    800042ea:	93ffc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    800042ee:	4cdc                	lw	a5,28(s1)
    800042f0:	37fd                	addiw	a5,a5,-1
    800042f2:	893e                	mv	s2,a5
    800042f4:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800042f6:	509c                	lw	a5,32(s1)
    800042f8:	e7b1                	bnez	a5,80004344 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800042fa:	04091e63          	bnez	s2,80004356 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    800042fe:	00045497          	auipc	s1,0x45
    80004302:	5fa48493          	addi	s1,s1,1530 # 800498f8 <log>
    80004306:	4785                	li	a5,1
    80004308:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000430a:	8526                	mv	a0,s1
    8000430c:	9b1fc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004310:	549c                	lw	a5,40(s1)
    80004312:	06f04463          	bgtz	a5,8000437a <end_op+0xa6>
    acquire(&log.lock);
    80004316:	00045517          	auipc	a0,0x45
    8000431a:	5e250513          	addi	a0,a0,1506 # 800498f8 <log>
    8000431e:	90bfc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80004322:	00045797          	auipc	a5,0x45
    80004326:	5e07ab23          	sw	zero,1526(a5) # 80049918 <log+0x20>
    wakeup(&log);
    8000432a:	00045517          	auipc	a0,0x45
    8000432e:	5ce50513          	addi	a0,a0,1486 # 800498f8 <log>
    80004332:	f63fd0ef          	jal	80002294 <wakeup>
    release(&log.lock);
    80004336:	00045517          	auipc	a0,0x45
    8000433a:	5c250513          	addi	a0,a0,1474 # 800498f8 <log>
    8000433e:	97ffc0ef          	jal	80000cbc <release>
}
    80004342:	a035                	j	8000436e <end_op+0x9a>
    80004344:	ec4e                	sd	s3,24(sp)
    80004346:	e852                	sd	s4,16(sp)
    80004348:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000434a:	00004517          	auipc	a0,0x4
    8000434e:	3ae50513          	addi	a0,a0,942 # 800086f8 <etext+0x6f8>
    80004352:	cd2fc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80004356:	00045517          	auipc	a0,0x45
    8000435a:	5a250513          	addi	a0,a0,1442 # 800498f8 <log>
    8000435e:	f37fd0ef          	jal	80002294 <wakeup>
  release(&log.lock);
    80004362:	00045517          	auipc	a0,0x45
    80004366:	59650513          	addi	a0,a0,1430 # 800498f8 <log>
    8000436a:	953fc0ef          	jal	80000cbc <release>
}
    8000436e:	70e2                	ld	ra,56(sp)
    80004370:	7442                	ld	s0,48(sp)
    80004372:	74a2                	ld	s1,40(sp)
    80004374:	7902                	ld	s2,32(sp)
    80004376:	6121                	addi	sp,sp,64
    80004378:	8082                	ret
    8000437a:	ec4e                	sd	s3,24(sp)
    8000437c:	e852                	sd	s4,16(sp)
    8000437e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004380:	00045a97          	auipc	s5,0x45
    80004384:	5a4a8a93          	addi	s5,s5,1444 # 80049924 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004388:	00045a17          	auipc	s4,0x45
    8000438c:	570a0a13          	addi	s4,s4,1392 # 800498f8 <log>
    80004390:	018a2583          	lw	a1,24(s4)
    80004394:	012585bb          	addw	a1,a1,s2
    80004398:	2585                	addiw	a1,a1,1
    8000439a:	024a2503          	lw	a0,36(s4)
    8000439e:	e23fe0ef          	jal	800031c0 <bread>
    800043a2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800043a4:	000aa583          	lw	a1,0(s5)
    800043a8:	024a2503          	lw	a0,36(s4)
    800043ac:	e15fe0ef          	jal	800031c0 <bread>
    800043b0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800043b2:	40000613          	li	a2,1024
    800043b6:	05850593          	addi	a1,a0,88
    800043ba:	05848513          	addi	a0,s1,88
    800043be:	99bfc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    800043c2:	8526                	mv	a0,s1
    800043c4:	ed3fe0ef          	jal	80003296 <bwrite>
    brelse(from);
    800043c8:	854e                	mv	a0,s3
    800043ca:	efffe0ef          	jal	800032c8 <brelse>
    brelse(to);
    800043ce:	8526                	mv	a0,s1
    800043d0:	ef9fe0ef          	jal	800032c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043d4:	2905                	addiw	s2,s2,1
    800043d6:	0a91                	addi	s5,s5,4
    800043d8:	028a2783          	lw	a5,40(s4)
    800043dc:	faf94ae3          	blt	s2,a5,80004390 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800043e0:	cd9ff0ef          	jal	800040b8 <write_head>
    install_trans(0); // Now install writes to home locations
    800043e4:	4501                	li	a0,0
    800043e6:	d31ff0ef          	jal	80004116 <install_trans>
    log.lh.n = 0;
    800043ea:	00045797          	auipc	a5,0x45
    800043ee:	5207ab23          	sw	zero,1334(a5) # 80049920 <log+0x28>
    write_head();    // Erase the transaction from the log
    800043f2:	cc7ff0ef          	jal	800040b8 <write_head>
    800043f6:	69e2                	ld	s3,24(sp)
    800043f8:	6a42                	ld	s4,16(sp)
    800043fa:	6aa2                	ld	s5,8(sp)
    800043fc:	bf29                	j	80004316 <end_op+0x42>

00000000800043fe <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800043fe:	1101                	addi	sp,sp,-32
    80004400:	ec06                	sd	ra,24(sp)
    80004402:	e822                	sd	s0,16(sp)
    80004404:	e426                	sd	s1,8(sp)
    80004406:	1000                	addi	s0,sp,32
    80004408:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000440a:	00045517          	auipc	a0,0x45
    8000440e:	4ee50513          	addi	a0,a0,1262 # 800498f8 <log>
    80004412:	817fc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004416:	00045617          	auipc	a2,0x45
    8000441a:	50a62603          	lw	a2,1290(a2) # 80049920 <log+0x28>
    8000441e:	47f5                	li	a5,29
    80004420:	04c7cd63          	blt	a5,a2,8000447a <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004424:	00045797          	auipc	a5,0x45
    80004428:	4f07a783          	lw	a5,1264(a5) # 80049914 <log+0x1c>
    8000442c:	04f05d63          	blez	a5,80004486 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004430:	4781                	li	a5,0
    80004432:	06c05063          	blez	a2,80004492 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004436:	44cc                	lw	a1,12(s1)
    80004438:	00045717          	auipc	a4,0x45
    8000443c:	4ec70713          	addi	a4,a4,1260 # 80049924 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004440:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004442:	4314                	lw	a3,0(a4)
    80004444:	04b68763          	beq	a3,a1,80004492 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80004448:	2785                	addiw	a5,a5,1
    8000444a:	0711                	addi	a4,a4,4
    8000444c:	fef61be3          	bne	a2,a5,80004442 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004450:	060a                	slli	a2,a2,0x2
    80004452:	02060613          	addi	a2,a2,32
    80004456:	00045797          	auipc	a5,0x45
    8000445a:	4a278793          	addi	a5,a5,1186 # 800498f8 <log>
    8000445e:	97b2                	add	a5,a5,a2
    80004460:	44d8                	lw	a4,12(s1)
    80004462:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004464:	8526                	mv	a0,s1
    80004466:	ee7fe0ef          	jal	8000334c <bpin>
    log.lh.n++;
    8000446a:	00045717          	auipc	a4,0x45
    8000446e:	48e70713          	addi	a4,a4,1166 # 800498f8 <log>
    80004472:	571c                	lw	a5,40(a4)
    80004474:	2785                	addiw	a5,a5,1
    80004476:	d71c                	sw	a5,40(a4)
    80004478:	a815                	j	800044ac <log_write+0xae>
    panic("too big a transaction");
    8000447a:	00004517          	auipc	a0,0x4
    8000447e:	28e50513          	addi	a0,a0,654 # 80008708 <etext+0x708>
    80004482:	ba2fc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80004486:	00004517          	auipc	a0,0x4
    8000448a:	29a50513          	addi	a0,a0,666 # 80008720 <etext+0x720>
    8000448e:	b96fc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80004492:	00279693          	slli	a3,a5,0x2
    80004496:	02068693          	addi	a3,a3,32
    8000449a:	00045717          	auipc	a4,0x45
    8000449e:	45e70713          	addi	a4,a4,1118 # 800498f8 <log>
    800044a2:	9736                	add	a4,a4,a3
    800044a4:	44d4                	lw	a3,12(s1)
    800044a6:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800044a8:	faf60ee3          	beq	a2,a5,80004464 <log_write+0x66>
  }
  release(&log.lock);
    800044ac:	00045517          	auipc	a0,0x45
    800044b0:	44c50513          	addi	a0,a0,1100 # 800498f8 <log>
    800044b4:	809fc0ef          	jal	80000cbc <release>
}
    800044b8:	60e2                	ld	ra,24(sp)
    800044ba:	6442                	ld	s0,16(sp)
    800044bc:	64a2                	ld	s1,8(sp)
    800044be:	6105                	addi	sp,sp,32
    800044c0:	8082                	ret

00000000800044c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800044c2:	1101                	addi	sp,sp,-32
    800044c4:	ec06                	sd	ra,24(sp)
    800044c6:	e822                	sd	s0,16(sp)
    800044c8:	e426                	sd	s1,8(sp)
    800044ca:	e04a                	sd	s2,0(sp)
    800044cc:	1000                	addi	s0,sp,32
    800044ce:	84aa                	mv	s1,a0
    800044d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800044d2:	00004597          	auipc	a1,0x4
    800044d6:	26e58593          	addi	a1,a1,622 # 80008740 <etext+0x740>
    800044da:	0521                	addi	a0,a0,8
    800044dc:	ec2fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    800044e0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800044e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800044e8:	0204a423          	sw	zero,40(s1)
}
    800044ec:	60e2                	ld	ra,24(sp)
    800044ee:	6442                	ld	s0,16(sp)
    800044f0:	64a2                	ld	s1,8(sp)
    800044f2:	6902                	ld	s2,0(sp)
    800044f4:	6105                	addi	sp,sp,32
    800044f6:	8082                	ret

00000000800044f8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800044f8:	1101                	addi	sp,sp,-32
    800044fa:	ec06                	sd	ra,24(sp)
    800044fc:	e822                	sd	s0,16(sp)
    800044fe:	e426                	sd	s1,8(sp)
    80004500:	e04a                	sd	s2,0(sp)
    80004502:	1000                	addi	s0,sp,32
    80004504:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004506:	00850913          	addi	s2,a0,8
    8000450a:	854a                	mv	a0,s2
    8000450c:	f1cfc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004510:	409c                	lw	a5,0(s1)
    80004512:	c799                	beqz	a5,80004520 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004514:	85ca                	mv	a1,s2
    80004516:	8526                	mv	a0,s1
    80004518:	d31fd0ef          	jal	80002248 <sleep>
  while (lk->locked) {
    8000451c:	409c                	lw	a5,0(s1)
    8000451e:	fbfd                	bnez	a5,80004514 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004520:	4785                	li	a5,1
    80004522:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004524:	e76fd0ef          	jal	80001b9a <myproc>
    80004528:	591c                	lw	a5,48(a0)
    8000452a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000452c:	854a                	mv	a0,s2
    8000452e:	f8efc0ef          	jal	80000cbc <release>
}
    80004532:	60e2                	ld	ra,24(sp)
    80004534:	6442                	ld	s0,16(sp)
    80004536:	64a2                	ld	s1,8(sp)
    80004538:	6902                	ld	s2,0(sp)
    8000453a:	6105                	addi	sp,sp,32
    8000453c:	8082                	ret

000000008000453e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000453e:	1101                	addi	sp,sp,-32
    80004540:	ec06                	sd	ra,24(sp)
    80004542:	e822                	sd	s0,16(sp)
    80004544:	e426                	sd	s1,8(sp)
    80004546:	e04a                	sd	s2,0(sp)
    80004548:	1000                	addi	s0,sp,32
    8000454a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000454c:	00850913          	addi	s2,a0,8
    80004550:	854a                	mv	a0,s2
    80004552:	ed6fc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    80004556:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000455a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000455e:	8526                	mv	a0,s1
    80004560:	d35fd0ef          	jal	80002294 <wakeup>
  release(&lk->lk);
    80004564:	854a                	mv	a0,s2
    80004566:	f56fc0ef          	jal	80000cbc <release>
}
    8000456a:	60e2                	ld	ra,24(sp)
    8000456c:	6442                	ld	s0,16(sp)
    8000456e:	64a2                	ld	s1,8(sp)
    80004570:	6902                	ld	s2,0(sp)
    80004572:	6105                	addi	sp,sp,32
    80004574:	8082                	ret

0000000080004576 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004576:	7179                	addi	sp,sp,-48
    80004578:	f406                	sd	ra,40(sp)
    8000457a:	f022                	sd	s0,32(sp)
    8000457c:	ec26                	sd	s1,24(sp)
    8000457e:	e84a                	sd	s2,16(sp)
    80004580:	1800                	addi	s0,sp,48
    80004582:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004584:	00850913          	addi	s2,a0,8
    80004588:	854a                	mv	a0,s2
    8000458a:	e9efc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000458e:	409c                	lw	a5,0(s1)
    80004590:	ef81                	bnez	a5,800045a8 <holdingsleep+0x32>
    80004592:	4481                	li	s1,0
  release(&lk->lk);
    80004594:	854a                	mv	a0,s2
    80004596:	f26fc0ef          	jal	80000cbc <release>
  return r;
}
    8000459a:	8526                	mv	a0,s1
    8000459c:	70a2                	ld	ra,40(sp)
    8000459e:	7402                	ld	s0,32(sp)
    800045a0:	64e2                	ld	s1,24(sp)
    800045a2:	6942                	ld	s2,16(sp)
    800045a4:	6145                	addi	sp,sp,48
    800045a6:	8082                	ret
    800045a8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800045aa:	0284a983          	lw	s3,40(s1)
    800045ae:	decfd0ef          	jal	80001b9a <myproc>
    800045b2:	5904                	lw	s1,48(a0)
    800045b4:	413484b3          	sub	s1,s1,s3
    800045b8:	0014b493          	seqz	s1,s1
    800045bc:	69a2                	ld	s3,8(sp)
    800045be:	bfd9                	j	80004594 <holdingsleep+0x1e>

00000000800045c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800045c0:	1141                	addi	sp,sp,-16
    800045c2:	e406                	sd	ra,8(sp)
    800045c4:	e022                	sd	s0,0(sp)
    800045c6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800045c8:	00004597          	auipc	a1,0x4
    800045cc:	18858593          	addi	a1,a1,392 # 80008750 <etext+0x750>
    800045d0:	00045517          	auipc	a0,0x45
    800045d4:	47050513          	addi	a0,a0,1136 # 80049a40 <ftable>
    800045d8:	dc6fc0ef          	jal	80000b9e <initlock>
}
    800045dc:	60a2                	ld	ra,8(sp)
    800045de:	6402                	ld	s0,0(sp)
    800045e0:	0141                	addi	sp,sp,16
    800045e2:	8082                	ret

00000000800045e4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800045e4:	1101                	addi	sp,sp,-32
    800045e6:	ec06                	sd	ra,24(sp)
    800045e8:	e822                	sd	s0,16(sp)
    800045ea:	e426                	sd	s1,8(sp)
    800045ec:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800045ee:	00045517          	auipc	a0,0x45
    800045f2:	45250513          	addi	a0,a0,1106 # 80049a40 <ftable>
    800045f6:	e32fc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800045fa:	00045497          	auipc	s1,0x45
    800045fe:	45e48493          	addi	s1,s1,1118 # 80049a58 <ftable+0x18>
    80004602:	00046717          	auipc	a4,0x46
    80004606:	3f670713          	addi	a4,a4,1014 # 8004a9f8 <disk>
    if(f->ref == 0){
    8000460a:	40dc                	lw	a5,4(s1)
    8000460c:	cf89                	beqz	a5,80004626 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000460e:	02848493          	addi	s1,s1,40
    80004612:	fee49ce3          	bne	s1,a4,8000460a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004616:	00045517          	auipc	a0,0x45
    8000461a:	42a50513          	addi	a0,a0,1066 # 80049a40 <ftable>
    8000461e:	e9efc0ef          	jal	80000cbc <release>
  return 0;
    80004622:	4481                	li	s1,0
    80004624:	a809                	j	80004636 <filealloc+0x52>
      f->ref = 1;
    80004626:	4785                	li	a5,1
    80004628:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000462a:	00045517          	auipc	a0,0x45
    8000462e:	41650513          	addi	a0,a0,1046 # 80049a40 <ftable>
    80004632:	e8afc0ef          	jal	80000cbc <release>
}
    80004636:	8526                	mv	a0,s1
    80004638:	60e2                	ld	ra,24(sp)
    8000463a:	6442                	ld	s0,16(sp)
    8000463c:	64a2                	ld	s1,8(sp)
    8000463e:	6105                	addi	sp,sp,32
    80004640:	8082                	ret

0000000080004642 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004642:	1101                	addi	sp,sp,-32
    80004644:	ec06                	sd	ra,24(sp)
    80004646:	e822                	sd	s0,16(sp)
    80004648:	e426                	sd	s1,8(sp)
    8000464a:	1000                	addi	s0,sp,32
    8000464c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000464e:	00045517          	auipc	a0,0x45
    80004652:	3f250513          	addi	a0,a0,1010 # 80049a40 <ftable>
    80004656:	dd2fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    8000465a:	40dc                	lw	a5,4(s1)
    8000465c:	02f05063          	blez	a5,8000467c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004660:	2785                	addiw	a5,a5,1
    80004662:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004664:	00045517          	auipc	a0,0x45
    80004668:	3dc50513          	addi	a0,a0,988 # 80049a40 <ftable>
    8000466c:	e50fc0ef          	jal	80000cbc <release>
  return f;
}
    80004670:	8526                	mv	a0,s1
    80004672:	60e2                	ld	ra,24(sp)
    80004674:	6442                	ld	s0,16(sp)
    80004676:	64a2                	ld	s1,8(sp)
    80004678:	6105                	addi	sp,sp,32
    8000467a:	8082                	ret
    panic("filedup");
    8000467c:	00004517          	auipc	a0,0x4
    80004680:	0dc50513          	addi	a0,a0,220 # 80008758 <etext+0x758>
    80004684:	9a0fc0ef          	jal	80000824 <panic>

0000000080004688 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004688:	7139                	addi	sp,sp,-64
    8000468a:	fc06                	sd	ra,56(sp)
    8000468c:	f822                	sd	s0,48(sp)
    8000468e:	f426                	sd	s1,40(sp)
    80004690:	0080                	addi	s0,sp,64
    80004692:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004694:	00045517          	auipc	a0,0x45
    80004698:	3ac50513          	addi	a0,a0,940 # 80049a40 <ftable>
    8000469c:	d8cfc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    800046a0:	40dc                	lw	a5,4(s1)
    800046a2:	04f05a63          	blez	a5,800046f6 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800046a6:	37fd                	addiw	a5,a5,-1
    800046a8:	c0dc                	sw	a5,4(s1)
    800046aa:	06f04063          	bgtz	a5,8000470a <fileclose+0x82>
    800046ae:	f04a                	sd	s2,32(sp)
    800046b0:	ec4e                	sd	s3,24(sp)
    800046b2:	e852                	sd	s4,16(sp)
    800046b4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800046b6:	0004a903          	lw	s2,0(s1)
    800046ba:	0094c783          	lbu	a5,9(s1)
    800046be:	89be                	mv	s3,a5
    800046c0:	689c                	ld	a5,16(s1)
    800046c2:	8a3e                	mv	s4,a5
    800046c4:	6c9c                	ld	a5,24(s1)
    800046c6:	8abe                	mv	s5,a5
  f->ref = 0;
    800046c8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800046cc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800046d0:	00045517          	auipc	a0,0x45
    800046d4:	37050513          	addi	a0,a0,880 # 80049a40 <ftable>
    800046d8:	de4fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    800046dc:	4785                	li	a5,1
    800046de:	04f90163          	beq	s2,a5,80004720 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800046e2:	ffe9079b          	addiw	a5,s2,-2
    800046e6:	4705                	li	a4,1
    800046e8:	04f77563          	bgeu	a4,a5,80004732 <fileclose+0xaa>
    800046ec:	7902                	ld	s2,32(sp)
    800046ee:	69e2                	ld	s3,24(sp)
    800046f0:	6a42                	ld	s4,16(sp)
    800046f2:	6aa2                	ld	s5,8(sp)
    800046f4:	a00d                	j	80004716 <fileclose+0x8e>
    800046f6:	f04a                	sd	s2,32(sp)
    800046f8:	ec4e                	sd	s3,24(sp)
    800046fa:	e852                	sd	s4,16(sp)
    800046fc:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800046fe:	00004517          	auipc	a0,0x4
    80004702:	06250513          	addi	a0,a0,98 # 80008760 <etext+0x760>
    80004706:	91efc0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    8000470a:	00045517          	auipc	a0,0x45
    8000470e:	33650513          	addi	a0,a0,822 # 80049a40 <ftable>
    80004712:	daafc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004716:	70e2                	ld	ra,56(sp)
    80004718:	7442                	ld	s0,48(sp)
    8000471a:	74a2                	ld	s1,40(sp)
    8000471c:	6121                	addi	sp,sp,64
    8000471e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004720:	85ce                	mv	a1,s3
    80004722:	8552                	mv	a0,s4
    80004724:	348000ef          	jal	80004a6c <pipeclose>
    80004728:	7902                	ld	s2,32(sp)
    8000472a:	69e2                	ld	s3,24(sp)
    8000472c:	6a42                	ld	s4,16(sp)
    8000472e:	6aa2                	ld	s5,8(sp)
    80004730:	b7dd                	j	80004716 <fileclose+0x8e>
    begin_op();
    80004732:	b33ff0ef          	jal	80004264 <begin_op>
    iput(ff.ip);
    80004736:	8556                	mv	a0,s5
    80004738:	aa2ff0ef          	jal	800039da <iput>
    end_op();
    8000473c:	b99ff0ef          	jal	800042d4 <end_op>
    80004740:	7902                	ld	s2,32(sp)
    80004742:	69e2                	ld	s3,24(sp)
    80004744:	6a42                	ld	s4,16(sp)
    80004746:	6aa2                	ld	s5,8(sp)
    80004748:	b7f9                	j	80004716 <fileclose+0x8e>

000000008000474a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000474a:	715d                	addi	sp,sp,-80
    8000474c:	e486                	sd	ra,72(sp)
    8000474e:	e0a2                	sd	s0,64(sp)
    80004750:	fc26                	sd	s1,56(sp)
    80004752:	f052                	sd	s4,32(sp)
    80004754:	0880                	addi	s0,sp,80
    80004756:	84aa                	mv	s1,a0
    80004758:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000475a:	c40fd0ef          	jal	80001b9a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000475e:	409c                	lw	a5,0(s1)
    80004760:	37f9                	addiw	a5,a5,-2
    80004762:	4705                	li	a4,1
    80004764:	04f76263          	bltu	a4,a5,800047a8 <filestat+0x5e>
    80004768:	f84a                	sd	s2,48(sp)
    8000476a:	f44e                	sd	s3,40(sp)
    8000476c:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000476e:	6c88                	ld	a0,24(s1)
    80004770:	8e8ff0ef          	jal	80003858 <ilock>
    stati(f->ip, &st);
    80004774:	fb840913          	addi	s2,s0,-72
    80004778:	85ca                	mv	a1,s2
    8000477a:	6c88                	ld	a0,24(s1)
    8000477c:	c40ff0ef          	jal	80003bbc <stati>
    iunlock(f->ip);
    80004780:	6c88                	ld	a0,24(s1)
    80004782:	984ff0ef          	jal	80003906 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004786:	46e1                	li	a3,24
    80004788:	864a                	mv	a2,s2
    8000478a:	85d2                	mv	a1,s4
    8000478c:	0509b503          	ld	a0,80(s3)
    80004790:	824fd0ef          	jal	800017b4 <copyout>
    80004794:	41f5551b          	sraiw	a0,a0,0x1f
    80004798:	7942                	ld	s2,48(sp)
    8000479a:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000479c:	60a6                	ld	ra,72(sp)
    8000479e:	6406                	ld	s0,64(sp)
    800047a0:	74e2                	ld	s1,56(sp)
    800047a2:	7a02                	ld	s4,32(sp)
    800047a4:	6161                	addi	sp,sp,80
    800047a6:	8082                	ret
  return -1;
    800047a8:	557d                	li	a0,-1
    800047aa:	bfcd                	j	8000479c <filestat+0x52>

00000000800047ac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800047ac:	7179                	addi	sp,sp,-48
    800047ae:	f406                	sd	ra,40(sp)
    800047b0:	f022                	sd	s0,32(sp)
    800047b2:	e84a                	sd	s2,16(sp)
    800047b4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800047b6:	00854783          	lbu	a5,8(a0)
    800047ba:	cfd1                	beqz	a5,80004856 <fileread+0xaa>
    800047bc:	ec26                	sd	s1,24(sp)
    800047be:	e44e                	sd	s3,8(sp)
    800047c0:	84aa                	mv	s1,a0
    800047c2:	892e                	mv	s2,a1
    800047c4:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800047c6:	411c                	lw	a5,0(a0)
    800047c8:	4705                	li	a4,1
    800047ca:	04e78363          	beq	a5,a4,80004810 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047ce:	470d                	li	a4,3
    800047d0:	04e78763          	beq	a5,a4,8000481e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800047d4:	4709                	li	a4,2
    800047d6:	06e79a63          	bne	a5,a4,8000484a <fileread+0x9e>
    ilock(f->ip);
    800047da:	6d08                	ld	a0,24(a0)
    800047dc:	87cff0ef          	jal	80003858 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800047e0:	874e                	mv	a4,s3
    800047e2:	5094                	lw	a3,32(s1)
    800047e4:	864a                	mv	a2,s2
    800047e6:	4585                	li	a1,1
    800047e8:	6c88                	ld	a0,24(s1)
    800047ea:	c00ff0ef          	jal	80003bea <readi>
    800047ee:	892a                	mv	s2,a0
    800047f0:	00a05563          	blez	a0,800047fa <fileread+0x4e>
      f->off += r;
    800047f4:	509c                	lw	a5,32(s1)
    800047f6:	9fa9                	addw	a5,a5,a0
    800047f8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800047fa:	6c88                	ld	a0,24(s1)
    800047fc:	90aff0ef          	jal	80003906 <iunlock>
    80004800:	64e2                	ld	s1,24(sp)
    80004802:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004804:	854a                	mv	a0,s2
    80004806:	70a2                	ld	ra,40(sp)
    80004808:	7402                	ld	s0,32(sp)
    8000480a:	6942                	ld	s2,16(sp)
    8000480c:	6145                	addi	sp,sp,48
    8000480e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004810:	6908                	ld	a0,16(a0)
    80004812:	3b0000ef          	jal	80004bc2 <piperead>
    80004816:	892a                	mv	s2,a0
    80004818:	64e2                	ld	s1,24(sp)
    8000481a:	69a2                	ld	s3,8(sp)
    8000481c:	b7e5                	j	80004804 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000481e:	02451783          	lh	a5,36(a0)
    80004822:	03079693          	slli	a3,a5,0x30
    80004826:	92c1                	srli	a3,a3,0x30
    80004828:	4725                	li	a4,9
    8000482a:	02d76963          	bltu	a4,a3,8000485c <fileread+0xb0>
    8000482e:	0792                	slli	a5,a5,0x4
    80004830:	00045717          	auipc	a4,0x45
    80004834:	17070713          	addi	a4,a4,368 # 800499a0 <devsw>
    80004838:	97ba                	add	a5,a5,a4
    8000483a:	639c                	ld	a5,0(a5)
    8000483c:	c78d                	beqz	a5,80004866 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    8000483e:	4505                	li	a0,1
    80004840:	9782                	jalr	a5
    80004842:	892a                	mv	s2,a0
    80004844:	64e2                	ld	s1,24(sp)
    80004846:	69a2                	ld	s3,8(sp)
    80004848:	bf75                	j	80004804 <fileread+0x58>
    panic("fileread");
    8000484a:	00004517          	auipc	a0,0x4
    8000484e:	f2650513          	addi	a0,a0,-218 # 80008770 <etext+0x770>
    80004852:	fd3fb0ef          	jal	80000824 <panic>
    return -1;
    80004856:	57fd                	li	a5,-1
    80004858:	893e                	mv	s2,a5
    8000485a:	b76d                	j	80004804 <fileread+0x58>
      return -1;
    8000485c:	57fd                	li	a5,-1
    8000485e:	893e                	mv	s2,a5
    80004860:	64e2                	ld	s1,24(sp)
    80004862:	69a2                	ld	s3,8(sp)
    80004864:	b745                	j	80004804 <fileread+0x58>
    80004866:	57fd                	li	a5,-1
    80004868:	893e                	mv	s2,a5
    8000486a:	64e2                	ld	s1,24(sp)
    8000486c:	69a2                	ld	s3,8(sp)
    8000486e:	bf59                	j	80004804 <fileread+0x58>

0000000080004870 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004870:	00954783          	lbu	a5,9(a0)
    80004874:	10078f63          	beqz	a5,80004992 <filewrite+0x122>
{
    80004878:	711d                	addi	sp,sp,-96
    8000487a:	ec86                	sd	ra,88(sp)
    8000487c:	e8a2                	sd	s0,80(sp)
    8000487e:	e0ca                	sd	s2,64(sp)
    80004880:	f456                	sd	s5,40(sp)
    80004882:	f05a                	sd	s6,32(sp)
    80004884:	1080                	addi	s0,sp,96
    80004886:	892a                	mv	s2,a0
    80004888:	8b2e                	mv	s6,a1
    8000488a:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000488c:	411c                	lw	a5,0(a0)
    8000488e:	4705                	li	a4,1
    80004890:	02e78a63          	beq	a5,a4,800048c4 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004894:	470d                	li	a4,3
    80004896:	02e78b63          	beq	a5,a4,800048cc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000489a:	4709                	li	a4,2
    8000489c:	0ce79f63          	bne	a5,a4,8000497a <filewrite+0x10a>
    800048a0:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800048a2:	0ac05a63          	blez	a2,80004956 <filewrite+0xe6>
    800048a6:	e4a6                	sd	s1,72(sp)
    800048a8:	fc4e                	sd	s3,56(sp)
    800048aa:	ec5e                	sd	s7,24(sp)
    800048ac:	e862                	sd	s8,16(sp)
    800048ae:	e466                	sd	s9,8(sp)
    int i = 0;
    800048b0:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800048b2:	6b85                	lui	s7,0x1
    800048b4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800048b8:	6785                	lui	a5,0x1
    800048ba:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800048be:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800048c0:	4c05                	li	s8,1
    800048c2:	a8ad                	j	8000493c <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800048c4:	6908                	ld	a0,16(a0)
    800048c6:	204000ef          	jal	80004aca <pipewrite>
    800048ca:	a04d                	j	8000496c <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800048cc:	02451783          	lh	a5,36(a0)
    800048d0:	03079693          	slli	a3,a5,0x30
    800048d4:	92c1                	srli	a3,a3,0x30
    800048d6:	4725                	li	a4,9
    800048d8:	0ad76f63          	bltu	a4,a3,80004996 <filewrite+0x126>
    800048dc:	0792                	slli	a5,a5,0x4
    800048de:	00045717          	auipc	a4,0x45
    800048e2:	0c270713          	addi	a4,a4,194 # 800499a0 <devsw>
    800048e6:	97ba                	add	a5,a5,a4
    800048e8:	679c                	ld	a5,8(a5)
    800048ea:	cbc5                	beqz	a5,8000499a <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800048ec:	4505                	li	a0,1
    800048ee:	9782                	jalr	a5
    800048f0:	a8b5                	j	8000496c <filewrite+0xfc>
      if(n1 > max)
    800048f2:	2981                	sext.w	s3,s3
      begin_op();
    800048f4:	971ff0ef          	jal	80004264 <begin_op>
      ilock(f->ip);
    800048f8:	01893503          	ld	a0,24(s2)
    800048fc:	f5dfe0ef          	jal	80003858 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004900:	874e                	mv	a4,s3
    80004902:	02092683          	lw	a3,32(s2)
    80004906:	016a0633          	add	a2,s4,s6
    8000490a:	85e2                	mv	a1,s8
    8000490c:	01893503          	ld	a0,24(s2)
    80004910:	bccff0ef          	jal	80003cdc <writei>
    80004914:	84aa                	mv	s1,a0
    80004916:	00a05763          	blez	a0,80004924 <filewrite+0xb4>
        f->off += r;
    8000491a:	02092783          	lw	a5,32(s2)
    8000491e:	9fa9                	addw	a5,a5,a0
    80004920:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004924:	01893503          	ld	a0,24(s2)
    80004928:	fdffe0ef          	jal	80003906 <iunlock>
      end_op();
    8000492c:	9a9ff0ef          	jal	800042d4 <end_op>

      if(r != n1){
    80004930:	02999563          	bne	s3,s1,8000495a <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004934:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004938:	015a5963          	bge	s4,s5,8000494a <filewrite+0xda>
      int n1 = n - i;
    8000493c:	414a87bb          	subw	a5,s5,s4
    80004940:	89be                	mv	s3,a5
      if(n1 > max)
    80004942:	fafbd8e3          	bge	s7,a5,800048f2 <filewrite+0x82>
    80004946:	89e6                	mv	s3,s9
    80004948:	b76d                	j	800048f2 <filewrite+0x82>
    8000494a:	64a6                	ld	s1,72(sp)
    8000494c:	79e2                	ld	s3,56(sp)
    8000494e:	6be2                	ld	s7,24(sp)
    80004950:	6c42                	ld	s8,16(sp)
    80004952:	6ca2                	ld	s9,8(sp)
    80004954:	a801                	j	80004964 <filewrite+0xf4>
    int i = 0;
    80004956:	4a01                	li	s4,0
    80004958:	a031                	j	80004964 <filewrite+0xf4>
    8000495a:	64a6                	ld	s1,72(sp)
    8000495c:	79e2                	ld	s3,56(sp)
    8000495e:	6be2                	ld	s7,24(sp)
    80004960:	6c42                	ld	s8,16(sp)
    80004962:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004964:	034a9d63          	bne	s5,s4,8000499e <filewrite+0x12e>
    80004968:	8556                	mv	a0,s5
    8000496a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000496c:	60e6                	ld	ra,88(sp)
    8000496e:	6446                	ld	s0,80(sp)
    80004970:	6906                	ld	s2,64(sp)
    80004972:	7aa2                	ld	s5,40(sp)
    80004974:	7b02                	ld	s6,32(sp)
    80004976:	6125                	addi	sp,sp,96
    80004978:	8082                	ret
    8000497a:	e4a6                	sd	s1,72(sp)
    8000497c:	fc4e                	sd	s3,56(sp)
    8000497e:	f852                	sd	s4,48(sp)
    80004980:	ec5e                	sd	s7,24(sp)
    80004982:	e862                	sd	s8,16(sp)
    80004984:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004986:	00004517          	auipc	a0,0x4
    8000498a:	dfa50513          	addi	a0,a0,-518 # 80008780 <etext+0x780>
    8000498e:	e97fb0ef          	jal	80000824 <panic>
    return -1;
    80004992:	557d                	li	a0,-1
}
    80004994:	8082                	ret
      return -1;
    80004996:	557d                	li	a0,-1
    80004998:	bfd1                	j	8000496c <filewrite+0xfc>
    8000499a:	557d                	li	a0,-1
    8000499c:	bfc1                	j	8000496c <filewrite+0xfc>
    ret = (i == n ? n : -1);
    8000499e:	557d                	li	a0,-1
    800049a0:	7a42                	ld	s4,48(sp)
    800049a2:	b7e9                	j	8000496c <filewrite+0xfc>

00000000800049a4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800049a4:	7179                	addi	sp,sp,-48
    800049a6:	f406                	sd	ra,40(sp)
    800049a8:	f022                	sd	s0,32(sp)
    800049aa:	ec26                	sd	s1,24(sp)
    800049ac:	e052                	sd	s4,0(sp)
    800049ae:	1800                	addi	s0,sp,48
    800049b0:	84aa                	mv	s1,a0
    800049b2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800049b4:	0005b023          	sd	zero,0(a1)
    800049b8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800049bc:	c29ff0ef          	jal	800045e4 <filealloc>
    800049c0:	e088                	sd	a0,0(s1)
    800049c2:	c549                	beqz	a0,80004a4c <pipealloc+0xa8>
    800049c4:	c21ff0ef          	jal	800045e4 <filealloc>
    800049c8:	00aa3023          	sd	a0,0(s4)
    800049cc:	cd25                	beqz	a0,80004a44 <pipealloc+0xa0>
    800049ce:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800049d0:	974fc0ef          	jal	80000b44 <kalloc>
    800049d4:	892a                	mv	s2,a0
    800049d6:	c12d                	beqz	a0,80004a38 <pipealloc+0x94>
    800049d8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800049da:	4985                	li	s3,1
    800049dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800049e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800049e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800049e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800049ec:	00004597          	auipc	a1,0x4
    800049f0:	da458593          	addi	a1,a1,-604 # 80008790 <etext+0x790>
    800049f4:	9aafc0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    800049f8:	609c                	ld	a5,0(s1)
    800049fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049fe:	609c                	ld	a5,0(s1)
    80004a00:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a04:	609c                	ld	a5,0(s1)
    80004a06:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a0a:	609c                	ld	a5,0(s1)
    80004a0c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a10:	000a3783          	ld	a5,0(s4)
    80004a14:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a18:	000a3783          	ld	a5,0(s4)
    80004a1c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004a20:	000a3783          	ld	a5,0(s4)
    80004a24:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004a28:	000a3783          	ld	a5,0(s4)
    80004a2c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004a30:	4501                	li	a0,0
    80004a32:	6942                	ld	s2,16(sp)
    80004a34:	69a2                	ld	s3,8(sp)
    80004a36:	a01d                	j	80004a5c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004a38:	6088                	ld	a0,0(s1)
    80004a3a:	c119                	beqz	a0,80004a40 <pipealloc+0x9c>
    80004a3c:	6942                	ld	s2,16(sp)
    80004a3e:	a029                	j	80004a48 <pipealloc+0xa4>
    80004a40:	6942                	ld	s2,16(sp)
    80004a42:	a029                	j	80004a4c <pipealloc+0xa8>
    80004a44:	6088                	ld	a0,0(s1)
    80004a46:	c10d                	beqz	a0,80004a68 <pipealloc+0xc4>
    fileclose(*f0);
    80004a48:	c41ff0ef          	jal	80004688 <fileclose>
  if(*f1)
    80004a4c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004a50:	557d                	li	a0,-1
  if(*f1)
    80004a52:	c789                	beqz	a5,80004a5c <pipealloc+0xb8>
    fileclose(*f1);
    80004a54:	853e                	mv	a0,a5
    80004a56:	c33ff0ef          	jal	80004688 <fileclose>
  return -1;
    80004a5a:	557d                	li	a0,-1
}
    80004a5c:	70a2                	ld	ra,40(sp)
    80004a5e:	7402                	ld	s0,32(sp)
    80004a60:	64e2                	ld	s1,24(sp)
    80004a62:	6a02                	ld	s4,0(sp)
    80004a64:	6145                	addi	sp,sp,48
    80004a66:	8082                	ret
  return -1;
    80004a68:	557d                	li	a0,-1
    80004a6a:	bfcd                	j	80004a5c <pipealloc+0xb8>

0000000080004a6c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a6c:	1101                	addi	sp,sp,-32
    80004a6e:	ec06                	sd	ra,24(sp)
    80004a70:	e822                	sd	s0,16(sp)
    80004a72:	e426                	sd	s1,8(sp)
    80004a74:	e04a                	sd	s2,0(sp)
    80004a76:	1000                	addi	s0,sp,32
    80004a78:	84aa                	mv	s1,a0
    80004a7a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a7c:	9acfc0ef          	jal	80000c28 <acquire>
  if(writable){
    80004a80:	02090763          	beqz	s2,80004aae <pipeclose+0x42>
    pi->writeopen = 0;
    80004a84:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a88:	21848513          	addi	a0,s1,536
    80004a8c:	809fd0ef          	jal	80002294 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a90:	2204a783          	lw	a5,544(s1)
    80004a94:	e781                	bnez	a5,80004a9c <pipeclose+0x30>
    80004a96:	2244a783          	lw	a5,548(s1)
    80004a9a:	c38d                	beqz	a5,80004abc <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	a1efc0ef          	jal	80000cbc <release>
}
    80004aa2:	60e2                	ld	ra,24(sp)
    80004aa4:	6442                	ld	s0,16(sp)
    80004aa6:	64a2                	ld	s1,8(sp)
    80004aa8:	6902                	ld	s2,0(sp)
    80004aaa:	6105                	addi	sp,sp,32
    80004aac:	8082                	ret
    pi->readopen = 0;
    80004aae:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004ab2:	21c48513          	addi	a0,s1,540
    80004ab6:	fdefd0ef          	jal	80002294 <wakeup>
    80004aba:	bfd9                	j	80004a90 <pipeclose+0x24>
    release(&pi->lock);
    80004abc:	8526                	mv	a0,s1
    80004abe:	9fefc0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004ac2:	8526                	mv	a0,s1
    80004ac4:	f99fb0ef          	jal	80000a5c <kfree>
    80004ac8:	bfe9                	j	80004aa2 <pipeclose+0x36>

0000000080004aca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004aca:	7159                	addi	sp,sp,-112
    80004acc:	f486                	sd	ra,104(sp)
    80004ace:	f0a2                	sd	s0,96(sp)
    80004ad0:	eca6                	sd	s1,88(sp)
    80004ad2:	e8ca                	sd	s2,80(sp)
    80004ad4:	e4ce                	sd	s3,72(sp)
    80004ad6:	e0d2                	sd	s4,64(sp)
    80004ad8:	fc56                	sd	s5,56(sp)
    80004ada:	1880                	addi	s0,sp,112
    80004adc:	84aa                	mv	s1,a0
    80004ade:	8aae                	mv	s5,a1
    80004ae0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004ae2:	8b8fd0ef          	jal	80001b9a <myproc>
    80004ae6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	93efc0ef          	jal	80000c28 <acquire>
  while(i < n){
    80004aee:	0d405263          	blez	s4,80004bb2 <pipewrite+0xe8>
    80004af2:	f85a                	sd	s6,48(sp)
    80004af4:	f45e                	sd	s7,40(sp)
    80004af6:	f062                	sd	s8,32(sp)
    80004af8:	ec66                	sd	s9,24(sp)
    80004afa:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004afc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004afe:	f9f40c13          	addi	s8,s0,-97
    80004b02:	4b85                	li	s7,1
    80004b04:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b06:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b0a:	21c48c93          	addi	s9,s1,540
    80004b0e:	a82d                	j	80004b48 <pipewrite+0x7e>
      release(&pi->lock);
    80004b10:	8526                	mv	a0,s1
    80004b12:	9aafc0ef          	jal	80000cbc <release>
      return -1;
    80004b16:	597d                	li	s2,-1
    80004b18:	7b42                	ld	s6,48(sp)
    80004b1a:	7ba2                	ld	s7,40(sp)
    80004b1c:	7c02                	ld	s8,32(sp)
    80004b1e:	6ce2                	ld	s9,24(sp)
    80004b20:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004b22:	854a                	mv	a0,s2
    80004b24:	70a6                	ld	ra,104(sp)
    80004b26:	7406                	ld	s0,96(sp)
    80004b28:	64e6                	ld	s1,88(sp)
    80004b2a:	6946                	ld	s2,80(sp)
    80004b2c:	69a6                	ld	s3,72(sp)
    80004b2e:	6a06                	ld	s4,64(sp)
    80004b30:	7ae2                	ld	s5,56(sp)
    80004b32:	6165                	addi	sp,sp,112
    80004b34:	8082                	ret
      wakeup(&pi->nread);
    80004b36:	856a                	mv	a0,s10
    80004b38:	f5cfd0ef          	jal	80002294 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b3c:	85a6                	mv	a1,s1
    80004b3e:	8566                	mv	a0,s9
    80004b40:	f08fd0ef          	jal	80002248 <sleep>
  while(i < n){
    80004b44:	05495a63          	bge	s2,s4,80004b98 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004b48:	2204a783          	lw	a5,544(s1)
    80004b4c:	d3f1                	beqz	a5,80004b10 <pipewrite+0x46>
    80004b4e:	854e                	mv	a0,s3
    80004b50:	ae7fd0ef          	jal	80002636 <killed>
    80004b54:	fd55                	bnez	a0,80004b10 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004b56:	2184a783          	lw	a5,536(s1)
    80004b5a:	21c4a703          	lw	a4,540(s1)
    80004b5e:	2007879b          	addiw	a5,a5,512
    80004b62:	fcf70ae3          	beq	a4,a5,80004b36 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b66:	86de                	mv	a3,s7
    80004b68:	01590633          	add	a2,s2,s5
    80004b6c:	85e2                	mv	a1,s8
    80004b6e:	0509b503          	ld	a0,80(s3)
    80004b72:	d0bfc0ef          	jal	8000187c <copyin>
    80004b76:	05650063          	beq	a0,s6,80004bb6 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b7a:	21c4a783          	lw	a5,540(s1)
    80004b7e:	0017871b          	addiw	a4,a5,1
    80004b82:	20e4ae23          	sw	a4,540(s1)
    80004b86:	1ff7f793          	andi	a5,a5,511
    80004b8a:	97a6                	add	a5,a5,s1
    80004b8c:	f9f44703          	lbu	a4,-97(s0)
    80004b90:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b94:	2905                	addiw	s2,s2,1
    80004b96:	b77d                	j	80004b44 <pipewrite+0x7a>
    80004b98:	7b42                	ld	s6,48(sp)
    80004b9a:	7ba2                	ld	s7,40(sp)
    80004b9c:	7c02                	ld	s8,32(sp)
    80004b9e:	6ce2                	ld	s9,24(sp)
    80004ba0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004ba2:	21848513          	addi	a0,s1,536
    80004ba6:	eeefd0ef          	jal	80002294 <wakeup>
  release(&pi->lock);
    80004baa:	8526                	mv	a0,s1
    80004bac:	910fc0ef          	jal	80000cbc <release>
  return i;
    80004bb0:	bf8d                	j	80004b22 <pipewrite+0x58>
  int i = 0;
    80004bb2:	4901                	li	s2,0
    80004bb4:	b7fd                	j	80004ba2 <pipewrite+0xd8>
    80004bb6:	7b42                	ld	s6,48(sp)
    80004bb8:	7ba2                	ld	s7,40(sp)
    80004bba:	7c02                	ld	s8,32(sp)
    80004bbc:	6ce2                	ld	s9,24(sp)
    80004bbe:	6d42                	ld	s10,16(sp)
    80004bc0:	b7cd                	j	80004ba2 <pipewrite+0xd8>

0000000080004bc2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004bc2:	711d                	addi	sp,sp,-96
    80004bc4:	ec86                	sd	ra,88(sp)
    80004bc6:	e8a2                	sd	s0,80(sp)
    80004bc8:	e4a6                	sd	s1,72(sp)
    80004bca:	e0ca                	sd	s2,64(sp)
    80004bcc:	fc4e                	sd	s3,56(sp)
    80004bce:	f852                	sd	s4,48(sp)
    80004bd0:	f456                	sd	s5,40(sp)
    80004bd2:	1080                	addi	s0,sp,96
    80004bd4:	84aa                	mv	s1,a0
    80004bd6:	892e                	mv	s2,a1
    80004bd8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004bda:	fc1fc0ef          	jal	80001b9a <myproc>
    80004bde:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004be0:	8526                	mv	a0,s1
    80004be2:	846fc0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004be6:	2184a703          	lw	a4,536(s1)
    80004bea:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bee:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bf2:	02f71763          	bne	a4,a5,80004c20 <piperead+0x5e>
    80004bf6:	2244a783          	lw	a5,548(s1)
    80004bfa:	cf85                	beqz	a5,80004c32 <piperead+0x70>
    if(killed(pr)){
    80004bfc:	8552                	mv	a0,s4
    80004bfe:	a39fd0ef          	jal	80002636 <killed>
    80004c02:	e11d                	bnez	a0,80004c28 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c04:	85a6                	mv	a1,s1
    80004c06:	854e                	mv	a0,s3
    80004c08:	e40fd0ef          	jal	80002248 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c0c:	2184a703          	lw	a4,536(s1)
    80004c10:	21c4a783          	lw	a5,540(s1)
    80004c14:	fef701e3          	beq	a4,a5,80004bf6 <piperead+0x34>
    80004c18:	f05a                	sd	s6,32(sp)
    80004c1a:	ec5e                	sd	s7,24(sp)
    80004c1c:	e862                	sd	s8,16(sp)
    80004c1e:	a829                	j	80004c38 <piperead+0x76>
    80004c20:	f05a                	sd	s6,32(sp)
    80004c22:	ec5e                	sd	s7,24(sp)
    80004c24:	e862                	sd	s8,16(sp)
    80004c26:	a809                	j	80004c38 <piperead+0x76>
      release(&pi->lock);
    80004c28:	8526                	mv	a0,s1
    80004c2a:	892fc0ef          	jal	80000cbc <release>
      return -1;
    80004c2e:	59fd                	li	s3,-1
    80004c30:	a0a5                	j	80004c98 <piperead+0xd6>
    80004c32:	f05a                	sd	s6,32(sp)
    80004c34:	ec5e                	sd	s7,24(sp)
    80004c36:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c38:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004c3a:	faf40c13          	addi	s8,s0,-81
    80004c3e:	4b85                	li	s7,1
    80004c40:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c42:	05505163          	blez	s5,80004c84 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80004c46:	2184a783          	lw	a5,536(s1)
    80004c4a:	21c4a703          	lw	a4,540(s1)
    80004c4e:	02f70b63          	beq	a4,a5,80004c84 <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    80004c52:	1ff7f793          	andi	a5,a5,511
    80004c56:	97a6                	add	a5,a5,s1
    80004c58:	0187c783          	lbu	a5,24(a5)
    80004c5c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004c60:	86de                	mv	a3,s7
    80004c62:	8662                	mv	a2,s8
    80004c64:	85ca                	mv	a1,s2
    80004c66:	050a3503          	ld	a0,80(s4)
    80004c6a:	b4bfc0ef          	jal	800017b4 <copyout>
    80004c6e:	03650f63          	beq	a0,s6,80004cac <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004c72:	2184a783          	lw	a5,536(s1)
    80004c76:	2785                	addiw	a5,a5,1
    80004c78:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c7c:	2985                	addiw	s3,s3,1
    80004c7e:	0905                	addi	s2,s2,1
    80004c80:	fd3a93e3          	bne	s5,s3,80004c46 <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c84:	21c48513          	addi	a0,s1,540
    80004c88:	e0cfd0ef          	jal	80002294 <wakeup>
  release(&pi->lock);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	82efc0ef          	jal	80000cbc <release>
    80004c92:	7b02                	ld	s6,32(sp)
    80004c94:	6be2                	ld	s7,24(sp)
    80004c96:	6c42                	ld	s8,16(sp)
  return i;
}
    80004c98:	854e                	mv	a0,s3
    80004c9a:	60e6                	ld	ra,88(sp)
    80004c9c:	6446                	ld	s0,80(sp)
    80004c9e:	64a6                	ld	s1,72(sp)
    80004ca0:	6906                	ld	s2,64(sp)
    80004ca2:	79e2                	ld	s3,56(sp)
    80004ca4:	7a42                	ld	s4,48(sp)
    80004ca6:	7aa2                	ld	s5,40(sp)
    80004ca8:	6125                	addi	sp,sp,96
    80004caa:	8082                	ret
      if(i == 0)
    80004cac:	fc099ce3          	bnez	s3,80004c84 <piperead+0xc2>
        i = -1;
    80004cb0:	89aa                	mv	s3,a0
    80004cb2:	bfc9                	j	80004c84 <piperead+0xc2>

0000000080004cb4 <ulazymalloc>:


uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
uint64 a;

  if(va_end < va_start)
    80004cb4:	04b66a63          	bltu	a2,a1,80004d08 <ulazymalloc+0x54>
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
    80004cb8:	7139                	addi	sp,sp,-64
    80004cba:	fc06                	sd	ra,56(sp)
    80004cbc:	f822                	sd	s0,48(sp)
    80004cbe:	f426                	sd	s1,40(sp)
    80004cc0:	f04a                	sd	s2,32(sp)
    80004cc2:	e852                	sd	s4,16(sp)
    80004cc4:	0080                	addi	s0,sp,64
    80004cc6:	8a2a                	mv	s4,a0
    80004cc8:	8932                	mv	s2,a2
    return va_start;

  va_start = PGROUNDUP(va_start);
    80004cca:	6785                	lui	a5,0x1
    80004ccc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004cce:	95be                	add	a1,a1,a5
    80004cd0:	77fd                	lui	a5,0xfffff
    80004cd2:	00f5f4b3          	and	s1,a1,a5
  for(a = va_start; a < va_end; a += PGSIZE){
    80004cd6:	02c4fb63          	bgeu	s1,a2,80004d0c <ulazymalloc+0x58>
    80004cda:	ec4e                	sd	s3,24(sp)
    80004cdc:	e456                	sd	s5,8(sp)
    80004cde:	e05a                	sd	s6,0(sp)
    pte_t *pte = walk(pagetable, a, 1);
    80004ce0:	4a85                	li	s5,1
      // In case of failure, we don't have a simple way to deallocate just this segment,
      // so we let kexec handle the full cleanup.
      return 0;
    }
    // Mark as User-accessible with given permissions, but NOT valid (PTE_V=0).
    *pte = PTE_U | xperm;
    80004ce2:	0106e993          	ori	s3,a3,16
  for(a = va_start; a < va_end; a += PGSIZE){
    80004ce6:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable, a, 1);
    80004ce8:	8656                	mv	a2,s5
    80004cea:	85a6                	mv	a1,s1
    80004cec:	8552                	mv	a0,s4
    80004cee:	a9efc0ef          	jal	80000f8c <walk>
    if(pte == 0){
    80004cf2:	cd19                	beqz	a0,80004d10 <ulazymalloc+0x5c>
    *pte = PTE_U | xperm;
    80004cf4:	01353023          	sd	s3,0(a0)
  for(a = va_start; a < va_end; a += PGSIZE){
    80004cf8:	94da                	add	s1,s1,s6
    80004cfa:	ff24e7e3          	bltu	s1,s2,80004ce8 <ulazymalloc+0x34>
  }
  return va_end;
    80004cfe:	854a                	mv	a0,s2
    80004d00:	69e2                	ld	s3,24(sp)
    80004d02:	6aa2                	ld	s5,8(sp)
    80004d04:	6b02                	ld	s6,0(sp)
    80004d06:	a801                	j	80004d16 <ulazymalloc+0x62>
    return va_start;
    80004d08:	852e                	mv	a0,a1
    }
    80004d0a:	8082                	ret
  return va_end;
    80004d0c:	8532                	mv	a0,a2
    80004d0e:	a021                	j	80004d16 <ulazymalloc+0x62>
    80004d10:	69e2                	ld	s3,24(sp)
    80004d12:	6aa2                	ld	s5,8(sp)
    80004d14:	6b02                	ld	s6,0(sp)
    }
    80004d16:	70e2                	ld	ra,56(sp)
    80004d18:	7442                	ld	s0,48(sp)
    80004d1a:	74a2                	ld	s1,40(sp)
    80004d1c:	7902                	ld	s2,32(sp)
    80004d1e:	6a42                	ld	s4,16(sp)
    80004d20:	6121                	addi	sp,sp,64
    80004d22:	8082                	ret

0000000080004d24 <flags2perm>:
// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004d24:	1141                	addi	sp,sp,-16
    80004d26:	e406                	sd	ra,8(sp)
    80004d28:	e022                	sd	s0,0(sp)
    80004d2a:	0800                	addi	s0,sp,16
    80004d2c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004d2e:	0035151b          	slliw	a0,a0,0x3
    80004d32:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004d34:	0027f713          	andi	a4,a5,2
    80004d38:	c319                	beqz	a4,80004d3e <flags2perm+0x1a>
      perm |= PTE_W;
    80004d3a:	00456513          	ori	a0,a0,4
    if(flags & ELF_PROG_FLAG_READ)
    80004d3e:	8b91                	andi	a5,a5,4
    80004d40:	c399                	beqz	a5,80004d46 <flags2perm+0x22>
      perm |= PTE_R;
    80004d42:	00256513          	ori	a0,a0,2
    return perm;
}
    80004d46:	60a2                	ld	ra,8(sp)
    80004d48:	6402                	ld	s0,0(sp)
    80004d4a:	0141                	addi	sp,sp,16
    80004d4c:	8082                	ret

0000000080004d4e <kexec>:
//
// In kernel/exec.c, replace the existing kexec function

int
kexec(char *path, char **argv)
{
    80004d4e:	db010113          	addi	sp,sp,-592
    80004d52:	24113423          	sd	ra,584(sp)
    80004d56:	24813023          	sd	s0,576(sp)
    80004d5a:	22913c23          	sd	s1,568(sp)
    80004d5e:	23213823          	sd	s2,560(sp)
    80004d62:	23413023          	sd	s4,544(sp)
    80004d66:	21613823          	sd	s6,528(sp)
    80004d6a:	0c80                	addi	s0,sp,592
    80004d6c:	84aa                	mv	s1,a0
    80004d6e:	8b2a                	mv	s6,a0
    80004d70:	8a2e                	mv	s4,a1
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d72:	e29fc0ef          	jal	80001b9a <myproc>
    80004d76:	892a                	mv	s2,a0
  uint64 text_start = -1, text_end = 0;
  uint64 data_start = -1, data_end = 0;


  begin_op();
    80004d78:	cecff0ef          	jal	80004264 <begin_op>

  if((ip = namei(path)) == 0){
    80004d7c:	8526                	mv	a0,s1
    80004d7e:	b08ff0ef          	jal	80004086 <namei>
    80004d82:	12050a63          	beqz	a0,80004eb6 <kexec+0x168>
    80004d86:	23313423          	sd	s3,552(sp)
    80004d8a:	84aa                	mv	s1,a0
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
    80004d8c:	acdfe0ef          	jal	80003858 <ilock>
  p->exec_ip = idup(ip);
    80004d90:	8526                	mv	a0,s1
    80004d92:	a91fe0ef          	jal	80003822 <idup>
    80004d96:	16a93823          	sd	a0,368(s2)
  char swap_path[32];
  char pid_str[10];
  
  // Copy the base path "/pgswp"
  safestrcpy(swap_path, "/pgswp", sizeof(swap_path));
    80004d9a:	02000613          	li	a2,32
    80004d9e:	00004597          	auipc	a1,0x4
    80004da2:	a2258593          	addi	a1,a1,-1502 # 800087c0 <etext+0x7c0>
    80004da6:	df840513          	addi	a0,s0,-520
    80004daa:	8a2fc0ef          	jal	80000e4c <safestrcpy>
  
  // Convert PID to string
  itoa(p->pid, pid_str);
    80004dae:	03092683          	lw	a3,48(s2)
  if (n == 0) {
    80004db2:	10068c63          	beqz	a3,80004eca <kexec+0x17c>
    80004db6:	dd840513          	addi	a0,s0,-552
    80004dba:	85aa                	mv	a1,a0
  int i = 0;
    80004dbc:	4601                	li	a2,0
    temp[i++] = (n % 10) + '0';
    80004dbe:	666668b7          	lui	a7,0x66666
    80004dc2:	66788893          	addi	a7,a7,1639 # 66666667 <_entry-0x19999999>
  } while (n > 0);
    80004dc6:	4325                	li	t1,9
    temp[i++] = (n % 10) + '0';
    80004dc8:	8832                	mv	a6,a2
    80004dca:	2605                	addiw	a2,a2,1
    80004dcc:	03168733          	mul	a4,a3,a7
    80004dd0:	9709                	srai	a4,a4,0x22
    80004dd2:	41f6d79b          	sraiw	a5,a3,0x1f
    80004dd6:	9f1d                	subw	a4,a4,a5
    80004dd8:	0027179b          	slliw	a5,a4,0x2
    80004ddc:	9fb9                	addw	a5,a5,a4
    80004dde:	0017979b          	slliw	a5,a5,0x1
    80004de2:	40f687bb          	subw	a5,a3,a5
    80004de6:	0307879b          	addiw	a5,a5,48 # fffffffffffff030 <end+0xffffffff7ffb44f8>
    80004dea:	00f58023          	sb	a5,0(a1)
    n /= 10;
    80004dee:	87b6                	mv	a5,a3
    80004df0:	86ba                	mv	a3,a4
  } while (n > 0);
    80004df2:	0585                	addi	a1,a1,1
    80004df4:	fcf34ae3          	blt	t1,a5,80004dc8 <kexec+0x7a>
  for (int j = i - 1; j >= 0; j--) {
    80004df8:	0e084063          	bltz	a6,80004ed8 <kexec+0x18a>
    80004dfc:	00a80733          	add	a4,a6,a0
    80004e00:	de840793          	addi	a5,s0,-536
    80004e04:	02081693          	slli	a3,a6,0x20
    80004e08:	9281                	srli	a3,a3,0x20
    80004e0a:	de940613          	addi	a2,s0,-535
    80004e0e:	9636                	add	a2,a2,a3
    buf[k++] = temp[j];
    80004e10:	00074683          	lbu	a3,0(a4)
    80004e14:	00d78023          	sb	a3,0(a5)
  for (int j = i - 1; j >= 0; j--) {
    80004e18:	177d                	addi	a4,a4,-1
    80004e1a:	0785                	addi	a5,a5,1
    80004e1c:	fef61ae3          	bne	a2,a5,80004e10 <kexec+0xc2>
    80004e20:	2805                	addiw	a6,a6,1
  buf[k] = '\0';
    80004e22:	fd080793          	addi	a5,a6,-48
    80004e26:	fc040713          	addi	a4,s0,-64
    80004e2a:	00e78833          	add	a6,a5,a4
    80004e2e:	e4080c23          	sb	zero,-424(a6)
  
  // Manually append the PID string to the path
  char *ptr = swap_path + strlen(swap_path);
    80004e32:	df840993          	addi	s3,s0,-520
    80004e36:	854e                	mv	a0,s3
    80004e38:	84afc0ef          	jal	80000e82 <strlen>
    80004e3c:	954e                	add	a0,a0,s3
  char *s1 = pid_str;
  while(*s1) {
    80004e3e:	de844783          	lbu	a5,-536(s0)
    80004e42:	cb91                	beqz	a5,80004e56 <kexec+0x108>
  char *s1 = pid_str;
    80004e44:	de840713          	addi	a4,s0,-536
    *ptr++ = *s1++;
    80004e48:	0705                	addi	a4,a4,1
    80004e4a:	0505                	addi	a0,a0,1
    80004e4c:	fef50fa3          	sb	a5,-1(a0)
  while(*s1) {
    80004e50:	00074783          	lbu	a5,0(a4)
    80004e54:	fbf5                	bnez	a5,80004e48 <kexec+0xfa>
  }
  *ptr = '\0';
    80004e56:	00050023          	sb	zero,0(a0)
  
  p->swap_file = create(swap_path, T_FILE, 0, 0);
    80004e5a:	4681                	li	a3,0
    80004e5c:	4601                	li	a2,0
    80004e5e:	4589                	li	a1,2
    80004e60:	df840513          	addi	a0,s0,-520
    80004e64:	013000ef          	jal	80005676 <create>
    80004e68:	36a93023          	sd	a0,864(s2)
  if(p->swap_file == 0){
    80004e6c:	c925                	beqz	a0,80004edc <kexec+0x18e>
    iunlockput(ip);
    end_op();
    return -1;
  }
  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004e6e:	04000713          	li	a4,64
    80004e72:	4681                	li	a3,0
    80004e74:	e5040613          	addi	a2,s0,-432
    80004e78:	4581                	li	a1,0
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	d6ffe0ef          	jal	80003bea <readi>
    80004e80:	04000793          	li	a5,64
    80004e84:	06f50563          	beq	a0,a5,80004eee <kexec+0x1a0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004e88:	8526                	mv	a0,s1
    80004e8a:	bdbfe0ef          	jal	80003a64 <iunlockput>
    end_op();
    80004e8e:	c46ff0ef          	jal	800042d4 <end_op>
  }
  return -1;
    80004e92:	557d                	li	a0,-1
    80004e94:	22813983          	ld	s3,552(sp)
}
    80004e98:	24813083          	ld	ra,584(sp)
    80004e9c:	24013403          	ld	s0,576(sp)
    80004ea0:	23813483          	ld	s1,568(sp)
    80004ea4:	23013903          	ld	s2,560(sp)
    80004ea8:	22013a03          	ld	s4,544(sp)
    80004eac:	21013b03          	ld	s6,528(sp)
    80004eb0:	25010113          	addi	sp,sp,592
    80004eb4:	8082                	ret
    end_op();
    80004eb6:	c1eff0ef          	jal	800042d4 <end_op>
    printf("exec checkpoint FAIL: namei failed\n");
    80004eba:	00004517          	auipc	a0,0x4
    80004ebe:	8de50513          	addi	a0,a0,-1826 # 80008798 <etext+0x798>
    80004ec2:	e38fb0ef          	jal	800004fa <printf>
    return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	bfc1                	j	80004e98 <kexec+0x14a>
    buf[0] = '0';
    80004eca:	03000793          	li	a5,48
    80004ece:	def40423          	sb	a5,-536(s0)
    buf[1] = '\0';
    80004ed2:	de0404a3          	sb	zero,-535(s0)
    return;
    80004ed6:	bfb1                	j	80004e32 <kexec+0xe4>
  int k = 0;
    80004ed8:	4801                	li	a6,0
    80004eda:	b7a1                	j	80004e22 <kexec+0xd4>
    iunlockput(ip);
    80004edc:	8526                	mv	a0,s1
    80004ede:	b87fe0ef          	jal	80003a64 <iunlockput>
    end_op();
    80004ee2:	bf2ff0ef          	jal	800042d4 <end_op>
    return -1;
    80004ee6:	557d                	li	a0,-1
    80004ee8:	22813983          	ld	s3,552(sp)
    80004eec:	b775                	j	80004e98 <kexec+0x14a>
  p->num_phdrs = elf.phnum;
    80004eee:	e8845783          	lhu	a5,-376(s0)
    80004ef2:	76f92423          	sw	a5,1896(s2)
  if(readi(ip, 0, (uint64)p->phdrs, elf.phoff, sizeof(struct proghdr) * p->num_phdrs) != sizeof(struct proghdr) * p->num_phdrs)
    80004ef6:	0037971b          	slliw	a4,a5,0x3
    80004efa:	9f1d                	subw	a4,a4,a5
    80004efc:	0037171b          	slliw	a4,a4,0x3
    80004f00:	e7042683          	lw	a3,-400(s0)
    80004f04:	77090613          	addi	a2,s2,1904
    80004f08:	4581                	li	a1,0
    80004f0a:	8526                	mv	a0,s1
    80004f0c:	cdffe0ef          	jal	80003bea <readi>
    80004f10:	76892703          	lw	a4,1896(s2)
    80004f14:	00371793          	slli	a5,a4,0x3
    80004f18:	8f99                	sub	a5,a5,a4
    80004f1a:	078e                	slli	a5,a5,0x3
    80004f1c:	f6f516e3          	bne	a0,a5,80004e88 <kexec+0x13a>
  if(elf.magic != ELF_MAGIC)
    80004f20:	e5042703          	lw	a4,-432(s0)
    80004f24:	464c47b7          	lui	a5,0x464c4
    80004f28:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004f2c:	f4f71ee3          	bne	a4,a5,80004e88 <kexec+0x13a>
    80004f30:	ffe6                	sd	s9,504(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004f32:	854a                	mv	a0,s2
    80004f34:	db5fc0ef          	jal	80001ce8 <proc_pagetable>
    80004f38:	8caa                	mv	s9,a0
    80004f3a:	2a050563          	beqz	a0,800051e4 <kexec+0x496>
    80004f3e:	21513c23          	sd	s5,536(sp)
    80004f42:	21713423          	sd	s7,520(sp)
    80004f46:	21813023          	sd	s8,512(sp)
    80004f4a:	fbea                	sd	s10,496(sp)
    80004f4c:	f7ee                	sd	s11,488(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f4e:	e8845783          	lhu	a5,-376(s0)
    80004f52:	c3f5                	beqz	a5,80005036 <kexec+0x2e8>
    80004f54:	e7042683          	lw	a3,-400(s0)
  uint64 data_start = -1, data_end = 0;
    80004f58:	da043c23          	sd	zero,-584(s0)
    80004f5c:	57fd                	li	a5,-1
    80004f5e:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    80004f62:	dc043023          	sd	zero,-576(s0)
    80004f66:	8dbe                	mv	s11,a5
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004f68:	4c01                	li	s8,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f6a:	4981                	li	s3,0
    if(ph.vaddr % PGSIZE != 0)
    80004f6c:	6785                	lui	a5,0x1
    80004f6e:	97ee                	add	a5,a5,s11
    80004f70:	8d3e                	mv	s10,a5
    80004f72:	a089                	j	80004fb4 <kexec+0x266>
        if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    80004f74:	8dca                	mv	s11,s2
        if (ph.vaddr + ph.memsz > text_end) text_end = ph.vaddr + ph.memsz;
    80004f76:	dc043703          	ld	a4,-576(s0)
    80004f7a:	01777463          	bgeu	a4,s7,80004f82 <kexec+0x234>
    80004f7e:	dd743023          	sd	s7,-576(s0)
    if((ulazymalloc(pagetable, ph.vaddr, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f82:	da3ff0ef          	jal	80004d24 <flags2perm>
    80004f86:	86aa                	mv	a3,a0
    80004f88:	865e                	mv	a2,s7
    80004f8a:	85ca                	mv	a1,s2
    80004f8c:	8566                	mv	a0,s9
    80004f8e:	d27ff0ef          	jal	80004cb4 <ulazymalloc>
    80004f92:	24050b63          	beqz	a0,800051e8 <kexec+0x49a>
    if(ph.vaddr + ph.memsz > sz)
    80004f96:	e2843783          	ld	a5,-472(s0)
    80004f9a:	e4043703          	ld	a4,-448(s0)
    80004f9e:	97ba                	add	a5,a5,a4
    80004fa0:	00fc7363          	bgeu	s8,a5,80004fa6 <kexec+0x258>
    80004fa4:	8c3e                	mv	s8,a5
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004fa6:	2985                	addiw	s3,s3,1
    80004fa8:	038a869b          	addiw	a3,s5,56
    80004fac:	e8845783          	lhu	a5,-376(s0)
    80004fb0:	08f9dc63          	bge	s3,a5,80005048 <kexec+0x2fa>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004fb4:	8ab6                	mv	s5,a3
    80004fb6:	03800713          	li	a4,56
    80004fba:	e1840613          	addi	a2,s0,-488
    80004fbe:	4581                	li	a1,0
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	c29fe0ef          	jal	80003bea <readi>
    80004fc6:	03800793          	li	a5,56
    80004fca:	20f51f63          	bne	a0,a5,800051e8 <kexec+0x49a>
    if(ph.type != ELF_PROG_LOAD)
    80004fce:	e1842783          	lw	a5,-488(s0)
    80004fd2:	4705                	li	a4,1
    80004fd4:	fce799e3          	bne	a5,a4,80004fa6 <kexec+0x258>
    if(ph.memsz < ph.filesz)
    80004fd8:	e4043783          	ld	a5,-448(s0)
    80004fdc:	e3843703          	ld	a4,-456(s0)
    80004fe0:	20e7e463          	bltu	a5,a4,800051e8 <kexec+0x49a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fe4:	e2843903          	ld	s2,-472(s0)
    80004fe8:	97ca                	add	a5,a5,s2
    80004fea:	8bbe                	mv	s7,a5
    80004fec:	1f27ee63          	bltu	a5,s2,800051e8 <kexec+0x49a>
    if(ph.vaddr % PGSIZE != 0)
    80004ff0:	01a977b3          	and	a5,s2,s10
    80004ff4:	1e079a63          	bnez	a5,800051e8 <kexec+0x49a>
     if (ph.flags & ELF_PROG_FLAG_EXEC) { // Text segment
    80004ff8:	e1c42503          	lw	a0,-484(s0)
    80004ffc:	00157793          	andi	a5,a0,1
    80005000:	cb81                	beqz	a5,80005010 <kexec+0x2c2>
        if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    80005002:	577d                	li	a4,-1
    80005004:	f6ed88e3          	beq	s11,a4,80004f74 <kexec+0x226>
    80005008:	f7b977e3          	bgeu	s2,s11,80004f76 <kexec+0x228>
    8000500c:	8dca                	mv	s11,s2
    8000500e:	b7a5                	j	80004f76 <kexec+0x228>
        if (data_start == -1 || ph.vaddr < data_start) data_start = ph.vaddr;
    80005010:	dc843783          	ld	a5,-568(s0)
    80005014:	577d                	li	a4,-1
    80005016:	00e78763          	beq	a5,a4,80005024 <kexec+0x2d6>
    8000501a:	00f97763          	bgeu	s2,a5,80005028 <kexec+0x2da>
    8000501e:	dd243423          	sd	s2,-568(s0)
    80005022:	a019                	j	80005028 <kexec+0x2da>
    80005024:	dd243423          	sd	s2,-568(s0)
        if (ph.vaddr + ph.memsz > data_end) data_end = ph.vaddr + ph.memsz;
    80005028:	db843703          	ld	a4,-584(s0)
    8000502c:	f5777be3          	bgeu	a4,s7,80004f82 <kexec+0x234>
    80005030:	db743c23          	sd	s7,-584(s0)
    80005034:	b7b9                	j	80004f82 <kexec+0x234>
  uint64 data_start = -1, data_end = 0;
    80005036:	da043c23          	sd	zero,-584(s0)
    8000503a:	57fd                	li	a5,-1
    8000503c:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    80005040:	dc043023          	sd	zero,-576(s0)
    80005044:	8dbe                	mv	s11,a5
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005046:	4c01                	li	s8,0
  iunlockput(ip);
    80005048:	8526                	mv	a0,s1
    8000504a:	a1bfe0ef          	jal	80003a64 <iunlockput>
  end_op();
    8000504e:	a86ff0ef          	jal	800042d4 <end_op>
  p = myproc();
    80005052:	b49fc0ef          	jal	80001b9a <myproc>
    80005056:	89aa                	mv	s3,a0
    80005058:	8d2a                	mv	s10,a0
  uint64 oldsz = p->sz;
    8000505a:	653c                	ld	a5,72(a0)
    8000505c:	daf43823          	sd	a5,-592(s0)
  p->heap_start = sz;
    80005060:	17853423          	sd	s8,360(a0)
  sz = PGROUNDUP(sz);
    80005064:	6485                	lui	s1,0x1
    80005066:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    80005068:	94e2                	add	s1,s1,s8
    8000506a:	77fd                	lui	a5,0xfffff
    8000506c:	8cfd                	and	s1,s1,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000506e:	4691                	li	a3,4
    80005070:	6609                	lui	a2,0x2
    80005072:	9626                	add	a2,a2,s1
    80005074:	85a6                	mv	a1,s1
    80005076:	8566                	mv	a0,s9
    80005078:	d26fc0ef          	jal	8000159e <uvmalloc>
    8000507c:	8baa                	mv	s7,a0
    8000507e:	e11d                	bnez	a0,800050a4 <kexec+0x356>
  sz = PGROUNDUP(sz);
    80005080:	8ba6                	mv	s7,s1
    proc_freepagetable(pagetable, sz);
    80005082:	85de                	mv	a1,s7
    80005084:	8566                	mv	a0,s9
    80005086:	ce7fc0ef          	jal	80001d6c <proc_freepagetable>
  return -1;
    8000508a:	557d                	li	a0,-1
    8000508c:	22813983          	ld	s3,552(sp)
    80005090:	21813a83          	ld	s5,536(sp)
    80005094:	20813b83          	ld	s7,520(sp)
    80005098:	20013c03          	ld	s8,512(sp)
    8000509c:	7cfe                	ld	s9,504(sp)
    8000509e:	7d5e                	ld	s10,496(sp)
    800050a0:	7dbe                	ld	s11,488(sp)
    800050a2:	bbdd                	j	80004e98 <kexec+0x14a>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800050a4:	75f9                	lui	a1,0xffffe
    800050a6:	95aa                	add	a1,a1,a0
    800050a8:	8566                	mv	a0,s9
    800050aa:	ee0fc0ef          	jal	8000178a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800050ae:	800b8713          	addi	a4,s7,-2048
    800050b2:	80070713          	addi	a4,a4,-2048
    800050b6:	8aba                	mv	s5,a4
  printf("[pid %d] INIT-LAZYMAP text=[0x%lx,0x%lx) data=[0x%lx,0x%lx) heap_start=0x%lx stack_top=0x%lx\n",
    800050b8:	895e                	mv	s2,s7
    800050ba:	88de                	mv	a7,s7
    800050bc:	1689b803          	ld	a6,360(s3)
    800050c0:	db843783          	ld	a5,-584(s0)
    800050c4:	dc843703          	ld	a4,-568(s0)
    800050c8:	dc043683          	ld	a3,-576(s0)
    800050cc:	866e                	mv	a2,s11
    800050ce:	0309a583          	lw	a1,48(s3)
    800050d2:	00003517          	auipc	a0,0x3
    800050d6:	6f650513          	addi	a0,a0,1782 # 800087c8 <etext+0x7c8>
    800050da:	c20fb0ef          	jal	800004fa <printf>
  for(argc = 0; argv[argc]; argc++) {
    800050de:	000a3503          	ld	a0,0(s4)
    800050e2:	4481                	li	s1,0
    800050e4:	c939                	beqz	a0,8000513a <kexec+0x3ec>
    sp -= strlen(argv[argc]) + 1;
    800050e6:	d9dfb0ef          	jal	80000e82 <strlen>
    800050ea:	0015079b          	addiw	a5,a0,1
    800050ee:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800050f2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800050f6:	f95966e3          	bltu	s2,s5,80005082 <kexec+0x334>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800050fa:	000a3983          	ld	s3,0(s4)
    800050fe:	854e                	mv	a0,s3
    80005100:	d83fb0ef          	jal	80000e82 <strlen>
    80005104:	0015069b          	addiw	a3,a0,1
    80005108:	864e                	mv	a2,s3
    8000510a:	85ca                	mv	a1,s2
    8000510c:	8566                	mv	a0,s9
    8000510e:	ea6fc0ef          	jal	800017b4 <copyout>
    80005112:	f60548e3          	bltz	a0,80005082 <kexec+0x334>
    ustack[argc] = sp;
    80005116:	00349793          	slli	a5,s1,0x3
    8000511a:	e9040713          	addi	a4,s0,-368
    8000511e:	97ba                	add	a5,a5,a4
    80005120:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffb44c8>
  for(argc = 0; argv[argc]; argc++) {
    80005124:	0485                	addi	s1,s1,1
    80005126:	008a0793          	addi	a5,s4,8
    8000512a:	8a3e                	mv	s4,a5
    8000512c:	6388                	ld	a0,0(a5)
    8000512e:	c511                	beqz	a0,8000513a <kexec+0x3ec>
    if(argc >= MAXARG)
    80005130:	02000793          	li	a5,32
    80005134:	faf499e3          	bne	s1,a5,800050e6 <kexec+0x398>
    80005138:	b7a9                	j	80005082 <kexec+0x334>
  ustack[argc] = 0;
    8000513a:	00349793          	slli	a5,s1,0x3
    8000513e:	fd078793          	addi	a5,a5,-48
    80005142:	fc040713          	addi	a4,s0,-64
    80005146:	97ba                	add	a5,a5,a4
    80005148:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000514c:	00349693          	slli	a3,s1,0x3
    80005150:	06a1                	addi	a3,a3,8
    80005152:	40d907b3          	sub	a5,s2,a3
  sp -= sp % 16;
    80005156:	ff07f913          	andi	s2,a5,-16
  if(sp < stackbase)
    8000515a:	f35964e3          	bltu	s2,s5,80005082 <kexec+0x334>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000515e:	e9040613          	addi	a2,s0,-368
    80005162:	85ca                	mv	a1,s2
    80005164:	8566                	mv	a0,s9
    80005166:	e4efc0ef          	jal	800017b4 <copyout>
    8000516a:	f0054ce3          	bltz	a0,80005082 <kexec+0x334>
  p->trapframe->a1 = sp;
    8000516e:	058d3783          	ld	a5,88(s10)
    80005172:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005176:	000b4703          	lbu	a4,0(s6) # 1000 <_entry-0x7ffff000>
    8000517a:	cf11                	beqz	a4,80005196 <kexec+0x448>
    8000517c:	001b0793          	addi	a5,s6,1
    if(*s == '/')
    80005180:	02f00693          	li	a3,47
    80005184:	a029                	j	8000518e <kexec+0x440>
  for(last=s=path; *s; s++)
    80005186:	0785                	addi	a5,a5,1
    80005188:	fff7c703          	lbu	a4,-1(a5)
    8000518c:	c709                	beqz	a4,80005196 <kexec+0x448>
    if(*s == '/')
    8000518e:	fed71ce3          	bne	a4,a3,80005186 <kexec+0x438>
      last = s+1;
    80005192:	8b3e                	mv	s6,a5
    80005194:	bfcd                	j	80005186 <kexec+0x438>
  safestrcpy(p->name, last, sizeof(p->name));
    80005196:	4641                	li	a2,16
    80005198:	85da                	mv	a1,s6
    8000519a:	158d0513          	addi	a0,s10,344
    8000519e:	caffb0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    800051a2:	050d3503          	ld	a0,80(s10)
  p->pagetable = pagetable;
    800051a6:	059d3823          	sd	s9,80(s10)
  p->sz = sz;
    800051aa:	057d3423          	sd	s7,72(s10)
  p->trapframe->epc = elf.entry;
    800051ae:	058d3783          	ld	a5,88(s10)
    800051b2:	e6843703          	ld	a4,-408(s0)
    800051b6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;
    800051b8:	058d3783          	ld	a5,88(s10)
    800051bc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800051c0:	db043583          	ld	a1,-592(s0)
    800051c4:	ba9fc0ef          	jal	80001d6c <proc_freepagetable>
  return argc;
    800051c8:	0004851b          	sext.w	a0,s1
    800051cc:	22813983          	ld	s3,552(sp)
    800051d0:	21813a83          	ld	s5,536(sp)
    800051d4:	20813b83          	ld	s7,520(sp)
    800051d8:	20013c03          	ld	s8,512(sp)
    800051dc:	7cfe                	ld	s9,504(sp)
    800051de:	7d5e                	ld	s10,496(sp)
    800051e0:	7dbe                	ld	s11,488(sp)
    800051e2:	b95d                	j	80004e98 <kexec+0x14a>
    800051e4:	7cfe                	ld	s9,504(sp)
    800051e6:	b14d                	j	80004e88 <kexec+0x13a>
    proc_freepagetable(pagetable, sz);
    800051e8:	85e2                	mv	a1,s8
    800051ea:	8566                	mv	a0,s9
    800051ec:	b81fc0ef          	jal	80001d6c <proc_freepagetable>
  if(ip){
    800051f0:	21813a83          	ld	s5,536(sp)
    800051f4:	20813b83          	ld	s7,520(sp)
    800051f8:	20013c03          	ld	s8,512(sp)
    800051fc:	7cfe                	ld	s9,504(sp)
    800051fe:	7d5e                	ld	s10,496(sp)
    80005200:	7dbe                	ld	s11,488(sp)
    80005202:	b159                	j	80004e88 <kexec+0x13a>

0000000080005204 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005204:	7179                	addi	sp,sp,-48
    80005206:	f406                	sd	ra,40(sp)
    80005208:	f022                	sd	s0,32(sp)
    8000520a:	ec26                	sd	s1,24(sp)
    8000520c:	e84a                	sd	s2,16(sp)
    8000520e:	1800                	addi	s0,sp,48
    80005210:	892e                	mv	s2,a1
    80005212:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005214:	fdc40593          	addi	a1,s0,-36
    80005218:	c53fd0ef          	jal	80002e6a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000521c:	fdc42703          	lw	a4,-36(s0)
    80005220:	47bd                	li	a5,15
    80005222:	02e7ea63          	bltu	a5,a4,80005256 <argfd+0x52>
    80005226:	975fc0ef          	jal	80001b9a <myproc>
    8000522a:	fdc42703          	lw	a4,-36(s0)
    8000522e:	00371793          	slli	a5,a4,0x3
    80005232:	0d078793          	addi	a5,a5,208
    80005236:	953e                	add	a0,a0,a5
    80005238:	611c                	ld	a5,0(a0)
    8000523a:	c385                	beqz	a5,8000525a <argfd+0x56>
    return -1;
  if(pfd)
    8000523c:	00090463          	beqz	s2,80005244 <argfd+0x40>
    *pfd = fd;
    80005240:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005244:	4501                	li	a0,0
  if(pf)
    80005246:	c091                	beqz	s1,8000524a <argfd+0x46>
    *pf = f;
    80005248:	e09c                	sd	a5,0(s1)
}
    8000524a:	70a2                	ld	ra,40(sp)
    8000524c:	7402                	ld	s0,32(sp)
    8000524e:	64e2                	ld	s1,24(sp)
    80005250:	6942                	ld	s2,16(sp)
    80005252:	6145                	addi	sp,sp,48
    80005254:	8082                	ret
    return -1;
    80005256:	557d                	li	a0,-1
    80005258:	bfcd                	j	8000524a <argfd+0x46>
    8000525a:	557d                	li	a0,-1
    8000525c:	b7fd                	j	8000524a <argfd+0x46>

000000008000525e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000525e:	1101                	addi	sp,sp,-32
    80005260:	ec06                	sd	ra,24(sp)
    80005262:	e822                	sd	s0,16(sp)
    80005264:	e426                	sd	s1,8(sp)
    80005266:	1000                	addi	s0,sp,32
    80005268:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000526a:	931fc0ef          	jal	80001b9a <myproc>
    8000526e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005270:	0d050793          	addi	a5,a0,208
    80005274:	4501                	li	a0,0
    80005276:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005278:	6398                	ld	a4,0(a5)
    8000527a:	cb19                	beqz	a4,80005290 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000527c:	2505                	addiw	a0,a0,1
    8000527e:	07a1                	addi	a5,a5,8
    80005280:	fed51ce3          	bne	a0,a3,80005278 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005284:	557d                	li	a0,-1
}
    80005286:	60e2                	ld	ra,24(sp)
    80005288:	6442                	ld	s0,16(sp)
    8000528a:	64a2                	ld	s1,8(sp)
    8000528c:	6105                	addi	sp,sp,32
    8000528e:	8082                	ret
      p->ofile[fd] = f;
    80005290:	00351793          	slli	a5,a0,0x3
    80005294:	0d078793          	addi	a5,a5,208
    80005298:	963e                	add	a2,a2,a5
    8000529a:	e204                	sd	s1,0(a2)
      return fd;
    8000529c:	b7ed                	j	80005286 <fdalloc+0x28>

000000008000529e <sys_dup>:

uint64
sys_dup(void)
{
    8000529e:	7179                	addi	sp,sp,-48
    800052a0:	f406                	sd	ra,40(sp)
    800052a2:	f022                	sd	s0,32(sp)
    800052a4:	1800                	addi	s0,sp,48
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    800052a6:	fd840613          	addi	a2,s0,-40
    800052aa:	4581                	li	a1,0
    800052ac:	4501                	li	a0,0
    800052ae:	f57ff0ef          	jal	80005204 <argfd>
    return -1;
    800052b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800052b4:	02054363          	bltz	a0,800052da <sys_dup+0x3c>
    800052b8:	ec26                	sd	s1,24(sp)
    800052ba:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800052bc:	fd843483          	ld	s1,-40(s0)
    800052c0:	8526                	mv	a0,s1
    800052c2:	f9dff0ef          	jal	8000525e <fdalloc>
    800052c6:	892a                	mv	s2,a0
    return -1;
    800052c8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800052ca:	00054d63          	bltz	a0,800052e4 <sys_dup+0x46>
  filedup(f);
    800052ce:	8526                	mv	a0,s1
    800052d0:	b72ff0ef          	jal	80004642 <filedup>
  return fd;
    800052d4:	87ca                	mv	a5,s2
    800052d6:	64e2                	ld	s1,24(sp)
    800052d8:	6942                	ld	s2,16(sp)
}
    800052da:	853e                	mv	a0,a5
    800052dc:	70a2                	ld	ra,40(sp)
    800052de:	7402                	ld	s0,32(sp)
    800052e0:	6145                	addi	sp,sp,48
    800052e2:	8082                	ret
    800052e4:	64e2                	ld	s1,24(sp)
    800052e6:	6942                	ld	s2,16(sp)
    800052e8:	bfcd                	j	800052da <sys_dup+0x3c>

00000000800052ea <sys_read>:

uint64
sys_read(void)
{
    800052ea:	7179                	addi	sp,sp,-48
    800052ec:	f406                	sd	ra,40(sp)
    800052ee:	f022                	sd	s0,32(sp)
    800052f0:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    800052f2:	fd840593          	addi	a1,s0,-40
    800052f6:	4505                	li	a0,1
    800052f8:	b8ffd0ef          	jal	80002e86 <argaddr>
  argint(2, &n);
    800052fc:	fe440593          	addi	a1,s0,-28
    80005300:	4509                	li	a0,2
    80005302:	b69fd0ef          	jal	80002e6a <argint>
  if(argfd(0, 0, &f) < 0)
    80005306:	fe840613          	addi	a2,s0,-24
    8000530a:	4581                	li	a1,0
    8000530c:	4501                	li	a0,0
    8000530e:	ef7ff0ef          	jal	80005204 <argfd>
    80005312:	87aa                	mv	a5,a0
    return -1;
    80005314:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005316:	0007ca63          	bltz	a5,8000532a <sys_read+0x40>
  return fileread(f, p, n);
    8000531a:	fe442603          	lw	a2,-28(s0)
    8000531e:	fd843583          	ld	a1,-40(s0)
    80005322:	fe843503          	ld	a0,-24(s0)
    80005326:	c86ff0ef          	jal	800047ac <fileread>
}
    8000532a:	70a2                	ld	ra,40(sp)
    8000532c:	7402                	ld	s0,32(sp)
    8000532e:	6145                	addi	sp,sp,48
    80005330:	8082                	ret

0000000080005332 <sys_write>:

uint64
sys_write(void)
{
    80005332:	7179                	addi	sp,sp,-48
    80005334:	f406                	sd	ra,40(sp)
    80005336:	f022                	sd	s0,32(sp)
    80005338:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    8000533a:	fd840593          	addi	a1,s0,-40
    8000533e:	4505                	li	a0,1
    80005340:	b47fd0ef          	jal	80002e86 <argaddr>
  argint(2, &n);
    80005344:	fe440593          	addi	a1,s0,-28
    80005348:	4509                	li	a0,2
    8000534a:	b21fd0ef          	jal	80002e6a <argint>
  if(argfd(0, 0, &f) < 0)
    8000534e:	fe840613          	addi	a2,s0,-24
    80005352:	4581                	li	a1,0
    80005354:	4501                	li	a0,0
    80005356:	eafff0ef          	jal	80005204 <argfd>
    8000535a:	87aa                	mv	a5,a0
    return -1;
    8000535c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000535e:	0007ca63          	bltz	a5,80005372 <sys_write+0x40>

  return filewrite(f, p, n);
    80005362:	fe442603          	lw	a2,-28(s0)
    80005366:	fd843583          	ld	a1,-40(s0)
    8000536a:	fe843503          	ld	a0,-24(s0)
    8000536e:	d02ff0ef          	jal	80004870 <filewrite>
}
    80005372:	70a2                	ld	ra,40(sp)
    80005374:	7402                	ld	s0,32(sp)
    80005376:	6145                	addi	sp,sp,48
    80005378:	8082                	ret

000000008000537a <sys_close>:

uint64
sys_close(void)
{
    8000537a:	1101                	addi	sp,sp,-32
    8000537c:	ec06                	sd	ra,24(sp)
    8000537e:	e822                	sd	s0,16(sp)
    80005380:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    80005382:	fe040613          	addi	a2,s0,-32
    80005386:	fec40593          	addi	a1,s0,-20
    8000538a:	4501                	li	a0,0
    8000538c:	e79ff0ef          	jal	80005204 <argfd>
    return -1;
    80005390:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005392:	02054163          	bltz	a0,800053b4 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005396:	805fc0ef          	jal	80001b9a <myproc>
    8000539a:	fec42783          	lw	a5,-20(s0)
    8000539e:	078e                	slli	a5,a5,0x3
    800053a0:	0d078793          	addi	a5,a5,208
    800053a4:	953e                	add	a0,a0,a5
    800053a6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800053aa:	fe043503          	ld	a0,-32(s0)
    800053ae:	adaff0ef          	jal	80004688 <fileclose>
  return 0;
    800053b2:	4781                	li	a5,0
}
    800053b4:	853e                	mv	a0,a5
    800053b6:	60e2                	ld	ra,24(sp)
    800053b8:	6442                	ld	s0,16(sp)
    800053ba:	6105                	addi	sp,sp,32
    800053bc:	8082                	ret

00000000800053be <sys_fstat>:

uint64
sys_fstat(void)
{
    800053be:	1101                	addi	sp,sp,-32
    800053c0:	ec06                	sd	ra,24(sp)
    800053c2:	e822                	sd	s0,16(sp)
    800053c4:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    800053c6:	fe040593          	addi	a1,s0,-32
    800053ca:	4505                	li	a0,1
    800053cc:	abbfd0ef          	jal	80002e86 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800053d0:	fe840613          	addi	a2,s0,-24
    800053d4:	4581                	li	a1,0
    800053d6:	4501                	li	a0,0
    800053d8:	e2dff0ef          	jal	80005204 <argfd>
    800053dc:	87aa                	mv	a5,a0
    return -1;
    800053de:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053e0:	0007c863          	bltz	a5,800053f0 <sys_fstat+0x32>
  return filestat(f, st);
    800053e4:	fe043583          	ld	a1,-32(s0)
    800053e8:	fe843503          	ld	a0,-24(s0)
    800053ec:	b5eff0ef          	jal	8000474a <filestat>
}
    800053f0:	60e2                	ld	ra,24(sp)
    800053f2:	6442                	ld	s0,16(sp)
    800053f4:	6105                	addi	sp,sp,32
    800053f6:	8082                	ret

00000000800053f8 <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    800053f8:	7169                	addi	sp,sp,-304
    800053fa:	f606                	sd	ra,296(sp)
    800053fc:	f222                	sd	s0,288(sp)
    800053fe:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005400:	08000613          	li	a2,128
    80005404:	ed040593          	addi	a1,s0,-304
    80005408:	4501                	li	a0,0
    8000540a:	a99fd0ef          	jal	80002ea2 <argstr>
    return -1;
    8000540e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005410:	0c054e63          	bltz	a0,800054ec <sys_link+0xf4>
    80005414:	08000613          	li	a2,128
    80005418:	f5040593          	addi	a1,s0,-176
    8000541c:	4505                	li	a0,1
    8000541e:	a85fd0ef          	jal	80002ea2 <argstr>
    return -1;
    80005422:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005424:	0c054463          	bltz	a0,800054ec <sys_link+0xf4>
    80005428:	ee26                	sd	s1,280(sp)

  begin_op();
    8000542a:	e3bfe0ef          	jal	80004264 <begin_op>
  if((ip = namei(old)) == 0){
    8000542e:	ed040513          	addi	a0,s0,-304
    80005432:	c55fe0ef          	jal	80004086 <namei>
    80005436:	84aa                	mv	s1,a0
    80005438:	c53d                	beqz	a0,800054a6 <sys_link+0xae>
    end_op();
    return -1;
  }

  ilock(ip);
    8000543a:	c1efe0ef          	jal	80003858 <ilock>
  if(ip->type == T_DIR){
    8000543e:	04449703          	lh	a4,68(s1)
    80005442:	4785                	li	a5,1
    80005444:	06f70663          	beq	a4,a5,800054b0 <sys_link+0xb8>
    80005448:	ea4a                	sd	s2,272(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
    8000544a:	04a4d783          	lhu	a5,74(s1)
    8000544e:	2785                	addiw	a5,a5,1
    80005450:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005454:	8526                	mv	a0,s1
    80005456:	b4efe0ef          	jal	800037a4 <iupdate>
  iunlock(ip);
    8000545a:	8526                	mv	a0,s1
    8000545c:	caafe0ef          	jal	80003906 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    80005460:	fd040593          	addi	a1,s0,-48
    80005464:	f5040513          	addi	a0,s0,-176
    80005468:	c39fe0ef          	jal	800040a0 <nameiparent>
    8000546c:	892a                	mv	s2,a0
    8000546e:	cd21                	beqz	a0,800054c6 <sys_link+0xce>
    goto bad;
  ilock(dp);
    80005470:	be8fe0ef          	jal	80003858 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005474:	854a                	mv	a0,s2
    80005476:	00092703          	lw	a4,0(s2)
    8000547a:	409c                	lw	a5,0(s1)
    8000547c:	04f71263          	bne	a4,a5,800054c0 <sys_link+0xc8>
    80005480:	40d0                	lw	a2,4(s1)
    80005482:	fd040593          	addi	a1,s0,-48
    80005486:	b57fe0ef          	jal	80003fdc <dirlink>
    8000548a:	02054b63          	bltz	a0,800054c0 <sys_link+0xc8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
    8000548e:	854a                	mv	a0,s2
    80005490:	dd4fe0ef          	jal	80003a64 <iunlockput>
  iput(ip);
    80005494:	8526                	mv	a0,s1
    80005496:	d44fe0ef          	jal	800039da <iput>

  end_op();
    8000549a:	e3bfe0ef          	jal	800042d4 <end_op>

  return 0;
    8000549e:	4781                	li	a5,0
    800054a0:	64f2                	ld	s1,280(sp)
    800054a2:	6952                	ld	s2,272(sp)
    800054a4:	a0a1                	j	800054ec <sys_link+0xf4>
    end_op();
    800054a6:	e2ffe0ef          	jal	800042d4 <end_op>
    return -1;
    800054aa:	57fd                	li	a5,-1
    800054ac:	64f2                	ld	s1,280(sp)
    800054ae:	a83d                	j	800054ec <sys_link+0xf4>
    iunlockput(ip);
    800054b0:	8526                	mv	a0,s1
    800054b2:	db2fe0ef          	jal	80003a64 <iunlockput>
    end_op();
    800054b6:	e1ffe0ef          	jal	800042d4 <end_op>
    return -1;
    800054ba:	57fd                	li	a5,-1
    800054bc:	64f2                	ld	s1,280(sp)
    800054be:	a03d                	j	800054ec <sys_link+0xf4>
    iunlockput(dp);
    800054c0:	854a                	mv	a0,s2
    800054c2:	da2fe0ef          	jal	80003a64 <iunlockput>

bad:
  ilock(ip);
    800054c6:	8526                	mv	a0,s1
    800054c8:	b90fe0ef          	jal	80003858 <ilock>
  ip->nlink--;
    800054cc:	04a4d783          	lhu	a5,74(s1)
    800054d0:	37fd                	addiw	a5,a5,-1
    800054d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054d6:	8526                	mv	a0,s1
    800054d8:	accfe0ef          	jal	800037a4 <iupdate>
  iunlockput(ip);
    800054dc:	8526                	mv	a0,s1
    800054de:	d86fe0ef          	jal	80003a64 <iunlockput>
  end_op();
    800054e2:	df3fe0ef          	jal	800042d4 <end_op>
  return -1;
    800054e6:	57fd                	li	a5,-1
    800054e8:	64f2                	ld	s1,280(sp)
    800054ea:	6952                	ld	s2,272(sp)
}
    800054ec:	853e                	mv	a0,a5
    800054ee:	70b2                	ld	ra,296(sp)
    800054f0:	7412                	ld	s0,288(sp)
    800054f2:	6155                	addi	sp,sp,304
    800054f4:	8082                	ret

00000000800054f6 <sys_unlink>:
  return 1;
}

uint64
sys_unlink(void)
{
    800054f6:	7151                	addi	sp,sp,-240
    800054f8:	f586                	sd	ra,232(sp)
    800054fa:	f1a2                	sd	s0,224(sp)
    800054fc:	1980                	addi	s0,sp,240
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    800054fe:	08000613          	li	a2,128
    80005502:	f3040593          	addi	a1,s0,-208
    80005506:	4501                	li	a0,0
    80005508:	99bfd0ef          	jal	80002ea2 <argstr>
    8000550c:	14054d63          	bltz	a0,80005666 <sys_unlink+0x170>
    80005510:	eda6                	sd	s1,216(sp)
    return -1;

  begin_op();
    80005512:	d53fe0ef          	jal	80004264 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005516:	fb040593          	addi	a1,s0,-80
    8000551a:	f3040513          	addi	a0,s0,-208
    8000551e:	b83fe0ef          	jal	800040a0 <nameiparent>
    80005522:	84aa                	mv	s1,a0
    80005524:	c955                	beqz	a0,800055d8 <sys_unlink+0xe2>
    end_op();
    return -1;
  }

  ilock(dp);
    80005526:	b32fe0ef          	jal	80003858 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000552a:	00003597          	auipc	a1,0x3
    8000552e:	2fe58593          	addi	a1,a1,766 # 80008828 <etext+0x828>
    80005532:	fb040513          	addi	a0,s0,-80
    80005536:	8a7fe0ef          	jal	80003ddc <namecmp>
    8000553a:	10050b63          	beqz	a0,80005650 <sys_unlink+0x15a>
    8000553e:	00003597          	auipc	a1,0x3
    80005542:	2f258593          	addi	a1,a1,754 # 80008830 <etext+0x830>
    80005546:	fb040513          	addi	a0,s0,-80
    8000554a:	893fe0ef          	jal	80003ddc <namecmp>
    8000554e:	10050163          	beqz	a0,80005650 <sys_unlink+0x15a>
    80005552:	e9ca                	sd	s2,208(sp)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80005554:	f2c40613          	addi	a2,s0,-212
    80005558:	fb040593          	addi	a1,s0,-80
    8000555c:	8526                	mv	a0,s1
    8000555e:	895fe0ef          	jal	80003df2 <dirlookup>
    80005562:	892a                	mv	s2,a0
    80005564:	0e050563          	beqz	a0,8000564e <sys_unlink+0x158>
    80005568:	e5ce                	sd	s3,200(sp)
    goto bad;
  ilock(ip);
    8000556a:	aeefe0ef          	jal	80003858 <ilock>

  if(ip->nlink < 1)
    8000556e:	04a91783          	lh	a5,74(s2)
    80005572:	06f05863          	blez	a5,800055e2 <sys_unlink+0xec>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005576:	04491703          	lh	a4,68(s2)
    8000557a:	4785                	li	a5,1
    8000557c:	06f70963          	beq	a4,a5,800055ee <sys_unlink+0xf8>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
    80005580:	fc040993          	addi	s3,s0,-64
    80005584:	4641                	li	a2,16
    80005586:	4581                	li	a1,0
    80005588:	854e                	mv	a0,s3
    8000558a:	f6efb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000558e:	4741                	li	a4,16
    80005590:	f2c42683          	lw	a3,-212(s0)
    80005594:	864e                	mv	a2,s3
    80005596:	4581                	li	a1,0
    80005598:	8526                	mv	a0,s1
    8000559a:	f42fe0ef          	jal	80003cdc <writei>
    8000559e:	47c1                	li	a5,16
    800055a0:	08f51863          	bne	a0,a5,80005630 <sys_unlink+0x13a>
    panic("unlink: writei");
  if(ip->type == T_DIR){
    800055a4:	04491703          	lh	a4,68(s2)
    800055a8:	4785                	li	a5,1
    800055aa:	08f70963          	beq	a4,a5,8000563c <sys_unlink+0x146>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
    800055ae:	8526                	mv	a0,s1
    800055b0:	cb4fe0ef          	jal	80003a64 <iunlockput>

  ip->nlink--;
    800055b4:	04a95783          	lhu	a5,74(s2)
    800055b8:	37fd                	addiw	a5,a5,-1
    800055ba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055be:	854a                	mv	a0,s2
    800055c0:	9e4fe0ef          	jal	800037a4 <iupdate>
  iunlockput(ip);
    800055c4:	854a                	mv	a0,s2
    800055c6:	c9efe0ef          	jal	80003a64 <iunlockput>

  end_op();
    800055ca:	d0bfe0ef          	jal	800042d4 <end_op>

  return 0;
    800055ce:	4501                	li	a0,0
    800055d0:	64ee                	ld	s1,216(sp)
    800055d2:	694e                	ld	s2,208(sp)
    800055d4:	69ae                	ld	s3,200(sp)
    800055d6:	a061                	j	8000565e <sys_unlink+0x168>
    end_op();
    800055d8:	cfdfe0ef          	jal	800042d4 <end_op>
    return -1;
    800055dc:	557d                	li	a0,-1
    800055de:	64ee                	ld	s1,216(sp)
    800055e0:	a8bd                	j	8000565e <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	25650513          	addi	a0,a0,598 # 80008838 <etext+0x838>
    800055ea:	a3afb0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055ee:	04c92703          	lw	a4,76(s2)
    800055f2:	02000793          	li	a5,32
    800055f6:	f8e7f5e3          	bgeu	a5,a4,80005580 <sys_unlink+0x8a>
    800055fa:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055fc:	4741                	li	a4,16
    800055fe:	86ce                	mv	a3,s3
    80005600:	f1840613          	addi	a2,s0,-232
    80005604:	4581                	li	a1,0
    80005606:	854a                	mv	a0,s2
    80005608:	de2fe0ef          	jal	80003bea <readi>
    8000560c:	47c1                	li	a5,16
    8000560e:	00f51b63          	bne	a0,a5,80005624 <sys_unlink+0x12e>
    if(de.inum != 0)
    80005612:	f1845783          	lhu	a5,-232(s0)
    80005616:	ebb1                	bnez	a5,8000566a <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005618:	29c1                	addiw	s3,s3,16
    8000561a:	04c92783          	lw	a5,76(s2)
    8000561e:	fcf9efe3          	bltu	s3,a5,800055fc <sys_unlink+0x106>
    80005622:	bfb9                	j	80005580 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005624:	00003517          	auipc	a0,0x3
    80005628:	22c50513          	addi	a0,a0,556 # 80008850 <etext+0x850>
    8000562c:	9f8fb0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80005630:	00003517          	auipc	a0,0x3
    80005634:	23850513          	addi	a0,a0,568 # 80008868 <etext+0x868>
    80005638:	9ecfb0ef          	jal	80000824 <panic>
    dp->nlink--;
    8000563c:	04a4d783          	lhu	a5,74(s1)
    80005640:	37fd                	addiw	a5,a5,-1
    80005642:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005646:	8526                	mv	a0,s1
    80005648:	95cfe0ef          	jal	800037a4 <iupdate>
    8000564c:	b78d                	j	800055ae <sys_unlink+0xb8>
    8000564e:	694e                	ld	s2,208(sp)

bad:
  iunlockput(dp);
    80005650:	8526                	mv	a0,s1
    80005652:	c12fe0ef          	jal	80003a64 <iunlockput>
  end_op();
    80005656:	c7ffe0ef          	jal	800042d4 <end_op>
  return -1;
    8000565a:	557d                	li	a0,-1
    8000565c:	64ee                	ld	s1,216(sp)
}
    8000565e:	70ae                	ld	ra,232(sp)
    80005660:	740e                	ld	s0,224(sp)
    80005662:	616d                	addi	sp,sp,240
    80005664:	8082                	ret
    return -1;
    80005666:	557d                	li	a0,-1
    80005668:	bfdd                	j	8000565e <sys_unlink+0x168>
    iunlockput(ip);
    8000566a:	854a                	mv	a0,s2
    8000566c:	bf8fe0ef          	jal	80003a64 <iunlockput>
    goto bad;
    80005670:	694e                	ld	s2,208(sp)
    80005672:	69ae                	ld	s3,200(sp)
    80005674:	bff1                	j	80005650 <sys_unlink+0x15a>

0000000080005676 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
    80005676:	715d                	addi	sp,sp,-80
    80005678:	e486                	sd	ra,72(sp)
    8000567a:	e0a2                	sd	s0,64(sp)
    8000567c:	fc26                	sd	s1,56(sp)
    8000567e:	f84a                	sd	s2,48(sp)
    80005680:	f44e                	sd	s3,40(sp)
    80005682:	f052                	sd	s4,32(sp)
    80005684:	ec56                	sd	s5,24(sp)
    80005686:	e85a                	sd	s6,16(sp)
    80005688:	0880                	addi	s0,sp,80
    8000568a:	892e                	mv	s2,a1
    8000568c:	8a2e                	mv	s4,a1
    8000568e:	8ab2                	mv	s5,a2
    80005690:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005692:	fb040593          	addi	a1,s0,-80
    80005696:	a0bfe0ef          	jal	800040a0 <nameiparent>
    8000569a:	84aa                	mv	s1,a0
    8000569c:	10050763          	beqz	a0,800057aa <create+0x134>
    return 0;

  ilock(dp);
    800056a0:	9b8fe0ef          	jal	80003858 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800056a4:	4601                	li	a2,0
    800056a6:	fb040593          	addi	a1,s0,-80
    800056aa:	8526                	mv	a0,s1
    800056ac:	f46fe0ef          	jal	80003df2 <dirlookup>
    800056b0:	89aa                	mv	s3,a0
    800056b2:	c131                	beqz	a0,800056f6 <create+0x80>
    iunlockput(dp);
    800056b4:	8526                	mv	a0,s1
    800056b6:	baefe0ef          	jal	80003a64 <iunlockput>
    ilock(ip);
    800056ba:	854e                	mv	a0,s3
    800056bc:	99cfe0ef          	jal	80003858 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800056c0:	4789                	li	a5,2
    800056c2:	02f91563          	bne	s2,a5,800056ec <create+0x76>
    800056c6:	0449d783          	lhu	a5,68(s3)
    800056ca:	37f9                	addiw	a5,a5,-2
    800056cc:	17c2                	slli	a5,a5,0x30
    800056ce:	93c1                	srli	a5,a5,0x30
    800056d0:	4705                	li	a4,1
    800056d2:	00f76d63          	bltu	a4,a5,800056ec <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800056d6:	854e                	mv	a0,s3
    800056d8:	60a6                	ld	ra,72(sp)
    800056da:	6406                	ld	s0,64(sp)
    800056dc:	74e2                	ld	s1,56(sp)
    800056de:	7942                	ld	s2,48(sp)
    800056e0:	79a2                	ld	s3,40(sp)
    800056e2:	7a02                	ld	s4,32(sp)
    800056e4:	6ae2                	ld	s5,24(sp)
    800056e6:	6b42                	ld	s6,16(sp)
    800056e8:	6161                	addi	sp,sp,80
    800056ea:	8082                	ret
    iunlockput(ip);
    800056ec:	854e                	mv	a0,s3
    800056ee:	b76fe0ef          	jal	80003a64 <iunlockput>
    return 0;
    800056f2:	4981                	li	s3,0
    800056f4:	b7cd                	j	800056d6 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    800056f6:	85ca                	mv	a1,s2
    800056f8:	4088                	lw	a0,0(s1)
    800056fa:	feffd0ef          	jal	800036e8 <ialloc>
    800056fe:	892a                	mv	s2,a0
    80005700:	cd15                	beqz	a0,8000573c <create+0xc6>
  ilock(ip);
    80005702:	956fe0ef          	jal	80003858 <ilock>
  ip->major = major;
    80005706:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    8000570a:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    8000570e:	4785                	li	a5,1
    80005710:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005714:	854a                	mv	a0,s2
    80005716:	88efe0ef          	jal	800037a4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000571a:	4705                	li	a4,1
    8000571c:	02ea0463          	beq	s4,a4,80005744 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005720:	00492603          	lw	a2,4(s2)
    80005724:	fb040593          	addi	a1,s0,-80
    80005728:	8526                	mv	a0,s1
    8000572a:	8b3fe0ef          	jal	80003fdc <dirlink>
    8000572e:	06054263          	bltz	a0,80005792 <create+0x11c>
  iunlockput(dp);
    80005732:	8526                	mv	a0,s1
    80005734:	b30fe0ef          	jal	80003a64 <iunlockput>
  return ip;
    80005738:	89ca                	mv	s3,s2
    8000573a:	bf71                	j	800056d6 <create+0x60>
    iunlockput(dp);
    8000573c:	8526                	mv	a0,s1
    8000573e:	b26fe0ef          	jal	80003a64 <iunlockput>
    return 0;
    80005742:	bf51                	j	800056d6 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005744:	00492603          	lw	a2,4(s2)
    80005748:	00003597          	auipc	a1,0x3
    8000574c:	0e058593          	addi	a1,a1,224 # 80008828 <etext+0x828>
    80005750:	854a                	mv	a0,s2
    80005752:	88bfe0ef          	jal	80003fdc <dirlink>
    80005756:	02054e63          	bltz	a0,80005792 <create+0x11c>
    8000575a:	40d0                	lw	a2,4(s1)
    8000575c:	00003597          	auipc	a1,0x3
    80005760:	0d458593          	addi	a1,a1,212 # 80008830 <etext+0x830>
    80005764:	854a                	mv	a0,s2
    80005766:	877fe0ef          	jal	80003fdc <dirlink>
    8000576a:	02054463          	bltz	a0,80005792 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000576e:	00492603          	lw	a2,4(s2)
    80005772:	fb040593          	addi	a1,s0,-80
    80005776:	8526                	mv	a0,s1
    80005778:	865fe0ef          	jal	80003fdc <dirlink>
    8000577c:	00054b63          	bltz	a0,80005792 <create+0x11c>
    dp->nlink++;  // for ".."
    80005780:	04a4d783          	lhu	a5,74(s1)
    80005784:	2785                	addiw	a5,a5,1
    80005786:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000578a:	8526                	mv	a0,s1
    8000578c:	818fe0ef          	jal	800037a4 <iupdate>
    80005790:	b74d                	j	80005732 <create+0xbc>
  ip->nlink = 0;
    80005792:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005796:	854a                	mv	a0,s2
    80005798:	80cfe0ef          	jal	800037a4 <iupdate>
  iunlockput(ip);
    8000579c:	854a                	mv	a0,s2
    8000579e:	ac6fe0ef          	jal	80003a64 <iunlockput>
  iunlockput(dp);
    800057a2:	8526                	mv	a0,s1
    800057a4:	ac0fe0ef          	jal	80003a64 <iunlockput>
  return 0;
    800057a8:	b73d                	j	800056d6 <create+0x60>
    return 0;
    800057aa:	89aa                	mv	s3,a0
    800057ac:	b72d                	j	800056d6 <create+0x60>

00000000800057ae <sys_open>:

uint64
sys_open(void)
{
    800057ae:	7131                	addi	sp,sp,-192
    800057b0:	fd06                	sd	ra,184(sp)
    800057b2:	f922                	sd	s0,176(sp)
    800057b4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800057b6:	f4c40593          	addi	a1,s0,-180
    800057ba:	4505                	li	a0,1
    800057bc:	eaefd0ef          	jal	80002e6a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057c0:	08000613          	li	a2,128
    800057c4:	f5040593          	addi	a1,s0,-176
    800057c8:	4501                	li	a0,0
    800057ca:	ed8fd0ef          	jal	80002ea2 <argstr>
    800057ce:	87aa                	mv	a5,a0
    return -1;
    800057d0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800057d2:	0a07c363          	bltz	a5,80005878 <sys_open+0xca>
    800057d6:	f526                	sd	s1,168(sp)

  begin_op();
    800057d8:	a8dfe0ef          	jal	80004264 <begin_op>

  if(omode & O_CREATE){
    800057dc:	f4c42783          	lw	a5,-180(s0)
    800057e0:	2007f793          	andi	a5,a5,512
    800057e4:	c3dd                	beqz	a5,8000588a <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800057e6:	4681                	li	a3,0
    800057e8:	4601                	li	a2,0
    800057ea:	4589                	li	a1,2
    800057ec:	f5040513          	addi	a0,s0,-176
    800057f0:	e87ff0ef          	jal	80005676 <create>
    800057f4:	84aa                	mv	s1,a0
    if(ip == 0){
    800057f6:	c549                	beqz	a0,80005880 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800057f8:	04449703          	lh	a4,68(s1)
    800057fc:	478d                	li	a5,3
    800057fe:	00f71763          	bne	a4,a5,8000580c <sys_open+0x5e>
    80005802:	0464d703          	lhu	a4,70(s1)
    80005806:	47a5                	li	a5,9
    80005808:	0ae7ee63          	bltu	a5,a4,800058c4 <sys_open+0x116>
    8000580c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000580e:	dd7fe0ef          	jal	800045e4 <filealloc>
    80005812:	892a                	mv	s2,a0
    80005814:	c561                	beqz	a0,800058dc <sys_open+0x12e>
    80005816:	ed4e                	sd	s3,152(sp)
    80005818:	a47ff0ef          	jal	8000525e <fdalloc>
    8000581c:	89aa                	mv	s3,a0
    8000581e:	0a054b63          	bltz	a0,800058d4 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005822:	04449703          	lh	a4,68(s1)
    80005826:	478d                	li	a5,3
    80005828:	0cf70363          	beq	a4,a5,800058ee <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000582c:	4789                	li	a5,2
    8000582e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005832:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005836:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000583a:	f4c42783          	lw	a5,-180(s0)
    8000583e:	0017f713          	andi	a4,a5,1
    80005842:	00174713          	xori	a4,a4,1
    80005846:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000584a:	0037f713          	andi	a4,a5,3
    8000584e:	00e03733          	snez	a4,a4
    80005852:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005856:	4007f793          	andi	a5,a5,1024
    8000585a:	c791                	beqz	a5,80005866 <sys_open+0xb8>
    8000585c:	04449703          	lh	a4,68(s1)
    80005860:	4789                	li	a5,2
    80005862:	08f70d63          	beq	a4,a5,800058fc <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005866:	8526                	mv	a0,s1
    80005868:	89efe0ef          	jal	80003906 <iunlock>
  end_op();
    8000586c:	a69fe0ef          	jal	800042d4 <end_op>

  return fd;
    80005870:	854e                	mv	a0,s3
    80005872:	74aa                	ld	s1,168(sp)
    80005874:	790a                	ld	s2,160(sp)
    80005876:	69ea                	ld	s3,152(sp)
}
    80005878:	70ea                	ld	ra,184(sp)
    8000587a:	744a                	ld	s0,176(sp)
    8000587c:	6129                	addi	sp,sp,192
    8000587e:	8082                	ret
      end_op();
    80005880:	a55fe0ef          	jal	800042d4 <end_op>
      return -1;
    80005884:	557d                	li	a0,-1
    80005886:	74aa                	ld	s1,168(sp)
    80005888:	bfc5                	j	80005878 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000588a:	f5040513          	addi	a0,s0,-176
    8000588e:	ff8fe0ef          	jal	80004086 <namei>
    80005892:	84aa                	mv	s1,a0
    80005894:	c11d                	beqz	a0,800058ba <sys_open+0x10c>
    ilock(ip);
    80005896:	fc3fd0ef          	jal	80003858 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000589a:	04449703          	lh	a4,68(s1)
    8000589e:	4785                	li	a5,1
    800058a0:	f4f71ce3          	bne	a4,a5,800057f8 <sys_open+0x4a>
    800058a4:	f4c42783          	lw	a5,-180(s0)
    800058a8:	d3b5                	beqz	a5,8000580c <sys_open+0x5e>
      iunlockput(ip);
    800058aa:	8526                	mv	a0,s1
    800058ac:	9b8fe0ef          	jal	80003a64 <iunlockput>
      end_op();
    800058b0:	a25fe0ef          	jal	800042d4 <end_op>
      return -1;
    800058b4:	557d                	li	a0,-1
    800058b6:	74aa                	ld	s1,168(sp)
    800058b8:	b7c1                	j	80005878 <sys_open+0xca>
      end_op();
    800058ba:	a1bfe0ef          	jal	800042d4 <end_op>
      return -1;
    800058be:	557d                	li	a0,-1
    800058c0:	74aa                	ld	s1,168(sp)
    800058c2:	bf5d                	j	80005878 <sys_open+0xca>
    iunlockput(ip);
    800058c4:	8526                	mv	a0,s1
    800058c6:	99efe0ef          	jal	80003a64 <iunlockput>
    end_op();
    800058ca:	a0bfe0ef          	jal	800042d4 <end_op>
    return -1;
    800058ce:	557d                	li	a0,-1
    800058d0:	74aa                	ld	s1,168(sp)
    800058d2:	b75d                	j	80005878 <sys_open+0xca>
      fileclose(f);
    800058d4:	854a                	mv	a0,s2
    800058d6:	db3fe0ef          	jal	80004688 <fileclose>
    800058da:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800058dc:	8526                	mv	a0,s1
    800058de:	986fe0ef          	jal	80003a64 <iunlockput>
    end_op();
    800058e2:	9f3fe0ef          	jal	800042d4 <end_op>
    return -1;
    800058e6:	557d                	li	a0,-1
    800058e8:	74aa                	ld	s1,168(sp)
    800058ea:	790a                	ld	s2,160(sp)
    800058ec:	b771                	j	80005878 <sys_open+0xca>
    f->type = FD_DEVICE;
    800058ee:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800058f2:	04649783          	lh	a5,70(s1)
    800058f6:	02f91223          	sh	a5,36(s2)
    800058fa:	bf35                	j	80005836 <sys_open+0x88>
    itrunc(ip);
    800058fc:	8526                	mv	a0,s1
    800058fe:	848fe0ef          	jal	80003946 <itrunc>
    80005902:	b795                	j	80005866 <sys_open+0xb8>

0000000080005904 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005904:	7175                	addi	sp,sp,-144
    80005906:	e506                	sd	ra,136(sp)
    80005908:	e122                	sd	s0,128(sp)
    8000590a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000590c:	959fe0ef          	jal	80004264 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005910:	08000613          	li	a2,128
    80005914:	f7040593          	addi	a1,s0,-144
    80005918:	4501                	li	a0,0
    8000591a:	d88fd0ef          	jal	80002ea2 <argstr>
    8000591e:	02054363          	bltz	a0,80005944 <sys_mkdir+0x40>
    80005922:	4681                	li	a3,0
    80005924:	4601                	li	a2,0
    80005926:	4585                	li	a1,1
    80005928:	f7040513          	addi	a0,s0,-144
    8000592c:	d4bff0ef          	jal	80005676 <create>
    80005930:	c911                	beqz	a0,80005944 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005932:	932fe0ef          	jal	80003a64 <iunlockput>
  end_op();
    80005936:	99ffe0ef          	jal	800042d4 <end_op>
  return 0;
    8000593a:	4501                	li	a0,0
}
    8000593c:	60aa                	ld	ra,136(sp)
    8000593e:	640a                	ld	s0,128(sp)
    80005940:	6149                	addi	sp,sp,144
    80005942:	8082                	ret
    end_op();
    80005944:	991fe0ef          	jal	800042d4 <end_op>
    return -1;
    80005948:	557d                	li	a0,-1
    8000594a:	bfcd                	j	8000593c <sys_mkdir+0x38>

000000008000594c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000594c:	7135                	addi	sp,sp,-160
    8000594e:	ed06                	sd	ra,152(sp)
    80005950:	e922                	sd	s0,144(sp)
    80005952:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005954:	911fe0ef          	jal	80004264 <begin_op>
  argint(1, &major);
    80005958:	f6c40593          	addi	a1,s0,-148
    8000595c:	4505                	li	a0,1
    8000595e:	d0cfd0ef          	jal	80002e6a <argint>
  argint(2, &minor);
    80005962:	f6840593          	addi	a1,s0,-152
    80005966:	4509                	li	a0,2
    80005968:	d02fd0ef          	jal	80002e6a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000596c:	08000613          	li	a2,128
    80005970:	f7040593          	addi	a1,s0,-144
    80005974:	4501                	li	a0,0
    80005976:	d2cfd0ef          	jal	80002ea2 <argstr>
    8000597a:	02054563          	bltz	a0,800059a4 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000597e:	f6841683          	lh	a3,-152(s0)
    80005982:	f6c41603          	lh	a2,-148(s0)
    80005986:	458d                	li	a1,3
    80005988:	f7040513          	addi	a0,s0,-144
    8000598c:	cebff0ef          	jal	80005676 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005990:	c911                	beqz	a0,800059a4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005992:	8d2fe0ef          	jal	80003a64 <iunlockput>
  end_op();
    80005996:	93ffe0ef          	jal	800042d4 <end_op>
  return 0;
    8000599a:	4501                	li	a0,0
}
    8000599c:	60ea                	ld	ra,152(sp)
    8000599e:	644a                	ld	s0,144(sp)
    800059a0:	610d                	addi	sp,sp,160
    800059a2:	8082                	ret
    end_op();
    800059a4:	931fe0ef          	jal	800042d4 <end_op>
    return -1;
    800059a8:	557d                	li	a0,-1
    800059aa:	bfcd                	j	8000599c <sys_mknod+0x50>

00000000800059ac <sys_chdir>:

uint64
sys_chdir(void)
{
    800059ac:	7135                	addi	sp,sp,-160
    800059ae:	ed06                	sd	ra,152(sp)
    800059b0:	e922                	sd	s0,144(sp)
    800059b2:	e14a                	sd	s2,128(sp)
    800059b4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800059b6:	9e4fc0ef          	jal	80001b9a <myproc>
    800059ba:	892a                	mv	s2,a0
  
  begin_op();
    800059bc:	8a9fe0ef          	jal	80004264 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800059c0:	08000613          	li	a2,128
    800059c4:	f6040593          	addi	a1,s0,-160
    800059c8:	4501                	li	a0,0
    800059ca:	cd8fd0ef          	jal	80002ea2 <argstr>
    800059ce:	04054363          	bltz	a0,80005a14 <sys_chdir+0x68>
    800059d2:	e526                	sd	s1,136(sp)
    800059d4:	f6040513          	addi	a0,s0,-160
    800059d8:	eaefe0ef          	jal	80004086 <namei>
    800059dc:	84aa                	mv	s1,a0
    800059de:	c915                	beqz	a0,80005a12 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800059e0:	e79fd0ef          	jal	80003858 <ilock>
  if(ip->type != T_DIR){
    800059e4:	04449703          	lh	a4,68(s1)
    800059e8:	4785                	li	a5,1
    800059ea:	02f71963          	bne	a4,a5,80005a1c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059ee:	8526                	mv	a0,s1
    800059f0:	f17fd0ef          	jal	80003906 <iunlock>
  iput(p->cwd);
    800059f4:	15093503          	ld	a0,336(s2)
    800059f8:	fe3fd0ef          	jal	800039da <iput>
  end_op();
    800059fc:	8d9fe0ef          	jal	800042d4 <end_op>
  p->cwd = ip;
    80005a00:	14993823          	sd	s1,336(s2)
  return 0;
    80005a04:	4501                	li	a0,0
    80005a06:	64aa                	ld	s1,136(sp)
}
    80005a08:	60ea                	ld	ra,152(sp)
    80005a0a:	644a                	ld	s0,144(sp)
    80005a0c:	690a                	ld	s2,128(sp)
    80005a0e:	610d                	addi	sp,sp,160
    80005a10:	8082                	ret
    80005a12:	64aa                	ld	s1,136(sp)
    end_op();
    80005a14:	8c1fe0ef          	jal	800042d4 <end_op>
    return -1;
    80005a18:	557d                	li	a0,-1
    80005a1a:	b7fd                	j	80005a08 <sys_chdir+0x5c>
    iunlockput(ip);
    80005a1c:	8526                	mv	a0,s1
    80005a1e:	846fe0ef          	jal	80003a64 <iunlockput>
    end_op();
    80005a22:	8b3fe0ef          	jal	800042d4 <end_op>
    return -1;
    80005a26:	557d                	li	a0,-1
    80005a28:	64aa                	ld	s1,136(sp)
    80005a2a:	bff9                	j	80005a08 <sys_chdir+0x5c>

0000000080005a2c <sys_exec>:

uint64
sys_exec(void)
{
    80005a2c:	7105                	addi	sp,sp,-480
    80005a2e:	ef86                	sd	ra,472(sp)
    80005a30:	eba2                	sd	s0,464(sp)
    80005a32:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005a34:	e2840593          	addi	a1,s0,-472
    80005a38:	4505                	li	a0,1
    80005a3a:	c4cfd0ef          	jal	80002e86 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005a3e:	08000613          	li	a2,128
    80005a42:	f3040593          	addi	a1,s0,-208
    80005a46:	4501                	li	a0,0
    80005a48:	c5afd0ef          	jal	80002ea2 <argstr>
    80005a4c:	87aa                	mv	a5,a0
    return -1;
    80005a4e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005a50:	0e07c063          	bltz	a5,80005b30 <sys_exec+0x104>
    80005a54:	e7a6                	sd	s1,456(sp)
    80005a56:	e3ca                	sd	s2,448(sp)
    80005a58:	ff4e                	sd	s3,440(sp)
    80005a5a:	fb52                	sd	s4,432(sp)
    80005a5c:	f756                	sd	s5,424(sp)
    80005a5e:	f35a                	sd	s6,416(sp)
    80005a60:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005a62:	e3040a13          	addi	s4,s0,-464
    80005a66:	10000613          	li	a2,256
    80005a6a:	4581                	li	a1,0
    80005a6c:	8552                	mv	a0,s4
    80005a6e:	a8afb0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a72:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005a74:	89d2                	mv	s3,s4
    80005a76:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a78:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a7c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005a7e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a82:	00391513          	slli	a0,s2,0x3
    80005a86:	85d6                	mv	a1,s5
    80005a88:	e2843783          	ld	a5,-472(s0)
    80005a8c:	953e                	add	a0,a0,a5
    80005a8e:	b52fd0ef          	jal	80002de0 <fetchaddr>
    80005a92:	02054663          	bltz	a0,80005abe <sys_exec+0x92>
    if(uarg == 0){
    80005a96:	e2043783          	ld	a5,-480(s0)
    80005a9a:	c7a1                	beqz	a5,80005ae2 <sys_exec+0xb6>
    argv[i] = kalloc();
    80005a9c:	8a8fb0ef          	jal	80000b44 <kalloc>
    80005aa0:	85aa                	mv	a1,a0
    80005aa2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005aa6:	cd01                	beqz	a0,80005abe <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005aa8:	865a                	mv	a2,s6
    80005aaa:	e2043503          	ld	a0,-480(s0)
    80005aae:	b7cfd0ef          	jal	80002e2a <fetchstr>
    80005ab2:	00054663          	bltz	a0,80005abe <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80005ab6:	0905                	addi	s2,s2,1
    80005ab8:	09a1                	addi	s3,s3,8
    80005aba:	fd7914e3          	bne	s2,s7,80005a82 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005abe:	100a0a13          	addi	s4,s4,256
    80005ac2:	6088                	ld	a0,0(s1)
    80005ac4:	cd31                	beqz	a0,80005b20 <sys_exec+0xf4>
    kfree(argv[i]);
    80005ac6:	f97fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aca:	04a1                	addi	s1,s1,8
    80005acc:	ff449be3          	bne	s1,s4,80005ac2 <sys_exec+0x96>
  return -1;
    80005ad0:	557d                	li	a0,-1
    80005ad2:	64be                	ld	s1,456(sp)
    80005ad4:	691e                	ld	s2,448(sp)
    80005ad6:	79fa                	ld	s3,440(sp)
    80005ad8:	7a5a                	ld	s4,432(sp)
    80005ada:	7aba                	ld	s5,424(sp)
    80005adc:	7b1a                	ld	s6,416(sp)
    80005ade:	6bfa                	ld	s7,408(sp)
    80005ae0:	a881                	j	80005b30 <sys_exec+0x104>
      argv[i] = 0;
    80005ae2:	0009079b          	sext.w	a5,s2
    80005ae6:	e3040593          	addi	a1,s0,-464
    80005aea:	078e                	slli	a5,a5,0x3
    80005aec:	97ae                	add	a5,a5,a1
    80005aee:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005af2:	f3040513          	addi	a0,s0,-208
    80005af6:	a58ff0ef          	jal	80004d4e <kexec>
    80005afa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005afc:	100a0a13          	addi	s4,s4,256
    80005b00:	6088                	ld	a0,0(s1)
    80005b02:	c511                	beqz	a0,80005b0e <sys_exec+0xe2>
    kfree(argv[i]);
    80005b04:	f59fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b08:	04a1                	addi	s1,s1,8
    80005b0a:	ff449be3          	bne	s1,s4,80005b00 <sys_exec+0xd4>
  return ret;
    80005b0e:	854a                	mv	a0,s2
    80005b10:	64be                	ld	s1,456(sp)
    80005b12:	691e                	ld	s2,448(sp)
    80005b14:	79fa                	ld	s3,440(sp)
    80005b16:	7a5a                	ld	s4,432(sp)
    80005b18:	7aba                	ld	s5,424(sp)
    80005b1a:	7b1a                	ld	s6,416(sp)
    80005b1c:	6bfa                	ld	s7,408(sp)
    80005b1e:	a809                	j	80005b30 <sys_exec+0x104>
  return -1;
    80005b20:	557d                	li	a0,-1
    80005b22:	64be                	ld	s1,456(sp)
    80005b24:	691e                	ld	s2,448(sp)
    80005b26:	79fa                	ld	s3,440(sp)
    80005b28:	7a5a                	ld	s4,432(sp)
    80005b2a:	7aba                	ld	s5,424(sp)
    80005b2c:	7b1a                	ld	s6,416(sp)
    80005b2e:	6bfa                	ld	s7,408(sp)
}
    80005b30:	60fe                	ld	ra,472(sp)
    80005b32:	645e                	ld	s0,464(sp)
    80005b34:	613d                	addi	sp,sp,480
    80005b36:	8082                	ret

0000000080005b38 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b38:	7139                	addi	sp,sp,-64
    80005b3a:	fc06                	sd	ra,56(sp)
    80005b3c:	f822                	sd	s0,48(sp)
    80005b3e:	f426                	sd	s1,40(sp)
    80005b40:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b42:	858fc0ef          	jal	80001b9a <myproc>
    80005b46:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005b48:	fd840593          	addi	a1,s0,-40
    80005b4c:	4501                	li	a0,0
    80005b4e:	b38fd0ef          	jal	80002e86 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005b52:	fc840593          	addi	a1,s0,-56
    80005b56:	fd040513          	addi	a0,s0,-48
    80005b5a:	e4bfe0ef          	jal	800049a4 <pipealloc>
    return -1;
    80005b5e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b60:	0a054763          	bltz	a0,80005c0e <sys_pipe+0xd6>
  fd0 = -1;
    80005b64:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b68:	fd043503          	ld	a0,-48(s0)
    80005b6c:	ef2ff0ef          	jal	8000525e <fdalloc>
    80005b70:	fca42223          	sw	a0,-60(s0)
    80005b74:	08054463          	bltz	a0,80005bfc <sys_pipe+0xc4>
    80005b78:	fc843503          	ld	a0,-56(s0)
    80005b7c:	ee2ff0ef          	jal	8000525e <fdalloc>
    80005b80:	fca42023          	sw	a0,-64(s0)
    80005b84:	06054263          	bltz	a0,80005be8 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b88:	4691                	li	a3,4
    80005b8a:	fc440613          	addi	a2,s0,-60
    80005b8e:	fd843583          	ld	a1,-40(s0)
    80005b92:	68a8                	ld	a0,80(s1)
    80005b94:	c21fb0ef          	jal	800017b4 <copyout>
    80005b98:	00054e63          	bltz	a0,80005bb4 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b9c:	4691                	li	a3,4
    80005b9e:	fc040613          	addi	a2,s0,-64
    80005ba2:	fd843583          	ld	a1,-40(s0)
    80005ba6:	95b6                	add	a1,a1,a3
    80005ba8:	68a8                	ld	a0,80(s1)
    80005baa:	c0bfb0ef          	jal	800017b4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005bae:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bb0:	04055f63          	bgez	a0,80005c0e <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80005bb4:	fc442783          	lw	a5,-60(s0)
    80005bb8:	078e                	slli	a5,a5,0x3
    80005bba:	0d078793          	addi	a5,a5,208
    80005bbe:	97a6                	add	a5,a5,s1
    80005bc0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005bc4:	fc042783          	lw	a5,-64(s0)
    80005bc8:	078e                	slli	a5,a5,0x3
    80005bca:	0d078793          	addi	a5,a5,208
    80005bce:	97a6                	add	a5,a5,s1
    80005bd0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005bd4:	fd043503          	ld	a0,-48(s0)
    80005bd8:	ab1fe0ef          	jal	80004688 <fileclose>
    fileclose(wf);
    80005bdc:	fc843503          	ld	a0,-56(s0)
    80005be0:	aa9fe0ef          	jal	80004688 <fileclose>
    return -1;
    80005be4:	57fd                	li	a5,-1
    80005be6:	a025                	j	80005c0e <sys_pipe+0xd6>
    if(fd0 >= 0)
    80005be8:	fc442783          	lw	a5,-60(s0)
    80005bec:	0007c863          	bltz	a5,80005bfc <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005bf0:	078e                	slli	a5,a5,0x3
    80005bf2:	0d078793          	addi	a5,a5,208
    80005bf6:	97a6                	add	a5,a5,s1
    80005bf8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005bfc:	fd043503          	ld	a0,-48(s0)
    80005c00:	a89fe0ef          	jal	80004688 <fileclose>
    fileclose(wf);
    80005c04:	fc843503          	ld	a0,-56(s0)
    80005c08:	a81fe0ef          	jal	80004688 <fileclose>
    return -1;
    80005c0c:	57fd                	li	a5,-1
}
    80005c0e:	853e                	mv	a0,a5
    80005c10:	70e2                	ld	ra,56(sp)
    80005c12:	7442                	ld	s0,48(sp)
    80005c14:	74a2                	ld	s1,40(sp)
    80005c16:	6121                	addi	sp,sp,64
    80005c18:	8082                	ret
    80005c1a:	0000                	unimp
    80005c1c:	0000                	unimp
	...

0000000080005c20 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005c20:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005c22:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005c24:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005c26:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005c28:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005c2a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005c2c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005c2e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005c30:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005c32:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005c34:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005c36:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005c38:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005c3a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005c3c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005c3e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005c40:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005c42:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005c44:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005c46:	8a8fd0ef          	jal	80002cee <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005c4a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005c4c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005c4e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005c50:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005c52:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005c54:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005c56:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005c58:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005c5a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005c5c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005c5e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005c60:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005c62:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005c64:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005c66:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005c68:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005c6a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005c6c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005c6e:	10200073          	sret
    80005c72:	00000013          	nop
    80005c76:	00000013          	nop
    80005c7a:	00000013          	nop

0000000080005c7e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c7e:	1141                	addi	sp,sp,-16
    80005c80:	e406                	sd	ra,8(sp)
    80005c82:	e022                	sd	s0,0(sp)
    80005c84:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c86:	0c000737          	lui	a4,0xc000
    80005c8a:	4785                	li	a5,1
    80005c8c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c8e:	c35c                	sw	a5,4(a4)
}
    80005c90:	60a2                	ld	ra,8(sp)
    80005c92:	6402                	ld	s0,0(sp)
    80005c94:	0141                	addi	sp,sp,16
    80005c96:	8082                	ret

0000000080005c98 <plicinithart>:

void
plicinithart(void)
{
    80005c98:	1141                	addi	sp,sp,-16
    80005c9a:	e406                	sd	ra,8(sp)
    80005c9c:	e022                	sd	s0,0(sp)
    80005c9e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005ca0:	ec7fb0ef          	jal	80001b66 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005ca4:	0085171b          	slliw	a4,a0,0x8
    80005ca8:	0c0027b7          	lui	a5,0xc002
    80005cac:	97ba                	add	a5,a5,a4
    80005cae:	40200713          	li	a4,1026
    80005cb2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005cb6:	00d5151b          	slliw	a0,a0,0xd
    80005cba:	0c2017b7          	lui	a5,0xc201
    80005cbe:	97aa                	add	a5,a5,a0
    80005cc0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005cc4:	60a2                	ld	ra,8(sp)
    80005cc6:	6402                	ld	s0,0(sp)
    80005cc8:	0141                	addi	sp,sp,16
    80005cca:	8082                	ret

0000000080005ccc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005ccc:	1141                	addi	sp,sp,-16
    80005cce:	e406                	sd	ra,8(sp)
    80005cd0:	e022                	sd	s0,0(sp)
    80005cd2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cd4:	e93fb0ef          	jal	80001b66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005cd8:	00d5151b          	slliw	a0,a0,0xd
    80005cdc:	0c2017b7          	lui	a5,0xc201
    80005ce0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005ce2:	43c8                	lw	a0,4(a5)
    80005ce4:	60a2                	ld	ra,8(sp)
    80005ce6:	6402                	ld	s0,0(sp)
    80005ce8:	0141                	addi	sp,sp,16
    80005cea:	8082                	ret

0000000080005cec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005cec:	1101                	addi	sp,sp,-32
    80005cee:	ec06                	sd	ra,24(sp)
    80005cf0:	e822                	sd	s0,16(sp)
    80005cf2:	e426                	sd	s1,8(sp)
    80005cf4:	1000                	addi	s0,sp,32
    80005cf6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005cf8:	e6ffb0ef          	jal	80001b66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005cfc:	00d5179b          	slliw	a5,a0,0xd
    80005d00:	0c201737          	lui	a4,0xc201
    80005d04:	97ba                	add	a5,a5,a4
    80005d06:	c3c4                	sw	s1,4(a5)
}
    80005d08:	60e2                	ld	ra,24(sp)
    80005d0a:	6442                	ld	s0,16(sp)
    80005d0c:	64a2                	ld	s1,8(sp)
    80005d0e:	6105                	addi	sp,sp,32
    80005d10:	8082                	ret

0000000080005d12 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d12:	1141                	addi	sp,sp,-16
    80005d14:	e406                	sd	ra,8(sp)
    80005d16:	e022                	sd	s0,0(sp)
    80005d18:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d1a:	479d                	li	a5,7
    80005d1c:	04a7ca63          	blt	a5,a0,80005d70 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005d20:	00045797          	auipc	a5,0x45
    80005d24:	cd878793          	addi	a5,a5,-808 # 8004a9f8 <disk>
    80005d28:	97aa                	add	a5,a5,a0
    80005d2a:	0187c783          	lbu	a5,24(a5)
    80005d2e:	e7b9                	bnez	a5,80005d7c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d30:	00451693          	slli	a3,a0,0x4
    80005d34:	00045797          	auipc	a5,0x45
    80005d38:	cc478793          	addi	a5,a5,-828 # 8004a9f8 <disk>
    80005d3c:	6398                	ld	a4,0(a5)
    80005d3e:	9736                	add	a4,a4,a3
    80005d40:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005d44:	6398                	ld	a4,0(a5)
    80005d46:	9736                	add	a4,a4,a3
    80005d48:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005d4c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005d50:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005d54:	97aa                	add	a5,a5,a0
    80005d56:	4705                	li	a4,1
    80005d58:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005d5c:	00045517          	auipc	a0,0x45
    80005d60:	cb450513          	addi	a0,a0,-844 # 8004aa10 <disk+0x18>
    80005d64:	d30fc0ef          	jal	80002294 <wakeup>
}
    80005d68:	60a2                	ld	ra,8(sp)
    80005d6a:	6402                	ld	s0,0(sp)
    80005d6c:	0141                	addi	sp,sp,16
    80005d6e:	8082                	ret
    panic("free_desc 1");
    80005d70:	00003517          	auipc	a0,0x3
    80005d74:	b0850513          	addi	a0,a0,-1272 # 80008878 <etext+0x878>
    80005d78:	aadfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    80005d7c:	00003517          	auipc	a0,0x3
    80005d80:	b0c50513          	addi	a0,a0,-1268 # 80008888 <etext+0x888>
    80005d84:	aa1fa0ef          	jal	80000824 <panic>

0000000080005d88 <virtio_disk_init>:
{
    80005d88:	1101                	addi	sp,sp,-32
    80005d8a:	ec06                	sd	ra,24(sp)
    80005d8c:	e822                	sd	s0,16(sp)
    80005d8e:	e426                	sd	s1,8(sp)
    80005d90:	e04a                	sd	s2,0(sp)
    80005d92:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005d94:	00003597          	auipc	a1,0x3
    80005d98:	b0458593          	addi	a1,a1,-1276 # 80008898 <etext+0x898>
    80005d9c:	00045517          	auipc	a0,0x45
    80005da0:	d8450513          	addi	a0,a0,-636 # 8004ab20 <disk+0x128>
    80005da4:	dfbfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005da8:	100017b7          	lui	a5,0x10001
    80005dac:	4398                	lw	a4,0(a5)
    80005dae:	2701                	sext.w	a4,a4
    80005db0:	747277b7          	lui	a5,0x74727
    80005db4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005db8:	14f71863          	bne	a4,a5,80005f08 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dbc:	100017b7          	lui	a5,0x10001
    80005dc0:	43dc                	lw	a5,4(a5)
    80005dc2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dc4:	4709                	li	a4,2
    80005dc6:	14e79163          	bne	a5,a4,80005f08 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dca:	100017b7          	lui	a5,0x10001
    80005dce:	479c                	lw	a5,8(a5)
    80005dd0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dd2:	12e79b63          	bne	a5,a4,80005f08 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dd6:	100017b7          	lui	a5,0x10001
    80005dda:	47d8                	lw	a4,12(a5)
    80005ddc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dde:	554d47b7          	lui	a5,0x554d4
    80005de2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005de6:	12f71163          	bne	a4,a5,80005f08 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dea:	100017b7          	lui	a5,0x10001
    80005dee:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df2:	4705                	li	a4,1
    80005df4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df6:	470d                	li	a4,3
    80005df8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005dfa:	10001737          	lui	a4,0x10001
    80005dfe:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e00:	c7ffe6b7          	lui	a3,0xc7ffe
    80005e04:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fb3c27>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e08:	8f75                	and	a4,a4,a3
    80005e0a:	100016b7          	lui	a3,0x10001
    80005e0e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e10:	472d                	li	a4,11
    80005e12:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e14:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005e18:	439c                	lw	a5,0(a5)
    80005e1a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e1e:	8ba1                	andi	a5,a5,8
    80005e20:	0e078a63          	beqz	a5,80005f14 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e24:	100017b7          	lui	a5,0x10001
    80005e28:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005e2c:	43fc                	lw	a5,68(a5)
    80005e2e:	2781                	sext.w	a5,a5
    80005e30:	0e079863          	bnez	a5,80005f20 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e34:	100017b7          	lui	a5,0x10001
    80005e38:	5bdc                	lw	a5,52(a5)
    80005e3a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e3c:	0e078863          	beqz	a5,80005f2c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005e40:	471d                	li	a4,7
    80005e42:	0ef77b63          	bgeu	a4,a5,80005f38 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005e46:	cfffa0ef          	jal	80000b44 <kalloc>
    80005e4a:	00045497          	auipc	s1,0x45
    80005e4e:	bae48493          	addi	s1,s1,-1106 # 8004a9f8 <disk>
    80005e52:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005e54:	cf1fa0ef          	jal	80000b44 <kalloc>
    80005e58:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005e5a:	cebfa0ef          	jal	80000b44 <kalloc>
    80005e5e:	87aa                	mv	a5,a0
    80005e60:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005e62:	6088                	ld	a0,0(s1)
    80005e64:	0e050063          	beqz	a0,80005f44 <virtio_disk_init+0x1bc>
    80005e68:	00045717          	auipc	a4,0x45
    80005e6c:	b9873703          	ld	a4,-1128(a4) # 8004aa00 <disk+0x8>
    80005e70:	cb71                	beqz	a4,80005f44 <virtio_disk_init+0x1bc>
    80005e72:	cbe9                	beqz	a5,80005f44 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005e74:	6605                	lui	a2,0x1
    80005e76:	4581                	li	a1,0
    80005e78:	e81fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005e7c:	00045497          	auipc	s1,0x45
    80005e80:	b7c48493          	addi	s1,s1,-1156 # 8004a9f8 <disk>
    80005e84:	6605                	lui	a2,0x1
    80005e86:	4581                	li	a1,0
    80005e88:	6488                	ld	a0,8(s1)
    80005e8a:	e6ffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    80005e8e:	6605                	lui	a2,0x1
    80005e90:	4581                	li	a1,0
    80005e92:	6888                	ld	a0,16(s1)
    80005e94:	e65fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e98:	100017b7          	lui	a5,0x10001
    80005e9c:	4721                	li	a4,8
    80005e9e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005ea0:	4098                	lw	a4,0(s1)
    80005ea2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005ea6:	40d8                	lw	a4,4(s1)
    80005ea8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005eac:	649c                	ld	a5,8(s1)
    80005eae:	0007869b          	sext.w	a3,a5
    80005eb2:	10001737          	lui	a4,0x10001
    80005eb6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005eba:	9781                	srai	a5,a5,0x20
    80005ebc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005ec0:	689c                	ld	a5,16(s1)
    80005ec2:	0007869b          	sext.w	a3,a5
    80005ec6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005eca:	9781                	srai	a5,a5,0x20
    80005ecc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005ed0:	4785                	li	a5,1
    80005ed2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005ed4:	00f48c23          	sb	a5,24(s1)
    80005ed8:	00f48ca3          	sb	a5,25(s1)
    80005edc:	00f48d23          	sb	a5,26(s1)
    80005ee0:	00f48da3          	sb	a5,27(s1)
    80005ee4:	00f48e23          	sb	a5,28(s1)
    80005ee8:	00f48ea3          	sb	a5,29(s1)
    80005eec:	00f48f23          	sb	a5,30(s1)
    80005ef0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005ef4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005ef8:	07272823          	sw	s2,112(a4)
}
    80005efc:	60e2                	ld	ra,24(sp)
    80005efe:	6442                	ld	s0,16(sp)
    80005f00:	64a2                	ld	s1,8(sp)
    80005f02:	6902                	ld	s2,0(sp)
    80005f04:	6105                	addi	sp,sp,32
    80005f06:	8082                	ret
    panic("could not find virtio disk");
    80005f08:	00003517          	auipc	a0,0x3
    80005f0c:	9a050513          	addi	a0,a0,-1632 # 800088a8 <etext+0x8a8>
    80005f10:	915fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005f14:	00003517          	auipc	a0,0x3
    80005f18:	9b450513          	addi	a0,a0,-1612 # 800088c8 <etext+0x8c8>
    80005f1c:	909fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80005f20:	00003517          	auipc	a0,0x3
    80005f24:	9c850513          	addi	a0,a0,-1592 # 800088e8 <etext+0x8e8>
    80005f28:	8fdfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    80005f2c:	00003517          	auipc	a0,0x3
    80005f30:	9dc50513          	addi	a0,a0,-1572 # 80008908 <etext+0x908>
    80005f34:	8f1fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80005f38:	00003517          	auipc	a0,0x3
    80005f3c:	9f050513          	addi	a0,a0,-1552 # 80008928 <etext+0x928>
    80005f40:	8e5fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80005f44:	00003517          	auipc	a0,0x3
    80005f48:	a0450513          	addi	a0,a0,-1532 # 80008948 <etext+0x948>
    80005f4c:	8d9fa0ef          	jal	80000824 <panic>

0000000080005f50 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f50:	711d                	addi	sp,sp,-96
    80005f52:	ec86                	sd	ra,88(sp)
    80005f54:	e8a2                	sd	s0,80(sp)
    80005f56:	e4a6                	sd	s1,72(sp)
    80005f58:	e0ca                	sd	s2,64(sp)
    80005f5a:	fc4e                	sd	s3,56(sp)
    80005f5c:	f852                	sd	s4,48(sp)
    80005f5e:	f456                	sd	s5,40(sp)
    80005f60:	f05a                	sd	s6,32(sp)
    80005f62:	ec5e                	sd	s7,24(sp)
    80005f64:	e862                	sd	s8,16(sp)
    80005f66:	1080                	addi	s0,sp,96
    80005f68:	89aa                	mv	s3,a0
    80005f6a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f6c:	00c52b83          	lw	s7,12(a0)
    80005f70:	001b9b9b          	slliw	s7,s7,0x1
    80005f74:	1b82                	slli	s7,s7,0x20
    80005f76:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005f7a:	00045517          	auipc	a0,0x45
    80005f7e:	ba650513          	addi	a0,a0,-1114 # 8004ab20 <disk+0x128>
    80005f82:	ca7fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80005f86:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005f88:	00045a97          	auipc	s5,0x45
    80005f8c:	a70a8a93          	addi	s5,s5,-1424 # 8004a9f8 <disk>
  for(int i = 0; i < 3; i++){
    80005f90:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005f92:	5c7d                	li	s8,-1
    80005f94:	a095                	j	80005ff8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005f96:	00fa8733          	add	a4,s5,a5
    80005f9a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005f9e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005fa0:	0207c563          	bltz	a5,80005fca <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005fa4:	2905                	addiw	s2,s2,1
    80005fa6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005fa8:	05490c63          	beq	s2,s4,80006000 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80005fac:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005fae:	00045717          	auipc	a4,0x45
    80005fb2:	a4a70713          	addi	a4,a4,-1462 # 8004a9f8 <disk>
    80005fb6:	4781                	li	a5,0
    if(disk.free[i]){
    80005fb8:	01874683          	lbu	a3,24(a4)
    80005fbc:	fee9                	bnez	a3,80005f96 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80005fbe:	2785                	addiw	a5,a5,1
    80005fc0:	0705                	addi	a4,a4,1
    80005fc2:	fe979be3          	bne	a5,s1,80005fb8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005fc6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80005fca:	01205d63          	blez	s2,80005fe4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005fce:	fa042503          	lw	a0,-96(s0)
    80005fd2:	d41ff0ef          	jal	80005d12 <free_desc>
      for(int j = 0; j < i; j++)
    80005fd6:	4785                	li	a5,1
    80005fd8:	0127d663          	bge	a5,s2,80005fe4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005fdc:	fa442503          	lw	a0,-92(s0)
    80005fe0:	d33ff0ef          	jal	80005d12 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fe4:	00045597          	auipc	a1,0x45
    80005fe8:	b3c58593          	addi	a1,a1,-1220 # 8004ab20 <disk+0x128>
    80005fec:	00045517          	auipc	a0,0x45
    80005ff0:	a2450513          	addi	a0,a0,-1500 # 8004aa10 <disk+0x18>
    80005ff4:	a54fc0ef          	jal	80002248 <sleep>
  for(int i = 0; i < 3; i++){
    80005ff8:	fa040613          	addi	a2,s0,-96
    80005ffc:	4901                	li	s2,0
    80005ffe:	b77d                	j	80005fac <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006000:	fa042503          	lw	a0,-96(s0)
    80006004:	00451693          	slli	a3,a0,0x4

  if(write)
    80006008:	00045797          	auipc	a5,0x45
    8000600c:	9f078793          	addi	a5,a5,-1552 # 8004a9f8 <disk>
    80006010:	00451713          	slli	a4,a0,0x4
    80006014:	0a070713          	addi	a4,a4,160
    80006018:	973e                	add	a4,a4,a5
    8000601a:	01603633          	snez	a2,s6
    8000601e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006020:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006024:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006028:	6398                	ld	a4,0(a5)
    8000602a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000602c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006030:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006032:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006034:	6390                	ld	a2,0(a5)
    80006036:	00d60833          	add	a6,a2,a3
    8000603a:	4741                	li	a4,16
    8000603c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006040:	4585                	li	a1,1
    80006042:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006046:	fa442703          	lw	a4,-92(s0)
    8000604a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000604e:	0712                	slli	a4,a4,0x4
    80006050:	963a                	add	a2,a2,a4
    80006052:	05898813          	addi	a6,s3,88
    80006056:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000605a:	0007b883          	ld	a7,0(a5)
    8000605e:	9746                	add	a4,a4,a7
    80006060:	40000613          	li	a2,1024
    80006064:	c710                	sw	a2,8(a4)
  if(write)
    80006066:	001b3613          	seqz	a2,s6
    8000606a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000606e:	8e4d                	or	a2,a2,a1
    80006070:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006074:	fa842603          	lw	a2,-88(s0)
    80006078:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000607c:	00451813          	slli	a6,a0,0x4
    80006080:	02080813          	addi	a6,a6,32
    80006084:	983e                	add	a6,a6,a5
    80006086:	577d                	li	a4,-1
    80006088:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000608c:	0612                	slli	a2,a2,0x4
    8000608e:	98b2                	add	a7,a7,a2
    80006090:	03068713          	addi	a4,a3,48
    80006094:	973e                	add	a4,a4,a5
    80006096:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000609a:	6398                	ld	a4,0(a5)
    8000609c:	9732                	add	a4,a4,a2
    8000609e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800060a0:	4689                	li	a3,2
    800060a2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800060a6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800060aa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800060ae:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800060b2:	6794                	ld	a3,8(a5)
    800060b4:	0026d703          	lhu	a4,2(a3)
    800060b8:	8b1d                	andi	a4,a4,7
    800060ba:	0706                	slli	a4,a4,0x1
    800060bc:	96ba                	add	a3,a3,a4
    800060be:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800060c2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800060c6:	6798                	ld	a4,8(a5)
    800060c8:	00275783          	lhu	a5,2(a4)
    800060cc:	2785                	addiw	a5,a5,1
    800060ce:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800060d2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800060d6:	100017b7          	lui	a5,0x10001
    800060da:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800060de:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800060e2:	00045917          	auipc	s2,0x45
    800060e6:	a3e90913          	addi	s2,s2,-1474 # 8004ab20 <disk+0x128>
  while(b->disk == 1) {
    800060ea:	84ae                	mv	s1,a1
    800060ec:	00b79a63          	bne	a5,a1,80006100 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800060f0:	85ca                	mv	a1,s2
    800060f2:	854e                	mv	a0,s3
    800060f4:	954fc0ef          	jal	80002248 <sleep>
  while(b->disk == 1) {
    800060f8:	0049a783          	lw	a5,4(s3)
    800060fc:	fe978ae3          	beq	a5,s1,800060f0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80006100:	fa042903          	lw	s2,-96(s0)
    80006104:	00491713          	slli	a4,s2,0x4
    80006108:	02070713          	addi	a4,a4,32
    8000610c:	00045797          	auipc	a5,0x45
    80006110:	8ec78793          	addi	a5,a5,-1812 # 8004a9f8 <disk>
    80006114:	97ba                	add	a5,a5,a4
    80006116:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000611a:	00045997          	auipc	s3,0x45
    8000611e:	8de98993          	addi	s3,s3,-1826 # 8004a9f8 <disk>
    80006122:	00491713          	slli	a4,s2,0x4
    80006126:	0009b783          	ld	a5,0(s3)
    8000612a:	97ba                	add	a5,a5,a4
    8000612c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006130:	854a                	mv	a0,s2
    80006132:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006136:	bddff0ef          	jal	80005d12 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000613a:	8885                	andi	s1,s1,1
    8000613c:	f0fd                	bnez	s1,80006122 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000613e:	00045517          	auipc	a0,0x45
    80006142:	9e250513          	addi	a0,a0,-1566 # 8004ab20 <disk+0x128>
    80006146:	b77fa0ef          	jal	80000cbc <release>
}
    8000614a:	60e6                	ld	ra,88(sp)
    8000614c:	6446                	ld	s0,80(sp)
    8000614e:	64a6                	ld	s1,72(sp)
    80006150:	6906                	ld	s2,64(sp)
    80006152:	79e2                	ld	s3,56(sp)
    80006154:	7a42                	ld	s4,48(sp)
    80006156:	7aa2                	ld	s5,40(sp)
    80006158:	7b02                	ld	s6,32(sp)
    8000615a:	6be2                	ld	s7,24(sp)
    8000615c:	6c42                	ld	s8,16(sp)
    8000615e:	6125                	addi	sp,sp,96
    80006160:	8082                	ret

0000000080006162 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006162:	1101                	addi	sp,sp,-32
    80006164:	ec06                	sd	ra,24(sp)
    80006166:	e822                	sd	s0,16(sp)
    80006168:	e426                	sd	s1,8(sp)
    8000616a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000616c:	00045497          	auipc	s1,0x45
    80006170:	88c48493          	addi	s1,s1,-1908 # 8004a9f8 <disk>
    80006174:	00045517          	auipc	a0,0x45
    80006178:	9ac50513          	addi	a0,a0,-1620 # 8004ab20 <disk+0x128>
    8000617c:	aadfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006180:	100017b7          	lui	a5,0x10001
    80006184:	53bc                	lw	a5,96(a5)
    80006186:	8b8d                	andi	a5,a5,3
    80006188:	10001737          	lui	a4,0x10001
    8000618c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000618e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006192:	689c                	ld	a5,16(s1)
    80006194:	0204d703          	lhu	a4,32(s1)
    80006198:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000619c:	04f70863          	beq	a4,a5,800061ec <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800061a0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800061a4:	6898                	ld	a4,16(s1)
    800061a6:	0204d783          	lhu	a5,32(s1)
    800061aa:	8b9d                	andi	a5,a5,7
    800061ac:	078e                	slli	a5,a5,0x3
    800061ae:	97ba                	add	a5,a5,a4
    800061b0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800061b2:	00479713          	slli	a4,a5,0x4
    800061b6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    800061ba:	9726                	add	a4,a4,s1
    800061bc:	01074703          	lbu	a4,16(a4)
    800061c0:	e329                	bnez	a4,80006202 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800061c2:	0792                	slli	a5,a5,0x4
    800061c4:	02078793          	addi	a5,a5,32
    800061c8:	97a6                	add	a5,a5,s1
    800061ca:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800061cc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800061d0:	8c4fc0ef          	jal	80002294 <wakeup>

    disk.used_idx += 1;
    800061d4:	0204d783          	lhu	a5,32(s1)
    800061d8:	2785                	addiw	a5,a5,1
    800061da:	17c2                	slli	a5,a5,0x30
    800061dc:	93c1                	srli	a5,a5,0x30
    800061de:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800061e2:	6898                	ld	a4,16(s1)
    800061e4:	00275703          	lhu	a4,2(a4)
    800061e8:	faf71ce3          	bne	a4,a5,800061a0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800061ec:	00045517          	auipc	a0,0x45
    800061f0:	93450513          	addi	a0,a0,-1740 # 8004ab20 <disk+0x128>
    800061f4:	ac9fa0ef          	jal	80000cbc <release>
}
    800061f8:	60e2                	ld	ra,24(sp)
    800061fa:	6442                	ld	s0,16(sp)
    800061fc:	64a2                	ld	s1,8(sp)
    800061fe:	6105                	addi	sp,sp,32
    80006200:	8082                	ret
      panic("virtio_disk_intr status");
    80006202:	00002517          	auipc	a0,0x2
    80006206:	75e50513          	addi	a0,a0,1886 # 80008960 <etext+0x960>
    8000620a:	e1afa0ef          	jal	80000824 <panic>
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
